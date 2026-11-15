local a={cache={}}do do local function b()

local c, d

local function e(f, g)
	c = f
	d = g
end

local function f(g, h)
	LPH_ATTRIBUTES(VM(NONE))
	local i = c or Toggles
	local j = i and i[g]
	if j then
		local k = j.Value
		if k ~= nil then
			return k
		end
	end
	return h
end

local function g(h, i)
	LPH_ATTRIBUTES(VM(NONE))
	local j = d or Options
	local k = j and j[h]
	if k then
		local l = k.Value
		if l ~= nil then
			return l
		end
	end
	return i
end

local function h(i)
	local j = d or Options
	return j and j[i]
end

return {
	bind = e,
	tv = f,
	ov = g,
	option = h,
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
		local g = getgenv().Toggles
		local h = getgenv().Options
		local i = f.Tabs
		local j = f.Library
		local k = f.ThemeManager
		local l = f.SaveManager
		local m = i.Settings or i["UI Settings"]
		if not m then
			return
		end
		local n = d.keybind or "menubind"
		local o = m:AddLeftGroupbox("Menu")
		o:AddButton({
			Text = "Unload",
			Func = function()
				j:Unload()
			end,
		})
		o:AddLabel("Menu keybind"):AddKeyPicker(n, {
			Default = d.keybindDefault or "RightShift",
			NoUI = true,
			Text = "Menu keybind",
		})
		j.ToggleKeybind = h[n]
		if not d.hideKeybindList then
			o
				:AddToggle("ShowKeybindList", { Text = "Show Keybind List", Default = true })
				:OnChanged(function(p)
					if j and j.KeybindFrame then
						j.KeybindFrame.Visible = p
					end
				end)
		end
		k:SetLibrary(j)
		l:SetLibrary(j)
		if l.Parser and l.Parser.Slider then
			local p = l.Parser.Slider.Load
			l.Parser.Slider.Load = function(q, r)
				if h[q] then
					h[q]:SetValue(tonumber(r.value) or r.value)
				elseif p then
					p(q, r)
				end
			end
		end
		l:IgnoreThemeSettings()
		l:SetIgnoreIndexes(d.ignore or { n })
		k:SetFolder("VaultCC")
		l:SetFolder(d.folder)
		l:BuildConfigSection(m)
		local p = game:GetService("HttpService")
		local q
		local function r(s)
			return s == "VaultConfigCode" or s:find("SaveManager_") or s:find("ThemeManager_")
		end
		local function s(t)
			if t and t.Changed then
				pcall(t.Changed, t.Value)
			end
		end
		local function t(u, v)
			if not u then
				return false
			end
			local w = false
			if u.SetValue then
				w = pcall(function()
					u:SetValue(v)
				end)
			end
			if not w then
				u.Value = v
			end
			s(u)
			return true
		end
		local function u(v)
			local w = 0
			if type(v) ~= "table" then
				return 0
			end
			for x, y in v do
				if type(x) ~= "string" or r(x) then
					continue
				end
				local z = g[x]
				if z and type(y) == "table" and y.boolean ~= nil then
					if t(z, y.boolean == true) then
						w += 1
					end
					continue
				end
				local A = h[x]
				if not A then
					continue
				end
				if A.Type == "ColorPicker" and type(y) == "table" and type(y.color) == "string" then
					local B, C = pcall(Color3.fromHex, y.color)
					if B then
						if A.SetValueRGB then
							pcall(function()
								A:SetValueRGB(C, y.transparency)
							end)
						end
						A.Value = C
						s(A)
						w += 1
					end
				elseif A.Type == "KeyPicker" and type(y) == "table" then
					if t(A, { y.keycode or y.key or A.Value, A.Mode }) then
						w += 1
					end
				elseif A.Type == "Slider" then
					if t(A, tonumber(y) or y) then
						w += 1
					end
				elseif t(A, y) then
					w += 1
				end
			end
			return w
		end
		local function v(w)
			if type(w) ~= "table" or type(w.idx) ~= "string" or r(w.idx) then
				return false
			end
			local x = l.Parser and l.Parser[w.type]
			if x and x.Load then
				local y = pcall(function()
					x.Load(w.idx, w)
				end)
				if y then
					return true
				end
			end
			if w.type == "Toggle" then
				return t(g[w.idx], w.value == true)
			end
			if w.type == "Slider" then
				return t(h[w.idx], tonumber(w.value) or w.value)
			end
			if w.type == "Dropdown" then
				return t(h[w.idx], w.value)
			end
			if w.type == "ColorPicker" then
				local y = h[w.idx]
				local z, A = pcall(Color3.fromHex, w.value)
				if not z or not y then
					return false
				end
				if y.SetValueRGB then
					pcall(function()
						y:SetValueRGB(A, w.transparency)
					end)
				end
				y.Value = A
				s(y)
				return true
			end
			if w.type == "KeyPicker" then
				return t(h[w.idx], { w.key, w.mode })
			end
			if w.type == "Input" then
				return t(h[w.idx], w.text)
			end
			return false
		end
		local function w()
			local x = {}
			for y, z in g do
				if not r(y) then
					x[#x + 1] = { type = "Toggle", idx = y, value = z.Value == true }
				end
			end
			for y, z in h do
				if r(y) then
					continue
				end
				if z.Type == "Slider" then
					x[#x + 1] = { type = "Slider", idx = y, value = tostring(z.Value) }
				elseif z.Type == "Dropdown" then
					x[#x + 1] = { type = "Dropdown", idx = y, value = z.Value, mutli = z.Multi }
				elseif z.Type == "ColorPicker" then
					local A = z.Value
					x[#x + 1] = {
						type = "ColorPicker",
						idx = y,
						value = typeof(A) == "Color3" and A:ToHex() or tostring(A),
						transparency = z.Transparency,
					}
				elseif z.Type == "KeyPicker" then
					x[#x + 1] = { type = "KeyPicker", idx = y, mode = z.Mode, key = z.Value }
				elseif z.Type == "Input" then
					x[#x + 1] = { type = "Input", idx = y, text = tostring(z.Value or "") }
				end
			end
			return p:JSONEncode({ vault = 1, objects = x })
		end
		local function x(y)
			if type(y) ~= "string" then
				return false, "empty"
			end
			y = y:match("^%s*(.-)%s*$") or ""
			if y == "" then
				return false, "empty"
			end
			local z, A = pcall(function()
				return p:JSONDecode(y)
			end)
			if not z or type(A) ~= "table" then
				return false, "invalid json"
			end
			local B = 0
			if type(A.flagValues) == "table" then
				B = u(A.flagValues)
			end
			local C = A.objects or A
			if B == 0 and type(C) == "table" then
				for D, E in C do
					if v(E) then
						B += 1
					end
				end
			end
			if B == 0 then
				return false, "no settings in that code"
			end
			return true, B
		end
		local y = 0
		local function z()
			local A = os.clock()
			if A - y < 0.35 then
				return false
			end
			y = A
			return true
		end
		local function A()
			if not z() then
				return
			end
			local B = w()
			if q then
				q.Text = B
			end
			if h.VaultConfigCode and h.VaultConfigCode.SetValue then
				pcall(function()
					h.VaultConfigCode:SetValue(B)
				end)
			end
			local C = false
			pcall(function()
				setclipboard(B)
				C = true
			end)
			j:Notify(C and "Config copied" or "Config ready, copy the box")
		end
		local function B(C)
			if not z() then
				return
			end
			if type(C) ~= "string" or C:match("^%s*(.-)%s*$") == "" then
				local D = ""
				pcall(function()
					D = getclipboard()
				end)
				if D == "" then
					pcall(function()
						D = clipboard()
					end)
				end
				C = D
			end
			local D, E = x(C)
			if not D then
				j:Notify("Import failed: " .. tostring(E))
				return
			end
			j:Notify("Imported " .. tostring(E) .. " settings")
		end
		local C = m:AddLeftGroupbox("Import / Export")
		C:AddInput("VaultConfigCode", {
			Text = "Config code",
			Placeholder = "Paste a config here",
			PlaceholderText = "Paste a config here",
		})
		C:AddButton({
			Text = "Export",
			Func = A,
		})
		C:AddButton({
			Text = "Import",
			Func = function()
				B(h.VaultConfigCode and h.VaultConfigCode.Value or "")
			end,
		})
		pcall(function()
			l:SetIgnoreIndexes({ "VaultConfigCode" })
		end)
		if j.IsMobile then
			local D = game:GetService("GuiService")
			local E = game:GetService("UserInputService")
			local F
			local G = {}
			local function H(I)
				local J = I
				while J and J ~= game do
					if J:IsA("GuiObject") and not J.Visible then
						return false
					end
					J = J.Parent
				end
				return I and I.Parent ~= nil
			end
			local function I(J)
				local K, L
				for M, N in G do
					if H(M) then
						local O, P = M.AbsolutePosition, M.AbsoluteSize
						if P.X > 0 and P.Y > 0 and J.X >= O.X and J.X <= O.X + P.X and J.Y >= O.Y and J.Y <= O.Y + P.Y then
							local Q = O + P / 2
							local R = (Vector2.new(Q.X, Q.Y) - J).Magnitude
							if not L or R < L then
								K, L = N, R
							end
						end
					end
				end
				return K
			end
			local function J(K)
				if type(K) ~= "string" or K == "" or not isfolder("darius/VaultCC") then
					return nil
				end
				for L, M in listfiles("darius/VaultCC") do
					local N, O = pcall(function()
						return p:JSONDecode(readfile(M))
					end)
					if N and type(O) == "table" and O.name == K then
						return O
					end
				end
				return nil
			end
			local function K(L)
				local M = J(L)
				if not M then
					j:Notify("Config not found")
					return
				end
				local N = getgenv and getgenv().dariusInstance
				if N and M.uid and N.SetConfiguration then
					pcall(function()
						N:SetConfiguration(M.uid)
					end)
				end
				u(M.flagValues)
				j:Notify("Loaded " .. L)
			end
			local function L()
				local M = game:GetService("CoreGui")
				for N, O in M:GetDescendants() do
					if O:IsA("TextLabel") then
						local P = O.Text:match("^Configs:%s*(.+)$")
						if P and P ~= "" then
							return P
						end
					end
				end
				return nil
			end
			local function M()
				if not z() then
					return
				end
				local N = F or L()
				if not N or N == "" then
					j:Notify("Select a config first")
					return
				end
				K(N)
			end
			if not j._vaultCfgHook then
				j._vaultCfgHook = true
				local N
				E.InputBegan:Connect(function(O)
					local P = O.UserInputType
					if P == Enum.UserInputType.Touch or P == Enum.UserInputType.MouseButton1 then
						N = O.Position
					end
				end)
				E.InputEnded:Connect(function(O)
					local P = O.UserInputType
					if P ~= Enum.UserInputType.Touch and P ~= Enum.UserInputType.MouseButton1 then
						return
					end
					if not N or (O.Position - N).Magnitude > 18 then
						return
					end
					local Q = Vector2.new(O.Position.X, O.Position.Y)
					local R = D:GetGuiInset()
					local S = I(Q) or I(Q - R) or I(Q + R)
					if S then
						S()
					end
				end)
			end
			local function N(O, P)
				if not O or G[O] then
					return
				end
				G[O] = P
			end
			local function O()
				local P = game:GetService("CoreGui")
				local Q = UDim2.new(1, 0, 0, 36)
				local function R(S)
					if S:IsA("TextButton") and S.Text ~= "" then
						return S.Text
					end
					local T
					for U, V in S:GetDescendants() do
						if V:IsA("TextLabel") then
							local W = V.Text
							if W == "Load" or W == "Save" or W == "Create" or W == "Delete" or W == "Export" or W == "Import" then
								T = W
							end
						end
					end
					return T
				end
				for S, T in P:GetDescendants() do
					if T:IsA("TextLabel") and T.Text:sub(1, 7) == "Configs" then
						local U = T:FindFirstAncestorWhichIsA("TextButton")
						local V = U and U.Parent
						local W = V and V:FindFirstChildWhichIsA("ScrollingFrame")
						if W and not W:GetAttribute("vaultCfgWatch") then
							W:SetAttribute("vaultCfgWatch", true)
							local function X(Y)
								if not Y:IsA("TextButton") then
									return
								end
								N(Y, function()
									F = Y.Name
								end)
							end
							for Y, Z in W:GetChildren() do
								X(Z)
							end
							W.ChildAdded:Connect(X)
						end
					end
				end
				for S, T in P:GetDescendants() do
					if T:IsA("TextLabel") and T.Text == "Load" then
						local U = T:FindFirstAncestorWhichIsA("TextButton")
						local V = U and U.Parent
						if V and V:IsA("GuiObject") then
							local W = V:FindFirstChildOfClass("UIListLayout")
							if W then
								W.FillDirection = Enum.FillDirection.Vertical
								W.HorizontalAlignment = Enum.HorizontalAlignment.Center
								W.Padding = UDim.new(0, 4)
							end
							V.AutomaticSize = Enum.AutomaticSize.Y
							V.Size = UDim2.new(1, 0, 0, 0)
							if not V:GetAttribute("vaultSizePin") then
								V:SetAttribute("vaultSizePin", true)
								V:GetPropertyChangedSignal("Size"):Connect(function()
									if V.Parent and V.Size ~= UDim2.new(1, 0, 0, 0) then
										V.Size = UDim2.new(1, 0, 0, 0)
									end
								end)
								V:GetPropertyChangedSignal("AutomaticSize"):Connect(function()
									if V.Parent and V.AutomaticSize ~= Enum.AutomaticSize.Y then
										V.AutomaticSize = Enum.AutomaticSize.Y
									end
								end)
							end
							local X
							for Y, Z in V:GetChildren() do
								if Z:IsA("GuiButton") then
									Z.Size = Q
									if R(Z) == "Save" then
										X = Z
									end
									if not Z:GetAttribute("vaultPinned") then
										Z:SetAttribute("vaultPinned", true)
										Z:GetPropertyChangedSignal("Size"):Connect(function()
											if Z.Parent and Z.Size ~= Q then
												Z.Size = Q
											end
										end)
									end
								end
							end
							N(U, M)
							if X and U and not U:GetAttribute("vaultLoadGuard") then
								U:SetAttribute("vaultLoadGuard", true)
								U.InputBegan:Connect(function(Y)
									local Z = Y.UserInputType
									if Z ~= Enum.UserInputType.Touch and Z ~= Enum.UserInputType.MouseButton1 then
										return
									end
									X.Active = false
									task.delay(0.4, function()
										if X.Parent then
											X.Active = true
										end
									end)
								end)
							end
							if not V:GetAttribute("vaultShare") then
								V:SetAttribute("vaultShare", true)
								q = Instance.new("TextBox")
								q.Name = "VaultConfigCode"
								q.Size = UDim2.new(1, 0, 0, 72)
								q.BackgroundColor3 = U.BackgroundColor3
								q.TextColor3 = Color3.new(1, 1, 1)
								q.PlaceholderText = "Paste config code"
								q.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
								q.Text = ""
								q.ClearTextOnFocus = false
								q.TextWrapped = true
								q.MultiLine = true
								q.TextXAlignment = Enum.TextXAlignment.Left
								q.TextYAlignment = Enum.TextYAlignment.Top
								q.Font = Enum.Font.Gotham
								q.TextSize = 12
								q.Parent = V
								local Y = Instance.new("UICorner")
								Y.CornerRadius = UDim.new(0, 6)
								Y.Parent = q
								local Z = Instance.new("UIPadding")
								Z.PaddingTop = UDim.new(0, 6)
								Z.PaddingLeft = UDim.new(0, 8)
								Z.PaddingRight = UDim.new(0, 8)
								Z.Parent = q
								local function _(aa, ab)
									local ac = Instance.new("TextButton")
									ac.Name = aa
									ac.Size = Q
									ac.BackgroundColor3 = U.BackgroundColor3
									ac.Text = aa
									ac.TextColor3 = Color3.new(1, 1, 1)
									ac.Font = Enum.Font.GothamBold
									ac.TextSize = 14
									ac.AutoButtonColor = true
									ac.Parent = V
									local ad = Instance.new("UICorner")
									ad.CornerRadius = UDim.new(0, 6)
									ad.Parent = ac
									ac.Activated:Connect(ab)
									N(ac, ab)
									return ac
								end
								_("Export", A)
								_("Import", function()
									B(q.Text)
								end)
							end
						end
						break
					end
				end
			end
			task.defer(O)
			task.delay(0.6, O)
			task.delay(1.5, O)
		end
		k:ApplyToTab(m)
		if d.beforeLoad then
			d.beforeLoad(f, o)
		end
		l:LoadAutoloadConfig()
		if d.afterLoad then
			d.afterLoad(f)
		end
		if j.KeybindFrame and not d.hideKeybindList then
			j.KeybindFrame.Visible = g.ShowKeybindList == nil or g.ShowKeybindList.Value ~= false
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
local ab = {}

function ab.build(ac)
	local ad = ac.tv
	local b = ac.ov
	local c = ac.Players
	local d = ac.LocalPlayer
	local e = ac.UserInputService
	local f = ac.CollectionService
	local g = ac.ReplicatedStorage
	local h = ac.StateObject
	local i = ac.Targeting
	local j = ac.ESP
	local k = ac.Tabs
	local l = ac.espConfig
local function m(n, o)
	if i.get_viewmodel then
		local p = i:get_viewmodel(n)
		if p then
			return p
		end
	end
	if o and o.values then
		return o.values.viewmodels
	end
	return nil
end

local n
local o = 0

local function p()
	local q = b("aimbotmaxdistance", 0)
	if q <= 0 then
		q = math.huge
	end
	local r = ac.Camera.CFrame.Position
	local s = Vector2.new(ac.Camera.ViewportSize.X / 2, ac.Camera.ViewportSize.Y / 2)
	local t = ad("aimbotteamcheck", false)
	local u = ad("aimbotvischeck", false)
	local v = string.lower(b("aimbottarget", "Head"))
	if v == "left arm" then
		v = "arm2"
	elseif v == "right arm" then
		v = "arm1"
	elseif v == "left leg" then
		v = "leg2"
	elseif v == "right leg" then
		v = "leg1"
	end
	local w = RaycastParams.new()
	w.FilterType = Enum.RaycastFilterType.Exclude
	local x = math.huge
	local y

	for z, A in c:GetPlayers() do
		if A == d then
			continue
		end
		if t and i:is_friendly(A) then
			continue
		end
		local B = i:get_character(A)
		if not B then
			continue
		end
		local C = i:get_health(A)
		if type(C) ~= "number" or C <= 0 then
			continue
		end
		local D = m(A, B)
		if typeof(D) ~= "Instance" then
			continue
		end
		local E = D:FindFirstChild(v) or D:FindFirstChild("head") or D:FindFirstChild("torso")
		if not E then
			continue
		end
		local F = (r - E.Position).Magnitude
		if F > q then
			continue
		end
		local G, H = ac.Camera:WorldToViewportPoint(E.Position)
		if not H or G.Z <= 0 then
			continue
		end
		if u then
			w.FilterDescendantsInstances = { d.Character, workspace:FindFirstChild("Viewmodels") }
			local I = workspace:Raycast(r, E.Position - r, w)
			if I and not I.Instance:IsDescendantOf(D) and not (B.instance and I.Instance:IsDescendantOf(B.instance)) then
				continue
			end
		end
		local I = (Vector2.new(G.X, G.Y) - s).Magnitude
		if I < x then
			x = I
			y = E
		end
	end
	return y
end

local function q()
	local r = os.clock()
	if r - o < 1 / 60 then
		return n
	end
	o = r
	if not ad("aimbotenabled", false) then
		n = nil
		return nil
	end
	n = p()
	return n
end

local function r()
	if not ad("aimbotenabled", false) then
		return
	end
	if Options and Options.aimbotkey and not Options.aimbotkey:GetState() then
		return
	end
	local s = q()
	if not (s and s.Parent) then
		return
	end
	local t = math.max(1, b("aimbotsmoothness", 1))
	local u = s.Position
	if b("aimbotmethod", "Camera") == "Mouse" and mousemoverel then
		local v, w = ac.Camera:WorldToViewportPoint(u)
		if w and v.Z > 0 then
			local x = e:GetMouseLocation()
			mousemoverel((v.X - x.X) / t, (v.Y - x.Y) / t)
		end
	else
		local v = ac.Camera.CFrame
		local w = CFrame.lookAt(v.Position, u)
		if t == 1 then
			ac.Camera.CFrame = w
		else
			ac.Camera.CFrame = v:Lerp(w, 1 / t)
		end
	end
end

local s = k.Combat:AddLeftGroupbox("Aimbot")
s:AddToggle("aimbotenabled", { Text = "Enabled", Default = false })
	:AddKeyPicker("aimbotkey", { Default = "E", SyncToggleState = false, Mode = "Hold", Text = "Aimbot Key" })
s:AddDropdown("aimbotmethod", { Text = "Aim Method", Values = { "Camera", "Mouse" }, Default = 1, Multi = false })
s:AddDropdown("aimbottarget", {
	Text = "Target part",
	Values = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" },
	Default = 1,
	Multi = false,
})
s:AddSlider("aimbotsmoothness", { Text = "Smoothness", Default = 1, Min = 1, Max = 20, Rounding = 1 })
s:AddToggle("aimbotteamcheck", { Text = "Team Check", Default = false })
s:AddToggle("aimbotvischeck", { Text = "Visible Check", Default = false })
s:AddSlider("aimbotmaxdistance", { Text = "Max Distance", Default = 0, Min = 0, Max = 2000, Rounding = 0, Suffix = " studs" })


	ac.combat = {
		getTarget = q,
		step = r,
	}
	ab.step = r
end

function ab.step()
end

function ab.unload()
end

return ab
end function a.c()local ab=a.cache.c if not ab then ab={c=aa()}a.cache.c=ab end return ab.c end end do local function aa()
local ab = {}

function ab.build(ac)
	local ad = ac.tv
	local b = ac.ov
	local c = ac.Players
	local d = ac.LocalPlayer
	local e = ac.UserInputService
	local f = ac.CollectionService
	local g = ac.ReplicatedStorage
	local h = ac.StateObject
	local i = ac.Targeting
	local j = ac.ESP
	local k = ac.Tabs
	local l = ac.espConfig
local function m()
	local n = l
	if not n then
		return
	end

	
	n.Enabled = Toggles.ESPMaster.Value
	n.LocalPlayer = false 
	n.MaxDistance = Options.ESPMaxDistance.Value
	n.DynamicBoxes = true 
	n.DynamicBoxesCheap = false
	n.DynamicBoxesIncludeAll = false
	n.Filter = function(o, p)
	    if not o or not p then
			return false
		end

		if not Toggles.ESPFilterTeam.Value then
			return true
		end

		return not i:is_friendly(p)
	end

	
	n.Boxes = Toggles.ESPBoxes.Value
	n.BoxType = Options.ESPBoxType.Value
	n.BoxColor = Options.ESPBoxColor.Value
	n.BoxThickness = Options.ESPBoxThickness.Value
	n.Outlines.Style = Toggles.ESPBoxOutline.Value and "Full" or "None"
	n.Outlines.Color = Options.ESPBoxOutlineColor.Value

	
	n.BoxFill.Enabled = Toggles.ESPBoxFill.Value
	n.BoxFill.Color = Options.ESPBoxFillColor.Value
	n.BoxFill.Transparency = Options.ESPBoxFillTransparency.Value

	
	n.Names = Toggles.ESPNames.Value
	n.TextColor = Options.ESPNameColor.Value
	n.TextSize = Options.ESPTextSize.Value
	n.TextOutline = Toggles.ESPTextOutline.Value
	n.Distance.Enabled = Toggles.ESPDistance.Value
	n.Distance.Color = Options.ESPDistanceColor.Value
	n.Weapon.Enabled = Toggles.ESPWeapon.Value
	n.Weapon.UseToolFallback = true 
	n.TeamIndicator.Enabled = false
	n.FriendlyIndicator.Enabled = false
	n.FriendlyIndicator.CheckTeam = false
	n.FriendlyIndicator.CheckFriends = false

	
	n.HealthBar.Enabled = Toggles.ESPHealth.Value
	n.HealthBar.ShowText = true

	
	
	n.Chams.Enabled = Toggles.ESPChams.Value
	n.Chams.Type = Options.ESPChamsType.Value

	local o = Options.ESPChamsFill.Value
	local p = Options.ESPChamsFillT.Value
	local q = Options.ESPChamsOutline.Value
	local r = Options.ESPChamsOutlineT.Value
	local s = Toggles.ESPChamsVisible.Value

	n.Chams.Highlight.FillColor = o
	n.Chams.Highlight.FillTransparency = p
	n.Chams.Highlight.OutlineColor = q
	n.Chams.Highlight.OutlineTransparency = r
	n.Chams.Highlight.VisibleCheck = s

	n.Chams.MeshChams.FillColor = o
	n.Chams.MeshChams.FillTransparency = p
	n.Chams.MeshChams.OutlineColor = q
	n.Chams.MeshChams.OutlineTransparency = r
	n.Chams.MeshChams.VisibleCheck = s

	n.Chams.Adornment.Color = o
	n.Chams.Adornment.Transparency = p
	n.Chams.Adornment.VisibleCheck = s

	
	n.OffScreenArrows.Enabled = Toggles.ESPArrows.Value
	n.OffScreenArrows.Color = Options.ESPArrowColor.Value
	n.OffScreenArrows.Size = Options.ESPArrowSize.Value
end




local n = k.ESP:AddLeftGroupbox("Main")
n:AddToggle("ESPMaster", { Text = "Enabled", Default = false, Tooltip = "Master switch for all ESP" })
n:AddToggle(
	"ESPFilterTeam",
	{ Text = "Exclude Teammates", Default = false, Tooltip = "Hide players in your squad" }
)
n:AddSlider(
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


local o = k.ESP:AddLeftGroupbox("Boxes")
o:AddToggle("ESPBoxes", { Text = "Boxes", Default = true })
o:AddDropdown("ESPBoxType", { Text = "Box type", Values = { "Normal", "Corner" }, Default = 1, Multi = false })
o
	:AddLabel("Box color")
	:AddColorPicker("ESPBoxColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Box color" })
o:AddSlider("ESPBoxThickness", { Text = "Box thickness", Default = 1, Min = 1, Max = 6, Rounding = 0 })
o:AddToggle("ESPBoxOutline", { Text = "Box outline", Default = true })
o
	:AddLabel("Outline color")
	:AddColorPicker("ESPBoxOutlineColor", { Default = Color3.fromRGB(0, 0, 0), Title = "Outline color" })
o:AddDivider()
o:AddToggle("ESPBoxFill", { Text = "Box fill", Default = false })
o
	:AddLabel("Fill color")
	:AddColorPicker("ESPBoxFillColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Fill color" })
o:AddSlider(
	"ESPBoxFillTransparency",
	{ Text = "Fill transparency", Default = 0.9, Min = 0, Max = 1, Rounding = 2 }
)


local p = k.ESP:AddLeftGroupbox("Chams")
p:AddToggle("ESPChams", { Text = "Chams", Default = false })
p:AddDropdown(
	"ESPChamsType",
	{
		Text = "Chams type",
		Values = { "Highlight", "Adornment", "MeshChams" },
		Default = 1,
		Multi = false,
		Tooltip = "MeshChams = real players only",
	}
)
p
	:AddLabel("Fill color")
	:AddColorPicker("ESPChamsFill", { Default = Color3.fromRGB(59, 144, 204), Title = "Cham fill" })
p:AddSlider("ESPChamsFillT", { Text = "Fill transparency", Default = 0.6, Min = 0, Max = 1, Rounding = 2 })
p
	:AddLabel("Outline color")
	:AddColorPicker("ESPChamsOutline", { Default = Color3.fromRGB(255, 255, 255), Title = "Cham outline" })
p:AddSlider("ESPChamsOutlineT", { Text = "Outline transparency", Default = 0, Min = 0, Max = 1, Rounding = 2 })
p:AddToggle(
	"ESPChamsVisible",
	{ Text = "Visible check", Default = false, Tooltip = "On = occluded depth, Off = always on top" }
)


local q = k.ESP:AddRightGroupbox("Names & Info")
q:AddToggle("ESPNames", { Text = "Names", Default = true })
q
	:AddLabel("Name color")
	:AddColorPicker("ESPNameColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Name color" })
q:AddSlider("ESPTextSize", { Text = "Text size", Default = 12, Min = 6, Max = 28, Rounding = 0 })
q:AddToggle("ESPTextOutline", { Text = "Text outline", Default = true })
q:AddDivider()
q:AddToggle("ESPDistance", { Text = "Distance", Default = false })
q
	:AddLabel("Distance color")
	:AddColorPicker("ESPDistanceColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Distance color" })
q:AddToggle("ESPWeapon", { Text = "Weapon", Default = false })


local r = k.ESP:AddRightGroupbox("Health")
r:AddToggle("ESPHealth", { Text = "Health", Default = false, Tooltip = "Show health text on players" })


local s = k.ESP:AddRightGroupbox("OOF Arrows")
s:AddToggle("ESPArrows", { Text = "Off-screen arrows", Default = false })
s
	:AddLabel("Arrow color")
	:AddColorPicker("ESPArrowColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Arrow color" })
s:AddSlider("ESPArrowSize", { Text = "Arrow size", Default = 14, Min = 8, Max = 40, Rounding = 0 })

local t = k.ESP:AddRightGroupbox("World")
t:AddToggle("ESPWorld", { Text = "World ESP", Default = false })
t:AddToggle("ESPCameras", { Text = "Cameras", Default = true })
	:AddColorPicker("ESPCameraColor", { Default = Color3.fromRGB(255, 220, 80), Title = "Cameras" })
t:AddToggle("ESPDrones", { Text = "Drones", Default = true })
	:AddColorPicker("ESPDroneColor", { Default = Color3.fromRGB(80, 200, 255), Title = "Drones" })
t:AddToggle("ESPTraps", { Text = "Traps", Default = true })
	:AddColorPicker("ESPTrapColor", { Default = Color3.fromRGB(255, 80, 80), Title = "Traps" })
t:AddToggle("ESPGadgets", { Text = "Gadgets", Default = true })
	:AddColorPicker("ESPGadgetColor", { Default = Color3.fromRGB(255, 160, 60), Title = "Gadgets" })



local u = {
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
local v = {
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

for w, x in ipairs(u) do
	Toggles[x]:OnChanged(m)
end
for w, x in ipairs(v) do
	Options[x]:OnChanged(m)
end

m()

local w = {
	{ toggle = "ESPCameras", color = "ESPCameraColor", default = Color3.fromRGB(255, 220, 80), tags = { "DefaultCamera", "BulletproofCamera", "StickyCamera" }, label = "Camera" },
	{ toggle = "ESPDrones", color = "ESPDroneColor", default = Color3.fromRGB(80, 200, 255), tags = { "Drone" }, label = "Drone" },
	{ toggle = "ESPTraps", color = "ESPTrapColor", default = Color3.fromRGB(255, 80, 80), tags = { "Claymore", "NeedleMine", "ProximityAlarm", "BarbedWire", "ShockBattery", "IncendiaryCanister" }, label = "Trap" },
	{ toggle = "ESPGadgets", color = "ESPGadgetColor", default = Color3.fromRGB(255, 160, 60), tags = { "BreachCharge", "RemoteC4", "ThermiteCharge", "ToxicCharge", "SignalDisruptor" }, label = "Gadget" },
}

local x = {}
local y = 0

local function z()
	y += 1
	local A = x[y]
	if not A then
		A = Drawing.new("Text")
		A.Center = true
		A.Outline = true
		A.Size = 13
		x[y] = A
	end
	return A
end

local function A()
	for B = y + 1, #x do
		x[B].Visible = false
	end
end

local function B()
	for C, D in x do
		D:Remove()
	end
	table.clear(x)
	y = 0
end

local function C(D)
	if not D or not D.Parent or not D:IsDescendantOf(workspace) then
		return false
	end
	if D.Parent.Name == "Garbage" or D:IsDescendantOf(g) then
		return false
	end
	local E, F = pcall(function()
		return h.get("Breakable", D)
	end)
	if E and F and F.states and F.states.destroyed and F.states.destroyed:get() then
		return false
	end
	if D:IsA("BasePart") then
		if D.Transparency < 1 and D.Size.Magnitude > 0.05 then
			return D
		end
		return false
	end
	for G, H in D:GetChildren() do
		if H:IsA("BasePart") and H.Transparency < 1 and H.Size.Magnitude > 0.05 then
			return H
		end
	end
	local G = D:IsA("Model") and (D.PrimaryPart or D:FindFirstChildWhichIsA("BasePart", true))
	if G and G.Transparency < 1 and G.Size.Magnitude > 0.05 then
		return G
	end
	return false
end

local function D()
	y = 0
	if not ad("ESPWorld", false) then
		A()
		return
	end
	local E = b("ESPMaxDistance", 0)
	if E <= 0 then
		E = math.huge
	end
	local F = ac.Camera.CFrame.Position
	for G, H in w do
		if not ad(H.toggle, false) then
			continue
		end
		local I = b(H.color, H.default)
		for J, K in H.tags do
			for L, M in f:GetTagged(K) do
				local N = C(M)
				if not N then
					continue
				end
				local O = (F - N.Position).Magnitude
				if O > E then
					continue
				end
				local P, Q = ac.Camera:WorldToViewportPoint(N.Position)
				if not Q or P.Z <= 0 then
					continue
				end
				local R = z()
				R.Text = `{H.label} [{math.floor(O)}]`
				R.Position = Vector2.new(P.X, P.Y)
				R.Color = I
				R.Visible = true
			end
		end
	end
	A()
end

	ac.visuals = {
		applyESP = m,
		step = D,
		unload = B,
	}
	ab.step = D
	ab.unload = B
end

function ab.step()
end

function ab.unload()
end

return ab
end function a.d()local ab=a.cache.d if not ab then ab={c=aa()}a.cache.d=ab end return ab.c end end end
if not LPH_OBFUSCATED then
	LPH_ATTRIBUTES = function(...) end
	VM = function(...) return ... end
	NONE = "NONE"
	LPH_NO_UPVALUES = function(aa) return function(...) return aa(...) end end
	LPH_ENCSTR = function(aa) return aa end
	LPH_ENCNUM = function(aa) return aa end
	LPH_CRASH = function() end
end

local aa = game:GetService("Players")
local ab = game:GetService("RunService")
local ac = game:GetService("ReplicatedStorage")
local ad = game:GetService("UserInputService")
local b = game:GetService("CollectionService")
local c = workspace.CurrentCamera
local d = aa.LocalPlayer

local e = require(ac.Modules.StateObject)
local f = loadstring(game:HttpGet("https://raw.githubusercontent.com/ttokennxyz/vaultcc/refs/heads/main/targeting.lua"))()
local g = loadstring(game:HttpGet("https://raw.githubusercontent.com/ttokennxyz/vaultcc/refs/heads/main/esplib_op1.lua"))()

local h, i, j = loadstring(game:HttpGet("https://raw.githubusercontent.com/ttokennxyz/vaultcc/refs/heads/main/uilib.lua"))()


g:Load({ Enabled = false, Players = false, LocalPlayer = false })

local k = a.a()
local l = a.b().create({
	title = "Operation One - vault.cc Lite",
	folder = "VaultCC/op1_lite",
	tabs = { "Combat", "ESP", "Settings" },
	ignore = { "menubind" },
	afterLoad = function(l)
		if l.visuals and l.visuals.applyESP then
			l.visuals.applyESP()
		end
	end,
})
local m = a.c()
local n = a.d()

local o = {
	Players = aa,
	RunService = ab,
	UserInputService = ad,
	CollectionService = b,
	ReplicatedStorage = ac,
	LocalPlayer = d,
	Camera = workspace.CurrentCamera,
	StateObject = e,
	Targeting = f,
	ESP = g,
	Library = h,
	ThemeManager = i,
	SaveManager = j,
	espConfig = g:GetConfig(),
	tv = k.tv,
	ov = k.ov,
}

l.build(o)
m.build(o)
n.build(o)
l.finish(o)

local p = false
local function q()
	if p then
		return
	end
	p = true
	if o.renderConnection then
		o.renderConnection:Disconnect()
		o.renderConnection = nil
	end
	if o.visuals and o.visuals.unload then
		o.visuals.unload()
	end
	if g and g.Unload then
		g:Unload()
	end
end

o.renderConnection = ab.RenderStepped:Connect(function()
	LPH_ATTRIBUTES(VM(NONE))
	o.Camera = workspace.CurrentCamera
	o.combat.getTarget()
	o.combat.step()
	o.visuals.step()
end)

h:OnUnload(q)
