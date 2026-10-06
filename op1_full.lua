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
	return clonefunction and clonefunction(d) or d
end

local function d(e)
	return e
end

local function e(f, g)
	if filtergc then
		local h = filtergc("function", {
			Name = f,
			IgnoreExecutor = true,
		}, true)
		if type(h) == "function" then
			return h
		end
		if type(h) == "table" then
			for i, j in h do
				if type(j) == "function" then
					local k = debug.getinfo(j)
					if not g or (k.source and string.find(k.source, g, 1, true)) then
						return j
					end
				end
			end
		end
	end
	for h, i in getgc(false) do
		if typeof(i) == "function" and islclosure(i) then
			local j = debug.getinfo(i)
			if j.name == f and (not g or (j.source and string.find(j.source, g, 1, true))) then
				return i
			end
		end
	end
end

return {
	cloneOriginal = c,
	wrap = d,
	findGcFunction = e,
}
end function a.d()local c=a.cache.d if not c then c={c=b()}a.cache.d=c end return c.c end end do local function b()
local function c(d)
	local e = d.Players
	local f = d.LocalPlayer
	local g = d.StateObject
	local h = d.Targeting

	local function i(j, k)
		LPH_ATTRIBUTES(VM(NONE))
		if k and k.values and k.values.viewmodels then
			return k.values.viewmodels
		end
		if h.get_viewmodel then
			local l = h:get_viewmodel(j)
			if l then
				return l
			end
		end
		if typeof(k) == "Instance" then
			return k
		end
		return nil
	end

	local j = {}
	local k = 0
	local function l(m)
		LPH_ATTRIBUTES(VM(NONE))
		local n = os.clock()
		if n - k > 0.2 then
			k = n
			table.clear(j)
			local o = g.get_all("Character")
			for p, q in o do
				if typeof(p) ~= "Instance" or type(q) ~= "table" then
					continue
				end
				local r = q.instance
				if typeof(r) ~= "Instance" or not r.Parent then
					continue
				end
				j[p] = q
				j[p.Name] = q
			end
		end
		if typeof(m) == "Instance" then
			return j[m] or j[m.Name]
		end
		return nil
	end

	local m
	local n = 0
	local function o()
		LPH_ATTRIBUTES(VM(NONE))
		local p = os.clock()
		if p - n < 1 / 60 then
			local q = m and m.instance
			if typeof(q) == "Instance" and q.Parent then
				return m
			end
		end
		n = p
		local q = l(f)
		if q and q.values then
			m = q
			return q
		end
		m = nil
		return nil
	end

	return {
		getLiveCharacter = l,
		getLocalOwner = o,
		getViewmodel = i,
	}
end

return {
	create = c,
}
end function a.e()local c=a.cache.e if not c then c={c=b()}a.cache.e=c end return c.c end end do local function b()
local c = debug.profilebegin or function() end
local d = debug.profileend or function() end

local function e(f, g, h)
	return function(...)
		c(f)
		if h == 2 then
			local i, j = g(...)
			d()
			return i, j
		end
		local i = g(...)
		d()
		return i
	end
end

return {
	begin = c,
	stop = d,
	wrap = e,
}
end function a.f()local c=a.cache.f if not c then c={c=b()}a.cache.f=c end return c.c end end do local function b()
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
end function a.g()local aa=a.cache.g if not aa then aa={c=b()}a.cache.g=aa end return aa.c end end do local function aa()
local ab = a.g()

return ab.create({
	title = "Operation One - vault.cc",
	folder = "VaultCC/op1_full",
	tabs = { "Combat", "ESP", "Visuals", "Misc", "Settings" },
	ignore = { "menubind", "recoilmult" },
})
end function a.h()local ab=a.cache.h if not ab then ab={c=aa()}a.cache.h=ab end return ab.c end end do local function aa()
local ab = workspace.Raycast
local b = a.f()

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
end function a.i()local ab=a.cache.i if not ab then ab={c=aa()}a.cache.i=ab end return ab.c end end do local function aa()
local ab = a.i()
local b = a.f()

local c = {}

function c.build(d)
	local e = d.tv
	local f = d.ov
	local g = d.cloneOriginal
	local h = d.wrap
	local i = d.findGcFunction
	local j = d.Players
	local k = d.LocalPlayer
	local l = d.UserInputService
	local m = d.Lighting
	local n = d.CollectionService
	local o = d.ReplicatedStorage
	local p = d.Modules
	local q = d.Gun
	local r = d.StateObject
	local s = d.Util
	local t = d.Targeting
	local u = d.ESP
	local v = d.Library
	local w = d.owner.getLocalOwner
	local x = d.owner.getLiveCharacter
	local y = d.owner.getViewmodel
	local z = d.Tabs

	local A = { "head" }
	local B = {
		["head"] = "head",
		["torso"] = "torso",
		["left arm"] = "arm2",
		["right arm"] = "arm1",
		["left leg"] = "leg2",
		["right leg"] = "leg1",
	}

	local function C()
		LPH_ATTRIBUTES(VM(NONE))
		local D = w()
		local E = f("targetfrom", "Muzzle")
		local F = E == "Head" or E == 1
		if e("antiaimfromhead", false) and e("antiaim", false) then
			F = true
		end
		if F and D then
			local G = D.values and D.values.viewmodels
			local H = typeof(G) == "Instance" and (G:FindFirstChild("head") or G:FindFirstChild("Head"))
			if not (H and H:IsA("BasePart")) then
				local I = D.instance
				H = typeof(I) == "Instance" and (I:FindFirstChild("head") or I:FindFirstChild("Head"))
			end
			if H and H:IsA("BasePart") then
				return H.Position
			end
		end
		local G = D and D.values and D.values.equipped
		local H = G and G.shot
		if typeof(H) == "Instance" and H.Parent then
			return H.Position
		end
		return d.Camera.CFrame.Position
	end
	local function D()
		table.clear(A)
		local E = Options and Options.silenttarget and Options.silenttarget.Value
		if type(E) == "table" then
			for F, G in pairs(E) do
				if G == true then
					local H = B[string.lower(tostring(F))]
					if H then
						table.insert(A, H)
					end
				end
			end
		end
		if #A == 0 then
			A[1] = "head"
		end
	end

	local E = {
		Vector3.xAxis,
		-Vector3.xAxis,
		Vector3.yAxis,
		-Vector3.yAxis,
		Vector3.zAxis,
		-Vector3.zAxis,
	}

	local F = {}
	local function G(H, I, J)
		LPH_ATTRIBUTES(VM(NONE))
		if I.Magnitude < 0.001 then
			return
		end
		F[#F + 1] = H + I.Unit * J
	end

	local H = RaycastParams.new()
	H.FilterType = Enum.RaycastFilterType.Exclude
	H.IgnoreWater = true

	local I = RaycastParams.new()
	I.FilterType = Enum.RaycastFilterType.Exclude
	I.IgnoreWater = true

	local J = {}
	local K = {}

	local L = function(L, M, N, O)
		LPH_ATTRIBUTES(VM(NONE))
		table.clear(F)
		if not L then
			return F
		end
		F[1] = L
		if not (N and N > 0) then
			return F
		end
		for P, Q in E do
			G(L, Q, N)
		end
		local P = d.Camera.CFrame
		G(L, P.LookVector, N)
		G(L, P.RightVector, N)
		G(L, -P.RightVector, N)
		local Q = Vector3.new(M.X - L.X, 0, M.Z - L.Z)
		G(L, Q, N)
		if O == "Medium" or O == "High" then
			G(L, P.LookVector - Vector3.yAxis, N)
			G(L, Q - Vector3.yAxis, N)
			G(L, P.RightVector - Vector3.yAxis, N)
			G(L, -P.RightVector - Vector3.yAxis, N)
		end
		if O == "High" then
			G(L, P.LookVector + P.RightVector, N)
			G(L, P.LookVector - P.RightVector, N)
			G(L, Q + Vector3.xAxis, N)
			G(L, Q - Vector3.xAxis, N)
		end
		return F
	end
	local function M(N, O)
		LPH_ATTRIBUTES(VM(NONE))
		for P, Q in O do
			if typeof(Q) == "Instance" and (N == Q or N:IsDescendantOf(Q)) then
				return true
			end
		end
		return false
	end

	local N = {}

	local function O(P)
		LPH_ATTRIBUTES(VM(NONE))
		for Q, R in N do
			if typeof(R) == "Instance" and P:IsDescendantOf(R) then
				return true
			end
		end
		return false
	end

	local function P(Q)
		LPH_ATTRIBUTES(VM(NONE))
		local R = Q
		for S = 1, 8 do
			if not R or R == workspace then
				break
			end
			local T = string.lower(R.Name)
			if string.find(T, "shield", 1, true)
				or R:HasTag("Shield")
				or R:HasTag("BallisticShield")
				or R:HasTag("RiotShield")
				or R:HasTag("DeployableShield")
				or R:HasTag("GlassShield")
				or R:HasTag("MetalShield")
			then
				return true
			end
			R = R.Parent
		end
		return false
	end

	local function Q(R)
		LPH_ATTRIBUTES(VM(NONE))
		if P(R) then
			return true
		end
		if R:GetAttribute("Hard") or (R.Parent and R.Parent:GetAttribute("Hard")) then
			return true
		end
		if R.Name == "MetalRoll" or R.Name == "MetalBarricade" then
			return true
		end
		local S = R
		for T = 1, 8 do
			if not S or S == workspace then
				break
			end
			if S:HasTag("Reinforcement") or S:HasTag("Hard") then
				return true
			end
			local U = string.lower(S.Name)
			if string.find(U, "metalbarricade", 1, true) or string.find(U, "metal_barricade", 1, true) then
				return true
			end
			local V = S.Name == "DoorBarricade" or S:HasTag("DoorBarricade")
			if V then
				local W = R:GetAttribute("Soft") or S:GetAttribute("Soft")
				local X = R.Material
				local Y = X == Enum.Material.Metal
					or X == Enum.Material.CorrodedMetal
					or X == Enum.Material.DiamondPlate
				if R.Name == "MetalRoll" or R:IsA("UnionOperation") or Y or not W then
					return true
				end
			end
			S = S.Parent
		end
		return false
	end

	local function R(S)
		LPH_ATTRIBUTES(VM(NONE))
		if S:IsA("TrussPart") then
			return true
		end
		local T = string.lower(S.Name)
		return string.find(T, "ladder", 1, true) ~= nil or string.find(T, "truss", 1, true) ~= nil
	end

	local function S(T)
		LPH_ATTRIBUTES(VM(NONE))
		if not T then
			return false
		end
		if Q(T) or P(T) then
			return false
		end
		if T.CanCollide == false or T.Transparency >= 1 then
			return true
		end
		if T.CollisionGroup == "char_block" then
			return true
		end
		local U = T.Parent
		if T:GetAttribute("Soft") or (U and U:GetAttribute("Soft")) then
			return true
		end
		local V = string.lower(T.Name)
		if string.find(V, "glass", 1, true) or string.find(V, "window", 1, true) then
			return true
		end
		return T.Material == Enum.Material.Glass
	end

	local function T(U)
		LPH_ATTRIBUTES(VM(NONE))
		if Q(U) or P(U) then
			return false
		end
		if R(U) or S(U) then
			return true
		end
		return false
	end

	local ac = function(U, V, W, X, Y)
		LPH_ATTRIBUTES(VM(NONE))
		local Z = V - U
		local _ = Z.Magnitude
		if _ <= 0.001 then
			return true
		end

		table.clear(J)
		if X then
			for ac = 1, #X do
				J[ac] = X[ac]
			end
		end
		H.FilterDescendantsInstances = J
		local ac = U
		local ad = V - ac
		local ae = 0
		local af = 0
		local ag = Y and 6 or 1

		while ae < ag and af < 8 do
			local ah = ad.Magnitude
			if ah <= 0.05 then
				return true
			end
			local ai = workspace:Raycast(ac, ad, H)
			if not ai then
				return true
			end

			local aj = ai.Instance
			if P(aj) then
				return false
			end
			if M(aj, W) then
				return true
			end
			if (ai.Position - V).Magnitude <= 0.4 then
				return true
			end
			if O(aj) then
				return false
			end
			if Q(aj) or P(aj) then
				return false
			end
			local ak = R(aj) or S(aj)
			if not ak then
				if not Y or not T(aj) then
					return false
				end
				ae += 1
			else
				af += 1
			end

			J[#J + 1] = aj
			H.FilterDescendantsInstances = J

			local al = ad.Unit
			ac = ai.Position + al * 0.05
			ad = V - ac
		end
		return false
	end

	local function ad(ae, af, ag)
		LPH_ATTRIBUTES(VM(NONE))
		local ah = af - ae
		local ai = ah.Magnitude
		if ai <= 0.05 then
			return ae
		end
		H.FilterDescendantsInstances = ag or {}
		local aj = workspace:Raycast(ae, ah, H)
		if not aj then
			return af
		end
		local ak = (aj.Position - ae).Magnitude
		if ak <= 0.15 then
			return nil
		end
		return ae + ah.Unit * (ak - 0.15)
	end

	local ae = 0
	local af
	local ag
	local ah
	local ai = false
	local aj = function(aj, ak, al, U, V)
		LPH_ATTRIBUTES(VM(NONE))
		local W = os.clock()
		if W - ae < 1 / 60 and af == aj and ag == ak then
			if ai then
				return ah, ak
			end
			return nil
		end
		ae = W
		af = aj
		ag = ak
		ai = false
		ah = nil
		local X = (e("manipulation", false) and f("manipulationdistance", 0)) or 0
		local Y = (e("manipulation", false) and f("manipulationdepth", "Low")) or "Low"
		local Z = ab.solve(aj, ak, X, Y, function(Z, _)
			return ac(Z, _, al, U, V)
		end, U)
		if not Z then
			return nil
		end
		ah = Z
		ai = true
		return Z, ak
	end
	local ak = { origin = nil, dest = nil, at = 0 }
	local al = { target = nil, time = 0 }
	local U = 0
	local function V()
		LPH_ATTRIBUTES(VM(NONE))
		local W = os.clock()
		if W - U < 0.25 then
			return
		end
		U = W
		table.clear(N)
		for X, Y in j:GetPlayers() do
			if Y == k or not (t.is_friendly and t:is_friendly(Y)) then
				continue
			end
			local Z = x(Y) or (t.get_character and t:get_character(Y))
			if not Z then
				continue
			end
			if typeof(Z.instance) == "Instance" and not Z.instance.Parent then
				continue
			end
			if Z.instance then
				table.insert(N, Z.instance)
			end
			local _ = y(Y, Z)
			if _ then
				table.insert(N, _)
			end
		end
	end

	local function W(X)
		LPH_ATTRIBUTES(VM(NONE))
		table.clear(K)
		local Y = X or w()
		if Y then
			if Y.values and Y.values.viewmodels then
				K[#K + 1] = Y.values.viewmodels
			end
			if Y.instance then
				K[#K + 1] = Y.instance
			end
		end
		if k.Character then
			K[#K + 1] = k.Character
		end
		return K
	end

	local X = {
		{
			Vector3.new(1, 0, 0),
			Vector3.new(-1, 0, 0),
		},
		{
			Vector3.new(1, 1, 0),
			Vector3.new(1, -1, 0),
			Vector3.new(-1, 1, 0),
			Vector3.new(-1, -1, 0),
		},
		{
			Vector3.new(1, 1, 1),
			Vector3.new(1, 1, -1),
			Vector3.new(1, -1, 1),
			Vector3.new(1, -1, -1),
			Vector3.new(-1, 1, 1),
			Vector3.new(-1, 1, -1),
			Vector3.new(-1, -1, 1),
			Vector3.new(-1, -1, -1),
		},
	}

	local function Y(Z)
		LPH_ATTRIBUTES(VM(NONE))
		local _, am = d.Camera:WorldToViewportPoint(Z)
		if typeof(_) ~= "Vector3" or _.Z <= 0 then
			return false, _, math.huge
		end
		local an = d.Camera.ViewportSize
		if not am or _.X < 0 or _.Y < 0 or _.X > an.X or _.Y > an.Y then
			return false, _, math.huge
		end
		local ao = (Vector2.new(_.X, _.Y) - Vector2.new(an.X / 2, an.Y / 2)).Magnitude
		return true, _, ao
	end

	local function am()
		local an = f("multipointcount", "2^3")
		local ao = tonumber(an)
		if not ao then
			ao = tonumber(string.match(tostring(an), "%d+"))
		end
		return math.clamp(ao or 3, 1, 3)
	end

	local function an(ao, Z, _)
		local ap = ao.Size * 0.5 * _
		return ao.CFrame:PointToWorldSpace(Vector3.new(ap.X * Z.X, ap.Y * Z.Y, ap.Z * Z.Z))
	end

	local function ao(ap, Z)
		LPH_ATTRIBUTES(VM(NONE))
		local _ = ap and ap.Part
		if not _ or not _.Parent then
			return
		end
		ap.AimPoint = _.Position
		if not e("multipoints", false) then
			return
		end
		local aq = math.clamp(tonumber(f("multipointscale", 0.8)) or 0.8, 0.1, 1)
		local ar = X[am()]
		local as = W()
		local at = { ap.Viewmodel, ap.CharacterInstance, _ }
		local au = e("ragebotwallbang", false)
		local av = e("silentvischeck", false) or e("ragebot", false) or e("manipulation", false)
		local aw = _.Position
		local ax = math.huge
		local ay = false
		local function az(aA)
			local aB, aC, aD = Y(aA)
			if not aB then
				aD = (Z - aA).Magnitude + 100000
			end
			if av then
				if not ac(Z, aA, at, as, au) then
					return
				end
				ay = true
			end
			if aD < ax then
				ax = aD
				aw = aA
			end
		end
		az(_.Position)
		for aA = 1, #ar do
			az(an(_, ar[aA], aq))
		end
		if av and not ay then
			ap.AimPoint = _.Position
			return
		end
		ap.AimPoint = aw
		if ay then
			ap.Visible = true
		end
	end

	local ap = {
		{ "head", "Head" },
		{ "torso", "Torso", "UpperTorso" },
		{ "arm1", "Right Arm", "RightUpperArm" },
		{ "arm2", "Left Arm", "LeftUpperArm" },
		{ "leg1", "Right Leg", "RightUpperLeg" },
		{ "leg2", "Left Leg", "LeftUpperLeg" },
	}
	local aq = {
		Vector3.zero,
		Vector3.new(0, -1, 0),
		Vector3.new(0, 1, 0),
		Vector3.new(1, 0, 0),
		Vector3.new(-1, 0, 0),
		Vector3.new(0, 0, 1),
		Vector3.new(0, 0, -1),
	}

	local function ar(as, at)
		for au = 1, #at do
			local av = as:FindFirstChild(at[au])
			if av and av:IsA("BasePart") then
				return av
			end
		end
	end

	local function as(at, au, av, aw)
		LPH_ATTRIBUTES(VM(NONE))
		local ax = at.Model
		if typeof(ax) ~= "Instance" then
			return nil
		end
		local ay = { at.Viewmodel, at.CharacterInstance, ax }
		for az = 1, #ap do
			local aA = ar(ax, ap[az])
			if aA then
				local aB = aA.Size * 0.45
				local aC = aA.CFrame
				for aD = 1, #aq do
					local Z = aq[aD]
					local _ = aA.Position
					if Z.X ~= 0 or Z.Y ~= 0 or Z.Z ~= 0 then
						_ = aC:PointToWorldSpace(Vector3.new(aB.X * Z.X, aB.Y * Z.Y, aB.Z * Z.Z))
					end
					if ac(au, _, ay, av, aw) then
						return aA, _
					end
				end
			end
		end
	end

	local function at(au, av, aw, ax)
		if ax >= av[3] then
			return
		end
		local ay = 3
		if ax < av[1] then
			ay = 1
		elseif ax < av[2] then
			ay = 2
		end
		for az = 3, ay + 1, -1 do
			au[az] = au[az - 1]
			av[az] = av[az - 1]
		end
		au[ay] = aw
		av[ay] = ax
	end

	local function au()
		LPH_ATTRIBUTES(VM(NONE))
		V()
		local av = A
		if #av == 0 then
			av = { "head" }
		end

		local aw = math.huge
		if e("silentdistancecheck", false) then
			local ax = f("silentmaxdistance", 500)
			if ax > 0 then
				aw = ax
			end
		end

		local ax = math.huge
		local ay = e("ragebot", false) and e("rageignorefov", true)
		if e("silentfovenabled", false) and not ay then
			ax = f("silentfovsize", 100)
		end

		local az = e("ragebot", false)
		local aA = az and e("rageallparts", false)
		local aB = not az
		local aC = e("ragebotwallbang", false)
		local aD = not az and not e("manipulation", false) and e("silentvischeck", false)
		local Z = e("silentteamcheck", false)
		local _ = C()
		local aE = W()
		local aF = math.huge
		local aG
		local aH, aI
		if aA then
			aH = { nil, nil, nil }
			aI = { math.huge, math.huge, math.huge }
		end

		for aJ, aK in j:GetPlayers() do
			if aK == k then
				continue
			end
			if Z and t:is_friendly(aK) then
				continue
			end

			local aL = x(aK) or (t.get_character and t:get_character(aK))
			if not aL then
				continue
			end
			if typeof(aL.instance) == "Instance" and not aL.instance.Parent then
				continue
			end
			if e("spawnprotcheck", false) or e("ragebotspawnprot", false) then
				local aM = aL.instance
				if typeof(aM) == "Instance" and aM:GetAttribute("Protected") then
					continue
				end
			end

			local aM = t:get_health(aK)
			if type(aM) ~= "number" then
				local aN = typeof(aL.instance) == "Instance" and aL.instance:FindFirstChildOfClass("Humanoid")
				aM = aN and aN.Health or 100
			end
			if aM <= 0 then
				continue
			end

			local aN = y(aK, aL)
			local aO = aL.instance
			local aP = typeof(aN) == "Instance" and aN or (typeof(aO) == "Instance" and aO)
			if typeof(aP) ~= "Instance" then
				continue
			end
			local aQ = aP:FindFirstChild("torso")
				or aP:FindFirstChild("head")
				or aP:FindFirstChild("Head")
				or aP:FindFirstChild("Torso")
				or aP:FindFirstChild("HumanoidRootPart")
			if not aQ then
				continue
			end

			local aR = aQ.Position
			local aS = (_ - aR).Magnitude
			if aS > aw then
				continue
			end

			if aA then
				if e("silentfovenabled", false) and not e("rageignorefov", true) then
					local aT, aU, aV = Y(aR)
					if not aT or aV > ax then
						continue
					end
				end
				at(aH, aI, {
					Player = aK,
					Part = aQ,
					Viewmodel = aN,
					Character = aL,
					CharacterInstance = aO,
					Model = aP,
					WorldPosition = aR,
					ScreenDist = aS,
					Visible = false,
				}, aS)
				continue
			end

			local aT
			local aU
			local aV = math.huge
			for aW, aX in av do
				local aY = aP:FindFirstChild(aX) or aP:FindFirstChild(string.gsub(aX, "^%l", string.upper))
				if not aY then
					continue
				end
				local aZ, a_, a0 = Y(aY.Position)
				if aB and not aZ then
					continue
				end
				if a0 < aV then
					aV = a0
					aT = aY
					aU = a_
				end
			end
			if not aT then
				local aW, aX, aY = Y(aR)
				if aB and not aW then
					continue
				end
				aT = aQ
				aV = aY
				aU = aX
			end
			if aV > ax then
				continue
			end

			local aW = e("multipoints", false)
			local aX = true
			if (aD or az) and not aW then
				aX = ac(_, aT.Position, { aN, aO, aP }, aE, aC)
				if aD and not aX then
					continue
				end
			end

			local aY = (az and not aW) and (aX and aS or aS + 10000) or aV
			if aY < aF then
				aF = aY
				aG = {
					Player = aK,
					Part = aT,
					Viewmodel = aN,
					Character = aL,
					CharacterInstance = aO,
					WorldPosition = aR,
					ScreenPoint = aU,
					ScreenDist = aV,
					Visible = aX,
				}
			end
		end

		if aA then
			for aJ = 1, 3 do
				local aK = aH[aJ]
				if not aK then
					break
				end
				local aL, aM = as(aK, _, aE, aC)
				if aL then
					aK.Part = aL
					aK.AimPoint = aM
					aK.Visible = true
					return aK
				end
			end
			return aH[1]
		end

		return aG
	end

	local function av()
		LPH_ATTRIBUTES(VM(NONE))
		local aw = os.clock()
		if aw - al.time < 1 / 60 then
			return al.target
		end
		al.time = aw
		if not (e("silentenabled", false) or e("ragebot", false) or e("aimbotenabled", false) or e("snaplines", false)) then
			al.target = nil
			return nil
		end
		al.target = au()
		if al.target and not al.target.AimPoint then
			ao(al.target, C())
		end
		return al.target
	end

	local function aw(ax, ay)
		LPH_ATTRIBUTES(VM(NONE))
		if ax and ay then
			ak.origin = ax
			ak.dest = ay
			ak.at = os.clock()
		else
			ak.origin = nil
			ak.dest = nil
		end
		return ax, ay
	end

	local function ax(ay, az, aA, aB)
		LPH_ATTRIBUTES(VM(NONE))
		local aC = e("ragebot", false)
		local aD = e("silentvischeck", false) or aC
		local aE = e("ragebotwallbang", false)
		local aF = e("manipulation", false)

		if aF then
			return aw(aj(ay, az, aA, aB, aE))
		end
		if aD then
			if ac(ay, az, aA, aB, aE) then
				return aw(ay, az)
			end
			return aw(nil)
		end
		return aw(ay, az)
	end

	ac = b.wrap("aim.canHit", ac, 1)
	au = b.wrap("aim.findBest", au, 1)
	aj = b.wrap("aim.manipScan", aj, 2)
	ax = b.wrap("aim.resolveShot", ax, 2)
	as = b.wrap("aim.rageHitscan", as, 2)

	local function ay(az, aA, aB)
		LPH_ATTRIBUTES(VM(NONE))
		local aC = {}
		local aD = e("silentteamcheck", false)
		for aE, aF in j:GetPlayers() do
			if aF == k then
				continue
			end
			if aD and t:is_friendly(aF) then
				continue
			end
			local aG = x(aF) or (t.get_character and t:get_character(aF))
			if not aG then
				continue
			end
			local aH = aG.instance
			if typeof(aH) == "Instance" and not aH.Parent then
				continue
			end
			if (e("spawnprotcheck", false) or e("ragebotspawnprot", false)) and typeof(aH) == "Instance" and aH:GetAttribute("Protected") then
				continue
			end
			local aI = t:get_health(aF)
			if type(aI) ~= "number" then
				local aJ = typeof(aH) == "Instance" and aH:FindFirstChildOfClass("Humanoid")
				aI = aJ and aJ.Health or 100
			end
			if aI <= 0 then
				continue
			end
			local aJ = y(aF, aG)
			local aK = typeof(aJ) == "Instance" and aJ or (typeof(aH) == "Instance" and aH)
			if typeof(aK) ~= "Instance" then
				continue
			end
			local aL = ar(aK, { "head", "Head" })
			if not aL then
				continue
			end
			if not ac(az, aL.Position, { aJ, aH, aK, aL }, aA, aB) then
				continue
			end
			aC[#aC + 1] = {
				Player = aF,
				Part = aL,
				AimPoint = aL.Position,
				Viewmodel = aJ,
				Character = aG,
				CharacterInstance = aH,
				WorldPosition = aL.Position,
				Visible = true,
				Dist = (az - aL.Position).Magnitude,
			}
		end
		table.sort(aC, function(aE, aF)
			return aE.Dist < aF.Dist
		end)
		return aC
	end

	local az = {
		{ tag = "Claymore", label = "Claymore" },
		{ tag = "NeedleMine", label = "Needle Mine" },
		{ tag = "ProximityAlarm", label = "Proximity Alarm" },
		{ tag = "BarbedWire", label = "Barbed Wire" },
		{ tag = "ShockBattery", label = "Shock Battery" },
		{ tag = "IncendiaryCanister", label = "Incendiary Canister" },
	}
	local aA = {
		{ tag = "BreachCharge", label = "Breach Charge" },
		{ tag = "HardBreachCharge", label = "Hard Breacher" },
		{ tag = "RemoteC4", label = "Remote C4" },
		{ tag = "ThermiteCharge", label = "Thermite Charge" },
		{ tag = "ToxicCharge", label = "Toxic Charge" },
		{ tag = "SignalDisruptor", label = "Signal Jammer" },
	}
	local aB = {}
	for aC, aD in az do
		aB[#aB + 1] = aD.label
	end

	local function aC(aD)
		LPH_ATTRIBUTES(VM(NONE))
		if typeof(aD) ~= "Instance" or not aD.Parent then
			return nil
		end
		if aD:GetAttribute("Destroyed") or aD:GetAttribute("Disabled") then
			return nil
		end
		local aE = aD.Parent
		if aE.Name == "Garbage" or aE == o then
			return nil
		end
		local aF = aD:FindFirstChild("Root")
		if aF and aF:IsA("BasePart") then
			return aF
		end
		if aD:IsA("BasePart") then
			return aD
		end
		if aD:IsA("Model") and aD.PrimaryPart then
			return aD.PrimaryPart
		end
		for aG, aH in aD:GetChildren() do
			if aH:IsA("BasePart") and aH.Transparency < 1 and aH.Size.Magnitude > 0.05 then
				return aH
			end
		end
		return nil
	end

	local function aD(aE)
		LPH_ATTRIBUTES(VM(NONE))
		local aF = aE:FindFirstChild("ClientModel")
		if aF and aF:IsA("ObjectValue") and typeof(aF.Value) == "Instance" then
			return aF.Value
		end
		return aE
	end

	local function aE(aF, aG)
		LPH_ATTRIBUTES(VM(NONE))
		local aH = { aF, aG }
		local aI = aF:FindFirstChild("ClientModel")
		if aI and aI:IsA("ObjectValue") and typeof(aI.Value) == "Instance" then
			aH[#aH + 1] = aI.Value
		end
		return aH
	end

	local function aF(aG, aH)
		LPH_ATTRIBUTES(VM(NONE))
		local aI
		if aH and aH.owner and type(aH.owner.get) == "function" then
			local aJ, aK = pcall(aH.owner.get, aH.owner)
			if aJ and typeof(aK) == "Instance" then
				aI = aK
			end
		end
		if aI then
			return s.ownership(aI, k) == 0
		end
		local aJ = aG:GetAttribute("UserId")
		if aJ and aJ == k:GetAttribute("UserId") then
			return false
		end
		local aK = aG:GetAttribute("Team")
		if aK and aK == k:GetAttribute("Team") then
			return false
		end
		return aJ ~= nil or aK ~= nil
	end

	local function aG(aH)
		LPH_ATTRIBUTES(VM(NONE))
		local aI = f("ragetraps", nil)
		if type(aI) ~= "table" then
			return false
		end
		return aI[aH] == true
	end

	local function aH()
		LPH_ATTRIBUTES(VM(NONE))
		if not e("ragebottraps", false) then
			return nil
		end
		local aI = C()
		local aJ = w()
		local aK = W(aJ)
		local aL = e("ragebotwallbang", false)
		local aM = math.huge
		local aN
		local aO = {}
		for aP, aQ in az do
			if not aG(aQ.label) then
				continue
			end
			local aR = r.get_all(aQ.tag)
			if type(aR) == "table" then
				for aS, aT in aR do
					local aU = aT and aT.instance
					if typeof(aU) == "Instance" then
						aO[aU] = true
						local aV = aF(aU, aT) and aC(aU)
						if aV then
							local aW = (aI - aV.Position).Magnitude
							if aW < aM and ac(aI, aV.Position, aE(aU, aV), aK, aL) then
								aM = aW
								aN = {
									Part = aV,
									AimPoint = aV.Position,
									Viewmodel = nil,
									CharacterInstance = aD(aU),
									WorldPosition = aV.Position,
									Visible = true,
								}
							end
						end
					end
				end
			end
			for aS, aT in n:GetTagged(aQ.tag) do
				if aO[aT] then
					continue
				end
				local aU = aF(aT, nil) and aC(aT)
				if not aU then
					continue
				end
				local aV = (aI - aU.Position).Magnitude
				if aV < aM and ac(aI, aU.Position, aE(aT, aU), aK, aL) then
					aM = aV
					aN = {
						Part = aU,
						AimPoint = aU.Position,
						Viewmodel = nil,
						CharacterInstance = aD(aT),
						WorldPosition = aU.Position,
						Visible = true,
					}
				end
			end
		end
		return aN
	end

	local function aI()
		LPH_ATTRIBUTES(VM(NONE))
		local aJ = av()
		local aK = aH()
		if not aK or not aK.Part then
			return aJ
		end
		if not (aJ and aJ.Part and aJ.Part.Parent) or aJ.Visible == false then
			return aK
		end
		local aL = C()
		local aM = (aL - aK.Part.Position).Magnitude
		local aN = (aL - aJ.Part.Position).Magnitude
		if aM < aN then
			return aK
		end
		return aJ
	end

	d.aim = {
		refreshTargetParts = D,
		getTarget = av,
		shotOrigin = C,
		resolveShot = ax,
		rageAimTarget = aI,
		trapTarget = aH,
		rageTargets = ay,
		projectScreen = Y,
		getIgnoreList = W,
		cache = al,
		peek = ak,
		trapTypes = az,
		gadgetTypes = aA,
		trapLabels = aB,
	}

end

function c.step(ac)
end

function c.unload()
end

return c
end function a.j()local ab=a.cache.j if not ab then ab={c=aa()}a.cache.j=ab end return ab.c end end do local function aa()
local ab = {}

function ab.build(ac)
	local ad = ac.tv
	local ae = ac.ov
	local af = ac.cloneOriginal
	local ag = ac.wrap
	local ah = ac.findGcFunction
	local ai = ac.Players
	local aj = ac.LocalPlayer
	local ak = ac.UserInputService
	local al = ac.Lighting
	local am = ac.CollectionService
	local an = ac.ReplicatedStorage
	local ao = ac.Modules
	local ap = ac.Gun
	local aq = ac.StateObject
	local ar = ac.Util
	local as = ac.Targeting
	local at = ac.ESP
	local au = ac.Library
	local av = ac.owner.getLocalOwner
	local aw = ac.owner.getLiveCharacter
	local ax = ac.owner.getViewmodel
	local ay = ac.Tabs

	local function az(aA)
		LPH_ATTRIBUTES(VM(NONE))
		return type(aA) == "table" and aA.owner ~= nil
	end

	local function aA(aB)
		LPH_ATTRIBUTES(VM(NONE))
		if az(aB) then
			return aB
		end
		local aC = av()
		local aD = aC and aC.values and aC.values.equipped
		if az(aD) then
			return aD
		end
		return nil
	end
	local aB = RaycastParams.new()
	aB.FilterType = Enum.RaycastFilterType.Exclude
	aB.IgnoreWater = true
	
	local aC = af(ap.get_shoot_look)
	local function aD(aE)
		LPH_ATTRIBUTES(VM(NONE))
		if type(aE) == "table" then
			local aF = aE.shot
			if typeof(aF) == "Instance" then
				return aF.CFrame
			end
			local aG = aE.instance
			local aH = typeof(aG) == "Instance" and aG:FindFirstChild("Root")
			if aH then
				return aH.CFrame
			end
		end
		return ac.Camera.CFrame
	end

	hookfunction(ap.get_shoot_look, ag(function(aE, ...)
		LPH_ATTRIBUTES(VM(NONE))
		local aF, aG = pcall(aC, aE, ...)
		if not aF or typeof(aG) ~= "CFrame" then
			aG = aD(aE)
		end
		if ac.aim.shotOrigin and typeof(aG) == "CFrame" then
			local aH = ac.aim.shotOrigin()
			if aH then
				aG = CFrame.new(aH) * aG.Rotation
			end
		end
		if not (ad("silentenabled", false) or ad("ragebot", false)) then
			return aG
		end
		if not az(aE) then
			return aG
		end
		local aH = av()
		if not aH or aE.owner ~= aH then
			return aG
		end

		local aI = ac.aim.rageShot
		if not aI then
			aI = ac.aim.getTarget()
			if ad("ragebot", false) and ad("ragebottraps", false) then
				aI = ac.aim.rageAimTarget()
			end
		end
		local aJ = aI and aI.Part
		if not aJ or not aJ.Parent then
			return aG
		end

		if ac.aim.peek.origin and ac.aim.peek.dest and os.clock() - ac.aim.peek.at < 0.05 then
			return CFrame.lookAt(ac.aim.peek.origin, ac.aim.peek.dest)
		end

		local aK = ac.aim.getIgnoreList(aE.owner)
		local aL, aM = ac.aim.resolveShot(
			aG.Position,
			aI.AimPoint or aJ.Position,
			{ aI.Viewmodel, aI.CharacterInstance },
			aK
		)
		if not aL or not aM then
			return aG
		end

		return CFrame.lookAt(aL, aM)
	end))

	if type(ar.validate_position) == "function" then
		local aE = af(ar.validate_position)
		hookfunction(ar.validate_position, ag(function(aF, aG, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if ac.aim.peek.origin and os.clock() - ac.aim.peek.at < 0.1 and typeof(aG) == "Vector3" and (aG - ac.aim.peek.origin).Magnitude < 0.5 then
				return aG
			end
			return aE(aF, aG, ...)
		end))
	end

	
	local aE = af(ap.recoil_function)
	hookfunction(ap.recoil_function, ag(function(aF, aG)
		LPH_ATTRIBUTES(VM(NONE))
		if type(aF) ~= "table" or not aF.states then
			return
		end
		local aH = ae("recoilup", 0)
		local aI = ae("recoilside", 0)
		if aH <= 0 and aI <= 0 then
			return
		end
		if aH >= 1 and aI >= 1 then
			return aE(aF, aG)
		end
		local aJ, aK = aF.states.recoil_up, aF.states.recoil_side
		local aL, aM = aJ.get, aK.get
		aJ.get = function(...)
			LPH_ATTRIBUTES(VM(NONE))
			return aL(...) * aH
		end
		aK.get = function(...)
			LPH_ATTRIBUTES(VM(NONE))
			return aM(...) * aI
		end
		local aN, aO = pcall(aE, aF, aG)
		aJ.get, aK.get = aL, aM
		if not aN then
			warn(aO)
		end
	end))

	
	local aF = af(ap.kickback)
	hookfunction(ap.kickback, ag(function(aG, ...)
		LPH_ATTRIBUTES(VM(NONE))
		if type(aG) ~= "table" then
			return
		end
		if ad("nokickback", false) then
			return
		end
		return aF(aG, ...)
	end))


	local function aG(aH, aI, aJ, aK)
		LPH_ATTRIBUTES(VM(NONE))
		if not aH or type(aH[aI]) ~= "function" then
			return
		end
		local aL = aH[aI]
		aK[#aK + 1] = function()
			aH[aI] = aL
		end
		aH[aI] = function(...)
			LPH_ATTRIBUTES(VM(NONE))
			return aJ
		end
	end

	local function aH(aI, aJ, aK, ...)
		LPH_ATTRIBUTES(VM(NONE))
		if not aI or not aJ then
			return aK(...)
		end
		local aL = {}
		if aJ.running and aI.states and aI.states.running then
			aG(aI.states.running, "get", false, aL)
		end
		if aJ.falling and aI.values and aI.values.falling then
			aG(aI.values.falling, "get", false, aL)
		end
		if aJ.vault and aI.states and aI.states.vault then
			aG(aI.states.vault, "get", 0, aL)
		end
		if aJ.prone and aI.values then
			local aM = aI.values.prone_debounce
			aI.values.prone_debounce = false
			aL[#aL + 1] = function()
				aI.values.prone_debounce = aM
			end
		end
		if aJ.equip and aI.values and aI.values.equip_debounce then
			aG(aI.values.equip_debounce, "get", false, aL)
		end
		local aM, aN, aO, aP = pcall(aK, ...)
		for aQ = #aL, 1, -1 do
			aL[aQ]()
		end
		if not aM then
			warn(aN)
			return
		end
		return aN, aO, aP
	end

	local function aI()
		LPH_ATTRIBUTES(VM(NONE))
		return ad("reloadwhilerunning", false) or ad("reloadwhilefalling", false) or ad("noreloadinterrupt", false)
	end

	local function aJ()
		LPH_ATTRIBUTES(VM(NONE))
		return ad("shootwhilerunning", false) or ad("ragebot", false)
	end

	local function aK()
		LPH_ATTRIBUTES(VM(NONE))
		return ad("shootwhilefalling", false) or ad("ragebot", false)
	end

	local aL = af(ap.input_shoot)
	hookfunction(ap.input_shoot, ag(function(aM, ...)
		LPH_ATTRIBUTES(VM(NONE))
		local aN = aA(aM)
		if not aN then
			return aL(aM, ...)
		end
		return aH(aN.owner, {
			running = aJ(),
			falling = aK(),
			vault = aJ() or aK(),
			prone = aJ() or aK(),
		}, aL, aN, ...)
	end))

	local aM
	local aN = 0
	local aO = af(ap.reload)
	hookfunction(ap.reload, ag(function(aP, aQ, aR, ...)
		LPH_ATTRIBUTES(VM(NONE))
		if aR == false and aM and aP == aM then
			local aS = aP.reload_thread
			if aS and aS.running then
				return
			end
		end
		return aO(aP, aQ, aR, ...)
	end))

	local aP = af(ap.input_render)
	hookfunction(ap.input_render, ag(function(aQ, ...)
		LPH_ATTRIBUTES(VM(NONE))
		local aR = aA(aQ)
		if not aR then
			return aP(aQ, ...)
		end
		return aH(aR.owner, {
			running = aJ(),
			falling = aK(),
			vault = aI() or aJ() or aK(),
			prone = aI() or aJ() or aK(),
		}, aP, aR, ...)
	end))

	local aQ = af(ap.running)
	hookfunction(ap.running, ag(function(aR, aS, aT, ...)
		LPH_ATTRIBUTES(VM(NONE))
		local aU = aA(aR)
		if not aU then
			return aQ(aR, aS, aT, ...)
		end
		aR = aU
		if aT and aI() and aR.reload then
			local aV = aR.reload
			aR.reload = function() end
			local aW, aX, aY, aZ = pcall(aQ, aR, aS, aT, ...)
			aR.reload = aV
			if not aW then
				warn(aX)
				return
			end
			return aX, aY, aZ
		end
		return aQ(aR, aS, aT, ...)
	end))

	if type(ap.walk_state) == "function" then
		local aR = af(ap.walk_state)
		hookfunction(ap.walk_state, ag(function(aS, aT, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if type(aS) ~= "table" then
				return
			end
			if aI() and aS.reload then
				local aU = aS.reload
				aS.reload = function() end
				local aV, aW, aX, aY = pcall(aR, aS, aT, ...)
				aS.reload = aU
				if not aV then
					warn(aW)
					return
				end
				return aW, aX, aY
			end
			return aR(aS, aT, ...)
		end))
	end

	if type(ap.vault) == "function" then
		local aR = af(ap.vault)
		hookfunction(ap.vault, ag(function(aS, aT, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if type(aS) ~= "table" then
				return
			end
			if aI() and aS.reload then
				local aU = aS.reload
				aS.reload = function() end
				local aV, aW, aX, aY = pcall(aR, aS, aT, ...)
				aS.reload = aU
				if not aV then
					warn(aW)
					return
				end
				return aW, aX, aY
			end
			return aR(aS, aT, ...)
		end))
	end

	local aR = ah("get_circular_spread")
	if aR then
		local aS = af(aR)
		hookfunction(aR, ag(function(aT, aU)
			LPH_ATTRIBUTES(VM(NONE))
			return aS(aT, (aU or 0) * ae("spreadmult", 1))
		end))
	else
		local aS = af(ap.send_shoot)
		hookfunction(ap.send_shoot, ag(function(aT, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if type(aT) ~= "table" then
				return aS(aT, ...)
			end
			local aU = aT.states and aT.states.spread
			local aV
			if aU then
				aV = aU.get
				aU.get = function(...)
					LPH_ATTRIBUTES(VM(NONE))
					return aV(...) * ae("spreadmult", 1)
				end
			end
			local aW, aX, aY, aZ = pcall(aS, aT, ...)
			if aV then
				aU.get = aV
			end
			if not aW then
				warn(aX)
				return
			end
			return aX, aY, aZ
		end))
	end

	local aS = {}
	local aT = Instance.new("Folder")
	aT.Name = "vault_tracers"
	aT.Parent = workspace

	local function aU(aV, aW)
		if not (aV and aW) then
			return
		end
		if #aS >= 32 then
			local aX = table.remove(aS, 1)
			if aX and aX.part then
				aX.part:Destroy()
			end
		end
		if not aT or not aT.Parent then
			aT = Instance.new("Folder")
			aT.Name = "vault_tracers"
			aT.Parent = workspace
		end
		local aX = (aW - aV).Magnitude
		if aX <= 0.001 then
			return
		end
		local aY = ae("tracermaterial", "Neon")
		local aZ = Enum.Material[aY] or Enum.Material.Neon
		local a_ = ae("tracersize", 0.12)
		local a0 = Instance.new("Part")
		a0.Name = "tracer"
		a0.Anchored = true
		a0.CanCollide = false
		a0.CanQuery = false
		a0.CanTouch = false
		a0.CastShadow = false
		a0.Material = aZ
		a0.Color = ae("tracercolor", Color3.fromRGB(255, 255, 255))
		a0.Transparency = ae("tracertransparency", 0.25)
		a0.Size = Vector3.new(a_, a_, aX)
		a0.CFrame = CFrame.lookAt((aV + aW) / 2, aW)
		local b = ae("tracertexture", "None")
		if b == "Glow" then
			local c = Instance.new("SurfaceLight")
			c.Brightness = 2
			c.Range = 12
			c.Parent = a0
		elseif b == "Lightning" then
			local c = Instance.new("Texture")
			c.Texture = "rbxassetid://10850031522"
			c.Face = Enum.NormalId.Front
			c.StudsPerTileU = 2
			c.StudsPerTileV = 2
			c.Parent = a0
		end
		a0.Parent = aT
		table.insert(aS, {
			part = a0,
			t0 = os.clock(),
			life = ae("tracerlifetime", 1),
			baseT = ae("tracertransparency", 0.25),
		})
	end

	local function aV()
		for aW, aX in aS do
			if aX.part then
				aX.part:Destroy()
			end
		end
		table.clear(aS)
	end

	local function aW()
		LPH_ATTRIBUTES(VM(NONE))
		if not ad("tracersenabled", false) then
			if #aS > 0 then
				aV()
			end
			return
		end
		local aX = os.clock()
		for aY = #aS, 1, -1 do
			local aZ = aS[aY]
			if not aZ.part or not aZ.part.Parent or aX - aZ.t0 >= aZ.life then
				if aZ.part then
					aZ.part:Destroy()
				end
				table.remove(aS, aY)
				continue
			end
			local a_ = (aX - aZ.t0) / aZ.life
			aZ.part.Transparency = aZ.baseT + (1 - aZ.baseT) * a_
		end
	end

	local function aX()
		LPH_ATTRIBUTES(VM(NONE))
		local aY = ac.Camera.ViewportSize
		fovCircle.Position = Vector2.new(aY.X / 2, aY.Y / 2)
		fovCircle.Radius = ae("silentfovsize", 100)
		fovCircle.Color = ae("silentfovcolor", Color3.fromRGB(255, 255, 255))
		fovCircle.Thickness = ae("silentfovthickness", 1)
		fovCircle.Visible = ad("silentfovenabled", false) and ad("silentfovdraw", true)
	end

	local function aY()
		LPH_ATTRIBUTES(VM(NONE))
		local aZ = ac.aim.cache.target
		local a_ = aZ and aZ.Part
		if not (ad("snaplines", false) and a_ and a_.Parent) then
			snapLine.Visible = false
			return
		end
		local a0, b, c = projectScreen(aZ.AimPoint or a_.Position)
		if not a0 then
			snapLine.Visible = false
			return
		end
		if ad("silentfovenabled", false) and not ad("ragebot", false) and c > ae("silentfovsize", 100) then
			snapLine.Visible = false
			return
		end
		local d = Vector2.new(ac.Camera.ViewportSize.X / 2, ac.Camera.ViewportSize.Y / 2)
		snapLine.From = d
		snapLine.To = Vector2.new(b.X, b.Y)
		snapLine.Color = ae("snapcolor", Color3.fromRGB(255, 0, 0))
		snapLine.Thickness = ae("snapwidth", 1)
		snapLine.Visible = true
	end

	local aZ = af(ap.send_shoot)
	hookfunction(ap.send_shoot, ag(function(a_, ...)
		LPH_ATTRIBUTES(VM(NONE))
		local a0 = aA(a_)
		if not a0 then
			return aZ(a_, ...)
		end
		a_ = a0
		if ad("tracersenabled", false) then
			local b = a_:get_shoot_look()
			local c = b.Position
			local d = c + b.LookVector * 1000
			local e = ac.aim.cache.target
			local f = e and e.Part
			if f and f.Parent and (ad("silentenabled", false) or ad("ragebot", false)) then
				d = e.AimPoint or f.Position
			else
				aB.FilterDescendantsInstances = ac.aim.getIgnoreList(a_.owner)
				local g = workspace:Raycast(c, b.LookVector * 1000, aB)
				if g then
					d = g.Position
				end
			end
			aU(c, d)
		end
		return aZ(a_, ...)
	end))

	local function a_()
		LPH_ATTRIBUTES(VM(NONE))
		if not ad("aimbotenabled", false) then
			return
		end
		if Options and Options.aimbotkey and not Options.aimbotkey:GetState() then
			return
		end
		local a0 = ac.aim.getTarget()
		local b = a0 and a0.Part
		if not (b and b.Parent) then
			return
		end
		local c = math.max(1, ae("aimbotsmoothness", 1))
		local d = a0.AimPoint or b.Position
		if ae("aimbotmethod", "Camera") == "Mouse" and mousemoverel then
			local e, f = ac.Camera:WorldToViewportPoint(d)
			if f and e.Z > 0 then
				local g = ak:GetMouseLocation()
				mousemoverel((e.X - g.X) / c, (e.Y - g.Y) / c)
			end
		else
			local e = ac.Camera.CFrame
			local f = CFrame.lookAt(e.Position, d)
			if c == 1 then
				ac.Camera.CFrame = f
			else
				ac.Camera.CFrame = e:Lerp(f, 1 / c)
			end
		end
	end

	local a0 = false
	local b = 0
	local c = false
	local d = 0
	local function e()
		LPH_ATTRIBUTES(VM(NONE))
		local f = av()
		local g = f and f.values and f.values.equipped
		if not g or type(g.send_shoot) ~= "function" then
			c = false
			return
		end
		local h = g.inputs and g.inputs:get("reload")
		local i = h and h.holding and h:holding()
		if not i then
			c = false
			return
		end
		if c then
			return
		end

		local j = f.states and f.states.running and f.states.running:get()
		local k = f.values.falling and f.values.falling:get()
		local l = f.states and f.states.vault and f.states.vault:get() > 0
		local m = f.values.prone_debounce == true
		local n = j or k or l or m
		local o = (ad("reloadwhilerunning", false) and j)
			or (ad("reloadwhilefalling", false) and k)
			or (ad("noreloadinterrupt", false) and n)
		if not o then
			return
		end

		c = true
		if g.reload_thread and g.reload_thread.running then
			return
		end
		local p = g.states.bullets and g.states.bullets:get() or 0
		local q = g.states.mag and g.states.mag:get() or 0
		local r = g.states.mag_size and g.states.mag_size:get() or 0
		if p <= 0 or q >= r then
			return
		end
		if g.states.reload and g.states.reload.fire_instant then
			pcall(function()
				g.states.reload:fire_instant()
			end)
		end
	end

	local function f()
		LPH_ATTRIBUTES(VM(NONE))
		if not ad("ragebot", false) then
			aM = nil
			if a0 then
				local g = av()
				local h = g and g.values and g.values.equipped
				if h and h.input_shoot then
					pcall(h.input_shoot, h, false)
				end
				a0 = false
			end
			return
		end

		local g = av()
		if not g or not g.values then
			return
		end
		local h = g.values.equipped
		if not h or type(h.send_shoot) ~= "function" then
			return
		end
		local i = h.instance
		if typeof(i) ~= "Instance" or not i:FindFirstChild("Root") then
			return
		end
		if h.safety and h.safety.set and h.safety.get and h.safety:get() then
			pcall(function()
				h.safety:set(false)
			end)
		end

		if ad("ragebotautoreload", false) then
			local j = h.states.mag and h.states.mag:get() or 0
			local k = h.states.bullets and h.states.bullets:get() or 0
			local l = h.reload_thread and h.reload_thread.running
			if l then
				if a0 then
					pcall(h.input_shoot, h, false)
					a0 = false
				end
				return
			end
			if j <= 0 and k > 0 then
				if os.clock() - aN < 0.4 then
					return
				end
				aN = os.clock()
				if h.states.sights and h.states.sights.set then
					pcall(function()
						h.states.sights:set(false)
					end)
				end
				h.ads_hold = false
				aM = h
				if h.states.reload and h.states.reload.fire_instant then
					pcall(function()
						h.states.reload:fire_instant()
					end)
				end
				return
			end
			if aM == h then
				aM = nil
			end
		elseif aM == h then
			aM = nil
		end

		local j = h.states.mag and h.states.mag:get() or 0
		if j <= 0 then
			return
		end
		local k = os.clock()
		local l = h.states.firerate and h.states.firerate:get() or 0
		if l == 0 and h.states.chambered and h.states.chambered.get and not h.states.chambered:get() then
			local m = h.cock_thread and h.cock_thread.running
			if not m and h.states.cock and h.states.cock.fire_instant then
				pcall(function()
					h.states.cock:fire_instant()
				end)
			end
			return
		end
		local m = l ~= 0 and (1 / (l / 60)) or 0
		if m > 0 and k - b <= m then
			return
		end

		local n = ac.Camera.CFrame.Position
		local o = (ac.aim.shotOrigin and ac.aim.shotOrigin()) or n
		if (o - n).Magnitude > 6 then
			o = n
		end
		local p = ac.aim.rageTargets(o, ac.aim.getIgnoreList(g), ad("ragebotwallbang", false))
		if ad("ragebottraps", false) and ac.aim.trapTarget then
			local q = ac.aim.trapTarget()
			if q and q.Part then
				p[#p + 1] = q
			end
		end
		if #p == 0 then
			if a0 then
				pcall(h.input_shoot, h, false)
				a0 = false
			end
			return
		end
		if d > #p then
			d = 0
		end

		local q = ac.aim.getIgnoreList(g)
		local r
		for s = 1, #p do
			d = (d % #p) + 1
			local t = p[d]
			local u = t.Part
			if u and u.Parent and ac.aim.resolveShot(o, t.AimPoint or u.Position, { t.Viewmodel, t.CharacterInstance, u }, q) then
				r = t
				break
			end
		end
		if not r then
			if a0 then
				pcall(h.input_shoot, h, false)
				a0 = false
			end
			return
		end
		b = k
		ac.aim.rageShot = r
		pcall(h.send_shoot, h)
		ac.aim.rageShot = nil
		a0 = true
	end

	do
	    local g = ay.Combat:AddLeftGroupbox("Targeting")
	    g:AddDropdown("silenttarget", {
	    	Text = "Target part",
	    	Values = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" },
	    	Default = 1,
	    	Multi = true,
	    })
	    g:AddDropdown("targetfrom", {
	    	Text = "Target from",
	    	Values = { "Head", "Muzzle" },
	    	Default = 2,
	    	Multi = false,
	    })
	    g:AddToggle("antiaimfromhead", { Text = "Head origin on antiaim", Default = false })
	    g:AddToggle("silentteamcheck", { Text = "Team Check", Default = false })
	    g:AddToggle("spawnprotcheck", { Text = "Spawn Protection", Default = false })
	    g:AddToggle("silentvischeck", { Text = "Visible Check", Default = false })
	    g:AddToggle("silentdistancecheck", { Text = "Distance Check", Default = false })
	    g:AddSlider("silentmaxdistance", {
	    	Text = "Max Distance",
	    	Default = 500,
	    	Min = 10,
	    	Max = 2000,
	    	Rounding = 0,
	    	Suffix = " studs",
	    })
	    g:AddToggle("silentfovenabled", { Text = "FOV Check", Default = false })
	    g:AddSlider("silentfovsize", {
	    	Text = "FOV Size",
	    	Default = 100,
	    	Min = 3,
	    	Max = 1000,
	    	Rounding = 0,
	    	Suffix = " px",
	    })
	    g:AddToggle("multipoints", { Text = "Multipoints", Default = false })
	    g:AddDropdown("multipointcount", {
	    	Text = "Point count",
	    	Values = { "2^1", "2^2", "2^3" },
	    	Default = 3,
	    	Multi = false,
	    })
	    g:AddSlider("multipointscale", {
	    	Text = "Point scale",
	    	Default = 0.8,
	    	Min = 0.1,
	    	Max = 1,
	    	Rounding = 2,
	    	Suffix = "x",
	    })
	    Options["silenttarget"]:OnChanged(ac.aim.refreshTargetParts)
	    ac.aim.refreshTargetParts()

	    local h = ay.Combat:AddRightGroupbox("Silent Aim")
	    h:AddToggle("silentenabled", {Text = "Silent Aim", Default = false})
	        :AddKeyPicker(
	    		"silentenabledbind",
	    		{ Default = "None", SyncToggleState = true, Mode = "Toggle", Text = "Silent Aim Keybind" }
	    	)
	    h:AddToggle("silentfovdraw", {Text = "Draw FOV Circle", Default = true})
	    h:AddLabel("FOV color"):AddColorPicker("silentfovcolor", { Default = Color3.fromRGB(255, 255, 255), Title = "FOV color" })
	    h:AddSlider("silentfovthickness", { Text = "FOV Thickness", Default = 1, Min = 1, Max = 6, Rounding = 0 })
	    h:AddToggle("snaplines", { Text = "Snapline", Default = false })
	    h:AddLabel("Line color"):AddColorPicker("snapcolor", { Default = Color3.fromRGB(255, 0, 0), Title = "Target line" })
	    h:AddSlider("snapwidth", { Text = "Line Width", Default = 1, Min = 1, Max = 4, Rounding = 0 })

	    local i = ay.Combat:AddRightGroupbox("Aimbot")
	    i:AddToggle("aimbotenabled", { Text = "Enabled", Default = false })
	    	:AddKeyPicker("aimbotkey", { Default = "E", SyncToggleState = false, Mode = "Hold", Text = "Aimbot Key" })
	    i:AddDropdown("aimbotmethod", { Text = "Aim Method", Values = { "Camera", "Mouse" }, Default = 1, Multi = false })
	    i:AddSlider("aimbotsmoothness", {
	    	Text = "Smoothness",
	    	Default = 1,
	    	Min = 1,
	    	Max = 20,
	    	Rounding = 1,
	    })

	    local j = ay.Combat:AddRightGroupbox("Gun Mods")
	    j:AddSlider("recoilside", { Text = "Recoil X", Default = 0, Min = 0, Max = 1, Rounding = 2 })
	    j:AddSlider("recoilup", { Text = "Recoil Y", Default = 0, Min = 0, Max = 1, Rounding = 2 })
	    j:AddSlider("spreadmult", { Text = "Spread Multiplier", Default = 0, Min = 0, Max = 1, Rounding = 2 })
	    j:AddSlider("fireratemult", { Text = "Firerate", Default = 1, Min = 0.1, Max = 5, Rounding = 2, Suffix = "x" })
	    j:AddToggle("instantreload", { Text = "Instant Reload", Default = false })
	    j:AddToggle("nokickback", { Text = "No Kickback", Default = true })
	    j:AddToggle("shootwhilerunning", { Text = "Run Shoot", Default = false })
	    j:AddToggle("shootwhilefalling", { Text = "Jump Shoot", Default = false })
	    j:AddToggle("reloadwhilerunning", { Text = "Run Reload", Default = false })
	    j:AddToggle("reloadwhilefalling", { Text = "Jump Reload", Default = false })
	    j:AddToggle("noreloadinterrupt", { Text = "Keep Reloading", Default = true })
	    j:AddToggle("fullaccuracy", { Text = "Force Accuracy", Default = false })
	    j:AddToggle("forceauto", { Text = "Force Auto", Default = false })
	    j:AddToggle("noviewbob", { Text = "No Viewbob", Default = false })

	    local k = ay.Combat:AddLeftGroupbox("Rage")
	    k:AddToggle("ragebot", { Text = "Ragebot", Default = false })
	    	:AddKeyPicker("ragebotbind", { Default = "None", SyncToggleState = true, Mode = "Toggle", Text = "Ragebot", Tooltip = "May require you to shoot once before working, idk why lol" })
	    k:AddToggle("rageallparts", { Text = "Check all parts", Default = false })
	    k:AddToggle("rageignorefov", { Text = "Ignore FOV", Default = true })
	    k:AddToggle("ragebotautoreload", { Text = "Auto Reload", Default = true })
	    k:AddToggle("ragebotwallbang", { Text = "Wallbang", Default = false })
	    k:AddToggle("ragebottraps", { Text = "Shoot Traps", Default = false })
	    k:AddDropdown("ragetraps", {
	    	Text = "Traps",
	    	Values = ac.aim.trapLabels,
	    	Default = { "Claymore", "Needle Mine", "Proximity Alarm", "Barbed Wire", "Shock Battery", "Incendiary Canister" },
	    	Multi = true,
	    })
	    k:AddToggle("manipulation", { Text = "Manipulation", Default = false })
	    k:AddSlider("manipulationdistance", {
	    	Text = "Max Manipulation Distance",
	    	Default = 1,
	    	Min = 0,
	    	Max = 4,
	    	Rounding = 2,
	    	Suffix = " studs",
	    })
	    k:AddDropdown("manipulationdepth", {
	    	Text = "Scan Depth",
	    	Values = { "Low", "Medium", "High" },
	    	Default = 1,
	    	Multi = false,
	    })
	end

	local g = ay.Visuals:AddLeftGroupbox("Tracers")
		g:AddToggle("tracersenabled", { Text = "Tracers", Default = false })
		g:AddLabel("Color"):AddColorPicker("tracercolor", { Default = Color3.fromRGB(255, 255, 255), Title = "Tracer" })
		g:AddDropdown("tracermaterial", {
			Text = "Material",
			Values = { "Neon", "ForceField", "SmoothPlastic", "Plastic", "Glass", "Metal" },
			Default = 1,
			Multi = false,
		})
		g:AddDropdown("tracertexture", {
			Text = "Texture",
			Values = { "None", "Glow", "Lightning" },
			Default = 1,
			Multi = false,
		})
		g:AddSlider("tracersize", { Text = "Thickness", Default = 0.12, Min = 0.02, Max = 1, Rounding = 2 })
		g:AddSlider("tracertransparency", { Text = "Transparency", Default = 0.25, Min = 0, Max = 1, Rounding = 2 })
		g:AddSlider("tracerlifetime", { Text = "Lifetime", Default = 1, Min = 0.1, Max = 5, Rounding = 1, Suffix = "s" })

	local function h()
		LPH_ATTRIBUTES(VM(NONE))
		local i = av()
		local j = i and i.values and i.values.equipped
		if j then
			if ad("fullaccuracy", false) and j.accuracy then
				j.accuracy.Value = 1
			end
			if ad("forceauto", false) then
				if j._vaultAuto == nil then
					j._vaultAuto = j.automatic
				end
				j.automatic = true
			elseif j._vaultAuto ~= nil then
				j.automatic = j._vaultAuto
				j._vaultAuto = nil
			end
			local function k(l, m, n, o)
				LPH_ATTRIBUTES(VM(NONE))
				if not (l and type(l.get) == "function") then
					return
				end
				if j[m .. "mul"] == n and j[m .. "inst"] == o then
					return
				end
				if not j[m] then
					j[m] = l.get
				end
				local p = j[m]
				j[m .. "mul"] = n
				j[m .. "inst"] = o
				if o then
					l.get = function()
						LPH_ATTRIBUTES(VM(NONE))
						return 0.01
					end
				elseif n == 1 then
					l.get = p
				else
					l.get = function(...)
						LPH_ATTRIBUTES(VM(NONE))
						return p(...) * n
					end
				end
			end
			if j.states then
				k(j.states.firerate, "_vaultFirerate", ae("fireratemult", 1), false)
				k(j.states.reload_speed, "_vaultReloadSpeed", 1, ad("instantreload", false))
			end
		end
		if ad("noviewbob", false) and i and i.values and i.values.bob_cframe then
			i.values.bob_cframe.Value = CFrame.new()
		end
	end

	local function i()
		if a0 then
			local j = av()
			local k = j and j.values and j.values.equipped
			if k and k.input_shoot then
				pcall(k.input_shoot, k, false)
			end
			a0 = false
		end
	end

	ac.combat = {
		updateTracers = aW,
		gunModStep = h,
		aimbotStep = a_,
		reloadStep = e,
		rageStep = f,
		release = i,
		unload = function()
			i()
			aV()
		end,
	}

end

function ab.step(ac)
end

function ab.unload()
end

return ab
end function a.k()local ab=a.cache.k if not ab then ab={c=aa()}a.cache.k=ab end return ab.c end end do local function aa()
local ab = a.f()

local ac = {}

function ac.build(ad)
	local ae = ad.tv
	local af = ad.ov
	local ag = ad.cloneOriginal
	local ah = ad.wrap
	local ai = ad.findGcFunction
	local aj = ad.Players
	local ak = ad.LocalPlayer
	local al = ad.UserInputService
	local am = ad.Lighting
	local an = ad.CollectionService
	local ao = ad.ReplicatedStorage
	local ap = ad.Modules
	local aq = ad.Gun
	local ar = ad.StateObject
	local as = ad.Util
	local at = ad.Targeting
	local au = ad.ESP
	local av = ad.Library
	local aw = ad.owner.getLocalOwner
	local ax = ad.owner.getLiveCharacter
	local ay = ad.owner.getViewmodel
	local az = ad.Tabs

	local aA
	pcall(function()
		aA = require(ap.Loadout)
	end)

	local function aB()
		local aC = ak:FindFirstChild("PlayerGui")
		if aC then
			local aD = aC:FindFirstChild("LoadoutMenu")
			if aD and aD:IsA("ScreenGui") and aD.Enabled then
				return true
			end
		end
		if aA and aA.main_menu and aA.main_menu.get then
			local aD, aE = pcall(function()
				return aA.main_menu:get()
			end)
			if aD and aE then
				return true
			end
		end
		return false
	end
	local aC = {}
	local aD = {}
	local function aE(aF)
		LPH_ATTRIBUTES(VM(NONE))
		if typeof(aF) ~= "Instance" then
			return
		end
		local aG = os.clock()
		local aH = aC[aF]
		if not aH or (aD[aF] or 0) + 0.5 < aG or not aF.Parent then
			aH = {}
			if aF:IsA("BasePart") or aF:IsA("Decal") then
				aH[1] = aF
			end
			for aI, aJ in aF:GetDescendants() do
				if aJ:IsA("BasePart") or aJ:IsA("Decal") then
					aH[#aH + 1] = aJ
				end
			end
			aC[aF] = aH
			aD[aF] = aG
		end
		for aI, aJ in aH do
			if aJ.Parent and aJ.LocalTransparencyModifier > 0.9 then
				aJ.LocalTransparencyModifier = 0
			end
		end
	end

	local function aF(aG)
		LPH_ATTRIBUTES(VM(NONE))
		if not aG then
			return
		end
		local aH = aw()
		local aI = aH and aH.values and aH.values.viewmodels
		if typeof(aI) ~= "Instance" then
			local aJ = workspace:FindFirstChild("Viewmodels")
			aI = aJ and aJ:FindFirstChild("LocalViewmodel")
		end
		if typeof(aI) == "Instance" then
			aE(aI)
		end
		aE(ak.Character)
		if aH and typeof(aH.instance) == "Instance" then
			aE(aH.instance)
		end
	end
	local aG = Drawing.new("Circle")
	aG.Filled = false
	aG.NumSides = 64
	aG.Visible = false

	local aH = Drawing.new("Line")
	aH.Visible = false

	local aI = Drawing.new("Text")
	aI.Text = "x"
	aI.Size = 24
	aI.Center = true
	aI.Outline = true
	aI.Color = Color3.fromRGB(255, 255, 255)
	aI.Visible = false
	local aJ = 0
	local function aK()
		local aL = ad.Camera.ViewportSize
		aI.Position = Vector2.new(aL.X / 2, aL.Y / 2)
		aI.Visible = true
		aJ = os.clock() + 0.12
	end
	local function aL()
		LPH_ATTRIBUTES(VM(NONE))
		local aM = ad.Camera.ViewportSize
		aG.Position = Vector2.new(aM.X / 2, aM.Y / 2)
		aG.Radius = af("silentfovsize", 100)
		aG.Color = af("silentfovcolor", Color3.fromRGB(255, 255, 255))
		aG.Thickness = af("silentfovthickness", 1)
		aG.Visible = ae("silentfovenabled", false) and ae("silentfovdraw", true)
	end

	local function aM()
		LPH_ATTRIBUTES(VM(NONE))
		local aN = ad.aim.cache.target
		local aO = aN and aN.Part
		if not (ae("snaplines", false) and aO and aO.Parent) then
			aH.Visible = false
			return
		end
		local aP, aQ, aR = ad.aim.projectScreen(aN.AimPoint or aO.Position)
		if not aP then
			aH.Visible = false
			return
		end
		if ae("silentfovenabled", false) and not ae("ragebot", false) and aR > af("silentfovsize", 100) then
			aH.Visible = false
			return
		end
		local aS = Vector2.new(ad.Camera.ViewportSize.X / 2, ad.Camera.ViewportSize.Y / 2)
		aH.From = aS
		aH.To = Vector2.new(aQ.X, aQ.Y)
		aH.Color = af("snapcolor", Color3.fromRGB(255, 0, 0))
		aH.Thickness = af("snapwidth", 1)
		aH.Visible = true
	end
	    au:Load({ Enabled = false, Players = false, LocalPlayer = false })
	    local aN = au:GetConfig()

	    local function aO()
	    	local aP = aN
	    	if not aP then
	    		return
	    	end

	    	
	    	aP.Enabled = Toggles.ESPMaster.Value
	    	aP.LocalPlayer = false 
	    	aP.MaxDistance = Options.ESPMaxDistance.Value
	    	aP.DynamicBoxes = true 
	     	aP.DynamicBoxesCheap = true
	    	aP.DynamicBoxesIncludeAll = false
	    	aP.Filter = function(aQ, aR)
	    	    if not aQ or not aR then
	    			return false
	    		end

	    		if not Toggles.ESPFilterTeam.Value then
	    			return true
	    		end

	    		return not at:is_friendly(aR)
	    	end

	    	
	    	aP.Boxes = Toggles.ESPBoxes.Value
	    	aP.BoxType = Options.ESPBoxType.Value
	    	aP.BoxColor = Options.ESPBoxColor.Value
	    	aP.BoxThickness = Options.ESPBoxThickness.Value
	    	aP.Outlines.Style = Toggles.ESPBoxOutline.Value and "Full" or "None"
	    	aP.Outlines.Color = Options.ESPBoxOutlineColor.Value

	    	
	    	aP.BoxFill.Enabled = Toggles.ESPBoxFill.Value
	    	aP.BoxFill.Color = Options.ESPBoxFillColor.Value
	    	aP.BoxFill.Transparency = Options.ESPBoxFillTransparency.Value

	    	
	    	aP.Names = Toggles.ESPNames.Value
	    	aP.TextColor = Options.ESPNameColor.Value
	    	aP.TextSize = Options.ESPTextSize.Value
	    	aP.TextOutline = Toggles.ESPTextOutline.Value
	    	aP.Distance.Enabled = Toggles.ESPDistance.Value
	    	aP.Distance.Color = Options.ESPDistanceColor.Value
	    	aP.Weapon.Enabled = Toggles.ESPWeapon.Value
	    	aP.Weapon.UseToolFallback = true 
	    	aP.TeamIndicator.Enabled = false
	    	aP.FriendlyIndicator.Enabled = false
	    	aP.FriendlyIndicator.CheckTeam = false
	    	aP.FriendlyIndicator.CheckFriends = false

	    	
	    	aP.HealthBar.Enabled = Toggles.ESPHealth.Value
	    	aP.HealthBar.ShowText = true

	    	
	    	
	    	aP.Chams.Enabled = Toggles.ESPChams.Value
	    	aP.Chams.Type = Options.ESPChamsType.Value

	    	local aQ = Options.ESPChamsFill.Value
	    	local aR = Options.ESPChamsFillT.Value
	    	local aS = Options.ESPChamsOutline.Value
	    	local aT = Options.ESPChamsOutlineT.Value
	    	local aU = Toggles.ESPChamsVisible.Value

	    	aP.Chams.Highlight.FillColor = aQ
	    	aP.Chams.Highlight.FillTransparency = aR
	    	aP.Chams.Highlight.OutlineColor = aS
	    	aP.Chams.Highlight.OutlineTransparency = aT
	    	aP.Chams.Highlight.VisibleCheck = aU

	    	aP.Chams.MeshChams.FillColor = aQ
	    	aP.Chams.MeshChams.FillTransparency = aR
	    	aP.Chams.MeshChams.OutlineColor = aS
	    	aP.Chams.MeshChams.OutlineTransparency = aT
	    	aP.Chams.MeshChams.VisibleCheck = aU

	    	aP.Chams.Adornment.Color = aQ
	    	aP.Chams.Adornment.Transparency = aR
	    	aP.Chams.Adornment.VisibleCheck = aU

	    	
	    	aP.OffScreenArrows.Enabled = Toggles.ESPArrows.Value
	    	aP.OffScreenArrows.Color = Options.ESPArrowColor.Value
	    	aP.OffScreenArrows.Size = Options.ESPArrowSize.Value
	    	aP.Directories = {}
	    end
	local aP = ai("render_bobbing", "Character")
	if aP then
		local aQ = ag(aP)
		hookfunction(aP, ah(function(aR, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if type(aR) ~= "table" then
				return
			end
			if ae("noviewbob", false) then
				if aR and aR.values and aR.values.bob_cframe then
					aR.values.bob_cframe.Value = CFrame.new()
				end
				return
			end
			return aQ(aR, ...)
		end))
	end
	local aQ, aR
	local function aS(aT, aU, aV)
		LPH_ATTRIBUTES(VM(NONE))
		if aT and aT.Parent then
			return aT
		end
		local aW = Instance.new("Highlight")
		aW.Name = aU
		aW.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		aW.Parent = aV or ak:FindFirstChild("PlayerGui") or workspace
		return aW
	end

	local aT = {}
	local aU = {}
	local aV = {}
	local function aW(aX)
		LPH_ATTRIBUTES(VM(NONE))
		if typeof(aX) ~= "Instance" then
			return nil
		end
		local aY = os.clock()
		local aZ = aT[aX]
		if aZ and (aU[aX] or 0) + 0.25 >= aY and aX.Parent then
			return aZ
		end
		ab.begin("chams.list")
		aZ = {}
		if aX:IsA("BasePart") then
			aZ[1] = aX
		end
		for a_, a0 in aX:GetDescendants() do
			if a0:IsA("BasePart") then
				aZ[#aZ + 1] = a0
			end
		end
		aT[aX] = aZ
		aU[aX] = aY
		ab.stop()
		return aZ
	end
	local function aX(aY, aZ, a_, a0)
		if a0 and (aY == a0 or aY:IsDescendantOf(a0)) then
			return true
		end
		if aZ and aZ[aY.Name] then
			return true
		end
		if a_ and not a_[aY.Name] then
			return true
		end
		return false
	end
	local function aY(aZ, a_, a0, b, c, d, e)
		LPH_ATTRIBUTES(VM(NONE))
		local f = aW(aZ)
		if not f then
			return
		end
		local g = Enum.Material[a_] or Enum.Material.ForceField
		ab.begin("chams.write")
		for h, i in f do
			if not i.Parent or aX(i, c, d, e) then
				continue
			end
			if not aV[i] then
				aV[i] = {
					Material = i.Material,
					Color = i.Color,
					LocalTransparencyModifier = i.LocalTransparencyModifier,
				}
			end
			if i.Material ~= g then
				i.Material = g
			end
			if i.Color ~= a0 then
				i.Color = a0
			end
			if i.LocalTransparencyModifier ~= b then
				i.LocalTransparencyModifier = b
			end
		end
		ab.stop()
	end
	local function aZ(a_, a0)
		LPH_ATTRIBUTES(VM(NONE))
		local b = aT[a_]
		if not b then
			return
		end
		for c, d in b do
			if a0 and d.Parent and (d == a0 or d:IsDescendantOf(a0)) then
				continue
			end
			local e = aV[d]
			if e and d.Parent then
				d.Material = e.Material
				d.Color = e.Color
				d.LocalTransparencyModifier = e.LocalTransparencyModifier
			end
			aV[d] = nil
		end
	end

	local a_ = {
		head = true, torso = true, arm1 = true, arm2 = true, leg1 = true, leg2 = true,
		shoulder1 = true, shoulder2 = true, hip1 = true, hip2 = true,
	}
	local a0
	local b = {}
	local c = {}
	local function d(e)
		LPH_ATTRIBUTES(VM(NONE))
		local f = b[e]
		if f and not f.Parent then
			f = nil
			b[e] = nil
		end
		if not f then
			local g = os.clock()
			if (c[e] or 0) > g then
				return
			end
			local h = ak:FindFirstChild("PlayerGui")
			f = h and h:FindFirstChild(e)
			b[e] = f
			if not f then
				c[e] = g + 1
				return
			end
		end
		if f:IsA("ScreenGui") then
			f.Enabled = false
		elseif f:IsA("GuiObject") then
			f.Visible = false
			f.BackgroundTransparency = 1
		end
	end
	local e
	local function f()
		LPH_ATTRIBUTES(VM(NONE))
		ab.begin("visuals.hitmarker")
		if aJ > 0 and os.clock() > aJ then
			aI.Visible = false
			aJ = 0
		end
		ab.stop()

		ab.begin("visuals.fov")
		if ae("customfov", false) then
			if a0 == nil then
				a0 = ad.Camera.FieldOfView
			end
			ad.Camera.FieldOfView = af("customfovvalue", 90)
		elseif a0 ~= nil then
			ad.Camera.FieldOfView = a0
			a0 = nil
		end
		ab.stop()

		ab.begin("visuals.overlays")
		if ae("noflash", false) then
			d("Flash")
		end
		if ae("nostun", false) then
			d("Stun")
			d("Deaf")
			d("Ring")
		end
		ab.stop()

		ab.begin("visuals.applyChams")
		e()
		ab.stop()
	end
	local function g(h)
		for i, j in h:GetChildren() do
			if j.Name == "Model" and j:FindFirstChild("torso") then
				return j
			end
		end
		return nil
	end
	local function h(i)
		if typeof(i) ~= "Instance" then
			return nil
		end
		for j, k in i:GetChildren() do
			if k:IsA("Model") and k:FindFirstChild("Root") then
				return k
			end
		end
		return nil
	end
	e = function()
		LPH_ATTRIBUTES(VM(NONE))
		ab.begin("chams.find")
		local i = workspace:FindFirstChild("Viewmodels")
		local j = i and i:FindFirstChild("LocalViewmodel")
		local k = ae("wepchams", false)
		local l = ae("vmchams", false)
		local m = aw()
		local n = m and m.values and m.values.equipped
		local o = h(j) or (n and n.instance)
		local p = j and g(j)
		ab.stop()
		if not l then
			ab.begin("chams.restoreVm")
			aZ(j, k and o or nil)
			if aQ then
				aQ.Enabled = false
			end
			ab.stop()
		end
		if not k then
			ab.begin("chams.restoreWep")
			aZ(o)
			if aR then
				aR.Enabled = false
			end
			ab.stop()
		end
		if l and j then
			ab.begin("chams.vm")
			if aQ then
				aQ.Enabled = false
			end
			aY(j, af("vmmaterial", "ForceField"), af("vmchamcolor", Color3.fromRGB(59, 144, 204)), af("vmtransparency", 0.4), nil, nil, o)
			if p then
				aQ = aS(aQ, "vault_vmcham", p)
				aQ.Adornee = p
				aQ.FillColor = af("vmchamcolor", Color3.fromRGB(59, 144, 204))
				aQ.FillTransparency = af("vmtransparency", 0.4)
				aQ.OutlineTransparency = 1
				aQ.Enabled = true
			end
			ab.stop()
		end
		if k and typeof(o) == "Instance" then
			ab.begin("chams.wep")
			aR = aS(aR, "vault_wepcham", o)
			aR.Adornee = o
			aR.FillColor = af("wepchamcolor", Color3.fromRGB(255, 255, 255))
			aR.FillTransparency = af("weptransparency", 0.3)
			aR.OutlineTransparency = 1
			aR.Enabled = true
			aY(o, af("wepmaterial", "ForceField"), af("wepchamcolor", Color3.fromRGB(255, 255, 255)), af("weptransparency", 0.3), a_)
			ab.stop()
		end
	end
	local i = ai("attach_camera", "Character")

	local j
	local k
	local l = 0
	local function m()
		LPH_ATTRIBUTES(VM(NONE))
		if ae("antiaim", false) or aB() then
			k = nil
			return
		end
		local n = ad.Camera
		local o = aw()
		local p = o and o.values and o.values.viewmodels
		if not n or typeof(p) ~= "Instance" then
			return
		end
		local q = os.clock()
		local r = q - l
		l = q
		if r < 0 or r > 0.2 then
			r = 0.016
		end
		local s = n.CFrame.LookVector
		if not k or k.Magnitude < 0.001 then
			k = s
		end
		k = k:Lerp(s, 1 - math.exp(-8 * r))
		if k.Magnitude < 0.001 then
			return
		end
		k = k.Unit
		local t = Vector3.new(k.X, 0, k.Z)
		if t.Magnitude < 0.001 then
			t = Vector3.new(n.CFrame.LookVector.X, 0, n.CFrame.LookVector.Z)
		end
		if t.Magnitude < 0.001 then
			return
		end
		local u = p:FindFirstChild("torso")
		if not u then
			return
		end
		local v, w = u:GetPivot():ToOrientation()
		local x, y = CFrame.lookAt(Vector3.zero, t.Unit):ToOrientation()
		local z = math.atan2(math.sin(y - w), math.cos(y - w))
		if math.abs(z) < 0.02 then
			return
		end
		local A = CFrame.new(u:GetPivot().Position)
		local B = A * CFrame.Angles(0, z, 0) * A:Inverse()
		local C = p:FindFirstChild("head")
		if C and C:IsA("BasePart") then
			C:PivotTo(B * C:GetPivot())
		end
		C = p:FindFirstChild("head")
		if C then
			local D = C:GetPivot().Position
			C:PivotTo(CFrame.lookAt(D, D + k))
		end
	end
	local function n()
		LPH_ATTRIBUTES(VM(NONE))
		local o = aw()
		if o then
			local p = o.values and o.values.equipped
			if p and typeof(p.shot) == "Instance" then
				j = p.shot.CFrame
				return j
			end
			if not ae("antiaim", false) then
				local q = o.states and o.states.look
				local r = q and q.get and q:get()
				local s = o.instance
				local t = typeof(s) == "Instance" and (s:FindFirstChild("head") or s:FindFirstChild("Head"))
				if t and typeof(r) == "Vector3" and r.Magnitude > 0.001 then
					j = CFrame.lookAt(t.Position, t.Position + r)
					return j
				end
			end
		end
		return j or ad.Camera.CFrame
	end

	local function o(p)
		if not p or not p:IsA("BasePart") then
			return
		end
		p.LocalTransparencyModifier = 0
		if p.Transparency > 0.9 then
			p.Transparency = p:GetAttribute("OriginalTransparency") or 0
		end
	end
	local p
	local q = 0
	local function r()
		LPH_ATTRIBUTES(VM(NONE))
		if not ae("thirdperson", false) or aB() then
			ad.aaPose = nil
			p = nil
			return
		end
		local s = aw()
		local t = s and s.values and s.values.viewmodels
		if typeof(t) ~= "Instance" or not ad.Camera then
			ad.aaPose = nil
			return
		end
		local u, w, x
		if ad.movement and ad.movement.getAim then
			u, w, x = ad.movement.getAim()
		end
		if not u then
			ad.aaPose = nil
			p = nil
			return
		end
		local y, z = ad.Camera.CFrame:ToOrientation()
		local A = (w or z) - z
		if x == nil then
			x = ae("antiaimpitch", false)
		end
		local B = os.clock()
		local C = B - q
		q = B
		if C < 0 or C > 0.2 then
			C = 0.016
		end
		if not p or p.Magnitude < 0.001 then
			p = ad.Camera.CFrame.LookVector
		end
		p = p:Lerp(u, 1 - math.exp(-8 * C))
		if p.Magnitude > 0.001 then
			p = p.Unit
		end
		if math.abs(A) < 0.001 and not x and p:Dot(ad.Camera.CFrame.LookVector) > 0.999 then
			ad.aaPose = nil
			return
		end
		local D = s.instance and (s.instance:FindFirstChild("HumanoidRootPart") or s.instance:FindFirstChild("Root"))
		local E = t:FindFirstChild("torso")
		local F = (D and D.Position) or (E and E:IsA("BasePart") and E.Position)
		if not F then
			return
		end
		if math.abs(A) > 0.001 then
			local G = CFrame.new(F)
			local H = G * CFrame.Angles(0, A, 0) * G:Inverse()
			for I, J in t:GetChildren() do
				if J:IsA("BasePart") then
					J:PivotTo(H * J:GetPivot())
					o(J)
				end
			end
			local I = s.values and (s.values.equipped or s.values.holding)
			local J = I and I.instance
			if typeof(J) ~= "Instance" then
				for K, L in t:GetChildren() do
					if L:IsA("Model") and L:FindFirstChild("Root") then
						J = L
						break
					end
				end
			end
			if typeof(J) == "Instance" then
				J:PivotTo(H * J:GetPivot())
			end
		end
		local G = s.values and (s.values.equipped or s.values.holding)
		local H = G and G.instance
		if typeof(H) ~= "Instance" then
			for I, J in t:GetChildren() do
				if J:IsA("Model") and J:FindFirstChild("Root") then
					H = J
					break
				end
			end
		end
		local I = t:FindFirstChild("head")
		if I and I:IsA("BasePart") and p then
			local J = I:GetPivot().Position
			I:PivotTo(CFrame.lookAt(J, J + p))
			o(I)
		end
		if E and E:IsA("BasePart") and p then
			local J = CFrame.Angles(0, A, 0) * ad.Camera.CFrame.Rotation
			local K = CFrame.lookAt(Vector3.zero, p).Rotation
			local L = K * J:Inverse()
			local M = L.LookVector:Dot(Vector3.new(0, 0, -1)) > 0.9995 and L.UpVector.Y > 0.9995
			if not M then
				local N = (E.CFrame * CFrame.new(0, E.Size.Y * 0.5, 0)).Position
				local O = CFrame.new(N) * L * CFrame.new(-N)
				local function P(Q)
					if typeof(Q) ~= "Instance" then
						return
					end
					if Q:IsA("BasePart") then
						Q:PivotTo(O * Q:GetPivot())
						o(Q)
					elseif Q:IsA("Model") then
						Q:PivotTo(O * Q:GetPivot())
					end
				end
				for Q, R in { "arm1", "arm2", "shoulder1", "shoulder2" } do
					P(t:FindFirstChild(R))
				end
				P(H)
			end
		end
		local J = { "torso", "head", "arm1", "arm2", "shoulder1", "shoulder2", "leg1", "leg2", "hip1", "hip2" }
		for K, L in t:GetChildren() do
			if L.Name == "Model" then
				for M, N in J do
					local O = t:FindFirstChild(N)
					local P = L:FindFirstChild(N)
					if O and P and O:IsA("BasePart") then
						P:PivotTo(O:GetPivot())
					end
				end
			end
		end
		local K = {}
		for L, M in J do
			local N = t:FindFirstChild(M)
			if N and N:IsA("BasePart") then
				K[M] = N:GetPivot()
			end
		end
		ad.aaPose = { at = os.clock(), parts = K }
	end

	local function s()
		LPH_ATTRIBUTES(VM(NONE))
		ad.Camera = workspace.CurrentCamera
		if not ae("thirdperson", false) or aB() or not ad.Camera then
			return
		end
		local t = aw()
		local u = t and t.instance
		local w = typeof(u) == "Instance" and (u:FindFirstChild("HumanoidRootPart") or u:FindFirstChild("Root"))
		if not w then
			return
		end
		local x = ad.Camera.CFrame.Position
		local y = Vector3.new(x.X - w.Position.X, 0, x.Z - w.Position.Z)
		if y.Magnitude <= 1.5 then
			return
		end
		local z = w.Position.Y + 1.6
		local A = t.states and t.states.walk_state and t.states.walk_state.get and t.states.walk_state:get()
		if A == "crouch" then
			z = w.Position.Y + 0.8
		elseif A == "prone" then
			z = w.Position.Y + 0.35
		end
		ad.Camera.CFrame = CFrame.new(w.Position.X, z, w.Position.Z) * ad.Camera.CFrame.Rotation
	end
	local function t()
		LPH_ATTRIBUTES(VM(NONE))
		ad.Camera = workspace.CurrentCamera
		local u = ae("thirdperson", false)
		local w = aB()
		local x = al.TouchEnabled and not al.KeyboardEnabled
		if not (u and not w) then
			if x and ad._tpCamMode then
				ak.CameraMode = ad._tpCamMode
				ad._tpCamMode = nil
			end
			j = ad.Camera.CFrame
			return
		end
		if x then
			if not ad._tpCamMode then
				ad._tpCamMode = ak.CameraMode
			end
			ak.CameraMode = Enum.CameraMode.Classic
		end
		local y = ad.Camera.CFrame
		j = y
		m()
		local z = y:VectorToWorldSpace(Vector3.new(0, af("tpheight", 2), af("tpdistance", 8)))
		local A = y.Position + z
		ad.Camera.CFrame = CFrame.new(A) * y.Rotation
		aF(true)
	end

	if i then
		local u = ag(i)
		hookfunction(i, ah(function(...)
			LPH_ATTRIBUTES(VM(NONE))
			local w, x, y, z = pcall(u, ...)
			if w then
				j = workspace.CurrentCamera.CFrame
			end
			if not w then
				warn(x)
				return
			end
			return x, y, z
		end))
	end

	local u = ai("can_climb", "FirstPersonInterface")
	if u then
		local w = ag(u)
		hookfunction(u, ah(function(x, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if not (ae("thirdperson", false) or ae("antiaim", false)) or not j or type(x) ~= "table" then
				return w(x, ...)
			end
			local y = x.values and x.values.camera and x.values.camera.get and x.values.camera:get()
			if typeof(y) ~= "Instance" then
				return w(x, ...)
			end
			local z = y.CFrame
			local A = x.values and x.values.viewmodels
			local B = {}
			if typeof(A) == "Instance" then
				for C, D in A:GetDescendants() do
					if D:IsA("BasePart") then
						B[D] = D.CanQuery
						D.CanQuery = false
					end
				end
			end
			y.CFrame = j
			local C, D, E, F = pcall(w, x, ...)
			y.CFrame = z
			for G, H in B do
				G.CanQuery = H
			end
			if not C then
				return
			end
			return D, E, F
		end))
	end

	if type(aq.send_melee) == "function" then
		local w = ag(aq.send_melee)
		hookfunction(aq.send_melee, ah(function(x, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if not (ae("thirdperson", false) and j) then
				return w(x, ...)
			end
			if type(x) ~= "table" or not x.states then
				return w(x, ...)
			end
			local y = n()
			pcall(function()
				x.states.melee:fire_instant()
			end)
			local z = x.owner
			local A = (tonumber(x.melee_range) or 2.75) + 0.2
			if x.client_sided_hitscan and z then
				local B = x:ray_damage(y.Position - y.LookVector * 0.2, y.LookVector * A, { z.values.viewmodels, z.instance }, 0.2)
				x.states.hit:fire(y, B)
			else
				x.states.hit:fire(y)
			end
		end))
	end

	    
	    local w = az.ESP:AddLeftGroupbox("Main")
	    w:AddToggle("ESPMaster", { Text = "Enabled", Default = false })
	    w:AddToggle(
	    	"ESPFilterTeam",
	    	{ Text = "Exclude Teammates", Default = false }
	    )
	    w:AddSlider(
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

	    
	    local x = az.ESP:AddLeftGroupbox("Boxes")
	    x:AddToggle("ESPBoxes", { Text = "Boxes", Default = true })
	    x:AddDropdown("ESPBoxType", { Text = "Box type", Values = { "Normal", "Corner" }, Default = 1, Multi = false })
	    x
	    	:AddLabel("Box color")
	    	:AddColorPicker("ESPBoxColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Box color" })
	    x:AddSlider("ESPBoxThickness", { Text = "Box thickness", Default = 1, Min = 1, Max = 6, Rounding = 0 })
	    x:AddToggle("ESPBoxOutline", { Text = "Box outline", Default = true })
	    x
	    	:AddLabel("Outline color")
	    	:AddColorPicker("ESPBoxOutlineColor", { Default = Color3.fromRGB(0, 0, 0), Title = "Outline color" })
	    x:AddDivider()
	    x:AddToggle("ESPBoxFill", { Text = "Box fill", Default = false })
	    x
	    	:AddLabel("Fill color")
	    	:AddColorPicker("ESPBoxFillColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Fill color" })
	    x:AddSlider(
	    	"ESPBoxFillTransparency",
	    	{ Text = "Fill transparency", Default = 0.9, Min = 0, Max = 1, Rounding = 2 }
	    )

	    
	    local y = az.ESP:AddLeftGroupbox("Chams")
	    y:AddToggle("ESPChams", { Text = "Chams", Default = false })
	    y:AddDropdown(
	    	"ESPChamsType",
	    	{
	    		Text = "Chams type",
	    		Values = { "Highlight", "Adornment", "MeshChams" },
	     		Default = 1,
	     		Multi = false,
	     	}
	    )
	    y
	    	:AddLabel("Fill color")
	    	:AddColorPicker("ESPChamsFill", { Default = Color3.fromRGB(59, 144, 204), Title = "Cham fill" })
	    y:AddSlider("ESPChamsFillT", { Text = "Fill transparency", Default = 0.6, Min = 0, Max = 1, Rounding = 2 })
	    y
	    	:AddLabel("Outline color")
	    	:AddColorPicker("ESPChamsOutline", { Default = Color3.fromRGB(255, 255, 255), Title = "Cham outline" })
	    y:AddSlider("ESPChamsOutlineT", { Text = "Outline transparency", Default = 0, Min = 0, Max = 1, Rounding = 2 })
	    y:AddToggle(
	    	"ESPChamsVisible",
	    	{ Text = "Visible check", Default = false }
	    )

	    
	    local z = az.ESP:AddRightGroupbox("Names & Info")
	    z:AddToggle("ESPNames", { Text = "Names", Default = true })
	    z
	    	:AddLabel("Name color")
	    	:AddColorPicker("ESPNameColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Name color" })
	    z:AddSlider("ESPTextSize", { Text = "Text size", Default = 12, Min = 6, Max = 28, Rounding = 0 })
	    z:AddToggle("ESPTextOutline", { Text = "Text outline", Default = true })
	    z:AddDivider()
	    z:AddToggle("ESPDistance", { Text = "Distance", Default = false })
	    z
	    	:AddLabel("Distance color")
	    	:AddColorPicker("ESPDistanceColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Distance color" })
	    z:AddToggle("ESPWeapon", { Text = "Weapon", Default = false })

	    
	    local A = az.ESP:AddRightGroupbox("Health")
	    A:AddToggle("ESPHealth", { Text = "Health", Default = false })

	    
	    local B = az.ESP:AddRightGroupbox("OOF Arrows")
	    B:AddToggle("ESPArrows", { Text = "Off-screen arrows", Default = false })
	    B
	    	:AddLabel("Arrow color")
	    	:AddColorPicker("ESPArrowColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Arrow color" })
	    B:AddSlider("ESPArrowSize", { Text = "Arrow size", Default = 14, Min = 8, Max = 40, Rounding = 0 })

	    
	    
	    local C = {
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
	                   }
	    local D = {
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
	               }

	    for E, F in ipairs(C) do
	    	Toggles[F]:OnChanged(aO)
	    end
	    for E, F in ipairs(D) do
	    	Options[F]:OnChanged(aO)
	    end

	    aO()
		local E = az.Visuals:AddLeftGroupbox("Viewmodel")
		E:AddToggle("vmchams", { Text = "Viewmodel Chams", Default = false })
			:AddColorPicker("vmchamcolor", { Default = Color3.fromRGB(59, 144, 204), Title = "Viewmodel" })
		E:AddDropdown("vmmaterial", {
			Text = "Material",
			Values = { "ForceField", "Neon", "SmoothPlastic", "Plastic", "Glass", "Metal" },
			Default = 1,
			Multi = false,
		})
		E:AddSlider("vmtransparency", { Text = "Transparency", Default = 0.4, Min = 0, Max = 1, Rounding = 2 })
		E:AddToggle("wepchams", { Text = "Weapon Chams", Default = false })
			:AddColorPicker("wepchamcolor", { Default = Color3.fromRGB(255, 255, 255), Title = "Weapon" })
		E:AddDropdown("wepmaterial", {
			Text = "Weapon Material",
			Values = { "ForceField", "Neon", "SmoothPlastic", "Plastic", "Glass", "Metal" },
			Default = 1,
			Multi = false,
		})
		E:AddSlider("weptransparency", { Text = "Weapon Transparency", Default = 0.3, Min = 0, Max = 1, Rounding = 2 })

		local F = az.Visuals:AddRightGroupbox("Camera")
		F:AddToggle("customfov", { Text = "Custom FOV", Default = false })
		F:AddSlider("customfovvalue", { Text = "FOV", Default = 90, Min = 40, Max = 120, Rounding = 0 })
		F:AddToggle("thirdperson", { Text = "Third Person", Default = false })
			:AddKeyPicker("thirdpersonbind", { Default = "None", SyncToggleState = true, Mode = "Toggle", Text = "Third Person" })
		F:AddSlider("tpdistance", { Text = "Distance", Default = 8, Min = 2, Max = 20, Rounding = 1 })
		F:AddSlider("tpheight", { Text = "Height", Default = 2, Min = 0, Max = 8, Rounding = 1 })
		F:AddToggle("noflash", { Text = "No Flash", Default = false })
		F:AddToggle("nostun", { Text = "No Stun", Default = false })
		F:AddToggle("instantinteract", { Text = "Instant Interact", Default = false })

	local function G()
		if aG then
			aG:Remove()
			aG = nil
		end
		if aH then
			aH:Remove()
			aH = nil
		end
		if aI then
			aI:Remove()
			aI = nil
		end
		if aQ then
			aQ:Destroy()
			aQ = nil
		end
		if aR then
			aR:Destroy()
			aR = nil
		end
	end

	ad.visuals = {
		updateFOV = aL,
		updateSnap = aM,
		step = f,
		applyThirdPerson = t,
		prepareThirdPerson = s,
		poseThirdPerson = r,
		applyChams = function()
			if e then
				e()
			end
		end,
		applyESP = aO,
		unload = G,
	}
	ac.step = f
	ac.unload = G

end

function ac.step(ad)
end

function ac.unload()
end

return ac
end function a.l()local ab=a.cache.l if not ab then ab={c=aa()}a.cache.l=ab end return ab.c end end do local function aa()
local ab = a.f()

local ac = {}

function ac.build(ad)
	local ae = ad.tv
	local af = ad.ov
	local ag = ad.cloneOriginal
	local ah = ad.wrap
	local ai = ad.findGcFunction
	local aj = ad.Players
	local ak = ad.LocalPlayer
	local al = ad.UserInputService
	local am = ad.Lighting
	local an = ad.CollectionService
	local ao = ad.ReplicatedStorage
	local ap = ad.Modules
	local aq = ad.Gun
	local ar = ad.StateObject
	local as = ad.Util
	local at = ad.Targeting
	local au = ad.ESP
	local av = ad.Library
	local aw = ad.owner.getLocalOwner
	local ax = ad.owner.getLiveCharacter
	local ay = ad.owner.getViewmodel
	local az = ad.Tabs

	local aA = ad.aim.trapTypes
	local aB = ad.aim.gadgetTypes
	local aC
	local function aD()
		if aC then
			return
		end
		aC = {
			Brightness = am.Brightness,
			ClockTime = am.ClockTime,
			GlobalShadows = am.GlobalShadows,
			Ambient = am.Ambient,
			OutdoorAmbient = am.OutdoorAmbient,
		}
	end

	local function aE()
		if not aC then
			return
		end
		am.Brightness = aC.Brightness
		am.ClockTime = aC.ClockTime
		am.GlobalShadows = aC.GlobalShadows
		am.Ambient = aC.Ambient
		am.OutdoorAmbient = aC.OutdoorAmbient
	end

	local aF = {
		{ toggle = "ESPCameras", color = "ESPCameraColor", default = Color3.fromRGB(255, 220, 80), tags = { "DefaultCamera", "BulletproofCamera", "StickyCamera" }, label = "Camera" },
		{ toggle = "ESPDrones", color = "ESPDroneColor", default = Color3.fromRGB(80, 200, 255), tags = { "Drone" }, label = "Drone" },
	}
	for aG, aH in aA do
		aF[#aF + 1] = {
			toggle = "ESP" .. aH.tag,
			color = "ESP" .. aH.tag .. "Color",
			default = Color3.fromRGB(255, 80, 80),
			tags = { aH.tag },
			label = aH.label,
		}
	end
	for aG, aH in aB do
		aF[#aF + 1] = {
			toggle = "ESP" .. aH.tag,
			color = "ESP" .. aH.tag .. "Color",
			default = Color3.fromRGB(255, 160, 60),
			tags = { aH.tag },
			label = aH.label,
		}
	end

	local aG = {}
	local aH = 0

	local function aI()
		aH += 1
		local aJ = aG[aH]
		if not aJ then
			aJ = Drawing.new("Text")
			aJ.Center = true
			aJ.Outline = true
			aJ.Size = 13
			aG[aH] = aJ
		end
		return aJ
	end

	local function aJ()
		for aK = aH + 1, #aG do
			aG[aK].Visible = false
		end
	end

	local function aK()
		for aL, aM in aG do
			aM:Remove()
		end
		table.clear(aG)
		aH = 0
	end

	local function aL(aM)
		if aM:IsA("BasePart") then
			if aM.Transparency < 1 and aM.Size.Magnitude > 0.05 then
				return aM
			end
			return nil
		end
		local aN = aM:IsA("Model") and aM.PrimaryPart
		if aN and aN.Transparency < 1 then
			return aN
		end
		for aO, aP in aM:GetChildren() do
			if aP:IsA("BasePart") and aP.Transparency < 1 and aP.Size.Magnitude > 0.05 then
				return aP
			end
		end
		return nil
	end

	local function aM(aN)
		local aO = aN:FindFirstChild("Root")
		if aO and aO:IsA("BasePart") then
			return aO
		end
		if aN:IsA("Model") and aN.PrimaryPart then
			return aN.PrimaryPart
		end
		if aN:IsA("BasePart") then
			return aN
		end
		return nil
	end

	local function aN(aO)
		if not aO or not aO.Parent then
			return false
		end
		local aP = aO.Parent
		if aP.Name == "Garbage" or aP == ao then
			return false
		end
		if aO:GetAttribute("Destroyed") or aP:GetAttribute("Destroyed") then
			return false
		end
		local aQ = aO:FindFirstChild("ClientModel")
		if aQ and aQ:IsA("ObjectValue") then
			local aR = aQ.Value
			if typeof(aR) == "Instance" and aR.Parent and aR ~= aO then
				local aS = aR.Parent
				if aS.Name ~= "Garbage" and aS ~= ao and not aR:GetAttribute("Destroyed") then
					return aM(aR) or aL(aR)
				end
			end
		end
		local aR = aL(aO)
		if aR then
			return aR
		end
		if aO:HasTag("Thrown") then
			return aM(aO)
		end
		return false
	end

	local aO, aP = {}, 0
	local function aQ()
		LPH_ATTRIBUTES(VM(NONE))
		ab.begin("world.espStep")
		aH = 0
		if not ae("ESPWorld", false) then
			aJ()
			ab.stop()
			return
		end

		local aR = af("ESPMaxDistance", 0)
		if aR <= 0 then
			aR = math.huge
		end
		local aS = ad.Camera.CFrame.Position
		local aT = os.clock()
		if aT - aP > 0.35 then
			aP = aT
			table.clear(aO)
			for aU, aV in aF do
				if not ae(aV.toggle, false) then
					continue
				end
				for aW, aX in aV.tags do
					aO[aX] = an:GetTagged(aX)
				end
			end
		end

		for aU, aV in aF do
			if not ae(aV.toggle, false) then
				continue
			end
			local aW = af(aV.color, aV.default)
			for aX, aY in aV.tags do
				local aZ = aO[aY]
				if not aZ then
					continue
				end
				for a_, a0 in aZ do
					if aH >= 60 then
						break
					end
					local b = aN(a0)
					if not b then
						continue
					end
					local c = (aS - b.Position).Magnitude
					if c > aR then
						continue
					end
					local d, e = ad.Camera:WorldToViewportPoint(b.Position)
					if not e or d.Z <= 0 then
						continue
					end
					local f = aI()
					f.Text = `{aV.label} [{math.floor(c)}]`
					f.Position = Vector2.new(d.X, d.Y)
					f.Color = aW
					f.Visible = true
				end
			end
		end
		aJ()
		ab.stop()
	end
	local aR
	local aS = {
		Night = "rbxassetid://12064107",
		Nebula = "rbxassetid://159454286",
		Sunset = "rbxassetid://151165214",
	}
	local function aT()
		LPH_ATTRIBUTES(VM(NONE))
			if ae("fullbright", false) then
				aD()
				am.Brightness = af("worldbrightness", 2)
				am.ClockTime = 12
				am.GlobalShadows = ae("worldshadows", false)
				am.Ambient = af("worldambient", Color3.fromRGB(255, 255, 255))
				am.OutdoorAmbient = af("worldoutdoor", Color3.fromRGB(255, 255, 255))
			elseif aC then
				aE()
				aC = nil
			end

			if ae("customsky", false) then
				local aU = am:FindFirstChildOfClass("Sky")
				if aU then
					if not aR then
						aR = { Bk = aU.SkyboxBk, Dn = aU.SkyboxDn, Ft = aU.SkyboxFt, Lf = aU.SkyboxLf, Rt = aU.SkyboxRt, Up = aU.SkyboxUp }
					end
					local aV = aS[af("skybox", "Default")]
					if aV then
						aU.SkyboxBk, aU.SkyboxDn, aU.SkyboxFt, aU.SkyboxLf, aU.SkyboxRt, aU.SkyboxUp = aV, aV, aV, aV, aV, aV
					end
				end
			elseif aR then
				local aU = am:FindFirstChildOfClass("Sky")
				if aU then
					aU.SkyboxBk, aU.SkyboxDn, aU.SkyboxFt, aU.SkyboxLf, aU.SkyboxRt, aU.SkyboxUp =
						aR.Bk, aR.Dn, aR.Ft, aR.Lf, aR.Rt, aR.Up
				end
				aR = nil
			end
	end
	    local aU = az.ESP:AddRightGroupbox("World")
	    aU:AddToggle("ESPWorld", { Text = "World ESP", Default = false })
	    aU:AddToggle("ESPCameras", { Text = "Cameras", Default = true })
	    	:AddColorPicker("ESPCameraColor", { Default = Color3.fromRGB(255, 220, 80), Title = "Cameras" })
	    aU:AddToggle("ESPDrones", { Text = "Drones", Default = true })
	    	:AddColorPicker("ESPDroneColor", { Default = Color3.fromRGB(80, 200, 255), Title = "Drones" })

	    local aV = az.ESP:AddRightGroupbox("Traps")
	    for aW, aX in aA do
	    	aV:AddToggle("ESP" .. aX.tag, { Text = aX.label, Default = true })
	    		:AddColorPicker("ESP" .. aX.tag .. "Color", { Default = Color3.fromRGB(255, 80, 80), Title = aX.label })
	    end
	    local aW = az.ESP:AddRightGroupbox("Gadgets")
	    for aX, aY in aB do
	    	aW:AddToggle("ESP" .. aY.tag, { Text = aY.label, Default = true })
	    		:AddColorPicker("ESP" .. aY.tag .. "Color", { Default = Color3.fromRGB(255, 160, 60), Title = aY.label })
	    end
		local aX = az.Visuals:AddRightGroupbox("Atmosphere")
		aX:AddToggle("fullbright", { Text = "Fullbright", Default = false })
		aX:AddToggle("worldshadows", { Text = "Shadows", Default = false })
		aX:AddSlider("worldbrightness", { Text = "Brightness", Default = 2, Min = 0, Max = 10, Rounding = 1 })
		aX:AddLabel("Ambient"):AddColorPicker("worldambient", { Default = Color3.fromRGB(255, 255, 255), Title = "Ambient" })
		aX:AddLabel("Outdoor"):AddColorPicker("worldoutdoor", { Default = Color3.fromRGB(255, 255, 255), Title = "Outdoor" })
		aX:AddToggle("customsky", { Text = "Custom Sky", Default = false })
		aX:AddDropdown("skybox", {
			Text = "Skybox",
			Values = { "Default", "Night", "Nebula", "Sunset" },
			Default = 1,
			Multi = false,
		})

	local function aY()
		aK()
		aE()
	end

	ad.world = {
		applyLighting = aT,
		espStep = aQ,
		unload = aY,
	}

end

function ac.step(ad)
end

function ac.unload()
end

return ac
end function a.m()local ab=a.cache.m if not ab then ab={c=aa()}a.cache.m=ab end return ab.c end end do local function aa()
local ab = {}

function ab.build(ac)
	local ad = ac.tv
	local ae = ac.ov
	local af = ac.cloneOriginal
	local ag = ac.wrap
	local ah = ac.findGcFunction
	local ai = ac.Players
	local aj = ac.LocalPlayer
	local ak = ac.UserInputService
	local al = ac.Lighting
	local am = ac.CollectionService
	local an = ac.ReplicatedStorage
	local ao = ac.Modules
	local ap = ac.Gun
	local aq = ac.StateObject
	local ar = ac.Util
	local as = ac.Targeting
	local at = ac.ESP
	local au = ac.Library
	local av = ac.owner.getLocalOwner
	local aw = ac.owner.getLiveCharacter
	local ax = ac.owner.getViewmodel
	local ay = ac.Tabs

	local az = ah("attach_camera", "Character")
	local aA = false
	local aB = ah("render_climbing", "FirstPersonInterface")
	if aB then
		local aC = af(aB)
		hookfunction(aB, ag(function(aD, aE, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if ad("fastladder", false) and type(aD) == "table" then
				aE = (tonumber(aE) or 0) * ae("fastladdermult", 3)
			end
			return aC(aD, aE, ...)
		end))
		aA = true
	end
	
	local aC = ah("render_running", "FirstPersonInterface")
	if aC then
		local aD = af(aC)
		hookfunction(aC, ag(function(aE)
			LPH_ATTRIBUTES(VM(NONE))
			if type(aE) ~= "table" then
				return
			end
			if ad("omnisprint", false) and aE and aE.values and aE.values.move_direction then
				local aF = aE.values.move_direction
				aE.values.move_direction = Vector3.new(aF.X, aF.Y, math.min(aF.Z, -0.5))
				local aG, aH, aI, aJ = pcall(aD, aE)
				aE.values.move_direction = aF
				if not aG then
					warn(aH)
					return
				end
				return aH, aI, aJ
			end
			return aD(aE)
		end))
	end
	do
	local aD = { hook = nil, retryAt = 0, flatLook = Vector3.new(0, 0, -1) }
	local aE = game:GetService("RunService")
	local aF = "vault_flight_hide"
	local aG, aH
	do
		local aI, aJ = pcall(require, ao.Items.Item.Utility.GrapplingHook)
		local aK, aL = pcall(require, ao.Items)
		aG = aI and aJ or nil
		aH = aK and aL or nil
		if aG and type(aG.load) == "function" then
			pcall(aG.load, aG)
		end
		local aM, aN = pcall(require, ao.Items.Item.Utility.GrapplingHook.Sounds)
		if aM and type(aN) == "table" then
			for aO, aP in aN do
				if type(aP) == "function" then
					local aQ = aP
					aN[aO] = function(...)
						if ad("flight", false) and aD.hook then
							if aO == "Zipping" or aO == "Ropping" then
								local aR = aQ(...)
								if typeof(aR) == "Instance" then
									aR.Volume = 0
									aR.Playing = false
								end
								return aR
							end
							return
						end
						return aQ(...)
					end
				end
			end
		end
	end

	function aD.isItem(aI)
		return type(aI) == "table" and (aI.tag == "GrapplingHook" or aI.name == "GrapplingHook")
	end

	function aD.find(aI)
		LPH_ATTRIBUTES(VM(NONE))
		local aJ = aI.values and aI.values.items
		if type(aJ) == "table" then
			for aK, aL in aJ do
				if aD.isItem(aL) then
					return aL
				end
			end
		end
		local aK = aI.values and aI.values.Items
		if typeof(aK) == "Instance" and aH then
			local aL = aK:FindFirstChild("GrapplingHook", true)
			if aL then
				local aM, aN = pcall(aH.get_item, aL)
				if aM and aD.isItem(aN) then
					return aN
				end
			end
		end
		return nil
	end

	function aD.ensure(aI)
		LPH_ATTRIBUTES(VM(NONE))
		local aJ = aD.find(aI)
		if aJ then
			return aJ
		end
		local aK = aI.values and aI.values.Items
		if not (aG and aH and aG.model and typeof(aK) == "Instance" and aK.Parent) then
			return nil
		end
		if aK:FindFirstChild("GrapplingHook") then
			return nil
		end
		aG.model.Archivable = true
		local aL = aG.model:Clone()
		if not aL then
			return nil
		end
		aL.Name = "GrapplingHook"
		local aM = pcall(function()
			aL.Parent = aK
		end)
		if not aM or not aL.Parent then
			pcall(function()
				aL:Destroy()
			end)
			return nil
		end
		local aN, aO = pcall(aH.get_item, aL)
		if not aN or not aD.isItem(aO) then
			aL:Destroy()
			return nil
		end
		if not aO.owner and type(aO.set_owner) == "function" then
			pcall(aO.set_owner, aO, aI)
		end
		if type(aI.values.items) == "table" then
			aI.values.items[aL] = aO
		end
		aO._vaultInjected = true
		return aO
	end

	function aD.gone(aI)
		local aJ = type(aI) == "table" and aI.instance
		if typeof(aJ) ~= "Instance" or not aJ.Parent then
			return true
		end
		return aJ:FindFirstChild("Root") == nil
	end

	function aD.hideVisuals()
		LPH_ATTRIBUTES(VM(NONE))
		local aI = aD.hook
		if not aI or not ad("flight", false) then
			return
		end
		local aJ = aI.hook_prop
		if typeof(aJ) == "Instance" then
			for aK, aL in aJ:GetDescendants() do
				if aL:IsA("Beam") or aL:IsA("Trail") or aL:IsA("RopeConstraint") then
					aL.Enabled = false
				elseif aL:IsA("Sound") then
					aL.Volume = 0
					aL.Playing = false
				end
			end
			if aJ.Parent then
				aJ.Parent = nil
			end
		end
		for aK, aL in { aI.zipping, aI.ropping } do
			if typeof(aL) == "Instance" then
				aL.Volume = 0
				aL.Playing = false
			end
		end
		local aK = aI.owner and aI.owner.instance
		local aL = typeof(aK) == "Instance" and aK:FindFirstChild("collision")
		if aL then
			for aM, aN in aL:GetChildren() do
				if aN:IsA("Sound") then
					aN.Volume = 0
					aN.Playing = false
				end
			end
		end
		local aM = typeof(aI.instance) == "Instance" and aI.instance:FindFirstChild("Root")
		if aM then
			for aN, aO in aM:GetChildren() do
				if aO:IsA("Sound") then
					aO.Volume = 0
					aO.Playing = false
				end
			end
		end
		if aI.action_button then
			aI.action_button.Visible = false
		end
		if aI.completion_bar and type(aI.completion_bar.cancel) == "function" then
			pcall(function()
				aI.completion_bar:cancel()
			end)
		end
	end
	function aD.bindHide()
		pcall(function()
			aE:UnbindFromRenderStep(aF)
		end)
		aE:BindToRenderStep(aF, Enum.RenderPriority.Last.Value + 4, function()
			aD.hideVisuals()
		end)
	end
	function aD.unbindHide()
		pcall(function()
			aE:UnbindFromRenderStep(aF)
		end)
	end
	function aD.stop()
		LPH_ATTRIBUTES(VM(NONE))
		local aI = aD.hook
		aD.hook = nil
		aD.unbindHide()
		if not aI then
			return
		end
		local aJ = aI._vaultJumpHum
		aI._vaultJumpHum = nil
		if aJ then
			pcall(function()
				if aJ.Parent then
					aJ:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
				end
			end)
		end
		if aD.gone(aI) then
			return
		end
		pcall(function()
			if aI.states and aI.states.rappeling and aI.states.rappeling.set then
				aI.states.rappeling:set(false)
			end
		end)
		pcall(function()
			if aI.owner and type(aI.stop_rappel_mode) == "function" then
				aI:stop_rappel_mode(aI.owner)
			elseif aI.move_position and aI.move_position.Parent then
				aI.move_position.Parent = nil
			end
		end)
		if aI._vaultInjected and typeof(aI.instance) == "Instance" and aI.instance.Parent then
			pcall(function()
				aI.instance:Destroy()
			end)
		end
	end

	function aD.start(aI, aJ, aK, aL)
		LPH_ATTRIBUTES(VM(NONE))
		if not aJ.move_position and type(aJ.init) == "function" then
			pcall(aJ.init, aJ)
		end
		if not aJ.move_position then
			return false
		end
		if not aJ.owner and type(aJ.set_owner) == "function" then
			pcall(aJ.set_owner, aJ, aI)
		end
		local aM = aK:FindFirstChild("RootAttachment") or aK:FindFirstChildWhichIsA("Attachment")
		if not aM then
			return false
		end
		local aN = workspace.CurrentCamera
		local aO = aN and aN.CFrame.LookVector or Vector3.new(0, 0, -1)
		local aP = Vector3.new(aO.X, 0, aO.Z)
		if aP.Magnitude < 0.05 then
			aP = aD.flatLook
		else
			aP = aP.Unit
			aD.flatLook = aP
		end
		aJ.move_position.Position = aK.Position
		aJ.move_position.Parent = aK
		aJ.move_position.Attachment0 = aM
		aJ.rappel_start = CFrame.new(aK.Position)
		aJ.rappel_end = CFrame.new(aK.Position + Vector3.new(0, 800, 0))
		aJ.rappel_time = 1
		aJ.dt_passed = 0
		local aQ = aK.Position + aP * 6 + Vector3.new(0, 40, 0)
		if aJ.states and aJ.states.hook and aJ.states.hook.set then
			pcall(function()
				aJ.states.hook:set(CFrame.lookAt(aQ, aQ + aP))
			end)
		end
		if aJ.states and aJ.states.rappeling and aJ.states.rappeling.set then
			pcall(function()
				aJ.states.rappeling:set(true)
			end)
		end
		if aI.states and aI.states.climbing and aI.states.climbing.set then
			pcall(function()
				aI.states.climbing:set(2)
			end)
		end
		if aL then
			pcall(function()
				aL:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
			end)
			aJ._vaultJumpHum = aL
		end
		aJ._vaultOwnerInst = aI.instance
		aD.hook = aJ
		aD.bindHide()
		aD.hideVisuals()
		return true
	end

	if aG and type(aG.input_render) == "function" and hookfunction then
		local aI = af(aG.input_render)
		hookfunction(aG.input_render, ag(function(aJ, ...)
			LPH_ATTRIBUTES(VM(NONE))
		if aJ == aD.hook then
			if not ad("flight", false) or aD.gone(aJ) then
				aD.hook = nil
				return
			end
			aJ.rappel_time = 1
			return
		end
		return aI(aJ, ...)
		end))
	end

	local aI = aG and (aG.rappel_hook or ah("rappel_hook", "GrapplingHook"))
	if type(aI) == "function" and hookfunction then
		local aJ = af(aI)
		hookfunction(aI, ag(function(aK, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if type(aK) == "table" and aD.gone(aK) then
				if aK == aD.hook then
					aD.hook = nil
				end
				return
			end
			return aJ(aK, ...)
		end))
	end

	function aD.step(aJ, aK, aL, aM, aN)
		LPH_ATTRIBUTES(VM(NONE))
		if not aJ then
			if aD.hook then
				aD.stop()
			end
			return
		end
		if not ad("flight", false) then
			if aD.hook then
				aD.stop()
			end
			return
		end
		if not aL or not aL.Parent or (aM and aM.Health <= 0) then
			if aD.hook then
				aD.stop()
			end
			return
		end
		local aO = aD.hook
		if not aO or aO._vaultOwnerInst ~= aK or (typeof(aO.instance) == "Instance" and not aO.instance.Parent) then
			if aD.hook then
				aD.stop()
			end
			if os.clock() >= aD.retryAt then
				aD.retryAt = os.clock() + 0.5
				aO = aD.ensure(aJ)
				if aO then
					aD.start(aJ, aO, aL, aM)
				end
			end
			aO = aD.hook
		end
		if not (aO and aO.move_position) or aD.gone(aO) then
			aD.hook = nil
			return
		end
		local aP = math.clamp(tonumber(aN) or 0.016, 0, 0.05)
		local aQ = math.clamp(tonumber(ae("flightspeed", 10)) or 10, 5, 20)
		local aR = workspace.CurrentCamera
		local aS = aR and aR.CFrame or CFrame.new()
		local aT = Vector3.new(aS.LookVector.X, 0, aS.LookVector.Z)
		if aT.Magnitude > 0.05 then
			aT = aT.Unit
			aD.flatLook = aT
		else
			aT = aD.flatLook
		end
		local aU = Vector3.new(aS.RightVector.X, 0, aS.RightVector.Z)
		if aU.Magnitude > 0.05 then
			aU = aU.Unit
		else
			aU = Vector3.new(aT.Z, 0, -aT.X)
		end
		local aV = Vector3.zero
		if ak:IsKeyDown(Enum.KeyCode.W) then
			aV += aT
		end
		if ak:IsKeyDown(Enum.KeyCode.S) then
			aV -= aT
		end
		if ak:IsKeyDown(Enum.KeyCode.D) then
			aV += aU
		end
		if ak:IsKeyDown(Enum.KeyCode.A) then
			aV -= aU
		end
		local aW = 0
		if ak:IsKeyDown(Enum.KeyCode.Space) then
			aW += aQ
		end
		if ak:IsKeyDown(Enum.KeyCode.LeftShift) or ak:IsKeyDown(Enum.KeyCode.RightShift) then
			aW -= aQ
		end
		local aX = Vector3.zero
		if aV.Magnitude > 0.001 then
			aX = aV.Unit * aQ
		end
		aX += Vector3.new(0, aW, 0)
		aO.rappel_time = 1
		aO.dt_passed = 0
		aO.descending = aW < 0
		aO.rappel_end = CFrame.new(aL.Position + Vector3.new(0, 800, 0))
		if aO.states and aO.states.hook and aO.states.hook.set and (not aO._vaultAirAt or os.clock() - aO._vaultAirAt > 0.35) then
			aO._vaultAirAt = os.clock()
			local aY = aL.Position + aD.flatLook * 6 + Vector3.new(0, 40, 0)
			pcall(function()
				aO.states.hook:set(CFrame.lookAt(aY, aY + aD.flatLook))
			end)
		end
		if aJ.states and aJ.states.vault and aJ.states.vault.get and aJ.states.vault:get() ~= 0 and aJ.states.vault.set then
			pcall(function()
				aJ.states.vault:set(0)
			end)
		end
		if aO.states and aO.states.rappeling and aO.states.rappeling.get and not aO.states.rappeling:get() and aO.states.rappeling.set then
			pcall(function()
				aO.states.rappeling:set(true)
			end)
		end
		if aJ.states and aJ.states.climbing and aJ.states.climbing.get and aJ.states.climbing:get() < 2 and aJ.states.climbing.set then
			pcall(function()
				aJ.states.climbing:set(2)
			end)
		end
		local aY = aO.move_position
		if aY.Parent ~= aL and aL.Parent then
			pcall(function()
				aY.Position = aL.Position
				aY.Parent = aL
				aY.Attachment0 = aL:FindFirstChild("RootAttachment") or aL:FindFirstChildWhichIsA("Attachment")
			end)
		end
		if aX.Magnitude < 0.01 then
			aY.Position = aL.Position
		else
			aY.Position = aY.Position + aX * aP
			if (aY.Position - aL.Position).Magnitude > 10 then
				aY.Position = aL.Position + aX * aP
			end
		end
		aD.hideVisuals()
	end

	au._flightEnd = aD.stop
	au._flightStep = aD.step
	ac.flight = aD
	end
	local function aD(aE)
			LPH_ATTRIBUTES(VM(NONE))
			local aF = av()
			if not aF then
				if ac.flight then
					ac.flight.stop()
				end
				return
			end
			local aG = aF.instance
			local aH = aG and aG:FindFirstChildOfClass("Humanoid")
			local aI = aG and (aG:FindFirstChild("HumanoidRootPart") or aG:FindFirstChild("Root"))

			if ac.flight then
				ac.flight.step(aF, aG, aI, aH, aE)
			end

			if ad("noslowdown", false) and aF.states and aF.states.speed_multiplier then
				pcall(function()
					aF.states.speed_multiplier:set(1)
				end)
			end

			if ad("autostrafe", false) and aF.values and aF.values.falling and aF.values.falling:get() and aH then
				local aJ = ac.Camera.CFrame.RightVector * (ak:IsKeyDown(Enum.KeyCode.D) and 1 or ak:IsKeyDown(Enum.KeyCode.A) and -1 or 1)
				aH:Move(Vector3.new(aJ.X, 0, aJ.Z), false)
			end
			if ad("fastladder", false) and not aA and aF.values and aF.values.climbing_ladder then
				local aJ = aF.values.climbing_ladder:get()
				local aK = aF.values.climb_moving and aF.values.climb_moving:get()
				if aJ and aK and aK ~= 0 and aF.values.climbing then
					local aL = (aJ.start.WorldCFrame.Position - aJ.finish.WorldCFrame.Position).Magnitude
					if aL > 0.1 then
						local aM = aF.values.climbing:get()
						aF.values.climbing:set(aM + aK * 0.016 * (5 / aL) * (ae("fastladdermult", 3) - 1))
					end
				end
			end
	end
	local aE = {
		down = -1.55,
		up = 1.55,
		zero = 0,
		Down = math.rad(-45),
		Up = math.rad(45),
		Zero = 0,
		["Perfect up"] = 1.55,
		["Perfect down"] = -1.55,
	}
	local function aF(aG, aH)
		local aI = CFrame.Angles(0, aG, 0).LookVector
		local aJ = math.cos(aH)
		local aK = math.sin(aH)
		local aL = aI * aJ + Vector3.new(0, aK, 0)
		if aL.Magnitude < 0.001 then
			return Vector3.yAxis * (aK >= 0 and 1 or -1)
		end
		return aL.Unit
	end
	local function aG(aH)
		return Options and Options[aH] ~= nil
	end
	local function aH()
		if aG("antiaimyawmode") then
			local aI = ae("antiaimyawmode", "none")
			return type(aI) == "string" and aI or "none"
		end
		if ad("antiaimjitter", false) then
			return "jitter"
		end
		if ad("antiaimyaw", false) then
			return "static"
		end
		return "none"
	end
	local function aI()
		if aG("antiaimpitchmode") then
			local aJ = ae("antiaimpitchmode", "none")
			return type(aJ) == "string" and aJ or "none"
		end
		if not ad("antiaimpitch", false) then
			return "none"
		end
		local aJ = ae("antiaimpitchvalue", "Perfect down")
		if aJ == "Up" or aJ == "Perfect up" then
			return "up"
		end
		if aJ == "Zero" then
			return "zero"
		end
		if aJ == "Down" then
			return "down"
		end
		return "down"
	end
	local aJ = {
		look = nil,
		yaw = 0,
		pitchOn = false,
		yawOn = false,
		pushed = 0,
		synced = 0,
		hooked = nil,
		rawSet = nil,
		rawGet = nil,
		lastPose = nil,
	}
	local function aK()
		return ad("antiaim", false) and not ad("flight", false)
	end
	local function aL()
		LPH_ATTRIBUTES(VM(NONE))
		if not aK() then
			aJ.look = nil
			aJ.pitchOn = false
			aJ.yawOn = false
			return
		end
		local aM = av()
		local aN = aM and aM.values and aM.values.camera and aM.values.camera.get and aM.values.camera:get()
		if typeof(aN) ~= "Instance" then
			aN = workspace.CurrentCamera
		end
		if not aN then
			return
		end
		local aO, aP = aN.CFrame:ToOrientation()
		local aQ = aI()
		local aR = aO
		local aS = aQ ~= "none"
		if aQ == "custom" then
			local aT = tonumber(ae("antiaimpitchcustom", -89)) or -89
			aR = math.clamp(math.rad(aT), -1.55, 1.55)
		elseif aQ == "jitter" then
			local aT = math.floor(os.clock() / 0.08) % 2 == 0 and 1 or -1
			aR = 1.55 * aT
		elseif aS then
			aR = aE[aQ]
			if aR == nil then
				aR = aE.down
			end
		end
		local aT = aH()
		if aT == "spin" then
			aT = "none"
		end
		local aU = aP
		local aV = aT ~= "none"
		local aW = math.rad(tonumber(ae("antiaimyawvalue", 180)) or 180)
		if aT == "backwards" then
			aU += math.pi
		elseif aT == "static" then
			aU += aW
		elseif aT == "jitter" then
			local aX = math.rad(tonumber(ae("antiaimjitterstrength", 45)) or 45)
			local aY = math.floor(os.clock() / 0.08) % 2 == 0 and 1 or -1
			aU += aW + aX * aY
		end
		if ad("antiaimspin", false) or aT == "spin" then
			local aX = tonumber(ae("antiaimspinspeed", 1.8)) or 1.8
			aU += os.clock() * aX * math.pi * 2
			aV = true
		end
		aJ.pitchOn = aS
		aJ.yawOn = aV
		aJ.yaw = aU
		aJ.look = aF(aU, aR)
	end
	local function aM(aN)
		LPH_ATTRIBUTES(VM(NONE))
		local aO = av()
		local aP = aO and aO.instance
		local aQ = aO and aO.values and aO.values.viewmodels
		if typeof(aP) ~= "Instance" or typeof(aQ) ~= "Instance" or not aJ.look then
			return aN
		end
		local aR = aP:FindFirstChild("HumanoidRootPart")
		local aS = aO.values.camera and aO.values.camera.get and aO.values.camera:get()
		if not aR or typeof(aS) ~= "Instance" then
			return aN
		end
		local aT, aU = aS.CFrame:ToOrientation()
		local aV = aJ.yaw - aU
		if math.abs(aV) < 0.001 and not aJ.pitchOn then
			return aN
		end
		local aW = aR.CFrame
		local aX = aW * CFrame.Angles(0, aV, 0) * aW:Inverse()
		local aY = {}
		if type(aN) == "table" then
			for aZ, a_ in aN do
				aY[aZ] = a_
			end
		end
		local aZ = false
		local function a_(a0, b, c)
			if typeof(b) ~= "Instance" or typeof(c) ~= "Instance" or not c.Part0 or not c.C0 then
				return
			end
			local d = b:GetPivot()
			local e = aX * d
			if a0 == "head" and aJ.pitchOn and aJ.look then
				local f = e.Position
				e = CFrame.lookAt(f, f + aJ.look)
			end
			aY[a0] = (c.Part0.CFrame * c.C0):ToObjectSpace(e)
			aZ = true
		end
		for a0, b in aQ:GetChildren() do
			if b:IsA("BasePart") then
				a_(b.Name, b, b:FindFirstChild("JointMotor"))
			end
		end
		for a0, b in aP:GetChildren() do
			if b:IsA("BasePart") and b.Name ~= "collision" then
				local c = aQ:FindFirstChild(b.Name)
				if c then
					a_(b.Name, c, b:FindFirstChild("JointMotor"))
				end
			end
		end
		if not aZ and type(aN) == "table" then
			local a0 = CFrame.Angles(0, aV, 0)
			for b, c in aN do
				if typeof(c) == "CFrame" and b ~= "collision" then
					aY[b] = c * a0
					aZ = true
				end
			end
		end
		if not aZ then
			return nil
		end
		return aY
	end
	local function aN(aO)
		return
	end
	local function aO(aP)
		LPH_ATTRIBUTES(VM(NONE))
		local aQ = aP and aP.states and aP.states.look
		if type(aQ) ~= "table" or type(aQ.set) ~= "function" or aQ == aJ.hooked then
			return
		end
		if aJ.hooked and aJ.rawSet then
			aJ.hooked.set = aJ.rawSet
			aJ.hooked.get = aJ.rawGet
		end
		aJ.hooked = aQ
		aJ.rawSet = aQ.set
		aJ.rawGet = aQ.get
		local aR = aJ.rawSet
		local aS = aJ.rawGet
		aQ.get = function(aT, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if aK() then
				local aU = workspace.CurrentCamera
				if aU then
					return aU.CFrame.LookVector
				end
			end
			return aS(aT, ...)
		end
		local aT = false
		aQ.set = function(aU, aV, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if aT or not aK() then
				return aR(aU, aV, ...)
			end
			aT = true
			aL()
			if not aJ.look then
				aT = false
				return aR(aU, aV, ...)
			end
			aR(aU, aJ.look, ...)
			if type(aU.set_no_replication) == "function" then
				local aW = aV
				if typeof(aW) ~= "Vector3" then
					local aX = workspace.CurrentCamera
					aW = aX and aX.CFrame.LookVector
				end
				if typeof(aW) == "Vector3" then
					aU:set_no_replication(aW)
				end
			end
			aT = false
		end
	end
	local aP = false
	local function aQ()
		LPH_ATTRIBUTES(VM(NONE))
		local aR = av()
		if not ad("autosprint", false) then
			if aP and aR and aR.values then
				aR.values.running_toggled = false
				aP = false
			end
			return
		end
		if not aR or not aR.values or not aR.states or not aR.states.running then
			return
		end
		local aS = aR.values.move_vector
		if aS and aS.Magnitude > 0.5 then
			aR.values.running_toggled = true
			aP = true
		elseif aP then
			aR.values.running_toggled = false
			aP = false
		end
	end
	local function aR()
		LPH_ATTRIBUTES(VM(NONE))
		aL()
		aJ.synced = os.clock()
		if aK() then
			aO(av())
		end
	end
	local aS
	local aT = false
	local aU = ac.Net
	if aU and type(aU.fast_send) == "function" and hookfunction then
		aS = af(aU.fast_send)
		hookfunction(aU.fast_send, ag(function(aV, aW, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if aV == "body_parts_cframes" and type(aW) == "table" and aK() then
				aL()
				local aX = ac.aaPose
				local aY = av()
				local aZ = aY and aY.values and aY.values.viewmodels
				local a_ = aY and aY.instance
				if not (aX and aX.parts and os.clock() - aX.at < 0.25 and typeof(aZ) == "Instance") then
					local a0 = aM(aW)
					if a0 then
						aW = a0
					end
				elseif typeof(aZ) == "Instance" then
					local a0 = {}
					for b, c in aW do
						a0[b] = c
					end
					local function b(c, d)
						local e = aX.parts[c]
						if not e or typeof(d) ~= "Instance" or not d.Part0 or not d.C0 then
							return
						end
						a0[c] = (d.Part0.CFrame * d.C0):ToObjectSpace(e)
					end
					for c, d in aZ:GetChildren() do
						if d:IsA("BasePart") then
							b(d.Name, d:FindFirstChild("JointMotor"))
						end
					end
					if typeof(a_) == "Instance" then
						for c, d in a_:GetChildren() do
							if d:IsA("BasePart") and d.Name ~= "collision" then
								b(d.Name, d:FindFirstChild("JointMotor"))
							end
						end
					end
					aW = a0
				end
			end
			return aS(aV, aW, ...)
		end))
	end
	local aV = 1.5
	local function aW(aX, aY)
		LPH_ATTRIBUTES(VM(NONE))
		if not ad("speedhack", false) or not aY or not aX then
			return
		end
		local aZ = tonumber(ae("speedvalue", 15)) or 15
		local a_ = aX.values and aX.values.move_vector and aX.values.move_vector.Magnitude > 0.2
		local a0 = (ad("autosprint", false) and a_) or (aX.states and aX.states.running and aX.states.running.get and aX.states.running:get())
		local b = 0.9 / aV
		if a0 then
			b = 1
		elseif aX.states and aX.states.walk_state and aX.states.walk_state.get then
			local c = aX.states.walk_state:get()
			if c == "crouch" then
				b = 0.5 / aV
			elseif c == "prone" then
				b = 0.3 / aV
			end
		end
		if aX.states and aX.states.walking and aX.states.walking.get and aX.states.walking:get() and not a0 then
			b = b * 0.5
		end
		aY.WalkSpeed = aZ * b
	end
	local function aX()
		LPH_ATTRIBUTES(VM(NONE))
		local aY = av()
		local aZ = aY and aY.instance and aY.instance:FindFirstChildOfClass("Humanoid")
		aW(aY, aZ)
		if os.clock() - aJ.synced > 0.001 then
			aL()
		end
		if not aK() or not aJ.look then
			return
		end
		local a_ = av()
		if not a_ then
			return
		end
		aO(a_)
		aN(a_)
		local a0 = tonumber(ae("antiaimrepspeed", 20)) or 20
		if a0 < 1 then
			a0 = 1
		elseif a0 > 100 then
			a0 = 100
		end
		local b = os.clock()
		if b - aJ.pushed < (1 / a0) then
			return
		end
		aJ.pushed = b
		local c = a_.states and a_.states.look
		if c and c.set then
			local d = workspace.CurrentCamera
			local e = d and d.CFrame.LookVector or aJ.look
			pcall(function()
				c:set(e)
			end)
		end
	end
	local function aY()
		if aJ.hooked and aJ.rawSet then
			aJ.hooked.set = aJ.rawSet
			aJ.hooked.get = aJ.rawGet
			aJ.hooked = nil
			aJ.rawSet = nil
			aJ.rawGet = nil
		end
	end
		local aZ = ay.Misc:AddLeftGroupbox("Movement")
		aZ:AddToggle("omnisprint", { Text = "Omnisprint", Default = false })
		aZ:AddToggle("instantlean", { Text = "Instant Lean", Default = false })
		aZ:AddToggle("instantcrouch", { Text = "Instant Crouch", Default = false })
		aZ:AddToggle("instantprone", { Text = "Instant Prone", Default = false })
		aZ:AddToggle("autosprint", { Text = "Auto Sprint", Default = false })
		aZ:AddToggle("speedhack", { Text = "Speed", Default = false })
		aZ:AddSlider("speedvalue", { Text = "Speed Value", Default = 15, Min = 8, Max = 25, Rounding = 0 })
		aZ:AddToggle("flight", {
			Text = "Flight",
			Default = false,
			Tooltip = "LeftShift to descend, Space to ascend",
		}):AddKeyPicker("flightkey", {
			Default = "None",
			SyncToggleState = true,
			Mode = "Toggle",
			Text = "Flight",
		})
		aZ:AddSlider("flightspeed", {
			Text = "Flight Speed",
			Default = 10,
			Min = 5,
			Max = 20,
			Rounding = 0,
			Suffix = " studs/s",
		})
		aZ:AddToggle("noslowdown", { Text = "No Slowdown", Default = false })
		aZ:AddToggle("autostrafe", { Text = "Auto Strafe", Default = false })
		aZ:AddToggle("fastladder", { Text = "Fast Ladder", Default = false })
		aZ:AddSlider("fastladdermult", { Text = "Ladder Speed", Default = 3, Min = 1, Max = 8, Rounding = 1, Suffix = "x" })
		local a_ = ay.Misc:AddRightGroupbox("Antiaim")
		a_:AddToggle("antiaim", { Text = "Enabled", Default = false }):AddKeyPicker("antiaimkey", {
			Default = "None",
			SyncToggleState = true,
			Mode = "Toggle",
			Text = "Antiaim",
		})
		a_:AddSlider("antiaimrepspeed", {
			Text = "Replication speed per second",
			Default = 20,
			Min = 1,
			Max = 100,
			Rounding = 0,
		})
		a_:AddDropdown("antiaimpitchmode", {
			Text = "Pitch",
			Values = { "none", "down", "up", "zero", "jitter", "custom" },
			Default = 1,
			Multi = false,
		})
		a_:AddSlider("antiaimpitchcustom", {
			Text = "Custom pitch",
			Default = -89,
			Min = -90,
			Max = 90,
			Rounding = 0,
		})
		a_:AddDropdown("antiaimyawmode", {
			Text = "Yaw",
			Values = { "none", "backwards", "static", "jitter" },
			Default = 1,
			Multi = false,
		})
		a_:AddSlider("antiaimyawvalue", {
			Text = "Yaw offset",
			Default = 180,
			Min = -180,
			Max = 180,
			Rounding = 0,
		})
		a_:AddSlider("antiaimjitterstrength", {
			Text = "Jitter strength",
			Default = 45,
			Min = 0,
			Max = 180,
			Rounding = 0,
		})
		a_:AddToggle("antiaimspin", { Text = "Yaw spin", Default = false })
		a_:AddSlider("antiaimspinspeed", {
			Text = "Spin speed",
			Default = 1.8,
			Min = 0,
			Max = 10,
			Rounding = 1,
		})

	local function a0()
		LPH_ATTRIBUTES(VM(NONE))
		if not aK() or not aJ.look then
			return nil
		end
		return aJ.look, aJ.yaw, aJ.pitchOn
	end
	ac.movement = {
		step = aD,
		spin = aX,
		sync = aR,
		applyAutoSprint = aQ,
		getAim = a0,
		unload = aY,
	}
	ab.step = aD

end

function ab.step(ac)
end

function ab.unload()
end

return ab
end function a.n()local ab=a.cache.n if not ab then ab={c=aa()}a.cache.n=ab end return ab.c end end do local function aa()
local ab = {}

function ab.build(ac)
	local ad = ac.tv
	local ae = ac.ov
	local af = ac.cloneOriginal
	local ag = ac.wrap
	local ah = ac.findGcFunction
	local ai = ac.Players
	local aj = ac.LocalPlayer
	local ak = ac.UserInputService
	local al = ac.Lighting
	local am = ac.CollectionService
	local an = ac.ReplicatedStorage
	local ao = ac.Modules
	local ap = ac.Gun
	local aq = ac.StateObject
	local ar = ac.Util
	local as = ac.Targeting
	local at = ac.ESP
	local au = ac.Library
	local av = ac.owner.getLocalOwner
	local aw = ac.owner.getLiveCharacter
	local ax = ac.owner.getViewmodel
	local ay = ac.Tabs

	local az = ac.okInput
	local aA = ac.Input
	local aB = ac.okNet
	local aC = ac.Net
	local aD = ac.okShield
	local aE = ac.ShieldMod
	local aF = az and aA and aA.current_device
	local aG = aF and aF.get
	local aH = nil
	local aI = 0
	local aJ = false

	local function aK()
		LPH_ATTRIBUTES(VM(NONE))
		local aL = ak.PreferredInput
		local aM = "pc"
		if aL == Enum.PreferredInput.Touch then
			aM = "mobile"
		elseif aL == Enum.PreferredInput.Gamepad then
			aM = "console"
		end
		if aj:GetAttribute("Spectator") then
			return aM
		end
		local aN = workspace:GetAttribute("Devices")
		if type(aN) ~= "string" or aN == "" then
			return aM
		end
		local aO = string.split(aN, ",")
		if #aO > 0 and not table.find(aO, "any") and aM ~= aO[1] then
			return aO[1]
		end
		return aM
	end

	local function aL()
		LPH_ATTRIBUTES(VM(NONE))
		if aJ or not ad("devicespoof", false) then
			return nil
		end
		local aM = ae("spoofdevice", "Console")
		if type(aM) ~= "string" then
			return "console"
		end
		local aN = string.lower(aM)
		if aN == "pc" or aN == "console" or aN == "mobile" then
			return aN
		end
		return "console"
	end

	local function aM(aN)
		LPH_ATTRIBUTES(VM(NONE))
		if not aB or not aC or type(aC.send) ~= "function" then
			return
		end
		pcall(function()
			aj:SetAttribute("Device", aN)
		end)
		pcall(aC.send, "set_device", aN)
	end

	local function aN()
		LPH_ATTRIBUTES(VM(NONE))
		if not aH then
			return
		end
		local aO = aK()
		if aF and (aF.value == "pc" or aF.value == "console" or aF.value == "mobile") then
			aO = aF.value
		end
		aH = nil
		aM(aO)
	end

	local function aO()
		LPH_ATTRIBUTES(VM(NONE))
		local aP = aL()
		if not aP then
			aN()
			return
		end
		if aH == aP and aj:GetAttribute("Device") == aP then
			return
		end
		local aQ = os.clock()
		if aH == aP and aQ - aI < 2 then
			return
		end
		aI = aQ
		aH = aP
		aM(aP)
	end

	local function aP()
		LPH_ATTRIBUTES(VM(NONE))
		aJ = true
		aN()
		if aF and aG then
			aF.get = aG
		end
	end

	if aF and type(aG) == "function" then
		aF.get = function(aQ, ...)
			LPH_ATTRIBUTES(VM(NONE))
			local aR = aL()
			if not aR or aQ ~= aF then
				return aG(aQ, ...)
			end
			local aS = ""
			if type(debug) == "table" and type(debug.info) == "function" then
				aS = debug.info(2, "s") or ""
			end
			if string.find(aS, "Items.Item.Gun", 1, true) then
				return aR
			end
			return aG(aQ, ...)
		end
	end

	if aB and aC and type(aC.send) == "function" and hookfunction then
		local aQ = af(aC.send)
		hookfunction(aC.send, ag(function(aR, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if aR == "set_device" then
				local aS = aL()
				if aS then
					return aQ("set_device", aS)
				end
			end
			return aQ(aR, ...)
		end))
	end
	if aD and aE and type(aE.equip) == "function" then
		local aQ = af(aE.equip)
		hookfunction(aE.equip, ag(function(aR, aS, aT, ...)
			LPH_ATTRIBUTES(VM(NONE))
			local aU, aV, aW, aX = pcall(aQ, aR, aS, aT, ...)
			if ad("shieldgun", false) and aT and aS and aS.values then
				local aY = aS.values.equipped
				if aY and aY.safety and aY.safety.set then
					pcall(function()
						aY.safety:set(false)
					end)
				end
			end
			if not aU then
				warn(aV)
				return
			end
			return aV, aW, aX
		end))
	end
	local aQ = {}
	local aR = {}
	local aS = {}
	local aT = false
	local aU

	local function aV()
		local aW = ae("spoofedname", "vault.cc")
		if type(aW) ~= "string" or aW == "" then
			return "vault.cc"
		end
		return aW
	end

	local function aW(aX, aY, aZ)
		LPH_ATTRIBUTES(VM(NONE))
		if aY == "" or aY == aZ or string.find(aZ, aY, 1, true) then
			return aX
		end
		local a_ = table.create(4)
		local a0 = 1
		while true do
			local b, c = string.find(aX, aY, a0, true)
			if not b then
				a_[#a_ + 1] = string.sub(aX, a0)
				break
			end
			a_[#a_ + 1] = string.sub(aX, a0, b - 1)
			a_[#a_ + 1] = aZ
			a0 = c + 1
		end
		return table.concat(a_)
	end

	local function aX(aY, aZ, a_, a0)
		LPH_ATTRIBUTES(VM(NONE))
		if type(aY) ~= "string" or aY == "" then
			return aY
		end
		local b = aW(aY, aZ, a0)
		if a_ ~= aZ then
			b = aW(b, a_, a0)
		end
		return b
	end

	local function aY(aZ)
		if aZ.Name ~= "Title" then
			return false
		end
		local a_ = aZ.Parent
		local a0 = a_ and a_:GetAttribute("UserId")
		return a0 ~= nil and tonumber(a0) == aj.UserId
	end

	local function aZ(a_, a0, b)
		if not (a_:IsA("TextLabel") or a_:IsA("TextButton") or a_:IsA("TextBox")) then
			return false
		end
		if aY(a_) then
			return true
		end
		local c = a_.Text
		if type(c) ~= "string" or c == "" then
			return false
		end
		if a0 ~= "" and string.find(c, a0, 1, true) then
			return true
		end
		if b ~= "" and b ~= a0 and string.find(c, b, 1, true) then
			return true
		end
		return false
	end

	local function a_(a0, b, c, d)
		LPH_ATTRIBUTES(VM(NONE))
		if not a0.Parent then
			return
		end
		local e = a0.Text
		local f = aX(e, b, c, d)
		if aY(a0) or (a0.Name == "Username" and (e == b or e == c)) then
			f = d
		end
		if f ~= e then
			a0.Text = f
		end
	end

	local function a0(b)
		if aQ[b] then
			return
		end
		aQ[b] = b.Text
		local c = false
		local function d()
			LPH_ATTRIBUTES(VM(NONE))
			if c or not ad("namespoof", false) then
				return
			end
			c = true
			a_(b, aj.Name, aj.DisplayName, aV())
			c = false
		end
		d()
		aR[#aR + 1] = b:GetPropertyChangedSignal("Text"):Connect(d)
		aR[#aR + 1] = b.Destroying:Connect(function()
			aQ[b] = nil
		end)
	end

	local function b(c, d)
		aR[#aR + 1] = c:Connect(d)
	end

	local function c(d)
		if d and aZ(d, aj.Name, aj.DisplayName) then
			a0(d)
		end
	end

	local function d(e, f, g)
		if not e or aS[e] then
			return
		end
		aS[e] = true
		for h, i in e:GetChildren() do
			if f(i) then
				g(i)
			end
		end
		b(e.ChildAdded, function(h)
			if ad("namespoof", false) and f(h) then
				g(h)
			end
		end)
	end

	local function e(f)
		local function g()
			if tonumber(f:GetAttribute("UserId")) ~= aj.UserId then
				return
			end
			c(f:FindFirstChild("Title"))
		end
		g()
		b(f:GetAttributeChangedSignal("UserId"), g)
		b(f.ChildAdded, function(h)
			if h.Name == "Title" then
				g()
			end
		end)
	end

	local function f(g)
		local function h(i)
			if i.Name ~= "RedTeam" and i.Name ~= "BlueTeam" then
				return
			end
			d(i, function(j)
				return j.Name == "PlayerBoardInfo"
			end, e)
		end
		for i, j in g:GetChildren() do
			h(j)
		end
		if not aS[g] then
			aS[g] = true
			b(g.ChildAdded, h)
		end
	end

	local function g(h, i)
		for j, k in i do
			local l = h:FindFirstChild(k)
			if not l then
				continue
			end
			c(l)
			b(l:GetPropertyChangedSignal("Text"), function()
				if ad("namespoof", false) then
					c(l)
				end
			end)
		end
	end

	local function h(i)
		d(i, function(j)
			return j.Name == "Kill"
		end, function(j)
			g(j, { "KillerName", "VictimName" })
		end)
	end

	local function i(j)
		local k = j:FindFirstChild("head")
		if not k then
			return
		end
		local l = k:FindFirstChild("Username")
		local m = l and l:FindFirstChild("Username")
		c(m)
	end

	local function j(k)
		d(k, function(l)
			return l.Name == "Viewmodel" or l.Name == "LocalViewmodel"
		end, i)
	end

	local function k(l)
		d(l, function(m)
			return m:FindFirstChild("Username") ~= nil
		end, function(m)
			g(m, { "Username" })
		end)
	end

	local function l()
		LPH_ATTRIBUTES(VM(NONE))
		local m = aj:FindFirstChild("PlayerGui")
		if not m then
			return
		end
		local n = m:FindFirstChild("Game")
		if n then
			local o = n:FindFirstChild("Center")
			o = o and o:FindFirstChild("Center")
			local p = o and o:FindFirstChild("Scoreboard")
			if p then
				f(p)
			end
			local q = n:FindFirstChild("Right")
			q = q and q:FindFirstChild("Top")
			local r = q and q:FindFirstChild("KillFeed")
			if r then
				h(r)
			end
		end
		local o = m:FindFirstChild("LoadoutMenu")
		o = o and o:FindFirstChild("Center")
		o = o and o:FindFirstChild("Center")
		o = o and o:FindFirstChild("CustomMatch")
		o = o and o:FindFirstChild("Players")
		if o then
			for p, q in o:GetChildren() do
				local r = q:FindFirstChildWhichIsA("Frame") or q
				k(r)
			end
		end
		local p = m:FindFirstChild("LoadoutOverlay")
		p = p and p:FindFirstChild("Left")
		p = p and p:FindFirstChild("Center")
		p = p and p:FindFirstChild("LeftOverlayMenu")
		p = p and p:FindFirstChild("ScrollingFrame")
		p = p and p:FindFirstChild("InvitePeopleFrame")
		if p then
			k(p)
		end
		local q = workspace:FindFirstChild("Viewmodels")
		if q then
			j(q)
		end
	end

	local function m(n)
		local o = aj.Name
		local p = aj.DisplayName
		for q in aQ do
			if typeof(q) == "Instance" and q.Parent then
				a_(q, o, p, n)
			end
		end
	end

	local function n()
		LPH_ATTRIBUTES(VM(NONE))
		for o, p in aR do
			p:Disconnect()
		end
		table.clear(aR)
		table.clear(aS)
		aU = nil
		for o, p in aQ do
			if typeof(o) == "Instance" and o.Parent and type(p) == "string" then
				pcall(function()
					o.Text = p
				end)
			end
		end
		table.clear(aQ)
		local o = av()
		local p = o and o.instance
		local q = p and p:FindFirstChildOfClass("Humanoid")
		if q then
			pcall(function()
				q.DisplayName = aj.DisplayName
			end)
		end
	end

	local function o()
		LPH_ATTRIBUTES(VM(NONE))
		if not ad("namespoof", false) then
			if aT then
				aT = false
				n()
			end
			return
		end
		aT = true
		local p = aV()
		local q = av()
		local r = q and q.instance
		local s = r and r:FindFirstChildOfClass("Humanoid")
		if s and s.DisplayName ~= p then
			pcall(function()
				s.DisplayName = p
			end)
		end
		l()
		if p ~= aU then
			aU = p
			m(p)
		end
	end

	local function p()
		o()
		local q = av()
		if not q then
			return
		end
		local r = q.instance
		local s = r and r:FindFirstChildOfClass("Humanoid")
			if ad("shieldgun", false) and q.values and q.states then
				local t = q.states.climbing and q.states.climbing:get() or 0
				if t == 0 then
					local function u(w)
						if type(w) ~= "table" then
							return false
						end
						local x = tostring(w.tag or "")
						local y = string.lower(tostring(w.display_name or w.name or ""))
						return x == "Shield" or x == "BallisticShield" or x == "RiotShield" or string.find(y, "shield", 1, true) ~= nil
					end
					local w = q.values.holding
					if not u(w) and q.values.items then
						for x, y in q.values.items do
							if u(y) then
								w = y
								break
							end
						end
					end
					if u(w) then
						w.can_reload = true
						local x = q.values.equipped
						local y = x and not u(x)
						if y and typeof(w.instance) == "Instance" then
							if w._vaultItemType == nil then
								w._vaultItemType = w.instance:GetAttribute("item_type")
							end
							w.instance:SetAttribute("item_type", 0)
							if q.states.holding:get() ~= w.instance then
								pcall(function()
									q.states.holding:set(w.instance)
								end)
							end
							if x.safety and x.safety.set then
								pcall(function()
									x.safety:set(false)
								end)
							end
						elseif not y and typeof(w.instance) == "Instance" and w._vaultItemType ~= nil then
							w.instance:SetAttribute("item_type", w._vaultItemType)
						end
					end
				end
			end
	end
		local q = ay.Misc:AddLeftGroupbox("Local")
		q:AddToggle("shieldgun", {
			Text = "Shield + Gun",
			Default = false,
		})
		q:AddToggle("namespoof", { Text = "Name Spoof", Default = false })
		q:AddInput("spoofedname", { Text = "Name", Default = "vault.cc", Placeholder = "Name", Finished = false })
		q:AddToggle("devicespoof", { Text = "Device Spoof", Default = false })
		q:AddDropdown("spoofdevice", {
			Text = "Device",
			Values = { "PC", "Console", "Mobile" },
			Default = 2,
			Multi = false,
		})

	local function r()
		n()
		aP()
	end
	ac.network = {
		apply = aO,
		restore = r,
		step = p,
	}
	ab.step = p
	ab.unload = r

end

function ab.step(ac)
end

function ab.unload()
end

return ab
end function a.o()local ab=a.cache.o if not ab then ab={c=aa()}a.cache.o=ab end return ab.c end end do local function aa()
local ab = {}

function ab.build(ac)
	local ad = ac.tv
	local ae = ac.ov
	local af = ac.cloneOriginal
	local ag = ac.wrap
	local ah = ac.findGcFunction
	local ai = ac.Players
	local aj = ac.LocalPlayer
	local ak = ac.UserInputService
	local al = ac.Lighting
	local am = ac.CollectionService
	local an = ac.ReplicatedStorage
	local ao = ac.Modules
	local ap = ac.Gun
	local aq = ac.StateObject
	local ar = ac.Util
	local as = ac.Targeting
	local at = ac.ESP
	local au = ac.Library
	local av = ac.owner.getLocalOwner
	local aw = ac.owner.getLiveCharacter
	local ax = ac.owner.getViewmodel
	local ay = ac.Tabs

	local az = ac.okPlaceable
	local aA = ac.Placeable
	local aB = ac.okDefuser
	local aC = ac.DefuserMod
	local aD = ac.okDisabler
	local aE = ac.DefuserDisabler
	local aF = ac.okCamHack
	local aG = ac.CameraHack
	local aH = ac.okCharAnim
	local aI = ac.CharAnim
	local aJ = false
	if type(ar.tween) == "function" then
		local aK = af(ar.tween)
		hookfunction(ar.tween, ag(function(aL, aM, aN)
			LPH_ATTRIBUTES(VM(NONE))
			if aJ and typeof(aM) == "TweenInfo" then
				aM = TweenInfo.new(0, aM.EasingStyle, aM.EasingDirection)
			end
			return aK(aL, aM, aN)
		end))
	end
	if type(ar.base_tween) == "function" then
		local aK = af(ar.base_tween)
		hookfunction(ar.base_tween, ag(function(aL, aM, aN)
			LPH_ATTRIBUTES(VM(NONE))
			if aJ and typeof(aM) == "TweenInfo" then
				aM = TweenInfo.new(0, aM.EasingStyle, aM.EasingDirection)
			end
			return aK(aL, aM, aN)
		end))
	end

	local function aK(aL, aM)
		if type(aL) ~= "function" then
			return
		end
		local aN = af(aL)
		hookfunction(aL, ag(function(...)
			LPH_ATTRIBUTES(VM(NONE))
			local aO = ad(aM, false)
			if aO then
				aJ = true
			end
			local aP, aQ, aR, aS = pcall(aN, ...)
			if aO then
				aJ = false
			end
			if not aP then
				warn(aQ)
				return
			end
			return aQ, aR, aS
		end))
	end

	if aH and type(aI) == "table" then
		if type(aI.Lean) == "table" then
			for aL, aM in aI.Lean do
				aK(aM, "instantlean")
			end
		end
		if type(aI.Movement) == "table" then
			local aL = {
				crouch = true,
				crouch_torso = true,
				crouch_slow = true,
				crouch_torso_slow = true,
				base = true,
			}
			local aM = {
				prone = true,
				prone_torso_down = true,
				prone_torso_up = true,
				rise = true,
				rise2 = true,
				down = true,
				drop = true,
				base_slow = true,
			}
			for aN, aO in aI.Movement do
				if aL[aN] then
					aK(aO, "instantcrouch")
				elseif aM[aN] then
					aK(aO, "instantprone")
				end
			end
		end
	end

	local function aL()
		local aM = av()
		if not aM or not aM.values then
			return
		end
		if ad("instantinteract", false) then
			if not aM._vaultInteractAt or os.clock() - aM._vaultInteractAt > 0.25 then
				aM._vaultInteractAt = os.clock()
				local aN = aj.PlayerGui:FindFirstChild("HoldingBar", true)
				if aN and aN:IsA("GuiObject") then
					aN.Visible = false
				end
			end
		end
	end

	ac.utility = {
		step = aL,
	}
	ab.step = aL

end

function ab.step(ac)
end

function ab.unload()
end

return ab
end function a.p()local ab=a.cache.p if not ab then ab={c=aa()}a.cache.p=ab end return ab.c end end end
if not LPH_OBFUSCATED then
	LPH_ATTRIBUTES = function(...) end
	OPTIMIZE = function(...) return ... end
	ERROR_HANDLING = function(...) return ... end
	ENCRYPT = function(...) return ... end
	PRESET = function(...) return ... end
	VM = function(...) return ... end
	FAST = "FAST"
	NONE = "NONE"
	NO_UPVALUES = "NO_UPVALUES"
	LPH_ENCSTR = function(aa) return aa end
	LPH_ENCNUM = function(aa) return aa end
	LPH_ENCBUF = function(aa) return aa end
	LPH_CRASH = function() end
	LPH_STACKALLOC = function(aa) return table.create(aa) end
	LPH_PRECHECK = function(...) end
	LPH_REWRITE = function(aa) return aa end
	LPH_LINE = 0
end

local aa = a.a()
aa.init()

local ab = a.b()
local ac, ad = ab.checkKey(getgenv().script_key)

if not ac then
    setclipboard("https://discord.gg/Z7tvDkBUxX")
    game.Players.LocalPlayer:Kick("Please get a valid key from https://discord.gg/Z7tvDkBUxX, we have attempted to copy it to your clipboard")
    return
end

local ae = game:GetService("Players")
local af = game:GetService("RunService")
local ag = game:GetService("ReplicatedStorage")
local ah = game:GetService("UserInputService")
local ai = game:GetService("Lighting")
local aj = game:GetService("CollectionService")
local ak = game:GetService("Debris")
local al = workspace.CurrentCamera
local am = ae.LocalPlayer

local an = ag.Modules
local ao = require(an.Items.Item.Gun)
local ap = require(an.StateObject)
local aq = require(an.Util)
local ar, as = pcall(require, an.Items.Item.Utility.Placeable)
local at, au = pcall(require, an.Items.Item.Utility.Placeable.Defuser)
local av, aw = pcall(require, an.Items.Item.Utility.DefuserDisabler)
local ax, ay = pcall(require, an.Items.Item.Utility.DefaultCameraHack)
local az, aA = pcall(require, an.Character.Animations)
local aB, aC = pcall(require, an.Items.Item.Utility.Shield)
pcall(function()
	require(an.FirstPersonInterface)
end)

local aD, aE = pcall(require, an.Input)
local aF, aG = pcall(require, an.Net)

local aH = loadstring(game:HttpGet("https://raw.githubusercontent.com/ttokennxyz/vaultcc/refs/heads/main/targeting.lua"))()
local aI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ttokennxyz/vaultcc/refs/heads/main/esplib_op1.lua"))()

local aJ, aK, aL = loadstring(game:HttpGet("https://raw.githubusercontent.com/ttokennxyz/vaultcc/refs/heads/main/uilib.lua"))()

local aM = a.c()
local aN = a.d()
local aO = a.e()
local aP = a.f()
local aQ = aP.begin
local aR = aP.stop
local aS = a.h()
local aT = a.j()
local aU = a.k()
local aV = a.l()
local aW = a.m()
local aX = a.n()
local aY = a.o()
local aZ = a.p()

local a_ = {
	Players = ae,
	RunService = af,
	UserInputService = ah,
	Lighting = ai,
	CollectionService = aj,
	ReplicatedStorage = ag,
	LocalPlayer = am,
	Modules = an,
	Camera = workspace.CurrentCamera,
	Gun = ao,
	StateObject = ap,
	Util = aq,
	Targeting = aH,
	ESP = aI,
	Library = aJ,
	ThemeManager = aK,
	SaveManager = aL,
	okPlaceable = ar,
	Placeable = as,
	okDefuser = at,
	DefuserMod = au,
	okDisabler = av,
	DefuserDisabler = aw,
	okCamHack = ax,
	CameraHack = ay,
	okCharAnim = az,
	CharAnim = aA,
	okShield = aB,
	ShieldMod = aC,
	okInput = aD,
	Input = aE,
	okNet = aF,
	Net = aG,
	tv = aM.tv,
	ov = aM.ov,
	cloneOriginal = aN.cloneOriginal,
	wrap = aN.wrap,
	findGcFunction = aN.findGcFunction,
}

a_.owner = aO.create(a_)
aS.build(a_)
aT.build(a_)
aU.build(a_)
aV.build(a_)
aW.build(a_)
aX.build(a_)
aY.build(a_)
aZ.build(a_)
aS.finish(a_)

a_.aim.refreshTargetParts()
a_.visuals.applyESP()
a_.visuals.updateFOV()

local a0 = false
local function b()
	if a0 then
		return
	end
	a0 = true
	if a_.flight then
		a_.flight.stop()
	end
	if a_.renderConnection then
		a_.renderConnection:Disconnect()
		a_.renderConnection = nil
	end
	if a_.network and a_.network.restore then
		a_.network.restore()
	end
	pcall(function()
		af:UnbindFromRenderStep("vault_cam_pre")
		af:UnbindFromRenderStep("vault_cam")
	end)
	if a_.movement and a_.movement.unload then
		a_.movement.unload()
	end
	if a_.combat and a_.combat.unload then
		a_.combat.unload()
	end
	if a_.visuals and a_.visuals.unload then
		a_.visuals.unload()
	end
	if a_.world and a_.world.unload then
		a_.world.unload()
	end
	if aI and aI.Unload then
		aI:Unload()
	end
end

a_.renderConnection = af.RenderStepped:Connect(function(c)
	LPH_ATTRIBUTES(VM(NONE))
	aQ("op1.render")
	a_.Camera = workspace.CurrentCamera
	aQ("network.apply")
	a_.network.apply()
	aR()
	aQ("aim.getTarget")
	a_.aim.getTarget()
	aR()
	aQ("visuals.updateFOV")
	a_.visuals.updateFOV()
	aR()
	aQ("visuals.updateSnap")
	a_.visuals.updateSnap()
	aR()
	aQ("combat.updateTracers")
	a_.combat.updateTracers()
	aR()
	aQ("combat.gunModStep")
	a_.combat.gunModStep()
	aR()
	aQ("visuals.step")
	a_.visuals.step()
	aR()
	aQ("world.applyLighting")
	a_.world.applyLighting()
	aR()
	aQ("movement.step")
	a_.movement.step(c)
	aR()
	aQ("network.step")
	a_.network.step()
	aR()
	aQ("utility.step")
	a_.utility.step()
	aR()
	aQ("world.espStep")
	a_.world.espStep()
	aR()
	aQ("combat.aimbotStep")
	a_.combat.aimbotStep()
	aR()
	aQ("combat.reloadStep")
	a_.combat.reloadStep()
	aR()
	aQ("combat.rageStep")
	a_.combat.rageStep()
	aR()
	aR()
end)

af:BindToRenderStep("vault_cam_pre", Enum.RenderPriority.Last.Value, function()
	LPH_ATTRIBUTES(VM(NONE))
	aQ("op1.camPre")
	a_.Camera = workspace.CurrentCamera
	aQ("visuals.prepareThirdPerson")
	a_.visuals.prepareThirdPerson()
	aR()
	aQ("movement.applyAutoSprint")
	a_.movement.applyAutoSprint()
	aR()
	aQ("movement.sync")
	a_.movement.sync()
	aR()
	aR()
end)

af:BindToRenderStep("vault_cam", Enum.RenderPriority.Last.Value + 3, function()
	LPH_ATTRIBUTES(VM(NONE))
	aQ("op1.cam")
	a_.Camera = workspace.CurrentCamera
	aQ("movement.applyAutoSprint")
	a_.movement.applyAutoSprint()
	aR()
	aQ("visuals.applyThirdPerson")
	a_.visuals.applyThirdPerson()
	aR()
	aQ("movement.spin")
	a_.movement.spin()
	aR()
	aQ("visuals.poseThirdPerson")
	a_.visuals.poseThirdPerson()
	aR()
	aQ("visuals.applyChams")
	a_.visuals.applyChams()
	aR()
	aR()
end)

aJ:OnUnload(b)
if aJ and aJ.KeybindFrame then
	aJ.KeybindFrame.Visible = aM.tv("ShowKeybindList", true)
end
