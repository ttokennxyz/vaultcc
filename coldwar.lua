local a={cache={}}do do local function b()local function c(d)
	return clonefunction and clonefunction(d) or d
end

local function d(e)
	return e
end


local e = {}

local function f(g, h)
	if type(g) ~= "function" or not hookfunction then
		return nil
	end
	local i = hookfunction(g, h)
	e[#e + 1] = { target = g, original = i }
	return i
end

local function g()
	for h = #e, 1, -1 do
		local i = e[h]
		pcall(function()
			if restorefunction then
				restorefunction(i.target)
			else
				hookfunction(i.target, i.original)
			end
		end)
		e[h] = nil
	end
end

local function h(i, j)
	local k
	if filtergc then
		local l = filtergc("function", { Name = i, IgnoreExecutor = true }, false)
		if type(l) == "table" then
			for m, n in l do
				if type(n) == "function" then
					local o = debug.info(n, "s")
					if not j or (o and string.find(o, j, 1, true)) then
						return n
					end
				end
			end
		elseif type(l) == "function" then
			return l
		end
	end
	for l, m in getgc(false) do
		if type(m) == "function" and islclosure(m) and not (isexecutorclosure and isexecutorclosure(m)) and debug.info(m, "n") == i then
			local n = debug.info(m, "s")
			if not j or (n and string.find(n, j, 1, true)) then
				k = m
				break
			end
		end
	end
	return k
end


local function i(j)
	local k = {}
	local l = 0
	for m in j do
		l += 1
	end
	for m, n in getgc(false) do
		if l == 0 then
			break
		end
		if type(n) == "function" and islclosure(n) then
			local o = debug.info(n, "n")
			local p = o and j[o]
			if p and not k[o] and not (isexecutorclosure and isexecutorclosure(n)) then
				local q = debug.info(n, "s")
				if q and string.find(q, p, 1, true) then
					k[o] = n
					l -= 1
				end
			end
		end
	end
	return k
end

return {
	cloneOriginal = c,
	wrap = d,
	hook = f,
	restoreAll = g,
	findGcFunction = h,
	findGcFunctions = i,
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
local ab = debug.profilebegin or function() end
local ac = debug.profileend or function() end

local function ad(b, c, d)
	return function(...)
		ab(b)
		if d == 2 then
			local e, f = c(...)
			ac()
			return e, f
		end
		local e = c(...)
		ac()
		return e
	end
end

return {
	begin = ab,
	stop = ac,
	wrap = ad,
}
end function a.c()local ab=a.cache.c if not ab then ab={c=aa()}a.cache.c=ab end return ab.c end end do local function aa()
local ab = workspace.Raycast
local ac = a.c()

local ad = {
	Vector3.new(1, 0, 0),
	Vector3.new(-1, 0, 0),
	Vector3.new(0, 0, 1),
	Vector3.new(0, 0, -1),
	Vector3.new(0, 1, 0),
	Vector3.new(0, -1, 0),
}
local b = {
	Vector3.new(0.5, 0, 0),
	Vector3.new(-0.5, 0, 0),
	Vector3.new(0, 0, 0.5),
	Vector3.new(0, 0, -0.5),
	Vector3.new(0, 0.5, 0),
	Vector3.new(0, -0.5, 0),
}
local c = {
	Vector3.new(0.5, 0, 0.5),
	Vector3.new(0.5, 0, -0.5),
	Vector3.new(-0.5, 0, 0.5),
	Vector3.new(-0.5, 0, -0.5),
	Vector3.new(0.5, 0.5, 0),
	Vector3.new(0.5, -0.5, 0),
	Vector3.new(-0.5, 0.5, 0),
	Vector3.new(-0.5, -0.5, 0),
	Vector3.new(0, 0.5, 0.5),
	Vector3.new(0, -0.5, 0.5),
	Vector3.new(0, 0.5, -0.5),
	Vector3.new(0, -0.5, -0.5),
}

local function d(...)
	local e = {}
	for f = 1, select("#", ...) do
		local g = select(f, ...)
		for h = 1, #g do
			e[#e + 1] = g[h]
		end
	end
	return e
end

local e = {
	Low = ad,
	Medium = d(b, ad),
	High = d(b, c, ad),
}

local f = RaycastParams.new()
f.FilterType = Enum.RaycastFilterType.Exclude
f.IgnoreWater = true

local function g(h, i, j, k, l, m, n)
	LPH_ATTRIBUTES(VM(NONE))
	if typeof(h) ~= "Vector3" or typeof(i) ~= "Vector3" then
		return nil
	end
	if l(h, i) then
		return h
	end
	j = tonumber(j) or 0
	if j <= 0 then
		return nil
	end
	n = tonumber(n)
	local o = e[k] or e.High
	f.FilterDescendantsInstances = m or {}
	for p = 1, #o do
		local q = o[p] * j
		if n and math.abs(q.Y) > n then
			q = Vector3.new(q.X, math.sign(q.Y) * n, q.Z)
		end
		local r = h + q
		if not ab(workspace, h, r - h, f) and l(r, i) then
			return r
		end
	end
	return nil
end

return {
	solve = ac.wrap("manip.solve", g, 1),
}
end function a.d()local ab=a.cache.d if not ab then ab={c=aa()}a.cache.d=ab end return ab.c end end do local function aa()
local ab = {}

function ab.build(ac)
	local ad = ac.flags
	local b = ac.tv
	local c = ac.ov
	local d = ac.util
	local e = ac.Players
	local f = ac.RunService
	local g = ac.UserInputService
	local h = ac.LocalPlayer
	local i = ac.RS
	local j = ac.Library
	local k = ac.Tabs
	local l = ac.HttpService
	local m = ac.manipulation
	local n = ac.RecoilController
	local o = ac.AimController
	local p = ac.FiremodeController
	local q = ac.Trajectory
	local r = ac.InventoryController
	local s = ac.CameraShaker
	local t = ac.Client
	local u = ac.Tools
	local v = ac.WeaponControllers
	local w = ac.cloneOriginal
	local x = ac.hook
local y
local z = false
local function A(B)
	LPH_ATTRIBUTES(VM(NONE))
	return type(B) == "table" and B.ExplosionSettings ~= nil
end
local function B(C, D)
	LPH_ATTRIBUTES(VM(NONE))
	return type(C) == "table" and (C.AmmoTypeName == "Rocket" or A(D))
end
local function C(D, E, F, G)
	LPH_ATTRIBUTES(VM(NONE))
	if not (ad.rpgprediction and E and F and G) then
		return E.Position
	end
	local H = E.AssemblyLinearVelocity or Vector3.zero
	local I = G.MuzzleVelocity or F.MuzzleVelocity or 0
	if I <= 0 then
		return E.Position
	end

	local J = workspace.Gravity
	local K = E.Position
	local L = (K - D).Magnitude / I
	for M = 1, 3 do
		K = E.Position + H * L
		local N = (K - D).Magnitude
		L = N / I
	end

	local M = math.clamp(c("rpgpredictionstrength", 1), 0, 2)
	return K + Vector3.new(0, J * L * L * 0.5 * M, 0)
end

local function D(E)
	LPH_ATTRIBUTES(VM(NONE))
	if not E then
		return false
	end
	local F = E:FindFirstChild("CharacterValues")
	local G = F and F:FindFirstChild("Unconscious")
	return G ~= nil and G.Value == true
end

local E = 0

local function F(G)
	LPH_ATTRIBUTES(VM(NONE))
	if not G or not G.Parent then
		return false
	end
	local H = G.Parent:FindFirstChildOfClass("Humanoid")
	return H ~= nil and H.Health > 0
end

local G = nil
local H = 0
local I = RaycastParams.new()
I.FilterType = Enum.RaycastFilterType.Exclude
local J = {}
local K = nil
local L = 0

local M = Instance.new("Camera").WorldToViewportPoint
local N = g.GetMouseLocation
local O = game.FindFirstChild
local P = game.FindFirstChildOfClass
local Q = game.IsDescendantOf

local function R()
	LPH_ATTRIBUTES(VM(NONE))
	local S = os.clock()
	if S - H < 0.05 then
		return G
	end
	H = S

	local T = workspace.CurrentCamera
	if not T then
		G = nil
		return nil
	end

	local U = h
	local V = U.Character
	local W = U.Team
	local X = T.CFrame.Position
	local Y = N(g)
	local Z, _ = Y.X, Y.Y
	local ae = ad.silenttarget
	local af = ad.silentteamcheck and W
	local ag = ad.silentdistancecheck and ad.silentmaxdistance
	local ah = ag and ag * ag
	
	local ai = ad.fovenabled and ad.fovsize * ad.fovsize
	local aj = ad.silentvisiblecheck
	local ak, al = nil, ai or math.huge

	if aj then
		table.clear(J)
		if V then
			J[1] = V
		end
		local am = O(workspace, "Ignore")
		if am then
			J[#J + 1] = am
		end
		I.FilterDescendantsInstances = J
	end

	for am, an in e:GetPlayers() do
		local ao = an.Character
		if an == U or not ao or (af and an.Team == W) then
			continue
		end
		local ap = O(ao, ae)
		if not ap then
			continue
		end
		local aq = ap.Position
		local ar = aq - X
		if ah and ar:Dot(ar) > ah then
			continue
		end
		local as, at = M(T, aq)
		if not at then
			continue
		end
		local au, av = as.X - Z, as.Y - _
		local aw = au * au + av * av
		if aw >= al then
			continue
		end
		
		local ax = P(ao, "Humanoid")
		if not ax or ax.Health <= 0 or D(ao) then
			continue
		end
		if aj then
			local ay = workspace:Raycast(X, ar, I)
			if ay and not Q(ay.Instance, ao) then
				continue
			end
		end
		ak, al = ap, aw
	end
	G = ak
	return ak
end

d.getTarget = function()
	LPH_ATTRIBUTES(VM(NONE))
	if F(G) then
		return G
	end
	H = 0
	return R()
end

local function ae()
	LPH_ATTRIBUTES(VM(NONE))
	local af = os.clock()
	if af == L then
		return K
	end
	L = af
	local ag = r.getEquipped()
	if typeof(ag) == "Instance" and ag:IsA("Tool") and ag:GetAttribute("ToolType") == "Weapon" then
		K = ag
		return ag
	end
	local ah = h.Character
	local ai = ah and ah:FindFirstChildOfClass("Tool")
	if ai and ai:GetAttribute("ToolType") == "Weapon" then
		K = ai
		return ai
	end
	K = nil
	return nil
end

d.getMuzzle = function()
	LPH_ATTRIBUTES(VM(NONE))
	local af = ae()
	if not af then
		return nil
	end
	local ag = h.Character
	local ah = ag and ag:FindFirstChild(af.Name .. "Model")
	local ai = (ah and ah:FindFirstChild("Handle")) or af:FindFirstChild("Handle")
	return ai and ai:FindFirstChild("Muzzle1")
end

local function af()
	LPH_ATTRIBUTES(VM(NONE))
	if not (ad.silentenabled or ad.turretsilentenabled or ad.aimbotenabled or ad.snaplines) then
		d.target = nil
		return
	end
	d.target = R()
end

local function ag()
	LPH_ATTRIBUTES(VM(NONE))
	if not ad.aimbotenabled then
		return
	end
	local ah = false
	if Options and Options.aimbotkey then
		ah = Options.aimbotkey:GetState()
	end
	if not ah then
		return
	end

	local ai = d.getTarget()
	if not (ai and ai.Parent) then
		return
	end

	local aj = workspace.CurrentCamera
	if not aj then
		return
	end

	local ak = ai.Position
	local al = math.max(1, c("aimbotsmoothness", 1))

	if c("aimbotmethod", "Camera") == "Mouse" and mousemoverel then
		local am, an = aj:WorldToViewportPoint(ak)
		if an and am.Z > 0 then
			local ao = g:GetMouseLocation()
			local ap = (am.X - ao.X) / al
			local aq = (am.Y - ao.Y) / al
			mousemoverel(ap, aq)
		end
	else

		local am = aj.CFrame
		local an = CFrame.new(am.Position, ak)
		if al == 1 then
			aj.CFrame = an
		else
			aj.CFrame = am:Lerp(an, 1 / al)
		end
	end
end

local ah = (function()
local ah = require(u.Weapon.Muzzle.Discharge)
local ai = require(v.WeaponViewmodel)
local aj = require(i.Shared.Ballistics.ProjectileCaster)
local ak = require(i.Shared.WeaponConfigManager)
local al = require(t.Character.stance.MovementTuning)
local am = require(t.BodyReplication)
local an = require(t.BodyReplication.BodyRotation)
local ao = require(i.Shared.Vehicle.TurretFireController)
local ap = require(t.Tools.Bandage)
local aq
pcall(function()
	aq = require(h.PlayerScripts.BallisticsClient.FlybySuppression)
end)

local ar = debug.getupvalues
local as = debug.getconstants
local at = debug.getinfo
local au = debug.getprotos or getprotos

local function av(aw)
	return type(aw) == "function" and (not islclosure or islclosure(aw))
end

local function aw(ax)
	local ay, S = pcall(ar, ax)
	return ay and S or {}
end

local function ax(ay, S)
	local T, U = pcall(as, ay)
	if not T then
		return false
	end
	for V, W in U do
		if W == S then
			return true
		end
	end
	return false
end

local function ay(S, T)
	for U, V in aw(S) do
		if av(V) and T(V, U) then
			return V, U
		end
	end
end

local function S(T, U)
	if type(T) ~= "table" then
		return nil
	end
	if U == nil then
		return nil
	end
	for V, W in T do
		if av(W) and U(W, V) then
			return W, V
		end
	end
end

local function T(U, V, W)
	if type(U) == "table" and av(U[V]) then
		return U[V], V
	end
	return S(U, W)
end

local function U(V, W, X, Y)
	if not av(V) or X < 0 then
		return nil
	end
	Y = Y or {}
	if Y[V] then
		return nil
	end
	Y[V] = true
	if W(V) then
		return V
	end
	for Z, _ in aw(V) do
		if av(_) then
			local az = U(_, W, X - 1, Y)
			if az then
				return az
			end
		elseif type(_) == "table" then
			for az, aA in _ do
				if av(aA) then
					local aB = U(aA, W, X - 1, Y)
					if aB then
						return aB
					end
				end
			end
		end
	end
	if au then
		local az, aA = pcall(au, V)
		if az then
			for aB, Z in aA do
				if av(Z) then
					local _ = U(Z, W, X - 1, Y)
					if _ then
						return _
					end
				end
			end
		end
	end
	return nil
end

local az = {}

local aA = T(n, "recoilScale", function(aA)
	local aB = aw(aA)
	local V, W, X = false, false, false
	for Y, Z in aB do
		if type(Z) == "table" then
			if type(Z.getAlpha) == "function" then
				V = true
			end
			if type(Z.getCharacterValues) == "function" then
				W = true
			end
			if Z.Crouch ~= nil and Z.Prone ~= nil then
				X = true
			end
		end
	end
	return V and W and X
end)
az.getRecoilMult = { func = aA, upv = aA and aw(aA) or {} }

local aB = T(ah, "fire", function(aB)
	return ax(aB, "IsPreparation") and ax(aB, "config")
end)
az.fire = { func = aB, upv = aB and aw(aB) or {} }
az.spreadVector = {
	func = aB and ay(aB, function(V)
		local W = at(V)
		return W.nups == 0 and W.numparams == 2
	end),
}

local V
if aq and av(aq.new) then
	for W, X in aw(aq.new) do
		if type(X) == "table" and av(X.fire) then
			V = X.fire
			break
		end
	end
end
az.flybyFire = { func = V }

local W = T(o, "flip", function(W)
	return at(W).numparams == 0 and at(W).nups >= 1
end)
local X = T(o, "canAim", function(X)
	return ax(X, "Stance") and ax(X, "Walk")
end)
az.aimtoggle = { func = W, upv = W and aw(W) or {} }
az.isaimingavailable = { func = X, upv = X and aw(X) or {} }
az.aimupdate = {
	
	func = ay(o.attach, function(Y)
		local Z = at(Y)
		return Z.numparams == 1 and ax(Y, "Prone") and ax(Y, "clamp")
	end),
}
az.aimupdate.upv = az.aimupdate.func and aw(az.aimupdate.func) or {}

local Y = T(p, "pull", function(Y)
	return ax(Y, "isFiring") or at(Y).numparams == 1
end)
local Z
if av(p.new) then
	for _, aC in aw(p.new) do
		if type(aC) == "table" and aC.Automatic then
			Z = aC
			break
		end
	end
end
az.firemodestart = { func = Y, upv = Z }

local aC
if av(r.equip) then
	aC = ay(r.equip, function(_)
		return ax(_, "EquipTool")
	end)
end
az.awaitLength = {
	func = aC and ay(aC, function(_)
		return ax(_, "Length") and ax(_, "isConscious")
	end),
}

az.movementupdate = {
	func = T(al, "apply", function(_)
		return ax(_, "inertialSpeed") and ax(_, "sprintHeld")
	end),
}

local _ = ay(ap.new, function(_)
	return ax(_, "HealLimb")
end)
az.healLimb = { func = _, upv = _ and aw(_) or {} }

az.muzzlesConfig = {
	func = T(ak, "MuzzleConfigsOf", function(aD)
		return at(aD).numparams == 2
	end),
}

local aD = ay(aj.Fire, function(aD)
	return ax(aD, "Alive") and ax(aD, "OnFinish")
end)
az.onArcEnd = {
	func = aD and ay(aD, function(aE)
		return ax(aE, "Segments")
	end),
}

local aE = ay(ao.Attach, function(aE)
	return ax(aE, "muzzleConfig") and ax(aE, "WorldCFrame")
end)
az.fireOnce = { func = aE, upv = aE and aw(aE) or {} }

az.sendOwnInfo = {
	func = ay(am.flushNow, function(aF)
		return ax(aF, "NewCameraAngle")
	end),
}

az.bodyRotationUpdate = {
	func = T(an, "UpdateCharacter", function(aF)
		return ax(aF, "HumanoidRootPart") and ax(aF, "LastUpdate")
	end),
}
az.bodyWallPush = {
	func = az.bodyRotationUpdate.func and ay(az.bodyRotationUpdate.func, function(aF)
		return at(aF).numparams >= 4
	end),
}

az.viewmodelWallPush = {
	func = U(ai.attach, function(aF)
		return ax(aF, "viewmodelAttachment") and ax(aF, "raise")
	end, 4),
}

local function aF(aG)
	if not av(aG) then
		return false
	end
	local aH = at(aG)
	if not aH or (aH.numparams or 0) < 5 then
		return false
	end
	if ax(aG, "proj") and ax(aG, "seed") and not ax(aG, "GetServerTimeNow") then
		return false
	end
	local aI = 0
	if ax(aG, "GetServerTimeNow") then
		aI += 1
	end
	if ax(aG, "encodeFire") then
		aI += 1
	end
	if ax(aG, "Direction") and ax(aG, "Seed") then
		aI += 1
	end
	if ax(aG, "Unit") then
		aI += 1
	end
	return aI >= 2
end

local function aG(aH)
	if type(aH) ~= "table" then
		return nil
	end
	if aF(aH.fireVolley) then
		return aH.fireVolley
	end
	local aI = aH.fire
	if av(aI) then
		local aJ, aK = pcall(as, aI)
		if aJ then
			for aL, aM in aK do
				if type(aM) == "string" then
					local aN = aH[aM]
					if av(aN) and aN ~= aI and aF(aN) then
						return aN
					end
				end
			end
		end
		for aL, aM in aw(aI) do
			if aF(aM) then
				return aM
			end
		end
	end
	for aJ, aK in aH do
		if aJ ~= "fire" and aF(aK) then
			return aK
		end
	end
	return nil
end

local aH
for aI, aJ in az.fire.upv do
	if aG(aJ) then
		aH = aJ
		break
	end
end
if not aH then
	pcall(function()
		local aI = h:FindFirstChild("PlayerScripts")
		local aJ = aI and aI:FindFirstChild("BallisticsClient")
		local aK = aJ and aJ:FindFirstChild("ClientFire")
		if aK then
			aH = require(aK)
		end
	end)
end
az.volleyFrom = aG
az.fireVolleyFn = aG(aH)

return az
end)()

local function ai(aj, ak, al, am)
	local an = aj.Transparency
	local ao = 1 - an
	local ap = al / am
	local aq = ao / ap

	task.wait(ak - al)
	for ar = 1, ap do
		task.wait(am)
		aj.Transparency += aq
	end
	aj.Transparency = 1
	aj:Destroy()
end

local function aj(ak, al, am, an, ao)
	local ap = (al - ak).Magnitude
	if ap <= 0.001 then
		return
	end
	local aq = (ak + al) / 2

	local ar = c("localtracersmaterial", "Plastic")
	if an then
		ar = c("teamtracersmaterial", "Plastic")
	elseif ao then
		ar = c("enemytracersmaterial", "Plastic")
	end

	local as = c("localtracerscolor", Color3.fromRGB(59, 255, 50))
	if an then
		as = c("teamtracerscolor", Color3.fromRGB(59, 144, 204))
	elseif ao then
		as = c("enemytracerscolor", Color3.fromRGB(255, 60, 60))
	end

	local at = c("localtracerstransparency", 0.5)
	if an then
		at = c("teamtracerstransparency", 0.5)
	elseif ao then
		at = c("enemytracerstransparency", 0.5)
	end

	local au = c("bullettracersize", 0.1)

	local av = Instance.new("Part")
	av.Name = "tracer"
	av.Anchored = true
	av.CanCollide = false
	av.CanQuery = false
	av.CanTouch = false
	av.Material = Enum.Material[ar]
	av.Color = as
	av.Size = Vector3.new(au, au, ap)
	av.CFrame = CFrame.new(aq, al)
	av.Parent = workspace:FindFirstChild("Ignore") or workspace
	av.Transparency = at

	task.spawn(ai, av, 3, 1, 0.05)

	return av
end

local ak = setmetatable({}, { __mode = "k" })
local al = { origin = nil, at = 0 }
local am
local an
local ao
local ap

local function aq(ar, as)
	if as and ar and (as - ar).Magnitude > 0.05 then
		al.origin = as
		al.at = os.clock()
	end
end
if ah.onArcEnd.func then
	local ar
	ar = x(ah.onArcEnd.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		local as = { ... }
		local at = as[1]
		local au = table.pack(ar(...))
		if not at or at.Alive or ak[at] then
			return table.unpack(au, 1, au.n)
		end

		ak[at] = true
		local av = at.Owner
		local aw = av == h
		local ax = av ~= nil and not aw and av.Team ~= nil and av.Team == h.Team
		local ay = av ~= nil and not aw and not ax
		local az = b("tracersenabled", false)
			and (
				(aw and b("localtracers", false))
				or (ay and b("enemytracers", false))
				or (ax and b("teamtracers", false))
			)
		if az then
			local aA = aw and al.origin and os.clock() - al.at < 0.25 and al.origin
			local aB = at.Segments or {}
			for aC, aD in ipairs(aB) do
				if typeof(aD.From) == "Vector3" and typeof(aD.To) == "Vector3" then
					local aE = aD.From
					if aC == 1 and aA and (aE - aA).Magnitude > 0.15 then
						aE = aA
					end
					task.spawn(aj, aE, aD.To, aw, ax, ay)
				end
			end
		end
		return table.unpack(au, 1, au.n)
	end)
end

if ah.flybyFire.func then
	local ar
	ar = x(ah.flybyFire.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		if ad.antisuppression then
			return
		end
		return ar(...)
	end)
end

local ar = s.Shake
local as = w(ar)
s.Shake = function(...)
	LPH_ATTRIBUTES(VM(NONE))
	if ad.antisuppression then
		return
	end
	return as(...)
end


if ah.getRecoilMult.func then
	local at
	at = x(ah.getRecoilMult.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		return (at(...) or 1) * c("recoilmult", 0)
	end)
end






local at = { dir = nil, untilT = 0, since = 0 }
ac.lookHold = at
local au = 2.5

local function av(aw, ax)
	LPH_ATTRIBUTES(VM(NONE))
	local ay = os.clock()
	local az = at.dir
	
	if not az or ay > at.untilT or az:Dot(aw) < 0.94 then
		at.since = ay
	end
	at.dir = aw
	at.untilT = math.max(at.untilT, ay + ax)
end

local function aw()
	LPH_ATTRIBUTES(VM(NONE))
	if at.dir and os.clock() <= at.untilT then
		return at.dir
	end
	at.dir = nil
	return nil
end


local function ax(ay, az)
	LPH_ATTRIBUTES(VM(NONE))
	local aA = ay.CFrame:VectorToObjectSpace(az)
	return math.atan2(-aA.X, -aA.Z)
end

if ah.sendOwnInfo.func then
	local ay
	ay = x(ah.sendOwnInfo.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		local az = debug.getupvalue(ay, 1)
		if type(az) == "table" then
			local aA = aw()
			if aA then
				az.NewCameraAngle = math.asin(math.clamp(aA.Y, -1, 1))
				local aB = az.HumanoidRootPart
				if aB and aB.Parent then
					az.NewCameraYaw = math.clamp(ax(aB, aA), -au, au)
				end
			elseif ad.antiaimpitch then
				az.NewCameraAngle = math.rad(c("antiaimpitchangle", 90))
			end
		end
		return ay(...)
	end)
end

if ah.bodyWallPush.func then
	local ay
	ay = x(ah.bodyWallPush.func, function(az, ...)
		LPH_ATTRIBUTES(VM(NONE))
		if ad.gunup and az and az.IsOwnCharacter then
			az.WallPush = az.WallPush or { push = 0, raise = 0 }
			az.WallPush.push = 0
			az.WallPush.raise = math.rad(89)
			return 0, math.rad(89)
		end
		return ay(az, ...)
	end)
end

if ah.viewmodelWallPush.func then
	local ay
	ay = x(ah.viewmodelWallPush.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		if ad.gunup then
			debug.setupvalue(ay, 2, 0)
			debug.setupvalue(ay, 3, math.rad(89))
			return
		end
		return ay(...)
	end)
end

if ah.bodyRotationUpdate.func then
	local ay
	ay = x(ah.bodyRotationUpdate.func, function(az, aA)
		LPH_ATTRIBUTES(VM(NONE))
		if not ad.antiaimpitch and not ad.gunup then
			return ay(az, aA)
		end
		if az ~= h.Character or not aA then
			return ay(az, aA)
		end

		if ad.antiaimpitch and not aw() then
			local aB = math.rad(c("antiaimpitchangle", 90))
			aA.NewCameraAngle = aB
			aA.CurrentCameraAngle = aB
		end

		local aB = aA.StanceValue
		local aC
		if ad.gunup and aB then
			aC = aB.Value
			aB.Value = "Walk"
		end
		local aD = table.pack(ay(az, aA))
		if aC ~= nil and aB.Parent then
			aB.Value = aC
		end
		return table.unpack(aD, 1, aD.n)
	end)
end

local function ay(az)
	local aA = {}
	for aB, aC in az or {} do
		local aD = typeof(aC)
		if aD == "RaycastParams" then
			aA.raycastParams = aC
		elseif aD == "function" then
			aA.spreadVector = aC
		elseif aD == "Instance" then
			if aC:IsA("Camera") then
				aA.camera = aC
			elseif aC:IsA("Player") then
				aA.player = aC
			elseif aC:IsA("ReplicatedStorage") then
				aA.replicatedStorage = aC
			end
		elseif aD == "table" then
			if type(aC.IsPreparation) == "function" then
				aA.matchPhase = aC
			elseif type(aC.getCharacter) == "function" then
				aA.wielder = aC
			elseif type(aC.isShown) == "function" then
				aA.viewmodel = aC
			elseif type(aC.zeroAngle) == "function" then
				aA.zeroController = aC
			elseif type(aC.MuzzleFlash) == "function" then
				aA.weaponEffects = aC
			elseif type(aC.Play) == "function" then
				aA.soundManager = aC
			elseif type(aC.flushNow) == "function" then
				aA.bodyReplication = aC
			elseif ah.volleyFrom(aC) then
				aA.clientFire = aC
			end
		end
	end
	return aA
end

local function az(aA)
	for aB, aC in debug.getupvalues(aA) do
		if type(aC) == "function" and islclosure(aC) then
			local aD = debug.getinfo(aC)
			if aD.nups == 0 and aD.numparams == 2 then
				return aC
			end
		end
	end
end





local function aA(aB)
	local aC = 0
	for aD, aE in aB:GetChildren() do
		local aF = aE:IsA("BasePart") and O(aE, "Health")
		if aF and aF:IsA("ValueBase") then
			aC += aF.Value
		end
	end
	return aC
end

local aB = { dir = nil, origin = nil }
local aC = { n = 0 }
ac.shotLog = aC

local function aD(aE)
	if not aE then
		return
	end
	local aF
	aF = x(aE, function(aG, aH)
		LPH_ATTRIBUTES(VM(NONE))
		local aI = aB.dir or aG
		local aJ = c("spreadmult", 0)
		if aJ <= 0 then
			return aI.Unit
		end
		if aJ >= 1 then
			return aF(aI, aH)
		end
		return aF(aI, (aH or 1) * aJ)
	end)
end
aD(ah.spreadVector.func)

local aE = {}
local function aF()
	LPH_ATTRIBUTES(VM(NONE))
	table.clear(aE)
	local aG = h.Character
	if aG then
		aE[1] = aG
	end
	local aH = workspace:FindFirstChild("Ignore")
	if aH then
		aE[#aE + 1] = aH
	end
	return aE
end


local function aG(aH, aI, aJ)
	LPH_ATTRIBUTES(VM(NONE))
	local aK = d.getTarget()
	if not aK then
		return nil
	end
	local aL = B(aI, aJ) and C(aH, aK, aI, aJ)
		or aK.Position
	local aM = aH
	if ad.manipulation and am then
		local aN = am(aH, aL, aK.Parent, ((aJ and aJ.Penetration) or 0) / 10, aF())
		if aN then
			aM = aN
		end
	end
	return aL, aM
end

local function aH(aI, aJ, aK)
	LPH_ATTRIBUTES(VM(NONE))
	local aL = aI - aJ
	aB.aim = aI
	if aL.Magnitude > 0.001 then
		aB.dir = aL.Unit
		
		av(aB.dir, 0.25)
	end
	if (aJ - aK).Magnitude > 0.05 then
		aB.origin = aJ
	end
end

if ah.fireVolleyFn then
	local aI
	aI = x(ah.fireVolleyFn, function(aJ, aK, aL, aM, aN, S)
		LPH_ATTRIBUTES(VM(NONE))
		local T = aB.origin
		if T then
			aq(aM, T)
			aM = T
		end
		
		
		local U = ac.shiftTest
		if U and aB.aim then
			U.count = (U.count or 0) + 1
			local V = (math.floor((U.count - 1) / U.per) % #U.seq) + 1
			local W = U.seq[V]
			local X = (aB.aim - aM).Unit
			local Y = X:Cross(Vector3.yAxis)
			Y = Y.Magnitude > 1e-3 and Y.Unit or Vector3.xAxis
			local Z = Y * W.X + Vector3.yAxis * W.Y
			T = aM + Z
			aM = T
			local _ = (aB.aim - aM).Unit
			aN = table.clone(aN)
			for aO = 1, #aN do
				aN[aO] = _
			end
			av(_, 0.25)
			U.last = W
		end
		
		local aO = aC
		
		local V = aB.target
		local W = {
			t = os.clock(),
			origin = aM,
			redirected = aB.dir ~= nil,
			shift = T and (T - aB.muzzle).Magnitude or 0,
			test = ac.shiftTest and ac.shiftTest.last,
			target = V and V.Parent and V.Parent.Name,
			rage = an ~= nil,
			dmg = 0,
		}
		aO[(aO.n % 40) + 1] = W
		aO.n += 1
		
		local X = V and V.Parent
		if X then
			local Y = aA(X)
			task.delay(0.6, function()
				W.dmg = math.max(0, Y - aA(X))
			end)
		end
		return aI(aJ, aK, aL, aM, aN, S)
	end)
end

if ah.fire.func then
	local aI = ay(ah.fire.upv)
	local aJ = aI.viewmodel
	local aK
	aK = x(ah.fire.func, function(aL, aM)
		LPH_ATTRIBUTES(VM(NONE))
		local aN = aL and aL.config
		local aO = aN and aN.BulletSettings and aN.BulletSettings[aM]
		local S, T = an, ap
		local U = workspace.CurrentCamera
		local V = U and (U.CFrame.Position - U.Focus.Position).Magnitude <= 0.75
		local W = aL and ((V and (not aJ or aJ.isShown()) and aL.viewmodelAttachment) or aL.attachment)
		local X = W and W.WorldPosition
		aB.target, aB.muzzle = ao, X
		if X then
			if not S and ad.silentenabled and aN then
				S, T = aG(X, aN, aO)
				aB.target = S and d.getTarget()
			end
			if S then
				aH(S, T or X, X)
			elseif (ad.antiaimpitch or ad.antiaimspin) and U then
				av(U.CFrame.LookVector, 0.25)
			end
		end
		E += 1
		z = A(aO)
		local Y, Z = pcall(aK, aL, aM)
		aB.dir, aB.origin, aB.aim = nil, nil, nil
		z = false
		if not Y then
			error(Z, 0)
		end
	end)
end

if ah.fireOnce.func then
	aD(az(ah.fireOnce.func))
	local aI
	aI = x(ah.fireOnce.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		local aJ = ad.turretsilentenabled and debug.getupvalue(aI, 1)
		local aK = type(aJ) == "table" and aJ.muzzle
		if aK and aK.Parent then
			local aL = aJ.muzzleConfig
			local aM = aL and aL.BulletSettings and aL.BulletSettings[1] or {}
			local aN = aK.WorldCFrame.Position
			local aO = d.getTarget()
			if aO and aL then
				local S = B(aL, aM) and C(aN, aO, aL, aM)
					or aO.Position
				aH(S, aN, aN)
			end
			z = A(aM)
		end
		local aL, aM = pcall(aI, ...)
		aB.dir, aB.origin, aB.aim = nil, nil, nil
		z = false
		if not aL then
			error(aM, 0)
		end
	end)
end
if ah.aimtoggle.func then
local aI
aI = x(ah.aimtoggle.func, function(...)
	LPH_ATTRIBUTES(VM(NONE))
	local aJ = aI
	if not ad.aimanywhere then
		return aJ(...)
	end
	local aK = debug.getupvalue(aJ, 1)
	debug.setupvalue(aJ, 1, (aK == 0) and 1 or 0)
end)
end

if ah.aimupdate.func then
local aI
aI = x(ah.aimupdate.func, function(aJ)
	LPH_ATTRIBUTES(VM(NONE))
	local aK = aI
	local aL = ad.instantads
	local aM = ad.aimanywhere
	local aN = ad.noadsslowdown
	if not (aL or aM or aN) then
		return aK(aJ)
	end

	local aO = debug.getupvalue(aK, 3) == 1
	if aL then
		debug.setupvalue(aK, 2, aO and 1 or 0)
	end

	aK(aJ)

	if aM and aO then
		debug.setupvalue(aK, 3, 1)
		if aL then
			debug.setupvalue(aK, 2, 1)
		end
	end

	if aN then
		local S = debug.getupvalue(aK, 1)
		if typeof(S) == "Instance" then
			S.Value = 1
		end
	end
end)
end

if ah.isaimingavailable.func then
local aI
aI = x(ah.isaimingavailable.func, function(...)
	LPH_ATTRIBUTES(VM(NONE))
	if ad.aimanywhere then
		return true
	end
	return aI(...)
end)
end

if ah.firemodestart.func then
local aI
aI = x(ah.firemodestart.func, function(aJ)
	LPH_ATTRIBUTES(VM(NONE))
	local aK = ah.firemodestart.upv

	if not aJ.isFiring then
		aJ.isFiring = true
		local aL = aJ:_current()
		if aL then
			local aM = aL.strategy
			if ad.forceauto then
				local aN = aK and aK.Automatic
				if aN and aN.strategy then
					aM = aN.strategy
				end
			end
			if aM then
				task.spawn(aM.fire, aJ)
			end
		end
	end
end)
end

if ah.awaitLength.func then
	local aI
	aI = x(ah.awaitLength.func, function(...)
		LPH_ATTRIBUTES(VM(NONE))
		if ad.instantequip then
			return false
		end
		return aI(...)
	end)
end

local function aI(aJ)
	local function aK(aL)
		local aM = aJ:FindFirstChild(aL)
		local aN = aM and aM:FindFirstChild("Health")
		if aN then
			local aO = aN:GetAttribute("MaxHealth")
			if aO and aO > 0 then
				return aN.Value / aO
			end
		end
		return nil
	end
	local aL, aM = aK("Left Leg"), aK("Right Leg")
	if aL and aM then
		return 0.5 + (aL + aM) / 4
	end
	return nil
end

if ah.movementupdate.func then
	local aJ
	aJ = x(ah.movementupdate.func, function(aK)
		LPH_ATTRIBUTES(VM(NONE))
		if not ad.omnisprint and not ad.nohurtslowdown then
			return aJ(aK)
		end

		if ad.omnisprint and aK then
			aK.firstPerson = false
		end

		aJ(aK)

		if ad.nohurtslowdown and aK and aK.humanoid and aK.character then
			local aL = aI(aK.character)
			if aL and aL > 0 and aL < 1 then
				aK.humanoid.WalkSpeed = aK.humanoid.WalkSpeed / aL
				if type(aK.inertialSpeed) == "number" then
					aK.inertialSpeed = aK.inertialSpeed / aL
				end
			end
		end
	end)
end

local aJ = q.new
q.new = function(aK)
	LPH_ATTRIBUTES(VM(NONE))
	if not z then
		if ad.nodrop then
			aK.Gravity = 0
		end
		if ad.instantbullet then
			aK.MuzzleSpeed = 1e6
			aK.K = 0
		end
	end
	return aJ(aK)
end

local aK = i:WaitForChild("Remotes")

local aL = 0
local function aM()
	LPH_ATTRIBUTES(VM(NONE))
	local function aN(aO)
		if not aO then
			return nil
		end
		for S, T in aO:GetChildren() do
			if T:IsA("Tool") and T:GetAttribute("ToolType") == "Bandage" then
				local U = T:FindFirstChild("Bandages")
				if not U then
					return T
				end
				for V, W in U:GetChildren() do
					if W:IsA("IntValue") and W.Value > 0 then
						return T
					end
				end
			end
		end
		return nil
	end
	return aN(h.Character) or aN(h:FindFirstChild("Backpack"))
end
local function aN(aO)
	LPH_ATTRIBUTES(VM(NONE))
	if not ad.autoheal then
		return
	end
	aL = aL + aO
	if not ad.instantheal and aL < 0.75 then
		return
	end
	aL = 0

	local S = aK:FindFirstChild("Bandage")
	local T = aM()
	local U = h.Character
	if not (S and T and U) then
		return
	end
	local V = c("autohealmindamage", 30)
	for W, X in U:GetChildren() do
		if X:IsA("BasePart") and X.Name ~= "HumanoidRootPart" then
			local Y = X:FindFirstChild("Health")
			if Y then
				local Z = Y:GetAttribute("MaxHealth")
				if Z and Z > 0 and (Z - Y.Value) / Z * 100 >= V then
					S:FireServer(T, "HealLimb", X)
				end
			end
		end
	end
end

local aO = 0
local function S(T)
	LPH_ATTRIBUTES(VM(NONE))
	if not ad.fastrevive then
		return
	end
	aO = aO + T
	if aO < 1 then
		return
	end
	aO = 0

	local U = workspace:FindFirstChild("Characters")
	if not U then
		return
	end
	local V = U:QueryDescendants("#RevivePrompt")
	for W, X in V do
		if X:IsA("ProximityPrompt") then
			X.HoldDuration = 3
		end
	end
end

local T = {
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
local U = { AutoShift = true, Ackermann = true }
local V = {
	ChassisType = "Wheeled",
	DriveType = "AWD",
	Differential = "Locked",
}
local W = {}
local X = {}
local Y = {}
local Z = "{}"
local _ = {}
local aP = false
local aQ = ""
local function aR(aS)
	local aT = aS.Name or aS.DisplayName or aS.VehicleName or aS.Id or "Unknown Car"
	local aU = aS.Team or aS.Faction or aS.Side or "PACT"
	aU = tostring(aU):upper():find("NATO") and "NATO" or "PACT"
	return tostring(aT) .. " (" .. aU .. ")"
end
local function aS(aT)
	local aU
	local aV = aT.Parent
	while aV and aV ~= i do
		local aW = aV.Name:upper()
		if aW == "PACT" or aW == "NATO" then
			aU = aW
			break
		end
		aV = aV.Parent
	end
	if not aU then
		return nil
	end
	return aT.Name .. " (" .. aU .. ")"
end
local function aT(aU)
	local aV = {}
	if type(aU) == "table" then
		for aW, aX in pairs(aU) do
			if type(aX) ~= "table" then
				aV[aW] = aX
			end
		end
		if type(aU.Ratios) == "table" then
			aV.Ratios = {}
			for aW, aX in pairs(aU.Ratios) do
				aV.Ratios[aW] = aX
			end
		end
		if type(aU.Wheels) == "table" then
			aV.Wheels = {}
			for aW, aX in ipairs(aU.Wheels) do
				aV.Wheels[aW] = {}
				for aY, aZ in pairs(aX) do
					aV.Wheels[aW][aY] = aZ
				end
			end
		end
	end
	for aW, aX in pairs(T) do
		aV[aW] = aU and aU[aW] ~= nil and aU[aW] or aX
	end
	for aW, aX in pairs(U) do
		aV[aW] = aU and aU[aW] ~= nil and aU[aW] or aX
	end
	for aW, aX in pairs(V) do
		aV[aW] = aU and aU[aW] ~= nil and aU[aW] or aX
	end
	return aV
end
local function aU()
	Z = l:JSONEncode(W)
	if Options.carsprofiles and Options.carsprofiles.Value ~= Z and not aP then
		aP = true
		Options.carsprofiles:SetValue(Z)
		aP = false
	end
end
local function aV(aW)
	if aP then
		return
	end
	if type(aW) ~= "string" or aW == "" then
		return
	end
	local aX, aY = pcall(l.JSONDecode, l, aW)
	if aX and type(aY) == "table" then
		for aZ, a_ in pairs(aY) do
			if type(a_) == "table" then
				W[aZ] = aT(a_)
			end
		end
	end
end
local function aW(aX, aY)
	if not aX or type(aY) ~= "table" or type(aY.Transmission) ~= "table" then
		return
	end
	if _[aY] then
		return
	end
	_[aY] = true
	Y[aX] = aY
	X[#X + 1] = aX
	if W[aX] == nil then
		W[aX] = aT(aY.Transmission)
	end
end
local function aX()
	local aY = i:FindFirstChild("Shared") and i.Shared:FindFirstChild("VehicleConfigManager")
	if aY then
		for aZ, a_ in ipairs(aY:GetDescendants()) do
			if a_:IsA("ModuleScript") then
				local a0 = aS(a_)
				if a0 then
					local a1, a2 = pcall(require, a_)
					if a1 and type(a2) == "table" and rawget(a2, "Transmission") then
						for a3, a4 in pairs(a2.Transmission) do
							if type(a4) == "number" and T[a3] == nil then
								T[a3] = a4
							elseif type(a4) == "boolean" and U[a3] == nil then
								U[a3] = a4
							elseif type(a4) == "string" and V[a3] == nil then
								V[a3] = a4
							end
						end
						aW(a0, a2)
					end
				end
			end
		end
	end

	if not aY then
		for aZ, a_ in pairs(getgc(true)) do
			if
				typeof(a_) == "table"
				and rawget(a_, "Transmission")
				and rawget(a_, "Damage")
				and rawget(a_, "ShopInfo")
			then
				local a0 = a_.ShopInfo
				if type(a0) == "table" then
					local a1 = aR(a0)
					for a2, a3 in pairs(a_.Transmission) do
						if type(a3) == "number" and T[a2] == nil then
							T[a2] = a3
						elseif type(a3) == "boolean" and U[a2] == nil then
							U[a2] = a3
						elseif type(a3) == "string" and V[a2] == nil then
							V[a2] = a3
						end
					end
					aW(a1, a_)
				end
			end
		end
	end
	table.sort(X)
	local aZ = table.concat(X, "\0")
	if Options.carprofile and aZ ~= aQ then
		aQ = aZ
		Options.carprofile:SetValues(X)
	end
end
aX()
local aY = { selected = X[1] }
local function aZ()
	if not ad.carmods then
		return
	end
	for a_, a0 in pairs(Y) do
		local a1 = W[a_]
		if a1 then
			local a2 = a0.Transmission
			for a3 in pairs(T) do
				if a2[a3] ~= a1[a3] then
					a2[a3] = a1[a3]
				end
			end
			for a3 in pairs(U) do
				if a2[a3] ~= a1[a3] then
					a2[a3] = a1[a3]
				end
			end
			for a3 in pairs(V) do
				if a2[a3] ~= a1[a3] then
					a2[a3] = a1[a3]
				end
			end
			if a1.Ratios then
				a2.Ratios = a2.Ratios or {}
				for a3, a4 in pairs(a1.Ratios) do
					if a2.Ratios[a3] ~= a4 then
						a2.Ratios[a3] = a4
					end
				end
			end
			if a1.Wheels then
				a2.Wheels = a2.Wheels or {}
				for a3, a4 in ipairs(a1.Wheels) do
					a2.Wheels[a3] = a2.Wheels[a3] or {}
					for a5, a6 in pairs(a4) do
						if a2.Wheels[a3][a5] ~= a6 then
							a2.Wheels[a3][a5] = a6
						end
					end
				end
			end
		end
	end
end

local function a_()
	if not aY.selected then
		return nil
	end
	W[aY.selected] = W[aY.selected] or aT()
	return W[aY.selected]
end
local function a0(a1, a2)
	local a3 = a_()
	if not a3 then
		return
	end
	a3[a1] = a2
	aU()
	aZ()
end
local a1 = 0
local function a2(a3)
	LPH_ATTRIBUTES(VM(NONE))
	if not ad.carmods then
		return
	end
	a1 = a1 + a3
	if a1 < 5 then
		return
	end
	a1 = 0
	aX()
	aZ()
end

local function a3(a4)
	local a5 = ay(a4)
	if a5.clientFire then
		return a5.clientFire
	end
	for a6, a7 in pairs(a4 or {}) do
		if ah.volleyFrom(a7) then
			return a7
		end
	end
end
local a4 = a3(ah.fire.upv)
local a5 = aK:WaitForChild("Weapon")

y = ah.muzzlesConfig.func and debug.getupvalue(ah.muzzlesConfig.func, 1)
local a6 = select(
	2,
	pcall(function()
		return require(i:WaitForChild("Shared"):WaitForChild("Ballistics"):WaitForChild("ProjectileMaterials"))
	end)
)
if type(a6) ~= "table" then
	a6 = nil
end

local function a7(a8, a9)
	LPH_ATTRIBUTES(VM(NONE))
	local ba = y and y[a8.Name]
	return ba and ba[a9]
end

local a8 = RaycastParams.new()
a8.FilterType = Enum.RaycastFilterType.Include
local a9 = RaycastParams.new()
a9.FilterType = Enum.RaycastFilterType.Exclude





local function ba(bb, bc, bd, be)
	LPH_ATTRIBUTES(VM(NONE))
	local bf = a8
	bf.FilterDescendantsInstances = { bd }
	local bg = workspace:Raycast(bb + bc * be, -bc * be, bf)
	if bg then
		return bg.Position, (bg.Position - bb).Magnitude
	end
	return nil, nil
end

local bb = game.FindFirstAncestorOfClass
local function bc(bd, be, bf, bg, bh)
	LPH_ATTRIBUTES(VM(NONE))
	if not bg or bg <= 0 then
		return false
	end
	local bi = be - bd
	local bj = bi.Magnitude
	if bj < 0.1 then
		return true
	end
	local bk = bi / bj
	local bl = bg
	local bm = bd
	local bn = table.clone(bh)
	local bo = #bn
	for bp = 1, 16 do
		a9.FilterDescendantsInstances = bn
		local bq = workspace:Raycast(bm, be - bm, a9)
		if not bq then
			return true
		end
		local br = bq.Instance
		if Q(br, bf) then
			return true
		end
		local bs = br:GetAttribute("PenThreshold")
		if type(bs) == "number" and bg < bs then
			return false
		end
		if bq.Material == Enum.Material.Water or br:IsA("Terrain") then
			return false
		end
		local bt = bb(br, "Accessory")
		if bt and (bt.Name == "CustomHelmet" or bt.Name == "CustomArmor") then
			return false
		end
		local bu = bb(br, "Model")
		local bv = bu ~= nil and P(bu, "Humanoid") ~= nil
		local bw, bx = ba(bq.Position, bk, br, bl)
		if not bw then
			return false
		end
		local by = bx * (bv and 0.3 or (a6 and a6.getPenetration(bq.Material) or 1))
		if by > bl then
			return false
		end
		bl -= by
		bn[bo + bp] = br
		bm = bw + bk * 0.01
	end
	return false
end

local function bd(be, bf, bg, bh, bi)
	LPH_ATTRIBUTES(VM(NONE))
	a9.FilterDescendantsInstances = bi
	local bj = workspace:Raycast(be, bf - be, a9)
	if not bj or Q(bj.Instance, bg) then
		return true
	end
	if not ad.ragebotwallbang then
		return false
	end
	return bc(be, bf, bg, bh, bi)
end

am = function(be, bf, bg, bh, bi)
	LPH_ATTRIBUTES(VM(NONE))
	if not ad.manipulation or not be or not bf then
		return be
	end
	local bj = m.solve(be, bf, ad.manipulationdistance or 1, ad.manipulationdepth or "Low", function(bj, bk)
		if not bg then
			return true
		end
		return bd(bj, bk, bg, bh, bi)
	end, bi, 1)
	if not bj then
		return nil
	end
	return bj
end

local function be(bf, bg)
	local bh = buffer.create(3)
	buffer.writeu8(bh, 0, 1)
	buffer.writeu8(bh, 1, bf)
	buffer.writeu8(bh, 2, bg)
	a5:FireServer(bh)
end

local bf = { "Head", "Torso", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }
local function bg(bh, bi, bj, bk)
	LPH_ATTRIBUTES(VM(NONE))
	for bl, bm in bf do
		local bn = bh:FindFirstChild(bm)
		if bn and bn:IsA("BasePart") then
			if bd(bi, bn.Position, bh, bj, bk) then
				return bn, bi
			end
		end
	end
	return nil
end

local bh = 0
local bi = 0
local bj = nil
local bk = setmetatable({}, { __mode = "k" })
local bl = require(t.BodyReplication)

local function bm(bn)
	LPH_ATTRIBUTES(VM(NONE))
	local bo = bk[bn]
	if bo and rawget(bo, "tool") == bn and rawget(bo, "currentMuzzle") then
		return bo
	end
	if not getgc then
		return nil
	end
	for bp, bq in getgc(true) do
		if type(bq) == "table" and rawget(bq, "tool") == bn and rawget(bq, "currentMuzzle") then
			bk[bn] = bq
			return bq
		end
	end
	return nil
end

local function bn(bo)
	LPH_ATTRIBUTES(VM(NONE))
	local bp = workspace.CurrentCamera
	if not (bp and bo) then
		return nil
	end
	local bq = (bp.CFrame.Position - bp.Focus.Position).Magnitude <= 0.75
	local br = bq and bo.viewmodelAttachment or bo.attachment
	if not br then
		return nil
	end
	local bs = br.WorldPosition
	local bt = br.WorldCFrame.LookVector
	local bu = h.Character
	local bv = bu and bu:FindFirstChild("Right Arm")
	if bv then
		local bw = (bs - bv.CFrame.Position).Magnitude
		a9.FilterType = Enum.RaycastFilterType.Exclude
		a9.FilterDescendantsInstances = { bu, workspace:FindFirstChild("Ignore") }
		local bx = workspace:Raycast(bs - bt * bw, bt * bw, a9)
		if bx then
			bs = bx.Position - bt * math.min(0.01, bx.Distance)
		end
	end
	return bs
end

local function bo()
	LPH_ATTRIBUTES(VM(NONE))
	local bp = h.Character
	local bq = ah.volleyFrom(a4) or ah.fireVolleyFn
	if not (bp and bq) then
		return
	end
	local br = ae()
	if not br then
		return
	end
	local bs = bm(br)
	local bt = bs and bs.currentMuzzle
	if not (bt and bt.tool) then
		return
	end
	local bu = bn(bt)
	if not bu then
		return
	end
	local bv = bt.magazine and bt.magazine:getBulletIndex()
	if not bv then
		return
	end

	local bw = bt.index
	local bx = a7(br, bw)
	local by = (bx and bx.Firerate) or 600
	local bz = (bx and bx.Ammo) or 30
	local bA = (bx and bx.ReloadTime) or 3
	local bB = bx and bx.BulletSettings and bx.BulletSettings[bv]
	local bC = ((bB and bB.Penetration) or 0) / 10

	if br ~= bj then
		bj = br
		E = 0
		bi = 0
	end

	if os.clock() < bi then
		return
	end

	if bz > 0 and E >= bz then
		if ad.ragebotautoreload then
			be(bw, bv)
			bi = os.clock() + bA
			E = 0
		end
		return
	end

	if os.clock() < bh then
		return
	end

	local bD = { bp }
	local bE = workspace:FindFirstChild("Ignore")
	if bE then
		bD[#bD + 1] = bE
	end

	local bF = h
	local bG = bF.Team
	local bH = b("ragebotrangecheck", false) and c("ragebotmaxrange", 500)
	local bI = bH and bH * bH
	local bJ = {}
	for bK, bL in e:GetPlayers() do
		local bM = bL.Character
		if bL == bF or not bM or (bG and bL.Team == bG) then
			continue
		end
		local bN = O(bM, "HumanoidRootPart") or O(bM, "Head")
		if not bN then
			continue
		end
		local bO = bN.Position - bu
		local bP = bO:Dot(bO)
		if bI and bP > bI then
			continue
		end
		local bQ = P(bM, "Humanoid")
		if bQ and bQ.Health > 0 and not D(bM) then
			bJ[#bJ + 1] = { Character = bM, Distance = bP }
		end
	end

	table.sort(bJ, function(bK, bL)
		return bK.Distance < bL.Distance
	end)
	local bK
	for bL, bM in ipairs(bJ) do
		bK = bg(bM.Character, bu, bC, bD)
		if bK then
			break
		end
	end
	local bL = bu
	local bM = bK
	if ad.manipulation and am then
		bM = nil
		bL = nil
		local bN = {}
		if bK then
			bN[1] = bK.Parent
		end
		for bO, bP in bJ do
			if bP.Character ~= (bK and bK.Parent) then
				bN[#bN + 1] = bP.Character
			end
		end
		for bO, bP in bN do
			local bQ = bP:FindFirstChild("Head") or bP:FindFirstChild("HumanoidRootPart")
			if bQ then
				local bR = am(bu, bQ.Position, bP, bC, bD)
				if bR then
					local bS = bg(bP, bR, bC, bD)
					if bS then
						bM = bS
						bL = bR
						break
					end
				end
			end
		end
	end

	if bM and bL and ah.fire.func then
		local bN = bM.Position
		if B(bx, bB) then
			bN = C(bL, bM, bx, bB)
		end
		
		
		
		local bO = (bN - bL).Unit
		local bP = O(bp, "HumanoidRootPart")
		if bP then
			local bQ = ad.antiaimspin
			if bQ or math.abs(ax(bP, bO)) > 2.2 then
				av(bO, 0.5)
				if not bQ then
					at.faceRoot = true
				end
				local bR = h:GetNetworkPing() * 2 + 0.05
				if os.clock() - at.since < bR then
					return
				end
			end
		end
		bh = os.clock() + 60 / by
		ap = bL
		an = bN
		ao = bM
		local bQ = pcall(ah.fire.func, bt, bv)
		ap = nil
		an = nil
		ao = nil
		if not bQ then
			bh = 0
		end
	end
end

local bp = 0
local function bq()
	LPH_ATTRIBUTES(VM(NONE))
	if not ad.ragebottpaura then
		return
	end
	if os.clock() - bp < 2.0 then
		return
	end

	local br = h
	local bs = br.Character
	if not bs then
		return
	end
	local bt = bs:FindFirstChild("HumanoidRootPart")
	local bu = bs:FindFirstChild("Head") or bt
	if not (bt and bu) then
		return
	end
	local bv = bu.Position

	local bw = { bs }
	local bx = workspace:FindFirstChild("Ignore")
	if bx then
		bw[#bw + 1] = bx
	end

	local by = false
	local bz, bA

	for bB, bC in ipairs(e:GetPlayers()) do
		if bC ~= br and bC.Character and not D(bC.Character) then
			if not (br.Team and bC.Team == br.Team) then
				local bD = bC.Character:FindFirstChildOfClass("Humanoid")
				local bE = bC.Character:FindFirstChild("HumanoidRootPart")
				local bF = bC.Character:FindFirstChild("Head") or bE
				if bD and bD.Health > 0 and bE then
					local bG = bF.Position - bv
					local bH = RaycastParams.new()
					bH.FilterType = Enum.RaycastFilterType.Exclude
					bH.FilterDescendantsInstances = bw
					local bI = workspace:Raycast(bv, bG, bH)

					if not bI or bI.Instance:IsDescendantOf(bC.Character) then
						by = true
						break
					end

					local bJ = (bE.Position - bv).Magnitude
					if not bA or bJ < bA then
						bz = bC.Character
						bA = bJ
					end
				end
			end
		end
	end

	if not by and bz then
		local bB = bz:FindFirstChild("HumanoidRootPart")
		if bB and bt then
			bp = os.clock()
			bt.CFrame = bB.CFrame * CFrame.new(0, 0, 3)
		end
	end
end

local br = 0
local function bs(bt)
	LPH_ATTRIBUTES(VM(NONE))
	if not (ad.ragebot or ad.ragebottpaura) then
		return
	end
	
	if at.faceRoot then
		local bu = aw()
		local bv = h.Character
		local bw = bu and bv and O(bv, "HumanoidRootPart")
		if bw then
			bw.CFrame = CFrame.new(bw.Position) * CFrame.Angles(0, math.atan2(-bu.X, -bu.Z), 0)
		else
			at.faceRoot = false
		end
	end
	br = br + bt
	if br < 0.03 then
		return
	end
	br = 0
	if ad.ragebot then
		pcall(bo)
	end
	if ad.ragebottpaura then
		pcall(bq)
	end
end

local bt
local bu, bv = pcall(function()
	LPH_ATTRIBUTES(VM(NONE))
	return loadstring(
		game:HttpGet("https://raw.githubusercontent.com/ttokennxyz/vaultcc/refs/heads/main/esplibcoldwar.lua")
	)()
end)

if bu and type(bv) == "table" then

	pcall(function()
		bv:Load({ Enabled = false, Players = false, LocalPlayer = false, LimitFPS = 45, DynamicBoxes = false })
		bt = bv:GetConfig()
	end)
else
	print(bv)
	bv = nil
	j:Notify("Failed to load ESP library.")
end
	ac.ESP = bv

local function bw()
	local bx = bt
	if not bx then
		return
	end

	bx.Enabled = Toggles.ESPMaster.Value
	bx.LocalPlayer = false
	bx.MaxDistance = Options.ESPMaxDistance.Value
	bx.LimitFPS = 45
	bx.DynamicBoxes = false
	bx.DynamicBoxesCheap = true
	bx.DynamicBoxesIncludeAll = false

	bx.Boxes = Toggles.ESPBoxes.Value
	bx.BoxType = Options.ESPBoxType.Value
	bx.BoxColor = Options.ESPBoxColor.Value
	bx.BoxThickness = Options.ESPBoxThickness.Value
	bx.Outlines.Style = Toggles.ESPBoxOutline.Value and "Full" or "None"
	bx.Outlines.Color = Options.ESPBoxOutlineColor.Value

	bx.BoxFill.Enabled = Toggles.ESPBoxFill.Value
	bx.BoxFill.Color = Options.ESPBoxFillColor.Value
	bx.BoxFill.Transparency = Options.ESPBoxFillTransparency.Value

	bx.Names = Toggles.ESPNames.Value
	bx.TextColor = Options.ESPNameColor.Value
	bx.TextSize = Options.ESPTextSize.Value
	bx.TextOutline = Toggles.ESPTextOutline.Value
	bx.Distance.Enabled = Toggles.ESPDistance.Value
	bx.Distance.Color = Options.ESPDistanceColor.Value
	bx.Weapon.Enabled = Toggles.ESPWeapon.Value
	bx.Weapon.UseToolFallback = true
	bx.TeamIndicator.Enabled = Toggles.ESPTeam.Value
	bx.FriendlyIndicator.Enabled = Toggles.ESPFriendly.Value
	bx.FriendlyIndicator.CheckTeam = Toggles.ESPFriendly.Value
	bx.FriendlyIndicator.CheckFriends = Toggles.ESPFriendly.Value

	bx.HealthBar.Enabled = Toggles.ESPHealth.Value
	bx.HealthBar.ShowText = true
	bx.HealthBar.Source = (Options.ESPHealthMode.Value == "Target part") and "Part" or "Average"
	bx.HealthBar.Part = c("silenttarget", "Head")

	bx.Chams.Enabled = Toggles.ESPChams.Value
	bx.Chams.Type = Options.ESPChamsType.Value

	local by = Options.ESPChamsFill.Value
	local bz = Options.ESPChamsFillT.Value
	local bA = Options.ESPChamsOutline.Value
	local bB = Options.ESPChamsOutlineT.Value
	local bC = Toggles.ESPChamsVisible.Value

	bx.Chams.Highlight.FillColor = by
	bx.Chams.Highlight.FillTransparency = bz
	bx.Chams.Highlight.OutlineColor = bA
	bx.Chams.Highlight.OutlineTransparency = bB
	bx.Chams.Highlight.VisibleCheck = bC

	bx.Chams.MeshChams.FillColor = by
	bx.Chams.MeshChams.FillTransparency = bz
	bx.Chams.MeshChams.OutlineColor = bA
	bx.Chams.MeshChams.OutlineTransparency = bB
	bx.Chams.MeshChams.VisibleCheck = bC

	bx.Chams.Adornment.Color = by
	bx.Chams.Adornment.Transparency = bz
	bx.Chams.Adornment.VisibleCheck = bC

	bx.Flags.Enabled = Toggles.ESPFlags.Value
	bx.Flags.Options.Idle = Toggles.ESPFlagIdle.Value
	bx.Flags.Options.Moving = Toggles.ESPFlagMoving.Value
	bx.Flags.Options.Jumping = Toggles.ESPFlagJumping.Value
	bx.Flags.Options.Swimming = Toggles.ESPFlagSwimming.Value
	bx.OffScreenArrows.Enabled = Toggles.ESPArrows.Value
	bx.OffScreenArrows.Color = Options.ESPArrowColor.Value
	bx.OffScreenArrows.Size = Options.ESPArrowSize.Value
end

local function bx()
	local by = bt
	if not by then
		return
	end

	local bz = h

	if Toggles.ESPFilterTeam.Value then
		by.Players = false
		local bA = {}
		for bB, bC in ipairs(e:GetPlayers()) do
			if bC ~= bz and bC.Character then

				if not (bz.Team and bC.Team == bz.Team) then
					bA[#bA + 1] = { DisplayName = bC.Name, Path = bC.Character:GetFullName() }
				end
			end
		end
		by.Directories = bA
	else

		by.Players = true
		by.Directories = {}
	end
end

local by = k.Combat:AddRightGroupbox("Gun Mods")
by:AddSlider("recoilmult", { Text = "Recoil Multiplier", Default = 0, Min = 0, Max = 1, Rounding = 2 })
by:AddSlider("spreadmult", { Text = "Spread Multiplier", Default = 0, Min = 0, Max = 1, Rounding = 2 })
by:AddToggle("forceauto", { Text = "Force Auto", Default = true })
by:AddToggle("instantequip", { Text = "Instant Equip", Default = false })
by:AddToggle("nodrop", { Text = "No Bullet Drop", Default = false })
by:AddToggle("instantbullet", { Text = "Instant Bullet", Default = false })
by:AddToggle(
	"rpgprediction",
	{
		Text = "RPG Prediction",
		Default = true,
	}
)
by:AddSlider(
	"rpgpredictionstrength",
	{ Text = "RPG Prediction Strength", Default = 1, Min = 0, Max = 2, Rounding = 2 }
)

local bz = k.Combat:AddLeftGroupbox("Aiming")
bz
	:AddToggle("aimbotenabled", { Text = "Aimbot Enabled", Default = false })
	:AddKeyPicker("aimbotkey", { Default = "R", SyncToggleState = false, Mode = "Hold", Text = "Aimbot Key" })
bz:AddDropdown("aimbotmethod", { Text = "Aim Method", Values = { "Camera", "Mouse" }, Default = 1, Multi = false })
bz:AddDropdown(
	"aimbottarget",
	{
		Text = "Target part",
		Values = { "Head", "Torso", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg" },
		Default = 1,
		Multi = false,
	}
)
bz:AddSlider(
	"aimbotsmoothness",
	{
		Text = "Smoothness",
		Default = 1,
		Min = 1,
		Max = 20,
		Rounding = 1,
	}
)
bz:AddToggle("aimanywhere", { Text = "Aim Anywhere", Default = true })
bz:AddToggle("instantads", { Text = "Instant ADS", Default = true })
bz:AddToggle("noadsslowdown", { Text = "No ADS Slowdown", Default = true })

local bA = k.Combat:AddLeftGroupbox("Silent Aim")
bA
	:AddToggle(
		"silentenabled",
		{ Text = "Normal Silent Aim", Default = true }
	)
	:AddKeyPicker(
		"silentbind",
		{ Default = "None", SyncToggleState = true, Mode = "Toggle", Text = "Normal Silent Aim" }
	)
bA
	:AddToggle(
		"turretsilentenabled",
		{ Text = "Turret Silent Aim", Default = true }
	)
	:AddKeyPicker(
		"turretsilentbind",
		{ Default = "None", SyncToggleState = true, Mode = "Toggle", Text = "Turret Silent Aim" }
	)
bA:AddDropdown(
	"silenttarget",
	{
		Text = "Target part",
		Values = { "Head", "Torso", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg" },
		Default = 1,
		Multi = false,
	}
)
Options["silenttarget"]:OnChanged(function(bB)
	if bt then
		bt.HealthBar.Part = bB
	end
end)
bA:AddToggle(
	"silentvisiblecheck",
	{ Text = "Visible Check", Default = false }
)
bA:AddToggle(
	"silentdistancecheck",
	{ Text = "Distance Check", Default = false }
)
bA:AddSlider(
	"silentmaxdistance",
	{ Text = "Max Distance", Default = 500, Min = 10, Max = 2000, Rounding = 0, Suffix = " studs" }
)
bA:AddToggle("fovenabled", { Text = "FOV Circle", Default = false })
bA:AddSlider("fovsize", { Text = "FOV Circle Size", Default = 100, Min = 5, Max = 500, Rounding = 0 })
bA:AddToggle("silentteamcheck", { Text = "Exclude Teammates", Default = true })
bA:AddToggle("fovdraw", { Text = "Draw FOV Circle", Default = false })
bA
	:AddLabel("FOV color")
	:AddColorPicker("fovcolor", { Default = Color3.fromRGB(255, 255, 255), Title = "FOV color" })
bA:AddSlider("fovthickness", { Text = "FOV Thickness", Default = 1, Min = 1, Max = 10, Rounding = 0 })
bA:AddToggle("snaplines", { Text = "Snapline", Default = false })
bA
	:AddLabel("Snapline color")
	:AddColorPicker("snaptargetcolor", { Default = Color3.fromRGB(255, 0, 0), Title = "Snapline color" })

do

    local bB = k.Combat:AddRightGroupbox("Ragebot")
    bB
    	:AddToggle("ragebot", { Text = "Enabled", Default = false })
    	:AddKeyPicker("ragebotbind", { Default = "None", SyncToggleState = true, Mode = "Toggle", Text = "Ragebot" })
    bB:AddToggle(
    	"ragebotwallbang",
    	{ Text = "Wallbang", Default = false }
    )
    bB:AddToggle("ragebotrangecheck", { Text = "Max Range", Default = false })
    bB:AddSlider("ragebotmaxrange", { Text = "Range", Default = 500, Min = 25, Max = 3000, Rounding = 0, Suffix = " studs" })
    bB:AddToggle(
    	"ragebotautoreload",
    	{ Text = "Auto Reload", Default = false }
    )
    bB:AddToggle(
    	"ragebottpaura",
    	{ Text = "TP Aura", Default = false }
    )
    bB:AddToggle("manipulation", { Text = "Manipulation", Default = false })
    bB:AddSlider("manipulationdistance", {
    	Text = "Manipulation Distance",
    	Default = 1,
    	Min = 0,
    	Max = 4,
    	Rounding = 2,
    	Suffix = " studs",
    })
    bB:AddDropdown("manipulationdepth", {
    	Text = "Scan Depth",
    	Values = { "Low", "Medium", "High" },
    	Default = 1,
    	Multi = false,
    })
end

local bB = Instance.new("ScreenGui")
bB.Name = "cwfov"
bB.IgnoreGuiInset = true
bB.ResetOnSpawn = false
bB.DisplayOrder = 100
bB.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local bC = Instance.new("Frame")
bC.AnchorPoint = Vector2.new(0.5, 0.5)
bC.BackgroundTransparency = 1
bC.BorderSizePixel = 0
bC.Visible = false
bC.Parent = bB

local bD = Instance.new("UICorner")
bD.CornerRadius = UDim.new(1, 0)
bD.Parent = bC

local bE = Instance.new("UIStroke")
bE.Thickness = 1
bE.Color = Color3.fromRGB(255, 255, 255)
bE.Parent = bC


local bF = { x = -1, y = -1, r = -1, thick = -1, color = nil, shown = false }
local function bG()
	LPH_ATTRIBUTES(VM(NONE))
	if not ad.fovdraw then
		if bF.shown then
			bF.shown = false
			bC.Visible = false
		end
		return
	end
	local bH = N(g)
	local bI, bJ = bH.X, bH.Y
	local bK = c("fovsize", 100)
	local bL = bF
	if bK ~= bL.r then
		bL.r = bK
		bC.Size = UDim2.fromOffset(bK + bK, bK + bK)
	end
	if bI ~= bL.x or bJ ~= bL.y then
		bL.x, bL.y = bI, bJ
		bC.Position = UDim2.fromOffset(bI, bJ)
	end
	local bM = c("fovthickness", 1)
	if bM ~= bL.thick then
		bL.thick = bM
		bE.Thickness = bM
	end
	local bN = c("fovcolor", Color3.new(1, 1, 1))
	if bN ~= bL.color then
		bL.color = bN
		bE.Color = bN
	end
	if not bL.shown then
		bL.shown = true
		bC.Visible = true
	end
end

local bH = Instance.new("ScreenGui")
bH.Name = "cwsnap"
bH.IgnoreGuiInset = true
bH.ResetOnSpawn = false
bH.DisplayOrder = 100
bH.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local bI = Instance.new("Frame")
bI.AnchorPoint = Vector2.new(0.5, 0.5)
bI.BorderSizePixel = 0
bI.Visible = false
bI.Parent = bH

local bJ = 180 / math.pi
local bK = false
local function bL()
	LPH_ATTRIBUTES(VM(NONE))
	local bM = d.target
	local bN = workspace.CurrentCamera
	if ad.snaplines and bM and bM.Parent and bN then
		local bO, bP = M(bN, bM.Position)
		if bP then
			local bQ = N(g)
			local bR, bS = bQ.X, bQ.Y
			local bT, bU = bO.X - bR, bO.Y - bS
			bI.Size = UDim2.fromOffset(math.sqrt(bT * bT + bU * bU), 1)
			bI.Position = UDim2.fromOffset(bR + bT * 0.5, bS + bU * 0.5)
			bI.Rotation = math.atan2(bU, bT) * bJ
			bI.BackgroundColor3 = c("snaptargetcolor", Color3.fromRGB(255, 0, 0))
			if not bK then
				bK = true
				bI.Visible = true
			end
			return
		end
	end
	if bK then
		bK = false
		bI.Visible = false
	end
end

	ac.functions = ah
	ac.espCfg = bt
	ac.applyESP = bw
	ac.refreshTeamFilter = bx
	ac.cars = {
		entries = X,
		defaults = T,
		boolDefaults = U,
		choiceDefaults = V,
		state = aY,
		apply = aZ,
		profile = a_,
		setControl = a0,
		syncJson = aU,
		loadJson = aV,
	}

	ac.combat = {
		targetStep = af,
		aimbotRenderStep = ag,
		fovRenderStep = bG,
		snapRenderStep = bL,
		rageSchedulerStep = bs,
		autoHealStep = aN,
		fastReviveStep = S,
		carModsStep = a2,
		applyESP = bw,
		refreshTeamFilter = bx,
		debug = { shift = function(...) return am(...) end, canDamage = bd, penetrable = bc },
		unload = function()
			
			s.Shake = ar
			q.new = aJ
			if bB then
				bB:Destroy()
				bB = nil
			end
			if bH then
				bH:Destroy()
				bH = nil
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
local aw = an.ESP:AddLeftGroupbox("Main")
aw:AddToggle("ESPMaster", { Text = "Enabled", Default = false })
aw:AddToggle(
	"ESPFilterTeam",
	{ Text = "Filter teammates", Default = false }
)
aw:AddSlider(
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

local ax = an.ESP:AddLeftGroupbox("Boxes")
ax:AddToggle("ESPBoxes", { Text = "Boxes", Default = true })
ax:AddDropdown("ESPBoxType", { Text = "Box type", Values = { "Normal", "Corner" }, Default = 1, Multi = false })
ax
	:AddLabel("Box color")
	:AddColorPicker("ESPBoxColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Box color" })
ax:AddSlider("ESPBoxThickness", { Text = "Box thickness", Default = 1, Min = 1, Max = 6, Rounding = 0 })
ax:AddToggle("ESPBoxOutline", { Text = "Box outline", Default = true })
ax
	:AddLabel("Outline color")
	:AddColorPicker("ESPBoxOutlineColor", { Default = Color3.fromRGB(0, 0, 0), Title = "Outline color" })
ax:AddDivider()
ax:AddToggle("ESPBoxFill", { Text = "Box fill", Default = false })
ax
	:AddLabel("Fill color")
	:AddColorPicker("ESPBoxFillColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Fill color" })
ax:AddSlider(
	"ESPBoxFillTransparency",
	{ Text = "Fill transparency", Default = 0.9, Min = 0, Max = 1, Rounding = 2 }
)

local ay = an.ESP:AddRightGroupbox("Chams")
ay:AddToggle("ESPChams", { Text = "Chams", Default = false })
ay:AddDropdown(
	"ESPChamsType",
	{
		Text = "Chams type",
		Values = { "Highlight", "Adornment", "MeshChams" },
		Default = 1,
		Multi = false,
	}
)
ay
	:AddLabel("Fill color")
	:AddColorPicker("ESPChamsFill", { Default = Color3.fromRGB(59, 144, 204), Title = "Cham fill" })
ay:AddSlider("ESPChamsFillT", { Text = "Fill transparency", Default = 0.6, Min = 0, Max = 1, Rounding = 2 })
ay
	:AddLabel("Outline color")
	:AddColorPicker("ESPChamsOutline", { Default = Color3.fromRGB(255, 255, 255), Title = "Cham outline" })
ay:AddSlider("ESPChamsOutlineT", { Text = "Outline transparency", Default = 0, Min = 0, Max = 1, Rounding = 2 })
ay:AddToggle(
	"ESPChamsVisible",
	{ Text = "Visible check", Default = false }
)

local az = an.ESP:AddLeftGroupbox("Names & Info")
az:AddToggle("ESPNames", { Text = "Names", Default = true })
az
	:AddLabel("Name color")
	:AddColorPicker("ESPNameColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Name color" })
az:AddSlider("ESPTextSize", { Text = "Text size", Default = 12, Min = 6, Max = 28, Rounding = 0 })
az:AddToggle("ESPTextOutline", { Text = "Text outline", Default = true })
az:AddDivider()
az:AddToggle("ESPDistance", { Text = "Distance", Default = false })
az
	:AddLabel("Distance color")
	:AddColorPicker("ESPDistanceColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Distance color" })
az:AddToggle("ESPWeapon", { Text = "Weapon", Default = false })
az:AddToggle("ESPTeam", { Text = "Team indicator", Default = false })
az:AddToggle(
	"ESPFriendly",
	{ Text = "Friendly indicator", Default = false }
)

local aA = an.ESP:AddRightGroupbox("Health")
aA:AddToggle("ESPHealth", { Text = "Health", Default = false })
aA:AddDropdown(
	"ESPHealthMode",
	{
		Text = "Health mode",
		Values = { "Average", "Target part" },
		Default = 1,
		Multi = false,
	}
)

local aB = an.ESP:AddRightGroupbox("Flags & Arrows")
aB:AddToggle("ESPFlags", { Text = "Status flags", Default = false })
aB:AddToggle("ESPFlagIdle", { Text = "Flag: Idle", Default = false })
aB:AddToggle("ESPFlagMoving", { Text = "Flag: Moving", Default = false })
aB:AddToggle("ESPFlagJumping", { Text = "Flag: Jumping", Default = false })
aB:AddToggle("ESPFlagSwimming", { Text = "Flag: Swimming", Default = false })
aB:AddDivider()
aB:AddToggle("ESPArrows", { Text = "Off-screen arrows", Default = false })
aB
	:AddLabel("Arrow color")
	:AddColorPicker("ESPArrowColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Arrow color" })
aB:AddSlider("ESPArrowSize", { Text = "Arrow size", Default = 14, Min = 8, Max = 40, Rounding = 0 })

local aC = {
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
local aD = {
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

for aE, aF in ipairs(aC) do
	Toggles[aF]:OnChanged(ac.applyESP)
end
for aE, aF in ipairs(aD) do
	Options[aF]:OnChanged(ac.applyESP)
end

Toggles.ESPFilterTeam:OnChanged(ac.refreshTeamFilter)

ac.applyESP()
ac.refreshTeamFilter()

local aE = 0
local function aF(aG)
	LPH_ATTRIBUTES(VM(NONE))
	if not ac.ESP or not ac.espCfg or not ad.ESPMaster then
		return
	end
	aE = aE + aG
	if aE < 1 then
		return
	end
	aE = 0
	ac.refreshTeamFilter()
end

local aG = game:GetService("Lighting")
local aH = {
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
local aI = {
	Atmosphere = { "Color", "Decay", "Density", "Offset", "Haze", "Glare" },
	BloomEffect = { "Enabled", "Intensity", "Size", "Threshold" },
	ColorCorrectionEffect = { "Enabled", "Brightness", "Contrast", "Saturation", "TintColor" },
	SunRaysEffect = { "Enabled", "Intensity", "Spread" },
	DepthOfFieldEffect = { "Enabled", "FarIntensity", "NearIntensity", "FocusDistance", "InFocusRadius" },
	BlurEffect = { "Enabled", "Size" },
}
local aJ = { Lighting = {}, Effects = {} }
local aK = {}
for aL, aM in ipairs(aH) do
	aJ.Lighting[aM] = aG[aM]
end
for aL, aM in ipairs(aG:GetDescendants()) do
	local aN = aI[aM.ClassName]
	if aN then
		aK[#aK + 1] = aM
		local aO = {}
		for aP, aQ in ipairs(aN) do
			aO[aQ] = aM[aQ]
		end
		aJ.Effects[aM] = aO
	end
end

local aL = aG:FindFirstChildOfClass("Atmosphere")
local aM = aG:FindFirstChildOfClass("BloomEffect")
local aN = aG:FindFirstChildOfClass("ColorCorrectionEffect")
local aO = aG:FindFirstChildOfClass("SunRaysEffect")
local aP = aG:FindFirstChild("DepthOfField")
local aQ = aG:FindFirstChildOfClass("BlurEffect")

local function aR()
	for aS, aT in pairs(aJ.Lighting) do
		aG[aS] = aT
	end
	for aS, aT in pairs(aJ.Effects) do
		if aS.Parent then
			for aU, aV in pairs(aT) do
				aS[aU] = aV
			end
		end
	end
end

local function aS(aT, aU, aV)
	if aT[aU] ~= aV then
		aT[aU] = aV
	end
end

local function aT()
	LPH_ATTRIBUTES(VM(NONE))
	if not ae("lightingoverride", false) then
		return
	end
	local aU = af("fogstart", aJ.Lighting.FogStart)
	aS(aG, "GlobalShadows", ae("globalshadows", aJ.Lighting.GlobalShadows))
	aS(aG, "Brightness", af("lightingbrightness", aJ.Lighting.Brightness))
	aS(aG, "ClockTime", af("clocktime", aJ.Lighting.ClockTime))
	aS(
		aG,
		"ExposureCompensation",
		af("exposure", aJ.Lighting.ExposureCompensation)
	)
	aS(aG, "ShadowSoftness", af("shadowsoftness", aJ.Lighting.ShadowSoftness))
	aS(
		aG,
		"EnvironmentDiffuseScale",
		af("diffusescale", aJ.Lighting.EnvironmentDiffuseScale)
	)
	aS(
		aG,
		"EnvironmentSpecularScale",
		af("specularscale", aJ.Lighting.EnvironmentSpecularScale)
	)
	aS(aG, "GeographicLatitude", af("latitude", aJ.Lighting.GeographicLatitude))
	aS(aG, "Ambient", af("ambientcolor", aJ.Lighting.Ambient))
	aS(aG, "OutdoorAmbient", af("outdoorambient", aJ.Lighting.OutdoorAmbient))
	aS(aG, "ColorShift_Top", af("colorshifttop", aJ.Lighting.ColorShift_Top))
	aS(
		aG,
		"ColorShift_Bottom",
		af("colorshiftbottom", aJ.Lighting.ColorShift_Bottom)
	)
	aS(aG, "FogColor", af("fogcolor", aJ.Lighting.FogColor))
	aS(aG, "FogStart", aU)
	aS(aG, "FogEnd", math.max(aU, af("fogend", aJ.Lighting.FogEnd)))

	for aV, aW in ipairs(aK) do
		if not aW.Parent then
			continue
		end
		if aW:IsA("Atmosphere") then
			local aX = aJ.Effects[aW]
			local aY = ae("atmosphereenabled", true)
			aS(aW, "Color", af("atmospherecolor", aX.Color))
			aS(aW, "Decay", af("atmospheredecay", aX.Decay))
			aS(aW, "Density", aY and af("atmospheredensity", aX.Density) or 0)
			aS(aW, "Offset", af("atmosphereoffset", aX.Offset))
			aS(aW, "Haze", aY and af("atmospherehaze", aX.Haze) or 0)
			aS(aW, "Glare", aY and af("atmosphereglare", aX.Glare) or 0)
		elseif aW:IsA("BloomEffect") then
			local aX = aJ.Effects[aW]
			aS(aW, "Enabled", ae("bloomenabled", aX.Enabled))
			aS(aW, "Intensity", af("bloomintensity", aX.Intensity))
			aS(aW, "Size", af("bloomsize", aX.Size))
			aS(aW, "Threshold", af("bloomthreshold", aX.Threshold))
		elseif aW:IsA("ColorCorrectionEffect") then
			local aX = aJ.Effects[aW]
			aS(aW, "Enabled", ae("colorcorrectionenabled", aX.Enabled))
			aS(aW, "Brightness", af("ccbrightness", aX.Brightness))
			aS(aW, "Contrast", af("cccontrast", aX.Contrast))
			aS(aW, "Saturation", af("ccsaturation", aX.Saturation))
			aS(aW, "TintColor", af("cctint", aX.TintColor))
		elseif aW:IsA("SunRaysEffect") then
			local aX = aJ.Effects[aW]
			aS(aW, "Enabled", ae("sunraysenabled", aX.Enabled))
			aS(aW, "Intensity", af("sunraysintensity", aX.Intensity))
			aS(aW, "Spread", af("sunraysspread", aX.Spread))
		elseif aW:IsA("DepthOfFieldEffect") and aW.Name == "DepthOfField" then
			local aX = aJ.Effects[aW]
			aS(aW, "Enabled", ae("dofenabled", aX.Enabled))
			aS(aW, "FarIntensity", af("doffar", aX.FarIntensity))
			aS(aW, "NearIntensity", af("dofnear", aX.NearIntensity))
			aS(aW, "FocusDistance", af("doffocus", aX.FocusDistance))
			aS(aW, "InFocusRadius", af("dofradius", aX.InFocusRadius))
		elseif aW:IsA("BlurEffect") then
			local aX = aJ.Effects[aW]
			aS(aW, "Enabled", ae("blurenabled", aX.Enabled))
			aS(aW, "Size", af("blursize", aX.Size))
		end
	end
end

local aU = an.Visuals:AddRightGroupbox("Lighting")
aU:AddToggle(
	"lightingoverride",
	{
		Text = "Lighting Override",
		Default = false,
	}
)
Toggles.lightingoverride:OnChanged(function(aV)
	if aV then
		aT()
	else
		aR()
	end
end)
aU:AddToggle("globalshadows", { Text = "Global Shadows", Default = aG.GlobalShadows })
aU:AddSlider(
	"lightingbrightness",
	{ Text = "Brightness", Default = aG.Brightness, Min = 0, Max = 10, Rounding = 2 }
)
aU:AddSlider(
	"clocktime",
	{ Text = "Clock Time", Default = aG.ClockTime, Min = 0, Max = 24, Rounding = 2, Suffix = " h" }
)
aU:AddSlider(
	"exposure",
	{ Text = "Exposure", Default = aG.ExposureCompensation, Min = -5, Max = 5, Rounding = 2 }
)
aU:AddSlider(
	"shadowsoftness",
	{ Text = "Shadow Softness", Default = aG.ShadowSoftness, Min = 0, Max = 1, Rounding = 2 }
)
aU:AddSlider(
	"diffusescale",
	{ Text = "Environment Diffuse", Default = aG.EnvironmentDiffuseScale, Min = 0, Max = 1, Rounding = 2 }
)
aU:AddSlider(
	"specularscale",
	{ Text = "Environment Specular", Default = aG.EnvironmentSpecularScale, Min = 0, Max = 1, Rounding = 2 }
)
aU:AddSlider(
	"latitude",
	{ Text = "Sun Latitude", Default = aG.GeographicLatitude, Min = -180, Max = 180, Rounding = 1, Suffix = "°" }
)
aU:AddLabel("Ambient"):AddColorPicker("ambientcolor", { Default = aG.Ambient, Title = "Ambient" })
aU
	:AddLabel("Outdoor Ambient")
	:AddColorPicker("outdoorambient", { Default = aG.OutdoorAmbient, Title = "Outdoor Ambient" })
aU
	:AddLabel("Color Shift Top")
	:AddColorPicker("colorshifttop", { Default = aG.ColorShift_Top, Title = "Color Shift Top" })
aU
	:AddLabel("Color Shift Bottom")
	:AddColorPicker("colorshiftbottom", { Default = aG.ColorShift_Bottom, Title = "Color Shift Bottom" })

local aV = an.Visuals:AddRightGroupbox("Fog & Atmosphere")
aV:AddLabel("Fog Color"):AddColorPicker("fogcolor", { Default = aG.FogColor, Title = "Fog Color" })
aV:AddSlider(
	"fogstart",
	{ Text = "Fog Start", Default = aG.FogStart, Min = 0, Max = 10000, Rounding = 0, Suffix = " studs" }
)
aV:AddSlider(
	"fogend",
	{
		Text = "Fog End",
		Default = math.min(aG.FogEnd, 100000),
		Min = 0,
		Max = 100000,
		Rounding = 0,
		Suffix = " studs",
	}
)
aV:AddToggle("atmosphereenabled", { Text = "Atmosphere", Default = true })
aV:AddLabel("Atmosphere Color"):AddColorPicker(
	"atmospherecolor",
	{ Default = aL and aL.Color or Color3.new(1, 1, 1), Title = "Atmosphere Color" }
)
aV:AddLabel("Atmosphere Decay"):AddColorPicker(
	"atmospheredecay",
	{ Default = aL and aL.Decay or Color3.new(1, 1, 1), Title = "Atmosphere Decay" }
)
aV:AddSlider(
	"atmospheredensity",
	{ Text = "Density", Default = aL and aL.Density or 0, Min = 0, Max = 1, Rounding = 3 }
)
aV:AddSlider(
	"atmosphereoffset",
	{ Text = "Offset", Default = aL and aL.Offset or 0, Min = -1, Max = 1, Rounding = 3 }
)
aV:AddSlider(
	"atmospherehaze",
	{ Text = "Haze", Default = aL and aL.Haze or 0, Min = 0, Max = 10, Rounding = 2 }
)
aV:AddSlider(
	"atmosphereglare",
	{ Text = "Glare", Default = aL and aL.Glare or 0, Min = 0, Max = 10, Rounding = 2 }
)

local aW = an.Visuals:AddRightGroupbox("Post Processing")
aW:AddToggle("bloomenabled", { Text = "Bloom", Default = aM and aM.Enabled or false })
aW:AddSlider(
	"bloomintensity",
	{ Text = "Bloom Intensity", Default = aM and aM.Intensity or 0, Min = 0, Max = 10, Rounding = 2 }
)
aW:AddSlider(
	"bloomsize",
	{ Text = "Bloom Size", Default = aM and aM.Size or 24, Min = 0, Max = 56, Rounding = 0 }
)
aW:AddSlider(
	"bloomthreshold",
	{ Text = "Bloom Threshold", Default = aM and aM.Threshold or 2, Min = 0, Max = 10, Rounding = 2 }
)
aW:AddToggle(
	"colorcorrectionenabled",
	{ Text = "Color Correction", Default = aN and aN.Enabled or false }
)
aW:AddSlider(
	"ccbrightness",
	{
		Text = "CC Brightness",
		Default = aN and aN.Brightness or 0,
		Min = -1,
		Max = 1,
		Rounding = 2,
	}
)
aW:AddSlider(
	"cccontrast",
	{
		Text = "CC Contrast",
		Default = aN and aN.Contrast or 0,
		Min = -1,
		Max = 1,
		Rounding = 2,
	}
)
aW:AddSlider(
	"ccsaturation",
	{
		Text = "CC Saturation",
		Default = aN and aN.Saturation or 0,
		Min = -1,
		Max = 1,
		Rounding = 2,
	}
)
aW:AddLabel("CC Tint"):AddColorPicker(
	"cctint",
	{
		Default = aN and aN.TintColor or Color3.new(1, 1, 1),
		Title = "Color Correction Tint",
	}
)
aW:AddToggle(
	"sunraysenabled",
	{ Text = "Sun Rays", Default = aO and aO.Enabled or false }
)
aW:AddSlider(
	"sunraysintensity",
	{
		Text = "Sun Rays Intensity",
		Default = aO and aO.Intensity or 0,
		Min = 0,
		Max = 1,
		Rounding = 3,
	}
)
aW:AddSlider(
	"sunraysspread",
	{ Text = "Sun Rays Spread", Default = aO and aO.Spread or 0, Min = 0, Max = 1, Rounding = 3 }
)
aW:AddToggle(
	"dofenabled",
	{ Text = "Depth of Field", Default = aP and aP.Enabled or false }
)
aW:AddSlider(
	"doffar",
	{
		Text = "DOF Far Intensity",
		Default = aP and aP.FarIntensity or 0,
		Min = 0,
		Max = 1,
		Rounding = 3,
	}
)
aW:AddSlider(
	"dofnear",
	{
		Text = "DOF Near Intensity",
		Default = aP and aP.NearIntensity or 0,
		Min = 0,
		Max = 1,
		Rounding = 3,
	}
)
aW:AddSlider(
	"doffocus",
	{
		Text = "DOF Focus Distance",
		Default = aP and aP.FocusDistance or 10,
		Min = 0,
		Max = 500,
		Rounding = 1,
	}
)
aW:AddSlider(
	"dofradius",
	{
		Text = "DOF Focus Radius",
		Default = aP and aP.InFocusRadius or 30,
		Min = 0,
		Max = 500,
		Rounding = 1,
	}
)
aW:AddToggle("blurenabled", { Text = "Blur", Default = aQ and aQ.Enabled or false })
aW:AddSlider(
	"blursize",
	{ Text = "Blur Size", Default = aQ and aQ.Size or 0, Min = 0, Max = 56, Rounding = 0 }
)



local aX = an.Visuals:AddLeftGroupbox("Camera")
aX:AddToggle("customfov", { Text = "Custom FOV", Default = false })
aX:AddSlider("customfovvalue", { Text = "FOV", Default = 90, Min = 40, Max = 120, Rounding = 0 })
aX:AddToggle("zoom", { Text = "Zoom", Default = false }):AddKeyPicker("zoombind", {
	Default = "None",
	Mode = "Hold",
	Text = "Zoom",
	NoUI = false,
})
aX:AddDropdown("zoommode", { Text = "Zoom Mode", Values = { "Hold", "Toggle" }, Default = 1 })
aX:AddSlider("zoomfov", { Text = "Zoom FOV", Default = 25, Min = 5, Max = 60, Rounding = 0 })

aX:AddToggle("maxzoom", { Text = "Max Zoom Out", Default = false })
aX:AddSlider("maxzoomdistance", { Text = "Zoom Distance", Default = 30, Min = 6, Max = 400, Rounding = 0, Suffix = " studs" })


local function aY()
	task.spawn(pcall, function()
		require(al.Client.Character.CameraController)._applyZoomRange()
	end)
end
local aZ = false
Toggles.maxzoom:OnChanged(function(a_)
	if aZ and not a_ then
		aY()
	end
	aZ = a_
end)
Options.zoommode:OnChanged(function(a_)
	local a0 = Options.zoombind
	if a0 then
		a0.Mode = a_
		a0.Toggled = false
		pcall(a0.Update, a0)
	end
end)

local a_ = 70
local a0 = nil
local function a1()
	LPH_ATTRIBUTES(VM(NONE))
	if ae("maxzoom", false) then
		local a2 = af("maxzoomdistance", 30)
		
		if ak.CameraMaxZoomDistance ~= a2 then
			ak.CameraMaxZoomDistance = a2
		end
	end
	local a2 = workspace.CurrentCamera
	if not a2 then
		return
	end
	local a3 = ae("customfov", false)
	local a4 = Options.zoombind
	local a5 = ae("zoom", false) and a4 and a4:GetState()
	if not (a3 or a5) then
		a0 = nil
		return
	end
	local a6 = a2.FieldOfView
	if a6 == a0 then
		
		return
	end
	local a7
	if a5 then
		a7 = af("zoomfov", 25)
	else
		
		a7 = a6 * (af("customfovvalue", 90) / a_)
	end
	a7 = math.clamp(a7, 1, 120)
	a2.FieldOfView = a7
	a0 = a7
end

local a2 = an.Visuals:AddLeftGroupbox("Bullet Tracers")
a2:AddToggle("tracersenabled", { Text = "Bullet Tracers Enabled", Default = false })

a2:AddToggle("teamtracers", { Text = "Draw Team Tracers", Default = false })
a2:AddLabel("Team Tracers Color")
	:AddColorPicker("teamtracerscolor", { Default = Color3.fromRGB(59, 144, 204), Title = "Team Tracer Color" })
a2:AddDropdown(
	"teamtracersmaterial",
	{
		Text = "Team Tracer Material",
		Values = { "Plastic", "SmoothPlastic", "ForceField", "Neon", "Glass" },
		Default = 1,
		Multi = false,
	}
)
a2:AddSlider(
	"teamtracerstransparency",
	{
		Text = "Team Tracer Transparency",
		Default = 0.5,
		Min = 0,
		Max = 1,
		Rounding = 2,
	}
)

a2:AddToggle("enemytracers", { Text = "Draw Enemy Tracers", Default = false })
a2:AddLabel("Enemy Tracers Color")
	:AddColorPicker("enemytracerscolor", { Default = Color3.fromRGB(255, 60, 60), Title = "Enemy Tracer Color" })
a2:AddDropdown(
	"enemytracersmaterial",
	{
		Text = "Enemy Tracer Material",
		Values = { "Plastic", "SmoothPlastic", "ForceField", "Neon", "Glass" },
		Default = 1,
		Multi = false,
	}
)
a2:AddSlider(
	"enemytracerstransparency",
	{
		Text = "Enemy Tracer Transparency",
		Default = 0.5,
		Min = 0,
		Max = 1,
		Rounding = 2,
	}
)
a2:AddToggle("localtracers", { Text = "Draw Local Tracers", Default = false })
a2:AddLabel("Local Tracers Color")
	:AddColorPicker("localtracerscolor", { Default = Color3.fromRGB(59, 255, 50), Title = "Local Tracer Color" })
a2:AddDropdown(
	"localtracersmaterial",
	{
		Text = "Local Tracer Material",
		Values = { "Plastic", "SmoothPlastic", "ForceField", "Neon", "Glass" },
		Default = 1,
		Multi = false,
	}
)
a2:AddSlider(
	"localtracerstransparency",
	{
		Text = "Local Tracer Transparency",
		Default = 0.5,
		Min = 0,
		Max = 1,
		Rounding = 2,
	}
)
a2:AddSlider("bullettracersize", { Text = "Bullet Tracer Size", Default = 0.1, Min = 0.01, Max = 1, Rounding = 2 })


	ac.visuals = {
		cameraStep = a1,
		teamFilterStep = aF,
		applyLighting = aT,
		unload = function()
			if ae("maxzoom", false) then
				aY()
			end
			aR()
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
local aw = true
local ax = 10
local ay = 200
local az = Drawing.new("Text")
az.Text = "Moderators\nChecking players..."
az.Position = Vector2.new(ax, ay)
az.Size = 14
az.Color = Color3.fromRGB(255, 255, 255)
az.Outline = true
az.OutlineColor = Color3.fromRGB(0, 0, 0)
az.Visible = aw
local aA = {}
local aB = {}
local aC
local aD

local function aE()
	LPH_ATTRIBUTES(VM(NONE))
	local aF = {}
	for aG, aH in pairs(aA) do
		if aG.Parent == ah and aH.IsModerator then
			local aI = {}
			if aH.Rank >= 240 then
				aI[#aI + 1] = "Rank " .. aH.Rank
			end
			if aH.ControlPanel then
				aI[#aI + 1] = "Control Panel"
			end
			aF[#aF + 1] = {
				SortName = aG.Name:lower(),
				Text = string.format("%s (@%s) [%s]", aG.DisplayName, aG.Name, table.concat(aI, ", ")),
			}
		end
	end
	table.sort(aF, function(aG, aH)
		return aG.SortName < aH.SortName
	end)

	local aG = {}
	for aH, aI in ipairs(aF) do
		aG[#aG + 1] = aI.Text
	end
	if az then
		az.Text = "Moderators\n" .. (#aG > 0 and table.concat(aG, "\n") or "No moderators online")
	end
end

local function aF(aG)
	LPH_ATTRIBUTES(VM(NONE))
	if aB[aG] then
		aB[aG]:Disconnect()
	end

	local aH = aG:GetAttribute("ControlPanelAccess") == true
	local aI = {
		Rank = 0,
		ControlPanel = aH,
		IsModerator = aH,
	}
	aA[aG] = aI
	aE()

	aB[aG] = aG:GetAttributeChangedSignal("ControlPanelAccess"):Connect(function()
		aI.ControlPanel = aG:GetAttribute("ControlPanelAccess") == true
		aI.IsModerator = aI.Rank >= 240 or aI.ControlPanel
		aE()
	end)

	task.spawn(function()
		local aJ, aK = pcall(aG.GetRankInGroup, aG, 32519006)
		if aA[aG] ~= aI then
			return
		end
		aI.Rank = aJ and aK or 0
		aI.IsModerator = aI.Rank >= 240 or aI.ControlPanel
		aE()
	end)
end

local function aG(aH)
	LPH_ATTRIBUTES(VM(NONE))
	if aB[aH] then
		aB[aH]:Disconnect()
		aB[aH] = nil
	end
	aA[aH] = nil
	aE()
end

for aH, aI in ipairs(ah:GetPlayers()) do
	aF(aI)
end
aC = ah.PlayerAdded:Connect(aF)
aD = ah.PlayerRemoving:Connect(aG)

local aH
local aI
local aJ
local function aK(aL)
	if aH then
		aH:Disconnect()
		aH = nil
	end
	local aM = aL
		and (aL:FindFirstChildWhichIsA("Humanoid") or aL:WaitForChild("Humanoid", 5))
	if not aM then
		return
	end
	local aN = false
	local function aO()
		if not ae("walkspeedenabled", false) or aN then
			return
		end
		aN = true
		aM.WalkSpeed = af("walkspeed", 16)
		aN = false
	end
	aO()
	aH = aM:GetPropertyChangedSignal("WalkSpeed"):Connect(aO)
end
local function aL(aM)
	if aJ then
		aJ:Disconnect()
		aJ = nil
	end
	local aN = aM
		and (aM:FindFirstChildWhichIsA("Humanoid") or aM:WaitForChild("Humanoid", 5))
	if not aN then
		return
	end
	local aO = false
	local function aP()
		if not ae("jumppowerenabled", false) or aO then
			return
		end
		aO = true
		aN.UseJumpPower = true
		aN.JumpPower = af("jumppower", 50)
		aO = false
	end
	aP()
	aJ = aN:GetPropertyChangedSignal("JumpPower"):Connect(aP)
end
aI = ak.CharacterAdded:Connect(function(aM)
	aK(aM)
	aL(aM)
end)
aK(ak.Character)
aL(ak.Character)

local aM
local aN
local aO = 0
local function aP(aQ)
	LPH_ATTRIBUTES(VM(NONE))
	if not ad.antiaimspin and not aM then
		return
	end
	local aR = ak.Character
	local aS = aR and aR:FindFirstChildWhichIsA("Humanoid")
	local aT = aR and aR:FindFirstChild("HumanoidRootPart")
	if not (aS and aT) then
		return
	end
	local aU = aS.Sit
		or aS.SeatPart ~= nil
		or ak:GetAttribute("InVehicle") == true
		or aR:GetAttribute("InVehicle") == true
		or aT:FindFirstChild("SeatWeld") ~= nil

	if ad.antiaimspin and not aU then
		if aM ~= aS then
			if aM and aM.Parent and aN ~= nil then
				aM.AutoRotate = aN
			end
			aM = aS
			aN = aS.AutoRotate
			aO = select(2, aT.CFrame:ToOrientation())
		end
		aS.AutoRotate = false
	elseif aM then
		if aM.Parent and aN ~= nil then
			aM.AutoRotate = aN
		end
		aM = nil
		aN = nil
	end

	if ad.antiaimspin and not aU then
		
		local aV = ac.lookHold
		local aW = aV and aV.dir and os.clock() <= aV.untilT and aV.dir
		if aW then
			aO = math.atan2(-aW.X, -aW.Z)
		else
			aO = (aO + math.rad(af("antiaimspinspeed", 180)) * aQ) % math.tau
		end
		aT.CFrame = CFrame.new(aT.Position) * CFrame.Angles(0, aO, 0)
	end
end
do
    local aQ = an.Misc:AddLeftGroupbox("Movement")
    aQ:AddToggle(
    	"walkspeedenabled",
    	{ Text = "WalkSpeed", Default = false }
    )
    Toggles.walkspeedenabled:OnChanged(function(aR)
    	aK(ak.Character)
    end)
    aQ:AddSlider("walkspeed", { Text = "WalkSpeed Value", Default = 16, Min = 0, Max = 50, Rounding = 0 })
    Options.walkspeed:OnChanged(function(aR)
    	aK(ak.Character)
    end)
    aQ:AddToggle(
    	"jumppowerenabled",
    	{ Text = "JumpPower", Default = false }
    )
    Toggles.jumppowerenabled:OnChanged(function(aR)
    	aL(ak.Character)
    end)
    aQ:AddSlider(
    	"jumppower",
    	{
    		Text = "JumpPower Value",
    		Default = 50,
    		Min = 0,
    		Max = 100,
    		Rounding = 0,
    	}
    )
    Options.jumppower:OnChanged(function(aR)
    	aL(ak.Character)
    end)
    aQ:AddToggle("omnisprint", { Text = "Omni Sprint", Default = false })
    aQ:AddToggle(
    	"nohurtslowdown",
    	{ Text = "No Hurt Slowdown", Default = false }
    )

    local aR = an.Misc:AddLeftGroupbox("Anti Aim")
    aR:AddToggle(
    	"antiaimpitch",
    	{
    		Text = "Head Pitch",
    		Default = false,
    	}
    )
    aR:AddSlider(
    	"antiaimpitchangle",
    	{ Text = "Head Pitch Angle", Default = 90, Min = -180, Max = 180, Rounding = 0, Suffix = "°" }
    )
    aR:AddToggle(
    	"gunup",
    	{ Text = "Always Gun Up", Default = false }
    )
    aR:AddToggle("antiaimspin", { Text = "Spin", Default = false })
    Toggles.antiaimspin:OnChanged(function(aS)
    	if not aS and aM then
    		if aM.Parent and aN ~= nil then
    			aM.AutoRotate = aN
    		end
    		aM = nil
    		aN = nil
    	end
    end)
    aR:AddSlider(
    	"antiaimspinspeed",
    	{ Text = "Spin Speed", Default = 180, Min = 0, Max = 1080, Rounding = 0, Suffix = "°/s" }
    )

    local function aS(aT)
    	local aU = aT and aT:FindFirstChild("CharacterValues")
    	if not aU then
    		return
    	end
	if ad.antisuppression then
     		local aV = aU:FindFirstChild("Suppression")
    		local aW = aU:FindFirstChild("Deafening")
    		if aV then
    			aV.Value = 0
    		end
    		if aW then
    			aW.Value = 0
    		end
    	end
    end

    local aT = game:GetService("Lighting"):FindFirstChild("SuppressionDepthOfField")
    local aU = aT and aT.Enabled
    local aV = 0
    function antiEffectsStep(aW)
    	LPH_ATTRIBUTES(VM(NONE))
    	if not (ad.antisuppression or ad.antiflashbang) then
    		return
    	end
    	aV = aV + aW
    	if aV < 0.5 then
    		return
    	end
    	aV = 0
    	aS(ak.Character)

     	if ad.antisuppression then
     		aT = game:GetService("Lighting"):FindFirstChild("SuppressionDepthOfField")
    			or aT
    		if aT and aT:IsA("PostEffect") then
    			aT.Enabled = false
    		end
    	end

     	if ad.antiflashbang then
    		for aX, aY in ipairs({ game:GetService("Lighting"), ak:FindFirstChildOfClass("PlayerGui") }) do
    			if aY then
    				for aZ, a_ in ipairs(aY:GetDescendants()) do
    					local a0 = a_.Name:lower()
    					if
    						a0:find("flash", 1, true)
    						or a0:find("stun", 1, true)
    						or a0:find("concussion", 1, true)
    					then
    						if a_:IsA("PostEffect") then
    							a_.Enabled = false
    						elseif a_:IsA("LayerCollector") then
    							a_.Enabled = false
    						elseif a_:IsA("GuiObject") then
    							a_.Visible = false
    						end
    					end
    				end
    			end
    		end
    	end
    end

    local aW = an.Misc:AddLeftGroupbox("Screen Effects")
    aW:AddToggle(
    	"antisuppression",
    	{
    		Text = "Anti Suppression",
    		Default = false,
    	}
    )
    Toggles.antisuppression:OnChanged(function(aX)
    	if aX then
    		aS(ak.Character)
    	elseif aT and aT.Parent then
    		aT.Enabled = aU
    	end
    end)
    aW:AddToggle(
    	"antiflashbang",
    	{
    		Text = "Anti Flashbang",
    		Default = false,
    	}
    )

    local aX = an.Misc:AddRightGroupbox("Healing")
    aX:AddToggle("autoheal", { Text = "Auto Heal", Default = false })
    aX:AddSlider("autohealmindamage", {
    	Text = "Min Damage",
    	Default = 30,
    	Min = 0,
    	Max = 100,
    	Rounding = 0,
    	Suffix = "%",
    })
    aX:AddToggle("instantheal", { Text = "Instant Heal", Default = false })
    local aY = ac.functions.healLimb.upv and ac.functions.healLimb.upv[7]
    local aZ = {}
    aX:AddToggle("nobandageslowdown", { Text = "No Bandage Slowdown", Default = false })
    Toggles["nobandageslowdown"]:OnChanged(function(a_)
    	if not ac.functions.healLimb.func then return end
    	if a_ then
    		debug.setupvalue(ac.functions.healLimb.func, 7, aZ)
    	else
    		debug.setupvalue(ac.functions.healLimb.func, 7, aY)
    	end
    end)
    aX:AddToggle("fastrevive", { Text = "Fast Revive", Default = false })

    local a_ = an.Misc:AddRightGroupbox("Vehicles")
    a_:AddToggle("carmods", { Text = "Car Mods", Default = false })
    Toggles["carmods"]:OnChanged(function(a0)
    	ac.cars.apply()
    end)
    a_:AddDropdown(
    	"carprofile",
    	{ Text = "Car", Values = ac.cars.entries, Default = 1, Multi = false, AllowNull = true }
    )
    Options.carprofile:OnChanged(function(a0)
    	ac.cars.state.selected = a0
    	local a1 = ac.cars.profile()
    	if not a1 then
    		return
    	end
    	for a2 in pairs(ac.cars.defaults) do
    		if Options["car_" .. a2] then
    			Options["car_" .. a2]:SetValue(a1[a2])
    		end
    	end
    	for a2 in pairs(ac.cars.boolDefaults) do
    		if Toggles["car_" .. a2] then
    			Toggles["car_" .. a2]:SetValue(a1[a2])
    		end
    	end
    	for a2, a3 in pairs({
    		ChassisType = { "Wheeled", "Tracked" },
    		DriveType = { "FWD", "RWD", "AWD" },
    		Differential = { "Open", "Locked" },
    	}) do
    		if Options["car_" .. a2] then
    			Options["car_" .. a2]:SetValue(a1[a2])
    		end
    	end
    	for a2 = -1, 6 do
    		local a3 = a1.Ratios and a1.Ratios[a2] or 0
    		if Options["car_ratio_" .. tostring(a2)] then
    			Options["car_ratio_" .. tostring(a2)]:SetValue(a3)
    		end
    	end
    	for a2 = 1, 4 do
    		local a3 = a1.Wheels and a1.Wheels[a2]
    		if Toggles["car_wheel_" .. a2 .. "_drive"] then
    			Toggles["car_wheel_" .. a2 .. "_drive"]:SetValue(a3 and a3.Drive == true or true)
    		end
    		if Toggles["car_wheel_" .. a2 .. "_steer"] then
    			Toggles["car_wheel_" .. a2 .. "_steer"]:SetValue(a3 and a3.Steer == 1 or a2 <= 2)
    		end
    	end
    	ac.cars.syncJson()
    	ac.cars.apply()
    end)
    a_:AddLabel("Saved profiles are stored per car and faction")

    local a0 = {
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
    for a1, a2 in ipairs({ "Reverse", "Neutral", "Gear 1", "Gear 2", "Gear 3", "Gear 4", "Gear 5", "Gear 6" }) do
    	local a3 = a1 - 2
    	local a4 = "car_ratio_" .. tostring(a3)
    	a_:AddSlider(a4, { Text = a2 .. " Ratio", Default = 0, Min = -15, Max = 15, Rounding = 3 })
    	Options[a4]:OnChanged(function(a5)
    		local a6 = ac.cars.profile()
    		if not a6 then
    			return
    		end
    		a6.Ratios = a6.Ratios or {}
    		a6.Ratios[a3] = a5
    		ac.cars.syncJson()
    		ac.cars.apply()
    	end)
    end
    for a1, a2 in ipairs({ "Front Left", "Front Right", "Rear Left", "Rear Right" }) do
    	local a3 = "car_wheel_" .. a1 .. "_"
    	a_:AddToggle(a3 .. "drive", { Text = a2 .. " Drive", Default = true })
    	a_:AddToggle(a3 .. "steer", { Text = a2 .. " Steer", Default = a1 <= 2 })
    	Toggles[a3 .. "drive"]:OnChanged(function(a4)
    		local a5 = ac.cars.profile()
    		if not a5 then
    			return
    		end
    		a5.Wheels = a5.Wheels or {}
    		a5.Wheels[a1] = a5.Wheels[a1]
    			or { Name = a2:gsub(" ", ""), Drive = true, Steer = a1 <= 2 and 1 or 0 }
    		a5.Wheels[a1].Drive = a4
    		ac.cars.syncJson()
    		ac.cars.apply()
    	end)
    	Toggles[a3 .. "steer"]:OnChanged(function(a4)
    		local a5 = ac.cars.profile()
    		if not a5 then
    			return
    		end
    		a5.Wheels = a5.Wheels or {}
    		a5.Wheels[a1] = a5.Wheels[a1]
    			or { Name = a2:gsub(" ", ""), Drive = true, Steer = a1 <= 2 and 1 or 0 }
    		a5.Wheels[a1].Steer = a4 and 1 or 0
    		ac.cars.syncJson()
    		ac.cars.apply()
    	end)
    end
    for a1, a2 in ipairs(a0) do
    	local a3, a4, a5, a6, a7 = table.unpack(a2)
    	a_:AddSlider(
    		"car_" .. a3,
    		{ Text = a4, Default = ac.cars.defaults[a3], Min = a5, Max = a6, Rounding = a7 }
    	)
    	Options["car_" .. a3]:OnChanged(function(a8)
    		ac.cars.setControl(a3, a8)
    	end)
    end
    for a1, a2 in pairs(ac.cars.boolDefaults) do
    	a_:AddToggle("car_" .. a1, { Text = a1, Default = a2 })
    	Toggles["car_" .. a1]:OnChanged(function(a3)
    		ac.cars.setControl(a1, a3)
    	end)
    end
    for a1, a2 in pairs({
    	ChassisType = { "Wheeled", "Tracked" },
    	DriveType = { "FWD", "RWD", "AWD" },
    	Differential = { "Open", "Locked" },
    }) do
    	a_:AddDropdown(
    		"car_" .. a1,
    		{ Text = a1, Values = a2, Default = ac.cars.choiceDefaults[a1], Multi = false }
    	)
    	Options["car_" .. a1]:OnChanged(function(a3)
    		ac.cars.setControl(a1, a3)
    	end)
    end
    a_:AddInput("carsprofiles", { Text = "Profile data", Default = "{}" })
    Options.carsprofiles:OnChanged(function(a1)
    	ac.cars.loadJson(a1)
    	ac.cars.syncJson()
    	ac.cars.apply()
    end)
if ac.cars.state.selected then
     	Options.carprofile:SetValue(ac.cars.state.selected)
    end
end

	ac.misc = {
		movementStep = aP,
		antiEffectsStep = antiEffectsStep,
		bindSettings = function(aQ)
local aR = "NUfjhQcETc"

local function aS(aT)
	local aU = http_request
		or request
		or (syn and syn.request)
		or (fluxus and fluxus.request)
		or (getgenv and getgenv().request)
	if not aU then
		am:Notify("No HTTP request function on this executor.")
		return
	end
	local aV = ao:JSONEncode({
		cmd = "INVITE_BROWSER",
		args = { code = aT },
		nonce = ao:GenerateGUID(false),
	})
	local aW = false
	for aX = 6463, 6472 do
		local aY, aZ = pcall(aU, {
			Url = ("http://127.0.0.1:%d/rpc?v=1"):format(aX),
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
				["Origin"] = "https://discord.com",
			},
			Body = aV,
		})
		if aY and aZ and (aZ.StatusCode == 200 or aZ.Success) then
			aW = true
			break
		end
	end
	am:Notify(aW and "Opened the invite in Discord." or "Couldn't reach Discord (is it running?).")
end

aQ:AddButton({
	Text = "Join Discord",
	Func = function()
		aS(aR)
	end,
})
aQ
	:AddToggle(
		"ShowModeratorList",
		{ Text = "Show Moderator List", Default = true }
	)
	:OnChanged(function(aT)
		aw = aT
		if az then
			az.Visible = aT
		end
	end)
aQ:AddSlider(
	"ModeratorListX",
	{ Text = "Moderator List X", Default = 10, Min = 0, Max = 2000, Rounding = 0, Suffix = " px" }
)
Options.ModeratorListX:OnChanged(function(aT)
	ax = aT
	if az then
		az.Position = Vector2.new(ax, ay)
	end
end)
aQ:AddSlider(
	"ModeratorListY",
	{ Text = "Moderator List Y", Default = 200, Min = 0, Max = 1200, Rounding = 0, Suffix = " px" }
)
Options.ModeratorListY:OnChanged(function(aT)
	ay = aT
	if az then
		az.Position = Vector2.new(ax, ay)
	end
end)

		end,
		unload = function()
			if aH then
				aH:Disconnect()
				aH = nil
			end
			if aJ then
				aJ:Disconnect()
				aJ = nil
			end
			if aI then
				aI:Disconnect()
				aI = nil
			end
			if aM and aM.Parent and aN ~= nil then
				aM.AutoRotate = aN
			end
			aM = nil
			local aQ = ak.Character and ak.Character:FindFirstChildWhichIsA("Humanoid")
			if aQ then
				aQ.PlatformStand = false
			end
			if aC then
				aC:Disconnect()
			end
			if aD then
				aD:Disconnect()
			end
			if aB then
				for aR, aS in pairs(aB) do
					aS:Disconnect()
					aB[aR] = nil
				end
			end
			if az then
				az:Remove()
				az = nil
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


local aa = getgenv()
local ab = "__vaultcc_cw"
if aa[ab] then
	pcall(aa[ab].unload)
	aa[ab] = nil
end

local ac = a.a()

do
	local ad = game:GetService("Players").LocalPlayer
	ad = ad and ad:FindFirstChild("PlayerScripts")
	ad = ad and ad:FindFirstChild("PlayerModule")
	local ae = ad and getscriptclosure and getscriptclosure(ad)
	local af = debug.getprotos or getprotos
	if type(ae) == "function" and af then
		local ag, ah = pcall(af, ae)
		if ag then
			for ai, aj in ah do
				if type(aj) == "function" then
					local ak = {}
					pcall(function()
						ak = debug.getconstants(aj)
					end)
					local al, am, an, ao, ap = false, false, false, false, false
					for aq, ar in ak do
						if ar == "StreamingHint" then al = true end
						if ar == "Animator" then am = true end
						if ar == "MovementPing" then ap = true end
						if ar == "task" then an = true end
						if ar == "random" then ao = true end
					end
					local aq = 0
					pcall(function()
						aq = debug.getinfo(aj).nups or 0
					end)
					if al or am or ap or (an and ao and aq == 3) then
						pcall(ac.hook, aj, function() end)
					elseif not ap then
						local ar, as = pcall(af, aj)
						if ar then
							for at, au in as do
								if type(au) == "function" then
									local av = {}
									pcall(function()
										av = debug.getconstants(au)
									end)
									for aw, ax in av do
										if ax == "MovementPing" then
											pcall(ac.hook, au, function() end)
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

local ad = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"

Library = loadstring(game:HttpGet(ad .. "Library.lua"))()
local ae = loadstring(game:HttpGet(ad .. "addons/ThemeManager.lua"))()
local af = loadstring(game:HttpGet(ad .. "addons/SaveManager.lua"))()

local ag = game:GetService("Players")
local ah = game:GetService("RunService")
local ai = game:GetService("UserInputService")
local aj = game:GetService("HttpService")
local ak = ag.LocalPlayer
local al = game:GetService("ReplicatedStorage")
local am = al.Client
local an = am.Tools
local ao = an.Weapon.controllers

local ap = require(ao.RecoilController)
local aq = require(ao.AimController)
local ar = require(an.Weapon.Muzzle.firemodes.FireController)
local as = require(al:WaitForChild("Shared"):WaitForChild("Ballistics"):WaitForChild("Trajectory"))
local at = require(am:WaitForChild("Character"):WaitForChild("InventoryController"))
local au = require(am:WaitForChild("GGCameraShaker"))

local function av(aw, ax)
	LPH_ATTRIBUTES(VM(NONE))
	local ay = Toggles and Toggles[aw]
	if ay and ay.Value ~= nil then
		return ay.Value
	end
	return ax
end

local function aw(ax, ay)
	LPH_ATTRIBUTES(VM(NONE))
	local az = Options and Options[ax]
	if az and az.Value ~= nil then
		return az.Value
	end
	return ay
end

local ax = {
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

local ay = ac.cloneOriginal

local az = {}
az.target = nil


local aA = a.b().create({
	title = "Cold War - vault.cc",
	folder = "VaultCC/ColdWar",
	tabs = { "Combat", "ESP", "Visuals", "Misc", "Settings" },
	keybind = "MenuKeybind",
	ignore = { "MenuKeybind" },
	beforeLoad = function(aA, aB)
		if aA.misc and aA.misc.bindSettings then
			aA.misc.bindSettings(aB)
		end
	end,
})
local aB = a.d()
local aC = a.e()
local aD = a.f()
local aE = a.g()

local aF = {
	Players = ag,
	RunService = ah,
	UserInputService = ai,
	LocalPlayer = ak,
	RS = al,
	Client = am,
	Tools = an,
	WeaponControllers = ao,
	RecoilController = ap,
	AimController = aq,
	FiremodeController = ar,
	Trajectory = as,
	InventoryController = at,
	CameraShaker = au,
	cloneOriginal = ay,
	hook = ac.hook,
	Library = Library,
	ThemeManager = ae,
	SaveManager = af,
	HttpService = aj,
	flags = ax,
	tv = av,
	ov = aw,
	util = az,
	manipulation = aB,
}

aA.build(aF)
aC.build(aF)
aD.build(aF)
aE.build(aF)

for aG in ax do
	local aH = Toggles and Toggles[aG]
	if aH then
		aH:OnChanged(function(aI)
			ax[aG] = aI
		end)
		if aH.Value ~= nil then
			ax[aG] = aH.Value
		end
	else
		local aI = Options and Options[aG]
		if aI and aI.Value ~= nil then
			aI:OnChanged(function(aJ)
				ax[aG] = aJ
			end)
			ax[aG] = aI.Value
		end
	end
end

aA.finish(aF)

local aG = false
local aH
local function aI()
	if aG then
		return
	end
	aG = true
	if aH then
		aH:Disconnect()
		aH = nil
	end
	pcall(function()
		ah:UnbindFromRenderStep("cwmain")
		ah:UnbindFromRenderStep("cwcamera")
	end)
	if aF.visuals and aF.visuals.unload then
		aF.visuals.unload()
	end
	if aF.misc and aF.misc.unload then
		aF.misc.unload()
	end
	if aF.combat and aF.combat.unload then
		aF.combat.unload()
	end
	if aF.ESP then
		pcall(function()
			aF.ESP:Unload()
		end)
	end
	ac.restoreAll()
	if aa[ab] and aa[ab].ctx == aF then
		aa[ab] = nil
	end
end

local aJ = 0
aH = ah.Heartbeat:Connect(function(aK)
	LPH_ATTRIBUTES(VM(NONE))
	if ax.silentenabled or ax.turretsilentenabled or ax.aimbotenabled or ax.snaplines then
		aF.combat.targetStep()
	end
	if ax.antiaimspin then
		aF.misc.movementStep(aK)
	end
	if ax.autoheal then
		aF.combat.autoHealStep(aK)
	end
	if ax.fastrevive then
		aF.combat.fastReviveStep(aK)
	end
	if ax.carmods then
		aF.combat.carModsStep(aK)
	end
	if ax.antisuppression or ax.antiflashbang then
		aF.misc.antiEffectsStep(aK)
	end
	if ax.ragebot or ax.ragebottpaura then
		aF.combat.rageSchedulerStep(aK)
	end
	if ax.ESPMaster then
		aF.visuals.teamFilterStep(aK)
	end
	if ax.lightingoverride then
		
		aJ += aK
		if aJ >= 0.1 then
			aJ = 0
			aF.visuals.applyLighting()
		end
	end
end)

ah:BindToRenderStep("cwmain", Enum.RenderPriority.Last.Value + 10, function()
	LPH_ATTRIBUTES(VM(NONE))
	if ax.aimbotenabled then
		aF.combat.aimbotRenderStep()
	end
	if ax.fovdraw then
		aF.combat.fovRenderStep()
	end
	if ax.snaplines then
		aF.combat.snapRenderStep()
	end
end)



ah:BindToRenderStep("cwcamera", Enum.RenderPriority.Camera.Value + 2, function()
	aF.visuals.cameraStep()
end)

Library:OnUnload(aI)
aa[ab] = {
	ctx = aF,
	unload = function()
		pcall(Library.Unload, Library)
		aI()
	end,
}
Library:Notify("Cold War loaded, made with love by vaultt. <3")
