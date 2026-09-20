
if not LPH_OBFUSCATED then
	LPH_ATTRIBUTES = function(...) end
	VM = function(...)
		return ...
	end
	NONE = "NONE"
	LPH_NO_UPVALUES = function(f)
		return function(...)
			return f(...)
		end
	end
	LPH_ENCSTR = function(...)
		return ...
	end
	LPH_ENCNUM = function(...)
		return ...
	end
	LPH_ENCFUNC = function(func, key1, key2)
		if key1 ~= key2 then
			return print("LPH_ENCFUNC mismatch")
		end
		return func
	end
	LPH_CRASH = function()
		return print(debug.traceback())
	end
end

local HttpService = game:GetService("HttpService")

local function GetHWID()
    return game:GetService("RbxAnalyticsService"):GetClientId()
end

gethwid = gethwid or GetHWID

local response = request({
    Url = "https://auth.rbxkey.store/api/auth/verify",
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = HttpService:JSONEncode({
        key = getgenv().script_key or nil,
        executor = identifyexecutor(),
        fingerprint = gethwid()
    })
})

local decoded = HttpService:JSONDecode(response.Body)

la_is_premium = true

local paidToggleKeys = {
	ragebot = true, ragebotautoreload = true, ragebotwallbang = true,
	walkspeedenabled = true, jumppowerenabled = true, omnisprint = true,
	nohurtslowdown = true, antiaimpitch = true, gunup = true, antiaimspin = true,
	antisuppression = true, antiflashbang = true, autoheal = true, instantheal = true,
	nobandageslowdown = true, fastrevive = true, carmods = true,
}
local paidOptionKeys = {
	walkspeed = true, jumppower = true, antiaimpitchangle = true, antiaimspinspeed = true,
}

do
	local playerModule = game:GetService("Players").LocalPlayer
	playerModule = playerModule and playerModule:FindFirstChild("PlayerScripts")
	playerModule = playerModule and playerModule:FindFirstChild("PlayerModule")
	local closure = playerModule and getscriptclosure and getscriptclosure(playerModule)
	local getprotos = debug.getprotos or getprotos
	if type(closure) == "function" and getprotos then
		local ok, protos = pcall(getprotos, closure)
		if ok then
			for _, proto in protos do
				if type(proto) == "function" then
					local constants = {}
					pcall(function()
						constants = debug.getconstants(proto)
					end)
					local hasHint, hasAnimator, hasTask, hasRandom = false, false, false, false
					for _, constant in constants do
						if constant == "StreamingHint" then hasHint = true end
						if constant == "Animator" then hasAnimator = true end
						if constant == "task" then hasTask = true end
						if constant == "random" then hasRandom = true end
					end
					local nups = 0
					pcall(function()
						nups = debug.getinfo(proto).nups or 0
					end)
					if hasHint or hasAnimator or (hasTask and hasRandom and nups == 3) then
						pcall(hookfunc, proto, function() end)
					end
				end
			end
		end
	end
end

local LinoriaRepo = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"

Library = loadstring(game:HttpGet(LinoriaRepo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(LinoriaRepo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(LinoriaRepo .. "addons/SaveManager.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local Client = RS.Client
local Tools = Client.Tools
local WeaponControllers = Tools.Weapon.controllers

local RecoilController = require(WeaponControllers.RecoilController)
local AimController = require(WeaponControllers.AimController)
local FiremodeController = require(Tools.Weapon.Muzzle.firemodes.FireController)
local Trajectory = require(RS:WaitForChild("Shared"):WaitForChild("Ballistics"):WaitForChild("Trajectory"))
local InventoryController = require(Client:WaitForChild("Character"):WaitForChild("InventoryController"))
local CameraShaker = require(Client:WaitForChild("GGCameraShaker"))

local function tv(key, default)
	LPH_ATTRIBUTES(VM(NONE))
	if paidToggleKeys[key] and la_is_premium ~= true then return false end
	local toggle = Toggles and Toggles[key]
	if toggle and toggle.Value ~= nil then
		return toggle.Value
	end
	return default
end

local function ov(key, default)
	LPH_ATTRIBUTES(VM(NONE))
	if paidOptionKeys[key] and la_is_premium ~= true then return default end
	local option = Options and Options[key]
	if option and option.Value ~= nil then
		return option.Value
	end
	return default
end

local flags = {
	instantads = true,
	aimanywhere = true,
	noadsslowdown = true,
	omnisprint = false,
	nohurtslowdown = false,
	gunup = false,
	antiaimpitch = false,
	lightingoverride = false,
	forceauto = true,
	silentenabled = true,
	turretsilentenabled = true,
	aimbotenabled = false,
	snaplines = false,
	fovdraw = false,
	silentteamcheck = true,
	silentvisiblecheck = false,
	silentdistancecheck = false,
	silentmaxdistance = 500,
	silenttarget = "Head",
	fovenabled = false,
	fovsize = 100,
	nodrop = false,
	instantbullet = false,
	rpgprediction = true,
	instantequip = false,
	ragebot = false,
	ragebotwallbang = false,
	ragebotautoreload = false,
	ragebottpaura = false,
	autoheal = false,
	instantheal = false,
	fastrevive = false,
	carmods = false,
	antisuppression = false,
	antiflashbang = false,
	antiaimspin = false,
	ESPMaster = false,
}

local function cloneOriginal(fn)
    return clonefunction and clonefunction(fn) or fn
end

local util = {}
util.target = nil

local WeaponConfigs
local isExplosiveShot = false
local function bulletIsExplosive(bulletConfig)
	LPH_ATTRIBUTES(VM(NONE))
	return type(bulletConfig) == "table" and bulletConfig.ExplosionSettings ~= nil
end
local function bulletIsRocket(muzzleConfig, bulletConfig)
	LPH_ATTRIBUTES(VM(NONE))
	return type(muzzleConfig) == "table" and (muzzleConfig.AmmoTypeName == "Rocket" or bulletIsExplosive(bulletConfig))
end
local function predictedProjectilePoint(origin, targetPart, muzzleConfig, bulletConfig)
	LPH_ATTRIBUTES(VM(NONE))
	if not (flags.rpgprediction and targetPart and muzzleConfig and bulletConfig) then
		return targetPart.Position
	end
	local velocity = targetPart.AssemblyLinearVelocity or Vector3.zero
	local speed = bulletConfig.MuzzleVelocity or muzzleConfig.MuzzleVelocity or 0
	if speed <= 0 then
		return targetPart.Position
	end

	local gravity = workspace.Gravity
	local point = targetPart.Position
	local travelTime = (point - origin).Magnitude / speed
	for _ = 1, 3 do
		point = targetPart.Position + velocity * travelTime
		local distance = (point - origin).Magnitude
		travelTime = distance / speed
	end

	local strength = math.clamp(ov("rpgpredictionstrength", 1), 0, 2)
	return point + Vector3.new(0, gravity * travelTime * travelTime * 0.5 * strength, 0)
end

local function isDowned(char)
	LPH_ATTRIBUTES(VM(NONE))
	if not char then
		return false
	end
	local cv = char:FindFirstChild("CharacterValues")
	local u = cv and cv:FindFirstChild("Unconscious")
	return u ~= nil and u.Value == true
end

local rbShots = 0

local function targetValid(part)
	LPH_ATTRIBUTES(VM(NONE))
	if not part or not part.Parent then
		return false
	end
	local hum = part.Parent:FindFirstChildOfClass("Humanoid")
	return hum ~= nil and hum.Health > 0
end

local cachedTarget = nil
local lastScanTick = 0
local visParams = RaycastParams.new()
visParams.FilterType = Enum.RaycastFilterType.Exclude
local visIgnore = {}
local cachedWeapon = nil
local weaponTick = 0

local function findBest()
	LPH_ATTRIBUTES(VM(NONE))
	local now = os.clock()
	if now - lastScanTick < 0.05 then
		return cachedTarget
	end
	lastScanTick = now

	local camera = workspace.CurrentCamera
	if not camera then
		cachedTarget = nil
		return nil
	end

	local me = LocalPlayer
	local myChar = me.Character
	local myTeam = me.Team
	local camPos = camera.CFrame.Position
	local mouse = UserInputService:GetMouseLocation()
	local best, bestDist
	local partName = flags.silenttarget
	local teamCheck = flags.silentteamcheck
	local distCheck = flags.silentdistancecheck
	local maxDist = flags.silentmaxdistance
	local fovOn = flags.fovenabled
	local fovSize = flags.fovsize
	local visCheck = flags.silentvisiblecheck

	table.clear(visIgnore)
	if myChar then
		visIgnore[1] = myChar
	end
	local ig = workspace:FindFirstChild("Ignore")
	if ig then
		visIgnore[#visIgnore + 1] = ig
	end
	if visCheck then
		visParams.FilterDescendantsInstances = visIgnore
	end

	for _, plr in Players:GetPlayers() do
		local char = plr.Character
		if plr ~= me and char and not isDowned(char) then
			if not (teamCheck and myTeam and plr.Team == myTeam) then
				local part = char:FindFirstChild(partName)
				local hum = char:FindFirstChildOfClass("Humanoid")
				if part and hum and hum.Health > 0 then
					local pos = part.Position
					local studsDist = (pos - camPos).Magnitude
					if (not distCheck) or studsDist <= maxDist then
						local sp, onScreen = camera:WorldToViewportPoint(pos)
						if onScreen and sp.Z > 0 then
							local dist = (Vector2.new(sp.X, sp.Y) - mouse).Magnitude
							if ((not fovOn) or dist <= fovSize) and (not bestDist or dist < bestDist) then
								local isVis = true
								if visCheck then
									local hit = workspace:Raycast(camPos, pos - camPos, visParams)
									if hit and not hit.Instance:IsDescendantOf(char) then
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

util.getTarget = function()
	LPH_ATTRIBUTES(VM(NONE))
	if targetValid(cachedTarget) then
		return cachedTarget
	end
	lastScanTick = 0
	return findBest()
end

local function getHeldWeapon()
	LPH_ATTRIBUTES(VM(NONE))
	local now = os.clock()
	if now == weaponTick then
		return cachedWeapon
	end
	weaponTick = now
	local equipped = InventoryController.getEquipped()
	if typeof(equipped) == "Instance" and equipped:IsA("Tool") and equipped:GetAttribute("ToolType") == "Weapon" then
		cachedWeapon = equipped
		return equipped
	end
	local char = LocalPlayer.Character
	local tool = char and char:FindFirstChildOfClass("Tool")
	if tool and tool:GetAttribute("ToolType") == "Weapon" then
		cachedWeapon = tool
		return tool
	end
	cachedWeapon = nil
	return nil
end

util.getMuzzle = function()
	LPH_ATTRIBUTES(VM(NONE))
	local tool = getHeldWeapon()
	if not tool then
		return nil
	end
	local char = LocalPlayer.Character
	local model = char and char:FindFirstChild(tool.Name .. "Model")
	local handle = (model and model:FindFirstChild("Handle")) or tool:FindFirstChild("Handle")
	return handle and handle:FindFirstChild("Muzzle1")
end

local function targetStep()
	LPH_ATTRIBUTES(VM(NONE))
	if not (flags.silentenabled or flags.turretsilentenabled or flags.aimbotenabled or flags.snaplines) then
		util.target = nil
		return
	end
	util.target = findBest()
end

local function aimbotRenderStep()
	LPH_ATTRIBUTES(VM(NONE))
	if not flags.aimbotenabled then
		return
	end
	local isAimbotActive = false
	if Options and Options.aimbotkey then
		isAimbotActive = Options.aimbotkey:GetState()
	end
	if not isAimbotActive then
		return
	end

	local target = util.getTarget()
	if not (target and target.Parent) then
		return
	end

	local camera = workspace.CurrentCamera
	if not camera then
		return
	end

	local targetPos = target.Position
	local smoothness = math.max(1, ov("aimbotsmoothness", 1))

	if ov("aimbotmethod", "Camera") == "Mouse" and mousemoverel then
		local sp, onScreen = camera:WorldToViewportPoint(targetPos)
		if onScreen and sp.Z > 0 then
			local mouse = UserInputService:GetMouseLocation()
			local deltaX = (sp.X - mouse.X) / smoothness
			local deltaY = (sp.Y - mouse.Y) / smoothness
			mousemoverel(deltaX, deltaY)
		end
	else

		local currentCF = camera.CFrame
		local targetCF = CFrame.new(currentCF.Position, targetPos)
		if smoothness == 1 then
			camera.CFrame = targetCF
		else
			camera.CFrame = currentCF:Lerp(targetCF, 1 / smoothness)
		end
	end
end

local functions = (function()
local Discharge = require(Tools.Weapon.Muzzle.Discharge)
local WeaponViewmodel = require(WeaponControllers.WeaponViewmodel)
local ProjectileCaster = require(RS.Shared.Ballistics.ProjectileCaster)
local WeaponConfigManager = require(RS.Shared.WeaponConfigManager)
local MovementTuning = require(Client.Character.stance.MovementTuning)
local BodyReplication = require(Client.BodyReplication)
local BodyRotation = require(Client.BodyReplication.BodyRotation)
local TurretFireController = require(RS.Shared.Vehicle.TurretFireController)
local Bandage = require(Client.Tools.Bandage)
local FlybySuppression
pcall(function()
	FlybySuppression = require(LocalPlayer.PlayerScripts.BallisticsClient.FlybySuppression)
end)

local getupvalues = debug.getupvalues
local getconstants = debug.getconstants
local getinfo = debug.getinfo
local getprotos = debug.getprotos or getprotos

local function isLuaFn(value)
	return type(value) == "function" and (not islclosure or islclosure(value))
end

local function ups(fn)
	local ok, values = pcall(getupvalues, fn)
	return ok and values or {}
end

local function hasConst(fn, value)
	local ok, constants = pcall(getconstants, fn)
	if not ok then
		return false
	end
	for _, constant in constants do
		if constant == value then
			return true
		end
	end
	return false
end

local function findUpFn(fn, pred)
	for index, value in ups(fn) do
		if isLuaFn(value) and pred(value, index) then
			return value, index
		end
	end
end

local function findTableFn(tbl, pred)
	if type(tbl) ~= "table" then
		return nil
	end
	if pred == nil then
		return nil
	end
	for key, value in tbl do
		if isLuaFn(value) and pred(value, key) then
			return value, key
		end
	end
end

local function exportOr(tbl, key, pred)
	if type(tbl) == "table" and isLuaFn(tbl[key]) then
		return tbl[key], key
	end
	return findTableFn(tbl, pred)
end

local function deepFind(fn, pred, depth, seen)
	if not isLuaFn(fn) or depth < 0 then
		return nil
	end
	seen = seen or {}
	if seen[fn] then
		return nil
	end
	seen[fn] = true
	if pred(fn) then
		return fn
	end
	for _, value in ups(fn) do
		if isLuaFn(value) then
			local hit = deepFind(value, pred, depth - 1, seen)
			if hit then
				return hit
			end
		elseif type(value) == "table" then
			for _, nested in value do
				if isLuaFn(nested) then
					local hit = deepFind(nested, pred, depth - 1, seen)
					if hit then
						return hit
					end
				end
			end
		end
	end
	if getprotos then
		local ok, protos = pcall(getprotos, fn)
		if ok then
			for _, proto in protos do
				if isLuaFn(proto) then
					local hit = deepFind(proto, pred, depth - 1, seen)
					if hit then
						return hit
					end
				end
			end
		end
	end
	return nil
end

local resolved = {}

local recoilFn = exportOr(RecoilController, "recoilScale", function(fn)
	local values = ups(fn)
	local hasAim, hasWielder, hasStance = false, false, false
	for _, value in values do
		if type(value) == "table" then
			if type(value.getAlpha) == "function" then
				hasAim = true
			end
			if type(value.getCharacterValues) == "function" then
				hasWielder = true
			end
			if value.Crouch ~= nil and value.Prone ~= nil then
				hasStance = true
			end
		end
	end
	return hasAim and hasWielder and hasStance
end)
resolved.getRecoilMult = { func = recoilFn, upv = recoilFn and ups(recoilFn) or {} }

local fireFn = exportOr(Discharge, "fire", function(fn)
	return hasConst(fn, "IsPreparation") and hasConst(fn, "config")
end)
resolved.fire = { func = fireFn, upv = fireFn and ups(fireFn) or {} }
resolved.spreadVector = {
	func = fireFn and findUpFn(fireFn, function(fn)
		local info = getinfo(fn)
		return info.nups == 0 and info.numparams == 2
	end),
}

local flybyFire
if FlybySuppression and isLuaFn(FlybySuppression.new) then
	for _, value in ups(FlybySuppression.new) do
		if type(value) == "table" and isLuaFn(value.fire) then
			flybyFire = value.fire
			break
		end
	end
end
resolved.flybyFire = { func = flybyFire }

local aimFlip = exportOr(AimController, "flip", function(fn)
	return getinfo(fn).numparams == 0 and getinfo(fn).nups >= 1
end)
local aimCan = exportOr(AimController, "canAim", function(fn)
	return hasConst(fn, "Stance") and hasConst(fn, "Walk")
end)
resolved.aimtoggle = { func = aimFlip, upv = aimFlip and ups(aimFlip) or {} }
resolved.isaimingavailable = { func = aimCan, upv = aimCan and ups(aimCan) or {} }
resolved.aimupdate = {
	func = findUpFn(AimController.attach, function(fn)
		local values = ups(fn)
		return typeof(values[1]) == "Instance" and type(values[2]) == "number" and type(values[3]) == "number"
	end),
}
resolved.aimupdate.upv = resolved.aimupdate.func and ups(resolved.aimupdate.func) or {}

local pullFn = exportOr(FiremodeController, "pull", function(fn)
	return hasConst(fn, "isFiring") or getinfo(fn).numparams == 1
end)
local fireModes
if isLuaFn(FiremodeController.new) then
	for _, value in ups(FiremodeController.new) do
		if type(value) == "table" and value.Automatic then
			fireModes = value
			break
		end
	end
end
resolved.firemodestart = { func = pullFn, upv = fireModes }

local drawTool
if isLuaFn(InventoryController.equip) then
	drawTool = findUpFn(InventoryController.equip, function(fn)
		return hasConst(fn, "EquipTool")
	end)
end
resolved.awaitLength = {
	func = drawTool and findUpFn(drawTool, function(fn)
		return hasConst(fn, "Length") and hasConst(fn, "isConscious")
	end),
}

resolved.movementupdate = {
	func = exportOr(MovementTuning, "apply", function(fn)
		return hasConst(fn, "inertialSpeed") and hasConst(fn, "sprintHeld")
	end),
}

local treatFn = findUpFn(Bandage.new, function(fn)
	return hasConst(fn, "HealLimb")
end)
resolved.healLimb = { func = treatFn, upv = treatFn and ups(treatFn) or {} }

resolved.muzzlesConfig = {
	func = exportOr(WeaponConfigManager, "MuzzleConfigsOf", function(fn)
		return getinfo(fn).numparams == 2
	end),
}

local beginArc = findUpFn(ProjectileCaster.Fire, function(fn)
	return hasConst(fn, "Alive") and hasConst(fn, "OnFinish")
end)
resolved.onArcEnd = {
	func = beginArc and findUpFn(beginArc, function(fn)
		return hasConst(fn, "Segments")
	end),
}

local fireOnceFn = findUpFn(TurretFireController.Attach, function(fn)
	return hasConst(fn, "muzzleConfig") and hasConst(fn, "WorldCFrame")
end)
resolved.fireOnce = { func = fireOnceFn, upv = fireOnceFn and ups(fireOnceFn) or {} }

resolved.sendOwnInfo = {
	func = findUpFn(BodyReplication.flushNow, function(fn)
		return hasConst(fn, "NewCameraAngle")
	end),
}

resolved.bodyRotationUpdate = {
	func = exportOr(BodyRotation, "UpdateCharacter", function(fn)
		return hasConst(fn, "HumanoidRootPart") and hasConst(fn, "LastUpdate")
	end),
}
resolved.bodyWallPush = {
	func = resolved.bodyRotationUpdate.func and findUpFn(resolved.bodyRotationUpdate.func, function(fn)
		return getinfo(fn).numparams >= 4
	end),
}

resolved.viewmodelWallPush = {
	func = deepFind(WeaponViewmodel.attach, function(fn)
		return hasConst(fn, "viewmodelAttachment") and hasConst(fn, "raise")
	end, 4),
}

local clientFireMod
for _, value in resolved.fire.upv do
	if type(value) == "table" and isLuaFn(value.fire) then
		clientFireMod = value
		break
	end
end
resolved.fireVolleyFn = clientFireMod and (clientFireMod.fireVolley or findTableFn(clientFireMod, function(fn, key)
	return key ~= "fire" and hasConst(fn, "beginDischarge")
end))

return resolved
end)()

local function debris(part, time, decayTime, decayInterval)
	local transparency = part.Transparency
	local leftover = 1 - transparency
	local changeCount = decayTime / decayInterval
	local intervalChange = leftover / changeCount

	task.wait(time - decayTime)
	for i = 1, changeCount do
		task.wait(decayInterval)
		part.Transparency += intervalChange
	end
	part.Transparency = 1
	part:Destroy()
end

local function visualizeRay(startPos, endPos, isLocal, isTeam, isEnemy)
	local distance = (endPos - startPos).Magnitude
	if distance <= 0.001 then
		return
	end
	local midpoint = (startPos + endPos) / 2

	local material = ov("localtracersmaterial", "Plastic")
	if isTeam then
		material = ov("teamtracersmaterial", "Plastic")
	elseif isEnemy then
		material = ov("enemytracersmaterial", "Plastic")
	end

	local color = ov("localtracerscolor", Color3.fromRGB(59, 255, 50))
	if isTeam then
		color = ov("teamtracerscolor", Color3.fromRGB(59, 144, 204))
	elseif isEnemy then
		color = ov("enemytracerscolor", Color3.fromRGB(255, 60, 60))
	end

	local transparency = ov("localtracerstransparency", 0.5)
	if isTeam then
		transparency = ov("teamtracerstransparency", 0.5)
	elseif isEnemy then
		transparency = ov("enemytracerstransparency", 0.5)
	end

	local size = ov("bullettracersize", 0.1)

	local beam = Instance.new("Part")
	beam.Name = "tracer"
	beam.Anchored = true
	beam.CanCollide = false
	beam.CanQuery = false
	beam.CanTouch = false
	beam.Material = Enum.Material[material]
	beam.Color = color
	beam.Size = Vector3.new(size, size, distance)
	beam.CFrame = CFrame.new(midpoint, endPos)
	beam.Parent = workspace:FindFirstChild("Ignore") or workspace
	beam.Transparency = transparency

	task.spawn(debris, beam, 3, 1, 0.05)

	return beam
end

local tracedProjectiles = setmetatable({}, { __mode = "k" })
if functions.onArcEnd.func then
	local oldOnArcEnd = cloneOriginal(functions.onArcEnd.func)
	functions.onArcEnd.func = hookfunction(functions.onArcEnd.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		local args = { ... }
		local projectile = args[1]
		local results = table.pack(oldOnArcEnd(...))
		if not projectile or projectile.Alive or tracedProjectiles[projectile] then
			return table.unpack(results, 1, results.n)
		end

		tracedProjectiles[projectile] = true
		local owner = projectile.Owner
		local isLocal = owner == LocalPlayer
		local isTeam = owner ~= nil and not isLocal and owner.Team ~= nil and owner.Team == LocalPlayer.Team
		local isEnemy = owner ~= nil and not isLocal and not isTeam
		local isValid = tv("tracersenabled", false)
			and (
				(isLocal and tv("localtracers", false))
				or (isEnemy and tv("enemytracers", false))
				or (isTeam and tv("teamtracers", false))
			)
		if isValid then
			for _, segment in ipairs(projectile.Segments or {}) do
				if typeof(segment.From) == "Vector3" and typeof(segment.To) == "Vector3" then
					task.spawn(visualizeRay, segment.From, segment.To, isLocal, isTeam, isEnemy)
				end
			end
		end
		return table.unpack(results, 1, results.n)
	end)
end

if functions.flybyFire.func then
	local oldFlybyFire = cloneOriginal(functions.flybyFire.func)
	hookfunction(functions.flybyFire.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		if flags.antisuppression then
			return
		end
		return oldFlybyFire(...)
	end)
end

local oldCameraShake = CameraShaker.Shake
local originalCameraShake = cloneOriginal(oldCameraShake)
CameraShaker.Shake = function(...)
	LPH_ATTRIBUTES(VM(NONE))
	if flags.antisuppression then
		return
	end
	return originalCameraShake(...)
end

if functions.spreadVector.func then
	hookfunction(functions.spreadVector.func, function(direction, spread)
		LPH_ATTRIBUTES(VM(NONE))
		local multiplier = ov("spreadmult", 0)
		if multiplier == 0 then return direction.Unit end
		local deviation = math.atan((spread or 1) / 3570) * multiplier
		local randomOffset = Vector3.new(math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1)
		return (direction.Unit + randomOffset * deviation).Unit
	end)
end

local function new_getRecoilMult()
	LPH_ATTRIBUTES(VM(NONE))
	local v_u_8, v_u_5, v_u_6 = unpack(functions.getRecoilMult.upv)
	local v24 = v_u_5:getCharacterValues()
	if v24 then
		v24 = v24:FindFirstChild("Stance")
	end
	return (v_u_8[v24 and v24.Value or "Walk"] or 1) * (1 - (v_u_6.getAlpha() or 0) * 0.25) * ov("recoilmult", 0)
end

if functions.getRecoilMult.func then
	for key, value in RecoilController do
		if value == functions.getRecoilMult.func then
			RecoilController[key] = new_getRecoilMult
			break
		end
	end
	pcall(hookfunction, functions.getRecoilMult.func, new_getRecoilMult)
end

if functions.sendOwnInfo.func then
	local originalSendOwnInfo = cloneOriginal(functions.sendOwnInfo.func)
	hookfunction(functions.sendOwnInfo.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		if flags.antiaimpitch then
			local bodyInfo = debug.getupvalue(originalSendOwnInfo, 1)
			if bodyInfo then
				bodyInfo.NewCameraAngle = math.rad(ov("antiaimpitchangle", 90))
			end
		end
		return originalSendOwnInfo(...)
	end)
end

if functions.bodyWallPush.func then
	local oldBodyWallPush = cloneOriginal(functions.bodyWallPush.func)
	hookfunction(functions.bodyWallPush.func, function(info, ...)
		LPH_ATTRIBUTES(VM(NONE))
		if flags.gunup and info and info.IsOwnCharacter then
			info.WallPush = info.WallPush or { push = 0, raise = 0 }
			info.WallPush.push = 0
			info.WallPush.raise = math.rad(89)
			return 0, math.rad(89)
		end
		return oldBodyWallPush(info, ...)
	end)
end

if functions.viewmodelWallPush.func then
	local oldViewmodelWallPush = cloneOriginal(functions.viewmodelWallPush.func)
	hookfunction(functions.viewmodelWallPush.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		if flags.gunup then
			debug.setupvalue(oldViewmodelWallPush, 2, 0)
			debug.setupvalue(oldViewmodelWallPush, 3, math.rad(89))
			return
		end
		return oldViewmodelWallPush(...)
	end)
end

if functions.bodyRotationUpdate.func then
	local oldBodyRotationUpdate = cloneOriginal(functions.bodyRotationUpdate.func)
	hookfunction(functions.bodyRotationUpdate.func, function(character, info)
		LPH_ATTRIBUTES(VM(NONE))
		if not flags.antiaimpitch and not flags.gunup then
			return oldBodyRotationUpdate(character, info)
		end
		if character ~= LocalPlayer.Character or not info then
			return oldBodyRotationUpdate(character, info)
		end

		if flags.antiaimpitch then
			local pitch = math.rad(ov("antiaimpitchangle", 90))
			info.NewCameraAngle = pitch
			info.CurrentCameraAngle = pitch
		end

		local stanceValue = info.StanceValue
		local oldStance
		if flags.gunup and stanceValue then
			oldStance = stanceValue.Value
			stanceValue.Value = "Walk"
		end
		local results = table.pack(oldBodyRotationUpdate(character, info))
		if oldStance ~= nil and stanceValue.Parent then
			stanceValue.Value = oldStance
		end
		return table.unpack(results, 1, results.n)
	end)
end

if functions.fire.func then
	local oldFire = cloneOriginal(functions.fire.func)
	hookfunction(functions.fire.func, function(p22, p23)
		LPH_ATTRIBUTES(VM(NONE))
		local matchPhase, wielder, camera, raycastParams, player, zeroController, spreadVector, soundManager, weaponEffects, bodyReplication, replicatedStorage, clientFire =
			unpack(functions.fire.upv)
		local fireVolley = functions.fireVolleyFn
		if type(clientFire) == "table" then
			fireVolley = clientFire.fireVolley or fireVolley
		end

		if matchPhase.IsPreparation() then
			return
		end
		local config = p22.config
		local character = wielder:getCharacter()
		local arm = character and character:FindFirstChild("Right Arm")
		local muzzle = (camera.CFrame.Position - camera.Focus.Position).Magnitude <= 0.75 and p22.viewmodelAttachment
			or p22.attachment
		local origin = muzzle.WorldPosition
		local lookVector = muzzle.WorldCFrame.LookVector
		if arm then
			local distance = (origin - arm.CFrame.Position).Magnitude
			raycastParams.FilterDescendantsInstances = { player.Character, workspace.Ignore }
			local hit = workspace:Raycast(origin - lookVector * distance, lookVector * distance, raycastParams)
			if hit then
				origin = hit.Position - lookVector * math.min(0.01, hit.Distance)
			end
		end

		local angle = zeroController.zeroAngle() or math.rad(config.DefaultAngle or 0)
		local direction = (muzzle.WorldCFrame * CFrame.Angles(angle, 0, 0)).LookVector
		local bulletConfig = config.BulletSettings[p23]
		if flags.silentenabled then
			local target = util.getTarget()
			if target then
				local targetPoint = bulletIsRocket(config, bulletConfig)
						and predictedProjectilePoint(origin, target, config, bulletConfig)
					or target.Position
				local offset = targetPoint - origin
				if offset.Magnitude > 0.001 then
					direction = offset.Unit
				end
			end
		end

		p22.animator:play("GunShoot")
		rbShots = rbShots + 1
		local shotCount = bulletConfig.ShotAmount or 1
		local directions = table.create(shotCount)
		for index = 1, shotCount do
			directions[index] = spreadVector(direction, bulletConfig.Spread or 1)
		end

		local sound = p22.tool.Sounds:FindFirstChild("Muzzle" .. p22.index)
		sound = sound and sound:FindFirstChild("Fire")
		if sound then
			soundManager.Play(sound, muzzle.WorldPosition, config.SoundRange or 3000)
		end
		weaponEffects.MuzzleFlash(muzzle, p22.tool.Name)
		isExplosiveShot = bulletIsExplosive(bulletConfig)
		if bodyReplication == nil then
			local module = replicatedStorage.Client:FindFirstChild("BodyReplication")
			if module then
				bodyReplication = require(module)
				debug.setupvalue(oldFire, 10, bodyReplication)
				functions.fire.upv[10] = bodyReplication
			end
		end
		if bodyReplication then
			bodyReplication.flushNow()
		end
		if fireVolley then
			fireVolley(p22.tool, p22.index, p23, origin, directions)
		end
		isExplosiveShot = false
		if not p22:isHandAction() then
			weaponEffects.Casing(muzzle, p22.tool.Name)
		end
	end)
end

if functions.fireOnce.func then
	local oldFireOnce = cloneOriginal(functions.fireOnce.func)
	hookfunction(functions.fireOnce.func, function()
		LPH_ATTRIBUTES(VM(NONE))
		local state, spreadVector, soundManager, weaponEffects, clientFire, turretController =
			unpack(debug.getupvalues(oldFireOnce))
		if not (state and state.muzzle and state.muzzle.Parent) then
			return
		end
		local fireVolley = functions.fireVolleyFn
		if type(clientFire) == "table" then
			fireVolley = clientFire.fireVolley or fireVolley
		end

		local muzzleConfig = state.muzzleConfig
		local muzzle = state.muzzle
		local muzzleCFrame = muzzle.WorldCFrame
		local origin = muzzleCFrame.Position
		local direction = (muzzleCFrame * CFrame.Angles(math.rad(muzzleConfig.DefaultAngle or 0), 0, 0)).LookVector
		local bulletConfig = muzzleConfig.BulletSettings and muzzleConfig.BulletSettings[1] or {}
		if flags.turretsilentenabled then
			local target = util.getTarget()
			if target then
				local targetPoint = bulletIsRocket(muzzleConfig, bulletConfig)
						and predictedProjectilePoint(origin, target, muzzleConfig, bulletConfig)
					or target.Position
				local offset = targetPoint - origin
				if offset.Magnitude > 0.001 then
					direction = offset.Unit
				end
			end
		end

		local shotCount = bulletConfig.ShotAmount or 1
		local directions = table.create(shotCount)
		for index = 1, shotCount do
			directions[index] = spreadVector(direction, bulletConfig.Spread or 1)
		end
		if state.loopSound then
			soundManager.Play(state.loopSound, origin, muzzleConfig.SoundRange or 3000)
			if state.burstTracker then
				state.burstTracker.onShot(origin)
			end
		elseif state.fireSound then
			soundManager.Play(state.fireSound, origin, muzzleConfig.SoundRange or 3000)
		end
		weaponEffects.MuzzleFlash(muzzle, state.weaponName)
		weaponEffects.Casing(muzzle, state.weaponName)
		isExplosiveShot = bulletIsExplosive(bulletConfig)
		if fireVolley then
			fireVolley(state.weaponName, 1, 1, origin, directions)
		end
		isExplosiveShot = false
		turretController.ApplyRecoil()
	end)
end
if functions.aimtoggle.func then
local oldAimToggle = cloneOriginal(functions.aimtoggle.func)
functions.aimtoggle.func = hookfunction(functions.aimtoggle.func, function(...)
	LPH_ATTRIBUTES(VM(NONE))
	local orig = oldAimToggle
	if not flags.aimanywhere then
		return orig(...)
	end
	local state = debug.getupvalue(orig, 1)
	debug.setupvalue(orig, 1, (state == 0) and 1 or 0)
end)
end

if functions.aimupdate.func then
local oldAimUpdate = cloneOriginal(functions.aimupdate.func)
functions.aimupdate.func = hookfunction(functions.aimupdate.func, function(p25)
	LPH_ATTRIBUTES(VM(NONE))
	local orig = oldAimUpdate
	local instantAds = flags.instantads
	local aimAnywhere = flags.aimanywhere
	local noAdsSlow = flags.noadsslowdown
	if not (instantAds or aimAnywhere or noAdsSlow) then
		return orig(p25)
	end

	local wantAim = debug.getupvalue(orig, 3) == 1
	if instantAds then
		debug.setupvalue(orig, 2, wantAim and 1 or 0)
	end

	orig(p25)

	if aimAnywhere and wantAim then
		debug.setupvalue(orig, 3, 1)
		if instantAds then
			debug.setupvalue(orig, 2, 1)
		end
	end

	if noAdsSlow then
		local slow = debug.getupvalue(orig, 1)
		if typeof(slow) == "Instance" then
			slow.Value = 1
		end
	end
end)
end

if functions.isaimingavailable.func then
local oldIsAimingAvailable = cloneOriginal(functions.isaimingavailable.func)
functions.isaimingavailable.func = hookfunction(functions.isaimingavailable.func, function(...)
	LPH_ATTRIBUTES(VM(NONE))
	if flags.aimanywhere then
		return true
	end
	return oldIsAimingAvailable(...)
end)
end

if functions.firemodestart.func then
local oldFiremodeStart = cloneOriginal(functions.firemodestart.func)
functions.firemodestart.func = hookfunction(functions.firemodestart.func, function(p18)
	LPH_ATTRIBUTES(VM(NONE))
	local v_u_6 = functions.firemodestart.upv

	if not p18.isFiring then
		p18.isFiring = true
		local v19 = p18:_current()
		if v19 then
			local strategy = v19.strategy
			if flags.forceauto then
				local auto = v_u_6 and v_u_6.Automatic
				if auto and auto.strategy then
					strategy = auto.strategy
				end
			end
			if strategy then
				task.spawn(strategy.fire, p18)
			end
		end
	end
end)
end

if functions.awaitLength.func then
	local oldAwaitLength = cloneOriginal(functions.awaitLength.func)
	functions.awaitLength.func = hookfunction(functions.awaitLength.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		if flags.instantequip then
			return false
		end
		return oldAwaitLength(...)
	end)
end

local function legHealthMult(char)
	local function ratio(name)
		local part = char:FindFirstChild(name)
		local h = part and part:FindFirstChild("Health")
		if h then
			local max = h:GetAttribute("MaxHealth")
			if max and max > 0 then
				return h.Value / max
			end
		end
		return nil
	end
	local l, r = ratio("Left Leg"), ratio("Right Leg")
	if l and r then
		return 0.5 + (l + r) / 4
	end
	return nil
end

if functions.movementupdate.func then
	local oldMovementUpdate = cloneOriginal(functions.movementupdate.func)
	functions.movementupdate.func = hookfunction(functions.movementupdate.func, function(p11)
		LPH_ATTRIBUTES(VM(NONE))
		if not flags.omnisprint and not flags.nohurtslowdown then
			return oldMovementUpdate(p11)
		end

		if flags.omnisprint and p11 then
			p11.firstPerson = false
		end

		oldMovementUpdate(p11)

		if flags.nohurtslowdown and p11 and p11.humanoid and p11.character then
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

local oldTrajNew = Trajectory.new
Trajectory.new = function(params)
	LPH_ATTRIBUTES(VM(NONE))
	if not isExplosiveShot then
		if flags.nodrop then
			params.Gravity = 0
		end
		if flags.instantbullet then
			params.MuzzleSpeed = 1e6
			params.K = 0
		end
	end
	return oldTrajNew(params)
end

local Remotes = RS:WaitForChild("Remotes")

local healAcc = 0
local healRemote, healBandage
local function autoHealStep(dt)
	LPH_ATTRIBUTES(VM(NONE))
	if not flags.autoheal or not functions.healLimb.func then
		return
	end
	healAcc = healAcc + dt
	if not flags.instantheal and healAcc < 0.75 then
		return
	end
	healAcc = 0

	if not healRemote then
		healRemote = debug.getupvalue(functions.healLimb.func, 1)
	end
	healBandage = debug.getupvalue(functions.healLimb.func, 2)
	local remote = healRemote
	local bandage = healBandage
	local char = LocalPlayer.Character
	if not (remote and char) then
		return
	end

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
end

local reviveAcc = 0
local function fastReviveStep(dt)
	LPH_ATTRIBUTES(VM(NONE))
	if not flags.fastrevive then
		return
	end
	reviveAcc = reviveAcc + dt
	if reviveAcc < 1 then
		return
	end
	reviveAcc = 0

	local chars = workspace:FindFirstChild("Characters")
	if not chars then
		return
	end
	local prompts = chars:QueryDescendants("#RevivePrompt")
	for _, p in prompts do
		if p:IsA("ProximityPrompt") then
			p.HoldDuration = 3
		end
	end
end

local carDefaults = {
	FinalDrive = 7.5,
	ShiftRPM = 7000,
	IdleRPM = 1000,
	IdleTorque = 140,
	PeakTorque = 520,
	PeakTorqueRPM = 5000,
	RedlineRPM = 9000,
	RedlineTorque = 300,
	HorsepowerLimit = 1000,
	TorqueScale = 6,
	TopSpeed = 220,
	PeakGrip = 2.5,
	SlideGrip = 2.25,
	PeakSlip = 0.5,
	Grip = 40,
	BrakeMultiplier = 10,
	HandBrakeMultiplier = 5.5,
	RollingFriction = 0.05,
	TurningZForceMultiplier = 1,
	TurnRadius = 20,
	SteerSpeed = 2.5,
	HighSpeedSteerReduction = 0.65,
	ForceHeight = 0.75,
	Mass = 750,
	WheelMass = 8,
	SuspensionHeight = 2,
	RideHeight = 1.5,
	WheelOffset = 0.5,
	ReboundDampingModifier = 1.3,
	CompressionDampingModifier = 1,
	DamperActiveness = 0.7,
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
	if not faction then
		return nil
	end
	return instance.Name .. " (" .. faction .. ")"
end
local function copyProfile(source)
	local result = {}
	if type(source) == "table" then
		for key, value in pairs(source) do
			if type(value) ~= "table" then
				result[key] = value
			end
		end
		if type(source.Ratios) == "table" then
			result.Ratios = {}
			for key, value in pairs(source.Ratios) do
				result.Ratios[key] = value
			end
		end
		if type(source.Wheels) == "table" then
			result.Wheels = {}
			for index, wheel in ipairs(source.Wheels) do
				result.Wheels[index] = {}
				for key, value in pairs(wheel) do
					result.Wheels[index][key] = value
				end
			end
		end
	end
	for key, value in pairs(carDefaults) do
		result[key] = source and source[key] ~= nil and source[key] or value
	end
	for key, value in pairs(carBoolDefaults) do
		result[key] = source and source[key] ~= nil and source[key] or value
	end
	for key, value in pairs(carChoiceDefaults) do
		result[key] = source and source[key] ~= nil and source[key] or value
	end
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
	if carProfileSyncing then
		return
	end
	if type(value) ~= "string" or value == "" then
		return
	end
	local ok, decoded = pcall(HttpService.JSONDecode, HttpService, value)
	if ok and type(decoded) == "table" then
		for label, profile in pairs(decoded) do
			if type(profile) == "table" then
				carProfiles[label] = copyProfile(profile)
			end
		end
	end
end
local function registerCar(label, value)
	if not label or type(value) ~= "table" or type(value.Transmission) ~= "table" then
		return
	end
	if carConfigSeen[value] then
		return
	end
	carConfigSeen[value] = true
	carConfigs[label] = value
	carEntries[#carEntries + 1] = label
	if carProfiles[label] == nil then
		carProfiles[label] = copyProfile(value.Transmission)
	end
end
local function discoverCars()
	local manager = RS:FindFirstChild("Shared") and RS.Shared:FindFirstChild("VehicleConfigManager")
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

	if not manager then
		for _, value in pairs(getgc(true)) do
			if
				typeof(value) == "table"
				and rawget(value, "Transmission")
				and rawget(value, "Damage")
				and rawget(value, "ShopInfo")
			then
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
	if not flags.carmods then
		return
	end
	for label, value in pairs(carConfigs) do
		local profile = carProfiles[label]
		if profile then
			local transmission = value.Transmission
			for key in pairs(carDefaults) do
				if transmission[key] ~= profile[key] then
					transmission[key] = profile[key]
				end
			end
			for key in pairs(carBoolDefaults) do
				if transmission[key] ~= profile[key] then
					transmission[key] = profile[key]
				end
			end
			for key in pairs(carChoiceDefaults) do
				if transmission[key] ~= profile[key] then
					transmission[key] = profile[key]
				end
			end
			if profile.Ratios then
				transmission.Ratios = transmission.Ratios or {}
				for gear, ratio in pairs(profile.Ratios) do
					if transmission.Ratios[gear] ~= ratio then
						transmission.Ratios[gear] = ratio
					end
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
	if not selectedCar then
		return nil
	end
	carProfiles[selectedCar] = carProfiles[selectedCar] or copyProfile()
	return carProfiles[selectedCar]
end
local function setCarControlValue(key, value)
	local profile = selectedCarProfile()
	if not profile then
		return
	end
	profile[key] = value
	syncCarProfileJson()
	applyCarMods()
end
local carModsAcc = 0
local function carModsStep(dt)
	LPH_ATTRIBUTES(VM(NONE))
	if not flags.carmods then
		return
	end
	carModsAcc = carModsAcc + dt
	if carModsAcc < 5 then
		return
	end
	carModsAcc = 0
	discoverCars()
	applyCarMods()
end

local function findClientFire(upvalues)
	for _, value in pairs(upvalues or {}) do
		if type(value) == "table" and type(value.fire) == "function" then
			return value
		end
	end
	return upvalues and upvalues[12]
end
local ClientFire = findClientFire(functions.fire.upv)
if type(ClientFire) == "table" and not ClientFire.fireVolley and functions.fireVolleyFn then
	ClientFire.fireVolley = functions.fireVolleyFn
end
local WeaponRemote = Remotes:WaitForChild("Weapon")

WeaponConfigs = functions.muzzlesConfig.func and debug.getupvalue(functions.muzzlesConfig.func, 1)
local Materials = select(
	2,
	pcall(function()
		return require(RS:WaitForChild("Shared"):WaitForChild("Ballistics"):WaitForChild("ProjectileMaterials"))
	end)
)
if type(Materials) ~= "table" then
	Materials = nil
end

local function rbMuzzleConfig(tool, muzzleIndex)
	LPH_ATTRIBUTES(VM(NONE))
	local wc = WeaponConfigs and WeaponConfigs[tool.Name]
	return wc and wc[muzzleIndex]
end

local rbExitParams = RaycastParams.new()
rbExitParams.FilterType = Enum.RaycastFilterType.Include
local rbHitParams = RaycastParams.new()
rbHitParams.FilterType = Enum.RaycastFilterType.Exclude

local function rbFindExit(hitPos, dir, inst)
	LPH_ATTRIBUTES(VM(NONE))
	local p = rbExitParams
	p.FilterType = Enum.RaycastFilterType.Include
	p.FilterDescendantsInstances = { inst }
	local far = hitPos + dir * 60
	local r = workspace:Raycast(far, -dir * 60, p)
	return r and r.Position or nil
end

local function rbPenetrable(origin, targetPos, targetChar, budget, ignore)
	LPH_ATTRIBUTES(VM(NONE))
	if not budget or budget <= 0 then
		return false
	end
	local remaining = budget
	local pos = origin
	for _ = 1, 8 do
		local delta = targetPos - pos
		local dist = delta.Magnitude
		if dist < 0.1 then
			return true
		end
		local dir = delta.Unit
		rbHitParams.FilterDescendantsInstances = ignore
		local hit = workspace:Raycast(pos, dir * dist, rbHitParams)
		if not hit then
			return true
		end
		if hit.Instance:IsDescendantOf(targetChar) then
			return true
		end
		local exit = rbFindExit(hit.Position, dir, hit.Instance)
		if not exit then
			return false
		end
		local thickness = (exit - hit.Position).Magnitude
		local cost = Materials and Materials.getPenetration(hit.Material) or 1
		remaining = remaining - thickness * cost
		if remaining <= 0 then
			return false
		end
		pos = exit + dir * 0.05
	end
	return false
end

local function rbCanDamage(origin, targetPos, targetChar, budget, ignore)
	LPH_ATTRIBUTES(VM(NONE))
	local delta = targetPos - origin
	rbHitParams.FilterDescendantsInstances = ignore
	local hit = workspace:Raycast(origin, delta, rbHitParams)
	if not hit then
		return true
	end
	if hit.Instance:IsDescendantOf(targetChar) then
		return true
	end
	if not flags.ragebotwallbang then
		return false
	end
	return rbPenetrable(origin, targetPos, targetChar, budget, ignore)
end

local function rbReloadServer(muzzleIndex, bulletIndex)
	local b = buffer.create(3)
	buffer.writeu8(b, 0, 1)
	buffer.writeu8(b, 1, muzzleIndex)
	buffer.writeu8(b, 2, bulletIndex)
	WeaponRemote:FireServer(b)
end

local rbPartOrder = { "Head", "Torso", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }
local function rbBestPart(targetChar, origin, budget, ignore)
	LPH_ATTRIBUTES(VM(NONE))
	for _, name in rbPartOrder do
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
local rbReloadUntil = 0
local rbLastTool = nil
local function ragebotStep()
	LPH_ATTRIBUTES(VM(NONE))
	local char = LocalPlayer.Character
	if not (char and ClientFire) then
		return
	end
	local tool = getHeldWeapon()
	if not tool then
		return
	end

	local muzzle = util.getMuzzle()
	local origin
	if muzzle then
		origin = muzzle.WorldPosition
	else
		local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
		if not head then
			return
		end
		origin = head.Position
	end

	local muzzleIndex, bulletIndex = 1, 1
	local mc = rbMuzzleConfig(tool, muzzleIndex)
	local firerate = (mc and mc.Firerate) or 600
	local magSize = (mc and mc.Ammo) or 30
	local reloadTime = (mc and mc.ReloadTime) or 3
	local bs = mc and mc.BulletSettings and mc.BulletSettings[bulletIndex]
	local budget = (bs and bs.Penetration) or 0

	if tool ~= rbLastTool then
		rbLastTool = tool
		rbShots = 0
		rbReloadUntil = 0
	end

	if os.clock() < rbReloadUntil then
		return
	end

	if magSize > 0 and rbShots >= magSize then
		if flags.ragebotautoreload then
			rbReloadServer(muzzleIndex, bulletIndex)
			rbReloadUntil = os.clock() + reloadTime
			rbShots = 0
		end
		return
	end

	if os.clock() < rbNextFire then
		return
	end

	local ignore = { char }
	local ig = workspace:FindFirstChild("Ignore")
	if ig then
		ignore[#ignore + 1] = ig
	end

	local me = LocalPlayer
	local candidates = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= me and plr.Character and not isDowned(plr.Character) then
			if not (me.Team and plr.Team == me.Team) then
				local hum = plr.Character:FindFirstChildOfClass("Humanoid")
				local ref = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Head")
				if hum and hum.Health > 0 and ref then
					local dist = (ref.Position - origin).Magnitude
					candidates[#candidates + 1] = { Character = plr.Character, Distance = dist }
				end
			end
		end
	end

	table.sort(candidates, function(a, b)
		return a.Distance < b.Distance
	end)
	local best, shotOrigin
	for _, candidate in ipairs(candidates) do
		best, shotOrigin = rbBestPart(candidate.Character, origin, budget, ignore)
		if best then
			break
		end
	end

	if best then
		rbNextFire = os.clock() + 60 / firerate
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
	LPH_ATTRIBUTES(VM(NONE))
	if not flags.ragebottpaura then
		return
	end
	if os.clock() - lastTpTime < 2.0 then
		return
	end

	local me = LocalPlayer
	local char = me.Character
	if not char then
		return
	end
	local myHrp = char:FindFirstChild("HumanoidRootPart")
	local head = char:FindFirstChild("Head") or myHrp
	if not (myHrp and head) then
		return
	end
	local origin = head.Position

	local ignore = { char }
	local ig = workspace:FindFirstChild("Ignore")
	if ig then
		ignore[#ignore + 1] = ig
	end

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

local rageAcc = 0
local function rageSchedulerStep(dt)
	LPH_ATTRIBUTES(VM(NONE))
	if not (flags.ragebot or flags.ragebottpaura) then
		return
	end
	rageAcc = rageAcc + dt
	if rageAcc < 0.03 then
		return
	end
	rageAcc = 0
	if flags.ragebot then
		pcall(ragebotStep)
	end
	if flags.ragebottpaura then
		pcall(tpAuraStep)
	end
end

local Window = Library:CreateWindow({
	Title = "Cold War - vault.cc [" .. (la_is_premium == true and "Paid" or "Free") .. "]",
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2,
})

local Tabs = {
	Combat = Window:AddTab("Combat"),
	ESP = Window:AddTab("ESP"),
	Visuals = Window:AddTab("Visuals"),
	Misc = nil,
	Settings = nil
}
if la_is_premium then
    Tabs.Misc = Window:AddTab("Misc")
end
Tabs.Settings = Window:AddTab("Settings")

local espCfg
local espOk, ESP = pcall(function()
	LPH_ATTRIBUTES(VM(NONE))
	return loadstring(
		game:HttpGet("https://raw.githubusercontent.com/ttokennxyz/vaultcc/refs/heads/main/esplibcoldwar.lua")
	)()
end)

if espOk and type(ESP) == "table" then

	pcall(function()
		ESP:Load({ Enabled = false, Players = false, LocalPlayer = false, LimitFPS = 45, DynamicBoxes = false })
		espCfg = ESP:GetConfig()
	end)
else
	print(ESP)
	ESP = nil
	Library:Notify("Failed to load ESP library.")
end

local function applyESP()
	local c = espCfg
	if not c then
		return
	end

	c.Enabled = Toggles.ESPMaster.Value
	c.LocalPlayer = false
	c.MaxDistance = Options.ESPMaxDistance.Value
	c.LimitFPS = 45
	c.DynamicBoxes = false
	c.DynamicBoxesCheap = true
	c.DynamicBoxesIncludeAll = false

	c.Boxes = Toggles.ESPBoxes.Value
	c.BoxType = Options.ESPBoxType.Value
	c.BoxColor = Options.ESPBoxColor.Value
	c.BoxThickness = Options.ESPBoxThickness.Value
	c.Outlines.Style = Toggles.ESPBoxOutline.Value and "Full" or "None"
	c.Outlines.Color = Options.ESPBoxOutlineColor.Value

	c.BoxFill.Enabled = Toggles.ESPBoxFill.Value
	c.BoxFill.Color = Options.ESPBoxFillColor.Value
	c.BoxFill.Transparency = Options.ESPBoxFillTransparency.Value

	c.Names = Toggles.ESPNames.Value
	c.TextColor = Options.ESPNameColor.Value
	c.TextSize = Options.ESPTextSize.Value
	c.TextOutline = Toggles.ESPTextOutline.Value
	c.Distance.Enabled = Toggles.ESPDistance.Value
	c.Distance.Color = Options.ESPDistanceColor.Value
	c.Weapon.Enabled = Toggles.ESPWeapon.Value
	c.Weapon.UseToolFallback = true
	c.TeamIndicator.Enabled = Toggles.ESPTeam.Value
	c.FriendlyIndicator.Enabled = Toggles.ESPFriendly.Value
	c.FriendlyIndicator.CheckTeam = Toggles.ESPFriendly.Value
	c.FriendlyIndicator.CheckFriends = Toggles.ESPFriendly.Value

	c.HealthBar.Enabled = Toggles.ESPHealth.Value
	c.HealthBar.ShowText = true
	c.HealthBar.Source = (Options.ESPHealthMode.Value == "Target part") and "Part" or "Average"
	c.HealthBar.Part = ov("silenttarget", "Head")

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

	c.Flags.Enabled = Toggles.ESPFlags.Value
	c.Flags.Options.Idle = Toggles.ESPFlagIdle.Value
	c.Flags.Options.Moving = Toggles.ESPFlagMoving.Value
	c.Flags.Options.Jumping = Toggles.ESPFlagJumping.Value
	c.Flags.Options.Swimming = Toggles.ESPFlagSwimming.Value
	c.OffScreenArrows.Enabled = Toggles.ESPArrows.Value
	c.OffScreenArrows.Color = Options.ESPArrowColor.Value
	c.OffScreenArrows.Size = Options.ESPArrowSize.Value
end

local function refreshTeamFilter()
	local c = espCfg
	if not c then
		return
	end

	local me = LocalPlayer

	if Toggles.ESPFilterTeam.Value then
		c.Players = false
		local dirs = {}
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= me and plr.Character then

				if not (me.Team and plr.Team == me.Team) then
					dirs[#dirs + 1] = { DisplayName = plr.Name, Path = plr.Character:GetFullName() }
				end
			end
		end
		c.Directories = dirs
	else

		c.Players = true
		c.Directories = {}
	end
end

local gunmods = Tabs.Combat:AddRightGroupbox("Gun Mods")
gunmods:AddSlider("recoilmult", { Text = "Recoil Multiplier", Default = 0, Min = 0, Max = 1, Rounding = 2 })
gunmods:AddSlider("spreadmult", { Text = "Spread Multiplier", Default = 0, Min = 0, Max = 1, Rounding = 2 })
gunmods:AddToggle("forceauto", { Text = "Force Auto", Default = true })
gunmods:AddToggle("instantequip", { Text = "Instant Equip", Default = false })
gunmods:AddToggle("nodrop", { Text = "No Bullet Drop", Default = false })
gunmods:AddToggle("instantbullet", { Text = "Instant Bullet", Default = false })
gunmods:AddToggle(
	"rpgprediction",
	{
		Text = "RPG Prediction",
		Default = true,
	}
)
gunmods:AddSlider(
	"rpgpredictionstrength",
	{ Text = "RPG Prediction Strength", Default = 1, Min = 0, Max = 2, Rounding = 2 }
)

local aiming = Tabs.Combat:AddLeftGroupbox("Aiming")
aiming
	:AddToggle("aimbotenabled", { Text = "Aimbot Enabled", Default = false })
	:AddKeyPicker("aimbotkey", { Default = "R", SyncToggleState = false, Mode = "Hold", Text = "Aimbot Key" })
aiming:AddDropdown("aimbotmethod", { Text = "Aim Method", Values = { "Camera", "Mouse" }, Default = 1, Multi = false })
aiming:AddDropdown(
	"aimbottarget",
	{
		Text = "Target part",
		Values = { "Head", "Torso", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg" },
		Default = 1,
		Multi = false,
	}
)
aiming:AddSlider(
	"aimbotsmoothness",
	{
		Text = "Smoothness",
		Default = 1,
		Min = 1,
		Max = 20,
		Rounding = 1,
	}
)
aiming:AddToggle("aimanywhere", { Text = "Aim Anywhere", Default = true })
aiming:AddToggle("instantads", { Text = "Instant ADS", Default = true })
aiming:AddToggle("noadsslowdown", { Text = "No ADS Slowdown", Default = true })

local silent = Tabs.Combat:AddLeftGroupbox("Silent Aim")
silent
	:AddToggle(
		"silentenabled",
		{ Text = "Normal Silent Aim", Default = true }
	)
	:AddKeyPicker(
		"silentbind",
		{ Default = "None", SyncToggleState = true, Mode = "Toggle", Text = "Normal Silent Aim" }
	)
silent
	:AddToggle(
		"turretsilentenabled",
		{ Text = "Turret Silent Aim", Default = true }
	)
	:AddKeyPicker(
		"turretsilentbind",
		{ Default = "None", SyncToggleState = true, Mode = "Toggle", Text = "Turret Silent Aim" }
	)
silent:AddDropdown(
	"silenttarget",
	{
		Text = "Target part",
		Values = { "Head", "Torso", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg" },
		Default = 1,
		Multi = false,
	}
)
Options["silenttarget"]:OnChanged(function(val)
	if espCfg then
		espCfg.HealthBar.Part = val
	end
end)
silent:AddToggle(
	"silentvisiblecheck",
	{ Text = "Visible Check", Default = false }
)
silent:AddToggle(
	"silentdistancecheck",
	{ Text = "Distance Check", Default = false }
)
silent:AddSlider(
	"silentmaxdistance",
	{ Text = "Max Distance", Default = 500, Min = 10, Max = 2000, Rounding = 0, Suffix = " studs" }
)
silent:AddToggle("fovenabled", { Text = "FOV Circle", Default = false })
silent:AddSlider("fovsize", { Text = "FOV Circle Size", Default = 100, Min = 5, Max = 500, Rounding = 0 })
silent:AddToggle("silentteamcheck", { Text = "Exclude Teammates", Default = true })
silent:AddToggle("fovdraw", { Text = "Draw FOV Circle", Default = false })
silent
	:AddLabel("FOV color")
	:AddColorPicker("fovcolor", { Default = Color3.fromRGB(255, 255, 255), Title = "FOV color" })
silent:AddSlider("fovthickness", { Text = "FOV Thickness", Default = 1, Min = 1, Max = 10, Rounding = 0 })
silent:AddToggle("snaplines", { Text = "Snapline", Default = false })
silent
	:AddLabel("Snapline color")
	:AddColorPicker("snaptargetcolor", { Default = Color3.fromRGB(255, 0, 0), Title = "Snapline color" })

if la_is_premium then

    local ragebot = Tabs.Combat:AddRightGroupbox("Ragebot")
    ragebot
    	:AddToggle("ragebot", { Text = "Enabled", Default = false })
    	:AddKeyPicker("ragebotbind", { Default = "None", SyncToggleState = true, Mode = "Toggle", Text = "Ragebot" })
    ragebot:AddToggle(
    	"ragebotwallbang",
    	{ Text = "Wallbang", Default = false }
    )
    ragebot:AddToggle(
    	"ragebotautoreload",
    	{ Text = "Auto Reload", Default = false }
    )
    ragebot:AddToggle(
    	"ragebottpaura",
    	{ Text = "TP Aura", Default = false }
    )
end

local fovGui = Instance.new("ScreenGui")
fovGui.Name = "cwfov"
fovGui.IgnoreGuiInset = true
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
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovCircle

local fovStroke = Instance.new("UIStroke")
fovStroke.Thickness = 1
fovStroke.Color = Color3.fromRGB(255, 255, 255)
fovStroke.Parent = fovCircle

local function fovRenderStep()
	LPH_ATTRIBUTES(VM(NONE))
	if not flags.fovdraw then
		fovCircle.Visible = false
		return
	end

	local m = UserInputService:GetMouseLocation()
	local r = ov("fovsize", 100)
	fovCircle.Size = UDim2.fromOffset(r * 2, r * 2)
	fovCircle.Position = UDim2.fromOffset(m.X, m.Y)
	fovStroke.Thickness = ov("fovthickness", 1)
	fovStroke.Color = ov("fovcolor", Color3.new(1, 1, 1))
	fovCircle.Visible = true
end

local snapGui = Instance.new("ScreenGui")
snapGui.Name = "cwsnap"
snapGui.IgnoreGuiInset = true
snapGui.ResetOnSpawn = false
snapGui.DisplayOrder = 100
snapGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local snapLine = Instance.new("Frame")
snapLine.AnchorPoint = Vector2.new(0.5, 0.5)
snapLine.BorderSizePixel = 0
snapLine.Visible = false
snapLine.Parent = snapGui

local function snapRenderStep()
	LPH_ATTRIBUTES(VM(NONE))
	local part = util.target
	if flags.snaplines and part and part.Parent then
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
				snapLine.BackgroundColor3 = ov("snaptargetcolor", Color3.fromRGB(255, 0, 0))
				snapLine.Visible = true
				return
			end
		end
	end
	snapLine.Visible = false
end

local espMain = Tabs.ESP:AddLeftGroupbox("Main")
espMain:AddToggle("ESPMaster", { Text = "Enabled", Default = false })
espMain:AddToggle(
	"ESPFilterTeam",
	{ Text = "Filter teammates", Default = false }
)
espMain:AddSlider(
	"ESPMaxDistance",
	{
		Text = "Max distance",
		Default = 0,
		Min = 0,
		Max = 2000,
		Rounding = 0,
		Suffix = " studs",
	}
)

local espBox = Tabs.ESP:AddLeftGroupbox("Boxes")
espBox:AddToggle("ESPBoxes", { Text = "Boxes", Default = true })
espBox:AddDropdown("ESPBoxType", { Text = "Box type", Values = { "Normal", "Corner" }, Default = 1, Multi = false })
espBox
	:AddLabel("Box color")
	:AddColorPicker("ESPBoxColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Box color" })
espBox:AddSlider("ESPBoxThickness", { Text = "Box thickness", Default = 1, Min = 1, Max = 6, Rounding = 0 })
espBox:AddToggle("ESPBoxOutline", { Text = "Box outline", Default = true })
espBox
	:AddLabel("Outline color")
	:AddColorPicker("ESPBoxOutlineColor", { Default = Color3.fromRGB(0, 0, 0), Title = "Outline color" })
espBox:AddDivider()
espBox:AddToggle("ESPBoxFill", { Text = "Box fill", Default = false })
espBox
	:AddLabel("Fill color")
	:AddColorPicker("ESPBoxFillColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Fill color" })
espBox:AddSlider(
	"ESPBoxFillTransparency",
	{ Text = "Fill transparency", Default = 0.9, Min = 0, Max = 1, Rounding = 2 }
)

local espChams = Tabs.ESP:AddRightGroupbox("Chams")
espChams:AddToggle("ESPChams", { Text = "Chams", Default = false })
espChams:AddDropdown(
	"ESPChamsType",
	{
		Text = "Chams type",
		Values = { "Highlight", "Adornment", "MeshChams" },
		Default = 1,
		Multi = false,
	}
)
espChams
	:AddLabel("Fill color")
	:AddColorPicker("ESPChamsFill", { Default = Color3.fromRGB(59, 144, 204), Title = "Cham fill" })
espChams:AddSlider("ESPChamsFillT", { Text = "Fill transparency", Default = 0.6, Min = 0, Max = 1, Rounding = 2 })
espChams
	:AddLabel("Outline color")
	:AddColorPicker("ESPChamsOutline", { Default = Color3.fromRGB(255, 255, 255), Title = "Cham outline" })
espChams:AddSlider("ESPChamsOutlineT", { Text = "Outline transparency", Default = 0, Min = 0, Max = 1, Rounding = 2 })
espChams:AddToggle(
	"ESPChamsVisible",
	{ Text = "Visible check", Default = false }
)

local espInfo = Tabs.ESP:AddLeftGroupbox("Names & Info")
espInfo:AddToggle("ESPNames", { Text = "Names", Default = true })
espInfo
	:AddLabel("Name color")
	:AddColorPicker("ESPNameColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Name color" })
espInfo:AddSlider("ESPTextSize", { Text = "Text size", Default = 12, Min = 6, Max = 28, Rounding = 0 })
espInfo:AddToggle("ESPTextOutline", { Text = "Text outline", Default = true })
espInfo:AddDivider()
espInfo:AddToggle("ESPDistance", { Text = "Distance", Default = false })
espInfo
	:AddLabel("Distance color")
	:AddColorPicker("ESPDistanceColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Distance color" })
espInfo:AddToggle("ESPWeapon", { Text = "Weapon", Default = false })
espInfo:AddToggle("ESPTeam", { Text = "Team indicator", Default = false })
espInfo:AddToggle(
	"ESPFriendly",
	{ Text = "Friendly indicator", Default = false }
)

local espHealth = Tabs.ESP:AddRightGroupbox("Health")
espHealth:AddToggle("ESPHealth", { Text = "Health", Default = false })
espHealth:AddDropdown(
	"ESPHealthMode",
	{
		Text = "Health mode",
		Values = { "Average", "Target part" },
		Default = 1,
		Multi = false,
	}
)

local espFlags = Tabs.ESP:AddRightGroupbox("Flags & Arrows")
espFlags:AddToggle("ESPFlags", { Text = "Status flags", Default = false })
espFlags:AddToggle("ESPFlagIdle", { Text = "Flag: Idle", Default = false })
espFlags:AddToggle("ESPFlagMoving", { Text = "Flag: Moving", Default = false })
espFlags:AddToggle("ESPFlagJumping", { Text = "Flag: Jumping", Default = false })
espFlags:AddToggle("ESPFlagSwimming", { Text = "Flag: Swimming", Default = false })
espFlags:AddDivider()
espFlags:AddToggle("ESPArrows", { Text = "Off-screen arrows", Default = false })
espFlags
	:AddLabel("Arrow color")
	:AddColorPicker("ESPArrowColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Arrow color" })
espFlags:AddSlider("ESPArrowSize", { Text = "Arrow size", Default = 14, Min = 8, Max = 40, Rounding = 0 })

local espToggleKeys = {
	"ESPMaster",
	"ESPBoxes",
	"ESPBoxOutline",
	"ESPBoxFill",
	"ESPNames",
	"ESPTextOutline",
	"ESPDistance",
	"ESPWeapon",
	"ESPTeam",
	"ESPFriendly",
	"ESPHealth",
	"ESPChams",
	"ESPChamsVisible",
	"ESPFlags",
	"ESPFlagIdle",
	"ESPFlagMoving",
	"ESPFlagJumping",
	"ESPFlagSwimming",
	"ESPArrows",
}
local espOptionKeys = {
	"ESPMaxDistance",
	"ESPBoxType",
	"ESPBoxColor",
	"ESPBoxThickness",
	"ESPBoxOutlineColor",
	"ESPBoxFillColor",
	"ESPBoxFillTransparency",
	"ESPNameColor",
	"ESPTextSize",
	"ESPDistanceColor",
	"ESPHealthMode",
	"ESPChamsType",
	"ESPChamsFill",
	"ESPChamsFillT",
	"ESPChamsOutline",
	"ESPChamsOutlineT",
	"ESPArrowColor",
	"ESPArrowSize",
}

for _, key in ipairs(espToggleKeys) do
	Toggles[key]:OnChanged(applyESP)
end
for _, key in ipairs(espOptionKeys) do
	Options[key]:OnChanged(applyESP)
end

Toggles.ESPFilterTeam:OnChanged(refreshTeamFilter)

applyESP()
refreshTeamFilter()

local teamFilterAcc = 0
local function teamFilterStep(dt)
	LPH_ATTRIBUTES(VM(NONE))
	if not ESP or not espCfg or not flags.ESPMaster then
		return
	end
	teamFilterAcc = teamFilterAcc + dt
	if teamFilterAcc < 1 then
		return
	end
	teamFilterAcc = 0
	refreshTeamFilter()
end

local Lighting = game:GetService("Lighting")
local lightingProperties = {
	"GlobalShadows",
	"Brightness",
	"ClockTime",
	"ExposureCompensation",
	"ShadowSoftness",
	"EnvironmentDiffuseScale",
	"EnvironmentSpecularScale",
	"GeographicLatitude",
	"Ambient",
	"OutdoorAmbient",
	"ColorShift_Top",
	"ColorShift_Bottom",
	"FogColor",
	"FogStart",
	"FogEnd",
}
local effectProperties = {
	Atmosphere = { "Color", "Decay", "Density", "Offset", "Haze", "Glare" },
	BloomEffect = { "Enabled", "Intensity", "Size", "Threshold" },
	ColorCorrectionEffect = { "Enabled", "Brightness", "Contrast", "Saturation", "TintColor" },
	SunRaysEffect = { "Enabled", "Intensity", "Spread" },
	DepthOfFieldEffect = { "Enabled", "FarIntensity", "NearIntensity", "FocusDistance", "InFocusRadius" },
	BlurEffect = { "Enabled", "Size" },
}
local lightingOriginal = { Lighting = {}, Effects = {} }
local lightingEffects = {}
for _, property in ipairs(lightingProperties) do
	lightingOriginal.Lighting[property] = Lighting[property]
end
for _, effect in ipairs(Lighting:GetDescendants()) do
	local properties = effectProperties[effect.ClassName]
	if properties then
		lightingEffects[#lightingEffects + 1] = effect
		local values = {}
		for _, property in ipairs(properties) do
			values[property] = effect[property]
		end
		lightingOriginal.Effects[effect] = values
	end
end

local primaryAtmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
local primaryBloom = Lighting:FindFirstChildOfClass("BloomEffect")
local primaryColorCorrection = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
local primarySunRays = Lighting:FindFirstChildOfClass("SunRaysEffect")
local primaryDepthOfField = Lighting:FindFirstChild("DepthOfField")
local primaryBlur = Lighting:FindFirstChildOfClass("BlurEffect")

local function restoreLighting()
	for property, value in pairs(lightingOriginal.Lighting) do
		Lighting[property] = value
	end
	for effect, values in pairs(lightingOriginal.Effects) do
		if effect.Parent then
			for property, value in pairs(values) do
				effect[property] = value
			end
		end
	end
end

local function setLightingProperty(instance, property, value)
	if instance[property] ~= value then
		instance[property] = value
	end
end

local function applyLighting()
	LPH_ATTRIBUTES(VM(NONE))
	if not tv("lightingoverride", false) then
		return
	end
	local fogStart = ov("fogstart", lightingOriginal.Lighting.FogStart)
	setLightingProperty(Lighting, "GlobalShadows", tv("globalshadows", lightingOriginal.Lighting.GlobalShadows))
	setLightingProperty(Lighting, "Brightness", ov("lightingbrightness", lightingOriginal.Lighting.Brightness))
	setLightingProperty(Lighting, "ClockTime", ov("clocktime", lightingOriginal.Lighting.ClockTime))
	setLightingProperty(
		Lighting,
		"ExposureCompensation",
		ov("exposure", lightingOriginal.Lighting.ExposureCompensation)
	)
	setLightingProperty(Lighting, "ShadowSoftness", ov("shadowsoftness", lightingOriginal.Lighting.ShadowSoftness))
	setLightingProperty(
		Lighting,
		"EnvironmentDiffuseScale",
		ov("diffusescale", lightingOriginal.Lighting.EnvironmentDiffuseScale)
	)
	setLightingProperty(
		Lighting,
		"EnvironmentSpecularScale",
		ov("specularscale", lightingOriginal.Lighting.EnvironmentSpecularScale)
	)
	setLightingProperty(Lighting, "GeographicLatitude", ov("latitude", lightingOriginal.Lighting.GeographicLatitude))
	setLightingProperty(Lighting, "Ambient", ov("ambientcolor", lightingOriginal.Lighting.Ambient))
	setLightingProperty(Lighting, "OutdoorAmbient", ov("outdoorambient", lightingOriginal.Lighting.OutdoorAmbient))
	setLightingProperty(Lighting, "ColorShift_Top", ov("colorshifttop", lightingOriginal.Lighting.ColorShift_Top))
	setLightingProperty(
		Lighting,
		"ColorShift_Bottom",
		ov("colorshiftbottom", lightingOriginal.Lighting.ColorShift_Bottom)
	)
	setLightingProperty(Lighting, "FogColor", ov("fogcolor", lightingOriginal.Lighting.FogColor))
	setLightingProperty(Lighting, "FogStart", fogStart)
	setLightingProperty(Lighting, "FogEnd", math.max(fogStart, ov("fogend", lightingOriginal.Lighting.FogEnd)))

	for _, effect in ipairs(lightingEffects) do
		if not effect.Parent then
			continue
		end
		if effect:IsA("Atmosphere") then
			local defaults = lightingOriginal.Effects[effect]
			local enabled = tv("atmosphereenabled", true)
			setLightingProperty(effect, "Color", ov("atmospherecolor", defaults.Color))
			setLightingProperty(effect, "Decay", ov("atmospheredecay", defaults.Decay))
			setLightingProperty(effect, "Density", enabled and ov("atmospheredensity", defaults.Density) or 0)
			setLightingProperty(effect, "Offset", ov("atmosphereoffset", defaults.Offset))
			setLightingProperty(effect, "Haze", enabled and ov("atmospherehaze", defaults.Haze) or 0)
			setLightingProperty(effect, "Glare", enabled and ov("atmosphereglare", defaults.Glare) or 0)
		elseif effect:IsA("BloomEffect") then
			local defaults = lightingOriginal.Effects[effect]
			setLightingProperty(effect, "Enabled", tv("bloomenabled", defaults.Enabled))
			setLightingProperty(effect, "Intensity", ov("bloomintensity", defaults.Intensity))
			setLightingProperty(effect, "Size", ov("bloomsize", defaults.Size))
			setLightingProperty(effect, "Threshold", ov("bloomthreshold", defaults.Threshold))
		elseif effect:IsA("ColorCorrectionEffect") then
			local defaults = lightingOriginal.Effects[effect]
			setLightingProperty(effect, "Enabled", tv("colorcorrectionenabled", defaults.Enabled))
			setLightingProperty(effect, "Brightness", ov("ccbrightness", defaults.Brightness))
			setLightingProperty(effect, "Contrast", ov("cccontrast", defaults.Contrast))
			setLightingProperty(effect, "Saturation", ov("ccsaturation", defaults.Saturation))
			setLightingProperty(effect, "TintColor", ov("cctint", defaults.TintColor))
		elseif effect:IsA("SunRaysEffect") then
			local defaults = lightingOriginal.Effects[effect]
			setLightingProperty(effect, "Enabled", tv("sunraysenabled", defaults.Enabled))
			setLightingProperty(effect, "Intensity", ov("sunraysintensity", defaults.Intensity))
			setLightingProperty(effect, "Spread", ov("sunraysspread", defaults.Spread))
		elseif effect:IsA("DepthOfFieldEffect") and effect.Name == "DepthOfField" then
			local defaults = lightingOriginal.Effects[effect]
			setLightingProperty(effect, "Enabled", tv("dofenabled", defaults.Enabled))
			setLightingProperty(effect, "FarIntensity", ov("doffar", defaults.FarIntensity))
			setLightingProperty(effect, "NearIntensity", ov("dofnear", defaults.NearIntensity))
			setLightingProperty(effect, "FocusDistance", ov("doffocus", defaults.FocusDistance))
			setLightingProperty(effect, "InFocusRadius", ov("dofradius", defaults.InFocusRadius))
		elseif effect:IsA("BlurEffect") then
			local defaults = lightingOriginal.Effects[effect]
			setLightingProperty(effect, "Enabled", tv("blurenabled", defaults.Enabled))
			setLightingProperty(effect, "Size", ov("blursize", defaults.Size))
		end
	end
end

local lightingMain = Tabs.Visuals:AddRightGroupbox("Lighting")
lightingMain:AddToggle(
	"lightingoverride",
	{
		Text = "Lighting Override",
		Default = false,
	}
)
Toggles.lightingoverride:OnChanged(function(val)
	if val then
		applyLighting()
	else
		restoreLighting()
	end
end)
lightingMain:AddToggle("globalshadows", { Text = "Global Shadows", Default = Lighting.GlobalShadows })
lightingMain:AddSlider(
	"lightingbrightness",
	{ Text = "Brightness", Default = Lighting.Brightness, Min = 0, Max = 10, Rounding = 2 }
)
lightingMain:AddSlider(
	"clocktime",
	{ Text = "Clock Time", Default = Lighting.ClockTime, Min = 0, Max = 24, Rounding = 2, Suffix = " h" }
)
lightingMain:AddSlider(
	"exposure",
	{ Text = "Exposure", Default = Lighting.ExposureCompensation, Min = -5, Max = 5, Rounding = 2 }
)
lightingMain:AddSlider(
	"shadowsoftness",
	{ Text = "Shadow Softness", Default = Lighting.ShadowSoftness, Min = 0, Max = 1, Rounding = 2 }
)
lightingMain:AddSlider(
	"diffusescale",
	{ Text = "Environment Diffuse", Default = Lighting.EnvironmentDiffuseScale, Min = 0, Max = 1, Rounding = 2 }
)
lightingMain:AddSlider(
	"specularscale",
	{ Text = "Environment Specular", Default = Lighting.EnvironmentSpecularScale, Min = 0, Max = 1, Rounding = 2 }
)
lightingMain:AddSlider(
	"latitude",
	{ Text = "Sun Latitude", Default = Lighting.GeographicLatitude, Min = -180, Max = 180, Rounding = 1, Suffix = "°" }
)
lightingMain:AddLabel("Ambient"):AddColorPicker("ambientcolor", { Default = Lighting.Ambient, Title = "Ambient" })
lightingMain
	:AddLabel("Outdoor Ambient")
	:AddColorPicker("outdoorambient", { Default = Lighting.OutdoorAmbient, Title = "Outdoor Ambient" })
lightingMain
	:AddLabel("Color Shift Top")
	:AddColorPicker("colorshifttop", { Default = Lighting.ColorShift_Top, Title = "Color Shift Top" })
lightingMain
	:AddLabel("Color Shift Bottom")
	:AddColorPicker("colorshiftbottom", { Default = Lighting.ColorShift_Bottom, Title = "Color Shift Bottom" })

local lightingFog = Tabs.Visuals:AddRightGroupbox("Fog & Atmosphere")
lightingFog:AddLabel("Fog Color"):AddColorPicker("fogcolor", { Default = Lighting.FogColor, Title = "Fog Color" })
lightingFog:AddSlider(
	"fogstart",
	{ Text = "Fog Start", Default = Lighting.FogStart, Min = 0, Max = 10000, Rounding = 0, Suffix = " studs" }
)
lightingFog:AddSlider(
	"fogend",
	{
		Text = "Fog End",
		Default = math.min(Lighting.FogEnd, 100000),
		Min = 0,
		Max = 100000,
		Rounding = 0,
		Suffix = " studs",
	}
)
lightingFog:AddToggle("atmosphereenabled", { Text = "Atmosphere", Default = true })
lightingFog:AddLabel("Atmosphere Color"):AddColorPicker(
	"atmospherecolor",
	{ Default = primaryAtmosphere and primaryAtmosphere.Color or Color3.new(1, 1, 1), Title = "Atmosphere Color" }
)
lightingFog:AddLabel("Atmosphere Decay"):AddColorPicker(
	"atmospheredecay",
	{ Default = primaryAtmosphere and primaryAtmosphere.Decay or Color3.new(1, 1, 1), Title = "Atmosphere Decay" }
)
lightingFog:AddSlider(
	"atmospheredensity",
	{ Text = "Density", Default = primaryAtmosphere and primaryAtmosphere.Density or 0, Min = 0, Max = 1, Rounding = 3 }
)
lightingFog:AddSlider(
	"atmosphereoffset",
	{ Text = "Offset", Default = primaryAtmosphere and primaryAtmosphere.Offset or 0, Min = -1, Max = 1, Rounding = 3 }
)
lightingFog:AddSlider(
	"atmospherehaze",
	{ Text = "Haze", Default = primaryAtmosphere and primaryAtmosphere.Haze or 0, Min = 0, Max = 10, Rounding = 2 }
)
lightingFog:AddSlider(
	"atmosphereglare",
	{ Text = "Glare", Default = primaryAtmosphere and primaryAtmosphere.Glare or 0, Min = 0, Max = 10, Rounding = 2 }
)

local lightingPost = Tabs.Visuals:AddRightGroupbox("Post Processing")
lightingPost:AddToggle("bloomenabled", { Text = "Bloom", Default = primaryBloom and primaryBloom.Enabled or false })
lightingPost:AddSlider(
	"bloomintensity",
	{ Text = "Bloom Intensity", Default = primaryBloom and primaryBloom.Intensity or 0, Min = 0, Max = 10, Rounding = 2 }
)
lightingPost:AddSlider(
	"bloomsize",
	{ Text = "Bloom Size", Default = primaryBloom and primaryBloom.Size or 24, Min = 0, Max = 56, Rounding = 0 }
)
lightingPost:AddSlider(
	"bloomthreshold",
	{ Text = "Bloom Threshold", Default = primaryBloom and primaryBloom.Threshold or 2, Min = 0, Max = 10, Rounding = 2 }
)
lightingPost:AddToggle(
	"colorcorrectionenabled",
	{ Text = "Color Correction", Default = primaryColorCorrection and primaryColorCorrection.Enabled or false }
)
lightingPost:AddSlider(
	"ccbrightness",
	{
		Text = "CC Brightness",
		Default = primaryColorCorrection and primaryColorCorrection.Brightness or 0,
		Min = -1,
		Max = 1,
		Rounding = 2,
	}
)
lightingPost:AddSlider(
	"cccontrast",
	{
		Text = "CC Contrast",
		Default = primaryColorCorrection and primaryColorCorrection.Contrast or 0,
		Min = -1,
		Max = 1,
		Rounding = 2,
	}
)
lightingPost:AddSlider(
	"ccsaturation",
	{
		Text = "CC Saturation",
		Default = primaryColorCorrection and primaryColorCorrection.Saturation or 0,
		Min = -1,
		Max = 1,
		Rounding = 2,
	}
)
lightingPost:AddLabel("CC Tint"):AddColorPicker(
	"cctint",
	{
		Default = primaryColorCorrection and primaryColorCorrection.TintColor or Color3.new(1, 1, 1),
		Title = "Color Correction Tint",
	}
)
lightingPost:AddToggle(
	"sunraysenabled",
	{ Text = "Sun Rays", Default = primarySunRays and primarySunRays.Enabled or false }
)
lightingPost:AddSlider(
	"sunraysintensity",
	{
		Text = "Sun Rays Intensity",
		Default = primarySunRays and primarySunRays.Intensity or 0,
		Min = 0,
		Max = 1,
		Rounding = 3,
	}
)
lightingPost:AddSlider(
	"sunraysspread",
	{ Text = "Sun Rays Spread", Default = primarySunRays and primarySunRays.Spread or 0, Min = 0, Max = 1, Rounding = 3 }
)
lightingPost:AddToggle(
	"dofenabled",
	{ Text = "Depth of Field", Default = primaryDepthOfField and primaryDepthOfField.Enabled or false }
)
lightingPost:AddSlider(
	"doffar",
	{
		Text = "DOF Far Intensity",
		Default = primaryDepthOfField and primaryDepthOfField.FarIntensity or 0,
		Min = 0,
		Max = 1,
		Rounding = 3,
	}
)
lightingPost:AddSlider(
	"dofnear",
	{
		Text = "DOF Near Intensity",
		Default = primaryDepthOfField and primaryDepthOfField.NearIntensity or 0,
		Min = 0,
		Max = 1,
		Rounding = 3,
	}
)
lightingPost:AddSlider(
	"doffocus",
	{
		Text = "DOF Focus Distance",
		Default = primaryDepthOfField and primaryDepthOfField.FocusDistance or 10,
		Min = 0,
		Max = 500,
		Rounding = 1,
	}
)
lightingPost:AddSlider(
	"dofradius",
	{
		Text = "DOF Focus Radius",
		Default = primaryDepthOfField and primaryDepthOfField.InFocusRadius or 30,
		Min = 0,
		Max = 500,
		Rounding = 1,
	}
)
lightingPost:AddToggle("blurenabled", { Text = "Blur", Default = primaryBlur and primaryBlur.Enabled or false })
lightingPost:AddSlider(
	"blursize",
	{ Text = "Blur Size", Default = primaryBlur and primaryBlur.Size or 0, Min = 0, Max = 56, Rounding = 0 }
)

local Tracers = Tabs.Visuals:AddLeftGroupbox("Bullet Tracers")
Tracers:AddToggle("tracersenabled", { Text = "Bullet Tracers Enabled", Default = false })

Tracers:AddToggle("teamtracers", { Text = "Draw Team Tracers", Default = false })
Tracers:AddLabel("Team Tracers Color")
	:AddColorPicker("teamtracerscolor", { Default = Color3.fromRGB(59, 144, 204), Title = "Team Tracer Color" })
Tracers:AddDropdown(
	"teamtracersmaterial",
	{
		Text = "Team Tracer Material",
		Values = { "Plastic", "SmoothPlastic", "ForceField", "Neon", "Glass" },
		Default = 1,
		Multi = false,
	}
)
Tracers:AddSlider(
	"teamtracerstransparency",
	{
		Text = "Team Tracer Transparency",
		Default = 0.5,
		Min = 0,
		Max = 1,
		Rounding = 2,
	}
)

Tracers:AddToggle("enemytracers", { Text = "Draw Enemy Tracers", Default = false })
Tracers:AddLabel("Enemy Tracers Color")
	:AddColorPicker("enemytracerscolor", { Default = Color3.fromRGB(255, 60, 60), Title = "Enemy Tracer Color" })
Tracers:AddDropdown(
	"enemytracersmaterial",
	{
		Text = "Enemy Tracer Material",
		Values = { "Plastic", "SmoothPlastic", "ForceField", "Neon", "Glass" },
		Default = 1,
		Multi = false,
	}
)
Tracers:AddSlider(
	"enemytracerstransparency",
	{
		Text = "Enemy Tracer Transparency",
		Default = 0.5,
		Min = 0,
		Max = 1,
		Rounding = 2,
	}
)
Tracers:AddToggle("localtracers", { Text = "Draw Local Tracers", Default = false })
Tracers:AddLabel("Local Tracers Color")
	:AddColorPicker("localtracerscolor", { Default = Color3.fromRGB(59, 255, 50), Title = "Local Tracer Color" })
Tracers:AddDropdown(
	"localtracersmaterial",
	{
		Text = "Local Tracer Material",
		Values = { "Plastic", "SmoothPlastic", "ForceField", "Neon", "Glass" },
		Default = 1,
		Multi = false,
	}
)
Tracers:AddSlider(
	"localtracerstransparency",
	{
		Text = "Local Tracer Transparency",
		Default = 0.5,
		Min = 0,
		Max = 1,
		Rounding = 2,
	}
)
Tracers:AddSlider("bullettracersize", { Text = "Bullet Tracer Size", Default = 0.1, Min = 0.01, Max = 1, Rounding = 2 })

local moderatorListVisible = true
local moderatorListX = 10
local moderatorListY = 200
local moderatorDrawing = Drawing.new("Text")
moderatorDrawing.Text = "Moderators\nChecking players..."
moderatorDrawing.Position = Vector2.new(moderatorListX, moderatorListY)
moderatorDrawing.Size = 14
moderatorDrawing.Color = Color3.fromRGB(255, 255, 255)
moderatorDrawing.Outline = true
moderatorDrawing.OutlineColor = Color3.fromRGB(0, 0, 0)
moderatorDrawing.Visible = moderatorListVisible
local moderatorState = {}
local moderatorConnections = {}
local moderatorPlayerAdded
local moderatorPlayerRemoving

local function updateModeratorList()
	LPH_ATTRIBUTES(VM(NONE))
	local names = {}
	for player, state in pairs(moderatorState) do
		if player.Parent == Players and state.IsModerator then
			local sources = {}
			if state.Rank >= 240 then
				sources[#sources + 1] = "Rank " .. state.Rank
			end
			if state.ControlPanel then
				sources[#sources + 1] = "Control Panel"
			end
			names[#names + 1] = {
				SortName = player.Name:lower(),
				Text = string.format("%s (@%s) [%s]", player.DisplayName, player.Name, table.concat(sources, ", ")),
			}
		end
	end
	table.sort(names, function(a, b)
		return a.SortName < b.SortName
	end)

	local lines = {}
	for _, entry in ipairs(names) do
		lines[#lines + 1] = entry.Text
	end
	if moderatorDrawing then
		moderatorDrawing.Text = "Moderators\n" .. (#lines > 0 and table.concat(lines, "\n") or "No moderators online")
	end
end

local function trackModerator(player)
	LPH_ATTRIBUTES(VM(NONE))
	if moderatorConnections[player] then
		moderatorConnections[player]:Disconnect()
	end

	local hasControlPanel = player:GetAttribute("ControlPanelAccess") == true
	local state = {
		Rank = 0,
		ControlPanel = hasControlPanel,
		IsModerator = hasControlPanel,
	}
	moderatorState[player] = state
	updateModeratorList()

	moderatorConnections[player] = player:GetAttributeChangedSignal("ControlPanelAccess"):Connect(function()
		state.ControlPanel = player:GetAttribute("ControlPanelAccess") == true
		state.IsModerator = state.Rank >= 240 or state.ControlPanel
		updateModeratorList()
	end)

	task.spawn(function()
		local ok, rank = pcall(player.GetRankInGroup, player, 32519006)
		if moderatorState[player] ~= state then
			return
		end
		state.Rank = ok and rank or 0
		state.IsModerator = state.Rank >= 240 or state.ControlPanel
		updateModeratorList()
	end)
end

local function untrackModerator(player)
	LPH_ATTRIBUTES(VM(NONE))
	if moderatorConnections[player] then
		moderatorConnections[player]:Disconnect()
		moderatorConnections[player] = nil
	end
	moderatorState[player] = nil
	updateModeratorList()
end

for _, player in ipairs(Players:GetPlayers()) do
	trackModerator(player)
end
moderatorPlayerAdded = Players.PlayerAdded:Connect(trackModerator)
moderatorPlayerRemoving = Players.PlayerRemoving:Connect(untrackModerator)

local walkSpeedConnection
local walkSpeedCharacterConnection
local jumpPowerConnection
local function bindWalkSpeed(character)
	if walkSpeedConnection then
		walkSpeedConnection:Disconnect()
		walkSpeedConnection = nil
	end
	local humanoid = character
		and (character:FindFirstChildWhichIsA("Humanoid") or character:WaitForChild("Humanoid", 5))
	if not humanoid then
		return
	end
	local applying = false
	local function applyWalkSpeed()
		if not tv("walkspeedenabled", false) or applying then
			return
		end
		applying = true
		humanoid.WalkSpeed = ov("walkspeed", 16)
		applying = false
	end
	applyWalkSpeed()
	walkSpeedConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(applyWalkSpeed)
end
local function bindJumpPower(character)
	if jumpPowerConnection then
		jumpPowerConnection:Disconnect()
		jumpPowerConnection = nil
	end
	local humanoid = character
		and (character:FindFirstChildWhichIsA("Humanoid") or character:WaitForChild("Humanoid", 5))
	if not humanoid then
		return
	end
	local applying = false
	local function applyJumpPower()
		if not tv("jumppowerenabled", false) or applying then
			return
		end
		applying = true
		humanoid.UseJumpPower = true
		humanoid.JumpPower = ov("jumppower", 50)
		applying = false
	end
	applyJumpPower()
	jumpPowerConnection = humanoid:GetPropertyChangedSignal("JumpPower"):Connect(applyJumpPower)
end
walkSpeedCharacterConnection = LocalPlayer.CharacterAdded:Connect(function(character)
	bindWalkSpeed(character)
	bindJumpPower(character)
end)
bindWalkSpeed(LocalPlayer.Character)
bindJumpPower(LocalPlayer.Character)

local spinHumanoid
local spinAutoRotate
local spinAngle = 0
local function movementStep(dt)
	LPH_ATTRIBUTES(VM(NONE))
	if not flags.antiaimspin and not spinHumanoid then
		return
	end
	local character = LocalPlayer.Character
	local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not (humanoid and root) then
		return
	end
	local inVehicle = humanoid.Sit
		or humanoid.SeatPart ~= nil
		or LocalPlayer:GetAttribute("InVehicle") == true
		or character:GetAttribute("InVehicle") == true
		or root:FindFirstChild("SeatWeld") ~= nil

	if flags.antiaimspin and not inVehicle then
		if spinHumanoid ~= humanoid then
			if spinHumanoid and spinHumanoid.Parent and spinAutoRotate ~= nil then
				spinHumanoid.AutoRotate = spinAutoRotate
			end
			spinHumanoid = humanoid
			spinAutoRotate = humanoid.AutoRotate
			spinAngle = select(2, root.CFrame:ToOrientation())
		end
		humanoid.AutoRotate = false
	elseif spinHumanoid then
		if spinHumanoid.Parent and spinAutoRotate ~= nil then
			spinHumanoid.AutoRotate = spinAutoRotate
		end
		spinHumanoid = nil
		spinAutoRotate = nil
	end

	if flags.antiaimspin and not inVehicle then
		spinAngle = (spinAngle + math.rad(ov("antiaimspinspeed", 180)) * dt) % math.tau
		root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, spinAngle, 0)
	end
end
if la_is_premium then
    local miscMove = Tabs.Misc:AddLeftGroupbox("Movement")
    miscMove:AddToggle(
    	"walkspeedenabled",
    	{ Text = "WalkSpeed", Default = false }
    )
    Toggles.walkspeedenabled:OnChanged(function(val)
    	bindWalkSpeed(LocalPlayer.Character)
    end)
    miscMove:AddSlider("walkspeed", { Text = "WalkSpeed Value", Default = 16, Min = 0, Max = 50, Rounding = 0 })
    Options.walkspeed:OnChanged(function(val)
    	bindWalkSpeed(LocalPlayer.Character)
    end)
    miscMove:AddToggle(
    	"jumppowerenabled",
    	{ Text = "JumpPower", Default = false }
    )
    Toggles.jumppowerenabled:OnChanged(function(val)
    	bindJumpPower(LocalPlayer.Character)
    end)
    miscMove:AddSlider(
    	"jumppower",
    	{
    		Text = "JumpPower Value",
    		Default = 50,
    		Min = 0,
    		Max = 100,
    		Rounding = 0,
    	}
    )
    Options.jumppower:OnChanged(function(val)
    	bindJumpPower(LocalPlayer.Character)
    end)
    miscMove:AddToggle("omnisprint", { Text = "Omni Sprint", Default = false })
    miscMove:AddToggle(
    	"nohurtslowdown",
    	{ Text = "No Hurt Slowdown", Default = false }
    )

    local miscAntiAim = Tabs.Misc:AddLeftGroupbox("Anti Aim")
    miscAntiAim:AddToggle(
    	"antiaimpitch",
    	{
    		Text = "Head Pitch",
    		Default = false,
    	}
    )
    miscAntiAim:AddSlider(
    	"antiaimpitchangle",
    	{ Text = "Head Pitch Angle", Default = 90, Min = -180, Max = 180, Rounding = 0, Suffix = "°" }
    )
    miscAntiAim:AddToggle(
    	"gunup",
    	{ Text = "Always Gun Up", Default = false }
    )
    miscAntiAim:AddToggle("antiaimspin", { Text = "Spin", Default = false })
    Toggles.antiaimspin:OnChanged(function(val)
    	if not val and spinHumanoid then
    		if spinHumanoid.Parent and spinAutoRotate ~= nil then
    			spinHumanoid.AutoRotate = spinAutoRotate
    		end
    		spinHumanoid = nil
    		spinAutoRotate = nil
    	end
    end)
    miscAntiAim:AddSlider(
    	"antiaimspinspeed",
    	{ Text = "Spin Speed", Default = 180, Min = 0, Max = 1080, Rounding = 0, Suffix = "°/s" }
    )

    local function clearCharacterEffects(character)
    	local values = character and character:FindFirstChild("CharacterValues")
    	if not values then
    		return
    	end
	if flags.antisuppression then
     		local suppression = values:FindFirstChild("Suppression")
    		local deafening = values:FindFirstChild("Deafening")
    		if suppression then
    			suppression.Value = 0
    		end
    		if deafening then
    			deafening.Value = 0
    		end
    	end
    end

    local suppressionDepthEffect = game:GetService("Lighting"):FindFirstChild("SuppressionDepthOfField")
    local suppressionDepthWasEnabled = suppressionDepthEffect and suppressionDepthEffect.Enabled
    local antiEffectsAcc = 0
    function antiEffectsStep(dt)
    	LPH_ATTRIBUTES(VM(NONE))
    	if not (flags.antisuppression or flags.antiflashbang) then
    		return
    	end
    	antiEffectsAcc = antiEffectsAcc + dt
    	if antiEffectsAcc < 0.5 then
    		return
    	end
    	antiEffectsAcc = 0
    	clearCharacterEffects(LocalPlayer.Character)

     	if flags.antisuppression then
     		suppressionDepthEffect = game:GetService("Lighting"):FindFirstChild("SuppressionDepthOfField")
    			or suppressionDepthEffect
    		if suppressionDepthEffect and suppressionDepthEffect:IsA("PostEffect") then
    			suppressionDepthEffect.Enabled = false
    		end
    	end

     	if flags.antiflashbang then
    		for _, container in ipairs({ game:GetService("Lighting"), LocalPlayer:FindFirstChildOfClass("PlayerGui") }) do
    			if container then
    				for _, effect in ipairs(container:GetDescendants()) do
    					local name = effect.Name:lower()
    					if
    						name:find("flash", 1, true)
    						or name:find("stun", 1, true)
    						or name:find("concussion", 1, true)
    					then
    						if effect:IsA("PostEffect") then
    							effect.Enabled = false
    						elseif effect:IsA("LayerCollector") then
    							effect.Enabled = false
    						elseif effect:IsA("GuiObject") then
    							effect.Visible = false
    						end
    					end
    				end
    			end
    		end
    	end
    end

    local miscEffects = Tabs.Misc:AddLeftGroupbox("Screen Effects")
    miscEffects:AddToggle(
    	"antisuppression",
    	{
    		Text = "Anti Suppression",
    		Default = false,
    	}
    )
    Toggles.antisuppression:OnChanged(function(val)
    	if val then
    		clearCharacterEffects(LocalPlayer.Character)
    	elseif suppressionDepthEffect and suppressionDepthEffect.Parent then
    		suppressionDepthEffect.Enabled = suppressionDepthWasEnabled
    	end
    end)
    miscEffects:AddToggle(
    	"antiflashbang",
    	{
    		Text = "Anti Flashbang",
    		Default = false,
    	}
    )

    local miscHeal = Tabs.Misc:AddRightGroupbox("Healing")
    miscHeal:AddToggle("autoheal", { Text = "Auto Heal", Default = false })
    miscHeal:AddToggle("instantheal", { Text = "Instant Heal", Default = false })
    local originalHealSpeed = functions.healLimb.upv and functions.healLimb.upv[7]
    local modifiedHealSpeed = {}
    miscHeal:AddToggle("nobandageslowdown", { Text = "No Bandage Slowdown", Default = false })
    Toggles["nobandageslowdown"]:OnChanged(function(val)
    	if la_is_premium ~= true or not functions.healLimb.func then return end
    	if val then
    		debug.setupvalue(functions.healLimb.func, 7, modifiedHealSpeed)
    	else
    		debug.setupvalue(functions.healLimb.func, 7, originalHealSpeed)
    	end
    end)
    miscHeal:AddToggle("fastrevive", { Text = "Fast Revive", Default = false })

    local miscVehicle = Tabs.Misc:AddRightGroupbox("Vehicles")
    miscVehicle:AddToggle("carmods", { Text = "Car Mods", Default = false })
    Toggles["carmods"]:OnChanged(function(val)
    	applyCarMods()
    end)
    miscVehicle:AddDropdown(
    	"carprofile",
    	{ Text = "Car", Values = carEntries, Default = 1, Multi = false, AllowNull = true }
    )
    Options.carprofile:OnChanged(function(value)
    	selectedCar = value
    	local profile = selectedCarProfile()
    	if not profile then
    		return
    	end
    	for key in pairs(carDefaults) do
    		if Options["car_" .. key] then
    			Options["car_" .. key]:SetValue(profile[key])
    		end
    	end
    	for key in pairs(carBoolDefaults) do
    		if Toggles["car_" .. key] then
    			Toggles["car_" .. key]:SetValue(profile[key])
    		end
    	end
    	for key, values in pairs({
    		ChassisType = { "Wheeled", "Tracked" },
    		DriveType = { "FWD", "RWD", "AWD" },
    		Differential = { "Open", "Locked" },
    	}) do
    		if Options["car_" .. key] then
    			Options["car_" .. key]:SetValue(profile[key])
    		end
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
    	{ "FinalDrive", "Final Drive", 0, 20, 2 },
    	{ "ShiftRPM", "Shift RPM", 1000, 15000, 0 },
    	{ "IdleRPM", "Idle RPM", 0, 5000, 0 },
    	{ "IdleTorque", "Idle Torque", 0, 2000, 0 },
    	{ "PeakTorque", "Peak Torque", 0, 3000, 0 },
    	{ "PeakTorqueRPM", "Peak Torque RPM", 0, 15000, 0 },
    	{ "RedlineRPM", "Redline RPM", 1000, 20000, 0 },
    	{ "RedlineTorque", "Redline Torque", 0, 3000, 0 },
    	{ "HorsepowerLimit", "Horsepower Limit", 0, 3000, 0 },
    	{ "TorqueScale", "Torque Scale", 0, 20, 2 },
    	{ "TopSpeed", "Top Speed", 0, 500, 0 },
    	{ "PeakGrip", "Peak Grip", 0, 10, 2 },
    	{ "SlideGrip", "Slide Grip", 0, 10, 2 },
    	{ "PeakSlip", "Peak Slip", 0, 5, 2 },
    	{ "Grip", "Grip", 0, 200, 1 },
    	{ "BrakeMultiplier", "Brake Multiplier", 0, 50, 2 },
    	{ "HandBrakeMultiplier", "Handbrake Multiplier", 0, 50, 2 },
    	{ "RollingFriction", "Rolling Friction", 0, 2, 2 },
    	{ "TurningZForceMultiplier", "Turning Z Force", 0, 10, 2 },
    	{ "TurnRadius", "Turn Radius", 0, 100, 1 },
    	{ "SteerSpeed", "Steer Speed", 0, 20, 2 },
    	{ "HighSpeedSteerReduction", "High Speed Steering", 0, 1, 2 },
    	{ "ForceHeight", "Force Height", -5, 5, 2 },
    	{ "Mass", "Mass", 0, 5000, 0 },
    	{ "WheelMass", "Wheel Mass", 0, 100, 1 },
    	{ "SuspensionHeight", "Suspension Height", 0, 10, 2 },
    	{ "RideHeight", "Ride Height", -5, 10, 2 },
    	{ "WheelOffset", "Wheel Offset", -5, 5, 2 },
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
    		if not profile then
    			return
    		end
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
    		if not profile then
    			return
    		end
    		profile.Wheels = profile.Wheels or {}
    		profile.Wheels[index] = profile.Wheels[index]
    			or { Name = label:gsub(" ", ""), Drive = true, Steer = index <= 2 and 1 or 0 }
    		profile.Wheels[index].Drive = value
    		syncCarProfileJson()
    		applyCarMods()
    	end)
    	Toggles[prefix .. "steer"]:OnChanged(function(value)
    		local profile = selectedCarProfile()
    		if not profile then
    			return
    		end
    		profile.Wheels = profile.Wheels or {}
    		profile.Wheels[index] = profile.Wheels[index]
    			or { Name = label:gsub(" ", ""), Drive = true, Steer = index <= 2 and 1 or 0 }
    		profile.Wheels[index].Steer = value and 1 or 0
    		syncCarProfileJson()
    		applyCarMods()
    	end)
    end
    for _, info in ipairs(carSliderInfo) do
    	local key, text, min, max, rounding = table.unpack(info)
    	miscVehicle:AddSlider(
    		"car_" .. key,
    		{ Text = text, Default = carDefaults[key], Min = min, Max = max, Rounding = rounding }
    	)
    	Options["car_" .. key]:OnChanged(function(value)
    		setCarControlValue(key, value)
    	end)
    end
    for key, default in pairs(carBoolDefaults) do
    	miscVehicle:AddToggle("car_" .. key, { Text = key, Default = default })
    	Toggles["car_" .. key]:OnChanged(function(value)
    		setCarControlValue(key, value)
    	end)
    end
    for key, values in pairs({
    	ChassisType = { "Wheeled", "Tracked" },
    	DriveType = { "FWD", "RWD", "AWD" },
    	Differential = { "Open", "Locked" },
    }) do
    	miscVehicle:AddDropdown(
    		"car_" .. key,
    		{ Text = key, Values = values, Default = carChoiceDefaults[key], Multi = false }
    	)
    	Options["car_" .. key]:OnChanged(function(value)
    		setCarControlValue(key, value)
    	end)
    end
    miscVehicle:AddInput("carsprofiles", { Text = "Profile data", Default = "{}" })
    Options.carsprofiles:OnChanged(function(value)
    	loadCarProfileJson(value)
    	syncCarProfileJson()
    	applyCarMods()
    end)
    if selectedCar then
    	Options.carprofile:SetValue(selectedCar)
    end
end

local menuGroup = Tabs.Settings:AddLeftGroupbox("Menu")

local DiscordInvite = "NUfjhQcETc"

local function openDiscordInvite(code)
	local request = http_request
		or request
		or (syn and syn.request)
		or (fluxus and fluxus.request)
		or (getgenv and getgenv().request)
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
menuGroup
	:AddLabel("Menu bind")
	:AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
menuGroup
	:AddToggle(
		"ShowKeybindList",
		{ Text = "Show Keybind List", Default = true }
	)
	:OnChanged(function(val)
		if Library and Library.KeybindFrame then
			Library.KeybindFrame.Visible = val
		end
	end)
menuGroup
	:AddToggle(
		"ShowModeratorList",
		{ Text = "Show Moderator List", Default = true }
	)
	:OnChanged(function(val)
		moderatorListVisible = val
		if moderatorDrawing then
			moderatorDrawing.Visible = val
		end
	end)
menuGroup:AddSlider(
	"ModeratorListX",
	{ Text = "Moderator List X", Default = 10, Min = 0, Max = 2000, Rounding = 0, Suffix = " px" }
)
Options.ModeratorListX:OnChanged(function(val)
	moderatorListX = val
	if moderatorDrawing then
		moderatorDrawing.Position = Vector2.new(moderatorListX, moderatorListY)
	end
end)
menuGroup:AddSlider(
	"ModeratorListY",
	{ Text = "Moderator List Y", Default = 200, Min = 0, Max = 1200, Rounding = 0, Suffix = " px" }
)
Options.ModeratorListY:OnChanged(function(val)
	moderatorListY = val
	if moderatorDrawing then
		moderatorDrawing.Position = Vector2.new(moderatorListX, moderatorListY)
	end
end)

Library.ToggleKeybind = Options.MenuKeybind

for key in flags do
	local toggle = Toggles and Toggles[key]
	if toggle then
		toggle:OnChanged(function(value)
			if paidToggleKeys[key] and la_is_premium ~= true then
				flags[key] = false
				return
			end
			flags[key] = value
		end)
		if toggle.Value ~= nil then
			flags[key] = (paidToggleKeys[key] and la_is_premium ~= true) and false or toggle.Value
		end
	else
		local option = Options and Options[key]
		if option and option.Value ~= nil then
			option:OnChanged(function(value)
				if paidOptionKeys[key] and la_is_premium ~= true then
					return
				end
				flags[key] = value
			end)
			flags[key] = option.Value
		end
	end
end

local heartbeatConn = RunService.Heartbeat:Connect(function(dt)
	LPH_ATTRIBUTES(VM(NONE))
	if flags.silentenabled or flags.turretsilentenabled or flags.aimbotenabled or flags.snaplines then
		targetStep()
	end
	if la_is_premium then
		if flags.antiaimspin then
			movementStep(dt)
		end
		if flags.autoheal then
			autoHealStep(dt)
		end
		if flags.fastrevive then
			fastReviveStep(dt)
		end
		if flags.carmods then
			carModsStep(dt)
		end
		if flags.antisuppression or flags.antiflashbang then
			antiEffectsStep(dt)
		end
		if flags.ragebot or flags.ragebottpaura then
			rageSchedulerStep(dt)
		end
	end
	if flags.ESPMaster then
		teamFilterStep(dt)
	end
	if flags.lightingoverride then
		applyLighting()
	end
end)

RunService:BindToRenderStep("cwmain", Enum.RenderPriority.Last.Value + 10, function()
	LPH_ATTRIBUTES(VM(NONE))
	if flags.aimbotenabled then
		aimbotRenderStep()
	end
	if flags.fovdraw then
		fovRenderStep()
	elseif fovCircle.Visible then
		fovCircle.Visible = false
	end
	if flags.snaplines then
		snapRenderStep()
	elseif snapLine.Visible then
		snapLine.Visible = false
	end
end)

Library:OnUnload(function()
	if heartbeatConn then
		heartbeatConn:Disconnect()
		heartbeatConn = nil
	end
	pcall(function()
		RunService:UnbindFromRenderStep("cwmain")
	end)
	restoreLighting()

	if walkSpeedConnection then
		walkSpeedConnection:Disconnect()
		walkSpeedConnection = nil
	end
	if jumpPowerConnection then
		jumpPowerConnection:Disconnect()
		jumpPowerConnection = nil
	end
	if walkSpeedCharacterConnection then
		walkSpeedCharacterConnection:Disconnect()
		walkSpeedCharacterConnection = nil
	end
	if spinHumanoid and spinHumanoid.Parent and spinAutoRotate ~= nil then
		spinHumanoid.AutoRotate = spinAutoRotate
	end
	spinHumanoid = nil
	spinAutoRotate = nil
	local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
		humanoid.PlatformStand = false
	end
	if moderatorPlayerAdded then
		moderatorPlayerAdded:Disconnect()
		moderatorPlayerAdded = nil
	end
	if moderatorPlayerRemoving then
		moderatorPlayerRemoving:Disconnect()
		moderatorPlayerRemoving = nil
	end
	for player, connection in pairs(moderatorConnections) do
		connection:Disconnect()
		moderatorConnections[player] = nil
	end
	if moderatorDrawing then
		moderatorDrawing:Remove()
		moderatorDrawing = nil
	end
	if fovGui then
		fovGui:Destroy()
		fovGui = nil
	end
	if snapGui then
		snapGui:Destroy()
		snapGui = nil
	end
	if ESP then
		pcall(function()
			ESP:Unload()
		end)
	end
end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("VaultCC")
SaveManager:SetFolder("VaultCC/ColdWar")

SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

SaveManager:LoadAutoloadConfig()

if Library and Library.KeybindFrame then
	Library.KeybindFrame.Visible = true
end

Library:Notify("Cold War loaded, made with love by vaultt. <3")
