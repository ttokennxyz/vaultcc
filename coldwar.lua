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
		local n = game:GetService("HttpService")
		local o
		local function p(q)
			return q == "VaultConfigCode" or q:find("SaveManager_") or q:find("ThemeManager_")
		end
		local function q(r)
			if r and r.Changed then
				pcall(r.Changed, r.Value)
			end
		end
		local function r(s, t)
			if not s then
				return false
			end
			local u = false
			if s.SetValue then
				u = pcall(function()
					s:SetValue(t)
				end)
			end
			if not u then
				s.Value = t
			end
			q(s)
			return true
		end
		local function s(t)
			local u = 0
			if type(t) ~= "table" then
				return 0
			end
			for v, w in t do
				if type(v) ~= "string" or p(v) then
					continue
				end
				local x = Toggles[v]
				if x and type(w) == "table" and w.boolean ~= nil then
					if r(x, w.boolean == true) then
						u += 1
					end
					continue
				end
				local y = Options[v]
				if not y then
					continue
				end
				if y.Type == "ColorPicker" and type(w) == "table" and type(w.color) == "string" then
					local z, A = pcall(Color3.fromHex, w.color)
					if z then
						if y.SetValueRGB then
							pcall(function()
								y:SetValueRGB(A, w.transparency)
							end)
						end
						y.Value = A
						q(y)
						u += 1
					end
				elseif y.Type == "KeyPicker" and type(w) == "table" then
					if r(y, { w.keycode or w.key or y.Value, y.Mode }) then
						u += 1
					end
				elseif y.Type == "Slider" then
					if r(y, tonumber(w) or w) then
						u += 1
					end
				elseif r(y, w) then
					u += 1
				end
			end
			return u
		end
		local function t(u)
			if type(u) ~= "table" or type(u.idx) ~= "string" or p(u.idx) then
				return false
			end
			local v = j.Parser and j.Parser[u.type]
			if v and v.Load then
				local w = pcall(function()
					v.Load(u.idx, u)
				end)
				if w then
					return true
				end
			end
			if u.type == "Toggle" then
				return r(Toggles[u.idx], u.value == true)
			end
			if u.type == "Slider" then
				return r(Options[u.idx], tonumber(u.value) or u.value)
			end
			if u.type == "Dropdown" then
				return r(Options[u.idx], u.value)
			end
			if u.type == "ColorPicker" then
				local w = Options[u.idx]
				local x, y = pcall(Color3.fromHex, u.value)
				if not x or not w then
					return false
				end
				if w.SetValueRGB then
					pcall(function()
						w:SetValueRGB(y, u.transparency)
					end)
				end
				w.Value = y
				q(w)
				return true
			end
			if u.type == "KeyPicker" then
				return r(Options[u.idx], { u.key, u.mode })
			end
			if u.type == "Input" then
				return r(Options[u.idx], u.text)
			end
			return false
		end
		local function u()
			local v = {}
			for w, x in Toggles do
				if not p(w) then
					v[#v + 1] = { type = "Toggle", idx = w, value = x.Value == true }
				end
			end
			for w, x in Options do
				if p(w) then
					continue
				end
				if x.Type == "Slider" then
					v[#v + 1] = { type = "Slider", idx = w, value = tostring(x.Value) }
				elseif x.Type == "Dropdown" then
					v[#v + 1] = { type = "Dropdown", idx = w, value = x.Value, mutli = x.Multi }
				elseif x.Type == "ColorPicker" then
					local y = x.Value
					v[#v + 1] = {
						type = "ColorPicker",
						idx = w,
						value = typeof(y) == "Color3" and y:ToHex() or tostring(y),
						transparency = x.Transparency,
					}
				elseif x.Type == "KeyPicker" then
					v[#v + 1] = { type = "KeyPicker", idx = w, mode = x.Mode, key = x.Value }
				elseif x.Type == "Input" then
					v[#v + 1] = { type = "Input", idx = w, text = tostring(x.Value or "") }
				end
			end
			return n:JSONEncode({ vault = 1, objects = v })
		end
		local function v(w)
			if type(w) ~= "string" then
				return false, "empty"
			end
			w = w:match("^%s*(.-)%s*$") or ""
			if w == "" then
				return false, "empty"
			end
			local x, y = pcall(function()
				return n:JSONDecode(w)
			end)
			if not x or type(y) ~= "table" then
				return false, "invalid json"
			end
			local z = 0
			if type(y.flagValues) == "table" then
				z = s(y.flagValues)
			end
			local A = y.objects or y
			if z == 0 and type(A) == "table" then
				for B, C in A do
					if t(C) then
						z += 1
					end
				end
			end
			if z == 0 then
				return false, "no settings in that code"
			end
			return true, z
		end
		local w = 0
		local function x()
			local y = os.clock()
			if y - w < 0.35 then
				return false
			end
			w = y
			return true
		end
		local function y()
			if not x() then
				return
			end
			local z = u()
			if o then
				o.Text = z
			end
			if Options.VaultConfigCode and Options.VaultConfigCode.SetValue then
				pcall(function()
					Options.VaultConfigCode:SetValue(z)
				end)
			end
			local A = false
			pcall(function()
				setclipboard(z)
				A = true
			end)
			h:Notify(A and "Config copied" or "Config ready, copy the box")
		end
		local function z(A)
			if not x() then
				return
			end
			if type(A) ~= "string" or A:match("^%s*(.-)%s*$") == "" then
				local B = ""
				pcall(function()
					B = getclipboard()
				end)
				if B == "" then
					pcall(function()
						B = clipboard()
					end)
				end
				A = B
			end
			local B, C = v(A)
			if not B then
				h:Notify("Import failed: " .. tostring(C))
				return
			end
			h:Notify("Imported " .. tostring(C) .. " settings")
		end
		local A = k:AddLeftGroupbox("Import / Export")
		A:AddInput("VaultConfigCode", {
			Text = "Config code",
			Placeholder = "Paste a config here",
			PlaceholderText = "Paste a config here",
		})
		A:AddButton({
			Text = "Export",
			Func = y,
		})
		A:AddButton({
			Text = "Import",
			Func = function()
				z(Options.VaultConfigCode and Options.VaultConfigCode.Value or "")
			end,
		})
		pcall(function()
			j:SetIgnoreIndexes({ "VaultConfigCode" })
		end)
		if h.IsMobile then
			local B = game:GetService("GuiService")
			local C = game:GetService("UserInputService")
			local D
			local E = {}
			local function F(G)
				local H = G
				while H and H ~= game do
					if H:IsA("GuiObject") and not H.Visible then
						return false
					end
					H = H.Parent
				end
				return G and G.Parent ~= nil
			end
			local function G(H)
				local I, J
				for K, L in E do
					if F(K) then
						local M, N = K.AbsolutePosition, K.AbsoluteSize
						if N.X > 0 and N.Y > 0 and H.X >= M.X and H.X <= M.X + N.X and H.Y >= M.Y and H.Y <= M.Y + N.Y then
							local O = M + N / 2
							local P = (Vector2.new(O.X, O.Y) - H).Magnitude
							if not J or P < J then
								I, J = L, P
							end
						end
					end
				end
				return I
			end
			local function H(I)
				if type(I) ~= "string" or I == "" or not isfolder("darius/VaultCC") then
					return nil
				end
				for J, K in listfiles("darius/VaultCC") do
					local L, M = pcall(function()
						return n:JSONDecode(readfile(K))
					end)
					if L and type(M) == "table" and M.name == I then
						return M
					end
				end
				return nil
			end
			local function I(J)
				local K = H(J)
				if not K then
					h:Notify("Config not found")
					return
				end
				local L = getgenv and getgenv().dariusInstance
				if L and K.uid and L.SetConfiguration then
					pcall(function()
						L:SetConfiguration(K.uid)
					end)
				end
				s(K.flagValues)
				h:Notify("Loaded " .. J)
			end
			local function J()
				local K = game:GetService("CoreGui")
				for L, M in K:GetDescendants() do
					if M:IsA("TextLabel") then
						local N = M.Text:match("^Configs:%s*(.+)$")
						if N and N ~= "" then
							return N
						end
					end
				end
				return nil
			end
			local function K()
				if not x() then
					return
				end
				local L = D or J()
				if not L or L == "" then
					h:Notify("Select a config first")
					return
				end
				I(L)
			end
			if not h._vaultCfgHook then
				h._vaultCfgHook = true
				local L
				C.InputBegan:Connect(function(M)
					local N = M.UserInputType
					if N == Enum.UserInputType.Touch or N == Enum.UserInputType.MouseButton1 then
						L = M.Position
					end
				end)
				C.InputEnded:Connect(function(M)
					local N = M.UserInputType
					if N ~= Enum.UserInputType.Touch and N ~= Enum.UserInputType.MouseButton1 then
						return
					end
					if not L or (M.Position - L).Magnitude > 18 then
						return
					end
					local O = Vector2.new(M.Position.X, M.Position.Y)
					local P = B:GetGuiInset()
					local Q = G(O) or G(O - P) or G(O + P)
					if Q then
						Q()
					end
				end)
			end
			local function L(M, N)
				if not M or E[M] then
					return
				end
				E[M] = N
			end
			local function M()
				local N = game:GetService("CoreGui")
				local O = UDim2.new(1, 0, 0, 36)
				local function P(Q)
					if Q:IsA("TextButton") and Q.Text ~= "" then
						return Q.Text
					end
					local R
					for S, T in Q:GetDescendants() do
						if T:IsA("TextLabel") then
							local U = T.Text
							if U == "Load" or U == "Save" or U == "Create" or U == "Delete" or U == "Export" or U == "Import" then
								R = U
							end
						end
					end
					return R
				end
				for Q, R in N:GetDescendants() do
					if R:IsA("TextLabel") and R.Text:sub(1, 7) == "Configs" then
						local S = R:FindFirstAncestorWhichIsA("TextButton")
						local T = S and S.Parent
						local U = T and T:FindFirstChildWhichIsA("ScrollingFrame")
						if U and not U:GetAttribute("vaultCfgWatch") then
							U:SetAttribute("vaultCfgWatch", true)
							local function V(W)
								if not W:IsA("TextButton") then
									return
								end
								L(W, function()
									D = W.Name
								end)
							end
							for W, X in U:GetChildren() do
								V(X)
							end
							U.ChildAdded:Connect(V)
						end
					end
				end
				for Q, R in N:GetDescendants() do
					if R:IsA("TextLabel") and R.Text == "Load" then
						local S = R:FindFirstAncestorWhichIsA("TextButton")
						local T = S and S.Parent
						if T and T:IsA("GuiObject") then
							local U = T:FindFirstChildOfClass("UIListLayout")
							if U then
								U.FillDirection = Enum.FillDirection.Vertical
								U.HorizontalAlignment = Enum.HorizontalAlignment.Center
								U.Padding = UDim.new(0, 4)
							end
							T.AutomaticSize = Enum.AutomaticSize.Y
							T.Size = UDim2.new(1, 0, 0, 0)
							if not T:GetAttribute("vaultSizePin") then
								T:SetAttribute("vaultSizePin", true)
								T:GetPropertyChangedSignal("Size"):Connect(function()
									if T.Parent and T.Size ~= UDim2.new(1, 0, 0, 0) then
										T.Size = UDim2.new(1, 0, 0, 0)
									end
								end)
								T:GetPropertyChangedSignal("AutomaticSize"):Connect(function()
									if T.Parent and T.AutomaticSize ~= Enum.AutomaticSize.Y then
										T.AutomaticSize = Enum.AutomaticSize.Y
									end
								end)
							end
							local V
							for W, X in T:GetChildren() do
								if X:IsA("GuiButton") then
									X.Size = O
									if P(X) == "Save" then
										V = X
									end
									if not X:GetAttribute("vaultPinned") then
										X:SetAttribute("vaultPinned", true)
										X:GetPropertyChangedSignal("Size"):Connect(function()
											if X.Parent and X.Size ~= O then
												X.Size = O
											end
										end)
									end
								end
							end
							L(S, K)
							if V and S and not S:GetAttribute("vaultLoadGuard") then
								S:SetAttribute("vaultLoadGuard", true)
								S.InputBegan:Connect(function(W)
									local X = W.UserInputType
									if X ~= Enum.UserInputType.Touch and X ~= Enum.UserInputType.MouseButton1 then
										return
									end
									V.Active = false
									task.delay(0.4, function()
										if V.Parent then
											V.Active = true
										end
									end)
								end)
							end
							if not T:GetAttribute("vaultShare") then
								T:SetAttribute("vaultShare", true)
								o = Instance.new("TextBox")
								o.Name = "VaultConfigCode"
								o.Size = UDim2.new(1, 0, 0, 72)
								o.BackgroundColor3 = S.BackgroundColor3
								o.TextColor3 = Color3.new(1, 1, 1)
								o.PlaceholderText = "Paste config code"
								o.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
								o.Text = ""
								o.ClearTextOnFocus = false
								o.TextWrapped = true
								o.MultiLine = true
								o.TextXAlignment = Enum.TextXAlignment.Left
								o.TextYAlignment = Enum.TextYAlignment.Top
								o.Font = Enum.Font.Gotham
								o.TextSize = 12
								o.Parent = T
								local W = Instance.new("UICorner")
								W.CornerRadius = UDim.new(0, 6)
								W.Parent = o
								local X = Instance.new("UIPadding")
								X.PaddingTop = UDim.new(0, 6)
								X.PaddingLeft = UDim.new(0, 8)
								X.PaddingRight = UDim.new(0, 8)
								X.Parent = o
								local function Y(Z, _)
									local aa = Instance.new("TextButton")
									aa.Name = Z
									aa.Size = O
									aa.BackgroundColor3 = S.BackgroundColor3
									aa.Text = Z
									aa.TextColor3 = Color3.new(1, 1, 1)
									aa.Font = Enum.Font.GothamBold
									aa.TextSize = 14
									aa.AutoButtonColor = true
									aa.Parent = T
									local ab = Instance.new("UICorner")
									ab.CornerRadius = UDim.new(0, 6)
									ab.Parent = aa
									aa.Activated:Connect(_)
									L(aa, _)
									return aa
								end
								Y("Export", y)
								Y("Import", function()
									z(o.Text)
								end)
							end
						end
						break
					end
				end
			end
			task.defer(M)
			task.delay(0.6, M)
			task.delay(1.5, M)
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
end function a.b()local aa=a.cache.b if not aa then aa={c=b()}a.cache.b=aa end return aa.c end end do local function aa()
local ab = debug.profilebegin or function() end
local b = debug.profileend or function() end

local function c(d, e, f)
	return function(...)
		ab(d)
		if f == 2 then
			local g, h = e(...)
			b()
			return g, h
		end
		local g = e(...)
		b()
		return g
	end
end

return {
	begin = ab,
	stop = b,
	wrap = c,
}
end function a.c()local ab=a.cache.c if not ab then ab={c=aa()}a.cache.c=ab end return ab.c end end do local function aa()
local ab = workspace.Raycast
local b = a.c()

local c = {
	Vector3.new(1, 0, 0),
	Vector3.new(-1, 0, 0),
	Vector3.new(0, 0, 1),
	Vector3.new(0, 0, -1),
	Vector3.new(0, 1, 0),
	Vector3.new(0, -1, 0),
}
local d = {
	Vector3.new(0.5, 0, 0),
	Vector3.new(-0.5, 0, 0),
	Vector3.new(0, 0, 0.5),
	Vector3.new(0, 0, -0.5),
	Vector3.new(0, 0.5, 0),
	Vector3.new(0, -0.5, 0),
}
local e = {
	Vector3.new(0.5, 0.5, 0),
	Vector3.new(0.5, -0.5, 0),
	Vector3.new(-0.5, 0.5, 0),
	Vector3.new(-0.5, -0.5, 0),
	Vector3.new(0, 0.5, 0.5),
	Vector3.new(0, -0.5, 0.5),
	Vector3.new(0, 0.5, -0.5),
	Vector3.new(0, -0.5, -0.5),
}

local function f(...)
	local g = {}
	for h = 1, select("#", ...) do
		local i = select(h, ...)
		for j = 1, #i do
			g[#g + 1] = i[j]
		end
	end
	return g
end

local g = {
	Low = c,
	Medium = f(d, c),
	High = f(d, e, c),
}

local h = RaycastParams.new()
h.FilterType = Enum.RaycastFilterType.Exclude
h.IgnoreWater = true

local function i(j, k, l, m, n, o, p)
	LPH_ATTRIBUTES(VM(NONE))
	if typeof(j) ~= "Vector3" or typeof(k) ~= "Vector3" then
		return nil
	end
	if n(j, k) then
		return j
	end
	l = tonumber(l) or 0
	if l <= 0 then
		return nil
	end
	p = tonumber(p)
	local q = g[m] or g.High
	h.FilterDescendantsInstances = o or {}
	for r = 1, #q do
		local s = q[r] * l
		if p and math.abs(s.Y) > p then
			s = Vector3.new(s.X, math.sign(s.Y) * p, s.Z)
		end
		local t = j + s
		if not ab(workspace, j, t - j, h) and n(t, k) then
			return t
		end
	end
	return nil
end

return {
	solve = b.wrap("manip.solve", i, 1),
}
end function a.d()local ab=a.cache.d if not ab then ab={c=aa()}a.cache.d=ab end return ab.c end end do local function aa()
local ab = {}

function ab.build(b)
	local c = b.flags
	local d = b.tv
	local e = b.ov
	local f = b.util
	local g = b.Players
	local h = b.RunService
	local i = b.UserInputService
	local j = b.LocalPlayer
	local k = b.RS
	local l = b.Library
	local m = b.Tabs
	local n = b.HttpService
	local o = b.manipulation
	local p = b.RecoilController
	local q = b.AimController
	local r = b.FiremodeController
	local s = b.Trajectory
	local t = b.InventoryController
	local u = b.CameraShaker
	local v = b.paidToggleKeys
	local w = b.paidOptionKeys
	local x = b.Client
	local y = b.Tools
	local z = b.WeaponControllers
	local A = b.cloneOriginal
local B
local C = false
local function D(E)
	LPH_ATTRIBUTES(VM(NONE))
	return type(E) == "table" and E.ExplosionSettings ~= nil
end
local function E(F, G)
	LPH_ATTRIBUTES(VM(NONE))
	return type(F) == "table" and (F.AmmoTypeName == "Rocket" or D(G))
end
local function F(G, H, I, J)
	LPH_ATTRIBUTES(VM(NONE))
	if not (c.rpgprediction and H and I and J) then
		return H.Position
	end
	local K = H.AssemblyLinearVelocity or Vector3.zero
	local L = J.MuzzleVelocity or I.MuzzleVelocity or 0
	if L <= 0 then
		return H.Position
	end

	local M = workspace.Gravity
	local N = H.Position
	local O = (N - G).Magnitude / L
	for P = 1, 3 do
		N = H.Position + K * O
		local Q = (N - G).Magnitude
		O = Q / L
	end

	local P = math.clamp(e("rpgpredictionstrength", 1), 0, 2)
	return N + Vector3.new(0, M * O * O * 0.5 * P, 0)
end

local function G(H)
	LPH_ATTRIBUTES(VM(NONE))
	if not H then
		return false
	end
	local I = H:FindFirstChild("CharacterValues")
	local J = I and I:FindFirstChild("Unconscious")
	return J ~= nil and J.Value == true
end

local H = 0

local function I(J)
	LPH_ATTRIBUTES(VM(NONE))
	if not J or not J.Parent then
		return false
	end
	local K = J.Parent:FindFirstChildOfClass("Humanoid")
	return K ~= nil and K.Health > 0
end

local J = nil
local K = 0
local L = RaycastParams.new()
L.FilterType = Enum.RaycastFilterType.Exclude
local M = {}
local N = nil
local O = 0

local function P()
	LPH_ATTRIBUTES(VM(NONE))
	local Q = os.clock()
	if Q - K < 0.05 then
		return J
	end
	K = Q

	local R = workspace.CurrentCamera
	if not R then
		J = nil
		return nil
	end

	local S = j
	local T = S.Character
	local U = S.Team
	local V = R.CFrame.Position
	local W = i:GetMouseLocation()
	local X, Y
	local Z = c.silenttarget
	local _ = c.silentteamcheck
	local ac = c.silentdistancecheck
	local ad = c.silentmaxdistance
	local ae = c.fovenabled
	local af = c.fovsize
	local ag = c.silentvisiblecheck

	table.clear(M)
	if T then
		M[1] = T
	end
	local ah = workspace:FindFirstChild("Ignore")
	if ah then
		M[#M + 1] = ah
	end
	if ag then
		L.FilterDescendantsInstances = M
	end

	for ai, aj in g:GetPlayers() do
		local ak = aj.Character
		if aj ~= S and ak and not G(ak) then
			if not (_ and U and aj.Team == U) then
				local al = ak:FindFirstChild(Z)
				local am = ak:FindFirstChildOfClass("Humanoid")
				if al and am and am.Health > 0 then
					local an = al.Position
					local ao = (an - V).Magnitude
					if (not ac) or ao <= ad then
						local ap, aq = R:WorldToViewportPoint(an)
						if aq and ap.Z > 0 then
							local ar = (Vector2.new(ap.X, ap.Y) - W).Magnitude
							if ((not ae) or ar <= af) and (not Y or ar < Y) then
								local as = true
								if ag then
									local at = workspace:Raycast(V, an - V, L)
									if at and not at.Instance:IsDescendantOf(ak) then
										as = false
									end
								end
								if as then
									X, Y = al, ar
								end
							end
						end
					end
				end
			end
		end
	end
	J = X
	return X
end

f.getTarget = function()
	LPH_ATTRIBUTES(VM(NONE))
	if I(J) then
		return J
	end
	K = 0
	return P()
end

local function ac()
	LPH_ATTRIBUTES(VM(NONE))
	local ad = os.clock()
	if ad == O then
		return N
	end
	O = ad
	local ae = t.getEquipped()
	if typeof(ae) == "Instance" and ae:IsA("Tool") and ae:GetAttribute("ToolType") == "Weapon" then
		N = ae
		return ae
	end
	local af = j.Character
	local ag = af and af:FindFirstChildOfClass("Tool")
	if ag and ag:GetAttribute("ToolType") == "Weapon" then
		N = ag
		return ag
	end
	N = nil
	return nil
end

f.getMuzzle = function()
	LPH_ATTRIBUTES(VM(NONE))
	local ad = ac()
	if not ad then
		return nil
	end
	local ae = j.Character
	local af = ae and ae:FindFirstChild(ad.Name .. "Model")
	local ag = (af and af:FindFirstChild("Handle")) or ad:FindFirstChild("Handle")
	return ag and ag:FindFirstChild("Muzzle1")
end

local function ad()
	LPH_ATTRIBUTES(VM(NONE))
	if not (c.silentenabled or c.turretsilentenabled or c.aimbotenabled or c.snaplines) then
		f.target = nil
		return
	end
	f.target = P()
end

local function ae()
	LPH_ATTRIBUTES(VM(NONE))
	if not c.aimbotenabled then
		return
	end
	local af = false
	if Options and Options.aimbotkey then
		af = Options.aimbotkey:GetState()
	end
	if not af then
		return
	end

	local ag = f.getTarget()
	if not (ag and ag.Parent) then
		return
	end

	local ah = workspace.CurrentCamera
	if not ah then
		return
	end

	local ai = ag.Position
	local aj = math.max(1, e("aimbotsmoothness", 1))

	if e("aimbotmethod", "Camera") == "Mouse" and mousemoverel then
		local ak, al = ah:WorldToViewportPoint(ai)
		if al and ak.Z > 0 then
			local am = i:GetMouseLocation()
			local an = (ak.X - am.X) / aj
			local ao = (ak.Y - am.Y) / aj
			mousemoverel(an, ao)
		end
	else

		local ak = ah.CFrame
		local al = CFrame.new(ak.Position, ai)
		if aj == 1 then
			ah.CFrame = al
		else
			ah.CFrame = ak:Lerp(al, 1 / aj)
		end
	end
end

local af = (function()
local af = require(y.Weapon.Muzzle.Discharge)
local ag = require(z.WeaponViewmodel)
local ah = require(k.Shared.Ballistics.ProjectileCaster)
local ai = require(k.Shared.WeaponConfigManager)
local aj = require(x.Character.stance.MovementTuning)
local ak = require(x.BodyReplication)
local al = require(x.BodyReplication.BodyRotation)
local am = require(k.Shared.Vehicle.TurretFireController)
local an = require(x.Tools.Bandage)
local ao
pcall(function()
	ao = require(j.PlayerScripts.BallisticsClient.FlybySuppression)
end)

local ap = debug.getupvalues
local aq = debug.getconstants
local ar = debug.getinfo
local as = debug.getprotos or getprotos

local function at(Q)
	return type(Q) == "function" and (not islclosure or islclosure(Q))
end

local function Q(R)
	local S, T = pcall(ap, R)
	return S and T or {}
end

local function R(S, T)
	local U, V = pcall(aq, S)
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
	for V, W in Q(T) do
		if at(W) and U(W, V) then
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
		if at(X) and V(X, W) then
			return X, W
		end
	end
end

local function U(V, W, X)
	if type(V) == "table" and at(V[W]) then
		return V[W], W
	end
	return T(V, X)
end

local function V(W, X, Y, Z)
	if not at(W) or Y < 0 then
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
	for _, au in Q(W) do
		if at(au) then
			local av = V(au, X, Y - 1, Z)
			if av then
				return av
			end
		elseif type(au) == "table" then
			for av, aw in au do
				if at(aw) then
					local ax = V(aw, X, Y - 1, Z)
					if ax then
						return ax
					end
				end
			end
		end
	end
	if as then
		local au, av = pcall(as, W)
		if au then
			for aw, ax in av do
				if at(ax) then
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

local av = U(p, "recoilScale", function(av)
	local aw = Q(av)
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
au.getRecoilMult = { func = av, upv = av and Q(av) or {} }

local aw = U(af, "fire", function(aw)
	return R(aw, "IsPreparation") and R(aw, "config")
end)
au.fire = { func = aw, upv = aw and Q(aw) or {} }
au.spreadVector = {
	func = aw and S(aw, function(ax)
		local W = ar(ax)
		return W.nups == 0 and W.numparams == 2
	end),
}

local ax
if ao and at(ao.new) then
	for W, X in Q(ao.new) do
		if type(X) == "table" and at(X.fire) then
			ax = X.fire
			break
		end
	end
end
au.flybyFire = { func = ax }

local W = U(q, "flip", function(W)
	return ar(W).numparams == 0 and ar(W).nups >= 1
end)
local X = U(q, "canAim", function(X)
	return R(X, "Stance") and R(X, "Walk")
end)
au.aimtoggle = { func = W, upv = W and Q(W) or {} }
au.isaimingavailable = { func = X, upv = X and Q(X) or {} }
au.aimupdate = {
	func = S(q.attach, function(Y)
		local Z = Q(Y)
		return typeof(Z[1]) == "Instance" and type(Z[2]) == "number" and type(Z[3]) == "number"
	end),
}
au.aimupdate.upv = au.aimupdate.func and Q(au.aimupdate.func) or {}

local Y = U(r, "pull", function(Y)
	return R(Y, "isFiring") or ar(Y).numparams == 1
end)
local Z
if at(r.new) then
	for _, ay in Q(r.new) do
		if type(ay) == "table" and ay.Automatic then
			Z = ay
			break
		end
	end
end
au.firemodestart = { func = Y, upv = Z }

local ay
if at(t.equip) then
	ay = S(t.equip, function(_)
		return R(_, "EquipTool")
	end)
end
au.awaitLength = {
	func = ay and S(ay, function(_)
		return R(_, "Length") and R(_, "isConscious")
	end),
}

au.movementupdate = {
	func = U(aj, "apply", function(_)
		return R(_, "inertialSpeed") and R(_, "sprintHeld")
	end),
}

local _ = S(an.new, function(_)
	return R(_, "HealLimb")
end)
au.healLimb = { func = _, upv = _ and Q(_) or {} }

au.muzzlesConfig = {
	func = U(ai, "MuzzleConfigsOf", function(az)
		return ar(az).numparams == 2
	end),
}

local az = S(ah.Fire, function(az)
	return R(az, "Alive") and R(az, "OnFinish")
end)
au.onArcEnd = {
	func = az and S(az, function(aA)
		return R(aA, "Segments")
	end),
}

local aA = S(am.Attach, function(aA)
	return R(aA, "muzzleConfig") and R(aA, "WorldCFrame")
end)
au.fireOnce = { func = aA, upv = aA and Q(aA) or {} }

au.sendOwnInfo = {
	func = S(ak.flushNow, function(aB)
		return R(aB, "NewCameraAngle")
	end),
}

au.bodyRotationUpdate = {
	func = U(al, "UpdateCharacter", function(aB)
		return R(aB, "HumanoidRootPart") and R(aB, "LastUpdate")
	end),
}
au.bodyWallPush = {
	func = au.bodyRotationUpdate.func and S(au.bodyRotationUpdate.func, function(aB)
		return ar(aB).numparams >= 4
	end),
}

au.viewmodelWallPush = {
	func = V(ag.attach, function(aB)
		return R(aB, "viewmodelAttachment") and R(aB, "raise")
	end, 4),
}

local function aB(aC)
	if not at(aC) then
		return false
	end
	local aD = ar(aC)
	if not aD or (aD.numparams or 0) < 5 then
		return false
	end
	if R(aC, "proj") and R(aC, "seed") and not R(aC, "GetServerTimeNow") then
		return false
	end
	local aE = 0
	if R(aC, "GetServerTimeNow") then
		aE += 1
	end
	if R(aC, "encodeFire") then
		aE += 1
	end
	if R(aC, "Direction") and R(aC, "Seed") then
		aE += 1
	end
	if R(aC, "Unit") then
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
	if at(aE) then
		local aF, aG = pcall(aq, aE)
		if aF then
			for aH, aI in aG do
				if type(aI) == "string" then
					local aJ = aD[aI]
					if at(aJ) and aJ ~= aE and aB(aJ) then
						return aJ
					end
				end
			end
		end
		for aH, aI in Q(aE) do
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
		local aE = j:FindFirstChild("PlayerScripts")
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

local function ag(ah, ai, aj, ak)
	local al = ah.Transparency
	local am = 1 - al
	local an = aj / ak
	local ao = am / an

	task.wait(ai - aj)
	for ap = 1, an do
		task.wait(ak)
		ah.Transparency += ao
	end
	ah.Transparency = 1
	ah:Destroy()
end

local function ah(ai, aj, ak, al, am)
	local an = (aj - ai).Magnitude
	if an <= 0.001 then
		return
	end
	local ao = (ai + aj) / 2

	local ap = e("localtracersmaterial", "Plastic")
	if al then
		ap = e("teamtracersmaterial", "Plastic")
	elseif am then
		ap = e("enemytracersmaterial", "Plastic")
	end

	local aq = e("localtracerscolor", Color3.fromRGB(59, 255, 50))
	if al then
		aq = e("teamtracerscolor", Color3.fromRGB(59, 144, 204))
	elseif am then
		aq = e("enemytracerscolor", Color3.fromRGB(255, 60, 60))
	end

	local ar = e("localtracerstransparency", 0.5)
	if al then
		ar = e("teamtracerstransparency", 0.5)
	elseif am then
		ar = e("enemytracerstransparency", 0.5)
	end

	local as = e("bullettracersize", 0.1)

	local at = Instance.new("Part")
	at.Name = "tracer"
	at.Anchored = true
	at.CanCollide = false
	at.CanQuery = false
	at.CanTouch = false
	at.Material = Enum.Material[ap]
	at.Color = aq
	at.Size = Vector3.new(as, as, an)
	at.CFrame = CFrame.new(ao, aj)
	at.Parent = workspace:FindFirstChild("Ignore") or workspace
	at.Transparency = ar

	task.spawn(ag, at, 3, 1, 0.05)

	return at
end

local ai = setmetatable({}, { __mode = "k" })
local aj = { origin = nil, at = 0 }
local ak
local al
local am

local function an(ao, ap)
	if ap and ao and (ap - ao).Magnitude > 0.05 then
		aj.origin = ap
		aj.at = os.clock()
	end
end
if af.onArcEnd.func then
	local ao = A(af.onArcEnd.func)
	af.onArcEnd.func = hookfunction(af.onArcEnd.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		local ap = { ... }
		local aq = ap[1]
		local ar = table.pack(ao(...))
		if not aq or aq.Alive or ai[aq] then
			return table.unpack(ar, 1, ar.n)
		end

		ai[aq] = true
		local as = aq.Owner
		local at = as == j
		local au = as ~= nil and not at and as.Team ~= nil and as.Team == j.Team
		local av = as ~= nil and not at and not au
		local aw = d("tracersenabled", false)
			and (
				(at and d("localtracers", false))
				or (av and d("enemytracers", false))
				or (au and d("teamtracers", false))
			)
		if aw then
			local ax = at and aj.origin and os.clock() - aj.at < 0.25 and aj.origin
			local ay = aq.Segments or {}
			for az, aA in ipairs(ay) do
				if typeof(aA.From) == "Vector3" and typeof(aA.To) == "Vector3" then
					local aB = aA.From
					if az == 1 and ax and (aB - ax).Magnitude > 0.15 then
						aB = ax
					end
					task.spawn(ah, aB, aA.To, at, au, av)
				end
			end
		end
		return table.unpack(ar, 1, ar.n)
	end)
end

if af.flybyFire.func then
	local ao = A(af.flybyFire.func)
	hookfunction(af.flybyFire.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		if c.antisuppression then
			return
		end
		return ao(...)
	end)
end

local ao = u.Shake
local ap = A(ao)
u.Shake = function(...)
	LPH_ATTRIBUTES(VM(NONE))
	if c.antisuppression then
		return
	end
	return ap(...)
end

if af.spreadVector.func then
	hookfunction(af.spreadVector.func, function(aq, ar)
		LPH_ATTRIBUTES(VM(NONE))
		local as = e("spreadmult", 0)
		if as == 0 then return aq.Unit end
		local at = math.atan((ar or 1) / 3570) * as
		local au = Vector3.new(math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1)
		return (aq.Unit + au * at).Unit
	end)
end

local function aq()
	LPH_ATTRIBUTES(VM(NONE))
	local ar, as, at = unpack(af.getRecoilMult.upv)
	local au = as:getCharacterValues()
	if au then
		au = au:FindFirstChild("Stance")
	end
	return (ar[au and au.Value or "Walk"] or 1) * (1 - (at.getAlpha() or 0) * 0.25) * e("recoilmult", 0)
end

if af.getRecoilMult.func then
	for ar, as in p do
		if as == af.getRecoilMult.func then
			p[ar] = aq
			break
		end
	end
	pcall(hookfunction, af.getRecoilMult.func, aq)
end

if af.sendOwnInfo.func then
	local ar = A(af.sendOwnInfo.func)
	hookfunction(af.sendOwnInfo.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		if c.antiaimpitch then
			local as = debug.getupvalue(ar, 1)
			if as then
				as.NewCameraAngle = math.rad(e("antiaimpitchangle", 90))
			end
		end
		return ar(...)
	end)
end

if af.bodyWallPush.func then
	local ar = A(af.bodyWallPush.func)
	hookfunction(af.bodyWallPush.func, function(as, ...)
		LPH_ATTRIBUTES(VM(NONE))
		if c.gunup and as and as.IsOwnCharacter then
			as.WallPush = as.WallPush or { push = 0, raise = 0 }
			as.WallPush.push = 0
			as.WallPush.raise = math.rad(89)
			return 0, math.rad(89)
		end
		return ar(as, ...)
	end)
end

if af.viewmodelWallPush.func then
	local ar = A(af.viewmodelWallPush.func)
	hookfunction(af.viewmodelWallPush.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		if c.gunup then
			debug.setupvalue(ar, 2, 0)
			debug.setupvalue(ar, 3, math.rad(89))
			return
		end
		return ar(...)
	end)
end

if af.bodyRotationUpdate.func then
	local ar = A(af.bodyRotationUpdate.func)
	hookfunction(af.bodyRotationUpdate.func, function(as, at)
		LPH_ATTRIBUTES(VM(NONE))
		if not c.antiaimpitch and not c.gunup then
			return ar(as, at)
		end
		if as ~= j.Character or not at then
			return ar(as, at)
		end

		if c.antiaimpitch then
			local au = math.rad(e("antiaimpitchangle", 90))
			at.NewCameraAngle = au
			at.CurrentCameraAngle = au
		end

		local au = at.StanceValue
		local av
		if c.gunup and au then
			av = au.Value
			au.Value = "Walk"
		end
		local aw = table.pack(ar(as, at))
		if av ~= nil and au.Parent then
			au.Value = av
		end
		return table.unpack(aw, 1, aw.n)
	end)
end

local function ar(as)
	local at = {}
	for au, av in as or {} do
		local aw = typeof(av)
		if aw == "RaycastParams" then
			at.raycastParams = av
		elseif aw == "function" then
			at.spreadVector = av
		elseif aw == "Instance" then
			if av:IsA("Camera") then
				at.camera = av
			elseif av:IsA("Player") then
				at.player = av
			elseif av:IsA("ReplicatedStorage") then
				at.replicatedStorage = av
			end
		elseif aw == "table" then
			if type(av.IsPreparation) == "function" then
				at.matchPhase = av
			elseif type(av.getCharacter) == "function" then
				at.wielder = av
			elseif type(av.isShown) == "function" then
				at.viewmodel = av
			elseif type(av.zeroAngle) == "function" then
				at.zeroController = av
			elseif type(av.MuzzleFlash) == "function" then
				at.weaponEffects = av
			elseif type(av.Play) == "function" then
				at.soundManager = av
			elseif type(av.flushNow) == "function" then
				at.bodyReplication = av
			elseif af.volleyFrom(av) then
				at.clientFire = av
			end
		end
	end
	return at
end

if af.fire.func then
	local as = A(af.fire.func)
	local at = ar(af.fire.upv)
	local au = at.bodyReplication
	if type(au) ~= "table" then
		local av, aw = pcall(require, x.BodyReplication)
		if av and type(aw) == "table" then
			au = aw
		end
	end
	hookfunction(af.fire.func, function(av, aw)
		LPH_ATTRIBUTES(VM(NONE))
		local ax = at.matchPhase
		local ay = at.wielder
		local az = at.camera
		local aA = at.raycastParams
		local aB = at.player
		local aC = at.zeroController
		local aD = at.spreadVector
		local aE = at.soundManager
		local aF = at.weaponEffects
		local aG = at.clientFire
		local aH = at.viewmodel
		if not (ax and ay and az and aC and aD and aE and aF) then
			return as(av, aw)
		end
		local aI = af.volleyFrom(aG) or af.fireVolleyFn

		if ax.IsPreparation() then
			return
		end
		local aJ = av.config
		local Q = ay:getCharacter()
		local R = Q and Q:FindFirstChild("Right Arm")
		local S = (az.CFrame.Position - az.Focus.Position).Magnitude <= 0.75
		local T = not aH or aH.isShown()
		local U = (S and T and av.viewmodelAttachment) or av.attachment
		local V = U.WorldPosition
		local W = U.WorldCFrame.LookVector
		if R and typeof(aA) == "RaycastParams" and typeof(aB) == "Instance" then
			local X = (V - R.CFrame.Position).Magnitude
			aA.FilterDescendantsInstances = { aB.Character, workspace.Ignore }
			local Y = workspace:Raycast(V - W * X, W * X, aA)
			if Y then
				V = Y.Position - W * math.min(0.01, Y.Distance)
			end
		end

		local X = aC.zeroAngle() or math.rad(aJ.DefaultAngle or 0)
		local Y = (U.WorldCFrame * CFrame.Angles(X, 0, 0)).LookVector
		local Z = aJ.BulletSettings[aw]
		local _ = V
		local aK = al
		if not aK and c.silentenabled then
			local aL = f.getTarget()
			if aL then
				aK = E(aJ, Z)
						and F(V, aL, aJ, Z)
					or aL.Position
				if c.manipulation and ak then
					local aM = {}
					if aB and aB.Character then
						aM[1] = aB.Character
					end
					local aN = workspace:FindFirstChild("Ignore")
					if aN then
						aM[#aM + 1] = aN
					end
					local aO = ak(V, aK, aL.Parent, Z and Z.Penetration, aM)
					if aO then
						V = aO
					end
				end
			end
		elseif am then
			V = am
		end
		if aK then
			local aL = aK - V
			if aL.Magnitude > 0.001 then
				Y = aL.Unit
			end
		end
		an(_, V)

		av.animator:play("GunShoot")
		H = H + 1
		local aL = Z.ShotAmount or 1
		local aM = table.create(aL)
		for aN = 1, aL do
			aM[aN] = aD(Y, Z.Spread or 1)
		end

		local aN = av.tool.Sounds:FindFirstChild("Muzzle" .. av.index)
		aN = aN and aN:FindFirstChild("Fire")
		if aN then
			aE.Play(aN, U.WorldPosition, aJ.SoundRange or 3000)
		end
		aF.MuzzleFlash(U, av.tool.Name)
		C = D(Z)
		if au and type(au.flushNow) == "function" then
			au.flushNow()
		end
		if aI then
			aI(av.tool, av.index, aw, V, aM)
		end
		C = false
		if not av:isHandAction() then
			aF.Casing(U, av.tool.Name)
		end
	end)
end

if af.fireOnce.func then
	local as = A(af.fireOnce.func)
	hookfunction(af.fireOnce.func, function()
		LPH_ATTRIBUTES(VM(NONE))
		local at, au, av, aw, ax, ay =
			unpack(debug.getupvalues(as))
		if not (at and at.muzzle and at.muzzle.Parent) then
			return
		end
		local az = af.volleyFrom(ax) or af.fireVolleyFn

		local aA = at.muzzleConfig
		local aB = at.muzzle
		local aC = aB.WorldCFrame
		local aD = aC.Position
		local aE = (aC * CFrame.Angles(math.rad(aA.DefaultAngle or 0), 0, 0)).LookVector
		local aF = aA.BulletSettings and aA.BulletSettings[1] or {}
		if c.turretsilentenabled then
			local aG = f.getTarget()
			if aG then
				local aH = E(aA, aF)
						and F(aD, aG, aA, aF)
					or aG.Position
				local aI = aH - aD
				if aI.Magnitude > 0.001 then
					aE = aI.Unit
				end
			end
		end

		local aG = aF.ShotAmount or 1
		local aH = table.create(aG)
		for aI = 1, aG do
			aH[aI] = au(aE, aF.Spread or 1)
		end
		if at.loopSound then
			av.Play(at.loopSound, aD, aA.SoundRange or 3000)
			if at.burstTracker then
				at.burstTracker.onShot(aD)
			end
		elseif at.fireSound then
			av.Play(at.fireSound, aD, aA.SoundRange or 3000)
		end
		aw.MuzzleFlash(aB, at.weaponName)
		aw.Casing(aB, at.weaponName)
		C = D(aF)
		if az then
			az(at.weaponName, 1, 1, aD, aH)
		end
		C = false
		ay.ApplyRecoil()
	end)
end
if af.aimtoggle.func then
local as = A(af.aimtoggle.func)
af.aimtoggle.func = hookfunction(af.aimtoggle.func, function(...)
	LPH_ATTRIBUTES(VM(NONE))
	local at = as
	if not c.aimanywhere then
		return at(...)
	end
	local au = debug.getupvalue(at, 1)
	debug.setupvalue(at, 1, (au == 0) and 1 or 0)
end)
end

if af.aimupdate.func then
local as = A(af.aimupdate.func)
af.aimupdate.func = hookfunction(af.aimupdate.func, function(at)
	LPH_ATTRIBUTES(VM(NONE))
	local au = as
	local av = c.instantads
	local aw = c.aimanywhere
	local ax = c.noadsslowdown
	if not (av or aw or ax) then
		return au(at)
	end

	local ay = debug.getupvalue(au, 3) == 1
	if av then
		debug.setupvalue(au, 2, ay and 1 or 0)
	end

	au(at)

	if aw and ay then
		debug.setupvalue(au, 3, 1)
		if av then
			debug.setupvalue(au, 2, 1)
		end
	end

	if ax then
		local az = debug.getupvalue(au, 1)
		if typeof(az) == "Instance" then
			az.Value = 1
		end
	end
end)
end

if af.isaimingavailable.func then
local as = A(af.isaimingavailable.func)
af.isaimingavailable.func = hookfunction(af.isaimingavailable.func, function(...)
	LPH_ATTRIBUTES(VM(NONE))
	if c.aimanywhere then
		return true
	end
	return as(...)
end)
end

if af.firemodestart.func then
local as = A(af.firemodestart.func)
af.firemodestart.func = hookfunction(af.firemodestart.func, function(at)
	LPH_ATTRIBUTES(VM(NONE))
	local au = af.firemodestart.upv

	if not at.isFiring then
		at.isFiring = true
		local av = at:_current()
		if av then
			local aw = av.strategy
			if c.forceauto then
				local ax = au and au.Automatic
				if ax and ax.strategy then
					aw = ax.strategy
				end
			end
			if aw then
				task.spawn(aw.fire, at)
			end
		end
	end
end)
end

if af.awaitLength.func then
	local as = A(af.awaitLength.func)
	af.awaitLength.func = hookfunction(af.awaitLength.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		if c.instantequip then
			return false
		end
		return as(...)
	end)
end

local function as(at)
	local function au(av)
		local aw = at:FindFirstChild(av)
		local ax = aw and aw:FindFirstChild("Health")
		if ax then
			local ay = ax:GetAttribute("MaxHealth")
			if ay and ay > 0 then
				return ax.Value / ay
			end
		end
		return nil
	end
	local av, aw = au("Left Leg"), au("Right Leg")
	if av and aw then
		return 0.5 + (av + aw) / 4
	end
	return nil
end

if af.movementupdate.func then
	local at = A(af.movementupdate.func)
	af.movementupdate.func = hookfunction(af.movementupdate.func, function(au)
		LPH_ATTRIBUTES(VM(NONE))
		if not c.omnisprint and not c.nohurtslowdown then
			return at(au)
		end

		if c.omnisprint and au then
			au.firstPerson = false
		end

		at(au)

		if c.nohurtslowdown and au and au.humanoid and au.character then
			local av = as(au.character)
			if av and av > 0 and av < 1 then
				au.humanoid.WalkSpeed = au.humanoid.WalkSpeed / av
				if type(au.inertialSpeed) == "number" then
					au.inertialSpeed = au.inertialSpeed / av
				end
			end
		end
	end)
end

local at = s.new
s.new = function(au)
	LPH_ATTRIBUTES(VM(NONE))
	if not C then
		if c.nodrop then
			au.Gravity = 0
		end
		if c.instantbullet then
			au.MuzzleSpeed = 1e6
			au.K = 0
		end
	end
	return at(au)
end

local au = k:WaitForChild("Remotes")

local av = 0
local function aw()
	LPH_ATTRIBUTES(VM(NONE))
	local function ax(ay)
		if not ay then
			return nil
		end
		for az, aA in ay:GetChildren() do
			if aA:IsA("Tool") and aA:GetAttribute("ToolType") == "Bandage" then
				local aB = aA:FindFirstChild("Bandages")
				if not aB then
					return aA
				end
				for aC, aD in aB:GetChildren() do
					if aD:IsA("IntValue") and aD.Value > 0 then
						return aA
					end
				end
			end
		end
		return nil
	end
	return ax(j.Character) or ax(j:FindFirstChild("Backpack"))
end
local function ax(ay)
	LPH_ATTRIBUTES(VM(NONE))
	if not c.autoheal then
		return
	end
	av = av + ay
	if not c.instantheal and av < 0.75 then
		return
	end
	av = 0

	local az = au:FindFirstChild("Bandage")
	local aA = aw()
	local aB = j.Character
	if not (az and aA and aB) then
		return
	end
	local aC = e("autohealmindamage", 30)
	for aD, aE in aB:GetChildren() do
		if aE:IsA("BasePart") and aE.Name ~= "HumanoidRootPart" then
			local aF = aE:FindFirstChild("Health")
			if aF then
				local aG = aF:GetAttribute("MaxHealth")
				if aG and aG > 0 and (aG - aF.Value) / aG * 100 >= aC then
					az:FireServer(aA, "HealLimb", aE)
				end
			end
		end
	end
end

local ay = 0
local function az(aA)
	LPH_ATTRIBUTES(VM(NONE))
	if not c.fastrevive then
		return
	end
	ay = ay + aA
	if ay < 1 then
		return
	end
	ay = 0

	local aB = workspace:FindFirstChild("Characters")
	if not aB then
		return
	end
	local aC = aB:QueryDescendants("#RevivePrompt")
	for aD, aE in aC do
		if aE:IsA("ProximityPrompt") then
			aE.HoldDuration = 3
		end
	end
end

local aA = {
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
local aB = { AutoShift = true, Ackermann = true }
local aC = {
	ChassisType = "Wheeled",
	DriveType = "AWD",
	Differential = "Locked",
}
local aD = {}
local aE = {}
local aF = {}
local aG = "{}"
local aH = {}
local aI = false
local aJ = ""
local function aK(aL)
	local aM = aL.Name or aL.DisplayName or aL.VehicleName or aL.Id or "Unknown Car"
	local aN = aL.Team or aL.Faction or aL.Side or "PACT"
	aN = tostring(aN):upper():find("NATO") and "NATO" or "PACT"
	return tostring(aM) .. " (" .. aN .. ")"
end
local function aL(aM)
	local aN
	local aO = aM.Parent
	while aO and aO ~= k do
		local Q = aO.Name:upper()
		if Q == "PACT" or Q == "NATO" then
			aN = Q
			break
		end
		aO = aO.Parent
	end
	if not aN then
		return nil
	end
	return aM.Name .. " (" .. aN .. ")"
end
local function aM(aN)
	local aO = {}
	if type(aN) == "table" then
		for Q, R in pairs(aN) do
			if type(R) ~= "table" then
				aO[Q] = R
			end
		end
		if type(aN.Ratios) == "table" then
			aO.Ratios = {}
			for Q, R in pairs(aN.Ratios) do
				aO.Ratios[Q] = R
			end
		end
		if type(aN.Wheels) == "table" then
			aO.Wheels = {}
			for Q, R in ipairs(aN.Wheels) do
				aO.Wheels[Q] = {}
				for S, T in pairs(R) do
					aO.Wheels[Q][S] = T
				end
			end
		end
	end
	for Q, R in pairs(aA) do
		aO[Q] = aN and aN[Q] ~= nil and aN[Q] or R
	end
	for Q, R in pairs(aB) do
		aO[Q] = aN and aN[Q] ~= nil and aN[Q] or R
	end
	for Q, R in pairs(aC) do
		aO[Q] = aN and aN[Q] ~= nil and aN[Q] or R
	end
	return aO
end
local function aN()
	aG = n:JSONEncode(aD)
	if Options.carsprofiles and Options.carsprofiles.Value ~= aG and not aI then
		aI = true
		Options.carsprofiles:SetValue(aG)
		aI = false
	end
end
local function aO(Q)
	if aI then
		return
	end
	if type(Q) ~= "string" or Q == "" then
		return
	end
	local R, S = pcall(n.JSONDecode, n, Q)
	if R and type(S) == "table" then
		for T, U in pairs(S) do
			if type(U) == "table" then
				aD[T] = aM(U)
			end
		end
	end
end
local function Q(R, S)
	if not R or type(S) ~= "table" or type(S.Transmission) ~= "table" then
		return
	end
	if aH[S] then
		return
	end
	aH[S] = true
	aF[R] = S
	aE[#aE + 1] = R
	if aD[R] == nil then
		aD[R] = aM(S.Transmission)
	end
end
local function R()
	local S = k:FindFirstChild("Shared") and k.Shared:FindFirstChild("VehicleConfigManager")
	if S then
		for T, U in ipairs(S:GetDescendants()) do
			if U:IsA("ModuleScript") then
				local V = aL(U)
				if V then
					local W, X = pcall(require, U)
					if W and type(X) == "table" and rawget(X, "Transmission") then
						for Y, Z in pairs(X.Transmission) do
							if type(Z) == "number" and aA[Y] == nil then
								aA[Y] = Z
							elseif type(Z) == "boolean" and aB[Y] == nil then
								aB[Y] = Z
							elseif type(Z) == "string" and aC[Y] == nil then
								aC[Y] = Z
							end
						end
						Q(V, X)
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
					local W = aK(V)
					for X, Y in pairs(U.Transmission) do
						if type(Y) == "number" and aA[X] == nil then
							aA[X] = Y
						elseif type(Y) == "boolean" and aB[X] == nil then
							aB[X] = Y
						elseif type(Y) == "string" and aC[X] == nil then
							aC[X] = Y
						end
					end
					Q(W, U)
				end
			end
		end
	end
	table.sort(aE)
	local T = table.concat(aE, "\0")
	if Options.carprofile and T ~= aJ then
		aJ = T
		Options.carprofile:SetValues(aE)
	end
end
R()
local S = { selected = aE[1] }
local function T()
	if not c.carmods then
		return
	end
	for U, V in pairs(aF) do
		local W = aD[U]
		if W then
			local X = V.Transmission
			for Y in pairs(aA) do
				if X[Y] ~= W[Y] then
					X[Y] = W[Y]
				end
			end
			for Y in pairs(aB) do
				if X[Y] ~= W[Y] then
					X[Y] = W[Y]
				end
			end
			for Y in pairs(aC) do
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
	aD[S.selected] = aD[S.selected] or aM()
	return aD[S.selected]
end
local function U(V, W)
	local X = aP()
	if not X then
		return
	end
	X[V] = W
	aN()
	T()
end
local V = 0
local function W(X)
	LPH_ATTRIBUTES(VM(NONE))
	if not c.carmods then
		return
	end
	V = V + X
	if V < 5 then
		return
	end
	V = 0
	R()
	T()
end

local function X(Y)
	local Z = ar(Y)
	if Z.clientFire then
		return Z.clientFire
	end
	for _, aQ in pairs(Y or {}) do
		if af.volleyFrom(aQ) then
			return aQ
		end
	end
end
local aQ = X(af.fire.upv)
local Y = au:WaitForChild("Weapon")

B = af.muzzlesConfig.func and debug.getupvalue(af.muzzlesConfig.func, 1)
local Z = select(
	2,
	pcall(function()
		return require(k:WaitForChild("Shared"):WaitForChild("Ballistics"):WaitForChild("ProjectileMaterials"))
	end)
)
if type(Z) ~= "table" then
	Z = nil
end

local function _(aR, aS)
	LPH_ATTRIBUTES(VM(NONE))
	local aT = B and B[aR.Name]
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
	if not c.ragebotwallbang then
		return false
	end
	return aU(aW, aX, aY, aZ, a_)
end

ak = function(aW, aX, aY, aZ, a_)
	LPH_ATTRIBUTES(VM(NONE))
	if not c.manipulation or not aW or not aX then
		return aW
	end
	local a0 = o.solve(aW, aX, c.manipulationdistance or 1, c.manipulationdepth or "Low", function(a0, a1)
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
local a2 = require(x.BodyReplication)

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
	local bb = j.Character
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
	local a6 = j.Character
	local a7 = af.volleyFrom(aQ) or af.fireVolleyFn
	if not (a6 and a7) then
		return
	end
	local a8 = ac()
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
		H = 0
		a_ = 0
	end

	if os.clock() < a_ then
		return
	end

	if bg > 0 and H >= bg then
		if c.ragebotautoreload then
			aW(bd, bc)
			a_ = os.clock() + bh
			H = 0
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

	local bm = j
	local bn = {}
	for bo, bp in ipairs(g:GetPlayers()) do
		if bp ~= bm and bp.Character and not G(bp.Character) then
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
	if c.manipulation and ak then
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
				local bv = ak(bb, bu.Position, bt, bj, bk)
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

	if bq and bp and af.fire.func then
		aZ = os.clock() + 60 / bf
		local br = bq.Position
		if E(be, bi) then
			br = F(bp, bq, be, bi)
		end
		am = bp
		al = br
		local bs = pcall(af.fire.func, ba, bc)
		am = nil
		al = nil
		if not bs then
			aZ = 0
		end
	end
end

local a6 = 0
local function a7()
	LPH_ATTRIBUTES(VM(NONE))
	if not c.ragebottpaura then
		return
	end
	if os.clock() - a6 < 2.0 then
		return
	end

	local a8 = j
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

	for bi, bj in ipairs(g:GetPlayers()) do
		if bj ~= a8 and bj.Character and not G(bj.Character) then
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
	if not (c.ragebot or c.ragebottpaura) then
		return
	end
	a8 = a8 + ba
	if a8 < 0.03 then
		return
	end
	a8 = 0
	if c.ragebot then
		pcall(a5)
	end
	if c.ragebottpaura then
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
	l:Notify("Failed to load ESP library.")
end
	b.ESP = bc

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
	be.HealthBar.Part = e("silenttarget", "Head")

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

	local bg = j

	if Toggles.ESPFilterTeam.Value then
		bf.Players = false
		local bh = {}
		for bi, bj in ipairs(g:GetPlayers()) do
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

local bf = m.Combat:AddRightGroupbox("Gun Mods")
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

local bg = m.Combat:AddLeftGroupbox("Aiming")
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

local bh = m.Combat:AddLeftGroupbox("Silent Aim")
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

    local bi = m.Combat:AddRightGroupbox("Ragebot")
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
	if not c.fovdraw then
		bj.Visible = false
		return
	end

	local bn = i:GetMouseLocation()
	local bo = e("fovsize", 100)
	bj.Size = UDim2.fromOffset(bo * 2, bo * 2)
	bj.Position = UDim2.fromOffset(bn.X, bn.Y)
	bl.Thickness = e("fovthickness", 1)
	bl.Color = e("fovcolor", Color3.new(1, 1, 1))
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
	local bq = f.target
	if c.snaplines and bq and bq.Parent then
		local br = workspace.CurrentCamera
		if br then
			local bs, bt = br:WorldToViewportPoint(bq.Position)
			if bt and bs.Z > 0 then
				local bu = i:GetMouseLocation()
				local bv = Vector2.new(bs.X, bs.Y)
				local bw = bv - bu
				bo.Size = UDim2.fromOffset(bw.Magnitude, 1)
				bo.Position = UDim2.fromOffset((bu.X + bv.X) / 2, (bu.Y + bv.Y) / 2)
				bo.Rotation = math.deg(math.atan2(bw.Y, bw.X))
				bo.BackgroundColor3 = e("snaptargetcolor", Color3.fromRGB(255, 0, 0))
				bo.Visible = true
				return
			end
		end
	end
	bo.Visible = false
end


	b.functions = af
	b.espCfg = ba
	b.applyESP = bd
	b.refreshTeamFilter = be
	b.cars = {
		entries = aE,
		defaults = aA,
		boolDefaults = aB,
		choiceDefaults = aC,
		state = S,
		apply = T,
		profile = aP,
		setControl = U,
		syncJson = aN,
		loadJson = aO,
	}

	b.combat = {
		targetStep = ad,
		aimbotRenderStep = ae,
		fovRenderStep = bm,
		snapRenderStep = bp,
		rageSchedulerStep = a9,
		autoHealStep = ax,
		fastReviveStep = az,
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
end function a.f()local ab=a.cache.f if not ab then ab={c=aa()}a.cache.f=ab end return ab.c end end do local function aa()
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
end function a.g()local ab=a.cache.g if not ab then ab={c=aa()}a.cache.g=ab end return ab.c end end end

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
la_is_premium = true

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
	if ad[ax] and la_is_premium ~= true then return false end
	local az = Toggles and Toggles[ax]
	if az and az.Value ~= nil then
		return az.Value
	end
	return ay
end

local function ax(ay, az)
	LPH_ATTRIBUTES(VM(NONE))
	if ae[ay] and la_is_premium ~= true then return az end
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
local aC = a.d()
local aD = a.e()
local aE = a.f()
local aF = a.g()

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
			if ad[aH] and la_is_premium ~= true then
				ay[aH] = false
				return
			end
			ay[aH] = aJ
		end)
		if aI.Value ~= nil then
			ay[aH] = (ad[aH] and la_is_premium ~= true) and false or aI.Value
		end
	else
		local aJ = Options and Options[aH]
		if aJ and aJ.Value ~= nil then
			aJ:OnChanged(function(aK)
				if ae[aH] and la_is_premium ~= true then
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
	if la_is_premium then
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
