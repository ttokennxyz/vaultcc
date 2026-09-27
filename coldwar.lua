local a={cache={}}do do local function b()local c = game:GetService("HttpService")

local function d()
    return game:GetService("RbxAnalyticsService"):GetClientId()
end

gethwid = gethwid or d

local function e(f)
    if not LPH_OBFUSCATED then
        return true, true
    end

    local g = request({
        Url = "https://auth.rbxkey.store/api/auth/verify",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = c:JSONEncode({
            key = f or nil,
            executor = identifyexecutor(),
            fingerprint = gethwid()
        })
    })

    local h = c:JSONDecode(g.Body)

    local i = h.expires_at == nil
    local j = h.valid == true

    return j, i
end

return {
    checkKey = e
}
end function a.a()local c=a.cache.a if not c then c={c=b()}a.cache.a=c end return c.c end end do local function b()
local function c(d)
	local e = {}

	function e.build(f)
		local g = f.Library
		local h = g:CreateWindow({
			Title = d.title,
			Center = true,
			AutoShow = true,
			TabPadding = 8,
			MenuFadeTime = 0.2,
		})
		f.Window = h
		f.Tabs = {}
		for i, j in d.tabs do
			f.Tabs[j] = h:AddTab(j)
		end
	end

	function e.finish(f)
		local g = f.Tabs
		local h = f.Library
		local i = f.ThemeManager
		local j = f.SaveManager
		local k = g.Settings or g["UI Settings"]
		if not k then
			return
		end
		local l = d.keybind or "menubind"
		local m = k:AddLeftGroupbox("Menu")
		m:AddButton({
			Text = "Unload",
			Func = function()
				h:Unload()
			end,
		})
		m:AddLabel("Menu keybind"):AddKeyPicker(l, {
			Default = d.keybindDefault or "RightShift",
			NoUI = true,
			Text = "Menu keybind",
		})
		h.ToggleKeybind = Options[l]
		if not d.hideKeybindList then
			m
				:AddToggle("ShowKeybindList", { Text = "Show Keybind List", Default = true })
				:OnChanged(function(n)
					if h and h.KeybindFrame then
						h.KeybindFrame.Visible = n
					end
				end)
		end
		i:SetLibrary(h)
		j:SetLibrary(h)
		if j.Parser and j.Parser.Slider then
			local n = j.Parser.Slider.Load
			j.Parser.Slider.Load = function(o, p)
				if Options[o] then
					Options[o]:SetValue(tonumber(p.value) or p.value)
				elseif n then
					n(o, p)
				end
			end
		end
		j:IgnoreThemeSettings()
		j:SetIgnoreIndexes(d.ignore or { l })
		i:SetFolder("VaultCC")
		j:SetFolder(d.folder)
		j:BuildConfigSection(k)
		if h.IsMobile then
			local function n()
				local o = game:GetService("CoreGui")
				local p = UDim2.new(1, 0, 0, 36)
				local function q(r)
					local s
					for t, u in r:GetDescendants() do
						if u:IsA("TextLabel") then
							local v = u.Text
							if v == "Load" or v == "Save" or v == "Create" or v == "Delete" then
								s = v
							end
						end
					end
					return s
				end
				for r, s in o:GetDescendants() do
					if s:IsA("TextLabel") and s.Text == "Load" then
						local t = s:FindFirstAncestorWhichIsA("TextButton")
						local u = t and t.Parent
						if u and u:IsA("GuiObject") then
							local v = u:FindFirstChildOfClass("UIListLayout")
							if v then
								v.FillDirection = Enum.FillDirection.Vertical
								v.HorizontalAlignment = Enum.HorizontalAlignment.Center
								v.Padding = UDim.new(0, 4)
							end
							u.AutomaticSize = Enum.AutomaticSize.Y
							u.Size = UDim2.new(1, 0, 0, 0)
							local w
							for x, y in u:GetChildren() do
								if y:IsA("GuiButton") then
									y.Size = p
									if q(y) == "Save" then
										w = y
									end
									if not y:GetAttribute("vaultPinned") then
										y:SetAttribute("vaultPinned", true)
										y:GetPropertyChangedSignal("Size"):Connect(function()
											if y.Parent and y.Size ~= p then
												y.Size = p
											end
										end)
									end
								end
							end
							if w and t and not t:GetAttribute("vaultLoadGuard") then
								t:SetAttribute("vaultLoadGuard", true)
								t.InputBegan:Connect(function(x)
									local y = x.UserInputType
									if y ~= Enum.UserInputType.Touch and y ~= Enum.UserInputType.MouseButton1 then
										return
									end
									w.Active = false
									task.delay(0.4, function()
										if w.Parent then
											w.Active = true
										end
									end)
								end)
							end
						end
						break
					end
				end
			end
			task.defer(n)
			task.delay(1, n)
		end
		i:ApplyToTab(k)
		if d.beforeLoad then
			d.beforeLoad(f, m)
		end
		j:LoadAutoloadConfig()
		if d.afterLoad then
			d.afterLoad(f)
		end
		if h.KeybindFrame and not d.hideKeybindList then
			h.KeybindFrame.Visible = Toggles.ShowKeybindList == nil or Toggles.ShowKeybindList.Value ~= false
		end
	end

	function e.step()
	end

	function e.unload()
	end

	return e
end

return {
	create = c,
}
end function a.b()local c=a.cache.b if not c then c={c=b()}a.cache.b=c end return c.c end end do local function b()
local c = workspace.Raycast

local d = {
	Vector3.new(1, 0, 0),
	Vector3.new(-1, 0, 0),
	Vector3.new(0, 0, 1),
	Vector3.new(0, 0, -1),
	Vector3.new(0, 1, 0),
	Vector3.new(0, -1, 0),
}
local e = {
	Vector3.new(0.5, 0, 0),
	Vector3.new(-0.5, 0, 0),
	Vector3.new(0, 0, 0.5),
	Vector3.new(0, 0, -0.5),
	Vector3.new(0, 0.5, 0),
	Vector3.new(0, -0.5, 0),
}
local f = {
	Vector3.new(0.5, 0.5, 0),
	Vector3.new(0.5, -0.5, 0),
	Vector3.new(-0.5, 0.5, 0),
	Vector3.new(-0.5, -0.5, 0),
	Vector3.new(0, 0.5, 0.5),
	Vector3.new(0, -0.5, 0.5),
	Vector3.new(0, 0.5, -0.5),
	Vector3.new(0, -0.5, -0.5),
}

local function g(...)
	local h = {}
	for i = 1, select("#", ...) do
		local j = select(i, ...)
		for k = 1, #j do
			h[#h + 1] = j[k]
		end
	end
	return h
end

local h = {
	Low = d,
	Medium = g(e, d),
	High = g(e, f, d),
}

local i = RaycastParams.new()
i.FilterType = Enum.RaycastFilterType.Exclude
i.IgnoreWater = true

local function j(k, l, m, n, o, p, q)
	LPH_ATTRIBUTES(VM(NONE))
	if typeof(k) ~= "Vector3" or typeof(l) ~= "Vector3" then
		return nil
	end
	if o(k, l) then
		return k
	end
	m = tonumber(m) or 0
	if m <= 0 then
		return nil
	end
	q = tonumber(q)
	local r = h[n] or h.High
	i.FilterDescendantsInstances = p or {}
	for s = 1, #r do
		local t = r[s] * m
		if q and math.abs(t.Y) > q then
			t = Vector3.new(t.X, math.sign(t.Y) * q, t.Z)
		end
		local u = k + t
		if not c(workspace, k, u - k, i) and o(u, l) then
			return u
		end
	end
	return nil
end

return {
	solve = j,
}
end function a.c()local c=a.cache.c if not c then c={c=b()}a.cache.c=c end return c.c end end do local function b()
local c = {}

function c.build(d)
	local e = d.flags
	local f = d.tv
	local g = d.ov
	local h = d.util
	local i = d.Players
	local j = d.RunService
	local k = d.UserInputService
	local l = d.LocalPlayer
	local m = d.RS
	local n = d.Library
	local o = d.Tabs
	local p = d.HttpService
	local q = d.manipulation
	local r = d.RecoilController
	local s = d.AimController
	local t = d.FiremodeController
	local u = d.Trajectory
	local v = d.InventoryController
	local w = d.CameraShaker
	local x = d.paidToggleKeys
	local y = d.paidOptionKeys
	local z = d.Client
	local A = d.Tools
	local B = d.WeaponControllers
	local C = d.cloneOriginal
local D
local E = false
local function F(G)
	LPH_ATTRIBUTES(VM(NONE))
	return type(G) == "table" and G.ExplosionSettings ~= nil
end
local function G(H, I)
	LPH_ATTRIBUTES(VM(NONE))
	return type(H) == "table" and (H.AmmoTypeName == "Rocket" or F(I))
end
local function H(I, J, K, L)
	LPH_ATTRIBUTES(VM(NONE))
	if not (e.rpgprediction and J and K and L) then
		return J.Position
	end
	local M = J.AssemblyLinearVelocity or Vector3.zero
	local N = L.MuzzleVelocity or K.MuzzleVelocity or 0
	if N <= 0 then
		return J.Position
	end

	local O = workspace.Gravity
	local P = J.Position
	local Q = (P - I).Magnitude / N
	for R = 1, 3 do
		P = J.Position + M * Q
		local S = (P - I).Magnitude
		Q = S / N
	end

	local R = math.clamp(g("rpgpredictionstrength", 1), 0, 2)
	return P + Vector3.new(0, O * Q * Q * 0.5 * R, 0)
end

local function I(J)
	LPH_ATTRIBUTES(VM(NONE))
	if not J then
		return false
	end
	local K = J:FindFirstChild("CharacterValues")
	local L = K and K:FindFirstChild("Unconscious")
	return L ~= nil and L.Value == true
end

local J = 0

local function K(L)
	LPH_ATTRIBUTES(VM(NONE))
	if not L or not L.Parent then
		return false
	end
	local M = L.Parent:FindFirstChildOfClass("Humanoid")
	return M ~= nil and M.Health > 0
end

local L = nil
local M = 0
local N = RaycastParams.new()
N.FilterType = Enum.RaycastFilterType.Exclude
local O = {}
local P = nil
local Q = 0

local function R()
	LPH_ATTRIBUTES(VM(NONE))
	local S = os.clock()
	if S - M < 0.05 then
		return L
	end
	M = S

	local T = workspace.CurrentCamera
	if not T then
		L = nil
		return nil
	end

	local U = l
	local V = U.Character
	local W = U.Team
	local X = T.CFrame.Position
	local Y = k:GetMouseLocation()
	local Z, _
	local aa = e.silenttarget
	local ab = e.silentteamcheck
	local ac = e.silentdistancecheck
	local ad = e.silentmaxdistance
	local ae = e.fovenabled
	local af = e.fovsize
	local ag = e.silentvisiblecheck

	table.clear(O)
	if V then
		O[1] = V
	end
	local ah = workspace:FindFirstChild("Ignore")
	if ah then
		O[#O + 1] = ah
	end
	if ag then
		N.FilterDescendantsInstances = O
	end

	for ai, aj in i:GetPlayers() do
		local ak = aj.Character
		if aj ~= U and ak and not I(ak) then
			if not (ab and W and aj.Team == W) then
				local al = ak:FindFirstChild(aa)
				local am = ak:FindFirstChildOfClass("Humanoid")
				if al and am and am.Health > 0 then
					local an = al.Position
					local ao = (an - X).Magnitude
					if (not ac) or ao <= ad then
						local ap, aq = T:WorldToViewportPoint(an)
						if aq and ap.Z > 0 then
							local ar = (Vector2.new(ap.X, ap.Y) - Y).Magnitude
							if ((not ae) or ar <= af) and (not _ or ar < _) then
								local as = true
								if ag then
									local at = workspace:Raycast(X, an - X, N)
									if at and not at.Instance:IsDescendantOf(ak) then
										as = false
									end
								end
								if as then
									Z, _ = al, ar
								end
							end
						end
					end
				end
			end
		end
	end
	L = Z
	return Z
end

h.getTarget = function()
	LPH_ATTRIBUTES(VM(NONE))
	if K(L) then
		return L
	end
	M = 0
	return R()
end

local function aa()
	LPH_ATTRIBUTES(VM(NONE))
	local ab = os.clock()
	if ab == Q then
		return P
	end
	Q = ab
	local ac = v.getEquipped()
	if typeof(ac) == "Instance" and ac:IsA("Tool") and ac:GetAttribute("ToolType") == "Weapon" then
		P = ac
		return ac
	end
	local ad = l.Character
	local ae = ad and ad:FindFirstChildOfClass("Tool")
	if ae and ae:GetAttribute("ToolType") == "Weapon" then
		P = ae
		return ae
	end
	P = nil
	return nil
end

h.getMuzzle = function()
	LPH_ATTRIBUTES(VM(NONE))
	local ab = aa()
	if not ab then
		return nil
	end
	local ac = l.Character
	local ad = ac and ac:FindFirstChild(ab.Name .. "Model")
	local ae = (ad and ad:FindFirstChild("Handle")) or ab:FindFirstChild("Handle")
	return ae and ae:FindFirstChild("Muzzle1")
end

local function ab()
	LPH_ATTRIBUTES(VM(NONE))
	if not (e.silentenabled or e.turretsilentenabled or e.aimbotenabled or e.snaplines) then
		h.target = nil
		return
	end
	h.target = R()
end

local function ac()
	LPH_ATTRIBUTES(VM(NONE))
	if not e.aimbotenabled then
		return
	end
	local ad = false
	if Options and Options.aimbotkey then
		ad = Options.aimbotkey:GetState()
	end
	if not ad then
		return
	end

	local ae = h.getTarget()
	if not (ae and ae.Parent) then
		return
	end

	local af = workspace.CurrentCamera
	if not af then
		return
	end

	local ag = ae.Position
	local ah = math.max(1, g("aimbotsmoothness", 1))

	if g("aimbotmethod", "Camera") == "Mouse" and mousemoverel then
		local ai, aj = af:WorldToViewportPoint(ag)
		if aj and ai.Z > 0 then
			local ak = k:GetMouseLocation()
			local al = (ai.X - ak.X) / ah
			local am = (ai.Y - ak.Y) / ah
			mousemoverel(al, am)
		end
	else

		local ai = af.CFrame
		local aj = CFrame.new(ai.Position, ag)
		if ah == 1 then
			af.CFrame = aj
		else
			af.CFrame = ai:Lerp(aj, 1 / ah)
		end
	end
end

local ad = (function()
local ad = require(A.Weapon.Muzzle.Discharge)
local ae = require(B.WeaponViewmodel)
local af = require(m.Shared.Ballistics.ProjectileCaster)
local ag = require(m.Shared.WeaponConfigManager)
local ah = require(z.Character.stance.MovementTuning)
local ai = require(z.BodyReplication)
local aj = require(z.BodyReplication.BodyRotation)
local ak = require(m.Shared.Vehicle.TurretFireController)
local al = require(z.Tools.Bandage)
local am
pcall(function()
	am = require(l.PlayerScripts.BallisticsClient.FlybySuppression)
end)

local an = debug.getupvalues
local ao = debug.getconstants
local ap = debug.getinfo
local aq = debug.getprotos or getprotos

local function ar(as)
	return type(as) == "function" and (not islclosure or islclosure(as))
end

local function as(at)
	local S, T = pcall(an, at)
	return S and T or {}
end

local function at(S, T)
	local U, V = pcall(ao, S)
	if not U then
		return false
	end
	for W, X in V do
		if X == T then
			return true
		end
	end
	return false
end

local function S(T, U)
	for V, W in as(T) do
		if ar(W) and U(W, V) then
			return W, V
		end
	end
end

local function T(U, V)
	if type(U) ~= "table" then
		return nil
	end
	if V == nil then
		return nil
	end
	for W, X in U do
		if ar(X) and V(X, W) then
			return X, W
		end
	end
end

local function U(V, W, X)
	if type(V) == "table" and ar(V[W]) then
		return V[W], W
	end
	return T(V, X)
end

local function V(W, X, Y, Z)
	if not ar(W) or Y < 0 then
		return nil
	end
	Z = Z or {}
	if Z[W] then
		return nil
	end
	Z[W] = true
	if X(W) then
		return W
	end
	for _, au in as(W) do
		if ar(au) then
			local av = V(au, X, Y - 1, Z)
			if av then
				return av
			end
		elseif type(au) == "table" then
			for av, aw in au do
				if ar(aw) then
					local ax = V(aw, X, Y - 1, Z)
					if ax then
						return ax
					end
				end
			end
		end
	end
	if aq then
		local au, av = pcall(aq, W)
		if au then
			for aw, ax in av do
				if ar(ax) then
					local _ = V(ax, X, Y - 1, Z)
					if _ then
						return _
					end
				end
			end
		end
	end
	return nil
end

local au = {}

local av = U(r, "recoilScale", function(av)
	local aw = as(av)
	local ax, W, X = false, false, false
	for Y, Z in aw do
		if type(Z) == "table" then
			if type(Z.getAlpha) == "function" then
				ax = true
			end
			if type(Z.getCharacterValues) == "function" then
				W = true
			end
			if Z.Crouch ~= nil and Z.Prone ~= nil then
				X = true
			end
		end
	end
	return ax and W and X
end)
au.getRecoilMult = { func = av, upv = av and as(av) or {} }

local aw = U(ad, "fire", function(aw)
	return at(aw, "IsPreparation") and at(aw, "config")
end)
au.fire = { func = aw, upv = aw and as(aw) or {} }
au.spreadVector = {
	func = aw and S(aw, function(ax)
		local W = ap(ax)
		return W.nups == 0 and W.numparams == 2
	end),
}

local ax
if am and ar(am.new) then
	for W, X in as(am.new) do
		if type(X) == "table" and ar(X.fire) then
			ax = X.fire
			break
		end
	end
end
au.flybyFire = { func = ax }

local W = U(s, "flip", function(W)
	return ap(W).numparams == 0 and ap(W).nups >= 1
end)
local X = U(s, "canAim", function(X)
	return at(X, "Stance") and at(X, "Walk")
end)
au.aimtoggle = { func = W, upv = W and as(W) or {} }
au.isaimingavailable = { func = X, upv = X and as(X) or {} }
au.aimupdate = {
	func = S(s.attach, function(Y)
		local Z = as(Y)
		return typeof(Z[1]) == "Instance" and type(Z[2]) == "number" and type(Z[3]) == "number"
	end),
}
au.aimupdate.upv = au.aimupdate.func and as(au.aimupdate.func) or {}

local Y = U(t, "pull", function(Y)
	return at(Y, "isFiring") or ap(Y).numparams == 1
end)
local Z
if ar(t.new) then
	for _, ay in as(t.new) do
		if type(ay) == "table" and ay.Automatic then
			Z = ay
			break
		end
	end
end
au.firemodestart = { func = Y, upv = Z }

local ay
if ar(v.equip) then
	ay = S(v.equip, function(_)
		return at(_, "EquipTool")
	end)
end
au.awaitLength = {
	func = ay and S(ay, function(_)
		return at(_, "Length") and at(_, "isConscious")
	end),
}

au.movementupdate = {
	func = U(ah, "apply", function(_)
		return at(_, "inertialSpeed") and at(_, "sprintHeld")
	end),
}

local _ = S(al.new, function(_)
	return at(_, "HealLimb")
end)
au.healLimb = { func = _, upv = _ and as(_) or {} }

au.muzzlesConfig = {
	func = U(ag, "MuzzleConfigsOf", function(az)
		return ap(az).numparams == 2
	end),
}

local az = S(af.Fire, function(az)
	return at(az, "Alive") and at(az, "OnFinish")
end)
au.onArcEnd = {
	func = az and S(az, function(aA)
		return at(aA, "Segments")
	end),
}

local aA = S(ak.Attach, function(aA)
	return at(aA, "muzzleConfig") and at(aA, "WorldCFrame")
end)
au.fireOnce = { func = aA, upv = aA and as(aA) or {} }

au.sendOwnInfo = {
	func = S(ai.flushNow, function(aB)
		return at(aB, "NewCameraAngle")
	end),
}

au.bodyRotationUpdate = {
	func = U(aj, "UpdateCharacter", function(aB)
		return at(aB, "HumanoidRootPart") and at(aB, "LastUpdate")
	end),
}
au.bodyWallPush = {
	func = au.bodyRotationUpdate.func and S(au.bodyRotationUpdate.func, function(aB)
		return ap(aB).numparams >= 4
	end),
}

au.viewmodelWallPush = {
	func = V(ae.attach, function(aB)
		return at(aB, "viewmodelAttachment") and at(aB, "raise")
	end, 4),
}

local function aB(aC)
	if not ar(aC) then
		return false
	end
	local aD = ap(aC)
	if not aD or (aD.numparams or 0) < 5 then
		return false
	end
	if at(aC, "proj") and at(aC, "seed") and not at(aC, "GetServerTimeNow") then
		return false
	end
	local aE = 0
	if at(aC, "GetServerTimeNow") then
		aE += 1
	end
	if at(aC, "encodeFire") then
		aE += 1
	end
	if at(aC, "Direction") and at(aC, "Seed") then
		aE += 1
	end
	if at(aC, "Unit") then
		aE += 1
	end
	return aE >= 2
end

local function aC(aD)
	if type(aD) ~= "table" then
		return nil
	end
	if aB(aD.fireVolley) then
		return aD.fireVolley
	end
	local aE = aD.fire
	if ar(aE) then
		local aF, aG = pcall(ao, aE)
		if aF then
			for aH, aI in aG do
				if type(aI) == "string" then
					local aJ = aD[aI]
					if ar(aJ) and aJ ~= aE and aB(aJ) then
						return aJ
					end
				end
			end
		end
		for aH, aI in as(aE) do
			if aB(aI) then
				return aI
			end
		end
	end
	for aF, aG in aD do
		if aF ~= "fire" and aB(aG) then
			return aG
		end
	end
	return nil
end

local aD
for aE, aF in au.fire.upv do
	if aC(aF) then
		aD = aF
		break
	end
end
if not aD then
	pcall(function()
		local aE = l:FindFirstChild("PlayerScripts")
		local aF = aE and aE:FindFirstChild("BallisticsClient")
		local aG = aF and aF:FindFirstChild("ClientFire")
		if aG then
			aD = require(aG)
		end
	end)
end
au.volleyFrom = aC
au.fireVolleyFn = aC(aD)

return au
end)()

local function ae(af, ag, ah, ai)
	local aj = af.Transparency
	local ak = 1 - aj
	local al = ah / ai
	local am = ak / al

	task.wait(ag - ah)
	for an = 1, al do
		task.wait(ai)
		af.Transparency += am
	end
	af.Transparency = 1
	af:Destroy()
end

local function af(ag, ah, ai, aj, ak)
	local al = (ah - ag).Magnitude
	if al <= 0.001 then
		return
	end
	local am = (ag + ah) / 2

	local an = g("localtracersmaterial", "Plastic")
	if aj then
		an = g("teamtracersmaterial", "Plastic")
	elseif ak then
		an = g("enemytracersmaterial", "Plastic")
	end

	local ao = g("localtracerscolor", Color3.fromRGB(59, 255, 50))
	if aj then
		ao = g("teamtracerscolor", Color3.fromRGB(59, 144, 204))
	elseif ak then
		ao = g("enemytracerscolor", Color3.fromRGB(255, 60, 60))
	end

	local ap = g("localtracerstransparency", 0.5)
	if aj then
		ap = g("teamtracerstransparency", 0.5)
	elseif ak then
		ap = g("enemytracerstransparency", 0.5)
	end

	local aq = g("bullettracersize", 0.1)

	local ar = Instance.new("Part")
	ar.Name = "tracer"
	ar.Anchored = true
	ar.CanCollide = false
	ar.CanQuery = false
	ar.CanTouch = false
	ar.Material = Enum.Material[an]
	ar.Color = ao
	ar.Size = Vector3.new(aq, aq, al)
	ar.CFrame = CFrame.new(am, ah)
	ar.Parent = workspace:FindFirstChild("Ignore") or workspace
	ar.Transparency = ap

	task.spawn(ae, ar, 3, 1, 0.05)

	return ar
end

local ag = setmetatable({}, { __mode = "k" })
local ah = { origin = nil, at = 0 }
local ai
local aj
local ak

local function al(am, an)
	if an and am and (an - am).Magnitude > 0.05 then
		ah.origin = an
		ah.at = os.clock()
	end
end
if ad.onArcEnd.func then
	local am = C(ad.onArcEnd.func)
	ad.onArcEnd.func = hookfunction(ad.onArcEnd.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		local an = { ... }
		local ao = an[1]
		local ap = table.pack(am(...))
		if not ao or ao.Alive or ag[ao] then
			return table.unpack(ap, 1, ap.n)
		end

		ag[ao] = true
		local aq = ao.Owner
		local ar = aq == l
		local as = aq ~= nil and not ar and aq.Team ~= nil and aq.Team == l.Team
		local at = aq ~= nil and not ar and not as
		local au = f("tracersenabled", false)
			and (
				(ar and f("localtracers", false))
				or (at and f("enemytracers", false))
				or (as and f("teamtracers", false))
			)
		if au then
			local av = ar and ah.origin and os.clock() - ah.at < 0.25 and ah.origin
			local aw = ao.Segments or {}
			for ax, ay in ipairs(aw) do
				if typeof(ay.From) == "Vector3" and typeof(ay.To) == "Vector3" then
					local az = ay.From
					if ax == 1 and av and (az - av).Magnitude > 0.15 then
						az = av
					end
					task.spawn(af, az, ay.To, ar, as, at)
				end
			end
		end
		return table.unpack(ap, 1, ap.n)
	end)
end

if ad.flybyFire.func then
	local am = C(ad.flybyFire.func)
	hookfunction(ad.flybyFire.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		if e.antisuppression then
			return
		end
		return am(...)
	end)
end

local am = w.Shake
local an = C(am)
w.Shake = function(...)
	LPH_ATTRIBUTES(VM(NONE))
	if e.antisuppression then
		return
	end
	return an(...)
end

if ad.spreadVector.func then
	hookfunction(ad.spreadVector.func, function(ao, ap)
		LPH_ATTRIBUTES(VM(NONE))
		local aq = g("spreadmult", 0)
		if aq == 0 then return ao.Unit end
		local ar = math.atan((ap or 1) / 3570) * aq
		local as = Vector3.new(math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1)
		return (ao.Unit + as * ar).Unit
	end)
end

local function ao()
	LPH_ATTRIBUTES(VM(NONE))
	local ap, aq, ar = unpack(ad.getRecoilMult.upv)
	local as = aq:getCharacterValues()
	if as then
		as = as:FindFirstChild("Stance")
	end
	return (ap[as and as.Value or "Walk"] or 1) * (1 - (ar.getAlpha() or 0) * 0.25) * g("recoilmult", 0)
end

if ad.getRecoilMult.func then
	for ap, aq in r do
		if aq == ad.getRecoilMult.func then
			r[ap] = ao
			break
		end
	end
	pcall(hookfunction, ad.getRecoilMult.func, ao)
end

if ad.sendOwnInfo.func then
	local ap = C(ad.sendOwnInfo.func)
	hookfunction(ad.sendOwnInfo.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		if e.antiaimpitch then
			local aq = debug.getupvalue(ap, 1)
			if aq then
				aq.NewCameraAngle = math.rad(g("antiaimpitchangle", 90))
			end
		end
		return ap(...)
	end)
end

if ad.bodyWallPush.func then
	local ap = C(ad.bodyWallPush.func)
	hookfunction(ad.bodyWallPush.func, function(aq, ...)
		LPH_ATTRIBUTES(VM(NONE))
		if e.gunup and aq and aq.IsOwnCharacter then
			aq.WallPush = aq.WallPush or { push = 0, raise = 0 }
			aq.WallPush.push = 0
			aq.WallPush.raise = math.rad(89)
			return 0, math.rad(89)
		end
		return ap(aq, ...)
	end)
end

if ad.viewmodelWallPush.func then
	local ap = C(ad.viewmodelWallPush.func)
	hookfunction(ad.viewmodelWallPush.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		if e.gunup then
			debug.setupvalue(ap, 2, 0)
			debug.setupvalue(ap, 3, math.rad(89))
			return
		end
		return ap(...)
	end)
end

if ad.bodyRotationUpdate.func then
	local ap = C(ad.bodyRotationUpdate.func)
	hookfunction(ad.bodyRotationUpdate.func, function(aq, ar)
		LPH_ATTRIBUTES(VM(NONE))
		if not e.antiaimpitch and not e.gunup then
			return ap(aq, ar)
		end
		if aq ~= l.Character or not ar then
			return ap(aq, ar)
		end

		if e.antiaimpitch then
			local as = math.rad(g("antiaimpitchangle", 90))
			ar.NewCameraAngle = as
			ar.CurrentCameraAngle = as
		end

		local as = ar.StanceValue
		local at
		if e.gunup and as then
			at = as.Value
			as.Value = "Walk"
		end
		local au = table.pack(ap(aq, ar))
		if at ~= nil and as.Parent then
			as.Value = at
		end
		return table.unpack(au, 1, au.n)
	end)
end

local function ap(aq)
	local ar = {}
	for as, at in aq or {} do
		local au = typeof(at)
		if au == "RaycastParams" then
			ar.raycastParams = at
		elseif au == "function" then
			ar.spreadVector = at
		elseif au == "Instance" then
			if at:IsA("Camera") then
				ar.camera = at
			elseif at:IsA("Player") then
				ar.player = at
			elseif at:IsA("ReplicatedStorage") then
				ar.replicatedStorage = at
			end
		elseif au == "table" then
			if type(at.IsPreparation) == "function" then
				ar.matchPhase = at
			elseif type(at.getCharacter) == "function" then
				ar.wielder = at
			elseif type(at.isShown) == "function" then
				ar.viewmodel = at
			elseif type(at.zeroAngle) == "function" then
				ar.zeroController = at
			elseif type(at.MuzzleFlash) == "function" then
				ar.weaponEffects = at
			elseif type(at.Play) == "function" then
				ar.soundManager = at
			elseif type(at.flushNow) == "function" then
				ar.bodyReplication = at
			elseif ad.volleyFrom(at) then
				ar.clientFire = at
			end
		end
	end
	return ar
end

if ad.fire.func then
	local aq = C(ad.fire.func)
	local ar = ap(ad.fire.upv)
	local as = ar.bodyReplication
	if type(as) ~= "table" then
		local at, au = pcall(require, z.BodyReplication)
		if at and type(au) == "table" then
			as = au
		end
	end
	hookfunction(ad.fire.func, function(at, au)
		LPH_ATTRIBUTES(VM(NONE))
		local av = ar.matchPhase
		local aw = ar.wielder
		local ax = ar.camera
		local ay = ar.raycastParams
		local az = ar.player
		local aA = ar.zeroController
		local aB = ar.spreadVector
		local aC = ar.soundManager
		local aD = ar.weaponEffects
		local aE = ar.clientFire
		local aF = ar.viewmodel
		if not (av and aw and ax and aA and aB and aC and aD) then
			return aq(at, au)
		end
		local aG = ad.volleyFrom(aE) or ad.fireVolleyFn

		if av.IsPreparation() then
			return
		end
		local aH = at.config
		local aI = aw:getCharacter()
		local aJ = aI and aI:FindFirstChild("Right Arm")
		local S = (ax.CFrame.Position - ax.Focus.Position).Magnitude <= 0.75
		local T = not aF or aF.isShown()
		local U = (S and T and at.viewmodelAttachment) or at.attachment
		local V = U.WorldPosition
		local W = U.WorldCFrame.LookVector
		if aJ and typeof(ay) == "RaycastParams" and typeof(az) == "Instance" then
			local X = (V - aJ.CFrame.Position).Magnitude
			ay.FilterDescendantsInstances = { az.Character, workspace.Ignore }
			local Y = workspace:Raycast(V - W * X, W * X, ay)
			if Y then
				V = Y.Position - W * math.min(0.01, Y.Distance)
			end
		end

		local X = aA.zeroAngle() or math.rad(aH.DefaultAngle or 0)
		local Y = (U.WorldCFrame * CFrame.Angles(X, 0, 0)).LookVector
		local Z = aH.BulletSettings[au]
		local _ = V
		local aK = aj
		if not aK and e.silentenabled then
			local aL = h.getTarget()
			if aL then
				aK = G(aH, Z)
						and H(V, aL, aH, Z)
					or aL.Position
				if e.manipulation and ai then
					local aM = {}
					if az and az.Character then
						aM[1] = az.Character
					end
					local aN = workspace:FindFirstChild("Ignore")
					if aN then
						aM[#aM + 1] = aN
					end
					local aO = ai(V, aK, aL.Parent, Z and Z.Penetration, aM)
					if aO then
						V = aO
					end
				end
			end
		elseif ak then
			V = ak
		end
		if aK then
			local aL = aK - V
			if aL.Magnitude > 0.001 then
				Y = aL.Unit
			end
		end
		al(_, V)

		at.animator:play("GunShoot")
		J = J + 1
		local aL = Z.ShotAmount or 1
		local aM = table.create(aL)
		for aN = 1, aL do
			aM[aN] = aB(Y, Z.Spread or 1)
		end

		local aN = at.tool.Sounds:FindFirstChild("Muzzle" .. at.index)
		aN = aN and aN:FindFirstChild("Fire")
		if aN then
			aC.Play(aN, U.WorldPosition, aH.SoundRange or 3000)
		end
		aD.MuzzleFlash(U, at.tool.Name)
		E = F(Z)
		if as and type(as.flushNow) == "function" then
			as.flushNow()
		end
		if aG then
			aG(at.tool, at.index, au, V, aM)
		end
		E = false
		if not at:isHandAction() then
			aD.Casing(U, at.tool.Name)
		end
	end)
end

if ad.fireOnce.func then
	local aq = C(ad.fireOnce.func)
	hookfunction(ad.fireOnce.func, function()
		LPH_ATTRIBUTES(VM(NONE))
		local ar, as, at, au, av, aw =
			unpack(debug.getupvalues(aq))
		if not (ar and ar.muzzle and ar.muzzle.Parent) then
			return
		end
		local ax = ad.volleyFrom(av) or ad.fireVolleyFn

		local ay = ar.muzzleConfig
		local az = ar.muzzle
		local aA = az.WorldCFrame
		local aB = aA.Position
		local aC = (aA * CFrame.Angles(math.rad(ay.DefaultAngle or 0), 0, 0)).LookVector
		local aD = ay.BulletSettings and ay.BulletSettings[1] or {}
		if e.turretsilentenabled then
			local aE = h.getTarget()
			if aE then
				local aF = G(ay, aD)
						and H(aB, aE, ay, aD)
					or aE.Position
				local aG = aF - aB
				if aG.Magnitude > 0.001 then
					aC = aG.Unit
				end
			end
		end

		local aE = aD.ShotAmount or 1
		local aF = table.create(aE)
		for aG = 1, aE do
			aF[aG] = as(aC, aD.Spread or 1)
		end
		if ar.loopSound then
			at.Play(ar.loopSound, aB, ay.SoundRange or 3000)
			if ar.burstTracker then
				ar.burstTracker.onShot(aB)
			end
		elseif ar.fireSound then
			at.Play(ar.fireSound, aB, ay.SoundRange or 3000)
		end
		au.MuzzleFlash(az, ar.weaponName)
		au.Casing(az, ar.weaponName)
		E = F(aD)
		if ax then
			ax(ar.weaponName, 1, 1, aB, aF)
		end
		E = false
		aw.ApplyRecoil()
	end)
end
if ad.aimtoggle.func then
local aq = C(ad.aimtoggle.func)
ad.aimtoggle.func = hookfunction(ad.aimtoggle.func, function(...)
	LPH_ATTRIBUTES(VM(NONE))
	local ar = aq
	if not e.aimanywhere then
		return ar(...)
	end
	local as = debug.getupvalue(ar, 1)
	debug.setupvalue(ar, 1, (as == 0) and 1 or 0)
end)
end

if ad.aimupdate.func then
local aq = C(ad.aimupdate.func)
ad.aimupdate.func = hookfunction(ad.aimupdate.func, function(ar)
	LPH_ATTRIBUTES(VM(NONE))
	local as = aq
	local at = e.instantads
	local au = e.aimanywhere
	local av = e.noadsslowdown
	if not (at or au or av) then
		return as(ar)
	end

	local aw = debug.getupvalue(as, 3) == 1
	if at then
		debug.setupvalue(as, 2, aw and 1 or 0)
	end

	as(ar)

	if au and aw then
		debug.setupvalue(as, 3, 1)
		if at then
			debug.setupvalue(as, 2, 1)
		end
	end

	if av then
		local ax = debug.getupvalue(as, 1)
		if typeof(ax) == "Instance" then
			ax.Value = 1
		end
	end
end)
end

if ad.isaimingavailable.func then
local aq = C(ad.isaimingavailable.func)
ad.isaimingavailable.func = hookfunction(ad.isaimingavailable.func, function(...)
	LPH_ATTRIBUTES(VM(NONE))
	if e.aimanywhere then
		return true
	end
	return aq(...)
end)
end

if ad.firemodestart.func then
local aq = C(ad.firemodestart.func)
ad.firemodestart.func = hookfunction(ad.firemodestart.func, function(ar)
	LPH_ATTRIBUTES(VM(NONE))
	local as = ad.firemodestart.upv

	if not ar.isFiring then
		ar.isFiring = true
		local at = ar:_current()
		if at then
			local au = at.strategy
			if e.forceauto then
				local av = as and as.Automatic
				if av and av.strategy then
					au = av.strategy
				end
			end
			if au then
				task.spawn(au.fire, ar)
			end
		end
	end
end)
end

if ad.awaitLength.func then
	local aq = C(ad.awaitLength.func)
	ad.awaitLength.func = hookfunction(ad.awaitLength.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		if e.instantequip then
			return false
		end
		return aq(...)
	end)
end

local function aq(ar)
	local function as(at)
		local au = ar:FindFirstChild(at)
		local av = au and au:FindFirstChild("Health")
		if av then
			local aw = av:GetAttribute("MaxHealth")
			if aw and aw > 0 then
				return av.Value / aw
			end
		end
		return nil
	end
	local at, au = as("Left Leg"), as("Right Leg")
	if at and au then
		return 0.5 + (at + au) / 4
	end
	return nil
end

if ad.movementupdate.func then
	local ar = C(ad.movementupdate.func)
	ad.movementupdate.func = hookfunction(ad.movementupdate.func, function(as)
		LPH_ATTRIBUTES(VM(NONE))
		if not e.omnisprint and not e.nohurtslowdown then
			return ar(as)
		end

		if e.omnisprint and as then
			as.firstPerson = false
		end

		ar(as)

		if e.nohurtslowdown and as and as.humanoid and as.character then
			local at = aq(as.character)
			if at and at > 0 and at < 1 then
				as.humanoid.WalkSpeed = as.humanoid.WalkSpeed / at
				if type(as.inertialSpeed) == "number" then
					as.inertialSpeed = as.inertialSpeed / at
				end
			end
		end
	end)
end

local ar = u.new
u.new = function(as)
	LPH_ATTRIBUTES(VM(NONE))
	if not E then
		if e.nodrop then
			as.Gravity = 0
		end
		if e.instantbullet then
			as.MuzzleSpeed = 1e6
			as.K = 0
		end
	end
	return ar(as)
end

local as = m:WaitForChild("Remotes")

local at = 0
local function au()
	LPH_ATTRIBUTES(VM(NONE))
	local function av(aw)
		if not aw then
			return nil
		end
		for ax, ay in aw:GetChildren() do
			if ay:IsA("Tool") and ay:GetAttribute("ToolType") == "Bandage" then
				local az = ay:FindFirstChild("Bandages")
				if not az then
					return ay
				end
				for aA, aB in az:GetChildren() do
					if aB:IsA("IntValue") and aB.Value > 0 then
						return ay
					end
				end
			end
		end
		return nil
	end
	return av(l.Character) or av(l:FindFirstChild("Backpack"))
end
local function av(aw)
	LPH_ATTRIBUTES(VM(NONE))
	if not e.autoheal then
		return
	end
	at = at + aw
	if not e.instantheal and at < 0.75 then
		return
	end
	at = 0

	local ax = as:FindFirstChild("Bandage")
	local ay = au()
	local az = l.Character
	if not (ax and ay and az) then
		return
	end
	local aA = g("autohealmindamage", 30)
	for aB, aC in az:GetChildren() do
		if aC:IsA("BasePart") and aC.Name ~= "HumanoidRootPart" then
			local aD = aC:FindFirstChild("Health")
			if aD then
				local aE = aD:GetAttribute("MaxHealth")
				if aE and aE > 0 and (aE - aD.Value) / aE * 100 >= aA then
					ax:FireServer(ay, "HealLimb", aC)
				end
			end
		end
	end
end

local aw = 0
local function ax(ay)
	LPH_ATTRIBUTES(VM(NONE))
	if not e.fastrevive then
		return
	end
	aw = aw + ay
	if aw < 1 then
		return
	end
	aw = 0

	local az = workspace:FindFirstChild("Characters")
	if not az then
		return
	end
	local aA = az:QueryDescendants("#RevivePrompt")
	for aB, aC in aA do
		if aC:IsA("ProximityPrompt") then
			aC.HoldDuration = 3
		end
	end
end

local ay = {
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
local az = { AutoShift = true, Ackermann = true }
local aA = {
	ChassisType = "Wheeled",
	DriveType = "AWD",
	Differential = "Locked",
}
local aB = {}
local aC = {}
local aD = {}
local aE = "{}"
local aF = {}
local aG = false
local aH = ""
local function aI(aJ)
	local aK = aJ.Name or aJ.DisplayName or aJ.VehicleName or aJ.Id or "Unknown Car"
	local aL = aJ.Team or aJ.Faction or aJ.Side or "PACT"
	aL = tostring(aL):upper():find("NATO") and "NATO" or "PACT"
	return tostring(aK) .. " (" .. aL .. ")"
end
local function aJ(aK)
	local aL
	local aM = aK.Parent
	while aM and aM ~= m do
		local aN = aM.Name:upper()
		if aN == "PACT" or aN == "NATO" then
			aL = aN
			break
		end
		aM = aM.Parent
	end
	if not aL then
		return nil
	end
	return aK.Name .. " (" .. aL .. ")"
end
local function aK(aL)
	local aM = {}
	if type(aL) == "table" then
		for aN, aO in pairs(aL) do
			if type(aO) ~= "table" then
				aM[aN] = aO
			end
		end
		if type(aL.Ratios) == "table" then
			aM.Ratios = {}
			for aN, aO in pairs(aL.Ratios) do
				aM.Ratios[aN] = aO
			end
		end
		if type(aL.Wheels) == "table" then
			aM.Wheels = {}
			for aN, aO in ipairs(aL.Wheels) do
				aM.Wheels[aN] = {}
				for S, T in pairs(aO) do
					aM.Wheels[aN][S] = T
				end
			end
		end
	end
	for aN, aO in pairs(ay) do
		aM[aN] = aL and aL[aN] ~= nil and aL[aN] or aO
	end
	for aN, aO in pairs(az) do
		aM[aN] = aL and aL[aN] ~= nil and aL[aN] or aO
	end
	for aN, aO in pairs(aA) do
		aM[aN] = aL and aL[aN] ~= nil and aL[aN] or aO
	end
	return aM
end
local function aL()
	aE = p:JSONEncode(aB)
	if Options.carsprofiles and Options.carsprofiles.Value ~= aE and not aG then
		aG = true
		Options.carsprofiles:SetValue(aE)
		aG = false
	end
end
local function aM(aN)
	if aG then
		return
	end
	if type(aN) ~= "string" or aN == "" then
		return
	end
	local aO, S = pcall(p.JSONDecode, p, aN)
	if aO and type(S) == "table" then
		for T, U in pairs(S) do
			if type(U) == "table" then
				aB[T] = aK(U)
			end
		end
	end
end
local function aN(aO, S)
	if not aO or type(S) ~= "table" or type(S.Transmission) ~= "table" then
		return
	end
	if aF[S] then
		return
	end
	aF[S] = true
	aD[aO] = S
	aC[#aC + 1] = aO
	if aB[aO] == nil then
		aB[aO] = aK(S.Transmission)
	end
end
local function aO()
	local S = m:FindFirstChild("Shared") and m.Shared:FindFirstChild("VehicleConfigManager")
	if S then
		for T, U in ipairs(S:GetDescendants()) do
			if U:IsA("ModuleScript") then
				local V = aJ(U)
				if V then
					local W, X = pcall(require, U)
					if W and type(X) == "table" and rawget(X, "Transmission") then
						for Y, Z in pairs(X.Transmission) do
							if type(Z) == "number" and ay[Y] == nil then
								ay[Y] = Z
							elseif type(Z) == "boolean" and az[Y] == nil then
								az[Y] = Z
							elseif type(Z) == "string" and aA[Y] == nil then
								aA[Y] = Z
							end
						end
						aN(V, X)
					end
				end
			end
		end
	end

	if not S then
		for T, U in pairs(getgc(true)) do
			if
				typeof(U) == "table"
				and rawget(U, "Transmission")
				and rawget(U, "Damage")
				and rawget(U, "ShopInfo")
			then
				local V = U.ShopInfo
				if type(V) == "table" then
					local W = aI(V)
					for X, Y in pairs(U.Transmission) do
						if type(Y) == "number" and ay[X] == nil then
							ay[X] = Y
						elseif type(Y) == "boolean" and az[X] == nil then
							az[X] = Y
						elseif type(Y) == "string" and aA[X] == nil then
							aA[X] = Y
						end
					end
					aN(W, U)
				end
			end
		end
	end
	table.sort(aC)
	local T = table.concat(aC, "\0")
	if Options.carprofile and T ~= aH then
		aH = T
		Options.carprofile:SetValues(aC)
	end
end
aO()
local S = { selected = aC[1] }
local function T()
	if not e.carmods then
		return
	end
	for U, V in pairs(aD) do
		local W = aB[U]
		if W then
			local X = V.Transmission
			for Y in pairs(ay) do
				if X[Y] ~= W[Y] then
					X[Y] = W[Y]
				end
			end
			for Y in pairs(az) do
				if X[Y] ~= W[Y] then
					X[Y] = W[Y]
				end
			end
			for Y in pairs(aA) do
				if X[Y] ~= W[Y] then
					X[Y] = W[Y]
				end
			end
			if W.Ratios then
				X.Ratios = X.Ratios or {}
				for Y, Z in pairs(W.Ratios) do
					if X.Ratios[Y] ~= Z then
						X.Ratios[Y] = Z
					end
				end
			end
			if W.Wheels then
				X.Wheels = X.Wheels or {}
				for Y, Z in ipairs(W.Wheels) do
					X.Wheels[Y] = X.Wheels[Y] or {}
					for _, aP in pairs(Z) do
						if X.Wheels[Y][_] ~= aP then
							X.Wheels[Y][_] = aP
						end
					end
				end
			end
		end
	end
end

local function aP()
	if not S.selected then
		return nil
	end
	aB[S.selected] = aB[S.selected] or aK()
	return aB[S.selected]
end
local function U(V, W)
	local X = aP()
	if not X then
		return
	end
	X[V] = W
	aL()
	T()
end
local V = 0
local function W(X)
	LPH_ATTRIBUTES(VM(NONE))
	if not e.carmods then
		return
	end
	V = V + X
	if V < 5 then
		return
	end
	V = 0
	aO()
	T()
end

local function X(Y)
	local Z = ap(Y)
	if Z.clientFire then
		return Z.clientFire
	end
	for _, aQ in pairs(Y or {}) do
		if ad.volleyFrom(aQ) then
			return aQ
		end
	end
end
local aQ = X(ad.fire.upv)
local Y = as:WaitForChild("Weapon")

D = ad.muzzlesConfig.func and debug.getupvalue(ad.muzzlesConfig.func, 1)
local Z = select(
	2,
	pcall(function()
		return require(m:WaitForChild("Shared"):WaitForChild("Ballistics"):WaitForChild("ProjectileMaterials"))
	end)
)
if type(Z) ~= "table" then
	Z = nil
end

local function _(aR, aS)
	LPH_ATTRIBUTES(VM(NONE))
	local aT = D and D[aR.Name]
	return aT and aT[aS]
end

local aR = RaycastParams.new()
aR.FilterType = Enum.RaycastFilterType.Include
local aS = RaycastParams.new()
aS.FilterType = Enum.RaycastFilterType.Exclude

local function aT(aU, aV, aW)
	LPH_ATTRIBUTES(VM(NONE))
	local aX = aR
	aX.FilterType = Enum.RaycastFilterType.Include
	aX.FilterDescendantsInstances = { aW }
	local aY = aU + aV * 60
	local aZ = workspace:Raycast(aY, -aV * 60, aX)
	return aZ and aZ.Position or nil
end

local function aU(aV, aW, aX, aY, aZ)
	LPH_ATTRIBUTES(VM(NONE))
	if not aY or aY <= 0 then
		return false
	end
	local a_ = aY
	local a0 = aV
	for a1 = 1, 8 do
		local a2 = aW - a0
		local a3 = a2.Magnitude
		if a3 < 0.1 then
			return true
		end
		local a4 = a2.Unit
		aS.FilterDescendantsInstances = aZ
		local a5 = workspace:Raycast(a0, a4 * a3, aS)
		if not a5 then
			return true
		end
		if a5.Instance:IsDescendantOf(aX) then
			return true
		end
		local a6 = aT(a5.Position, a4, a5.Instance)
		if not a6 then
			return false
		end
		local a7 = (a6 - a5.Position).Magnitude
		local a8 = Z and Z.getPenetration(a5.Material) or 1
		a_ = a_ - a7 * a8
		if a_ <= 0 then
			return false
		end
		a0 = a6 + a4 * 0.05
	end
	return false
end

local function aV(aW, aX, aY, aZ, a_)
	LPH_ATTRIBUTES(VM(NONE))
	local a0 = aX - aW
	aS.FilterDescendantsInstances = a_
	local a1 = workspace:Raycast(aW, a0, aS)
	if not a1 then
		return true
	end
	if a1.Instance:IsDescendantOf(aY) then
		return true
	end
	if not e.ragebotwallbang then
		return false
	end
	return aU(aW, aX, aY, aZ, a_)
end

ai = function(aW, aX, aY, aZ, a_)
	LPH_ATTRIBUTES(VM(NONE))
	if not e.manipulation or not aW or not aX then
		return aW
	end
	local a0 = q.solve(aW, aX, e.manipulationdistance or 1, e.manipulationdepth or "Low", function(a0, a1)
		if not aY then
			return true
		end
		return aV(a0, a1, aY, aZ, a_)
	end, a_, 1)
	if not a0 then
		return nil
	end
	return a0
end

local function aW(aX, aY)
	local aZ = buffer.create(3)
	buffer.writeu8(aZ, 0, 1)
	buffer.writeu8(aZ, 1, aX)
	buffer.writeu8(aZ, 2, aY)
	Y:FireServer(aZ)
end

local aX = { "Head", "Torso", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }
local function aY(aZ, a_, a0, a1)
	LPH_ATTRIBUTES(VM(NONE))
	for a2, a3 in aX do
		local a4 = aZ:FindFirstChild(a3)
		if a4 and a4:IsA("BasePart") then
			if aV(a_, a4.Position, aZ, a0, a1) then
				return a4, a_
			end
		end
	end
	return nil
end

local aZ = 0
local a_ = 0
local a0 = nil
local a1 = setmetatable({}, { __mode = "k" })
local a2 = require(z.BodyReplication)

local function a3(a4)
	LPH_ATTRIBUTES(VM(NONE))
	local a5 = a1[a4]
	if a5 and rawget(a5, "tool") == a4 and rawget(a5, "currentMuzzle") then
		return a5
	end
	if not getgc then
		return nil
	end
	for a6, a7 in getgc(true) do
		if type(a7) == "table" and rawget(a7, "tool") == a4 and rawget(a7, "currentMuzzle") then
			a1[a4] = a7
			return a7
		end
	end
	return nil
end

local function a4(a5)
	LPH_ATTRIBUTES(VM(NONE))
	local a6 = workspace.CurrentCamera
	if not (a6 and a5) then
		return nil
	end
	local a7 = (a6.CFrame.Position - a6.Focus.Position).Magnitude <= 0.75
	local a8 = a7 and a5.viewmodelAttachment or a5.attachment
	if not a8 then
		return nil
	end
	local a9 = a8.WorldPosition
	local ba = a8.WorldCFrame.LookVector
	local bb = l.Character
	local bc = bb and bb:FindFirstChild("Right Arm")
	if bc then
		local bd = (a9 - bc.CFrame.Position).Magnitude
		aS.FilterType = Enum.RaycastFilterType.Exclude
		aS.FilterDescendantsInstances = { bb, workspace:FindFirstChild("Ignore") }
		local be = workspace:Raycast(a9 - ba * bd, ba * bd, aS)
		if be then
			a9 = be.Position - ba * math.min(0.01, be.Distance)
		end
	end
	return a9
end

local function a5()
	LPH_ATTRIBUTES(VM(NONE))
	local a6 = l.Character
	local a7 = ad.volleyFrom(aQ) or ad.fireVolleyFn
	if not (a6 and a7) then
		return
	end
	local a8 = aa()
	if not a8 then
		return
	end
	local a9 = a3(a8)
	local ba = a9 and a9.currentMuzzle
	if not (ba and ba.tool) then
		return
	end
	local bb = a4(ba)
	if not bb then
		return
	end
	local bc = ba.magazine and ba.magazine:getBulletIndex()
	if not bc then
		return
	end

	local bd = ba.index
	local be = _(a8, bd)
	local bf = (be and be.Firerate) or 600
	local bg = (be and be.Ammo) or 30
	local bh = (be and be.ReloadTime) or 3
	local bi = be and be.BulletSettings and be.BulletSettings[bc]
	local bj = (bi and bi.Penetration) or 0

	if a8 ~= a0 then
		a0 = a8
		J = 0
		a_ = 0
	end

	if os.clock() < a_ then
		return
	end

	if bg > 0 and J >= bg then
		if e.ragebotautoreload then
			aW(bd, bc)
			a_ = os.clock() + bh
			J = 0
		end
		return
	end

	if os.clock() < aZ then
		return
	end

	local bk = { a6 }
	local bl = workspace:FindFirstChild("Ignore")
	if bl then
		bk[#bk + 1] = bl
	end

	local bm = l
	local bn = {}
	for bo, bp in ipairs(i:GetPlayers()) do
		if bp ~= bm and bp.Character and not I(bp.Character) then
			if not (bm.Team and bp.Team == bm.Team) then
				local bq = bp.Character:FindFirstChildOfClass("Humanoid")
				local br = bp.Character:FindFirstChild("HumanoidRootPart") or bp.Character:FindFirstChild("Head")
				if bq and bq.Health > 0 and br then
					local bs = (br.Position - bb).Magnitude
					bn[#bn + 1] = { Character = bp.Character, Distance = bs }
				end
			end
		end
	end

	table.sort(bn, function(bo, bp)
		return bo.Distance < bp.Distance
	end)
	local bo
	for bp, bq in ipairs(bn) do
		bo = aY(bq.Character, bb, bj, bk)
		if bo then
			break
		end
	end
	local bp = bb
	local bq = bo
	if e.manipulation and ai then
		bq = nil
		bp = nil
		local br = {}
		if bo then
			br[1] = bo.Parent
		end
		for bs, bt in bn do
			if bt.Character ~= (bo and bo.Parent) then
				br[#br + 1] = bt.Character
			end
		end
		for bs, bt in br do
			local bu = bt:FindFirstChild("Head") or bt:FindFirstChild("HumanoidRootPart")
			if bu then
				local bv = ai(bb, bu.Position, bt, bj, bk)
				if bv then
					local bw = aY(bt, bv, bj, bk)
					if bw then
						bq = bw
						bp = bv
						break
					end
				end
			end
		end
	end

	if bq and bp and ad.fire.func then
		aZ = os.clock() + 60 / bf
		local br = bq.Position
		if G(be, bi) then
			br = H(bp, bq, be, bi)
		end
		ak = bp
		aj = br
		local bs = pcall(ad.fire.func, ba, bc)
		ak = nil
		aj = nil
		if not bs then
			aZ = 0
		end
	end
end

local a6 = 0
local function a7()
	LPH_ATTRIBUTES(VM(NONE))
	if not e.ragebottpaura then
		return
	end
	if os.clock() - a6 < 2.0 then
		return
	end

	local a8 = l
	local a9 = a8.Character
	if not a9 then
		return
	end
	local ba = a9:FindFirstChild("HumanoidRootPart")
	local bb = a9:FindFirstChild("Head") or ba
	if not (ba and bb) then
		return
	end
	local bc = bb.Position

	local bd = { a9 }
	local be = workspace:FindFirstChild("Ignore")
	if be then
		bd[#bd + 1] = be
	end

	local bf = false
	local bg, bh

	for bi, bj in ipairs(i:GetPlayers()) do
		if bj ~= a8 and bj.Character and not I(bj.Character) then
			if not (a8.Team and bj.Team == a8.Team) then
				local bk = bj.Character:FindFirstChildOfClass("Humanoid")
				local bl = bj.Character:FindFirstChild("HumanoidRootPart")
				local bm = bj.Character:FindFirstChild("Head") or bl
				if bk and bk.Health > 0 and bl then
					local bn = bm.Position - bc
					local bo = RaycastParams.new()
					bo.FilterType = Enum.RaycastFilterType.Exclude
					bo.FilterDescendantsInstances = bd
					local bp = workspace:Raycast(bc, bn, bo)

					if not bp or bp.Instance:IsDescendantOf(bj.Character) then
						bf = true
						break
					end

					local bq = (bl.Position - bc).Magnitude
					if not bh or bq < bh then
						bg = bj.Character
						bh = bq
					end
				end
			end
		end
	end

	if not bf and bg then
		local bi = bg:FindFirstChild("HumanoidRootPart")
		if bi and ba then
			a6 = os.clock()
			ba.CFrame = bi.CFrame * CFrame.new(0, 0, 3)
		end
	end
end

local a8 = 0
local function a9(ba)
	LPH_ATTRIBUTES(VM(NONE))
	if not (e.ragebot or e.ragebottpaura) then
		return
	end
	a8 = a8 + ba
	if a8 < 0.03 then
		return
	end
	a8 = 0
	if e.ragebot then
		pcall(a5)
	end
	if e.ragebottpaura then
		pcall(a7)
	end
end

local ba
local bb, bc = pcall(function()
	LPH_ATTRIBUTES(VM(NONE))
	return loadstring(
		game:HttpGet("https://raw.githubusercontent.com/ttokennxyz/vaultcc/refs/heads/main/esplibcoldwar.lua")
	)()
end)

if bb and type(bc) == "table" then

	pcall(function()
		bc:Load({ Enabled = false, Players = false, LocalPlayer = false, LimitFPS = 45, DynamicBoxes = false })
		ba = bc:GetConfig()
	end)
else
	print(bc)
	bc = nil
	n:Notify("Failed to load ESP library.")
end
	d.ESP = bc

local function bd()
	local be = ba
	if not be then
		return
	end

	be.Enabled = Toggles.ESPMaster.Value
	be.LocalPlayer = false
	be.MaxDistance = Options.ESPMaxDistance.Value
	be.LimitFPS = 45
	be.DynamicBoxes = false
	be.DynamicBoxesCheap = true
	be.DynamicBoxesIncludeAll = false

	be.Boxes = Toggles.ESPBoxes.Value
	be.BoxType = Options.ESPBoxType.Value
	be.BoxColor = Options.ESPBoxColor.Value
	be.BoxThickness = Options.ESPBoxThickness.Value
	be.Outlines.Style = Toggles.ESPBoxOutline.Value and "Full" or "None"
	be.Outlines.Color = Options.ESPBoxOutlineColor.Value

	be.BoxFill.Enabled = Toggles.ESPBoxFill.Value
	be.BoxFill.Color = Options.ESPBoxFillColor.Value
	be.BoxFill.Transparency = Options.ESPBoxFillTransparency.Value

	be.Names = Toggles.ESPNames.Value
	be.TextColor = Options.ESPNameColor.Value
	be.TextSize = Options.ESPTextSize.Value
	be.TextOutline = Toggles.ESPTextOutline.Value
	be.Distance.Enabled = Toggles.ESPDistance.Value
	be.Distance.Color = Options.ESPDistanceColor.Value
	be.Weapon.Enabled = Toggles.ESPWeapon.Value
	be.Weapon.UseToolFallback = true
	be.TeamIndicator.Enabled = Toggles.ESPTeam.Value
	be.FriendlyIndicator.Enabled = Toggles.ESPFriendly.Value
	be.FriendlyIndicator.CheckTeam = Toggles.ESPFriendly.Value
	be.FriendlyIndicator.CheckFriends = Toggles.ESPFriendly.Value

	be.HealthBar.Enabled = Toggles.ESPHealth.Value
	be.HealthBar.ShowText = true
	be.HealthBar.Source = (Options.ESPHealthMode.Value == "Target part") and "Part" or "Average"
	be.HealthBar.Part = g("silenttarget", "Head")

	be.Chams.Enabled = Toggles.ESPChams.Value
	be.Chams.Type = Options.ESPChamsType.Value

	local bf = Options.ESPChamsFill.Value
	local bg = Options.ESPChamsFillT.Value
	local bh = Options.ESPChamsOutline.Value
	local bi = Options.ESPChamsOutlineT.Value
	local bj = Toggles.ESPChamsVisible.Value

	be.Chams.Highlight.FillColor = bf
	be.Chams.Highlight.FillTransparency = bg
	be.Chams.Highlight.OutlineColor = bh
	be.Chams.Highlight.OutlineTransparency = bi
	be.Chams.Highlight.VisibleCheck = bj

	be.Chams.MeshChams.FillColor = bf
	be.Chams.MeshChams.FillTransparency = bg
	be.Chams.MeshChams.OutlineColor = bh
	be.Chams.MeshChams.OutlineTransparency = bi
	be.Chams.MeshChams.VisibleCheck = bj

	be.Chams.Adornment.Color = bf
	be.Chams.Adornment.Transparency = bg
	be.Chams.Adornment.VisibleCheck = bj

	be.Flags.Enabled = Toggles.ESPFlags.Value
	be.Flags.Options.Idle = Toggles.ESPFlagIdle.Value
	be.Flags.Options.Moving = Toggles.ESPFlagMoving.Value
	be.Flags.Options.Jumping = Toggles.ESPFlagJumping.Value
	be.Flags.Options.Swimming = Toggles.ESPFlagSwimming.Value
	be.OffScreenArrows.Enabled = Toggles.ESPArrows.Value
	be.OffScreenArrows.Color = Options.ESPArrowColor.Value
	be.OffScreenArrows.Size = Options.ESPArrowSize.Value
end

local function be()
	local bf = ba
	if not bf then
		return
	end

	local bg = l

	if Toggles.ESPFilterTeam.Value then
		bf.Players = false
		local bh = {}
		for bi, bj in ipairs(i:GetPlayers()) do
			if bj ~= bg and bj.Character then

				if not (bg.Team and bj.Team == bg.Team) then
					bh[#bh + 1] = { DisplayName = bj.Name, Path = bj.Character:GetFullName() }
				end
			end
		end
		bf.Directories = bh
	else

		bf.Players = true
		bf.Directories = {}
	end
end

local bf = o.Combat:AddRightGroupbox("Gun Mods")
bf:AddSlider("recoilmult", { Text = "Recoil Multiplier", Default = 0, Min = 0, Max = 1, Rounding = 2 })
bf:AddSlider("spreadmult", { Text = "Spread Multiplier", Default = 0, Min = 0, Max = 1, Rounding = 2 })
bf:AddToggle("forceauto", { Text = "Force Auto", Default = true })
bf:AddToggle("instantequip", { Text = "Instant Equip", Default = false })
bf:AddToggle("nodrop", { Text = "No Bullet Drop", Default = false })
bf:AddToggle("instantbullet", { Text = "Instant Bullet", Default = false })
bf:AddToggle(
	"rpgprediction",
	{
		Text = "RPG Prediction",
		Default = true,
	}
)
bf:AddSlider(
	"rpgpredictionstrength",
	{ Text = "RPG Prediction Strength", Default = 1, Min = 0, Max = 2, Rounding = 2 }
)

local bg = o.Combat:AddLeftGroupbox("Aiming")
bg
	:AddToggle("aimbotenabled", { Text = "Aimbot Enabled", Default = false })
	:AddKeyPicker("aimbotkey", { Default = "R", SyncToggleState = false, Mode = "Hold", Text = "Aimbot Key" })
bg:AddDropdown("aimbotmethod", { Text = "Aim Method", Values = { "Camera", "Mouse" }, Default = 1, Multi = false })
bg:AddDropdown(
	"aimbottarget",
	{
		Text = "Target part",
		Values = { "Head", "Torso", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg" },
		Default = 1,
		Multi = false,
	}
)
bg:AddSlider(
	"aimbotsmoothness",
	{
		Text = "Smoothness",
		Default = 1,
		Min = 1,
		Max = 20,
		Rounding = 1,
	}
)
bg:AddToggle("aimanywhere", { Text = "Aim Anywhere", Default = true })
bg:AddToggle("instantads", { Text = "Instant ADS", Default = true })
bg:AddToggle("noadsslowdown", { Text = "No ADS Slowdown", Default = true })

local bh = o.Combat:AddLeftGroupbox("Silent Aim")
bh
	:AddToggle(
		"silentenabled",
		{ Text = "Normal Silent Aim", Default = true }
	)
	:AddKeyPicker(
		"silentbind",
		{ Default = "None", SyncToggleState = true, Mode = "Toggle", Text = "Normal Silent Aim" }
	)
bh
	:AddToggle(
		"turretsilentenabled",
		{ Text = "Turret Silent Aim", Default = true }
	)
	:AddKeyPicker(
		"turretsilentbind",
		{ Default = "None", SyncToggleState = true, Mode = "Toggle", Text = "Turret Silent Aim" }
	)
bh:AddDropdown(
	"silenttarget",
	{
		Text = "Target part",
		Values = { "Head", "Torso", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg" },
		Default = 1,
		Multi = false,
	}
)
Options["silenttarget"]:OnChanged(function(bi)
	if ba then
		ba.HealthBar.Part = bi
	end
end)
bh:AddToggle(
	"silentvisiblecheck",
	{ Text = "Visible Check", Default = false }
)
bh:AddToggle(
	"silentdistancecheck",
	{ Text = "Distance Check", Default = false }
)
bh:AddSlider(
	"silentmaxdistance",
	{ Text = "Max Distance", Default = 500, Min = 10, Max = 2000, Rounding = 0, Suffix = " studs" }
)
bh:AddToggle("fovenabled", { Text = "FOV Circle", Default = false })
bh:AddSlider("fovsize", { Text = "FOV Circle Size", Default = 100, Min = 5, Max = 500, Rounding = 0 })
bh:AddToggle("silentteamcheck", { Text = "Exclude Teammates", Default = true })
bh:AddToggle("fovdraw", { Text = "Draw FOV Circle", Default = false })
bh
	:AddLabel("FOV color")
	:AddColorPicker("fovcolor", { Default = Color3.fromRGB(255, 255, 255), Title = "FOV color" })
bh:AddSlider("fovthickness", { Text = "FOV Thickness", Default = 1, Min = 1, Max = 10, Rounding = 0 })
bh:AddToggle("snaplines", { Text = "Snapline", Default = false })
bh
	:AddLabel("Snapline color")
	:AddColorPicker("snaptargetcolor", { Default = Color3.fromRGB(255, 0, 0), Title = "Snapline color" })

if la_is_premium then

    local bi = o.Combat:AddRightGroupbox("Ragebot")
    bi
    	:AddToggle("ragebot", { Text = "Enabled", Default = false })
    	:AddKeyPicker("ragebotbind", { Default = "None", SyncToggleState = true, Mode = "Toggle", Text = "Ragebot" })
    bi:AddToggle(
    	"ragebotwallbang",
    	{ Text = "Wallbang", Default = false }
    )
    bi:AddToggle(
    	"ragebotautoreload",
    	{ Text = "Auto Reload", Default = false }
    )
    bi:AddToggle(
    	"ragebottpaura",
    	{ Text = "TP Aura", Default = false }
    )
    bi:AddToggle("manipulation", { Text = "Manipulation", Default = false })
    bi:AddSlider("manipulationdistance", {
    	Text = "Manipulation Distance",
    	Default = 1,
    	Min = 0,
    	Max = 4,
    	Rounding = 2,
    	Suffix = " studs",
    })
    bi:AddDropdown("manipulationdepth", {
    	Text = "Scan Depth",
    	Values = { "Low", "Medium", "High" },
    	Default = 1,
    	Multi = false,
    })
end

local bi = Instance.new("ScreenGui")
bi.Name = "cwfov"
bi.IgnoreGuiInset = true
bi.ResetOnSpawn = false
bi.DisplayOrder = 100
bi.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local bj = Instance.new("Frame")
bj.AnchorPoint = Vector2.new(0.5, 0.5)
bj.BackgroundTransparency = 1
bj.BorderSizePixel = 0
bj.Visible = false
bj.Parent = bi

local bk = Instance.new("UICorner")
bk.CornerRadius = UDim.new(1, 0)
bk.Parent = bj

local bl = Instance.new("UIStroke")
bl.Thickness = 1
bl.Color = Color3.fromRGB(255, 255, 255)
bl.Parent = bj

local function bm()
	LPH_ATTRIBUTES(VM(NONE))
	if not e.fovdraw then
		bj.Visible = false
		return
	end

	local bn = k:GetMouseLocation()
	local bo = g("fovsize", 100)
	bj.Size = UDim2.fromOffset(bo * 2, bo * 2)
	bj.Position = UDim2.fromOffset(bn.X, bn.Y)
	bl.Thickness = g("fovthickness", 1)
	bl.Color = g("fovcolor", Color3.new(1, 1, 1))
	bj.Visible = true
end

local bn = Instance.new("ScreenGui")
bn.Name = "cwsnap"
bn.IgnoreGuiInset = true
bn.ResetOnSpawn = false
bn.DisplayOrder = 100
bn.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local bo = Instance.new("Frame")
bo.AnchorPoint = Vector2.new(0.5, 0.5)
bo.BorderSizePixel = 0
bo.Visible = false
bo.Parent = bn

local function bp()
	LPH_ATTRIBUTES(VM(NONE))
	local bq = h.target
	if e.snaplines and bq and bq.Parent then
		local br = workspace.CurrentCamera
		if br then
			local bs, bt = br:WorldToViewportPoint(bq.Position)
			if bt and bs.Z > 0 then
				local bu = k:GetMouseLocation()
				local bv = Vector2.new(bs.X, bs.Y)
				local bw = bv - bu
				bo.Size = UDim2.fromOffset(bw.Magnitude, 1)
				bo.Position = UDim2.fromOffset((bu.X + bv.X) / 2, (bu.Y + bv.Y) / 2)
				bo.Rotation = math.deg(math.atan2(bw.Y, bw.X))
				bo.BackgroundColor3 = g("snaptargetcolor", Color3.fromRGB(255, 0, 0))
				bo.Visible = true
				return
			end
		end
	end
	bo.Visible = false
end


	d.functions = ad
	d.espCfg = ba
	d.applyESP = bd
	d.refreshTeamFilter = be
	d.cars = {
		entries = aC,
		defaults = ay,
		boolDefaults = az,
		choiceDefaults = aA,
		state = S,
		apply = T,
		profile = aP,
		setControl = U,
		syncJson = aL,
		loadJson = aM,
	}

	d.combat = {
		targetStep = ab,
		aimbotRenderStep = ac,
		fovRenderStep = bm,
		snapRenderStep = bp,
		rageSchedulerStep = a9,
		autoHealStep = av,
		fastReviveStep = ax,
		carModsStep = W,
		applyESP = bd,
		refreshTeamFilter = be,
		unload = function()
			if bi then
				bi:Destroy()
				bi = nil
			end
			if bn then
				bn:Destroy()
				bn = nil
			end
		end,
	}
end

function c.step()
end

function c.unload()
end

return c
end function a.d()local aa=a.cache.d if not aa then aa={c=b()}a.cache.d=aa end return aa.c end end do local function aa()
local ab = {}

function ab.build(ac)
	local ad = ac.flags
	local ae = ac.tv
	local af = ac.ov
	local ag = ac.util
	local ah = ac.Players
	local ai = ac.RunService
	local aj = ac.UserInputService
	local ak = ac.LocalPlayer
	local al = ac.RS
	local am = ac.Library
	local an = ac.Tabs
	local ao = ac.HttpService
	local ap = ac.manipulation
	local aq = ac.RecoilController
	local ar = ac.AimController
	local as = ac.FiremodeController
	local at = ac.Trajectory
	local au = ac.InventoryController
	local av = ac.CameraShaker
	local aw = ac.paidToggleKeys
	local ax = ac.paidOptionKeys
local ay = an.ESP:AddLeftGroupbox("Main")
ay:AddToggle("ESPMaster", { Text = "Enabled", Default = false })
ay:AddToggle(
	"ESPFilterTeam",
	{ Text = "Filter teammates", Default = false }
)
ay:AddSlider(
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

local az = an.ESP:AddLeftGroupbox("Boxes")
az:AddToggle("ESPBoxes", { Text = "Boxes", Default = true })
az:AddDropdown("ESPBoxType", { Text = "Box type", Values = { "Normal", "Corner" }, Default = 1, Multi = false })
az
	:AddLabel("Box color")
	:AddColorPicker("ESPBoxColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Box color" })
az:AddSlider("ESPBoxThickness", { Text = "Box thickness", Default = 1, Min = 1, Max = 6, Rounding = 0 })
az:AddToggle("ESPBoxOutline", { Text = "Box outline", Default = true })
az
	:AddLabel("Outline color")
	:AddColorPicker("ESPBoxOutlineColor", { Default = Color3.fromRGB(0, 0, 0), Title = "Outline color" })
az:AddDivider()
az:AddToggle("ESPBoxFill", { Text = "Box fill", Default = false })
az
	:AddLabel("Fill color")
	:AddColorPicker("ESPBoxFillColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Fill color" })
az:AddSlider(
	"ESPBoxFillTransparency",
	{ Text = "Fill transparency", Default = 0.9, Min = 0, Max = 1, Rounding = 2 }
)

local aA = an.ESP:AddRightGroupbox("Chams")
aA:AddToggle("ESPChams", { Text = "Chams", Default = false })
aA:AddDropdown(
	"ESPChamsType",
	{
		Text = "Chams type",
		Values = { "Highlight", "Adornment", "MeshChams" },
		Default = 1,
		Multi = false,
	}
)
aA
	:AddLabel("Fill color")
	:AddColorPicker("ESPChamsFill", { Default = Color3.fromRGB(59, 144, 204), Title = "Cham fill" })
aA:AddSlider("ESPChamsFillT", { Text = "Fill transparency", Default = 0.6, Min = 0, Max = 1, Rounding = 2 })
aA
	:AddLabel("Outline color")
	:AddColorPicker("ESPChamsOutline", { Default = Color3.fromRGB(255, 255, 255), Title = "Cham outline" })
aA:AddSlider("ESPChamsOutlineT", { Text = "Outline transparency", Default = 0, Min = 0, Max = 1, Rounding = 2 })
aA:AddToggle(
	"ESPChamsVisible",
	{ Text = "Visible check", Default = false }
)

local aB = an.ESP:AddLeftGroupbox("Names & Info")
aB:AddToggle("ESPNames", { Text = "Names", Default = true })
aB
	:AddLabel("Name color")
	:AddColorPicker("ESPNameColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Name color" })
aB:AddSlider("ESPTextSize", { Text = "Text size", Default = 12, Min = 6, Max = 28, Rounding = 0 })
aB:AddToggle("ESPTextOutline", { Text = "Text outline", Default = true })
aB:AddDivider()
aB:AddToggle("ESPDistance", { Text = "Distance", Default = false })
aB
	:AddLabel("Distance color")
	:AddColorPicker("ESPDistanceColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Distance color" })
aB:AddToggle("ESPWeapon", { Text = "Weapon", Default = false })
aB:AddToggle("ESPTeam", { Text = "Team indicator", Default = false })
aB:AddToggle(
	"ESPFriendly",
	{ Text = "Friendly indicator", Default = false }
)

local aC = an.ESP:AddRightGroupbox("Health")
aC:AddToggle("ESPHealth", { Text = "Health", Default = false })
aC:AddDropdown(
	"ESPHealthMode",
	{
		Text = "Health mode",
		Values = { "Average", "Target part" },
		Default = 1,
		Multi = false,
	}
)

local aD = an.ESP:AddRightGroupbox("Flags & Arrows")
aD:AddToggle("ESPFlags", { Text = "Status flags", Default = false })
aD:AddToggle("ESPFlagIdle", { Text = "Flag: Idle", Default = false })
aD:AddToggle("ESPFlagMoving", { Text = "Flag: Moving", Default = false })
aD:AddToggle("ESPFlagJumping", { Text = "Flag: Jumping", Default = false })
aD:AddToggle("ESPFlagSwimming", { Text = "Flag: Swimming", Default = false })
aD:AddDivider()
aD:AddToggle("ESPArrows", { Text = "Off-screen arrows", Default = false })
aD
	:AddLabel("Arrow color")
	:AddColorPicker("ESPArrowColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Arrow color" })
aD:AddSlider("ESPArrowSize", { Text = "Arrow size", Default = 14, Min = 8, Max = 40, Rounding = 0 })

local aE = {
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
local aF = {
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

for aG, aH in ipairs(aE) do
	Toggles[aH]:OnChanged(ac.applyESP)
end
for aG, aH in ipairs(aF) do
	Options[aH]:OnChanged(ac.applyESP)
end

Toggles.ESPFilterTeam:OnChanged(ac.refreshTeamFilter)

ac.applyESP()
ac.refreshTeamFilter()

local aG = 0
local function aH(aI)
	LPH_ATTRIBUTES(VM(NONE))
	if not ac.ESP or not ac.espCfg or not ad.ESPMaster then
		return
	end
	aG = aG + aI
	if aG < 1 then
		return
	end
	aG = 0
	ac.refreshTeamFilter()
end

local aI = game:GetService("Lighting")
local aJ = {
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
local aK = {
	Atmosphere = { "Color", "Decay", "Density", "Offset", "Haze", "Glare" },
	BloomEffect = { "Enabled", "Intensity", "Size", "Threshold" },
	ColorCorrectionEffect = { "Enabled", "Brightness", "Contrast", "Saturation", "TintColor" },
	SunRaysEffect = { "Enabled", "Intensity", "Spread" },
	DepthOfFieldEffect = { "Enabled", "FarIntensity", "NearIntensity", "FocusDistance", "InFocusRadius" },
	BlurEffect = { "Enabled", "Size" },
}
local aL = { Lighting = {}, Effects = {} }
local aM = {}
for aN, aO in ipairs(aJ) do
	aL.Lighting[aO] = aI[aO]
end
for aN, aO in ipairs(aI:GetDescendants()) do
	local aP = aK[aO.ClassName]
	if aP then
		aM[#aM + 1] = aO
		local aQ = {}
		for aR, aS in ipairs(aP) do
			aQ[aS] = aO[aS]
		end
		aL.Effects[aO] = aQ
	end
end

local aN = aI:FindFirstChildOfClass("Atmosphere")
local aO = aI:FindFirstChildOfClass("BloomEffect")
local aP = aI:FindFirstChildOfClass("ColorCorrectionEffect")
local aQ = aI:FindFirstChildOfClass("SunRaysEffect")
local aR = aI:FindFirstChild("DepthOfField")
local aS = aI:FindFirstChildOfClass("BlurEffect")

local function aT()
	for aU, aV in pairs(aL.Lighting) do
		aI[aU] = aV
	end
	for aU, aV in pairs(aL.Effects) do
		if aU.Parent then
			for aW, aX in pairs(aV) do
				aU[aW] = aX
			end
		end
	end
end

local function aU(aV, aW, aX)
	if aV[aW] ~= aX then
		aV[aW] = aX
	end
end

local function aV()
	LPH_ATTRIBUTES(VM(NONE))
	if not ae("lightingoverride", false) then
		return
	end
	local aW = af("fogstart", aL.Lighting.FogStart)
	aU(aI, "GlobalShadows", ae("globalshadows", aL.Lighting.GlobalShadows))
	aU(aI, "Brightness", af("lightingbrightness", aL.Lighting.Brightness))
	aU(aI, "ClockTime", af("clocktime", aL.Lighting.ClockTime))
	aU(
		aI,
		"ExposureCompensation",
		af("exposure", aL.Lighting.ExposureCompensation)
	)
	aU(aI, "ShadowSoftness", af("shadowsoftness", aL.Lighting.ShadowSoftness))
	aU(
		aI,
		"EnvironmentDiffuseScale",
		af("diffusescale", aL.Lighting.EnvironmentDiffuseScale)
	)
	aU(
		aI,
		"EnvironmentSpecularScale",
		af("specularscale", aL.Lighting.EnvironmentSpecularScale)
	)
	aU(aI, "GeographicLatitude", af("latitude", aL.Lighting.GeographicLatitude))
	aU(aI, "Ambient", af("ambientcolor", aL.Lighting.Ambient))
	aU(aI, "OutdoorAmbient", af("outdoorambient", aL.Lighting.OutdoorAmbient))
	aU(aI, "ColorShift_Top", af("colorshifttop", aL.Lighting.ColorShift_Top))
	aU(
		aI,
		"ColorShift_Bottom",
		af("colorshiftbottom", aL.Lighting.ColorShift_Bottom)
	)
	aU(aI, "FogColor", af("fogcolor", aL.Lighting.FogColor))
	aU(aI, "FogStart", aW)
	aU(aI, "FogEnd", math.max(aW, af("fogend", aL.Lighting.FogEnd)))

	for aX, aY in ipairs(aM) do
		if not aY.Parent then
			continue
		end
		if aY:IsA("Atmosphere") then
			local aZ = aL.Effects[aY]
			local a_ = ae("atmosphereenabled", true)
			aU(aY, "Color", af("atmospherecolor", aZ.Color))
			aU(aY, "Decay", af("atmospheredecay", aZ.Decay))
			aU(aY, "Density", a_ and af("atmospheredensity", aZ.Density) or 0)
			aU(aY, "Offset", af("atmosphereoffset", aZ.Offset))
			aU(aY, "Haze", a_ and af("atmospherehaze", aZ.Haze) or 0)
			aU(aY, "Glare", a_ and af("atmosphereglare", aZ.Glare) or 0)
		elseif aY:IsA("BloomEffect") then
			local aZ = aL.Effects[aY]
			aU(aY, "Enabled", ae("bloomenabled", aZ.Enabled))
			aU(aY, "Intensity", af("bloomintensity", aZ.Intensity))
			aU(aY, "Size", af("bloomsize", aZ.Size))
			aU(aY, "Threshold", af("bloomthreshold", aZ.Threshold))
		elseif aY:IsA("ColorCorrectionEffect") then
			local aZ = aL.Effects[aY]
			aU(aY, "Enabled", ae("colorcorrectionenabled", aZ.Enabled))
			aU(aY, "Brightness", af("ccbrightness", aZ.Brightness))
			aU(aY, "Contrast", af("cccontrast", aZ.Contrast))
			aU(aY, "Saturation", af("ccsaturation", aZ.Saturation))
			aU(aY, "TintColor", af("cctint", aZ.TintColor))
		elseif aY:IsA("SunRaysEffect") then
			local aZ = aL.Effects[aY]
			aU(aY, "Enabled", ae("sunraysenabled", aZ.Enabled))
			aU(aY, "Intensity", af("sunraysintensity", aZ.Intensity))
			aU(aY, "Spread", af("sunraysspread", aZ.Spread))
		elseif aY:IsA("DepthOfFieldEffect") and aY.Name == "DepthOfField" then
			local aZ = aL.Effects[aY]
			aU(aY, "Enabled", ae("dofenabled", aZ.Enabled))
			aU(aY, "FarIntensity", af("doffar", aZ.FarIntensity))
			aU(aY, "NearIntensity", af("dofnear", aZ.NearIntensity))
			aU(aY, "FocusDistance", af("doffocus", aZ.FocusDistance))
			aU(aY, "InFocusRadius", af("dofradius", aZ.InFocusRadius))
		elseif aY:IsA("BlurEffect") then
			local aZ = aL.Effects[aY]
			aU(aY, "Enabled", ae("blurenabled", aZ.Enabled))
			aU(aY, "Size", af("blursize", aZ.Size))
		end
	end
end

local aW = an.Visuals:AddRightGroupbox("Lighting")
aW:AddToggle(
	"lightingoverride",
	{
		Text = "Lighting Override",
		Default = false,
	}
)
Toggles.lightingoverride:OnChanged(function(aX)
	if aX then
		aV()
	else
		aT()
	end
end)
aW:AddToggle("globalshadows", { Text = "Global Shadows", Default = aI.GlobalShadows })
aW:AddSlider(
	"lightingbrightness",
	{ Text = "Brightness", Default = aI.Brightness, Min = 0, Max = 10, Rounding = 2 }
)
aW:AddSlider(
	"clocktime",
	{ Text = "Clock Time", Default = aI.ClockTime, Min = 0, Max = 24, Rounding = 2, Suffix = " h" }
)
aW:AddSlider(
	"exposure",
	{ Text = "Exposure", Default = aI.ExposureCompensation, Min = -5, Max = 5, Rounding = 2 }
)
aW:AddSlider(
	"shadowsoftness",
	{ Text = "Shadow Softness", Default = aI.ShadowSoftness, Min = 0, Max = 1, Rounding = 2 }
)
aW:AddSlider(
	"diffusescale",
	{ Text = "Environment Diffuse", Default = aI.EnvironmentDiffuseScale, Min = 0, Max = 1, Rounding = 2 }
)
aW:AddSlider(
	"specularscale",
	{ Text = "Environment Specular", Default = aI.EnvironmentSpecularScale, Min = 0, Max = 1, Rounding = 2 }
)
aW:AddSlider(
	"latitude",
	{ Text = "Sun Latitude", Default = aI.GeographicLatitude, Min = -180, Max = 180, Rounding = 1, Suffix = "°" }
)
aW:AddLabel("Ambient"):AddColorPicker("ambientcolor", { Default = aI.Ambient, Title = "Ambient" })
aW
	:AddLabel("Outdoor Ambient")
	:AddColorPicker("outdoorambient", { Default = aI.OutdoorAmbient, Title = "Outdoor Ambient" })
aW
	:AddLabel("Color Shift Top")
	:AddColorPicker("colorshifttop", { Default = aI.ColorShift_Top, Title = "Color Shift Top" })
aW
	:AddLabel("Color Shift Bottom")
	:AddColorPicker("colorshiftbottom", { Default = aI.ColorShift_Bottom, Title = "Color Shift Bottom" })

local aX = an.Visuals:AddRightGroupbox("Fog & Atmosphere")
aX:AddLabel("Fog Color"):AddColorPicker("fogcolor", { Default = aI.FogColor, Title = "Fog Color" })
aX:AddSlider(
	"fogstart",
	{ Text = "Fog Start", Default = aI.FogStart, Min = 0, Max = 10000, Rounding = 0, Suffix = " studs" }
)
aX:AddSlider(
	"fogend",
	{
		Text = "Fog End",
		Default = math.min(aI.FogEnd, 100000),
		Min = 0,
		Max = 100000,
		Rounding = 0,
		Suffix = " studs",
	}
)
aX:AddToggle("atmosphereenabled", { Text = "Atmosphere", Default = true })
aX:AddLabel("Atmosphere Color"):AddColorPicker(
	"atmospherecolor",
	{ Default = aN and aN.Color or Color3.new(1, 1, 1), Title = "Atmosphere Color" }
)
aX:AddLabel("Atmosphere Decay"):AddColorPicker(
	"atmospheredecay",
	{ Default = aN and aN.Decay or Color3.new(1, 1, 1), Title = "Atmosphere Decay" }
)
aX:AddSlider(
	"atmospheredensity",
	{ Text = "Density", Default = aN and aN.Density or 0, Min = 0, Max = 1, Rounding = 3 }
)
aX:AddSlider(
	"atmosphereoffset",
	{ Text = "Offset", Default = aN and aN.Offset or 0, Min = -1, Max = 1, Rounding = 3 }
)
aX:AddSlider(
	"atmospherehaze",
	{ Text = "Haze", Default = aN and aN.Haze or 0, Min = 0, Max = 10, Rounding = 2 }
)
aX:AddSlider(
	"atmosphereglare",
	{ Text = "Glare", Default = aN and aN.Glare or 0, Min = 0, Max = 10, Rounding = 2 }
)

local aY = an.Visuals:AddRightGroupbox("Post Processing")
aY:AddToggle("bloomenabled", { Text = "Bloom", Default = aO and aO.Enabled or false })
aY:AddSlider(
	"bloomintensity",
	{ Text = "Bloom Intensity", Default = aO and aO.Intensity or 0, Min = 0, Max = 10, Rounding = 2 }
)
aY:AddSlider(
	"bloomsize",
	{ Text = "Bloom Size", Default = aO and aO.Size or 24, Min = 0, Max = 56, Rounding = 0 }
)
aY:AddSlider(
	"bloomthreshold",
	{ Text = "Bloom Threshold", Default = aO and aO.Threshold or 2, Min = 0, Max = 10, Rounding = 2 }
)
aY:AddToggle(
	"colorcorrectionenabled",
	{ Text = "Color Correction", Default = aP and aP.Enabled or false }
)
aY:AddSlider(
	"ccbrightness",
	{
		Text = "CC Brightness",
		Default = aP and aP.Brightness or 0,
		Min = -1,
		Max = 1,
		Rounding = 2,
	}
)
aY:AddSlider(
	"cccontrast",
	{
		Text = "CC Contrast",
		Default = aP and aP.Contrast or 0,
		Min = -1,
		Max = 1,
		Rounding = 2,
	}
)
aY:AddSlider(
	"ccsaturation",
	{
		Text = "CC Saturation",
		Default = aP and aP.Saturation or 0,
		Min = -1,
		Max = 1,
		Rounding = 2,
	}
)
aY:AddLabel("CC Tint"):AddColorPicker(
	"cctint",
	{
		Default = aP and aP.TintColor or Color3.new(1, 1, 1),
		Title = "Color Correction Tint",
	}
)
aY:AddToggle(
	"sunraysenabled",
	{ Text = "Sun Rays", Default = aQ and aQ.Enabled or false }
)
aY:AddSlider(
	"sunraysintensity",
	{
		Text = "Sun Rays Intensity",
		Default = aQ and aQ.Intensity or 0,
		Min = 0,
		Max = 1,
		Rounding = 3,
	}
)
aY:AddSlider(
	"sunraysspread",
	{ Text = "Sun Rays Spread", Default = aQ and aQ.Spread or 0, Min = 0, Max = 1, Rounding = 3 }
)
aY:AddToggle(
	"dofenabled",
	{ Text = "Depth of Field", Default = aR and aR.Enabled or false }
)
aY:AddSlider(
	"doffar",
	{
		Text = "DOF Far Intensity",
		Default = aR and aR.FarIntensity or 0,
		Min = 0,
		Max = 1,
		Rounding = 3,
	}
)
aY:AddSlider(
	"dofnear",
	{
		Text = "DOF Near Intensity",
		Default = aR and aR.NearIntensity or 0,
		Min = 0,
		Max = 1,
		Rounding = 3,
	}
)
aY:AddSlider(
	"doffocus",
	{
		Text = "DOF Focus Distance",
		Default = aR and aR.FocusDistance or 10,
		Min = 0,
		Max = 500,
		Rounding = 1,
	}
)
aY:AddSlider(
	"dofradius",
	{
		Text = "DOF Focus Radius",
		Default = aR and aR.InFocusRadius or 30,
		Min = 0,
		Max = 500,
		Rounding = 1,
	}
)
aY:AddToggle("blurenabled", { Text = "Blur", Default = aS and aS.Enabled or false })
aY:AddSlider(
	"blursize",
	{ Text = "Blur Size", Default = aS and aS.Size or 0, Min = 0, Max = 56, Rounding = 0 }
)

local aZ = an.Visuals:AddLeftGroupbox("Bullet Tracers")
aZ:AddToggle("tracersenabled", { Text = "Bullet Tracers Enabled", Default = false })

aZ:AddToggle("teamtracers", { Text = "Draw Team Tracers", Default = false })
aZ:AddLabel("Team Tracers Color")
	:AddColorPicker("teamtracerscolor", { Default = Color3.fromRGB(59, 144, 204), Title = "Team Tracer Color" })
aZ:AddDropdown(
	"teamtracersmaterial",
	{
		Text = "Team Tracer Material",
		Values = { "Plastic", "SmoothPlastic", "ForceField", "Neon", "Glass" },
		Default = 1,
		Multi = false,
	}
)
aZ:AddSlider(
	"teamtracerstransparency",
	{
		Text = "Team Tracer Transparency",
		Default = 0.5,
		Min = 0,
		Max = 1,
		Rounding = 2,
	}
)

aZ:AddToggle("enemytracers", { Text = "Draw Enemy Tracers", Default = false })
aZ:AddLabel("Enemy Tracers Color")
	:AddColorPicker("enemytracerscolor", { Default = Color3.fromRGB(255, 60, 60), Title = "Enemy Tracer Color" })
aZ:AddDropdown(
	"enemytracersmaterial",
	{
		Text = "Enemy Tracer Material",
		Values = { "Plastic", "SmoothPlastic", "ForceField", "Neon", "Glass" },
		Default = 1,
		Multi = false,
	}
)
aZ:AddSlider(
	"enemytracerstransparency",
	{
		Text = "Enemy Tracer Transparency",
		Default = 0.5,
		Min = 0,
		Max = 1,
		Rounding = 2,
	}
)
aZ:AddToggle("localtracers", { Text = "Draw Local Tracers", Default = false })
aZ:AddLabel("Local Tracers Color")
	:AddColorPicker("localtracerscolor", { Default = Color3.fromRGB(59, 255, 50), Title = "Local Tracer Color" })
aZ:AddDropdown(
	"localtracersmaterial",
	{
		Text = "Local Tracer Material",
		Values = { "Plastic", "SmoothPlastic", "ForceField", "Neon", "Glass" },
		Default = 1,
		Multi = false,
	}
)
aZ:AddSlider(
	"localtracerstransparency",
	{
		Text = "Local Tracer Transparency",
		Default = 0.5,
		Min = 0,
		Max = 1,
		Rounding = 2,
	}
)
aZ:AddSlider("bullettracersize", { Text = "Bullet Tracer Size", Default = 0.1, Min = 0.01, Max = 1, Rounding = 2 })


	ac.visuals = {
		teamFilterStep = aH,
		applyLighting = aV,
		unload = function()
			aT()
		end,
	}
end

function ab.step()
end

function ab.unload()
end

return ab
end function a.e()local ab=a.cache.e if not ab then ab={c=aa()}a.cache.e=ab end return ab.c end end do local function aa()
local ab = {}

function ab.build(ac)
	local ad = ac.flags
	local ae = ac.tv
	local af = ac.ov
	local ag = ac.util
	local ah = ac.Players
	local ai = ac.RunService
	local aj = ac.UserInputService
	local ak = ac.LocalPlayer
	local al = ac.RS
	local am = ac.Library
	local an = ac.Tabs
	local ao = ac.HttpService
	local ap = ac.manipulation
	local aq = ac.RecoilController
	local ar = ac.AimController
	local as = ac.FiremodeController
	local at = ac.Trajectory
	local au = ac.InventoryController
	local av = ac.CameraShaker
	local aw = ac.paidToggleKeys
	local ax = ac.paidOptionKeys
local ay = true
local az = 10
local aA = 200
local aB = Drawing.new("Text")
aB.Text = "Moderators\nChecking players..."
aB.Position = Vector2.new(az, aA)
aB.Size = 14
aB.Color = Color3.fromRGB(255, 255, 255)
aB.Outline = true
aB.OutlineColor = Color3.fromRGB(0, 0, 0)
aB.Visible = ay
local aC = {}
local aD = {}
local aE
local aF

local function aG()
	LPH_ATTRIBUTES(VM(NONE))
	local aH = {}
	for aI, aJ in pairs(aC) do
		if aI.Parent == ah and aJ.IsModerator then
			local aK = {}
			if aJ.Rank >= 240 then
				aK[#aK + 1] = "Rank " .. aJ.Rank
			end
			if aJ.ControlPanel then
				aK[#aK + 1] = "Control Panel"
			end
			aH[#aH + 1] = {
				SortName = aI.Name:lower(),
				Text = string.format("%s (@%s) [%s]", aI.DisplayName, aI.Name, table.concat(aK, ", ")),
			}
		end
	end
	table.sort(aH, function(aI, aJ)
		return aI.SortName < aJ.SortName
	end)

	local aI = {}
	for aJ, aK in ipairs(aH) do
		aI[#aI + 1] = aK.Text
	end
	if aB then
		aB.Text = "Moderators\n" .. (#aI > 0 and table.concat(aI, "\n") or "No moderators online")
	end
end

local function aH(aI)
	LPH_ATTRIBUTES(VM(NONE))
	if aD[aI] then
		aD[aI]:Disconnect()
	end

	local aJ = aI:GetAttribute("ControlPanelAccess") == true
	local aK = {
		Rank = 0,
		ControlPanel = aJ,
		IsModerator = aJ,
	}
	aC[aI] = aK
	aG()

	aD[aI] = aI:GetAttributeChangedSignal("ControlPanelAccess"):Connect(function()
		aK.ControlPanel = aI:GetAttribute("ControlPanelAccess") == true
		aK.IsModerator = aK.Rank >= 240 or aK.ControlPanel
		aG()
	end)

	task.spawn(function()
		local aL, aM = pcall(aI.GetRankInGroup, aI, 32519006)
		if aC[aI] ~= aK then
			return
		end
		aK.Rank = aL and aM or 0
		aK.IsModerator = aK.Rank >= 240 or aK.ControlPanel
		aG()
	end)
end

local function aI(aJ)
	LPH_ATTRIBUTES(VM(NONE))
	if aD[aJ] then
		aD[aJ]:Disconnect()
		aD[aJ] = nil
	end
	aC[aJ] = nil
	aG()
end

for aJ, aK in ipairs(ah:GetPlayers()) do
	aH(aK)
end
aE = ah.PlayerAdded:Connect(aH)
aF = ah.PlayerRemoving:Connect(aI)

local aJ
local aK
local aL
local function aM(aN)
	if aJ then
		aJ:Disconnect()
		aJ = nil
	end
	local aO = aN
		and (aN:FindFirstChildWhichIsA("Humanoid") or aN:WaitForChild("Humanoid", 5))
	if not aO then
		return
	end
	local aP = false
	local function aQ()
		if not ae("walkspeedenabled", false) or aP then
			return
		end
		aP = true
		aO.WalkSpeed = af("walkspeed", 16)
		aP = false
	end
	aQ()
	aJ = aO:GetPropertyChangedSignal("WalkSpeed"):Connect(aQ)
end
local function aN(aO)
	if aL then
		aL:Disconnect()
		aL = nil
	end
	local aP = aO
		and (aO:FindFirstChildWhichIsA("Humanoid") or aO:WaitForChild("Humanoid", 5))
	if not aP then
		return
	end
	local aQ = false
	local function aR()
		if not ae("jumppowerenabled", false) or aQ then
			return
		end
		aQ = true
		aP.UseJumpPower = true
		aP.JumpPower = af("jumppower", 50)
		aQ = false
	end
	aR()
	aL = aP:GetPropertyChangedSignal("JumpPower"):Connect(aR)
end
aK = ak.CharacterAdded:Connect(function(aO)
	aM(aO)
	aN(aO)
end)
aM(ak.Character)
aN(ak.Character)

local aO
local aP
local aQ = 0
local function aR(aS)
	LPH_ATTRIBUTES(VM(NONE))
	if not ad.antiaimspin and not aO then
		return
	end
	local aT = ak.Character
	local aU = aT and aT:FindFirstChildWhichIsA("Humanoid")
	local aV = aT and aT:FindFirstChild("HumanoidRootPart")
	if not (aU and aV) then
		return
	end
	local aW = aU.Sit
		or aU.SeatPart ~= nil
		or ak:GetAttribute("InVehicle") == true
		or aT:GetAttribute("InVehicle") == true
		or aV:FindFirstChild("SeatWeld") ~= nil

	if ad.antiaimspin and not aW then
		if aO ~= aU then
			if aO and aO.Parent and aP ~= nil then
				aO.AutoRotate = aP
			end
			aO = aU
			aP = aU.AutoRotate
			aQ = select(2, aV.CFrame:ToOrientation())
		end
		aU.AutoRotate = false
	elseif aO then
		if aO.Parent and aP ~= nil then
			aO.AutoRotate = aP
		end
		aO = nil
		aP = nil
	end

	if ad.antiaimspin and not aW then
		aQ = (aQ + math.rad(af("antiaimspinspeed", 180)) * aS) % math.tau
		aV.CFrame = CFrame.new(aV.Position) * CFrame.Angles(0, aQ, 0)
	end
end
if la_is_premium then
    local aS = an.Misc:AddLeftGroupbox("Movement")
    aS:AddToggle(
    	"walkspeedenabled",
    	{ Text = "WalkSpeed", Default = false }
    )
    Toggles.walkspeedenabled:OnChanged(function(aT)
    	aM(ak.Character)
    end)
    aS:AddSlider("walkspeed", { Text = "WalkSpeed Value", Default = 16, Min = 0, Max = 50, Rounding = 0 })
    Options.walkspeed:OnChanged(function(aT)
    	aM(ak.Character)
    end)
    aS:AddToggle(
    	"jumppowerenabled",
    	{ Text = "JumpPower", Default = false }
    )
    Toggles.jumppowerenabled:OnChanged(function(aT)
    	aN(ak.Character)
    end)
    aS:AddSlider(
    	"jumppower",
    	{
    		Text = "JumpPower Value",
    		Default = 50,
    		Min = 0,
    		Max = 100,
    		Rounding = 0,
    	}
    )
    Options.jumppower:OnChanged(function(aT)
    	aN(ak.Character)
    end)
    aS:AddToggle("omnisprint", { Text = "Omni Sprint", Default = false })
    aS:AddToggle(
    	"nohurtslowdown",
    	{ Text = "No Hurt Slowdown", Default = false }
    )

    local aT = an.Misc:AddLeftGroupbox("Anti Aim")
    aT:AddToggle(
    	"antiaimpitch",
    	{
    		Text = "Head Pitch",
    		Default = false,
    	}
    )
    aT:AddSlider(
    	"antiaimpitchangle",
    	{ Text = "Head Pitch Angle", Default = 90, Min = -180, Max = 180, Rounding = 0, Suffix = "°" }
    )
    aT:AddToggle(
    	"gunup",
    	{ Text = "Always Gun Up", Default = false }
    )
    aT:AddToggle("antiaimspin", { Text = "Spin", Default = false })
    Toggles.antiaimspin:OnChanged(function(aU)
    	if not aU and aO then
    		if aO.Parent and aP ~= nil then
    			aO.AutoRotate = aP
    		end
    		aO = nil
    		aP = nil
    	end
    end)
    aT:AddSlider(
    	"antiaimspinspeed",
    	{ Text = "Spin Speed", Default = 180, Min = 0, Max = 1080, Rounding = 0, Suffix = "°/s" }
    )

    local function aU(aV)
    	local aW = aV and aV:FindFirstChild("CharacterValues")
    	if not aW then
    		return
    	end
	if ad.antisuppression then
     		local aX = aW:FindFirstChild("Suppression")
    		local aY = aW:FindFirstChild("Deafening")
    		if aX then
    			aX.Value = 0
    		end
    		if aY then
    			aY.Value = 0
    		end
    	end
    end

    local aV = game:GetService("Lighting"):FindFirstChild("SuppressionDepthOfField")
    local aW = aV and aV.Enabled
    local aX = 0
    function antiEffectsStep(aY)
    	LPH_ATTRIBUTES(VM(NONE))
    	if not (ad.antisuppression or ad.antiflashbang) then
    		return
    	end
    	aX = aX + aY
    	if aX < 0.5 then
    		return
    	end
    	aX = 0
    	aU(ak.Character)

     	if ad.antisuppression then
     		aV = game:GetService("Lighting"):FindFirstChild("SuppressionDepthOfField")
    			or aV
    		if aV and aV:IsA("PostEffect") then
    			aV.Enabled = false
    		end
    	end

     	if ad.antiflashbang then
    		for aZ, a_ in ipairs({ game:GetService("Lighting"), ak:FindFirstChildOfClass("PlayerGui") }) do
    			if a_ then
    				for a0, a1 in ipairs(a_:GetDescendants()) do
    					local a2 = a1.Name:lower()
    					if
    						a2:find("flash", 1, true)
    						or a2:find("stun", 1, true)
    						or a2:find("concussion", 1, true)
    					then
    						if a1:IsA("PostEffect") then
    							a1.Enabled = false
    						elseif a1:IsA("LayerCollector") then
    							a1.Enabled = false
    						elseif a1:IsA("GuiObject") then
    							a1.Visible = false
    						end
    					end
    				end
    			end
    		end
    	end
    end

    local aY = an.Misc:AddLeftGroupbox("Screen Effects")
    aY:AddToggle(
    	"antisuppression",
    	{
    		Text = "Anti Suppression",
    		Default = false,
    	}
    )
    Toggles.antisuppression:OnChanged(function(aZ)
    	if aZ then
    		aU(ak.Character)
    	elseif aV and aV.Parent then
    		aV.Enabled = aW
    	end
    end)
    aY:AddToggle(
    	"antiflashbang",
    	{
    		Text = "Anti Flashbang",
    		Default = false,
    	}
    )

    local aZ = an.Misc:AddRightGroupbox("Healing")
    aZ:AddToggle("autoheal", { Text = "Auto Heal", Default = false })
    aZ:AddSlider("autohealmindamage", {
    	Text = "Min Damage",
    	Default = 30,
    	Min = 0,
    	Max = 100,
    	Rounding = 0,
    	Suffix = "%",
    })
    aZ:AddToggle("instantheal", { Text = "Instant Heal", Default = false })
    local a_ = ac.functions.healLimb.upv and ac.functions.healLimb.upv[7]
    local a0 = {}
    aZ:AddToggle("nobandageslowdown", { Text = "No Bandage Slowdown", Default = false })
    Toggles["nobandageslowdown"]:OnChanged(function(a1)
    	if la_is_premium ~= true or not ac.functions.healLimb.func then return end
    	if a1 then
    		debug.setupvalue(ac.functions.healLimb.func, 7, a0)
    	else
    		debug.setupvalue(ac.functions.healLimb.func, 7, a_)
    	end
    end)
    aZ:AddToggle("fastrevive", { Text = "Fast Revive", Default = false })

    local a1 = an.Misc:AddRightGroupbox("Vehicles")
    a1:AddToggle("carmods", { Text = "Car Mods", Default = false })
    Toggles["carmods"]:OnChanged(function(a2)
    	ac.cars.apply()
    end)
    a1:AddDropdown(
    	"carprofile",
    	{ Text = "Car", Values = ac.cars.entries, Default = 1, Multi = false, AllowNull = true }
    )
    Options.carprofile:OnChanged(function(a2)
    	ac.cars.state.selected = a2
    	local a3 = ac.cars.profile()
    	if not a3 then
    		return
    	end
    	for a4 in pairs(ac.cars.defaults) do
    		if Options["car_" .. a4] then
    			Options["car_" .. a4]:SetValue(a3[a4])
    		end
    	end
    	for a4 in pairs(ac.cars.boolDefaults) do
    		if Toggles["car_" .. a4] then
    			Toggles["car_" .. a4]:SetValue(a3[a4])
    		end
    	end
    	for a4, a5 in pairs({
    		ChassisType = { "Wheeled", "Tracked" },
    		DriveType = { "FWD", "RWD", "AWD" },
    		Differential = { "Open", "Locked" },
    	}) do
    		if Options["car_" .. a4] then
    			Options["car_" .. a4]:SetValue(a3[a4])
    		end
    	end
    	for a4 = -1, 6 do
    		local a5 = a3.Ratios and a3.Ratios[a4] or 0
    		if Options["car_ratio_" .. tostring(a4)] then
    			Options["car_ratio_" .. tostring(a4)]:SetValue(a5)
    		end
    	end
    	for a4 = 1, 4 do
    		local a5 = a3.Wheels and a3.Wheels[a4]
    		if Toggles["car_wheel_" .. a4 .. "_drive"] then
    			Toggles["car_wheel_" .. a4 .. "_drive"]:SetValue(a5 and a5.Drive == true or true)
    		end
    		if Toggles["car_wheel_" .. a4 .. "_steer"] then
    			Toggles["car_wheel_" .. a4 .. "_steer"]:SetValue(a5 and a5.Steer == 1 or a4 <= 2)
    		end
    	end
    	ac.cars.syncJson()
    	ac.cars.apply()
    end)
    a1:AddLabel("Saved profiles are stored per car and faction")

    local a2 = {
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
    for a3, a4 in ipairs({ "Reverse", "Neutral", "Gear 1", "Gear 2", "Gear 3", "Gear 4", "Gear 5", "Gear 6" }) do
    	local a5 = a3 - 2
    	local a6 = "car_ratio_" .. tostring(a5)
    	a1:AddSlider(a6, { Text = a4 .. " Ratio", Default = 0, Min = -15, Max = 15, Rounding = 3 })
    	Options[a6]:OnChanged(function(a7)
    		local a8 = ac.cars.profile()
    		if not a8 then
    			return
    		end
    		a8.Ratios = a8.Ratios or {}
    		a8.Ratios[a5] = a7
    		ac.cars.syncJson()
    		ac.cars.apply()
    	end)
    end
    for a3, a4 in ipairs({ "Front Left", "Front Right", "Rear Left", "Rear Right" }) do
    	local a5 = "car_wheel_" .. a3 .. "_"
    	a1:AddToggle(a5 .. "drive", { Text = a4 .. " Drive", Default = true })
    	a1:AddToggle(a5 .. "steer", { Text = a4 .. " Steer", Default = a3 <= 2 })
    	Toggles[a5 .. "drive"]:OnChanged(function(a6)
    		local a7 = ac.cars.profile()
    		if not a7 then
    			return
    		end
    		a7.Wheels = a7.Wheels or {}
    		a7.Wheels[a3] = a7.Wheels[a3]
    			or { Name = a4:gsub(" ", ""), Drive = true, Steer = a3 <= 2 and 1 or 0 }
    		a7.Wheels[a3].Drive = a6
    		ac.cars.syncJson()
    		ac.cars.apply()
    	end)
    	Toggles[a5 .. "steer"]:OnChanged(function(a6)
    		local a7 = ac.cars.profile()
    		if not a7 then
    			return
    		end
    		a7.Wheels = a7.Wheels or {}
    		a7.Wheels[a3] = a7.Wheels[a3]
    			or { Name = a4:gsub(" ", ""), Drive = true, Steer = a3 <= 2 and 1 or 0 }
    		a7.Wheels[a3].Steer = a6 and 1 or 0
    		ac.cars.syncJson()
    		ac.cars.apply()
    	end)
    end
    for a3, a4 in ipairs(a2) do
    	local a5, a6, a7, a8, a9 = table.unpack(a4)
    	a1:AddSlider(
    		"car_" .. a5,
    		{ Text = a6, Default = ac.cars.defaults[a5], Min = a7, Max = a8, Rounding = a9 }
    	)
    	Options["car_" .. a5]:OnChanged(function(b)
    		ac.cars.setControl(a5, b)
    	end)
    end
    for a3, a4 in pairs(ac.cars.boolDefaults) do
    	a1:AddToggle("car_" .. a3, { Text = a3, Default = a4 })
    	Toggles["car_" .. a3]:OnChanged(function(a5)
    		ac.cars.setControl(a3, a5)
    	end)
    end
    for a3, a4 in pairs({
    	ChassisType = { "Wheeled", "Tracked" },
    	DriveType = { "FWD", "RWD", "AWD" },
    	Differential = { "Open", "Locked" },
    }) do
    	a1:AddDropdown(
    		"car_" .. a3,
    		{ Text = a3, Values = a4, Default = ac.cars.choiceDefaults[a3], Multi = false }
    	)
    	Options["car_" .. a3]:OnChanged(function(a5)
    		ac.cars.setControl(a3, a5)
    	end)
    end
    a1:AddInput("carsprofiles", { Text = "Profile data", Default = "{}" })
    Options.carsprofiles:OnChanged(function(a3)
    	ac.cars.loadJson(a3)
    	ac.cars.syncJson()
    	ac.cars.apply()
    end)
if ac.cars.state.selected then
     	Options.carprofile:SetValue(ac.cars.state.selected)
    end
end

	ac.misc = {
		movementStep = aR,
		antiEffectsStep = antiEffectsStep,
		bindSettings = function(aS)
local aT = "NUfjhQcETc"

local function aU(aV)
	local aW = http_request
		or request
		or (syn and syn.request)
		or (fluxus and fluxus.request)
		or (getgenv and getgenv().request)
	if not aW then
		am:Notify("No HTTP request function on this executor.")
		return
	end
	local aX = ao:JSONEncode({
		cmd = "INVITE_BROWSER",
		args = { code = aV },
		nonce = ao:GenerateGUID(false),
	})
	local aY = false
	for aZ = 6463, 6472 do
		local a_, a0 = pcall(aW, {
			Url = ("http://127.0.0.1:%d/rpc?v=1"):format(aZ),
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
				["Origin"] = "https://discord.com",
			},
			Body = aX,
		})
		if a_ and a0 and (a0.StatusCode == 200 or a0.Success) then
			aY = true
			break
		end
	end
	am:Notify(aY and "Opened the invite in Discord." or "Couldn't reach Discord (is it running?).")
end

aS:AddButton({
	Text = "Join Discord",
	Func = function()
		aU(aT)
	end,
})
aS
	:AddToggle(
		"ShowModeratorList",
		{ Text = "Show Moderator List", Default = true }
	)
	:OnChanged(function(aV)
		ay = aV
		if aB then
			aB.Visible = aV
		end
	end)
aS:AddSlider(
	"ModeratorListX",
	{ Text = "Moderator List X", Default = 10, Min = 0, Max = 2000, Rounding = 0, Suffix = " px" }
)
Options.ModeratorListX:OnChanged(function(aV)
	az = aV
	if aB then
		aB.Position = Vector2.new(az, aA)
	end
end)
aS:AddSlider(
	"ModeratorListY",
	{ Text = "Moderator List Y", Default = 200, Min = 0, Max = 1200, Rounding = 0, Suffix = " px" }
)
Options.ModeratorListY:OnChanged(function(aV)
	aA = aV
	if aB then
		aB.Position = Vector2.new(az, aA)
	end
end)

		end,
		unload = function()
			if aJ then
				aJ:Disconnect()
				aJ = nil
			end
			if aL then
				aL:Disconnect()
				aL = nil
			end
			if aK then
				aK:Disconnect()
				aK = nil
			end
			if aO and aO.Parent and aP ~= nil then
				aO.AutoRotate = aP
			end
			aO = nil
			local aS = ak.Character and ak.Character:FindFirstChildWhichIsA("Humanoid")
			if aS then
				aS.PlatformStand = false
			end
			if aE then
				aE:Disconnect()
			end
			if aF then
				aF:Disconnect()
			end
			if aD then
				for aT, aU in pairs(aD) do
					aU:Disconnect()
					aD[aT] = nil
				end
			end
			if aB then
				aB:Remove()
				aB = nil
			end
		end,
	}
end

function ab.step()
end

function ab.unload()
end

return ab
end function a.f()local ab=a.cache.f if not ab then ab={c=aa()}a.cache.f=ab end return ab.c end end end

if not LPH_OBFUSCATED then
	LPH_ATTRIBUTES = function(...) end
	VM = function(...)
		return ...
	end
	NONE = "NONE"
	LPH_NO_UPVALUES = function(aa)
		return function(...)
			return aa(...)
		end
	end
	LPH_ENCSTR = function(...)
		return ...
	end
	LPH_ENCNUM = function(...)
		return ...
	end
	LPH_ENCFUNC = function(aa, ab, ac)
		if ab ~= ac then
			return print("LPH_ENCFUNC mismatch")
		end
		return aa
	end
	LPH_CRASH = function()
		return print(debug.traceback())
	end
end

local aa = a.a()
local ab, ac = aa.checkKey(getgenv().script_key)

if not ab then
    setclipboard("https://discord.gg/Z7tvDkBUxX")
    game.Players.LocalPlayer:Kick("Please get a valid key from https://discord.gg/Z7tvDkBUxX, we have attempted to copy it to your clipboard")
    return
end

local ad = {
	ragebot = true, ragebotautoreload = true, ragebotwallbang = true,
	walkspeedenabled = true, jumppowerenabled = true, omnisprint = true,
	nohurtslowdown = true, antiaimpitch = true, gunup = true, antiaimspin = true,
	antisuppression = true, antiflashbang = true, autoheal = true, instantheal = true,
	nobandageslowdown = true, fastrevive = true, carmods = true,
}
local ae = {
	walkspeed = true, jumppower = true, antiaimpitchangle = true, antiaimspinspeed = true,
	autohealmindamage = true,
}

do
	local af = game:GetService("Players").LocalPlayer
	af = af and af:FindFirstChild("PlayerScripts")
	af = af and af:FindFirstChild("PlayerModule")
	local ag = af and getscriptclosure and getscriptclosure(af)
	local ah = debug.getprotos or getprotos
	if type(ag) == "function" and ah then
		local ai, aj = pcall(ah, ag)
		if ai then
			for ak, al in aj do
				if type(al) == "function" then
					local am = {}
					pcall(function()
						am = debug.getconstants(al)
					end)
					local an, ao, ap, aq, ar = false, false, false, false, false
					for as, at in am do
						if at == "StreamingHint" then an = true end
						if at == "Animator" then ao = true end
						if at == "MovementPing" then ar = true end
						if at == "task" then ap = true end
						if at == "random" then aq = true end
					end
					local as = 0
					pcall(function()
						as = debug.getinfo(al).nups or 0
					end)
					if an or ao or ar or (ap and aq and as == 3) then
						pcall(hookfunc, al, function() end)
					elseif not ar then
						local at, au = pcall(ah, al)
						if at then
							for av, aw in au do
								if type(aw) == "function" then
									local ax = {}
									pcall(function()
										ax = debug.getconstants(aw)
									end)
									for ay, az in ax do
										if az == "MovementPing" then
											pcall(hookfunc, aw, function() end)
											break
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

local af = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"

Library = loadstring(game:HttpGet(af .. "Library.lua"))()
local ag = loadstring(game:HttpGet(af .. "addons/ThemeManager.lua"))()
local ah = loadstring(game:HttpGet(af .. "addons/SaveManager.lua"))()

local ai = game:GetService("Players")
local aj = game:GetService("RunService")
local ak = game:GetService("UserInputService")
local al = ai.LocalPlayer
local am = game:GetService("ReplicatedStorage")
local an = am.Client
local ao = an.Tools
local ap = ao.Weapon.controllers

local aq = require(ap.RecoilController)
local ar = require(ap.AimController)
local as = require(ao.Weapon.Muzzle.firemodes.FireController)
local at = require(am:WaitForChild("Shared"):WaitForChild("Ballistics"):WaitForChild("Trajectory"))
local au = require(an:WaitForChild("Character"):WaitForChild("InventoryController"))
local av = require(an:WaitForChild("GGCameraShaker"))

local function aw(ax, ay)
	LPH_ATTRIBUTES(VM(NONE))
	if ad[ax] and ac ~= true then return false end
	local az = Toggles and Toggles[ax]
	if az and az.Value ~= nil then
		return az.Value
	end
	return ay
end

local function ax(ay, az)
	LPH_ATTRIBUTES(VM(NONE))
	if ae[ay] and ac ~= true then return az end
	local aA = Options and Options[ay]
	if aA and aA.Value ~= nil then
		return aA.Value
	end
	return az
end

local ay = {
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
	manipulation = false,
	manipulationdistance = 1,
	manipulationdepth = "Low",
	autoheal = false,
	instantheal = false,
	fastrevive = false,
	carmods = false,
	antisuppression = false,
	antiflashbang = false,
	antiaimspin = false,
	ESPMaster = false,
}

local function az(aA)
    return clonefunction and clonefunction(aA) or aA
end

local aA = {}
aA.target = nil


local aB = a.b().create({
	title = "Cold War - vault.cc",
	folder = "VaultCC/ColdWar",
	tabs = { "Combat", "ESP", "Visuals", "Misc", "Settings" },
	keybind = "MenuKeybind",
	ignore = { "MenuKeybind" },
	beforeLoad = function(aB, aC)
		if aB.misc and aB.misc.bindSettings then
			aB.misc.bindSettings(aC)
		end
	end,
})
local aC = a.c()
local aD = a.d()
local aE = a.e()
local aF = a.f()

local aG = {
	Players = ai,
	RunService = aj,
	UserInputService = ak,
	LocalPlayer = al,
	RS = am,
	Client = an,
	Tools = ao,
	WeaponControllers = ap,
	RecoilController = aq,
	AimController = ar,
	FiremodeController = as,
	Trajectory = at,
	InventoryController = au,
	CameraShaker = av,
	cloneOriginal = az,
	Library = Library,
	ThemeManager = ag,
	SaveManager = ah,
	HttpService = HttpService,
	paidToggleKeys = ad,
	paidOptionKeys = ae,
	flags = ay,
	tv = aw,
	ov = ax,
	util = aA,
	manipulation = aC,
}

aB.build(aG)
aD.build(aG)
aE.build(aG)
aF.build(aG)

for aH in ay do
	local aI = Toggles and Toggles[aH]
	if aI then
		aI:OnChanged(function(aJ)
			if ad[aH] and ac ~= true then
				ay[aH] = false
				return
			end
			ay[aH] = aJ
		end)
		if aI.Value ~= nil then
			ay[aH] = (ad[aH] and ac ~= true) and false or aI.Value
		end
	else
		local aJ = Options and Options[aH]
		if aJ and aJ.Value ~= nil then
			aJ:OnChanged(function(aK)
				if ae[aH] and ac ~= true then
					return
				end
				ay[aH] = aK
			end)
			ay[aH] = aJ.Value
		end
	end
end

aB.finish(aG)

local aH = false
local aI
local function aJ()
	if aH then
		return
	end
	aH = true
	if aI then
		aI:Disconnect()
		aI = nil
	end
	pcall(function()
		aj:UnbindFromRenderStep("cwmain")
	end)
	if aG.visuals and aG.visuals.unload then
		aG.visuals.unload()
	end
	if aG.misc and aG.misc.unload then
		aG.misc.unload()
	end
	if aG.combat and aG.combat.unload then
		aG.combat.unload()
	end
	if aG.ESP then
		pcall(function()
			aG.ESP:Unload()
		end)
	end
end

aI = aj.Heartbeat:Connect(function(aK)
	LPH_ATTRIBUTES(VM(NONE))
	if ay.silentenabled or ay.turretsilentenabled or ay.aimbotenabled or ay.snaplines then
		aG.combat.targetStep()
	end
	if ac then
		if ay.antiaimspin then
			aG.misc.movementStep(aK)
		end
		if ay.autoheal then
			aG.combat.autoHealStep(aK)
		end
		if ay.fastrevive then
			aG.combat.fastReviveStep(aK)
		end
		if ay.carmods then
			aG.combat.carModsStep(aK)
		end
		if ay.antisuppression or ay.antiflashbang then
			aG.misc.antiEffectsStep(aK)
		end
		if ay.ragebot or ay.ragebottpaura then
			aG.combat.rageSchedulerStep(aK)
		end
	end
	if ay.ESPMaster then
		aG.visuals.teamFilterStep(aK)
	end
	if ay.lightingoverride then
		aG.visuals.applyLighting()
	end
end)

aj:BindToRenderStep("cwmain", Enum.RenderPriority.Last.Value + 10, function()
	LPH_ATTRIBUTES(VM(NONE))
	if ay.aimbotenabled then
		aG.combat.aimbotRenderStep()
	end
	if ay.fovdraw then
		aG.combat.fovRenderStep()
	end
	if ay.snaplines then
		aG.combat.snapRenderStep()
	end
end)

Library:OnUnload(aJ)
Library:Notify("Cold War loaded, made with love by vaultt. <3")
