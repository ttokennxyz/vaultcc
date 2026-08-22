--[[
    cold war - vault.cc
    ui: linorialib (https://github.com/violin-suzutsuki/LinoriaLib)
    esp: dacces on v3rm
]]

--[[
TODO:
look at terrain wallbang
look at viewmodel mods like instant aim, visuals, etc
look at instant reload (reload debug logs are being printed in console rn, so find reload func like that)
]]

local gc = getgc(true)

-- print crash fix
local oldStringMatch
oldStringMatch = hookfunction(string.match, function(...)
    local args = {...}

    if args[2] == "^:%d+:" then
        return nil
    end

    return oldStringMatch(...)
end)

-- load linoria + addons
local LinoriaRepo = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"

Library = loadstring(game:HttpGet(LinoriaRepo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(LinoriaRepo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(LinoriaRepo .. "addons/SaveManager.lua"))()

-- services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local Client = RS.Client
local Tools = Client.Tools
local WeaponControllers = Tools.Weapon.controllers

local RecoilController = require(WeaponControllers.RecoilController)
local AimController = require(WeaponControllers.AimController)
local FiremodeController = require(Tools.Weapon.Muzzle.firemodes.FireController)
local Trajectory = require(RS:WaitForChild("Shared"):WaitForChild("Ballistics"):WaitForChild("Trajectory"))
local Wielder = require(Client:WaitForChild("Character"):WaitForChild("Wielder"))

local cfg = {
    Combat = {
        RecoilMult = 0,
        SpreadMult = 0,
        SilentEnabled = true,
        Ragebot = false,
        RagebotWallbang = false,
        RagebotAutoReload = false,
        RagebotTPAura = false,
        SilentTarget = "Head",
        SilentFov = 100,
        SilentFovEnabled = false,
        SilentExcludeTeammates = true,
        SilentVisibleCheck = false,
        SilentDistanceCheck = false,
        SilentMaxDistance = 500,
        FovDrawEnabled = false,
        FovColor = Color3.fromRGB(255, 255, 255),
        FovThickness = 1,
        AimAnywhere = true,
        InstantADS = true,
        NoADSSlowdown = true,
        AimbotEnabled = false,
        AimbotSmoothness = 1,
        AimbotAimType = "Hold",
        AimbotMethod = "Camera",
        AimbotTarget = "Head",
        ForceAuto = true,
        InstantEquip = false,
        NoBulletDrop = false,
        InstantBullet = false,
        RPGPrediction = true,
        RPGPredictionStrength = 1,
        Snaplines = false,
        SnapTargetColor = Color3.fromRGB(255, 0, 0),
        NoHurtSlowdown = false,
        NoBandageSlowdown = false,
        OmniSprint = false,
        AutoHeal = false,
        InstantHeal = false,
        FastRevive = false,
        CarMods = false,
    }
}

local util = {}
util.target = nil -- cached target part, refreshed every few frames

local WeaponConfigs
local isExplosiveShot = false
local function bulletIsExplosive(bulletConfig)
    return type(bulletConfig) == "table" and bulletConfig.ExplosionSettings ~= nil
end
local function bulletIsRocket(muzzleConfig, bulletConfig)
    return type(muzzleConfig) == "table"
        and (muzzleConfig.AmmoTypeName == "Rocket" or bulletIsExplosive(bulletConfig))
end
local function predictedProjectilePoint(origin, targetPart, muzzleConfig, bulletConfig)
    if not (cfg.Combat.RPGPrediction and targetPart and muzzleConfig and bulletConfig) then
        return targetPart.Position
    end
    local velocity = targetPart.AssemblyLinearVelocity or Vector3.zero
    local speed = bulletConfig.MuzzleVelocity or muzzleConfig.MuzzleVelocity or 0
    if speed <= 0 then return targetPart.Position end

    local gravity = workspace.Gravity
    local point = targetPart.Position
    local travelTime = (point - origin).Magnitude / speed
    for _ = 1, 3 do
        point = targetPart.Position + velocity * travelTime
        local distance = (point - origin).Magnitude
        travelTime = distance / speed
    end

    local strength = math.clamp(cfg.Combat.RPGPredictionStrength or 1, 0, 2)
    return point + Vector3.new(0, gravity * travelTime * travelTime * 0.5 * strength, 0)
end

-- downed players aren't dead but lie there with CharacterValues.Unconscious set true
-- (the same value the revive prompt reads). skip them so we don't shoot corpses
local function isDowned(char)
    if not char then return false end
    local cv = char:FindFirstChild("CharacterValues")
    local u = cv and cv:FindFirstChild("Unconscious")
    return u ~= nil and u.Value == true
end

-- rounds spent since the last reload. bumped by every shot (manual + ragebot) and zeroed
-- on reload, so the ragebot knows when the mag is dry and stops firing blanks
local rbShots = 0

-- part still on a live character?
local function targetValid(part)
    if not part or not part.Parent then return false end
    local hum = part.Parent:FindFirstChildOfClass("Humanoid")
    return hum ~= nil and hum.Health > 0
end

-- 1-frame memoized scan: closest target to the cursor within fov
local cachedTarget = nil
local lastScanTick = 0

local function findBest()
    local now = os.clock()
    if now == lastScanTick then
        return cachedTarget
    end
    lastScanTick = now

    local camera = workspace.CurrentCamera
    if not camera then
        cachedTarget = nil
        return nil
    end

    local me = LocalPlayer
    local camPos = camera.CFrame.Position
    local mouse = UserInputService:GetMouseLocation() -- Absolute Screen Space
    local best, bestDist

    local ignore = me.Character and { me.Character } or {}
    local ig = workspace:FindFirstChild("Ignore")
    if ig then ignore[#ignore + 1] = ig end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= me and plr.Character and not isDowned(plr.Character) then
            if (not (me.Team and plr.Team == me.Team)) or (not cfg.Combat.SilentExcludeTeammates) then
                local part = plr.Character:FindFirstChild(cfg.Combat.SilentTarget)
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if part and hum and hum.Health > 0 then
                    local pos = part.Position
                    local studsDist = (pos - camPos).Magnitude
                    if (not cfg.Combat.SilentDistanceCheck) or studsDist <= cfg.Combat.SilentMaxDistance then
                        local sp, onScreen = camera:WorldToViewportPoint(pos)
                        if onScreen and sp.Z > 0 then
                            local dist = (Vector2.new(sp.X, sp.Y) - mouse).Magnitude
                            local within = (not cfg.Combat.SilentFovEnabled) or dist <= cfg.Combat.SilentFov
                            if within and (not bestDist or dist < bestDist) then
                                local isVis = true
                                if cfg.Combat.SilentVisibleCheck then
                                    local delta = pos - camPos
                                    local p = RaycastParams.new()
                                    p.FilterType = Enum.RaycastFilterType.Exclude
                                    p.FilterDescendantsInstances = ignore
                                    local hit = workspace:Raycast(camPos, delta, p)
                                    if hit and not hit.Instance:IsDescendantOf(plr.Character) then
                                        isVis = false
                                    end
                                end
                                if isVis then
                                    best, bestDist = part, dist
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    cachedTarget = best
    return best
end

-- synchronized target provider: guarantees 1:1 match between silent aim and target indicators
util.getTarget = function()
    if targetValid(cachedTarget) then
        return cachedTarget
    end
    return findBest()
end

-- refresh the cached target every 3 frames (keeps UI perfectly synced with zero FPS drop)
local targetFrame = 0
RunService.Heartbeat:Connect(function()
    targetFrame = targetFrame + 1
    if targetFrame >= 3 then
        targetFrame = 0
        util.target = findBest()
    end
end)

-- camera / mouse aimbot loop
RunService.RenderStepped:Connect(function()
    if not cfg.Combat.AimbotEnabled then return end
    local isAimbotActive = false
    if Options and Options.aimbotkey then
        isAimbotActive = Options.aimbotkey:GetState()
    end
    if not isAimbotActive then return end

        local target = util.getTarget()
    if not (target and target.Parent) then return end

    local camera = workspace.CurrentCamera
    if not camera then return end

    local targetPos = target.Position
    local smoothness = math.max(1, cfg.Combat.AimbotSmoothness or 1)

    if cfg.Combat.AimbotMethod == "Mouse" and mousemoverel then
            local sp, onScreen = camera:WorldToViewportPoint(targetPos)
        if onScreen and sp.Z > 0 then
            local mouse = UserInputService:GetMouseLocation()
            local deltaX = (sp.X - mouse.X) / smoothness
            local deltaY = (sp.Y - mouse.Y) / smoothness
            mousemoverel(deltaX, deltaY)
        end
    else
        -- Camera CFrame interpolation
        local currentCF = camera.CFrame
        local targetCF = CFrame.new(currentCF.Position, targetPos)
        if smoothness == 1 then
            camera.CFrame = targetCF
        else
            camera.CFrame = currentCF:Lerp(targetCF, 1 / smoothness)
        end
    end
end)

local functions = {}
functions.getRecoilMult = {func = RecoilController.getRecoilMult, upv = debug.getupvalues(RecoilController.getRecoilMult)}
functions.spreadVector = {func = nil}
functions.fire = {func = nil, upv = nil}
functions.turretFire = {func = nil, upv = nil}
functions.aimtoggle = {func = AimController.toggle, upv = debug.getupvalues(AimController.toggle)}
functions.isaimingavailable = {func = AimController.isAimingAvailable, upv = debug.getupvalues(AimController.isAimingAvailable)}
functions.aimupdate = {func = nil, upv = nil}
functions.firemodestart = {func = FiremodeController.start, upv = debug.getupvalue(FiremodeController.new, 2)}
functions.awaitLength = {func = nil}
functions.movementupdate = {func = nil}
functions.healLimb = {func = nil}         -- bandage module: heals a limb (we read its upvalues for the remote)
functions.reloadContext = {func = nil}    -- reload controller: _context (holds the reload timings)
functions.muzzlesConfig = {func = nil}    -- weapon config manager: GetAllMuzzlesConfig (fire rate, ammo, penetration)

local function isClientFireModule(value)
    return type(value) == "table"
        and type(value.fire) == "function"
        and type(value.fireVolley) == "function"
end

for _,v in pairs(gc) do
    if typeof(v) ~= 'function' or (not islclosure(v)) then
        continue
    end

    local info = debug.getinfo(v)
    local constants = debug.getconstants(v)
    local upvalues = debug.getupvalues(v)

    if info.name == 'spreadVector' then
        functions.spreadVector.func = v
    elseif table.find(constants, "config") and string.find(info.source, "Shooter") then
        functions.fire.func = v
        functions.fire.upv = upvalues
    elseif info.name == "fireOnce" and string.find(info.source, "TurretFireController") then
        functions.turretFire.func = v
        functions.turretFire.upv = upvalues
    elseif info.name == 'update' and string.find(info.source, "AimController") then
        functions.aimupdate.func = v
        functions.aimupdate.upv = upvalues
    elseif info.name == 'awaitLength' and string.find(info.source, "Inventory") then
        functions.awaitLength.func = v
    elseif info.name == 'update' and table.find(constants, "inertialSpeed") and table.find(constants, "runHeld") then
        functions.movementupdate.func = v
    elseif info.name == 'healLimb' then
        functions.healLimb.func = v
        functions.healLimb.upv = upvalues
    elseif info.name == 'onVehicleState' then
        functions.reloadContext.func = v
    elseif info.name == 'GetAllMuzzlesConfig' then
        functions.muzzlesConfig.func = v
    end
end

-- Mounted guns use TurretFireController.fireOnce instead of Shooter.fire. The turret
-- state is an upvalue that is replaced on every Attach, so resolve it at shot time.
if functions.turretFire.func then
    local oldTurretFire = functions.turretFire.func
    functions.turretFire.func = hookfunction(oldTurretFire, function(...)
        if not cfg.Combat.SilentEnabled then
            return oldTurretFire(...)
        end

        local state, clientFire
        for _, value in pairs(debug.getupvalues(oldTurretFire)) do
            if type(value) == "table" then
                if isClientFireModule(value) then
                    clientFire = value
                elseif value.muzzle and value.muzzleConfig and value.weaponName then
                    state = value
                end
            end
        end

        local target = util.getTarget()
        if not (state and state.active and state.muzzle and state.muzzle.Parent and clientFire and target) then
            return oldTurretFire(...)
        end

        local origin = state.muzzle.WorldPosition
        local bulletConfig = state.muzzleConfig.BulletSettings
            and state.muzzleConfig.BulletSettings[1]
            or {}
        local targetPoint = target.Position
        if bulletIsRocket(state.muzzleConfig, bulletConfig) then
            targetPoint = predictedProjectilePoint(origin, target, state.muzzleConfig, bulletConfig)
        end
        local direction = targetPoint - origin
        if direction.Magnitude <= 0.001 then
            return oldTurretFire(...)
        end

        local shotCount = bulletConfig.ShotAmount or 1
        local spread = bulletConfig.Spread or 1
        local directions = table.create(shotCount)
        local baseDirection = direction.Unit
        for index = 1, shotCount do
            directions[index] = functions.spreadVector.func(baseDirection, spread)
        end

        local oldExplosiveState = isExplosiveShot
        isExplosiveShot = bulletIsExplosive(bulletConfig)
        local ok, result = pcall(clientFire.fireVolley, state.weaponName, 1, 1, origin, directions)
        isExplosiveShot = oldExplosiveState
        if ok then return result end
        return oldTurretFire(...)
    end)
end

-- spread changer
functions.spreadVector = hookfunction(functions.spreadVector.func, function(p12, p13)
    local mult = cfg.Combat.SpreadMult
    if type(mult) ~= "number" then mult = 1 end

    if mult == 0 then
        return p12.Unit
    end

    local v14 = p12.Unit
    local v15 = p13 / 3570
    local v16 = math.atan(v15) * mult
    local v17 = math.random() * 2 - 1
    local v18 = math.random() * 2 - 1
    local v19 = math.random() * 2 - 1
    return (v14 + Vector3.new(v17, v18, v19) * v16).Unit
end)

-- recoil change
local function new_getRecoilMult(newMult)
    -- upvalues: (copy) v_u_8, (copy) v_u_5, (copy) v_u_6
    local v_u_8,v_u_5,v_u_6 = unpack(functions.getRecoilMult.upv)
	local v23 = v_u_8
	local v24 = v_u_5:getCharacterValues()
	if v24 then
		v24 = v24:FindFirstChild("Stance")
	end --  v23[  v24.Value, default to "Walk"   ] * ((1 - AimController.GetAlpha(), default to 0) * 0.25)
	return (v23[v24 and v24.Value or "Walk"] or 1) * (1 - (v_u_6.getAlpha() or 0) * 0.25) * cfg.Combat.RecoilMult
end

RecoilController.getRecoilMult = new_getRecoilMult

-- silent aim
functions.fire.func = hookfunction(functions.fire.func, function(p22, p23)
    local v_u_4,v_u_3,v_u_8,v_u_12,v_u_9,v_u_5,spreadVector,v_u_7,v_u_6,v_u_13,v_u_2,v_u_11 = unpack(functions.fire.upv)

	-- upvalues: (copy) v_u_4, (copy) v_u_3, (copy) v_u_8, (copy) v_u_12, (copy) v_u_9, (copy) v_u_5, (copy) spreadVector, (copy) v_u_7, (copy) v_u_6, (ref) v_u_13, (copy) v_u_2, (copy) v_u_11
	-- irreducible control flow represented as a structured state loop
	local v24 = 30
	while v24 do
		if v24 == 30 then
			if v_u_4.IsPreparation() then
				return
			end
			local v25 = p22.config
			local v26 = v_u_3:getCharacter()
			if v26 then
				v26 = v26:FindFirstChild("Right Arm")
			end
			v27 = (v_u_8.CFrame.Position - v_u_8.Focus.Position).Magnitude <= 0.75 and p22.viewmodelAttachment or p22.attachment
			v28 = v27.WorldPosition
			local v29 = v27.WorldCFrame.LookVector
			if v26 then
				local v30 = (v28 - v26.CFrame.Position).Magnitude
				local v31 = v28 - v29 * v30
				v_u_12.FilterDescendantsInstances = { v_u_9.Character, workspace.Ignore }
				local v32 = workspace:Raycast(v31, v29 * v30, v_u_12)
				if v32 then
					local v33 = v32.Distance
					local v34 = math.min(0.01, v33)
					v28 = v32.Position - v29 * v34
				end
			end
			local v35 = v25.DefaultAngle or 0
			local v36 = math.rad(v35)
			local v37 = v_u_5.zeroAngle() or v36
			local v38 = (v27.WorldCFrame * CFrame.Angles(v37, 0, 0)).LookVector

			if cfg.Combat.SilentEnabled then
				local aimTarget = util.getTarget()
				if aimTarget then
					local aimPoint = aimTarget.Position
					if bulletIsRocket(v25, v25.BulletSettings[p23]) then
						aimPoint = predictedProjectilePoint(v28, aimTarget, v25, v25.BulletSettings[p23])
					end
					v38 = (aimPoint - v28).Unit   -- aim from the muzzle to the part
				end
			end

			local v39 = v25.BulletSettings[p23]
			rbShots = rbShots + 1 -- your own shots drain the mag too; keep the ragebot's count honest

			p22.animator:play("GunShoot")
			--local v39 = v25.BulletSettings[p23]
			local v40 = v39.ShotAmount or 1
			local v41 = v39.Spread or 1
			v42 = table.create(v40)
			for v43 = 1, v40 do
				v42[#v42 + 1] = spreadVector(v38, v41)
			end
			local v44 = p22.tool.Sounds:FindFirstChild("Muzzle" .. p22.index)
			if v44 then
				v44 = v44:FindFirstChild("Fire")
			end
			if v44 then
				v_u_7.Play(v44, v27.WorldPosition, v25.SoundRange or 3000)
			end
			v_u_6.MuzzleFlash(v27, p22.tool.Name)
			isExplosiveShot = bulletIsExplosive(v39)
			if v_u_13 == nil then
				v24 = 23
			else
				v24 = 24
			end
		elseif v24 == 24 then
			v_u_13.flushNow()
			v24 = 27
		elseif v24 == 27 then
			v_u_11.fireVolley(p22.tool, p22.index, p23, v28, v42)
			isExplosiveShot = false
			if not p22:isHandAction() then
				v_u_6.Casing(v27, p22.tool.Name)
			end
			v24 = nil
			return
		elseif v24 == 23 then
			v45 = v_u_2.Client:FindFirstChild("BodyReplication")
			if v45 then
				v24 = 26
			else
				v24 = 27
			end
		elseif v24 == 26 then
			v_u_13 = require(v45)
			v24 = 24
		else
			v24 = nil
		end
	end
end)
-- aiming shi
functions.aimtoggle.func = hookfunction(functions.aimtoggle.func, function(...)
    local orig = functions.aimtoggle.func
    if not cfg.Combat.AimAnywhere then
        return orig(...) -- let the game gate it like normal
    end
    -- flip the real aim state regardless of stance
    local state = debug.getupvalue(orig, 1)
    debug.setupvalue(orig, 1, (state == 0) and 1 or 0)
end)

-- aiming shi
functions.aimupdate.func = hookfunction(functions.aimupdate.func, function(p25)
    local orig = functions.aimupdate.func
    local wantAim = debug.getupvalue(orig, 1) == 1

    -- instant ads: snap alpha to its target before the lerp
    if cfg.Combat.InstantADS then
        debug.setupvalue(orig, 5, debug.getupvalue(orig, 1))
    end

    orig(p25)

    -- aim anywhere: undo the stance force-out so we stay aimed
    if cfg.Combat.AimAnywhere and wantAim then
        debug.setupvalue(orig, 1, 1)
        if cfg.Combat.InstantADS then
            debug.setupvalue(orig, 5, 1)
        end
    end

    -- no ads slowdown: pin the move multiplier back to 1
    if cfg.Combat.NoADSSlowdown then
        local slow = debug.getupvalue(orig, 6)
        if slow then slow.Value = 1 end
    end
end)

-- aiming shi
functions.isaimingavailable.func = hookfunction(functions.isaimingavailable.func, function(...)
    if cfg.Combat.AimAnywhere then
        return true
    end
    return functions.isaimingavailable.func(...)
end)

functions.firemodestart.func = hookfunction(functions.firemodestart.func, function(p18)
    local v_u_6 = functions.firemodestart.upv

	if not p18.isFiring then
		p18.isFiring = true
		local v19 = p18:_current()
		if v19 then
			local strategy = v19.strategy
			if cfg.Combat.ForceAuto then
				strategy = v_u_6.Automatic.strategy
			end
			task.spawn(strategy.fire, p18)
		end
	end
end)

-- instant equip: drawTool/holsterCurrent only wait on the equip anim when awaitLength
-- returns true, so forcing it false makes them EquipTool/UnequipTools instantly
if functions.awaitLength.func then
    functions.awaitLength.func = hookfunction(functions.awaitLength.func, function(...)
        if cfg.Combat.InstantEquip then
            return false
        end
        return functions.awaitLength.func(...)
    end)
end

-- no hurt slowdown: the game scales speed by 0.5 + (legHP%avg)/2 (down to 0.5 when legs
-- are dead). recompute that same factor and divide it back out after the update runs
local function legHealthMult(char)
    local function ratio(name)
        local part = char:FindFirstChild(name)
        local h = part and part:FindFirstChild("Health")
        if h then
            local max = h:GetAttribute("MaxHealth")
            if max and max > 0 then return h.Value / max end
        end
        return nil
    end
    local l, r = ratio("Left Leg"), ratio("Right Leg")
    if l and r then return 0.5 + (l + r) / 4 end
    return nil
end

if functions.movementupdate.func then
    functions.movementupdate.func = hookfunction(functions.movementupdate.func, function(p11)
        -- omni sprint: the run state only kicks in when moving forward in first person.
        -- force firstPerson off so the game treats every direction as sprint-able
        if cfg.Combat.OmniSprint and p11 then
            p11.firstPerson = false
        end

        functions.movementupdate.func(p11)

        -- no hurt slowdown: undo the leg-health speed penalty
        if cfg.Combat.NoHurtSlowdown and p11 and p11.humanoid and p11.character then
            local mult = legHealthMult(p11.character)
            if mult and mult > 0 and mult < 1 then
                p11.humanoid.WalkSpeed = p11.humanoid.WalkSpeed / mult
                if type(p11.inertialSpeed) == "number" then
                    p11.inertialSpeed = p11.inertialSpeed / mult
                end
            end
        end
    end)
end

-- bullet trajectory mods: drop + travel speed all come out of Trajectory.new
local oldTrajNew = Trajectory.new
Trajectory.new = function(params)
    if not isExplosiveShot then
        if cfg.Combat.NoBulletDrop then
            params.Gravity = 0
        end
        if cfg.Combat.InstantBullet then
            params.MuzzleSpeed = 1e6 -- covers max distance on the first step = hitscan
            params.K = 0             -- no speed decay
        end
    end
    return oldTrajNew(params)
end

local Remotes = RS:WaitForChild("Remotes")


-- auto heal: fire the game's HealLimb remote for each damaged limb directly. healLimb
-- (found in gc) captures the bandage remote as upvalue 1 and the currently equipped
-- bandage as upvalue 2, so we heal with whatever bandage is equipped. firing the remote
-- straight skips the local 5s bar + the speed penalty, so there's no slowdown to undo.
-- we fire every damaged limb each pass to see if the server allows simultaneous heals
local healAcc = 0
local healConn = RunService.Heartbeat:Connect(function(dt)
    if not cfg.Combat.AutoHeal or not functions.healLimb.func then return end
    healAcc = healAcc + dt
    -- instant heal removes the throttle so we fire every frame (tests server gating)
    if not cfg.Combat.InstantHeal and healAcc < 0.75 then return end
    healAcc = 0

    local remote = debug.getupvalue(functions.healLimb.func, 1)
    local bandage = debug.getupvalue(functions.healLimb.func, 2)
    local char = LocalPlayer.Character
    if not (remote and char) then return end

    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            local h = part:FindFirstChild("Health")
            if h then
                local max = h:GetAttribute("MaxHealth")
                if max and h.Value < max then
                    remote:FireServer(bandage, "HealLimb", part)
                end
            end
        end
    end
end)

-- fast revive: downed players' RevivePrompts have a hold time; pin them to the 3s floor
local reviveAcc = 0
local reviveConn = RunService.Heartbeat:Connect(function(dt)
    reviveAcc = reviveAcc + dt
    if reviveAcc < 1 then return end -- scan once a second
    reviveAcc = 0

    if not cfg.Combat.FastRevive then return end
    local chars = workspace:FindFirstChild("Characters")
    if not chars then return end
    for _, p in ipairs(chars:GetDescendants()) do
        if p:IsA("ProximityPrompt") and p.Name == "RevivePrompt" then
            p.HoldDuration = 3
        end
    end
end)

-- Vehicle profiles are keyed by the discovered ShopInfo name and faction.
local carDefaults = {
    FinalDrive = 7.5, ShiftRPM = 7000, IdleRPM = 1000, IdleTorque = 140,
    PeakTorque = 520, PeakTorqueRPM = 5000, RedlineRPM = 9000, RedlineTorque = 300,
    HorsepowerLimit = 1000, TorqueScale = 6, TopSpeed = 220, PeakGrip = 2.5,
    SlideGrip = 2.25, PeakSlip = 0.5, Grip = 40, BrakeMultiplier = 10,
    HandBrakeMultiplier = 5.5, RollingFriction = 0.05, TurningZForceMultiplier = 1,
    TurnRadius = 20, SteerSpeed = 2.5, HighSpeedSteerReduction = 0.65,
    ForceHeight = 0.75, Mass = 750, WheelMass = 8, SuspensionHeight = 2,
    RideHeight = 1.5, WheelOffset = 0.5, ReboundDampingModifier = 1.3,
    CompressionDampingModifier = 1, DamperActiveness = 0.7,
}
local carBoolDefaults = { AutoShift = true, Ackermann = true }
local carChoiceDefaults = {
    ChassisType = "Wheeled",
    DriveType = "AWD",
    Differential = "Locked",
}
local carProfiles = {}
local carEntries = {}
local carConfigs = {}
local carProfileJson = "{}"
local carConfigSeen = {}
local carProfileSyncing = false
local carEntrySignature = ""
local function carText(info)
    local name = info.Name or info.DisplayName or info.VehicleName or info.Id or "Unknown Car"
    local team = info.Team or info.Faction or info.Side or "PACT"
    team = tostring(team):upper():find("NATO") and "NATO" or "PACT"
    return tostring(name) .. " (" .. team .. ")"
end
local function carLabelFromInstance(instance)
    local faction
    local factionNode = instance.Parent
    while factionNode and factionNode ~= RS do
        local upper = factionNode.Name:upper()
        if upper == "PACT" or upper == "NATO" then
            faction = upper
            break
        end
        factionNode = factionNode.Parent
    end
    if not faction then return nil end
    return instance.Name .. " (" .. faction .. ")"
end
local function copyProfile(source)
    local result = {}
    if type(source) == "table" then
        for key, value in pairs(source) do
            if type(value) ~= "table" then result[key] = value end
        end
        if type(source.Ratios) == "table" then
            result.Ratios = {}
            for key, value in pairs(source.Ratios) do result.Ratios[key] = value end
        end
        if type(source.Wheels) == "table" then
            result.Wheels = {}
            for index, wheel in ipairs(source.Wheels) do
                result.Wheels[index] = {}
                for key, value in pairs(wheel) do result.Wheels[index][key] = value end
            end
        end
    end
    for key, value in pairs(carDefaults) do result[key] = source and source[key] ~= nil and source[key] or value end
    for key, value in pairs(carBoolDefaults) do result[key] = source and source[key] ~= nil and source[key] or value end
    for key, value in pairs(carChoiceDefaults) do result[key] = source and source[key] ~= nil and source[key] or value end
    return result
end
local function syncCarProfileJson()
    carProfileJson = HttpService:JSONEncode(carProfiles)
    if Options.carsprofiles and Options.carsprofiles.Value ~= carProfileJson and not carProfileSyncing then
        carProfileSyncing = true
        Options.carsprofiles:SetValue(carProfileJson)
        carProfileSyncing = false
    end
end
local function loadCarProfileJson(value)
    if carProfileSyncing then return end
    if type(value) ~= "string" or value == "" then return end
    local ok, decoded = pcall(HttpService.JSONDecode, HttpService, value)
    if ok and type(decoded) == "table" then
        for label, profile in pairs(decoded) do
            if type(profile) == "table" then carProfiles[label] = copyProfile(profile) end
        end
    end
end
local function registerCar(label, value)
    if not label or type(value) ~= "table" or type(value.Transmission) ~= "table" then return end
    if carConfigSeen[value] then return end
    carConfigSeen[value] = true
    carConfigs[label] = value
    carEntries[#carEntries + 1] = label
    if carProfiles[label] == nil then
        carProfiles[label] = copyProfile(value.Transmission)
    end
end
local function discoverCars()
    local manager = RS:FindFirstChild("Shared")
        and RS.Shared:FindFirstChild("VehicleConfigManager")
    if manager then
        for _, instance in ipairs(manager:GetDescendants()) do
            if instance:IsA("ModuleScript") then
                local label = carLabelFromInstance(instance)
                if label then
                    local ok, value = pcall(require, instance)
                    if ok and type(value) == "table" and rawget(value, "Transmission") then
                        for key, field in pairs(value.Transmission) do
                            if type(field) == "number" and carDefaults[key] == nil then
                                carDefaults[key] = field
                            elseif type(field) == "boolean" and carBoolDefaults[key] == nil then
                                carBoolDefaults[key] = field
                            elseif type(field) == "string" and carChoiceDefaults[key] == nil then
                                carChoiceDefaults[key] = field
                            end
                        end
                        registerCar(label, value)
                    end
                end
            end
        end
    end

    -- Fallback for configs held only in closures/upvalues rather than ModuleScripts.
    if not manager then
      for _, value in pairs(getgc(true)) do
        if typeof(value) == "table" and rawget(value, "Transmission") and rawget(value, "Damage") and rawget(value, "ShopInfo") then
            local info = value.ShopInfo
            if type(info) == "table" then
                local label = carText(info)
                for key, field in pairs(value.Transmission) do
                    if type(field) == "number" and carDefaults[key] == nil then
                        carDefaults[key] = field
                    elseif type(field) == "boolean" and carBoolDefaults[key] == nil then
                        carBoolDefaults[key] = field
                    elseif type(field) == "string" and carChoiceDefaults[key] == nil then
                        carChoiceDefaults[key] = field
                    end
                end
                registerCar(label, value)
            end
        end
      end
    end
    table.sort(carEntries)
    local signature = table.concat(carEntries, "\0")
    if Options.carprofile and signature ~= carEntrySignature then
        carEntrySignature = signature
        Options.carprofile:SetValues(carEntries)
    end
end
discoverCars()
local selectedCar = carEntries[1]
local function applyCarMods()
    if not cfg.Combat.CarMods then return end
    for label, value in pairs(carConfigs) do
        local profile = carProfiles[label]
        if profile then
            local transmission = value.Transmission
            for key in pairs(carDefaults) do
                if transmission[key] ~= profile[key] then transmission[key] = profile[key] end
            end
            for key in pairs(carBoolDefaults) do
                if transmission[key] ~= profile[key] then transmission[key] = profile[key] end
            end
            for key in pairs(carChoiceDefaults) do
                if transmission[key] ~= profile[key] then transmission[key] = profile[key] end
            end
            if profile.Ratios then
                transmission.Ratios = transmission.Ratios or {}
                for gear, ratio in pairs(profile.Ratios) do
                    if transmission.Ratios[gear] ~= ratio then transmission.Ratios[gear] = ratio end
                end
            end
            if profile.Wheels then
                transmission.Wheels = transmission.Wheels or {}
                for index, wheel in ipairs(profile.Wheels) do
                    transmission.Wheels[index] = transmission.Wheels[index] or {}
                    for key, value in pairs(wheel) do
                        if transmission.Wheels[index][key] ~= value then
                            transmission.Wheels[index][key] = value
                        end
                    end
                end
            end
        end
    end
end

local function selectedCarProfile()
    if not selectedCar then return nil end
    carProfiles[selectedCar] = carProfiles[selectedCar] or copyProfile()
    return carProfiles[selectedCar]
end
local function setCarControlValue(key, value)
    local profile = selectedCarProfile()
    if not profile then return end
    profile[key] = value
    syncCarProfileJson()
    applyCarMods()
end
local carModsAcc = 0
local carModsConn = RunService.Heartbeat:Connect(function(dt)
    if not cfg.Combat.CarMods then return end
    carModsAcc = carModsAcc + dt
    if carModsAcc < 5 then return end
    carModsAcc = 0
    discoverCars()
    applyCarMods()
end)

-- ragebot: independent auto-fire, fully separate from silent aim. it fires straight
-- through the client fire module (downstream of the silent aim hook) at any enemy it can
-- actually damage: clear line of sight, or a penetrable wall when wallbang is on.
-- runs in its own thread with a paced while-loop instead of per-frame render/heartbeat
local function findClientFire(upvalues)
    for _, value in pairs(upvalues or {}) do
        if type(value) == "table"
            and type(value.fire) == "function"
            and type(value.fireVolley) == "function" then
            return value
        end
    end
    return upvalues and upvalues[12]
end
local ClientFire = findClientFire(functions.fire.upv) -- the module with fireVolley/fire
local WeaponRemote = Remotes:WaitForChild("Weapon")             -- reload requests go here
-- the config manager keeps every weapon config keyed by tool name; grab that table off
-- GetAllMuzzlesConfig so we get real fire rate / ammo / penetration instead of guessing
WeaponConfigs = functions.muzzlesConfig.func and debug.getupvalue(functions.muzzlesConfig.func, 1)
local Materials = select(2, pcall(function()
    return require(RS:WaitForChild("Shared"):WaitForChild("Ballistics"):WaitForChild("ProjectileMaterials"))
end))
if type(Materials) ~= "table" then Materials = nil end

-- muzzle config for the held gun (Firerate, Ammo, ReloadTime, BulletSettings[i].Penetration)
local function rbMuzzleConfig(tool, muzzleIndex)
    local wc = WeaponConfigs and WeaponConfigs[tool.Name]
    return wc and wc[muzzleIndex]
end

-- find where a bullet exits a wall, same idea as ProjectileCaster.findExit: cast back
-- through just that part to get its far face
local function rbFindExit(hitPos, dir, inst)
    local p = RaycastParams.new()
    p.FilterType = Enum.RaycastFilterType.Include
    p.FilterDescendantsInstances = { inst }
    local far = hitPos + dir * 60
    local r = workspace:Raycast(far, -dir * 60, p)
    return r and r.Position or nil
end

-- walk the ray toward the target through walls, spending the penetration budget by
-- thickness * material cost (the same maths interactions.resolve uses). true if a bullet
-- would still reach the target character
local function rbPenetrable(origin, targetPos, targetChar, budget, ignore)
    if not budget or budget <= 0 then return false end -- no budget -> can't wallbang
    local remaining = budget
    local pos = origin
    for _ = 1, 8 do
        local delta = targetPos - pos
        local dist = delta.Magnitude
        if dist < 0.1 then return true end
        local dir = delta.Unit
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = ignore
        local hit = workspace:Raycast(pos, dir * dist, params)
        if not hit then return true end
        if hit.Instance:IsDescendantOf(targetChar) then return true end
        local exit = rbFindExit(hit.Position, dir, hit.Instance)
        if not exit then return false end
        local thickness = (exit - hit.Position).Magnitude
        local cost = Materials and Materials.getPenetration(hit.Material) or 1
        remaining = remaining - thickness * cost
        if remaining <= 0 then return false end
        pos = exit + dir * 0.05
    end
    return false
end

-- can we deal damage to this target from origin right now?
local function rbCanDamage(origin, targetPos, targetChar, budget, ignore)
    local delta = targetPos - origin
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = ignore
    local hit = workspace:Raycast(origin, delta, params)
    if not hit then return true end                       -- nothing in the way
    if hit.Instance:IsDescendantOf(targetChar) then return true end -- direct line to the target
    if not cfg.Combat.RagebotWallbang then return false end
    return rbPenetrable(origin, targetPos, targetChar, budget, ignore)
end

-- reload request buffer: {action=Reload(1), muzzleIndex, bulletIndex}
local function rbReloadServer(muzzleIndex, bulletIndex)
    local b = buffer.create(3)
    buffer.writeu8(b, 0, 1)
    buffer.writeu8(b, 1, muzzleIndex)
    buffer.writeu8(b, 2, bulletIndex)
    WeaponRemote:FireServer(b)
end

-- part priority: head and torso deal the most damage, so try them first, then any other
-- limb. scanning every part means we can tag a target the moment any bit of them is exposed
local rbPartOrder = { "Head", "Torso", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }
local function rbBestPart(targetChar, origin, budget, ignore)
    for _, name in ipairs(rbPartOrder) do
        local part = targetChar:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            if rbCanDamage(origin, part.Position, targetChar, budget, ignore) then
                return part, origin
            end
        end
    end
    return nil
end

local rbNextFire = 0
local rbReloadUntil = 0    -- hold fire until this time while a reload lands
local rbLastTool = nil
local function ragebotStep()
    local char = LocalPlayer.Character
    if not (char and ClientFire) then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end

    -- shoot from our own head, the game has ping leniency on the origin
    local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not head then return end
    local origin = head.Position

    local muzzleIndex, bulletIndex = 1, 1
    local mc = rbMuzzleConfig(tool, muzzleIndex)
    local firerate = (mc and mc.Firerate) or 600
    local magSize = (mc and mc.Ammo) or 30
    local reloadTime = (mc and mc.ReloadTime) or 3
    local bs = mc and mc.BulletSettings and mc.BulletSettings[bulletIndex]
    local budget = (bs and bs.Penetration) or 0

    -- new gun -> reset the ammo tracker
    if tool ~= rbLastTool then
        rbLastTool = tool
        rbShots = 0
        rbReloadUntil = 0
    end

    -- mid-reload: hold fire until it lands (instant reload cuts the wait to ~0)
    if os.clock() < rbReloadUntil then return end

    -- out of ammo: never fire a dry mag. auto reload if it's on, otherwise wait for the
    -- player to reload (which zeroes rbShots via the reload hook)
    if magSize > 0 and rbShots >= magSize then
        if cfg.Combat.RagebotAutoReload then
            rbReloadServer(muzzleIndex, bulletIndex)
            rbReloadUntil = os.clock() + reloadTime
            rbShots = 0
        end
        return
    end

    -- Do not spend rays finding an origin until the weapon can actually fire.
    if os.clock() < rbNextFire then return end

    local ignore = { char }
    local ig = workspace:FindFirstChild("Ignore")
    if ig then ignore[#ignore + 1] = ig end

    -- Check nearest enemies first so a valid target stops all further origin scans.
    local me = LocalPlayer
    local candidates = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= me and plr.Character and not isDowned(plr.Character) then -- skip downed
            if not (me.Team and plr.Team == me.Team) then -- never teammates
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                local ref = plr.Character:FindFirstChild("HumanoidRootPart")
                    or plr.Character:FindFirstChild("Head")
                if hum and hum.Health > 0 and ref then
                    local dist = (ref.Position - origin).Magnitude
                    candidates[#candidates + 1] = { Character = plr.Character, Distance = dist }
                end
            end
        end
    end

    table.sort(candidates, function(a, b) return a.Distance < b.Distance end)
    local best, shotOrigin
    for _, candidate in ipairs(candidates) do
        best, shotOrigin = rbBestPart(candidate.Character, origin, budget, ignore)
        if best then break end
    end

    if best then
        rbNextFire = os.clock() + 60 / firerate -- respect the weapon's real fire rate
        origin = shotOrigin or origin
        local targetPoint = best.Position
        if bulletIsRocket(mc, bs) then
            targetPoint = predictedProjectilePoint(origin, best, mc, bs)
        end
        local dir = (targetPoint - origin).Unit
        isExplosiveShot = bulletIsExplosive(bs)
        pcall(function()
            ClientFire.fire(tool, muzzleIndex, bulletIndex, origin, dir, {})
        end)
        isExplosiveShot = false
        rbShots = rbShots + 1
    end
end

local lastTpTime = 0
local function tpAuraStep()
    if not cfg.Combat.RagebotTPAura then return end
    if os.clock() - lastTpTime < 2.0 then return end -- hold at target location for 2s before next teleport

    local me = LocalPlayer
    local char = me.Character
    if not char then return end
    local myHrp = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head") or myHrp
    if not (myHrp and head) then return end
    local origin = head.Position

    local ignore = { char }
    local ig = workspace:FindFirstChild("Ignore")
    if ig then ignore[#ignore + 1] = ig end

    local anyVisible = false
    local nearestEnemyChar, nearestDist

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= me and plr.Character and not isDowned(plr.Character) then
            if not (me.Team and plr.Team == me.Team) then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local targetHead = plr.Character:FindFirstChild("Head") or targetHrp
                if hum and hum.Health > 0 and targetHrp then
                    local delta = targetHead.Position - origin
                    local p = RaycastParams.new()
                    p.FilterType = Enum.RaycastFilterType.Exclude
                    p.FilterDescendantsInstances = ignore
                    local hit = workspace:Raycast(origin, delta, p)

                    if not hit or hit.Instance:IsDescendantOf(plr.Character) then
                        anyVisible = true
                        break
                    end

                    local dist = (targetHrp.Position - origin).Magnitude
                    if not nearestDist or dist < nearestDist then
                        nearestEnemyChar = plr.Character
                        nearestDist = dist
                    end
                end
            end
        end
    end

    if not anyVisible and nearestEnemyChar then
        local targetHrp = nearestEnemyChar:FindFirstChild("HumanoidRootPart")
        if targetHrp and myHrp then
            lastTpTime = os.clock()
            myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 3)
        end
    end
end

local ragebotThread = task.spawn(function()
    while task.wait(0.03) do -- paced loop, cheaper than a render/heartbeat connection
        if cfg.Combat.Ragebot then
            pcall(ragebotStep)
        end
        if cfg.Combat.RagebotTPAura then
            pcall(tpAuraStep)
        end
    end
end)

local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    if cfg.Combat.NoHurtSlowdown then
        if key == "Value" and not checkcaller() and typeof(self) == "Instance" then
            if oldIndex(self, "Name") == "Health" then
                local parent = oldIndex(self, "Parent")
                if parent then
                    local pName = oldIndex(parent, "Name")
                    if pName == "Left Leg" or pName == "Right Leg" then
                        local maxHp = self:GetAttribute("MaxHealth")
                        return maxHp or 100
                    end
                end
            end
        end
    end

    return oldIndex(self, key)
end)







-- window + tabs
local Window = Library:CreateWindow({
    Title = "Cold War - vault.cc",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2,
})

local Tabs = {
    Combat = Window:AddTab("Combat"),
    ESP = Window:AddTab("ESP"),
    Misc = Window:AddTab("Misc"),
    Settings = Window:AddTab("Settings"),
}

-- load esp lib, pcall so a bad fetch doesnt take the whole ui down
local espCfg
local espOk, ESP = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/ttokennxyz/vaultcc/refs/heads/main/esplibcoldwar.lua"))()
end)

if espOk and type(ESP) == "table" then
    -- start disabled, ui drives everything through applyESP
    pcall(function()
        ESP:Load({ Enabled = false })
        espCfg = ESP:GetConfig()
    end)
else
    ESP = nil
    Library:Notify("Failed to load ESP library.")
end

-- push every control into the live esp config
-- lib re-reads config each frame so mutating espCfg is instant
local function applyESP()
    local c = espCfg
    if not c then return end

    -- core
    c.Enabled = Toggles.ESPMaster.Value
    c.LocalPlayer = false           -- never draw ourselves
    c.MaxDistance = Options.ESPMaxDistance.Value
    c.DynamicBoxes = true           -- always dynamic boxes
    c.DynamicBoxesCheap = false
    c.DynamicBoxesIncludeAll = false
    -- players/directories handled in refreshTeamFilter

    -- boxes
    c.Boxes = Toggles.ESPBoxes.Value
    c.BoxType = Options.ESPBoxType.Value
    c.BoxColor = Options.ESPBoxColor.Value
    c.BoxThickness = Options.ESPBoxThickness.Value
    c.Outlines.Style = Toggles.ESPBoxOutline.Value and "Full" or "None"
    c.Outlines.Color = Options.ESPBoxOutlineColor.Value

    -- box fill
    c.BoxFill.Enabled = Toggles.ESPBoxFill.Value
    c.BoxFill.Color = Options.ESPBoxFillColor.Value
    c.BoxFill.Transparency = Options.ESPBoxFillTransparency.Value

    -- names + info
    c.Names = Toggles.ESPNames.Value
    c.TextColor = Options.ESPNameColor.Value
    c.TextSize = Options.ESPTextSize.Value
    c.TextOutline = Toggles.ESPTextOutline.Value
    c.Distance.Enabled = Toggles.ESPDistance.Value
    c.Distance.Color = Options.ESPDistanceColor.Value
    c.Weapon.Enabled = Toggles.ESPWeapon.Value
    c.Weapon.UseToolFallback = true -- weapons are Tools under the character
    c.TeamIndicator.Enabled = Toggles.ESPTeam.Value
    c.FriendlyIndicator.Enabled = Toggles.ESPFriendly.Value
    c.FriendlyIndicator.CheckTeam = Toggles.ESPFriendly.Value
    c.FriendlyIndicator.CheckFriends = Toggles.ESPFriendly.Value

    -- health (lib reads per-part health via HealthBar.Source; see esp lib)
    c.HealthBar.Enabled = Toggles.ESPHealth.Value
    c.HealthBar.ShowText = true
    c.HealthBar.Source = (Options.ESPHealthMode.Value == "Target part") and "Part" or "Average"
    c.HealthBar.Part = cfg.Combat.SilentTarget

    -- chams. feed the same color/transparency into all 3 modes so the
    -- type dropdown just works without extra pickers
    c.Chams.Enabled = Toggles.ESPChams.Value
    c.Chams.Type = Options.ESPChamsType.Value

    local fill = Options.ESPChamsFill.Value
    local fillT = Options.ESPChamsFillT.Value
    local outline = Options.ESPChamsOutline.Value
    local outlineT = Options.ESPChamsOutlineT.Value
    local visCheck = Toggles.ESPChamsVisible.Value

    c.Chams.Highlight.FillColor = fill
    c.Chams.Highlight.FillTransparency = fillT
    c.Chams.Highlight.OutlineColor = outline
    c.Chams.Highlight.OutlineTransparency = outlineT
    c.Chams.Highlight.VisibleCheck = visCheck

    c.Chams.MeshChams.FillColor = fill
    c.Chams.MeshChams.FillTransparency = fillT
    c.Chams.MeshChams.OutlineColor = outline
    c.Chams.MeshChams.OutlineTransparency = outlineT
    c.Chams.MeshChams.VisibleCheck = visCheck

    c.Chams.Adornment.Color = fill
    c.Chams.Adornment.Transparency = fillT
    c.Chams.Adornment.VisibleCheck = visCheck

    -- flags + arrows
    c.Flags.Enabled = Toggles.ESPFlags.Value
    c.Flags.Options.Idle = Toggles.ESPFlagIdle.Value
    c.Flags.Options.Moving = Toggles.ESPFlagMoving.Value
    c.Flags.Options.Jumping = Toggles.ESPFlagJumping.Value
    c.Flags.Options.Swimming = Toggles.ESPFlagSwimming.Value
    c.OffScreenArrows.Enabled = Toggles.ESPArrows.Value
    c.OffScreenArrows.Color = Options.ESPArrowColor.Value
    c.OffScreenArrows.Size = Options.ESPArrowSize.Value
end

-- player tracking + teammate filter
-- lib has no team filter on its Players scan, so when filter is on we kill that
-- and feed only enemies through the Directories system instead (still tracks the
-- real char models so boxes/chams/health all work)
local function refreshTeamFilter()
    local c = espCfg
    if not c then return end

    local me = LocalPlayer

    if Toggles.ESPFilterTeam.Value then
        c.Players = false
        local dirs = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= me and plr.Character then
                -- same teamcheck as util.getTarget
                if not (me.Team and plr.Team == me.Team) then
                    dirs[#dirs + 1] = { DisplayName = plr.Name, Path = plr.Character:GetFullName() }
                end
            end
        end
        c.Directories = dirs
    else
        -- filter off, just use the built-in scan
        c.Players = true
        c.Directories = {}
    end
end

-- combat tab

--right: gunmods
local gunmods = Tabs.Combat:AddRightGroupbox("Gun Mods")
gunmods:AddSlider("recoilmult", { Text = "Recoil Multiplier", Default = 0, Min = 0, Max = 1, Rounding = 2 })
Options['recoilmult']:OnChanged(function(val)
    cfg.Combat.RecoilMult = val
end)
gunmods:AddSlider("spreadmult", { Text = "Spread Multiplier", Default = 0, Min = 0, Max = 1, Rounding = 2 })
Options['spreadmult']:OnChanged(function(val)
    cfg.Combat.SpreadMult = val
end)
gunmods:AddToggle("forceauto", { Text = "Force Auto", Default = true})
Toggles['forceauto']:OnChanged(function(val)
    cfg.Combat.ForceAuto = val
end)
gunmods:AddToggle("instantequip", { Text = "Instant Equip", Default = false, Tooltip = "Equip weapons instantly" })
Toggles['instantequip']:OnChanged(function(val) -- instant equip
    cfg.Combat.InstantEquip = val
end)
gunmods:AddToggle("nodrop", { Text = "No Bullet Drop", Default = false, Tooltip = "Bullets ignore gravity" })
Toggles['nodrop']:OnChanged(function(val) -- no bullet drop
    cfg.Combat.NoBulletDrop = val
end)
gunmods:AddToggle("instantbullet", { Text = "Instant Bullet", Default = false, Tooltip = "Bullets travel instantly" })
Toggles['instantbullet']:OnChanged(function(val) -- instant bullet
    cfg.Combat.InstantBullet = val
end)
gunmods:AddToggle("rpgprediction", { Text = "RPG Prediction", Default = true, Tooltip = "Lead rocket and explosive projectile shots using target velocity" })
Toggles['rpgprediction']:OnChanged(function(val)
    cfg.Combat.RPGPrediction = val
end)
gunmods:AddSlider("rpgpredictionstrength", { Text = "RPG Prediction Strength", Default = 1, Min = 0, Max = 2, Rounding = 2 })
Options['rpgpredictionstrength']:OnChanged(function(val)
    cfg.Combat.RPGPredictionStrength = val
end)

--right: aiming
local aiming = Tabs.Combat:AddRightGroupbox("Aiming")
aiming:AddToggle("aimbotenabled", { Text = "Aimbot Enabled", Default = false, Tooltip = "Camera / Mouse Aimbot" }):AddKeyPicker("aimbotkey", { Default = "R", SyncToggleState = false, Mode = "Hold", Text = "Aimbot Key" })
Toggles['aimbotenabled']:OnChanged(function(val)
    cfg.Combat.AimbotEnabled = val
end)
aiming:AddDropdown("aimbotmethod", { Text = "Aim Method", Values = { "Camera", "Mouse" }, Default = 1, Multi = false })
Options['aimbotmethod']:OnChanged(function(val)
    cfg.Combat.AimbotMethod = val
end)
aiming:AddDropdown("aimbottarget", { Text = "Target part", Values = { "Head", "Torso", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }, Default = 1, Multi = false })
Options['aimbottarget']:OnChanged(function(val)
    cfg.Combat.AimbotTarget = val
end)
aiming:AddSlider("aimbotsmoothness", { Text = "Smoothness", Default = 1, Min = 1, Max = 20, Rounding = 1, Tooltip = "1 = Instant lock, higher = smoother" })
Options['aimbotsmoothness']:OnChanged(function(val)
    cfg.Combat.AimbotSmoothness = val
end)
aiming:AddToggle("aimanywhere", { Text = "Aim Anywhere", Default = true, Tooltip = "Aim in any stance" })
Toggles['aimanywhere']:OnChanged(function(val) -- aim anywhere
    cfg.Combat.AimAnywhere = val
end)
aiming:AddToggle("instantads", { Text = "Instant ADS", Default = true, Tooltip = "Aim instantly" })
Toggles['instantads']:OnChanged(function(val) -- instant ads
    cfg.Combat.InstantADS = val
end)
aiming:AddToggle("noadsslowdown", { Text = "No ADS Slowdown", Default = true, Tooltip = "Full speed while aiming" })
Toggles['noadsslowdown']:OnChanged(function(val) -- no ads slowdown
    cfg.Combat.NoADSSlowdown = val
end)

--left: silent
local silent = Tabs.Combat:AddLeftGroupbox("Silent Aim")
silent:AddToggle("silentenabled", { Text = "Enabled", Default = true, Tooltip = "Master switch for Silent Aim" }):AddKeyPicker("silentbind", { Default = "None", SyncToggleState = true, Mode = "Toggle", Text = "Silent Aim" })
Toggles['silentenabled']:OnChanged(function(val) -- silent enabled
    cfg.Combat.SilentEnabled = val
end)
silent:AddDropdown("silenttarget", { Text = "Target part", Values = { "Head", "Torso", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }, Default = 1, Multi = false })
Options['silenttarget']:OnChanged(function(val) -- target part
    cfg.Combat.SilentTarget = val
    if espCfg then espCfg.HealthBar.Part = val end -- keep "Target part" health in sync
end)
silent:AddToggle("silentvisiblecheck", { Text = "Visible Check", Default = false, Tooltip = "Only target visible enemies" })
Toggles['silentvisiblecheck']:OnChanged(function(val)
    cfg.Combat.SilentVisibleCheck = val
end)
silent:AddToggle("silentdistancecheck", { Text = "Distance Check", Default = false, Tooltip = "Only target enemies within max distance" })
Toggles['silentdistancecheck']:OnChanged(function(val)
    cfg.Combat.SilentDistanceCheck = val
end)
silent:AddSlider("silentmaxdistance", { Text = "Max Distance", Default = 500, Min = 10, Max = 2000, Rounding = 0, Suffix = " studs" })
Options['silentmaxdistance']:OnChanged(function(val)
    cfg.Combat.SilentMaxDistance = val
end)
silent:AddToggle("fovenabled", { Text = "FOV Circle", Default = false})
Toggles['fovenabled']:OnChanged(function(val) -- fov circle enabled
    cfg.Combat.SilentFovEnabled = val
end)
silent:AddSlider("fovsize", { Text = "FOV Circle Size", Default = 100, Min = 5, Max = 500, Rounding = 0 })
Options['fovsize']:OnChanged(function(val) -- fov circle size
    cfg.Combat.SilentFov = val
end)
silent:AddToggle("silentteamcheck", { Text = "Exclude Teammates", Default = true})
Toggles['silentteamcheck']:OnChanged(function(val) -- silent enabled
    cfg.Combat.SilentExcludeTeammates = val
end)
silent:AddToggle("fovdraw", { Text = "Draw FOV Circle", Default = false })
Toggles['fovdraw']:OnChanged(function(val) -- draw fov circle
    cfg.Combat.FovDrawEnabled = val
end)
silent:AddLabel("FOV color"):AddColorPicker("fovcolor", { Default = Color3.fromRGB(255, 255, 255), Title = "FOV color" })
Options['fovcolor']:OnChanged(function(val) -- fov circle color
    cfg.Combat.FovColor = val
end)
silent:AddSlider("fovthickness", { Text = "FOV Thickness", Default = 1, Min = 1, Max = 10, Rounding = 0 })
Options['fovthickness']:OnChanged(function(val) -- fov circle thickness
    cfg.Combat.FovThickness = val
end)
silent:AddToggle("snaplines", { Text = "Snapline", Default = false, Tooltip = "Draw a line to the current target" })
Toggles['snaplines']:OnChanged(function(val) -- snapline
    cfg.Combat.Snaplines = val
end)
silent:AddLabel("Snapline color"):AddColorPicker("snaptargetcolor", { Default = Color3.fromRGB(255, 0, 0), Title = "Snapline color" })
Options['snaptargetcolor']:OnChanged(function(val) -- snapline color
    cfg.Combat.SnapTargetColor = val
end)

--left: ragebot (separate from silent aim, auto-fires on its own)
local ragebot = Tabs.Combat:AddLeftGroupbox("Ragebot")
ragebot:AddToggle("ragebot", { Text = "Enabled", Default = false, Tooltip = "Auto-shoot any enemy you can hit" }):AddKeyPicker("ragebotbind", { Default = "None", SyncToggleState = true, Mode = "Toggle", Text = "Ragebot" })
Toggles['ragebot']:OnChanged(function(val) -- ragebot
    cfg.Combat.Ragebot = val
end)
ragebot:AddToggle("ragebotwallbang", { Text = "Wallbang", Default = false, Tooltip = "Also shoot enemies through penetrable walls" })
Toggles['ragebotwallbang']:OnChanged(function(val) -- ragebot wallbang
    cfg.Combat.RagebotWallbang = val
end)
ragebot:AddToggle("ragebotautoreload", { Text = "Auto Reload", Default = false, Tooltip = "Reload automatically when the mag runs dry" })
Toggles['ragebotautoreload']:OnChanged(function(val) -- ragebot auto reload
    cfg.Combat.RagebotAutoReload = val
end)
ragebot:AddToggle("ragebottpaura", { Text = "TP Aura", Default = false, Tooltip = "Teleports to the nearest player if none are visible" })
Toggles['ragebottpaura']:OnChanged(function(val) -- ragebot tp aura
    cfg.Combat.RagebotTPAura = val
end)

-- fov circle drawing
-- screengui in gethui() with coregui fallback, same as the esp lib
local fovGui = Instance.new("ScreenGui")
fovGui.Name = "cwfov"
fovGui.IgnoreGuiInset = true -- Absolute Screen Space
fovGui.ResetOnSpawn = false
fovGui.DisplayOrder = 100
fovGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local fovCircle = Instance.new("Frame")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.Visible = false
fovCircle.Parent = fovGui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0) -- half of size = perfect circle
fovCorner.Parent = fovCircle

local fovStroke = Instance.new("UIStroke")
fovStroke.Thickness = 1
fovStroke.Color = Color3.fromRGB(255, 255, 255)
fovStroke.Parent = fovCircle

-- camera + 1 so it draws right after the camera, never lags behind the cursor
RunService:BindToRenderStep("cwfov", Enum.RenderPriority.Camera.Value + 1, function()
    if not cfg.Combat.FovDrawEnabled then
        fovCircle.Visible = false
        return
    end

    local m = UserInputService:GetMouseLocation() -- Absolute Screen Position
    local r = cfg.Combat.SilentFov
    fovCircle.Size = UDim2.fromOffset(r * 2, r * 2)
    fovCircle.Position = UDim2.fromOffset(m.X, m.Y)
    fovStroke.Thickness = cfg.Combat.FovThickness
    fovStroke.Color = cfg.Combat.FovColor
    fovCircle.Visible = true
end)

-- snaplines: one line from the cursor to the cached target (viewport space throughout)
local snapGui = Instance.new("ScreenGui")
snapGui.Name = "cwsnap"
snapGui.IgnoreGuiInset = true -- Absolute Screen Space
snapGui.ResetOnSpawn = false
snapGui.DisplayOrder = 100
snapGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local snapLine = Instance.new("Frame")
snapLine.AnchorPoint = Vector2.new(0.5, 0.5)
snapLine.BorderSizePixel = 0
snapLine.Visible = false
snapLine.Parent = snapGui

RunService:BindToRenderStep("cwsnap", Enum.RenderPriority.Camera.Value + 1, function()
    local part = util.target
    if cfg.Combat.Snaplines and part and part.Parent then
        local camera = workspace.CurrentCamera
        if camera then
            local sp, on = camera:WorldToViewportPoint(part.Position)
            if on and sp.Z > 0 then
                local origin = UserInputService:GetMouseLocation()
                local p2 = Vector2.new(sp.X, sp.Y)
                local diff = p2 - origin
                snapLine.Size = UDim2.fromOffset(diff.Magnitude, 1)
                snapLine.Position = UDim2.fromOffset((origin.X + p2.X) / 2, (origin.Y + p2.Y) / 2)
                snapLine.Rotation = math.deg(math.atan2(diff.Y, diff.X))
                snapLine.BackgroundColor3 = cfg.Combat.SnapTargetColor
                snapLine.Visible = true
                return
            end
        end
    end
    snapLine.Visible = false
end)

-- esp tab

-- left: main
local espMain = Tabs.ESP:AddLeftGroupbox("Main")
espMain:AddToggle("ESPMaster", { Text = "Enabled", Default = false, Tooltip = "Master switch for all ESP" })
espMain:AddToggle("ESPFilterTeam", { Text = "Filter teammates", Default = false, Tooltip = "Hide players on your team" })
espMain:AddSlider("ESPMaxDistance", { Text = "Max distance", Default = 0, Min = 0, Max = 2000, Rounding = 0, Suffix = " studs", Tooltip = "Hide targets past this range (0 = unlimited)" })

-- left: boxes
local espBox = Tabs.ESP:AddLeftGroupbox("Boxes")
espBox:AddToggle("ESPBoxes", { Text = "Boxes", Default = true })
espBox:AddDropdown("ESPBoxType", { Text = "Box type", Values = { "Normal", "Corner" }, Default = 1, Multi = false })
espBox:AddLabel("Box color"):AddColorPicker("ESPBoxColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Box color" })
espBox:AddSlider("ESPBoxThickness", { Text = "Box thickness", Default = 1, Min = 1, Max = 6, Rounding = 0 })
espBox:AddToggle("ESPBoxOutline", { Text = "Box outline", Default = true })
espBox:AddLabel("Outline color"):AddColorPicker("ESPBoxOutlineColor", { Default = Color3.fromRGB(0, 0, 0), Title = "Outline color" })
espBox:AddDivider()
espBox:AddToggle("ESPBoxFill", { Text = "Box fill", Default = false })
espBox:AddLabel("Fill color"):AddColorPicker("ESPBoxFillColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Fill color" })
espBox:AddSlider("ESPBoxFillTransparency", { Text = "Fill transparency", Default = 0.9, Min = 0, Max = 1, Rounding = 2 })

-- left: chams
local espChams = Tabs.ESP:AddLeftGroupbox("Chams")
espChams:AddToggle("ESPChams", { Text = "Chams", Default = false })
espChams:AddDropdown("ESPChamsType", { Text = "Chams type", Values = { "Highlight", "Adornment", "MeshChams" }, Default = 1, Multi = false, Tooltip = "MeshChams = real players only" })
espChams:AddLabel("Fill color"):AddColorPicker("ESPChamsFill", { Default = Color3.fromRGB(59, 144, 204), Title = "Cham fill" })
espChams:AddSlider("ESPChamsFillT", { Text = "Fill transparency", Default = 0.6, Min = 0, Max = 1, Rounding = 2 })
espChams:AddLabel("Outline color"):AddColorPicker("ESPChamsOutline", { Default = Color3.fromRGB(255, 255, 255), Title = "Cham outline" })
espChams:AddSlider("ESPChamsOutlineT", { Text = "Outline transparency", Default = 0, Min = 0, Max = 1, Rounding = 2 })
espChams:AddToggle("ESPChamsVisible", { Text = "Visible check", Default = false, Tooltip = "On = occluded depth, Off = always on top" })

-- right: names + info
local espInfo = Tabs.ESP:AddRightGroupbox("Names & Info")
espInfo:AddToggle("ESPNames", { Text = "Names", Default = true })
espInfo:AddLabel("Name color"):AddColorPicker("ESPNameColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Name color" })
espInfo:AddSlider("ESPTextSize", { Text = "Text size", Default = 12, Min = 6, Max = 28, Rounding = 0 })
espInfo:AddToggle("ESPTextOutline", { Text = "Text outline", Default = true })
espInfo:AddDivider()
espInfo:AddToggle("ESPDistance", { Text = "Distance", Default = false })
espInfo:AddLabel("Distance color"):AddColorPicker("ESPDistanceColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Distance color" })
espInfo:AddToggle("ESPWeapon", { Text = "Weapon", Default = false })
espInfo:AddToggle("ESPTeam", { Text = "Team indicator", Default = false })
espInfo:AddToggle("ESPFriendly", { Text = "Friendly indicator", Default = false, Tooltip = "Marks teammates & Roblox friends" })

-- right: health
local espHealth = Tabs.ESP:AddRightGroupbox("Health")
espHealth:AddToggle("ESPHealth", { Text = "Health", Default = false, Tooltip = "Show health text on players" })
espHealth:AddDropdown("ESPHealthMode", { Text = "Health mode", Values = { "Average", "Target part" }, Default = 1, Multi = false, Tooltip = "Average of all parts, or just the combat target part" })

-- right: flags + arrows
local espFlags = Tabs.ESP:AddRightGroupbox("Flags & Arrows")
espFlags:AddToggle("ESPFlags", { Text = "Status flags", Default = false })
espFlags:AddToggle("ESPFlagIdle", { Text = "Flag: Idle", Default = false })
espFlags:AddToggle("ESPFlagMoving", { Text = "Flag: Moving", Default = false })
espFlags:AddToggle("ESPFlagJumping", { Text = "Flag: Jumping", Default = false })
espFlags:AddToggle("ESPFlagSwimming", { Text = "Flag: Swimming", Default = false })
espFlags:AddDivider()
espFlags:AddToggle("ESPArrows", { Text = "Off-screen arrows", Default = false })
espFlags:AddLabel("Arrow color"):AddColorPicker("ESPArrowColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Arrow color" })
espFlags:AddSlider("ESPArrowSize", { Text = "Arrow size", Default = 14, Min = 8, Max = 40, Rounding = 0 })

-- hook every control to applyESP. OnChanged fires right away on attach and on
-- every change/config load after
local espToggleKeys = {
    "ESPMaster", "ESPBoxes", "ESPBoxOutline", "ESPBoxFill", "ESPNames", "ESPTextOutline", "ESPDistance",
    "ESPWeapon", "ESPTeam", "ESPFriendly", "ESPHealth", "ESPChams", "ESPChamsVisible",
    "ESPFlags", "ESPFlagIdle", "ESPFlagMoving", "ESPFlagJumping", "ESPFlagSwimming", "ESPArrows",
}
local espOptionKeys = {
    "ESPMaxDistance", "ESPBoxType", "ESPBoxColor", "ESPBoxThickness", "ESPBoxOutlineColor", "ESPBoxFillColor",
    "ESPBoxFillTransparency", "ESPNameColor", "ESPTextSize", "ESPDistanceColor", "ESPHealthMode",
    "ESPChamsType", "ESPChamsFill", "ESPChamsFillT", "ESPChamsOutline", "ESPChamsOutlineT",
    "ESPArrowColor", "ESPArrowSize",
}

for _, key in ipairs(espToggleKeys) do
    Toggles[key]:OnChanged(applyESP)
end
for _, key in ipairs(espOptionKeys) do
    Options[key]:OnChanged(applyESP)
end

-- filter drives player tracking, not applyESP
Toggles.ESPFilterTeam:OnChanged(refreshTeamFilter)

applyESP()
refreshTeamFilter()

-- keep enemy list fresh (joins/leaves, team swaps, respawns)
local teamFilterConn
if ESP then
    local acc = 0
    teamFilterConn = RunService.Heartbeat:Connect(function(dt)
        acc = acc + dt
        if acc < 1 then return end
        acc = 0
        refreshTeamFilter()
    end)
end

-- misc tab
local miscMove = Tabs.Misc:AddLeftGroupbox("Movement")
miscMove:AddToggle("omnisprint", { Text = "Omni Sprint", Default = false, Tooltip = "Sprint in any direction" })
Toggles['omnisprint']:OnChanged(function(val) -- omni sprint
    cfg.Combat.OmniSprint = val
end)
miscMove:AddToggle("nohurtslowdown", { Text = "No Hurt Slowdown", Default = false, Tooltip = "Side Effect: Legs will not show as damaged while enabled" })
Toggles['nohurtslowdown']:OnChanged(function(val) -- no hurt slowdown
    cfg.Combat.NoHurtSlowdown = val
end)

local miscHeal = Tabs.Misc:AddLeftGroupbox("Healing")
miscHeal:AddToggle("autoheal", { Text = "Auto Heal", Default = false, Tooltip = "Bandage damaged limbs automatically" })
Toggles['autoheal']:OnChanged(function(val) -- auto heal
    cfg.Combat.AutoHeal = val
end)
miscHeal:AddToggle("instantheal", { Text = "Instant Heal", Default = false, Tooltip = "Heal with no delay" })
Toggles['instantheal']:OnChanged(function(val) -- instant heal
    cfg.Combat.InstantHeal = val
end)
-- below here
local originalHealSpeed = functions.healLimb.upv[7]
local modifiedHealSpeed = {}

local miscBandage = Tabs.Misc:AddRightGroupbox("Bandage")
miscBandage:AddToggle("nobandageslowdown", { Text = "No Bandage Slowdown", Default = false, Tooltip = "Stay at full speed while bandaging" })
Toggles['nobandageslowdown']:OnChanged(function(val) -- no bandage slowdown
    cfg.Combat.NoBandageSlowdown = val

    if val then
        debug.setupvalue(functions.healLimb.func, 7, modifiedHealSpeed)
    else
        debug.setupvalue(functions.healLimb.func, 7, originalHealSpeed)
    end
end)

local miscRevive = Tabs.Misc:AddRightGroupbox("Revive")
miscRevive:AddToggle("fastrevive", { Text = "Fast Revive", Default = false, Tooltip = "Revive teammates faster" })
Toggles['fastrevive']:OnChanged(function(val) -- fast revive
    cfg.Combat.FastRevive = val
end)

local miscVehicle = Tabs.Misc:AddRightGroupbox("Vehicles")
miscVehicle:AddToggle("carmods", { Text = "Car Mods", Default = false, Tooltip = "More speed, torque and handling" })
Toggles['carmods']:OnChanged(function(val) -- car mods
    cfg.Combat.CarMods = val
    applyCarMods()
end)
miscVehicle:AddDropdown("carprofile", { Text = "Car", Values = carEntries, Default = 1, Multi = false, AllowNull = true })
Options.carprofile:OnChanged(function(value)
    selectedCar = value
    local profile = selectedCarProfile()
    if not profile then return end
    for key in pairs(carDefaults) do
        if Options["car_" .. key] then Options["car_" .. key]:SetValue(profile[key]) end
    end
    for key in pairs(carBoolDefaults) do
        if Toggles["car_" .. key] then Toggles["car_" .. key]:SetValue(profile[key]) end
    end
    for key, values in pairs({ ChassisType = { "Wheeled", "Tracked" }, DriveType = { "FWD", "RWD", "AWD" }, Differential = { "Open", "Locked" } }) do
        if Options["car_" .. key] then Options["car_" .. key]:SetValue(profile[key]) end
    end
    for index = -1, 6 do
        local ratio = profile.Ratios and profile.Ratios[index] or 0
        if Options["car_ratio_" .. tostring(index)] then
            Options["car_ratio_" .. tostring(index)]:SetValue(ratio)
        end
    end
    for index = 1, 4 do
        local wheel = profile.Wheels and profile.Wheels[index]
        if Toggles["car_wheel_" .. index .. "_drive"] then
            Toggles["car_wheel_" .. index .. "_drive"]:SetValue(wheel and wheel.Drive == true or true)
        end
        if Toggles["car_wheel_" .. index .. "_steer"] then
            Toggles["car_wheel_" .. index .. "_steer"]:SetValue(wheel and wheel.Steer == 1 or index <= 2)
        end
    end
    syncCarProfileJson()
    applyCarMods()
end)
miscVehicle:AddLabel("Saved profiles are stored per car and faction")

local carSliderInfo = {
    { "FinalDrive", "Final Drive", 0, 20, 2 }, { "ShiftRPM", "Shift RPM", 1000, 15000, 0 },
    { "IdleRPM", "Idle RPM", 0, 5000, 0 }, { "IdleTorque", "Idle Torque", 0, 2000, 0 },
    { "PeakTorque", "Peak Torque", 0, 3000, 0 }, { "PeakTorqueRPM", "Peak Torque RPM", 0, 15000, 0 },
    { "RedlineRPM", "Redline RPM", 1000, 20000, 0 }, { "RedlineTorque", "Redline Torque", 0, 3000, 0 },
    { "HorsepowerLimit", "Horsepower Limit", 0, 3000, 0 }, { "TorqueScale", "Torque Scale", 0, 20, 2 },
    { "TopSpeed", "Top Speed", 0, 500, 0 }, { "PeakGrip", "Peak Grip", 0, 10, 2 },
    { "SlideGrip", "Slide Grip", 0, 10, 2 }, { "PeakSlip", "Peak Slip", 0, 5, 2 },
    { "Grip", "Grip", 0, 200, 1 }, { "BrakeMultiplier", "Brake Multiplier", 0, 50, 2 },
    { "HandBrakeMultiplier", "Handbrake Multiplier", 0, 50, 2 }, { "RollingFriction", "Rolling Friction", 0, 2, 2 },
    { "TurningZForceMultiplier", "Turning Z Force", 0, 10, 2 }, { "TurnRadius", "Turn Radius", 0, 100, 1 },
    { "SteerSpeed", "Steer Speed", 0, 20, 2 }, { "HighSpeedSteerReduction", "High Speed Steering", 0, 1, 2 },
    { "ForceHeight", "Force Height", -5, 5, 2 }, { "Mass", "Mass", 0, 5000, 0 },
    { "WheelMass", "Wheel Mass", 0, 100, 1 }, { "SuspensionHeight", "Suspension Height", 0, 10, 2 },
    { "RideHeight", "Ride Height", -5, 10, 2 }, { "WheelOffset", "Wheel Offset", -5, 5, 2 },
    { "ReboundDampingModifier", "Rebound Damping", 0, 10, 2 },
    { "CompressionDampingModifier", "Compression Damping", 0, 10, 2 },
    { "DamperActiveness", "Damper Activeness", 0, 2, 2 },
}
for index, label in ipairs({ "Reverse", "Neutral", "Gear 1", "Gear 2", "Gear 3", "Gear 4", "Gear 5", "Gear 6" }) do
    local key = index - 2
    local control = "car_ratio_" .. tostring(key)
    miscVehicle:AddSlider(control, { Text = label .. " Ratio", Default = 0, Min = -15, Max = 15, Rounding = 3 })
    Options[control]:OnChanged(function(value)
        local profile = selectedCarProfile()
        if not profile then return end
        profile.Ratios = profile.Ratios or {}
        profile.Ratios[key] = value
        syncCarProfileJson()
        applyCarMods()
    end)
end
for index, label in ipairs({ "Front Left", "Front Right", "Rear Left", "Rear Right" }) do
    local prefix = "car_wheel_" .. index .. "_"
    miscVehicle:AddToggle(prefix .. "drive", { Text = label .. " Drive", Default = true })
    miscVehicle:AddToggle(prefix .. "steer", { Text = label .. " Steer", Default = index <= 2 })
    Toggles[prefix .. "drive"]:OnChanged(function(value)
        local profile = selectedCarProfile()
        if not profile then return end
        profile.Wheels = profile.Wheels or {}
        profile.Wheels[index] = profile.Wheels[index] or { Name = label:gsub(" ", ""), Drive = true, Steer = index <= 2 and 1 or 0 }
        profile.Wheels[index].Drive = value
        syncCarProfileJson()
        applyCarMods()
    end)
    Toggles[prefix .. "steer"]:OnChanged(function(value)
        local profile = selectedCarProfile()
        if not profile then return end
        profile.Wheels = profile.Wheels or {}
        profile.Wheels[index] = profile.Wheels[index] or { Name = label:gsub(" ", ""), Drive = true, Steer = index <= 2 and 1 or 0 }
        profile.Wheels[index].Steer = value and 1 or 0
        syncCarProfileJson()
        applyCarMods()
    end)
end
for _, info in ipairs(carSliderInfo) do
    local key, text, min, max, rounding = table.unpack(info)
    miscVehicle:AddSlider("car_" .. key, { Text = text, Default = carDefaults[key], Min = min, Max = max, Rounding = rounding })
    Options["car_" .. key]:OnChanged(function(value) setCarControlValue(key, value) end)
end
for key, default in pairs(carBoolDefaults) do
    miscVehicle:AddToggle("car_" .. key, { Text = key, Default = default })
    Toggles["car_" .. key]:OnChanged(function(value) setCarControlValue(key, value) end)
end
for key, values in pairs({ ChassisType = { "Wheeled", "Tracked" }, DriveType = { "FWD", "RWD", "AWD" }, Differential = { "Open", "Locked" } }) do
    miscVehicle:AddDropdown("car_" .. key, { Text = key, Values = values, Default = carChoiceDefaults[key], Multi = false })
    Options["car_" .. key]:OnChanged(function(value) setCarControlValue(key, value) end)
end
miscVehicle:AddInput("carsprofiles", { Text = "Profile data", Default = "{}" })
Options.carsprofiles:OnChanged(function(value)
    loadCarProfileJson(value)
    syncCarProfileJson()
    applyCarMods()
end)
if selectedCar then Options.carprofile:SetValue(selectedCar) end

-- settings tab (menu + config)
local menuGroup = Tabs.Settings:AddLeftGroupbox("Menu")

local DiscordInvite = "NUfjhQcETc"

-- opens an invite straight in the desktop discord client. discord runs a local rpc
-- server on one of ports 6463-6472; the INVITE_BROWSER command pops the invite. the
-- Origin header has to look like discord.com or the rpc rejects it
local function openDiscordInvite(code)
    local request = http_request or request or (syn and syn.request)
        or (fluxus and fluxus.request) or (getgenv and getgenv().request)
    if not request then
        Library:Notify("No HTTP request function on this executor.")
        return
    end
    local body = HttpService:JSONEncode({
        cmd = "INVITE_BROWSER",
        args = { code = code },
        nonce = HttpService:GenerateGUID(false),
    })
    local opened = false
    for port = 6463, 6472 do
        local ok, res = pcall(request, {
            Url = ("http://127.0.0.1:%d/rpc?v=1"):format(port),
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["Origin"] = "https://discord.com",
            },
            Body = body,
        })
        if ok and res and (res.StatusCode == 200 or res.Success) then
            opened = true
            break
        end
    end
    Library:Notify(opened and "Opened the invite in Discord." or "Couldn't reach Discord (is it running?).")
end

menuGroup:AddButton({
    Text = "Join Discord",
    Func = function()
        openDiscordInvite(DiscordInvite)
    end,
})
menuGroup:AddButton({
    Text = "Unload",
    Func = function()
        Library:Unload()
    end,
})
menuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
menuGroup:AddToggle("ShowKeybindList", { Text = "Show Keybind List", Default = true, Tooltip = "Shows the active keybind list overlay" }):OnChanged(function(val)
    if Library and Library.KeybindFrame then
        Library.KeybindFrame.Visible = val
    end
end)

-- menu open/close key
Library.ToggleKeybind = Options.MenuKeybind

-- kill esp on unload
Library:OnUnload(function()
    if teamFilterConn then
        teamFilterConn:Disconnect()
        teamFilterConn = nil
    end
    pcall(function() RunService:UnbindFromRenderStep("cwfov") end)
    pcall(function() RunService:UnbindFromRenderStep("cwsnap") end)
    if bandageConn then bandageConn:Disconnect() bandageConn = nil end
    if healConn then healConn:Disconnect() healConn = nil end
    if reviveConn then reviveConn:Disconnect() reviveConn = nil end
    if carModsConn then carModsConn:Disconnect() carModsConn = nil end
    if ragebotThread then pcall(task.cancel, ragebotThread) ragebotThread = nil end
    if fovGui then
        fovGui:Destroy()
        fovGui = nil
    end
    if snapGui then
        snapGui:Destroy()
        snapGui = nil
    end
    if ESP then
        pcall(function() ESP:Unload() end)
    end
end)

-- config + theme
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("VaultCC")
SaveManager:SetFolder("VaultCC/ColdWar")

-- builds the config save/load ui into settings
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

-- load autoload cfg last (fires OnChanged -> applyESP)
SaveManager:LoadAutoloadConfig()

if Library and Library.KeybindFrame then
    Library.KeybindFrame.Visible = true
end

Library:Notify("Cold War loaded, made with love by vaultt. <3")
