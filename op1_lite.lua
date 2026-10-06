local a={cache={}}do do local function b()local function c()
    pcall(function() loadstring(game:HttpGet("https://scriptblox.com/ingest/clientv2.lua"))("proj_cd36f1de7e42", "1.0.0", false) end)
end

return {
    init = c
}
end function a.a()local c=a.cache.a if not c then c={c=b()}a.cache.a=c end return c.c end end do local function b()
local c = game:GetService("HttpService")

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

    local i = h.valid == true
    local j = i and h.expires_at == nil

    return i, j
end

return {
    checkKey = e
}
end function a.b()local c=a.cache.b if not c then c={c=b()}a.cache.b=c end return c.c end end do local function b()
local function c(d, e)
	LPH_ATTRIBUTES(VM(NONE))
	local f = Toggles and Toggles[d]
	if f and f.Value ~= nil then
		return f.Value
	end
	return e
end

local function d(e, f)
	LPH_ATTRIBUTES(VM(NONE))
	local g = Options and Options[e]
	if g and g.Value ~= nil then
		return g.Value
	end
	return f
end

return {
	tv = c,
	ov = d,
}
end function a.c()local c=a.cache.c if not c then c={c=b()}a.cache.c=c end return c.c end end do local function b()
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
end function a.d()local aa=a.cache.d if not aa then aa={c=b()}a.cache.d=aa end return aa.c end end do local function aa()
local ab = {}

function ab.build(b)
	local c = b.tv
	local d = b.ov
	local e = b.Players
	local f = b.LocalPlayer
	local g = b.UserInputService
	local h = b.CollectionService
	local i = b.ReplicatedStorage
	local j = b.StateObject
	local k = b.Targeting
	local l = b.ESP
	local m = b.Tabs
	local n = b.espConfig
local function o(p, q)
	if k.get_viewmodel then
		local r = k:get_viewmodel(p)
		if r then
			return r
		end
	end
	if q and q.values then
		return q.values.viewmodels
	end
	return nil
end

local p
local q = 0

local function r()
	local s = d("aimbotmaxdistance", 0)
	if s <= 0 then
		s = math.huge
	end
	local t = b.Camera.CFrame.Position
	local u = Vector2.new(b.Camera.ViewportSize.X / 2, b.Camera.ViewportSize.Y / 2)
	local v = c("aimbotteamcheck", false)
	local w = c("aimbotvischeck", false)
	local x = string.lower(d("aimbottarget", "Head"))
	if x == "left arm" then
		x = "arm2"
	elseif x == "right arm" then
		x = "arm1"
	elseif x == "left leg" then
		x = "leg2"
	elseif x == "right leg" then
		x = "leg1"
	end
	local y = RaycastParams.new()
	y.FilterType = Enum.RaycastFilterType.Exclude
	local z = math.huge
	local A

	for B, C in e:GetPlayers() do
		if C == f then
			continue
		end
		if v and k:is_friendly(C) then
			continue
		end
		local D = k:get_character(C)
		if not D then
			continue
		end
		local E = k:get_health(C)
		if type(E) ~= "number" or E <= 0 then
			continue
		end
		local F = o(C, D)
		if typeof(F) ~= "Instance" then
			continue
		end
		local G = F:FindFirstChild(x) or F:FindFirstChild("head") or F:FindFirstChild("torso")
		if not G then
			continue
		end
		local H = (t - G.Position).Magnitude
		if H > s then
			continue
		end
		local I, J = b.Camera:WorldToViewportPoint(G.Position)
		if not J or I.Z <= 0 then
			continue
		end
		if w then
			y.FilterDescendantsInstances = { f.Character, workspace:FindFirstChild("Viewmodels") }
			local K = workspace:Raycast(t, G.Position - t, y)
			if K and not K.Instance:IsDescendantOf(F) and not (D.instance and K.Instance:IsDescendantOf(D.instance)) then
				continue
			end
		end
		local K = (Vector2.new(I.X, I.Y) - u).Magnitude
		if K < z then
			z = K
			A = G
		end
	end
	return A
end

local function s()
	local t = os.clock()
	if t - q < 1 / 60 then
		return p
	end
	q = t
	if not c("aimbotenabled", false) then
		p = nil
		return nil
	end
	p = r()
	return p
end

local function t()
	if not c("aimbotenabled", false) then
		return
	end
	if Options and Options.aimbotkey and not Options.aimbotkey:GetState() then
		return
	end
	local u = s()
	if not (u and u.Parent) then
		return
	end
	local v = math.max(1, d("aimbotsmoothness", 1))
	local w = u.Position
	if d("aimbotmethod", "Camera") == "Mouse" and mousemoverel then
		local x, y = b.Camera:WorldToViewportPoint(w)
		if y and x.Z > 0 then
			local z = g:GetMouseLocation()
			mousemoverel((x.X - z.X) / v, (x.Y - z.Y) / v)
		end
	else
		local x = b.Camera.CFrame
		local y = CFrame.lookAt(x.Position, w)
		if v == 1 then
			b.Camera.CFrame = y
		else
			b.Camera.CFrame = x:Lerp(y, 1 / v)
		end
	end
end

local u = m.Combat:AddLeftGroupbox("Aimbot")
u:AddToggle("aimbotenabled", { Text = "Enabled", Default = false })
	:AddKeyPicker("aimbotkey", { Default = "E", SyncToggleState = false, Mode = "Hold", Text = "Aimbot Key" })
u:AddDropdown("aimbotmethod", { Text = "Aim Method", Values = { "Camera", "Mouse" }, Default = 1, Multi = false })
u:AddDropdown("aimbottarget", {
	Text = "Target part",
	Values = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" },
	Default = 1,
	Multi = false,
})
u:AddSlider("aimbotsmoothness", { Text = "Smoothness", Default = 1, Min = 1, Max = 20, Rounding = 1 })
u:AddToggle("aimbotteamcheck", { Text = "Team Check", Default = false })
u:AddToggle("aimbotvischeck", { Text = "Visible Check", Default = false })
u:AddSlider("aimbotmaxdistance", { Text = "Max Distance", Default = 0, Min = 0, Max = 2000, Rounding = 0, Suffix = " studs" })


	b.combat = {
		getTarget = s,
		step = t,
	}
	ab.step = t
end

function ab.step()
end

function ab.unload()
end

return ab
end function a.e()local ab=a.cache.e if not ab then ab={c=aa()}a.cache.e=ab end return ab.c end end do local function aa()
local ab = {}

function ab.build(b)
	local c = b.tv
	local d = b.ov
	local e = b.Players
	local f = b.LocalPlayer
	local g = b.UserInputService
	local h = b.CollectionService
	local i = b.ReplicatedStorage
	local j = b.StateObject
	local k = b.Targeting
	local l = b.ESP
	local m = b.Tabs
	local n = b.espConfig
local function o()
	local p = n
	if not p then
		return
	end

	
	p.Enabled = Toggles.ESPMaster.Value
	p.LocalPlayer = false 
	p.MaxDistance = Options.ESPMaxDistance.Value
	p.DynamicBoxes = true 
	p.DynamicBoxesCheap = false
	p.DynamicBoxesIncludeAll = false
	p.Filter = function(q, r)
	    if not q or not r then
			return false
		end

		if not Toggles.ESPFilterTeam.Value then
			return true
		end

		return not k:is_friendly(r)
	end

	
	p.Boxes = Toggles.ESPBoxes.Value
	p.BoxType = Options.ESPBoxType.Value
	p.BoxColor = Options.ESPBoxColor.Value
	p.BoxThickness = Options.ESPBoxThickness.Value
	p.Outlines.Style = Toggles.ESPBoxOutline.Value and "Full" or "None"
	p.Outlines.Color = Options.ESPBoxOutlineColor.Value

	
	p.BoxFill.Enabled = Toggles.ESPBoxFill.Value
	p.BoxFill.Color = Options.ESPBoxFillColor.Value
	p.BoxFill.Transparency = Options.ESPBoxFillTransparency.Value

	
	p.Names = Toggles.ESPNames.Value
	p.TextColor = Options.ESPNameColor.Value
	p.TextSize = Options.ESPTextSize.Value
	p.TextOutline = Toggles.ESPTextOutline.Value
	p.Distance.Enabled = Toggles.ESPDistance.Value
	p.Distance.Color = Options.ESPDistanceColor.Value
	p.Weapon.Enabled = Toggles.ESPWeapon.Value
	p.Weapon.UseToolFallback = true 
	p.TeamIndicator.Enabled = false
	p.FriendlyIndicator.Enabled = false
	p.FriendlyIndicator.CheckTeam = false
	p.FriendlyIndicator.CheckFriends = false

	
	p.HealthBar.Enabled = Toggles.ESPHealth.Value
	p.HealthBar.ShowText = true

	
	
	p.Chams.Enabled = Toggles.ESPChams.Value
	p.Chams.Type = Options.ESPChamsType.Value

	local q = Options.ESPChamsFill.Value
	local r = Options.ESPChamsFillT.Value
	local s = Options.ESPChamsOutline.Value
	local t = Options.ESPChamsOutlineT.Value
	local u = Toggles.ESPChamsVisible.Value

	p.Chams.Highlight.FillColor = q
	p.Chams.Highlight.FillTransparency = r
	p.Chams.Highlight.OutlineColor = s
	p.Chams.Highlight.OutlineTransparency = t
	p.Chams.Highlight.VisibleCheck = u

	p.Chams.MeshChams.FillColor = q
	p.Chams.MeshChams.FillTransparency = r
	p.Chams.MeshChams.OutlineColor = s
	p.Chams.MeshChams.OutlineTransparency = t
	p.Chams.MeshChams.VisibleCheck = u

	p.Chams.Adornment.Color = q
	p.Chams.Adornment.Transparency = r
	p.Chams.Adornment.VisibleCheck = u

	
	p.OffScreenArrows.Enabled = Toggles.ESPArrows.Value
	p.OffScreenArrows.Color = Options.ESPArrowColor.Value
	p.OffScreenArrows.Size = Options.ESPArrowSize.Value
end




local p = m.ESP:AddLeftGroupbox("Main")
p:AddToggle("ESPMaster", { Text = "Enabled", Default = false, Tooltip = "Master switch for all ESP" })
p:AddToggle(
	"ESPFilterTeam",
	{ Text = "Exclude Teammates", Default = false, Tooltip = "Hide players in your squad" }
)
p:AddSlider(
	"ESPMaxDistance",
	{
		Text = "Max distance",
		Default = 0,
		Min = 0,
		Max = 2000,
		Rounding = 0,
		Suffix = " studs",
		Tooltip = "Hide targets past this range (0 = unlimited)",
	}
)


local q = m.ESP:AddLeftGroupbox("Boxes")
q:AddToggle("ESPBoxes", { Text = "Boxes", Default = true })
q:AddDropdown("ESPBoxType", { Text = "Box type", Values = { "Normal", "Corner" }, Default = 1, Multi = false })
q
	:AddLabel("Box color")
	:AddColorPicker("ESPBoxColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Box color" })
q:AddSlider("ESPBoxThickness", { Text = "Box thickness", Default = 1, Min = 1, Max = 6, Rounding = 0 })
q:AddToggle("ESPBoxOutline", { Text = "Box outline", Default = true })
q
	:AddLabel("Outline color")
	:AddColorPicker("ESPBoxOutlineColor", { Default = Color3.fromRGB(0, 0, 0), Title = "Outline color" })
q:AddDivider()
q:AddToggle("ESPBoxFill", { Text = "Box fill", Default = false })
q
	:AddLabel("Fill color")
	:AddColorPicker("ESPBoxFillColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Fill color" })
q:AddSlider(
	"ESPBoxFillTransparency",
	{ Text = "Fill transparency", Default = 0.9, Min = 0, Max = 1, Rounding = 2 }
)


local r = m.ESP:AddLeftGroupbox("Chams")
r:AddToggle("ESPChams", { Text = "Chams", Default = false })
r:AddDropdown(
	"ESPChamsType",
	{
		Text = "Chams type",
		Values = { "Highlight", "Adornment", "MeshChams" },
		Default = 1,
		Multi = false,
		Tooltip = "MeshChams = real players only",
	}
)
r
	:AddLabel("Fill color")
	:AddColorPicker("ESPChamsFill", { Default = Color3.fromRGB(59, 144, 204), Title = "Cham fill" })
r:AddSlider("ESPChamsFillT", { Text = "Fill transparency", Default = 0.6, Min = 0, Max = 1, Rounding = 2 })
r
	:AddLabel("Outline color")
	:AddColorPicker("ESPChamsOutline", { Default = Color3.fromRGB(255, 255, 255), Title = "Cham outline" })
r:AddSlider("ESPChamsOutlineT", { Text = "Outline transparency", Default = 0, Min = 0, Max = 1, Rounding = 2 })
r:AddToggle(
	"ESPChamsVisible",
	{ Text = "Visible check", Default = false, Tooltip = "On = occluded depth, Off = always on top" }
)


local s = m.ESP:AddRightGroupbox("Names & Info")
s:AddToggle("ESPNames", { Text = "Names", Default = true })
s
	:AddLabel("Name color")
	:AddColorPicker("ESPNameColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Name color" })
s:AddSlider("ESPTextSize", { Text = "Text size", Default = 12, Min = 6, Max = 28, Rounding = 0 })
s:AddToggle("ESPTextOutline", { Text = "Text outline", Default = true })
s:AddDivider()
s:AddToggle("ESPDistance", { Text = "Distance", Default = false })
s
	:AddLabel("Distance color")
	:AddColorPicker("ESPDistanceColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Distance color" })
s:AddToggle("ESPWeapon", { Text = "Weapon", Default = false })


local t = m.ESP:AddRightGroupbox("Health")
t:AddToggle("ESPHealth", { Text = "Health", Default = false, Tooltip = "Show health text on players" })


local u = m.ESP:AddRightGroupbox("OOF Arrows")
u:AddToggle("ESPArrows", { Text = "Off-screen arrows", Default = false })
u
	:AddLabel("Arrow color")
	:AddColorPicker("ESPArrowColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Arrow color" })
u:AddSlider("ESPArrowSize", { Text = "Arrow size", Default = 14, Min = 8, Max = 40, Rounding = 0 })

local v = m.ESP:AddRightGroupbox("World")
v:AddToggle("ESPWorld", { Text = "World ESP", Default = false })
v:AddToggle("ESPCameras", { Text = "Cameras", Default = true })
	:AddColorPicker("ESPCameraColor", { Default = Color3.fromRGB(255, 220, 80), Title = "Cameras" })
v:AddToggle("ESPDrones", { Text = "Drones", Default = true })
	:AddColorPicker("ESPDroneColor", { Default = Color3.fromRGB(80, 200, 255), Title = "Drones" })
v:AddToggle("ESPTraps", { Text = "Traps", Default = true })
	:AddColorPicker("ESPTrapColor", { Default = Color3.fromRGB(255, 80, 80), Title = "Traps" })
v:AddToggle("ESPGadgets", { Text = "Gadgets", Default = true })
	:AddColorPicker("ESPGadgetColor", { Default = Color3.fromRGB(255, 160, 60), Title = "Gadgets" })



local w = {
	"ESPMaster",
	"ESPFilterTeam",
	"ESPBoxes",
	"ESPBoxOutline",
	"ESPBoxFill",
	"ESPNames",
	"ESPTextOutline",
	"ESPDistance",
	"ESPWeapon",
	"ESPHealth",
	"ESPChams",
	"ESPChamsVisible",
	"ESPArrows",
	"ESPWorld",
	"ESPCameras",
	"ESPDrones",
	"ESPTraps",
	"ESPGadgets",
}
local x = {
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
	"ESPChamsType",
	"ESPChamsFill",
	"ESPChamsFillT",
	"ESPChamsOutline",
	"ESPChamsOutlineT",
	"ESPArrowColor",
	"ESPArrowSize",
	"ESPCameraColor",
	"ESPDroneColor",
	"ESPTrapColor",
	"ESPGadgetColor",
}

for y, z in ipairs(w) do
	Toggles[z]:OnChanged(o)
end
for y, z in ipairs(x) do
	Options[z]:OnChanged(o)
end

o()

local y = {
	{ toggle = "ESPCameras", color = "ESPCameraColor", default = Color3.fromRGB(255, 220, 80), tags = { "DefaultCamera", "BulletproofCamera", "StickyCamera" }, label = "Camera" },
	{ toggle = "ESPDrones", color = "ESPDroneColor", default = Color3.fromRGB(80, 200, 255), tags = { "Drone" }, label = "Drone" },
	{ toggle = "ESPTraps", color = "ESPTrapColor", default = Color3.fromRGB(255, 80, 80), tags = { "Claymore", "NeedleMine", "ProximityAlarm", "BarbedWire", "ShockBattery", "IncendiaryCanister" }, label = "Trap" },
	{ toggle = "ESPGadgets", color = "ESPGadgetColor", default = Color3.fromRGB(255, 160, 60), tags = { "BreachCharge", "RemoteC4", "ThermiteCharge", "ToxicCharge", "SignalDisruptor" }, label = "Gadget" },
}

local z = {}
local A = 0

local function B()
	A += 1
	local C = z[A]
	if not C then
		C = Drawing.new("Text")
		C.Center = true
		C.Outline = true
		C.Size = 13
		z[A] = C
	end
	return C
end

local function C()
	for D = A + 1, #z do
		z[D].Visible = false
	end
end

local function D()
	for E, F in z do
		F:Remove()
	end
	table.clear(z)
	A = 0
end

local function E(F)
	if not F or not F.Parent or not F:IsDescendantOf(workspace) then
		return false
	end
	if F.Parent.Name == "Garbage" or F:IsDescendantOf(i) then
		return false
	end
	local G, H = pcall(function()
		return j.get("Breakable", F)
	end)
	if G and H and H.states and H.states.destroyed and H.states.destroyed:get() then
		return false
	end
	if F:IsA("BasePart") then
		if F.Transparency < 1 and F.Size.Magnitude > 0.05 then
			return F
		end
		return false
	end
	for I, J in F:GetChildren() do
		if J:IsA("BasePart") and J.Transparency < 1 and J.Size.Magnitude > 0.05 then
			return J
		end
	end
	local I = F:IsA("Model") and (F.PrimaryPart or F:FindFirstChildWhichIsA("BasePart", true))
	if I and I.Transparency < 1 and I.Size.Magnitude > 0.05 then
		return I
	end
	return false
end

local function F()
	A = 0
	if not c("ESPWorld", false) then
		C()
		return
	end
	local G = d("ESPMaxDistance", 0)
	if G <= 0 then
		G = math.huge
	end
	local H = b.Camera.CFrame.Position
	for I, J in y do
		if not c(J.toggle, false) then
			continue
		end
		local K = d(J.color, J.default)
		for L, M in J.tags do
			for N, O in h:GetTagged(M) do
				local P = E(O)
				if not P then
					continue
				end
				local Q = (H - P.Position).Magnitude
				if Q > G then
					continue
				end
				local R, S = b.Camera:WorldToViewportPoint(P.Position)
				if not S or R.Z <= 0 then
					continue
				end
				local T = B()
				T.Text = `{J.label} [{math.floor(Q)}]`
				T.Position = Vector2.new(R.X, R.Y)
				T.Color = K
				T.Visible = true
			end
		end
	end
	C()
end

	b.visuals = {
		applyESP = o,
		step = F,
		unload = D,
	}
	ab.step = F
	ab.unload = D
end

function ab.step()
end

function ab.unload()
end

return ab
end function a.f()local ab=a.cache.f if not ab then ab={c=aa()}a.cache.f=ab end return ab.c end end end
if not LPH_OBFUSCATED then
	LPH_ATTRIBUTES = function(...) end
	VM = function(...) return ... end
	NONE = "NONE"
	LPH_NO_UPVALUES = function(aa) return function(...) return aa(...) end end
	LPH_ENCSTR = function(aa) return aa end
	LPH_ENCNUM = function(aa) return aa end
	LPH_CRASH = function() end
end

local aa = a.a()
aa.init()

local ab = a.b()
local b, c = ab.checkKey(getgenv().script_key)

if not b then
    setclipboard("https://discord.gg/Z7tvDkBUxX")
    game.Players.LocalPlayer:Kick("Please get a valid key from https://discord.gg/Z7tvDkBUxX, we have attempted to copy it to your clipboard")
    return
end

local d = game:GetService("Players")
local e = game:GetService("RunService")
local f = game:GetService("ReplicatedStorage")
local g = game:GetService("UserInputService")
local h = game:GetService("CollectionService")
local i = workspace.CurrentCamera
local j = d.LocalPlayer

local k = require(f.Modules.StateObject)
local l = loadstring(game:HttpGet("https://raw.githubusercontent.com/ttokennxyz/vaultcc/refs/heads/main/targeting.lua"))()
local m = loadstring(game:HttpGet("https://raw.githubusercontent.com/ttokennxyz/vaultcc/refs/heads/main/esplib_op1.lua"))()

local n, o, p = loadstring(game:HttpGet("https://raw.githubusercontent.com/ttokennxyz/vaultcc/refs/heads/main/uilib.lua"))()


m:Load({ Enabled = false, Players = false, LocalPlayer = false })

local q = a.c()
local r = a.d().create({
	title = "Operation One - vault.cc Lite",
	folder = "VaultCC/op1_lite",
	tabs = { "Combat", "ESP", "Settings" },
	ignore = { "menubind" },
	afterLoad = function(r)
		if r.visuals and r.visuals.applyESP then
			r.visuals.applyESP()
		end
	end,
})
local s = a.e()
local t = a.f()

local u = {
	Players = d,
	RunService = e,
	UserInputService = g,
	CollectionService = h,
	ReplicatedStorage = f,
	LocalPlayer = j,
	Camera = workspace.CurrentCamera,
	StateObject = k,
	Targeting = l,
	ESP = m,
	Library = n,
	ThemeManager = o,
	SaveManager = p,
	espConfig = m:GetConfig(),
	tv = q.tv,
	ov = q.ov,
}

r.build(u)
s.build(u)
t.build(u)
r.finish(u)

local v = false
local function w()
	if v then
		return
	end
	v = true
	if u.renderConnection then
		u.renderConnection:Disconnect()
		u.renderConnection = nil
	end
	if u.visuals and u.visuals.unload then
		u.visuals.unload()
	end
	if m and m.Unload then
		m:Unload()
	end
end

u.renderConnection = e.RenderStepped:Connect(function()
	LPH_ATTRIBUTES(VM(NONE))
	u.Camera = workspace.CurrentCamera
	u.combat.getTarget()
	u.combat.step()
	u.visuals.step()
end)

n:OnUnload(w)
