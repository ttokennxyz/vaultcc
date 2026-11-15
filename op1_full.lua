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
end function a.b()local c=a.cache.b if not c then c={c=b()}a.cache.b=c end return c.c end end do local function b()
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
		local l = d.Targeting
		if l and l.get_viewmodel then
			local m = l:get_viewmodel(j)
			if m then
				return m
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
end function a.c()local c=a.cache.c if not c then c={c=b()}a.cache.c=c end return c.c end end do local function b()



local c = {}


local d = {
	root = "torso",
	humanoidrootpart = "torso",
	torso = "torso",
	uppertorso = "torso",
	head = "head",
	["left arm"] = "arm2",
	leftarm = "arm2",
	leftupperarm = "arm2",
	["right arm"] = "arm1",
	rightarm = "arm1",
	rightupperarm = "arm1",
	["left leg"] = "leg2",
	leftleg = "leg2",
	leftupperleg = "leg2",
	["right leg"] = "leg1",
	rightleg = "leg1",
	rightupperleg = "leg1",
}
local e = {}

function c.create(f)
	local g = f.owner.getLiveCharacter
	local h = f.LocalPlayer
	local i = game.FindFirstChild
	local j = game.FindFirstChildOfClass
	local k = game.GetAttribute
	local l = string.lower

	local m = {}

	function m:get_character(n)
		local o = typeof(n) == "Instance" and g(n)
		if o then
			return o, o.instance
		end
		return nil
	end

	function m:get_viewmodel(n)
		local o = typeof(n) == "Instance" and g(n)
		local p = o and o.values
		return p and p.viewmodels or nil
	end

	function m:get_weapon(n)
		local o = typeof(n) == "Instance" and g(n)
		local p = o and o.values
		return p and p.weapon or nil
	end

	function m:get_weapon_name(n)
		local o = self:get_weapon(n)
		return o and o.name or "None"
	end

	function m:is_friendly(n)
		if typeof(n) ~= "Instance" then
			return false
		end
		local o = k(n, "Team")
		return o ~= nil and o == k(h, "Team")
	end

	function m:get_health(n)
		local o = typeof(n) == "Instance" and g(n)
		local p = o and o.instance
		local q = p and j(p, "Humanoid")
		if q then
			return q.Health, q.MaxHealth
		end
		return 100, 100
	end

	function m:getPart(n, o)
		if typeof(n) ~= "Instance" or type(o) ~= "string" then
			return nil
		end
		local p = e[o]
		if not p then
			local q = l(o)
			p = d[q] or q
			e[o] = p
		end
		return i(n, p) or i(n, o)
	end

	function m:getName(n)
		return n and tostring(n.Name) or nil
	end

	return m
end

return c
end function a.d()local c=a.cache.d if not c then c={c=b()}a.cache.d=c end return c.c end end do local function b()








if not LPH_OBFUSCATED then
    LPH_JIT = LPH_JIT or function(...)
        return ...
    end
    LPH_JIT_MAX = LPH_JIT_MAX or function(...)
        return ...
    end
    LPH_ATTRIBUTES = LPH_ATTRIBUTES or function(...) end
    VM = VM or function(...) return ... end
    NONE = NONE or "NONE"
    LPH_NO_UPVALUES = LPH_NO_UPVALUES or function(c)
        return function(...)
            return c(...)
        end
    end
    LPH_ENCSTR = LPH_ENCSTR or function(...)
        return ...
    end
    LPH_ENCNUM = LPH_ENCNUM or function(...)
        return ...
    end
    LPH_ENCFUNC = LPH_ENCFUNC or function(c, d, e)
        if d ~= e then
            return print("LPH_ENCFUNC mismatch")
        end
        return c
    end
    LPH_CRASH = LPH_CRASH or function()
        return print(debug.traceback())
    end
end

return function(c)
	local d = game:GetService("UserInputService")
	local e = game:GetService("RunService")
	local f = game:GetService("Players")
	local g = game:GetService("CoreGui")
	local h = game:GetService("Workspace")
	local i = game:GetService("HttpService")
	local j = f.LocalPlayer
	local k = h.CurrentCamera
	local l = k.WorldToViewportPoint
	local m = gethui and gethui() or g
	local n = f
	local o = {}
	local p
	local q
	local r
	local s
	local t
	local u = i:GenerateGUID(false)

	local v = c
	if not v then
	    warn("[ESP] Targeting library missing. ESP will not function.")
	end

	if getgenv().SensoryESP_Unload then
	    pcall(getgenv().SensoryESP_Unload)
	end

	local w = m:FindFirstChild("SensoryESP_Chams")
	if w then
	    pcall(function() w:Destroy() end)
	end

	local x = h:FindFirstChild("SensoryESP_MeshChams")
	if x then
	    pcall(function() x:Destroy() end)
	end

	local function y(z)
	    if not z then
	        return false
	    end

	    if z:GetAttribute("SensoryESP_MeshCham") == true then
	        return true
	    end

	    if z:IsA("Model") and z.Name == "ChamShells" then
	        return true
	    end

	    if z:IsA("BasePart") and z.Name:match("^ChamShell_") then
	        return true
	    end

	    if z:IsA("Highlight") and z.Name == "ChamShellHighlight" then
	        return true
	    end

	    return false
	end

	local function z(A)
	    if not A then
	        return
	    end

	    for B, C in ipairs(A:GetDescendants()) do
	        if y(C) then
	            pcall(function() C:Destroy() end)
	        end
	    end
	end

	local function A(B)
	    if not B then
	        return
	    end

	    for C, D in ipairs(B:GetChildren()) do
	        if y(D) then
	            pcall(function() D:Destroy() end)
	        end
	    end
	end

	z(h)

	for B, C in ipairs(n:GetPlayers()) do
	    A(v:get_viewmodel(C))
	end

	local function B()
	    if not p or not p.Parent then
	        p = Instance.new("Folder")
	        p.Name = "SensoryESP_Chams"
	        p.Parent = m
	    end

	    if not q or not q.Parent then
	        q = Instance.new("Folder")
	        q.Name = "SensoryESP_MeshChams"
	        q.Parent = h
	    end

	    if not r or not r.Parent then
	        r = Instance.new("ScreenGui")
	        r.Name = "SensoryESP"
	        r.ResetOnSpawn = false
	        r.IgnoreGuiInset = true
	        r.ZIndexBehavior = Enum.ZIndexBehavior.Global
	        getgenv().SensoryESP_UI = r

	        pcall(function()
	            r.Parent = m
	        end)
	    end
	end

	local C = setmetatable({}, { __mode = "k" })
	local D = function(D, E, F, G, H)
	    LPH_ATTRIBUTES(VM(NONE))
	    local I = F - E
	    local J = I.Magnitude
	    local K = math.deg(math.atan2(I.Y, I.X))

	    D.Size = UDim2.new(0, math.floor(J + 0.5), 0, G)
	    D.Position = UDim2.new(0, math.floor(E.X + I.X / 2 - J / 2 + 0.5), 0,
	        math.floor(E.Y + I.Y / 2 - G / 2 + 0.5))
	    D.Rotation = K
	    D.BackgroundColor3 = H
	    D.Visible = true
	end

	local E = {
	    
	    Enabled = true,
	    Keybind = {
	        Enabled = false,
	        Key = Enum.KeyCode.Insert,
	    },
	    Players = true,
	    LocalPlayer = false,
	    LimitFPS = 70, 
	    MaxDistance = 0, 
	    DynamicBoxes = true,
	    DynamicBoxesCheap = false,           
	    DynamicBoxesIncludeAll = true,      
	    VisibilityCheckRate = 0.3,
	    Filter = nil, 

	    
	    Boxes = true,
	    BoxType = "Normal", 
	    BoxColor = Color3.fromRGB(255, 255, 255),
	    BoxThickness = 1,
	    Outlines = {
	        Style = "Full", 
	        Color = Color3.fromRGB(0, 0, 0),
	        Thickness = 1,
	    },

	    
	    BoxFill = {
	        Enabled = false,
	        Color = Color3.fromRGB(255, 255, 255),
	        Transparency = 0.9,
	        Gradient = {
	            Enabled = false,
	            Color1 = Color3.fromRGB(180, 255, 255),
	            Color2 = Color3.fromRGB(0, 255, 255),
	            Color3 = Color3.fromRGB(0, 120, 255),
	            Rotation = 0,
	            Animated = false,
	            Speed = 64,          
	            Direction = "Right", 
	        }
	    },

	    
	    HealthBar = {
	        Enabled = false,
	        
	        
	        
	        
	        Source = "Humanoid",
	        Part = "Head", 
	        Position = "Left", 
	        SideGap = 2,
	        Width = 2,
	        ShowText = false,
	        TextFollowBar = false,
	        HideWhenFullHP = false,
	        FollowGradientColorText = false,
	        Font = "Smallest Pixel-7",
	        TextSize = 9,
	        Outline = {
	            Style = "Full",
	            Color = Color3.fromRGB(0, 0, 0),
	        },
	        Gradient = {
	            Enabled = false,
	            Color1 = Color3.fromRGB(0, 255, 0),   
	            Color2 = Color3.fromRGB(255, 255, 0), 
	            Color3 = Color3.fromRGB(255, 0, 0),   
	        }
	    },

	    
	    Names = true,
	    TextSize = 12,
	    TextColor = Color3.fromRGB(255, 255, 255),
	    TextOutline = false,
	    TextOutlineStyle = "Full", 
	    TextGap = 3,
	    Font = "Proggy Clean",
	    TeamIndicator = {
	        Enabled = false,
	        Position = "Right", 
	        UseTeamColor = false,
	        Color = Color3.fromRGB(255, 255, 255),
	        Compact = false,
	        TextSize = 10,
	    },
	    FriendlyIndicator = {
	        Enabled = false,
	        Position = "Right", 
	        CheckTeam = false,
	        CheckFriends = false,
	        Text = "[F]",
	        Color = Color3.fromRGB(0, 255, 0),
	    },
	    Weapon = {
	        Enabled = false,
	        Gap = 1,
	        OutlineStyle = "Full",
	        Font = "Proggy Clean",
	        TextSize = 12,
	        Color = Color3.fromRGB(255, 255, 255),
	        InventoryPath = "ReplicatedStorage.Players.%NAME%.Inventory",
	        UseToolFallback = true,
	    },

	    
	    Flags = {
	        Enabled = false,
	        Position = "Right",
	        Gap = 2,
	        SideGap = 4,
	        TextGap = 2,
	        OutlineStyle = "Full",
	        Font = "Smallest Pixel-7",
	        TextSize = 9,
	        Options = {
	            Idle = false,
	            Moving = false,
	            Jumping = false,
	            Swimming = false,
	        },
	        Colors = {
	            Idle = Color3.fromRGB(255, 255, 255),
	            Moving = Color3.fromRGB(255, 255, 255),
	            Jumping = Color3.fromRGB(255, 255, 255),
	            Swimming = Color3.fromRGB(65, 65, 255),
	        }
	    },

	    
	    Skeleton = {
	        Enabled = false,
	        Color = Color3.fromRGB(255, 255, 255),
	        Outline = false,
	        OutlineColor = Color3.fromRGB(0, 0, 0),
	        Gradient = {
	            Enabled = false,
	            Color1 = Color3.fromRGB(255, 255, 255),
	            Color2 = Color3.fromRGB(100, 200, 255),
	        },
	    },

	    
	    OffScreenArrows = {
	        Enabled = false,
	        Size = 14,
	        Color = Color3.fromRGB(255, 255, 255),
	        OrbitRadius = 100,
	        ArrowMode = "Camera",
	        Outline = false,
	        OutlineColor = Color3.fromRGB(0, 0, 0),
	        Names = {
	            Enabled = false,
	            Font = "Smallest Pixel-7",
	            TextSize = 9,
	            Color = Color3.fromRGB(255, 255, 255),
	            Outline = true,
	            OutlineColor = Color3.fromRGB(0, 0, 0),
	            Side = "Bottom",
	            Gap = 4,
	        },
	        Distance = {
	            Enabled = false,
	            Font = "Smallest Pixel-7",
	            TextSize = 9,
	            Color = Color3.fromRGB(255, 255, 255),
	            Outline = false,
	            OutlineColor = Color3.fromRGB(0, 0, 0),
	            Side = "Bottom",
	            Gap = 2,
	        },
	    },

	    
	    Distance = {
	        Enabled = false,
	        Unit = "Meters",
	        StudsPerMeter = 3,
	        Ending = "m",
	        Gap = 3,
	        OutlineStyle = "Full",
	        Font = "Proggy Clean",
	        TextSize = 12,
	        Color = Color3.fromRGB(255, 255, 255),
	    },

	    
	    Chams = {
	        Enabled = false,
	        Type = "MeshChams", 

	        Highlight = {
	            FillColor = Color3.fromRGB(255, 255, 255),
	            FillTransparency = 1,
	            OutlineColor = Color3.fromRGB(255, 255, 255),
	            OutlineTransparency = 0,
	            VisibleCheck = false, 
	        },

	        Adornment = {
	            Color = Color3.fromRGB(59, 144, 204),
	            VisibleColor = Color3.fromRGB(59, 204, 90),
	            Transparency = 0.7,
	            AlwaysOnTop = false,
	            VisibleCheck = false,
	        },

	        
	        
	        MeshChams = {
	            FillColor = Color3.fromRGB(59, 144, 204),
	            FillTransparency = 0.6,
	            OutlineColor = Color3.fromRGB(255, 255, 255),
	            OutlineTransparency = 0,
	            VisibleCheck = false, 
	        },
	    },

	    
	    Directories = {
	        
	    





































































































































































}
	}

	local function F(G)
	    if type(G) ~= "table" then
	        return G
	    end

	    local H = {}
	    for I, J in pairs(G) do
	        H[I] = F(J)
	    end
	    return H
	end

	local function G(H, I)
	    if type(I) ~= "table" then
	        return H
	    end

	    for J, K in pairs(I) do
	        if type(K) == "table" and type(H[J]) == "table" then
	            G(H[J], K)
	        else
	            H[J] = K
	        end
	    end

	    return H
	end

	local H = F(E)

	local function I(J)
	    if type(J) ~= "string" or J == "" then
	        return ""
	    end

	    local K = {}
	    for L in J:gmatch("[^%s%-_]+") do
	        if L ~= "" then
	            table.insert(K, L)
	        end
	    end

	    if #K == 0 then
	        return J
	    end

	    if #K == 1 then
	        local L = K[1]
	        if #L <= 4 then
	            return L:upper()
	        end
	        return L:sub(1, 1):upper()
	    end

	    local L = {}
	    for M, N in ipairs(K) do
	        table.insert(L, N:sub(1, 1):upper())
	    end
	    return table.concat(L)
	end

	local function J(K)
	    local L = math.clamp(math.floor(K.R * 255 + 0.5), 0, 255)
	    local M = math.clamp(math.floor(K.G * 255 + 0.5), 0, 255)
	    local N = math.clamp(math.floor(K.B * 255 + 0.5), 0, 255)
	    return string.format("#%02X%02X%02X", L, M, N)
	end
	

	
	local K = {
	    ["Proggy Clean"] = Enum.Font.SourceSans,
	    ["Smallest Pixel-7"] = Enum.Font.SourceSans,
	    ["Tahoma"] = Enum.Font.SourceSans,
	    ["Minecraftia"] = Enum.Font.SourceSans,
	    ["Tahoma Modern Bold"] = Enum.Font.SourceSansBold,
	}

	local L = {
	    ["Tahoma"] = { TTF = "https://github.com/LuckyHub1/LuckyHub/raw/main/zekton_rg.ttf" },
	    ["Minecraftia"] = { TTF = "https://github.com/LuckyHub1/LuckyHub/raw/refs/heads/main/Minecraftia.ttf" },
	    ["Smallest Pixel-7"] = { TTF = "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/smallest_pixel-7.ttf" },
	    ["Proggy Clean"] = { TTF = "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyClean.ttf" },
	    ["Tahoma Modern Bold"] = { TTF = "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Tahoma-Modern-Bold.ttf" },
	}

	local M = { Loaded = {} }
	local N = true


	local O = {
	    
	    { "UpperTorso", "LowerTorso" },
	    
	    { "Head", "UpperTorso" },
	    
	    { "UpperTorso", "LeftUpperArm" },
	    { "LeftUpperArm", "LeftLowerArm" },
	    { "LeftLowerArm", "LeftHand" },
	    
	    { "UpperTorso", "RightUpperArm" },
	    { "RightUpperArm", "RightLowerArm" },
	    { "RightLowerArm", "RightHand" },
	    
	    { "LowerTorso", "LeftUpperLeg" },
	    { "LeftUpperLeg", "LeftLowerLeg" },
	    { "LeftLowerLeg", "LeftFoot" },
	    
	    { "LowerTorso", "RightUpperLeg" },
	    { "RightUpperLeg", "RightLowerLeg" },
	    { "RightLowerLeg", "RightFoot" },
	}

	local function P(Q, R)
	    local S = v:getPart(Q, R)
	    if S then return S.Position end

	    
	    if R == "Head" then
	        S = v:getPart(Q, "Head")
	    elseif R == "UpperTorso" then
	        S = v:getPart(Q, "Torso")
	    elseif R == "LowerTorso" then
	        S = v:getPart(Q, "Torso")
	        if S then return (S.CFrame * CFrame.new(0, -1.2, 0)).Position end
	    elseif R == "LeftUpperArm" then
	        S = v:getPart(Q, "Left Arm") or v:getPart(Q, "LeftArm")
	    elseif R == "LeftLowerArm" then
	        S = v:getPart(Q, "Left Arm") or v:getPart(Q, "LeftArm")
	        if S then return (S.CFrame * CFrame.new(0, -0.8, 0)).Position end
	    elseif R == "LeftHand" then
	        S = v:getPart(Q, "Left Arm") or v:getPart(Q, "LeftArm")
	        if S then return (S.CFrame * CFrame.new(0, -1.5, 0)).Position end
	    elseif R == "RightUpperArm" then
	        S = v:getPart(Q, "Right Arm") or v:getPart(Q, "RightArm")
	    elseif R == "RightLowerArm" then
	        S = v:getPart(Q, "Right Arm") or v:getPart(Q, "RightArm")
	        if S then return (S.CFrame * CFrame.new(0, -0.8, 0)).Position end
	    elseif R == "RightHand" then
	        S = v:getPart(Q, "Right Arm") or v:getPart(Q, "RightArm")
	        if S then return (S.CFrame * CFrame.new(0, -1.5, 0)).Position end
	    elseif R == "LeftUpperLeg" then
	        S = v:getPart(Q, "Left Leg") or v:getPart(Q, "LeftLeg")
	    elseif R == "LeftLowerLeg" then
	        S = v:getPart(Q, "Left Leg") or v:getPart(Q, "LeftLeg")
	        if S then return (S.CFrame * CFrame.new(0, -0.8, 0)).Position end
	    elseif R == "LeftFoot" then
	        S = v:getPart(Q, "Left Leg") or v:getPart(Q, "LeftLeg")
	        if S then return (S.CFrame * CFrame.new(0, -1.5, 0)).Position end
	    elseif R == "RightUpperLeg" then
	        S = v:getPart(Q, "Right Leg") or v:getPart(Q, "RightLeg")
	    elseif R == "RightLowerLeg" then
	        S = v:getPart(Q, "Right Leg") or v:getPart(Q, "RightLeg")
	        if S then return (S.CFrame * CFrame.new(0, -0.8, 0)).Position end
	    elseif R == "RightFoot" then
	        S = v:getPart(Q, "Right Leg") or v:getPart(Q, "RightLeg")
	        if S then return (S.CFrame * CFrame.new(0, -1.5, 0)).Position end
	    end

	    return S and S.Position
	end
	local Q = writefile and isfile and getcustomasset
	local function R(S, T)
	    if not Q then return end
	    local U = S:gsub("%s+", "")
	    local V, W = pcall(function() return game:HttpGet(T) end)
	    if not V or not W or W == "" then return end
	    local X = pcall(writefile, U .. ".ttf", W)
	    if not X then return end
	    local Y = pcall(function()
	        local Y = {
	            name = U,
	            faces = { { name = "Regular", weight = 400, style = "normal", assetId = getcustomasset(U .. ".ttf") } }
	        }
	        writefile(U .. ".ttf.json", i:JSONEncode(Y))
	    end)
	    if not Y then return end
	    local Z, _ = pcall(Font.new, getcustomasset(U .. ".ttf.json"), Enum.FontWeight.Regular)
	    if Z and _ then
	        M.Loaded[S] = _
	    end
	end

	local function S()
	    if not Q then N = false; return end
	    for T, U in pairs(L) do
	        if M.Loaded[T] then continue end
	        R(T, U.TTF)
	    end
	    N = false
	    for T in pairs(L) do
	        if not M.Loaded[T] then N = true; break end
	    end
	end

	task.spawn(function()
	    task.wait(1)
	    S()
	end)
	

	
	local T = {}

	
	local function U(V)
	    local W = string.split(V, ".")
	    local X = game
	    for Y, Z in ipairs(W) do
	        if X == game and (Z == "Workspace" or Z == "workspace") then
	            X = h
	        elseif X == game and Z == "Players" then
	            X = f
	        else
	            local _ = X:FindFirstChild(Z)
	            if _ then
	                X = _
	            else
	                return nil
	            end
	        end
	    end
	    return X ~= game and X or nil
	end

	local function V(W)
	    local X = Instance.new("Frame")
	    X.BorderSizePixel = 0
	    X.BackgroundColor3 = E.BoxColor
	    X.Parent = W

	    local Y = Instance.new("Frame")
	    Y.BorderSizePixel = 0
	    Y.BackgroundColor3 = E.Outlines.Color
	    Y.ZIndex = 0
	    Y.Parent = X

	    return X, Y
	end

	local aa = function(W)
	    LPH_ATTRIBUTES(VM(NONE))
	    local X = {
	        Visible = false,
	        Lines = {},
	        Outlines = {},
	        CornerLines = {},
	        CornerOutlines = {},

	        FlagLabels = {},
	        LastVisCheck = 0,
	        CachedModelVisible = true
	    }

	    local Y = Instance.new("Frame")
	    Y.BackgroundTransparency = 1
	    Y.Name = "ESPObj"
	    Y.Parent = r
	    X.Container = Y

	    local Z = Instance.new("Frame")
	    Z.BorderSizePixel = 0
	    Z.ZIndex = 0
	    Z.Visible = false
	    Z.Parent = Y
	    X.BoxFill = Z

	    local _ = Instance.new("UIGradient")
	    _.Parent = Z
	    X.BoxFillGradient = _

	    for aa = 1, 4 do
	        local ab, ac = V(Y)
	        X.Lines[aa] = ab
	        X.Outlines[aa] = ac
	    end

	    for aa = 1, 8 do
	        local ab, ac = V(Y)
	        ab.Visible = false
	        ac.Visible = false
	        X.CornerLines[aa] = ab
	        X.CornerOutlines[aa] = ac
	    end

	    local function aa(ab)
	        ab.BackgroundTransparency = 1
	        ab.Size = UDim2.new(0, 100, 0, E.TextSize)
	        ab.Font = K[E.Font] or Enum.Font.Code
	        if M.Loaded[E.Font] then
	            ab.FontFace = M.Loaded[E.Font]
	        end
	        ab.TextSize = E.TextSize
	        ab.TextColor3 = E.TextColor
	        ab.TextStrokeTransparency = 1
	        ab.ZIndex = 2
	        ab.Parent = Y

	        local ac = Instance.new("UIStroke")
	        ac.Thickness = 1
	        ac.Color = E.TextOutlineColor or E.Outlines.Color
	        ac.LineJoinMode = Enum.LineJoinMode.Miter
	        ac.Enabled = E.TextOutline
	        ac.Parent = ab
	        C[ab] = ac
	    end

	    local ab = Instance.new("TextLabel")
	    aa(ab)
	    ab.TextYAlignment = Enum.TextYAlignment.Bottom
	    ab.RichText = true
	    ab.Text = W
	    ab.Visible = E.Names
	    X.Text = ab

	    X.TeamText = nil
	    X.TeamTextStroke = nil
	    X.FriendlyText = nil
	    X.FriendlyTextStroke = nil

	    local ac = Instance.new("TextLabel")
	    aa(ac)
	    ac.TextYAlignment = Enum.TextYAlignment.Top
	    ac.Visible = false
	    X.DistanceText = ac

	    local ad = Instance.new("TextLabel")
	    aa(ad)
	    ad.TextYAlignment = Enum.TextYAlignment.Top
	    ad.Visible = false
	    X.WeaponText = ad

	    local ae = Instance.new("Frame")
	    ae.BackgroundColor3 = E.Outlines.Color
	    ae.BorderSizePixel = 0
	    ae.Visible = false
	    ae.ZIndex = 1
	    ae.Parent = Y
	    X.HealthBarOutline = ae

	    local af = Instance.new("Frame")
	    af.BackgroundTransparency = 1
	    af.ClipsDescendants = true
	    af.BorderSizePixel = 0
	    af.ZIndex = 2
	    af.Parent = ae
	    X.HealthBarContainer = af

	    local ag = Instance.new("Frame")
	    ag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	    ag.BorderSizePixel = 0
	    ag.ZIndex = 2
	    ag.Parent = af
	    X.HealthBar = ag

	    local ah = Instance.new("UIGradient")
	    ah.Enabled = E.HealthBar.Gradient.Enabled
	    ah.Color = ColorSequence.new({
	        ColorSequenceKeypoint.new(0, E.HealthBar.Gradient.Color1),
	        ColorSequenceKeypoint.new(0.5, E.HealthBar.Gradient.Color2),
	        ColorSequenceKeypoint.new(1, E.HealthBar.Gradient.Color3)
	    })
	    ah.Parent = ag
	    X.HealthGradient = ah

	    local ai = Instance.new("TextLabel")
	    aa(ai)
	    ai.TextYAlignment = Enum.TextYAlignment.Center
	    ai.ZIndex = 3
	    ai.Visible = false
	    X.HealthText = ai

	    for aj = 1, 5 do 
	        local ak = Instance.new("TextLabel")
	        aa(ak)
	        ak.TextSize = E.Flags.TextSize
	        ak.Font = K[E.Flags.Font] or Enum.Font.Code
	        if M.Loaded[E.Flags.Font] then
	            ak.FontFace = M.Loaded[E.Flags.Font]
	        end
	        ak.Visible = false
	        X.FlagLabels[aj] = ak
	    end

	    X.Bones = {}
	    X.BoneOutlines = {}
	    for aj = 1, #O do
	        local ak = Instance.new("Frame")
	        ak.BorderSizePixel = 0
	        ak.Visible = false
	        ak.ZIndex = 1
	        ak.Parent = Y
	        X.BoneOutlines[aj] = ak

	        local al = Instance.new("Frame")
	        al.BorderSizePixel = 0
	        al.Visible = false
	        al.ZIndex = 2
	        al.Parent = Y
	        X.Bones[aj] = al
	    end

	    local aj = Instance.new("TextLabel")
	    aj.BackgroundTransparency = 1
	    aj.Text = "▲"
	    aj.TextColor3 = E.OffScreenArrows.Color
	    aj.TextSize = E.OffScreenArrows.Size
	    aj.Font = Enum.Font.SourceSans
	    aj.Size = UDim2.new(0, E.OffScreenArrows.Size * 2, 0, E.OffScreenArrows.Size * 2)
	    aj.ZIndex = 100
	    aj.Visible = false
	    aj.Parent = r
	    X.ArrowInner = aj

	    local ak = Instance.new("TextLabel")
	    ak.BackgroundTransparency = 1
	    ak.Text = "▲"
	    ak.TextColor3 = E.OffScreenArrows.OutlineColor
	    ak.TextSize = E.OffScreenArrows.Size + 2
	    ak.Font = Enum.Font.SourceSans
	    ak.Size = UDim2.new(0, (E.OffScreenArrows.Size + 2) * 2, 0, (E.OffScreenArrows.Size + 2) * 2)
	    ak.ZIndex = 99
	    ak.Visible = false
	    ak.Parent = r
	    X.ArrowOutline = ak

	    local function al()
	        local am = Instance.new("TextLabel")
	        am.BackgroundTransparency = 1
	        am.Size = UDim2.new(0, 150, 0, 12)
	        am.TextStrokeTransparency = 1
	        am.ZIndex = 110
	        am.TextColor3 = Color3.fromRGB(255, 255, 255)
	        am.Visible = false
	        am.Parent = r
	        local an = Instance.new("UIStroke")
	        an.Parent = am
	        C[am] = an
	        return am
	    end
	    X.ArrowName = al()
	    X.ArrowDist = al()

	    X.Adornments = {}
	    X.Highlight = nil

	    X.Destroy = function()
	        Y:Destroy()
	        if X.Highlight then X.Highlight:Destroy() end
	        if X.MeshShell then X.MeshShell:Destroy() end
	        for am, an in pairs(X.Adornments) do an:Destroy() end
	        if X.ArrowInner then X.ArrowInner:Destroy() end
	        if X.ArrowOutline then X.ArrowOutline:Destroy() end
	        if X.ArrowName then X.ArrowName:Destroy() end
	        if X.ArrowDist then X.ArrowDist:Destroy() end
	    end

	    return X
	end

	
	
	local function ab(ac)
	    if not ac then return nil end
	    local ad = ac:FindFirstChild("Health")
	    if ad and ad:IsA("ValueBase") then
	        return ad.Value, (ad:GetAttribute("MaxHealth") or 100)
	    end
	    return nil
	end

	
	local function ac(ad,ae,af,ag, ah)
	    return v:get_health(ah.owner.value)
	end

	
	local ag = setmetatable({}, {
	    __index = function(ag, ah)
	        local ai = string.split(ah, ".")
	        ag[ah] = ai
	        return ai
	    end,
	})
	local ah = function(ah, ai, aj, ak, al, am, an, W,
	                                               X,
	                                               Y, Z, _)
	    LPH_ATTRIBUTES(VM(NONE))
	    local ao = {}
	    local ap = type(Y) == "table" and next(Y) ~= nil
	    local function aq(ar)
	        local as = ao[ar]
	        if as ~= nil then return as end
	        local at = ag[ar]
	        local au = #at
	        if ap then
	            local av = Y
	            local aw = 1
	            while aw <= au and type(av) == "table" do
	                av = av[at[aw] ]
	                if av == nil then
	                    break
	                end
	                aw += 1
	            end
	            if aw > au and av ~= nil then
	                ao[ar] = av
	                return av
	            end
	        end
	        local av = E
	        for aw = 1, au do
	            av = av[at[aw] ]
	        end
	        ao[ar] = av
	        return av
	    end

	    local ar = tick()

	    
	    local as = aq("MaxDistance")
	    if as and as > 0 and al and al > as then
	        ah.Container.Visible = false
	        if ah.Highlight then ah.Highlight:Destroy() ah.Highlight = nil end
	        if ah.MeshShell then ah.MeshShell:Destroy() ah.MeshShell = nil ah.MeshHighlight = nil end
	        if ah.Adornments then for at, au in pairs(ah.Adornments) do au.Visible = false end end
	        if ah.ArrowInner then
	            ah.ArrowInner.Visible = false
	            ah.ArrowOutline.Visible = false
	            ah.ArrowName.Visible = false
	            ah.ArrowDist.Visible = false
	        end
	        if ah.Bones then for at, au in ipairs(ah.Bones) do au.Visible = false end end
	        if ah.BoneOutlines then for at, au in ipairs(ah.BoneOutlines) do au.Visible = false end end
	        return
	    end

	    
	    local at = _ and _.owner and v:get_health(_.owner.value)
	    local au = type(at) == "number" and at <= 0
	    local av = aq("Chams.Enabled")
	    if av and not au then
	        local aw = aq("Chams.Type")
	        if aw == "Highlight" and (am:IsA("Model") or am:IsA("BasePart")) then
	            
	            if ah.MeshShell then
	                ah.MeshShell:Destroy()
	                ah.MeshShell = nil
	                ah.MeshHighlight = nil
	            end
	            if not ah.Highlight then
	                ah.Highlight = Instance.new("Highlight")
	            end
	            local ax = ah.Highlight
	            ax.Parent = p
	            ax.Adornee = am
	            ax.FillColor = aq("Chams.Highlight.FillColor")
	            ax.FillTransparency = aq("Chams.Highlight.FillTransparency")
	            ax.OutlineColor = aq("Chams.Highlight.OutlineColor")
	            ax.OutlineTransparency = aq("Chams.Highlight.OutlineTransparency")
	            ax.DepthMode = aq("Chams.Highlight.VisibleCheck") and Enum.HighlightDepthMode.Occluded or
	                Enum.HighlightDepthMode.AlwaysOnTop
	            ax.Enabled = true

	            
	            if ah.Adornments then
	                for ay, az in pairs(ah.Adornments) do az.Visible = false end
	            end
	        elseif aw == "Adornment" then
	            if ah.Highlight then
	                ah.Highlight:Destroy()
	                ah.Highlight = nil
	            end
	            
	            if ah.MeshShell then
	                ah.MeshShell:Destroy()
	                ah.MeshShell = nil
	                ah.MeshHighlight = nil
	            end

	            local ax = am:IsA("Model") and am:GetChildren() or { am }
	            local ay = 0

	            local az = aq("Chams.Adornment.VisibleCheck")
	            local aA = aq("VisibilityCheckRate") or 0.1
	            local aB = ar
	            local aC = ah.LastVisCheck or 0
	            local aD = (aB - aC) > aA

	            if az and aD then
	                ah.LastVisCheck = aB
	                local aE = { m }
	                local aF, aG = v:get_character(j)
	                local aH = v:get_viewmodel(j)
	                if aG then table.insert(aE, aG) end
	                if aH then table.insert(aE, aH) end
	                if am:IsA("Model") then
	                    for aI, aJ in ipairs(am:GetDescendants()) do table.insert(aE, aJ) end
	                else
	                    table.insert(aE, am)
	                end

	                local aI = am:IsA("Model") and
	                    (am.PrimaryPart or am:FindFirstChild("HumanoidRootPart") or am:FindFirstChildWhichIsA("BasePart")) or
	                    am
	                if aI and aI:IsA("BasePart") then
	                    local aJ = k:GetPartsObscuringTarget({ aI.Position }, aE)
	                    ah.CachedModelVisible = (#aJ == 0)
	                end
	            end

	            local aE = aq("Chams.Adornment.Color")
	            local aF = aq("Chams.Adornment.VisibleColor")
	            local aG = (az and ah.CachedModelVisible) and aF or aE

	            for aH, aI in ipairs(ax) do
	                if aI:IsA("BasePart") and aI.Name ~= "HumanoidRootPart" then
	                    ay = ay + 1
	                    local aJ = ah.Adornments[ay]
	                    if not aJ then
	                        aJ = Instance.new("BoxHandleAdornment")
	                        aJ.Name = "Cham"
	                        aJ.Parent = p
	                        ah.Adornments[ay] = aJ
	                    end

	                    aJ.Adornee = aI
	                    aJ.Size = aI.Size
	                    aJ.Color3 = aG
	                    aJ.Transparency = aq("Chams.Adornment.Transparency")
	                    aJ.AlwaysOnTop = aq("Chams.Adornment.AlwaysOnTop")
	                    aJ.ZIndex = 10
	                    aJ.Visible = true
	                end
	            end
	            
	            for aH = ay + 1, #ah.Adornments do
	                ah.Adornments[aH].Visible = false
	            end
	        elseif aw == "MeshChams" then
	            
	            
	            local ax = _ and _.owner and _.owner.value
	            if not ax then
	                if ah.MeshShell then
	                    ah.MeshShell:Destroy()
	                    ah.MeshShell = nil
	                    ah.MeshHighlight = nil
	                end
	            else
	                
	                if ah.Highlight then
	                    ah.Highlight:Destroy()
	                    ah.Highlight = nil
	                end
	                if ah.Adornments then
	                    for ay, az in pairs(ah.Adornments) do az.Visible = false end
	                end

	                
	                if not ah.MeshShell or not ah.MeshShell.Parent then
	                    if ah.MeshShell then
	                        ah.MeshShell:Destroy()
	                        ah.MeshShell = nil
	                        ah.MeshHighlight = nil
	                    end

	                    A(am)

	                    local ay    = {"head", "torso", "leg1", "leg2", "arm1", "arm2", "hip1", "hip2", "shoulder1", "shoulder2"}

	                    local az   = Instance.new("Model")
	                    az.Name    = "ChamShells"
	                    az:SetAttribute("SensoryESP_MeshCham", true)
	                    az:SetAttribute("SensoryESP_RunId", u)
	                    az.Parent = am

	                    for aA, aB in ipairs(ay) do
	                        local aC = am:FindFirstChild(aB)
	                        if aC and aC:IsA("BasePart") then
	                            local aD = Instance.new("Part")
	                            aD.Name  = "ChamShell_" .. aB
	                            aD:SetAttribute("SensoryESP_MeshCham", true)
	                            aD:SetAttribute("SensoryESP_RunId", u)
	                            aD.Size         = aC.Size * 1.015
	                            aD.Transparency = 0.9999999
	                            aD.CastShadow   = false
	                            aD.CanCollide   = false
	                            aD.CanQuery     = false
	                            aD.CanTouch     = false
	                            aD.Anchored     = false
	                            aD.Massless     = true
	                            aD.CFrame       = aC.CFrame
	                            aD.Parent       = az

	                            local aE         = Instance.new("Weld")
	                            aE.Part0         = aD
	                            aE.Part1         = aC
	                            aE.C0            = CFrame.new()
	                            aE.C1            = CFrame.new()
	                            aE.Parent        = aD
	                        end
	                    end

	                    
	                    local aA = Instance.new("Highlight")
	                    aA.Name  = "ChamShellHighlight"
	                    aA:SetAttribute("SensoryESP_MeshCham", true)
	                    aA:SetAttribute("SensoryESP_RunId", u)
	                    aA.Adornee           = az
	                    aA.Parent            = az
	                    ah.MeshShell     = az
	                    ah.MeshHighlight = aA
	                end

	                
	                if ah.MeshHighlight then
	                    local ay               = ah.MeshHighlight
	                    ay.FillColor           = aq("Chams.MeshChams.FillColor")
	                    ay.FillTransparency    = aq("Chams.MeshChams.FillTransparency")
	                    ay.OutlineColor        = aq("Chams.MeshChams.OutlineColor")
	                    ay.OutlineTransparency = aq("Chams.MeshChams.OutlineTransparency")
	                    ay.DepthMode           = aq("Chams.MeshChams.VisibleCheck")
	                        and Enum.HighlightDepthMode.Occluded
	                        or Enum.HighlightDepthMode.AlwaysOnTop
	                    ay.Enabled             = true
	                end
	            end
	        end
	    else
	        
	        if ah.Highlight then
	            ah.Highlight:Destroy()
	            ah.Highlight = nil
	        end
	        if ah.Adornments then
	            for aw, ax in pairs(ah.Adornments) do ax.Visible = false end
	        end
	        if ah.MeshShell then
	            ah.MeshShell:Destroy()
	            ah.MeshShell = nil
	            ah.MeshHighlight = nil
	        end
	    end

	    local function aw(ax, ay, az)
	        local aA = C[ax] or ax:FindFirstChildOfClass("UIStroke")
	        if not aA then return end
	        if ay == "None" then
	            aA.Enabled = false
	        elseif ay == "Shadow" then
	            aA.Enabled = true
	            aA.Thickness = 1
	            aA.Color = az or Color3.fromRGB(0, 0, 0)
	        else
	            aA.Enabled = true
	            aA.Thickness = 1
	            aA.Color = az or Color3.fromRGB(0, 0, 0)
	        end
	    end

	    
	    if ah.ArrowInner and aq("OffScreenArrows.Enabled") and am:IsA("Model") then
	        local ax = am.PrimaryPart or am:FindFirstChild("HumanoidRootPart") or am:FindFirstChildWhichIsA("BasePart")
	        if ax then
	            local ay = k:WorldToViewportPoint(ax.Position)
	            local az = k.ViewportSize
	            local aA, aB = az.X / 2, az.Y / 2
	            local aC = ay.Z > 0 and ay.X >= 0 and ay.X <= az.X and ay.Y >= 0 and ay.Y <= az.Y
	            if not aC then
	                local aD = aq("OffScreenArrows.OrbitRadius")
	                local aE, aF, aG
	                if aq("OffScreenArrows.ArrowMode") == "Compass" then
	                    
	                    local aH = v:get_character(j)
	                    local aI = aH and (
	                        v:getPart(am, "HumanoidRootPart") or
	                        v:getPart(am, "Torso") or
	                        v:getPart(am, "BasePart")
	                    )
	                    local aJ = aI and aI.Position or k.CFrame.Position
	                    local aK = (Vector3.new(ax.Position.X, 0, ax.Position.Z) - Vector3.new(aJ.X, 0, aJ.Z)).Unit
	                    local aL = aI and aI.CFrame:VectorToObjectSpace(aK) or aK
	                    aE, aF = aL.X, aL.Z
	                    aG = math.deg(math.atan2(aL.Z, aL.X)) + 90
	                else
	                    
	                    local aH = (ax.Position - k.CFrame.Position).Unit
	                    local aI = k.CFrame:VectorToObjectSpace(aH)
	                    aE, aF = aI.X, -aI.Y
	                    aG = math.deg(math.atan2(-aI.Y, aI.X)) + 90
	                end
	                local aH = math.sqrt(aE * aE + aF * aF)
	                if aH > 0.001 then
	                    aE, aF = aE / aH, aF / aH
	                else
	                    aE, aF = 0, -1
	                end
	                local aI, aJ = aA + aE * aD, aB + aF * aD
	                local aK = aq("OffScreenArrows.Size")
	                local aL = aq("OffScreenArrows.Color")

	                if aq("OffScreenArrows.Outline") then
	                    ah.ArrowOutline.TextSize = aK + 2
	                    ah.ArrowOutline.TextColor3 = aq("OffScreenArrows.OutlineColor")
	                    ah.ArrowOutline.Position = UDim2.new(0, aI - aK - 2, 0, aJ - aK - 2)
	                    ah.ArrowOutline.Rotation = aG
	                    ah.ArrowOutline.Visible = true
	                else
	                    ah.ArrowOutline.Visible = false
	                end

	                local aM = K[aq("OffScreenArrows.Font")] or Enum.Font.SourceSans
	                ah.ArrowInner.Text = "▲"
	                ah.ArrowInner.Font = aM
	                ah.ArrowInner.TextSize = aK
	                ah.ArrowInner.TextColor3 = aL
	                ah.ArrowInner.Position = UDim2.new(0, aI - aK, 0, aJ - aK)
	                ah.ArrowInner.Size = UDim2.new(0, aK * 2, 0, aK * 2)
	                ah.ArrowInner.Rotation = aG
	                ah.ArrowInner.Visible = true

	                
	                local aN = aJ + aK + 4

	                if aq("OffScreenArrows.Names.Enabled") and ak and ak ~= "" then
	                    local aO = aq("OffScreenArrows.Names.Font")
	                    local aP = aq("OffScreenArrows.Names.TextSize")
	                    local aQ = K[aO] or Enum.Font.Code
	                    local aR = M.Loaded[aO]
	                    local aS = aq("OffScreenArrows.Names.Side")
	                    local aT = aq("OffScreenArrows.Names.Gap") or 4
	                    local aU = aq("OffScreenArrows.Names.Color")
	                    local aV = aq("OffScreenArrows.Names.Outline")
	                    local aW = aq("OffScreenArrows.Names.OutlineColor")
	                    ah.ArrowName.Font = aQ
	                    if aR then ah.ArrowName.FontFace = aR end
	                    ah.ArrowName.TextSize = aP
	                    ah.ArrowName.TextColor3 = aU
	                    ah.ArrowName.Text = ak
	                    if aS == "Top" then
	                        ah.ArrowName.Position = UDim2.new(0, aI - 75, 0, aJ - aK - aT - aP)
	                    elseif aS == "Left" then
	                        ah.ArrowName.Position = UDim2.new(0, aI - aK - aT - 150, 0, aJ - 6)
	                    elseif aS == "Right" then
	                        ah.ArrowName.Position = UDim2.new(0, aI + aK + aT, 0, aJ - 6)
	                    else
	                        ah.ArrowName.Position = UDim2.new(0, aI - 75, 0, aN)
	                        aN = aN + aP + 1
	                    end
	                    aw(ah.ArrowName, aV and "Full" or "None", aW or Color3.fromRGB(0, 0, 0))
	                    ah.ArrowName.Visible = true
	                else
	                    ah.ArrowName.Visible = false
	                end

	                if aq("OffScreenArrows.Distance.Enabled") then
	                    local aO = aq("OffScreenArrows.Distance.Font")
	                    local aP = aq("OffScreenArrows.Distance.TextSize")
	                    local aQ = K[aO] or Enum.Font.Code
	                    local aR = M.Loaded[aO]
	                    local aS = aq("OffScreenArrows.Distance.Side")
	                    local aT = aq("OffScreenArrows.Distance.Gap") or 2
	                    local aU = aq("OffScreenArrows.Distance.Color")
	                    local aV = aq("OffScreenArrows.Distance.Outline")
	                    local aW = aq("OffScreenArrows.Distance.OutlineColor")
	                    local aX = aq("Distance.Unit")
	                    local aY
	                    if aX == "Meters" then
	                        aY = math.floor(al / aq("Distance.StudsPerMeter"))
	                    else
	                        aY = math.floor(al)
	                    end
	                    ah.ArrowDist.Font = aQ
	                    if aR then ah.ArrowDist.FontFace = aR end
	                    ah.ArrowDist.TextSize = aP
	                    ah.ArrowDist.TextColor3 = aU
	                    ah.ArrowDist.Text = aY .. aq("Distance.Ending")
	                    if aS == "Top" then
	                        ah.ArrowDist.Position = UDim2.new(0, aI - 75, 0, aJ - aK - aT - aP)
	                    elseif aS == "Left" then
	                        ah.ArrowDist.Position = UDim2.new(0, aI - aK - aT - 150, 0, aJ - 6)
	                    elseif aS == "Right" then
	                        ah.ArrowDist.Position = UDim2.new(0, aI + aK + aT, 0, aJ - 6)
	                    else
	                        ah.ArrowDist.Position = UDim2.new(0, aI - 75, 0, aN)
	                    end
	                    aw(ah.ArrowDist, aV and "Full" or "None", aW or Color3.fromRGB(0, 0, 0))
	                    ah.ArrowDist.Visible = true
	                else
	                    ah.ArrowDist.Visible = false
	                end
	            else
	                ah.ArrowInner.Visible = false
	                ah.ArrowOutline.Visible = false
	                ah.ArrowName.Visible = false
	                ah.ArrowDist.Visible = false
	            end
	        else
	            ah.ArrowInner.Visible = false
	            ah.ArrowOutline.Visible = false
	            ah.ArrowName.Visible = false
	            ah.ArrowDist.Visible = false
	        end
	    else
	        if ah.ArrowInner then
	            ah.ArrowInner.Visible = false
	            ah.ArrowOutline.Visible = false
	            ah.ArrowName.Visible = false
	            ah.ArrowDist.Visible = false
	        end
	    end

	    if not Z or not ai or not aj then
	        ah.Container.Visible = false
	        return
	    end

	    ah.Container.Visible = true
	    ah.Container.ZIndex = W and 1 or 10
	    if aq("Names") then
	        ah.Text.Text = ak
	    end

	    local ax = aq("TextOutlineStyle")
	    
	    if aq("TextOutline") == false then ax = "None" end
	    local ay = aq("TextOutlineColor") or aq("Outlines.Color")

	    local az = aq("BoxThickness")
	    local aA = aq("Outlines.Thickness")
	    local aB = aq("TextSize")
	    local aC = aq("TextColor")
	    local aD = aq("Font")
	    local aE = K[aD] or Enum.Font.Code
	    local aF = M.Loaded[aD]
	    local aG = aq("BoxColor")
	    
	    ah.Text.TextSize = aB
	    ah.Text.TextColor3 = aC
	    ah.Text.Font = aE
	    if aF then
	        ah.Text.FontFace = aF
	    end
	    aw(ah.Text, ax, ay)

	    do
	        local aH = aq("Distance.Font")
	        local aI = K[aH] or Enum.Font.Code
	        ah.DistanceText.TextSize = aq("Distance.TextSize") or aB
	        ah.DistanceText.TextColor3 = aq("Distance.Color")
	        ah.DistanceText.Font = aI
	        if M.Loaded[aH] then
	            ah.DistanceText.FontFace = M.Loaded[aH]
	        end
	        aw(ah.DistanceText, aq("Distance.OutlineStyle") or ax, ay)
	    end

	    do
	        local aH = aq("Weapon.Font")
	        local aI = K[aH] or Enum.Font.Code
	        ah.WeaponText.TextSize = aq("Weapon.TextSize") or aB
	        ah.WeaponText.TextColor3 = aq("Weapon.Color")
	        ah.WeaponText.Font = aI
	        if M.Loaded[aH] then
	            ah.WeaponText.FontFace = M.Loaded[aH]
	        end
	        aw(ah.WeaponText, aq("Weapon.OutlineStyle") or ax, ay)
	    end

	    local aH, aI = math.floor(ai.X), math.floor(ai.Y)
	    local aJ, aK = math.floor(aj.X), math.floor(aj.Y)
	    local aL, aM = math.floor(aH - aJ / 2), math.floor(aI - aK / 2)

	    
	    local aN, aO, aP = 100, 100, 1
	    local aQ = aq("HealthBar.Source")
	    aN, aO = ac(am, nil, aQ, aq("HealthBar.Part"), _)
	    aP = math.clamp(aN / (aO > 0 and aO or 1), 0, 1)

	    
	    local aR = 0
	    local aS = 0
	    local aT = 0
	    local aU = 0
	    if aq("HealthBar.Enabled") and am:IsA("Model") then
	        local aV = aq("HealthBar.Position")
	        local aW = aq("HealthBar.Width") + 2 + aq("HealthBar.SideGap")
	        local aX = aq("Flags.Position") == "Right"
	        local aY = (aq("HealthBar.ShowText") and aN < aO) and 20 or 0

	        if aV == "Top" then
	            aR = aW
	        elseif aV == "Bottom" then
	            aS = aW
	        elseif aV == "Left" then
	            aT = aW + aY
	        elseif aV == "Right" then
	            aU = aW + aY
	        end
	    end

	    if an then
	        for aV = 1, 4 do
	            ah.Lines[aV].Visible = false
	            ah.Outlines[aV].Visible = false
	        end
	        ah.HealthBarOutline.Visible = false
	        ah.HealthText.Visible = false
	        ah.WeaponText.Visible = false
	        for aV, aW in ipairs(ah.FlagLabels) do aW.Visible = false end

	        local aV = aq("Distance.Unit")
	        local aW = al
	        if aV == "Meters" then
	            aW = math.floor(al / aq("Distance.StudsPerMeter"))
	        else
	            aW = math.floor(al)
	        end

	        ah.Text.Text = ak .. " " .. aW .. aq("Distance.Ending")
	        ah.Text.Position = UDim2.new(0, aH - 50, 0, aI - (aB / 2))
	        ah.Text.Visible = aq("Names")
	        ah.DistanceText.Visible = false
	        return
	    end

	    
	    ah.Lines[1].Position = UDim2.new(0, aL, 0, aM)
	    ah.Lines[1].Size = UDim2.new(0, aJ, 0, az)
	    
	    ah.Lines[2].Position = UDim2.new(0, aL, 0, aM + aK)
	    ah.Lines[2].Size = UDim2.new(0, aJ + az, 0, az)
	    
	    ah.Lines[3].Position = UDim2.new(0, aL, 0, aM)
	    ah.Lines[3].Size = UDim2.new(0, az, 0, aK)
	    
	    ah.Lines[4].Position = UDim2.new(0, aL + aJ, 0, aM)
	    ah.Lines[4].Size = UDim2.new(0, az, 0, aK + az)

	    local aV = aq("Boxes")
	    local aW = aq("BoxType") or "Normal"
	    local aX = aW == "Corner"

	    local aY = aq("Outlines.Style")
	    local aZ = aq("Outlines.Color")
	    local a_ = aq("Outlines.Thickness")
	    
	    if aq("Outlines.Enabled") == false then aY = "None" end
	    local a0 = 0
	    local a1 = aY ~= "None"

	    if aX then
	        local a2 = math.max(math.floor(aJ * 0.25), az * 3)
	        local a3 = math.max(math.floor(aK * 0.25), az * 3)

	        local a4 = {
	            { aL,                        aM,                         a2, az },
	            { aL,                        aM,                         az,           a3 },
	            { aL + aJ - a2 + az, aM,                         a2, az },
	            { aL + aJ,                   aM,                         az,           a3 },
	            { aL,                        aM + aK,                    a2, az },
	            { aL,                        aM + aK - a3 + az, az,           a3 },
	            { aL + aJ - a2 + az, aM + aK,                    a2, az },
	            { aL + aJ,                   aM + aK - a3 + az, az,           a3 },
	        }

	        for a5 = 1, 8 do
	            local a6 = a4[a5]
	            ah.CornerLines[a5].Position = UDim2.new(0, a6[1], 0, a6[2])
	            ah.CornerLines[a5].Size = UDim2.new(0, a6[3], 0, a6[4])
	        end
	    end

	    for a2 = 1, 4 do
	        ah.Lines[a2].Visible = aV and not aX
	        ah.Outlines[a2].Visible = aV and a1 and not aX

	        ah.Outlines[a2].Position = UDim2.new(0, -a_, 0, -a_)
	        ah.Outlines[a2].Size = UDim2.new(1, a_ * 2, 1, a_ * 2)
	        ah.Outlines[a2].BackgroundTransparency = a0
	        ah.Lines[a2].BackgroundColor3 = aG
	        ah.Outlines[a2].BackgroundColor3 = aZ
	    end

	    for a2 = 1, 8 do
	        ah.CornerLines[a2].Visible = aV and aX
	        ah.CornerOutlines[a2].Visible = aV and a1 and aX

	        ah.CornerOutlines[a2].Position = UDim2.new(0, -a_, 0, -a_)
	        ah.CornerOutlines[a2].Size = UDim2.new(1, a_ * 2, 1, a_ * 2)
	        ah.CornerOutlines[a2].BackgroundTransparency = a0
	        ah.CornerLines[a2].BackgroundColor3 = aG
	        ah.CornerOutlines[a2].BackgroundColor3 = aZ
	    end

	    
	    local a2 = ah.BoxFill
	    local a3 = ah.BoxFillGradient
	    if aq("BoxFill.Enabled") and aV then
	        a2.Visible = true
	        a2.Position = UDim2.new(0, aL, 0, aM)
	        a2.Size = UDim2.new(0, aJ, 0, aK)
	        a2.BackgroundTransparency = aq("BoxFill.Transparency")

	        if aq("BoxFill.Gradient.Enabled") then
	            a3.Enabled = true
	            local a4 = aq("BoxFill.Gradient.Color1")
	            local a5 = aq("BoxFill.Gradient.Color2")
	            local a6 = aq("BoxFill.Gradient.Color3")
	            a3.Color = ColorSequence.new({
	                ColorSequenceKeypoint.new(0, a4),
	                ColorSequenceKeypoint.new(0.5, a5),
	                ColorSequenceKeypoint.new(1, a6)
	            })

	            local a7 = aq("BoxFill.Gradient.Rotation")
	            if aq("BoxFill.Gradient.Animated") then
	                local a8 = aq("BoxFill.Gradient.Speed")
	                local a9 = aq("BoxFill.Gradient.Direction") == "Left" and -1 or 1
	                a7 = (a7 + (ar * a8 * a9)) % 360
	            end
	            a3.Rotation = a7
	            a2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	        else
	            a3.Enabled = false
	            a2.BackgroundColor3 = aq("BoxFill.Color")
	        end
	    else
	        a2.Visible = false
	    end

	    local a4 = aM - aB - (aq("TextGap") or 0) - aR
	    local a5 = _ and _.owner and _.owner.value or nil
	    local a6 = {}
	    local a7 = {}

	    if aq("TeamIndicator.Enabled") and a5 then
	        local a8 = a5:GetAttribute("Team")
	        if a8 then
	            local a9 = aq("TeamIndicator.UseTeamColor") and BrickColor.new(tostring(a8)).Color or
	            aq("TeamIndicator.Color")
	            local ba = aq("TeamIndicator.Compact") and I(a8) or a8
	            local bb = string.format('<font color="%s">[%s]</font>', J(a9), ba)
	            if aq("TeamIndicator.Position") == "Left" then
	                table.insert(a6, bb)
	            else
	                table.insert(a7, bb)
	            end
	        end
	    end

	    local a8 = false
	    if a5 and aq("FriendlyIndicator.Enabled") then
	        if aq("FriendlyIndicator.CheckTeam") and a5:GetAttribute("Team") ~= nil and a5:GetAttribute("Team") == j:GetAttribute("Team") then
	            a8 = true
	        end
	        if not a8 and aq("FriendlyIndicator.CheckFriends") then
	            local a9, ba = pcall(function()
	                return j:IsFriendsWith(a5.UserId)
	            end)
	            if a9 and ba then
	                a8 = true
	            end
	        end
	    end

	    if a8 then
	        local a9 = string.format('<font color="%s">%s</font>', J(aq("FriendlyIndicator.Color")),
	            aq("FriendlyIndicator.Text"))
	        if aq("FriendlyIndicator.Position") == "Left" then
	            table.insert(a6, a9)
	        else
	            table.insert(a7, a9)
	        end
	    end

	    local a9 = ak
	    if #a6 > 0 then
	        a9 = table.concat(a6, " ") .. " " .. a9
	    end
	    if #a7 > 0 then
	        a9 = a9 .. " " .. table.concat(a7, " ")
	    end

	    if aq("Names") then
	        ah.Text.Text = a9
	        ah.Text.Position = UDim2.new(0, aH - 50, 0, a4)
	        ah.Text.Visible = true
	    else
	        ah.Text.Visible = false
	    end

	    local ba = aq("Distance.Gap") or 0
	    local bb = aM + aK + ba + aS
	    if aq("Distance.Enabled") then
	        ah.DistanceText.Visible = true
	        ah.DistanceText.Position = UDim2.new(0, aH - 50, 0, bb)

	        local bc = aq("Distance.Unit")
	        local bd = al
	        if bc == "Meters" then
	            bd = math.floor(al / aq("Distance.StudsPerMeter"))
	        else
	            bd = math.floor(al)
	        end
	        ah.DistanceText.Text = bd .. aq("Distance.Ending")
	        bb = bb + (aq("Distance.TextSize") or aB) + (aq("Weapon.Gap") or 0)
	    else
	        ah.DistanceText.Visible = false
	    end

	    
	    if aq("Weapon.Enabled") then
	        local bc = nil

	        bc = v:get_weapon(_.owner.value)

	        
	        if (not bc or bc == "" or bc == "nil" or bc == "None") and aq("Weapon.UseToolFallback") then
	            local bd = am:FindFirstChildWhichIsA("Tool")
	            if bd then bc = bd.Name end
	        end

	        
	        if not bc or bc == "" or bc == "nil" then
	            bc = "None"
	        end

	        ah.WeaponText.Visible = true
	        ah.WeaponText.Text = bc
	        ah.WeaponText.Position = UDim2.new(0, aH - 50, 0, bb)
	    else
	        ah.WeaponText.Visible = false
	    end

	    
	    if aq("HealthBar.Enabled") and am:IsA("Model") then
	        
	        local bc = aq("HealthBar.Position")
	        local bd = (bc == "Top" or bc == "Bottom")
	        local be = aq("HealthBar.Width")
	        local bf = aq("HealthBar.SideGap")
	        local bg = aq("HealthBar.TextFollowBar")

	        local bh = aq("HealthBar.Outline.Style")
	        
	        if aq("HealthBar.Outline.Enabled") == false then bh = "None" end
	        ah.HealthBarOutline.Visible = bh ~= "None"
	        ah.HealthBarOutline.BackgroundTransparency = 0
	        ah.HealthBarOutline.BackgroundColor3 = aq("HealthBar.Outline.Color")
	        local bi

	        if bd then
	            bi = math.floor((aJ + 1) * aP)
	            ah.HealthBarOutline.Size = UDim2.new(0, aJ + 3, 0, be + 2)

	            if bc == "Top" then
	                ah.HealthBarOutline.Position = UDim2.new(0, aL - 1, 0,
	                    aM - aA - bf - be - 1)
	            else 
	                ah.HealthBarOutline.Position = UDim2.new(0, aL - 1, 0, aM + aK + aA + bf)
	            end

	            ah.HealthBarContainer.Size = UDim2.new(0, bi, 0, be)
	            ah.HealthBarContainer.Position = UDim2.new(0, 1, 0, 1)

	            ah.HealthBar.Size = UDim2.new(0, aJ + 1, 0, be)
	            ah.HealthBar.Position = UDim2.new(0, 0, 0, 0)
	        else 
	            local bj = math.floor((aK + 1) * aP)
	            ah.HealthBarOutline.Size = UDim2.new(0, be + 2, 0, aK + 3)

	            if bc == "Left" then
	                ah.HealthBarOutline.Position = UDim2.new(0,
	                    aL - aA - bf - be - 1, 0, aM - 1)
	            else 
	                ah.HealthBarOutline.Position = UDim2.new(0, aL + aJ + aA + bf, 0, aM - 1)
	            end

	            ah.HealthBarContainer.Size = UDim2.new(0, be, 0, bj)
	            ah.HealthBarContainer.Position = UDim2.new(0, 1, 0, (aK + 1) - bj + 1)

	            ah.HealthBar.Size = UDim2.new(0, be, 0, aK + 1)
	            ah.HealthBar.Position = UDim2.new(0, 0, 0, -(aK + 1 - bj))
	        end

	        
	        local bj = aq("HealthBar.Gradient.Enabled")
	        local bk = aq("HealthBar.ShowText")
	        if aq("HealthBar.HideWhenFullHP") and aN >= aO then
	            bk = false
	        end
	        local bl = bk and aq("HealthBar.FollowGradientColorText")
	        local bm = Color3.fromHSV(aP * 0.3, 1, 1)

	        if bj and not bd then
	            ah.HealthGradient.Rotation = 90
	            ah.HealthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

	            if bl then
	                if aP > 0.5 then
	                    local bn = (1 - aP) * 2
	                    bm = aq("HealthBar.Gradient.Color1"):Lerp(aq("HealthBar.Gradient.Color2"), bn)
	                else
	                    local bn = (0.5 - aP) * 2
	                    bm = aq("HealthBar.Gradient.Color2"):Lerp(aq("HealthBar.Gradient.Color3"), bn)
	                end
	            end
	        else
	            ah.HealthBar.BackgroundColor3 = bm
	        end

	        if bk then
	            ah.HealthText.Visible = true
	            ah.HealthText.Text = math.floor(aN)
	            ah.HealthText.TextSize = aq("HealthBar.TextSize")
	            local bn = aq("HealthBar.Font")
	            local bo = K[bn] or Enum.Font.Code
	            ah.HealthText.Font = bo
	            if M.Loaded[bn] then
	                ah.HealthText.FontFace = M.Loaded[bn]
	            end
	            ah.HealthText.TextColor3 = bl and bm or aq("TextColor")
	            aw(ah.HealthText, bh, ay)

	            if bd then
	                bi = math.floor((aJ + 1) * aP)
	                local bp = aL + bi - 1
	                local bq = ah.HealthBarOutline.Position.Y.Offset

	                ah.HealthText.TextXAlignment = Enum.TextXAlignment.Center
	                ah.HealthText.Size = UDim2.new(0, 0, 0, 0)

	                if bg then
	                    ah.HealthText.Position = UDim2.new(0, bp, 0, bq + (be / 2) + 1)
	                else
	                    ah.HealthText.Position = UDim2.new(0, aL + aJ, 0, bq + (be / 2) + 1)
	                end
	            else
	                local bp = math.floor((aK + 1) * aP)
	                local bq = ah.HealthBarOutline.Position.X.Offset
	                local br = aM + (aK + 1) - bp

	                ah.HealthText.TextXAlignment = bc == "Left" and Enum.TextXAlignment.Right or
	                    Enum.TextXAlignment.Left
	                ah.HealthText.Size = UDim2.new(0, 0, 0, 0)

	                local bs = bc == "Left" and (bq - 2) or (bq + be + 4)
	                local bt = bg and br or aM
	                ah.HealthText.Position = UDim2.new(0, bs, 0, bt)
	            end
	        else
	            ah.HealthText.Visible = false
	        end
	    else
	        ah.HealthBarOutline.Visible = false
	        ah.HealthText.Visible = false
	    end

	    
	    for bc, bd in ipairs(ah.FlagLabels) do bd.Visible = false end
	    local bc = am:FindFirstChild("Humanoid")
	    if aq("Flags.Enabled") and am:IsA("Model") and not X and bc then
	            local bd = bc:GetState()
	            local be = bc.MoveDirection.Magnitude > 0
	            local bf = (bd == Enum.HumanoidStateType.Jumping or bd == Enum.HumanoidStateType.FallingDown or bd == Enum.HumanoidStateType.Freefall)
	            local bg = bd == Enum.HumanoidStateType.Swimming
	            local bh = aq("Flags.Options.Moving")
	            local bi = aq("Flags.Options.Jumping")
	            local bj = aq("Flags.Options.Swimming")
	            local bk = aq("Flags.Options.Idle")
	            local bl = aq("Flags.Colors.Moving")
	            local bm = aq("Flags.Colors.Jumping")
	            local bn = aq("Flags.Colors.Swimming")
	            local bo = aq("Flags.Colors.Idle")
	            local bp = aq("Flags.Font")
	            local bq = aq("Flags.TextSize")
	            local br = aq("Flags.TextGap")
	            local bs = aq("Flags.Gap") or 2
	            local bt = aq("Flags.SideGap")
	            local bu = aq("Flags.Position")
	            local bv = {}

	            if be and bf and bh and bi then
	                table.insert(bv, { text = "Moving & Jumping", color = bl })
	            elseif bf and bi then
	                table.insert(bv, { text = "Jumping", color = bm })
	            elseif be and bh then
	                table.insert(bv, { text = "Moving", color = bl })
	            elseif bg and bj then
	                table.insert(bv, { text = "Swimming", color = bn })
	            elseif bk then
	                table.insert(bv, { text = "Idle", color = bo })
	            end

	            local bw = bu == "Right"
	            local bx = bw and (aL + aJ + bt + aU) or
	                (aL - 100 - bt - aT)
	            local by = aM - bs

	            if bp == "Smallest Pixel-7" then
	                by = by - 3
	            end

	            local bz = K[bp] or Enum.Font.Code
	            local bA = M.Loaded[bp]
	            local bB = aq("Flags.OutlineStyle") or ax

	            for bC, bD in ipairs(bv) do
	                local bE = ah.FlagLabels[bC]
	                if bE then
	                    bE.Visible = true
	                    bE.Text = bD.text
	                    bE.TextColor3 = bD.color
	                    bE.Font = bz
	                    if bA then
	                        bE.FontFace = bA
	                    end
	                    bE.TextSize = bq
	                    bE.TextXAlignment = bw and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right
	                    bE.Position = UDim2.new(0, bx, 0,
	                        by + (bC - 1) * (bq + br))
	                    aw(bE, bB, ay)
	                end
	        end
	    end

	    
	    if aq("Skeleton.Enabled") and am:IsA("Model") then
	        local bd = aq("Skeleton.Outline")
	        local be = aq("Skeleton.Color")
	        local bf = aq("Skeleton.OutlineColor")

	        local bg = {}
	        for bh, bi in ipairs(O) do
	            for bj, bk in ipairs(bi) do
	                if bg[bk] == nil then
	                    local bl = P(am, bk)
	                    local bm, bn = bl and l(k, bl)
	                    bg[bk] = (bl and bn) and Vector2.new(bm.X, bm.Y) or false
	                end
	            end
	        end

	        for bh, bi in ipairs(O) do
	            local bj = bg[bi[1] ]
	            local bk = bg[bi[2] ]

	            if bj and bk then
	                if bd then
	                    D(ah.BoneOutlines[bh], bj, bk, 3, bf)
	                else
	                    ah.BoneOutlines[bh].Visible = false
	                end

	                D(ah.Bones[bh], bj, bk, 1, be)
	            else
	                ah.Bones[bh].Visible = false
	                ah.BoneOutlines[bh].Visible = false
	            end
	        end
	    else
	        if ah.Bones then
	            for bd, be in ipairs(ah.Bones) do be.Visible = false end
	            for bd, be in ipairs(ah.BoneOutlines) do be.Visible = false end
	        end
	    end
	end
	

	
	
	local ai = setmetatable({}, { __mode = "k" })
	local aj = setmetatable({}, { __mode = "k" })
	local function ak(al, am)
	    LPH_ATTRIBUTES(VM(NONE))
	    local an = os.clock()
	    local ao = ai[al]
	    if ao and an - aj[al] < 0.5 then
	        return ao
	    end
	    ao = ao or {}
	    table.clear(ao)
	    if al:IsA("Model") then
	        for ap, aq in al:GetChildren() do
	            if aq:IsA("BasePart") and (am or (aq.Name ~= "HumanoidRootPart" and aq.Transparency ~= 1)) then
	                ao[#ao + 1] = aq
	            end
	        end
	    else
	        ao[1] = al
	    end
	    ai[al] = ao
	    aj[al] = an
	    return ao
	end

	local al = math.huge
	local am = Vector2.new
	local an = Vector3.new
	local ao = function(ao)
	    LPH_ATTRIBUTES(VM(NONE))
	    local ap = k
	    local aq = ao:IsA("Model")
	    local ar
	    if aq then
	        ar = ao:FindFirstChild("HumanoidRootPart") or ao:FindFirstChild("Torso") or
	            ao:FindFirstChild("torso") or ao:FindFirstChild("head") or
	            ao.PrimaryPart or ao:FindFirstChildWhichIsA("BasePart")
	    elseif ao:IsA("BasePart") then
	        ar = ao
	    end
	    if not ar then
	        return false, nil, nil
	    end
	    local as, at = l(ap, ar.Position)
	    if not at then
	        return false, nil, nil
	    end

	    local au, av, aw, ax = al, al, -al, -al
	    if not E.DynamicBoxes then
	        local ay = aq and ao:FindFirstChild("Humanoid")
	        if ay then
	            local az = ay.RigType == Enum.HumanoidRigType.R6
	            local aA = ar.Position
	            local aB = l(ap, aA + an(0, az and 2.8 or 3.0, 0))
	            local aC = l(ap, aA - an(0, az and 3.0 or 3.5, 0))
	            local aD = math.abs(aB.Y - aC.Y)
	            return true, am(as.X, (aB.Y + aC.Y) * 0.5), am(aD * 0.65, aD)
	        end
	        local az, aA
	        if aq then
	            az, aA = ao:GetBoundingBox()
	        else
	            az, aA = ao.CFrame, ao.Size
	        end
	        local aB, aC, aD = aA.X * 0.5, aA.Y * 0.5, aA.Z * 0.5
	        for aE = -1, 1, 2 do
	            for aF = -1, 1, 2 do
	                for aG = -1, 1, 2 do
	                    local aH = l(ap, az * an(aB * aE, aC * aF, aD * aG))
	                    local aI, aJ = aH.X, aH.Y
	                    if aI < au then au = aI end
	                    if aI > aw then aw = aI end
	                    if aJ < av then av = aJ end
	                    if aJ > ax then ax = aJ end
	                end
	            end
	        end
	        return true, am((au + aw) * 0.5, (av + ax) * 0.5), am(aw - au, ax - av)
	    end

	    local ay = ak(ao, E.DynamicBoxesIncludeAll)
	    local az = #ay
	    if az == 0 then
	        return false, nil, nil
	    end
	    local aA = E.DynamicBoxesCheap
	    for aB = 1, az do
	        local aC = ay[aB]
	        local aD = aC.CFrame
	        local aE = aC.Size
	        local aF, aG, aH = aE.X * 0.5, aE.Y * 0.5, aE.Z * 0.5
	        if aA then
	            
	            local aI = aD.Position
	            local aJ = aD * an(aF, aG, aH)
	            local aK = l(ap, aJ)
	            local aL = l(ap, aI + aI - aJ)
	            local aM, aN, aO, aP = aK.X, aK.Y, aL.X, aL.Y
	            if aM < au then au = aM end
	            if aM > aw then aw = aM end
	            if aN < av then av = aN end
	            if aN > ax then ax = aN end
	            if aO < au then au = aO end
	            if aO > aw then aw = aO end
	            if aP < av then av = aP end
	            if aP > ax then ax = aP end
	        else
	            for aI = -1, 1, 2 do
	                for aJ = -1, 1, 2 do
	                    for aK = -1, 1, 2 do
	                        local aL = l(ap, aD * an(aF * aI, aG * aJ, aH * aK))
	                        local aM, aN = aL.X, aL.Y
	                        if aM < au then au = aM end
	                        if aM > aw then aw = aM end
	                        if aN < av then av = aN end
	                        if aN > ax then ax = aN end
	                    end
	                end
	            end
	        end
	    end
	    return true, am((au + aw) * 0.5, (av + ax) * 0.5), am(aw - au, ax - av)
	end
	

	
	local function ap(aq, ar)
	    if type(ar) ~= "table" or #ar == 0 then return true end
	    if #ar == 1 and ar[1] == "" then return true end
	    for as, at in ipairs(ar) do
	        local au = false
	        for av, aw in ipairs(aq:GetChildren()) do
	            if aw.Name == at then
	                au = true
	                break
	            end
	        end
	        if not au then return false end
	    end
	    return true
	end

	local function aq(ar, as)
	    if type(as) ~= "table" or #as == 0 then return true end
	    if #as == 1 and as[1] == "" then return true end
	    for at, au in ipairs(as) do
	        if ar.Name == au then
	            return true
	        end
	    end
	    return false
	end

	local function ar(as, at)
	    if not at or #at == 0 then return false end
	    local au = as
	    while au and au ~= game do
	        for av, aw in ipairs(at) do
	            if aw ~= "" and au.Name:find(aw) then
	                return true
	            end
	        end
	        au = au.Parent
	    end
	    return false
	end

	local as = function()
	    LPH_ATTRIBUTES(VM(NONE))
	    local as = {}

	    

	    











for at, au in ipairs(n:GetPlayers()) do
	        if not E.LocalPlayer and au == j then continue end
	        local av, aw = v:get_character(au)
	        local ax = v:get_viewmodel(au)

	        local ay = ax or aw
	        if ay and ay.Parent then
	            local az = v:get_health(au)
	            if type(az) ~= "number" then
	                az = 100
	            end
	            if az > 0 then
	                if not E.Filter or E.Filter(ay, au) then
	                    as[ay] = {
	                        name = au.Name,
	                        Cheap = false,
	                        NonHuman = false,
	                        NoStatus = false,
	                        Actor = av,
	                        Config = {}
	                    }
	                end
	            end
	        end
	    end

	    for at, au in pairs(E.Directories) do
	        local av = nil
	        if type(au) == "table" and au.DisplayName and au.DisplayName ~= "" then
	            av = au.DisplayName
	        elseif type(at) == "string" then
	            av = at
	        end

	        if type(au) == "string" then
	            local aw = U(au)
	            if aw then
	                as[aw] = { name = av or aw.Name, Cheap = false }
	            end
	        elseif type(au) == "table" then
	            local aw = au.Path
	            if not aw then continue end
	            local ax = U(aw)
	            if not ax then continue end

	            local ay = au.Cheap or false
	            local az = au.NonHuman or false
	            local aA = au.NoStatus or false
	            local aB = au.Config or {}
	            local aC = au.Recursive or false

	            if au.Multiple then
	                local aD = aC and ax:GetDescendants() or ax:GetChildren()
	                for aE, aF in ipairs(aD) do
	                    if (aF:IsA("Model") or aF:IsA("BasePart")) then
	                        
	                        local aG = false
	                        local aH = aF.Parent
	                        while aH and aH ~= ax and aH ~= game do
	                            if as[aH] then
	                                aG = true
	                                break
	                            end
	                            aH = aH.Parent
	                        end

	                        if not aG and aq(aF, au.Names) and ap(aF, au.Contains) and not ar(aF, au.BlockNames) then
	                            local aI = aF:FindFirstChild("Humanoid")
	                            if az or (not aI or aI.Health > 0) then
	                                local aJ = (av and av ~= "") and av or aF.Name
	                                as[aF] = {
	                                    name = aJ,
	                                    Cheap = ay,
	                                    NonHuman = az,
	                                    NoStatus = aA,
	                                    Config = aB
	                                }
	                            end
	                        end
	                    end
	                end
	            else
	                if aq(ax, au.Names) and ap(ax, au.Contains) and not ar(ax, au.BlockNames) then
	                    local aD = ax:FindFirstChild("Humanoid")
	                    if az or (not aD or aD.Health > 0) then
	                        local aE = (av and av ~= "") and av or ax.Name
	                        as[ax] = {
	                            name = aE,
	                            Cheap = ay,
	                            NonHuman = az,
	                            NoStatus = aA,
	                            Config = aB
	                        }
	                    end
	                end
	            end
	        end
	    end

	    for at, au in pairs(as) do
	        if not T[at] then
	            T[at] = {
	                espObj = aa(au.name),
	                name = au.name,
	                Cheap = au.Cheap,
	                NonHuman = au.NonHuman,
	                NoStatus = au.NoStatus,
	                Actor = au.Actor,
	                Config = au.Config
	            }
	        else
	            T[at].name = au.name
	            T[at].Cheap = au.Cheap
	            T[at].NonHuman = au.NonHuman
	            T[at].NoStatus = au.NoStatus
	            T[at].Actor = au.Actor
	            T[at].Config = au.Config
	        end
	    end

	    for at, au in pairs(T) do
	        if not as[at] or not at.Parent then
	            au.espObj:Destroy()
	            T[at] = nil
	        end
	    end
	end

	local at = 0
	local au = 0
	local av = 0
	local aw = false
	local function ax()
	    LPH_ATTRIBUTES(VM(NONE))
	    if not E.Enabled then
	        
	        if aw then
	            return
	        end
	        aw = true
	        for ay, az in pairs(T) do
	            if az.espObj then
	                local aA = F(az.Config or {})
	                aA.Chams = aA.Chams or {}
	                aA.Chams.Enabled = false
	                ah(az.espObj, nil, nil, "", 0, ay, az.Cheap, az.NonHuman, az.NoStatus, aA,
	                    false, az.Actor)
	            end
	        end
	        return
	    end

	    aw = false
	    k = h.CurrentCamera
	    local ay = tick()

	    if N and ay - av > 5 then
	        av = ay
	        S()
	    end

	    if E.LimitFPS and E.LimitFPS > 0 then
	        if ay - au < (1 / E.LimitFPS) then return end
	        au = ay
	    end

	    if ay - at > 1 then
	        at = ay
	        as()
	    end

	    for az, aA in pairs(T) do
	        if not az or not az.Parent then
	            aA.espObj:Destroy()
	            T[az] = nil
	            continue
	        end

	        local aB = aA.Actor and aA.Actor.owner and v:get_health(aA.Actor.owner.value)
	        if type(aB) == "number" and aB <= 0 then
	            aA.espObj:Destroy()
	            T[az] = nil
	            continue
	        end

	        local aC = az:IsA("Model") and
	            (az.PrimaryPart or az:FindFirstChild("HumanoidRootPart") or az:FindFirstChildWhichIsA("BasePart")) or
	            (az:IsA("BasePart") and az)

	        if aC then
	            local aD, aE, aF = ao(az)
	            local aG = (k.CFrame.Position - aC.Position).Magnitude
	            ah(aA.espObj, aE, aF, aA.name, aG, az, aA.Cheap, aA.NonHuman,
	                aA.NoStatus, aA.Config, aD, aA.Actor)
	        else
	            ah(aA.espObj, nil, nil, aA.name, 0, az, aA.Cheap, aA.NonHuman, aA.NoStatus, aA
	                .Config, false, aA.Actor)
	        end
	    end
	end

	function o:Unload()
	    for ay, az in pairs(T) do
	        if az.espObj then
	            az.espObj:Destroy()
	        end
	        T[ay] = nil
	    end

	    if s then
	        s:Disconnect()
	        s = nil
	    end
	    if t then
	        t:Disconnect()
	        t = nil
	    end
	    if getgenv().SensoryESP_Loop then
	        getgenv().SensoryESP_Loop:Disconnect()
	        getgenv().SensoryESP_Loop = nil
	    end
	    if r then
	        r:Destroy()
	        r = nil
	    end
	    if p then
	        p:Destroy()
	        p = nil
	    end
	    if q then
	        q:Destroy()
	        q = nil
	    end

	    z(h)
	    for ay, az in ipairs(n:GetPlayers()) do
	        A(v:get_viewmodel(az))
	    end

	    getgenv().SensoryESP_UI = nil
	end

	function o:Load(ay)
	    self:Unload()

	    E = G(F(H), ay or {})
	    B()
	    u = i:GenerateGUID(false)
	    at = 0
	    au = 0

	    s = f.PlayerRemoving:Connect(function(az)
	        for aA, aB in pairs(T) do
	            if v:get_character(az) == aA then
	                aB.espObj:Destroy()
	                T[aA] = nil
	            end
	        end
	    end)

	    t = d.InputBegan:Connect(function(az, aA)
	        if not aA and E.Keybind.Enabled and az.KeyCode == E.Keybind.Key then
	            E.Enabled = not E.Enabled
	        end
	    end)

	    getgenv().SensoryESP_Loop = e.RenderStepped:Connect(ax)
	    o._RuntimeStep = ax
	    as()
	    return self
	end

	function o:GetConfig()
	    return E
	end

	getgenv().SensoryESP_Unload = function()
	    o:Unload()
	end

	return o
end
end function a.e()local aa=a.cache.e if not aa then aa={c=b()}a.cache.e=aa end return aa.c end end do local function aa()
local function ab(ac)
	local ag = {}

	function ag.build(ah)
		local ai = ah.Library
		local aj = ai:CreateWindow({
			Title = ac.title,
			Center = true,
			AutoShow = true,
			TabPadding = 8,
			MenuFadeTime = 0.2,
		})
		ah.Window = aj
		ah.Tabs = {}
		for ak, al in ac.tabs do
			ah.Tabs[al] = aj:AddTab(al)
		end
	end

	function ag.finish(ah)
		local ai = getgenv().Toggles
		local aj = getgenv().Options
		local ak = ah.Tabs
		local al = ah.Library
		local am = ah.ThemeManager
		local an = ah.SaveManager
		local ao = ak.Settings or ak["UI Settings"]
		if not ao then
			return
		end
		local ap = ac.keybind or "menubind"
		local aq = ao:AddLeftGroupbox("Menu")
		aq:AddButton({
			Text = "Unload",
			Func = function()
				al:Unload()
			end,
		})
		aq:AddLabel("Menu keybind"):AddKeyPicker(ap, {
			Default = ac.keybindDefault or "RightShift",
			NoUI = true,
			Text = "Menu keybind",
		})
		al.ToggleKeybind = aj[ap]
		if not ac.hideKeybindList then
			aq
				:AddToggle("ShowKeybindList", { Text = "Show Keybind List", Default = true })
				:OnChanged(function(ar)
					if al and al.KeybindFrame then
						al.KeybindFrame.Visible = ar
					end
				end)
		end
		am:SetLibrary(al)
		an:SetLibrary(al)
		if an.Parser and an.Parser.Slider then
			local ar = an.Parser.Slider.Load
			an.Parser.Slider.Load = function(as, at)
				if aj[as] then
					aj[as]:SetValue(tonumber(at.value) or at.value)
				elseif ar then
					ar(as, at)
				end
			end
		end
		an:IgnoreThemeSettings()
		an:SetIgnoreIndexes(ac.ignore or { ap })
		am:SetFolder("VaultCC")
		an:SetFolder(ac.folder)
		an:BuildConfigSection(ao)
		local ar = game:GetService("HttpService")
		local as
		local function at(au)
			return au == "VaultConfigCode" or au:find("SaveManager_") or au:find("ThemeManager_")
		end
		local function au(av)
			if av and av.Changed then
				pcall(av.Changed, av.Value)
			end
		end
		local function av(aw, ax)
			if not aw then
				return false
			end
			local ay = false
			if aw.SetValue then
				ay = pcall(function()
					aw:SetValue(ax)
				end)
			end
			if not ay then
				aw.Value = ax
			end
			au(aw)
			return true
		end
		local function aw(ax)
			local ay = 0
			if type(ax) ~= "table" then
				return 0
			end
			for az, aA in ax do
				if type(az) ~= "string" or at(az) then
					continue
				end
				local aB = ai[az]
				if aB and type(aA) == "table" and aA.boolean ~= nil then
					if av(aB, aA.boolean == true) then
						ay += 1
					end
					continue
				end
				local aC = aj[az]
				if not aC then
					continue
				end
				if aC.Type == "ColorPicker" and type(aA) == "table" and type(aA.color) == "string" then
					local aD, aE = pcall(Color3.fromHex, aA.color)
					if aD then
						if aC.SetValueRGB then
							pcall(function()
								aC:SetValueRGB(aE, aA.transparency)
							end)
						end
						aC.Value = aE
						au(aC)
						ay += 1
					end
				elseif aC.Type == "KeyPicker" and type(aA) == "table" then
					if av(aC, { aA.keycode or aA.key or aC.Value, aC.Mode }) then
						ay += 1
					end
				elseif aC.Type == "Slider" then
					if av(aC, tonumber(aA) or aA) then
						ay += 1
					end
				elseif av(aC, aA) then
					ay += 1
				end
			end
			return ay
		end
		local function ax(ay)
			if type(ay) ~= "table" or type(ay.idx) ~= "string" or at(ay.idx) then
				return false
			end
			local az = an.Parser and an.Parser[ay.type]
			if az and az.Load then
				local aA = pcall(function()
					az.Load(ay.idx, ay)
				end)
				if aA then
					return true
				end
			end
			if ay.type == "Toggle" then
				return av(ai[ay.idx], ay.value == true)
			end
			if ay.type == "Slider" then
				return av(aj[ay.idx], tonumber(ay.value) or ay.value)
			end
			if ay.type == "Dropdown" then
				return av(aj[ay.idx], ay.value)
			end
			if ay.type == "ColorPicker" then
				local aA = aj[ay.idx]
				local aB, aC = pcall(Color3.fromHex, ay.value)
				if not aB or not aA then
					return false
				end
				if aA.SetValueRGB then
					pcall(function()
						aA:SetValueRGB(aC, ay.transparency)
					end)
				end
				aA.Value = aC
				au(aA)
				return true
			end
			if ay.type == "KeyPicker" then
				return av(aj[ay.idx], { ay.key, ay.mode })
			end
			if ay.type == "Input" then
				return av(aj[ay.idx], ay.text)
			end
			return false
		end
		local function ay()
			local az = {}
			for aA, aB in ai do
				if not at(aA) then
					az[#az + 1] = { type = "Toggle", idx = aA, value = aB.Value == true }
				end
			end
			for aA, aB in aj do
				if at(aA) then
					continue
				end
				if aB.Type == "Slider" then
					az[#az + 1] = { type = "Slider", idx = aA, value = tostring(aB.Value) }
				elseif aB.Type == "Dropdown" then
					az[#az + 1] = { type = "Dropdown", idx = aA, value = aB.Value, mutli = aB.Multi }
				elseif aB.Type == "ColorPicker" then
					local aC = aB.Value
					az[#az + 1] = {
						type = "ColorPicker",
						idx = aA,
						value = typeof(aC) == "Color3" and aC:ToHex() or tostring(aC),
						transparency = aB.Transparency,
					}
				elseif aB.Type == "KeyPicker" then
					az[#az + 1] = { type = "KeyPicker", idx = aA, mode = aB.Mode, key = aB.Value }
				elseif aB.Type == "Input" then
					az[#az + 1] = { type = "Input", idx = aA, text = tostring(aB.Value or "") }
				end
			end
			return ar:JSONEncode({ vault = 1, objects = az })
		end
		local function az(aA)
			if type(aA) ~= "string" then
				return false, "empty"
			end
			aA = aA:match("^%s*(.-)%s*$") or ""
			if aA == "" then
				return false, "empty"
			end
			local aB, aC = pcall(function()
				return ar:JSONDecode(aA)
			end)
			if not aB or type(aC) ~= "table" then
				return false, "invalid json"
			end
			local aD = 0
			if type(aC.flagValues) == "table" then
				aD = aw(aC.flagValues)
			end
			local aE = aC.objects or aC
			if aD == 0 and type(aE) == "table" then
				for aF, aG in aE do
					if ax(aG) then
						aD += 1
					end
				end
			end
			if aD == 0 then
				return false, "no settings in that code"
			end
			return true, aD
		end
		local aA = 0
		local function aB()
			local aC = os.clock()
			if aC - aA < 0.35 then
				return false
			end
			aA = aC
			return true
		end
		local function aC()
			if not aB() then
				return
			end
			local aD = ay()
			if as then
				as.Text = aD
			end
			if aj.VaultConfigCode and aj.VaultConfigCode.SetValue then
				pcall(function()
					aj.VaultConfigCode:SetValue(aD)
				end)
			end
			local aE = false
			pcall(function()
				setclipboard(aD)
				aE = true
			end)
			al:Notify(aE and "Config copied" or "Config ready, copy the box")
		end
		local function aD(aE)
			if not aB() then
				return
			end
			if type(aE) ~= "string" or aE:match("^%s*(.-)%s*$") == "" then
				local aF = ""
				pcall(function()
					aF = getclipboard()
				end)
				if aF == "" then
					pcall(function()
						aF = clipboard()
					end)
				end
				aE = aF
			end
			local aF, aG = az(aE)
			if not aF then
				al:Notify("Import failed: " .. tostring(aG))
				return
			end
			al:Notify("Imported " .. tostring(aG) .. " settings")
		end
		local aE = ao:AddLeftGroupbox("Import / Export")
		aE:AddInput("VaultConfigCode", {
			Text = "Config code",
			Placeholder = "Paste a config here",
			PlaceholderText = "Paste a config here",
		})
		aE:AddButton({
			Text = "Export",
			Func = aC,
		})
		aE:AddButton({
			Text = "Import",
			Func = function()
				aD(aj.VaultConfigCode and aj.VaultConfigCode.Value or "")
			end,
		})
		pcall(function()
			an:SetIgnoreIndexes({ "VaultConfigCode" })
		end)
		if al.IsMobile then
			local aF = game:GetService("GuiService")
			local aG = game:GetService("UserInputService")
			local aH
			local aI = {}
			local function aJ(aK)
				local aL = aK
				while aL and aL ~= game do
					if aL:IsA("GuiObject") and not aL.Visible then
						return false
					end
					aL = aL.Parent
				end
				return aK and aK.Parent ~= nil
			end
			local function aK(aL)
				local aM, aN
				for aO, aP in aI do
					if aJ(aO) then
						local aQ, aR = aO.AbsolutePosition, aO.AbsoluteSize
						if aR.X > 0 and aR.Y > 0 and aL.X >= aQ.X and aL.X <= aQ.X + aR.X and aL.Y >= aQ.Y and aL.Y <= aQ.Y + aR.Y then
							local aS = aQ + aR / 2
							local aT = (Vector2.new(aS.X, aS.Y) - aL).Magnitude
							if not aN or aT < aN then
								aM, aN = aP, aT
							end
						end
					end
				end
				return aM
			end
			local function aL(aM)
				if type(aM) ~= "string" or aM == "" or not isfolder("darius/VaultCC") then
					return nil
				end
				for aN, aO in listfiles("darius/VaultCC") do
					local aP, aQ = pcall(function()
						return ar:JSONDecode(readfile(aO))
					end)
					if aP and type(aQ) == "table" and aQ.name == aM then
						return aQ
					end
				end
				return nil
			end
			local function aM(aN)
				local aO = aL(aN)
				if not aO then
					al:Notify("Config not found")
					return
				end
				local aP = getgenv and getgenv().dariusInstance
				if aP and aO.uid and aP.SetConfiguration then
					pcall(function()
						aP:SetConfiguration(aO.uid)
					end)
				end
				aw(aO.flagValues)
				al:Notify("Loaded " .. aN)
			end
			local function aN()
				local aO = game:GetService("CoreGui")
				for aP, aQ in aO:GetDescendants() do
					if aQ:IsA("TextLabel") then
						local aR = aQ.Text:match("^Configs:%s*(.+)$")
						if aR and aR ~= "" then
							return aR
						end
					end
				end
				return nil
			end
			local function aO()
				if not aB() then
					return
				end
				local aP = aH or aN()
				if not aP or aP == "" then
					al:Notify("Select a config first")
					return
				end
				aM(aP)
			end
			if not al._vaultCfgHook then
				al._vaultCfgHook = true
				local aP
				aG.InputBegan:Connect(function(aQ)
					local aR = aQ.UserInputType
					if aR == Enum.UserInputType.Touch or aR == Enum.UserInputType.MouseButton1 then
						aP = aQ.Position
					end
				end)
				aG.InputEnded:Connect(function(aQ)
					local aR = aQ.UserInputType
					if aR ~= Enum.UserInputType.Touch and aR ~= Enum.UserInputType.MouseButton1 then
						return
					end
					if not aP or (aQ.Position - aP).Magnitude > 18 then
						return
					end
					local aS = Vector2.new(aQ.Position.X, aQ.Position.Y)
					local aT = aF:GetGuiInset()
					local aU = aK(aS) or aK(aS - aT) or aK(aS + aT)
					if aU then
						aU()
					end
				end)
			end
			local function aP(aQ, aR)
				if not aQ or aI[aQ] then
					return
				end
				aI[aQ] = aR
			end
			local function aQ()
				local aR = game:GetService("CoreGui")
				local aS = UDim2.new(1, 0, 0, 36)
				local function aT(aU)
					if aU:IsA("TextButton") and aU.Text ~= "" then
						return aU.Text
					end
					local aV
					for aW, aX in aU:GetDescendants() do
						if aX:IsA("TextLabel") then
							local aY = aX.Text
							if aY == "Load" or aY == "Save" or aY == "Create" or aY == "Delete" or aY == "Export" or aY == "Import" then
								aV = aY
							end
						end
					end
					return aV
				end
				for aU, aV in aR:GetDescendants() do
					if aV:IsA("TextLabel") and aV.Text:sub(1, 7) == "Configs" then
						local aW = aV:FindFirstAncestorWhichIsA("TextButton")
						local aX = aW and aW.Parent
						local aY = aX and aX:FindFirstChildWhichIsA("ScrollingFrame")
						if aY and not aY:GetAttribute("vaultCfgWatch") then
							aY:SetAttribute("vaultCfgWatch", true)
							local function aZ(a_)
								if not a_:IsA("TextButton") then
									return
								end
								aP(a_, function()
									aH = a_.Name
								end)
							end
							for a_, a0 in aY:GetChildren() do
								aZ(a0)
							end
							aY.ChildAdded:Connect(aZ)
						end
					end
				end
				for aU, aV in aR:GetDescendants() do
					if aV:IsA("TextLabel") and aV.Text == "Load" then
						local aW = aV:FindFirstAncestorWhichIsA("TextButton")
						local aX = aW and aW.Parent
						if aX and aX:IsA("GuiObject") then
							local aY = aX:FindFirstChildOfClass("UIListLayout")
							if aY then
								aY.FillDirection = Enum.FillDirection.Vertical
								aY.HorizontalAlignment = Enum.HorizontalAlignment.Center
								aY.Padding = UDim.new(0, 4)
							end
							aX.AutomaticSize = Enum.AutomaticSize.Y
							aX.Size = UDim2.new(1, 0, 0, 0)
							if not aX:GetAttribute("vaultSizePin") then
								aX:SetAttribute("vaultSizePin", true)
								aX:GetPropertyChangedSignal("Size"):Connect(function()
									if aX.Parent and aX.Size ~= UDim2.new(1, 0, 0, 0) then
										aX.Size = UDim2.new(1, 0, 0, 0)
									end
								end)
								aX:GetPropertyChangedSignal("AutomaticSize"):Connect(function()
									if aX.Parent and aX.AutomaticSize ~= Enum.AutomaticSize.Y then
										aX.AutomaticSize = Enum.AutomaticSize.Y
									end
								end)
							end
							local aZ
							for a_, a0 in aX:GetChildren() do
								if a0:IsA("GuiButton") then
									a0.Size = aS
									if aT(a0) == "Save" then
										aZ = a0
									end
									if not a0:GetAttribute("vaultPinned") then
										a0:SetAttribute("vaultPinned", true)
										a0:GetPropertyChangedSignal("Size"):Connect(function()
											if a0.Parent and a0.Size ~= aS then
												a0.Size = aS
											end
										end)
									end
								end
							end
							aP(aW, aO)
							if aZ and aW and not aW:GetAttribute("vaultLoadGuard") then
								aW:SetAttribute("vaultLoadGuard", true)
								aW.InputBegan:Connect(function(a_)
									local a0 = a_.UserInputType
									if a0 ~= Enum.UserInputType.Touch and a0 ~= Enum.UserInputType.MouseButton1 then
										return
									end
									aZ.Active = false
									task.delay(0.4, function()
										if aZ.Parent then
											aZ.Active = true
										end
									end)
								end)
							end
							if not aX:GetAttribute("vaultShare") then
								aX:SetAttribute("vaultShare", true)
								as = Instance.new("TextBox")
								as.Name = "VaultConfigCode"
								as.Size = UDim2.new(1, 0, 0, 72)
								as.BackgroundColor3 = aW.BackgroundColor3
								as.TextColor3 = Color3.new(1, 1, 1)
								as.PlaceholderText = "Paste config code"
								as.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
								as.Text = ""
								as.ClearTextOnFocus = false
								as.TextWrapped = true
								as.MultiLine = true
								as.TextXAlignment = Enum.TextXAlignment.Left
								as.TextYAlignment = Enum.TextYAlignment.Top
								as.Font = Enum.Font.Gotham
								as.TextSize = 12
								as.Parent = aX
								local a_ = Instance.new("UICorner")
								a_.CornerRadius = UDim.new(0, 6)
								a_.Parent = as
								local a0 = Instance.new("UIPadding")
								a0.PaddingTop = UDim.new(0, 6)
								a0.PaddingLeft = UDim.new(0, 8)
								a0.PaddingRight = UDim.new(0, 8)
								a0.Parent = as
								local function a1(a2, a3)
									local a4 = Instance.new("TextButton")
									a4.Name = a2
									a4.Size = aS
									a4.BackgroundColor3 = aW.BackgroundColor3
									a4.Text = a2
									a4.TextColor3 = Color3.new(1, 1, 1)
									a4.Font = Enum.Font.GothamBold
									a4.TextSize = 14
									a4.AutoButtonColor = true
									a4.Parent = aX
									local a5 = Instance.new("UICorner")
									a5.CornerRadius = UDim.new(0, 6)
									a5.Parent = a4
									a4.Activated:Connect(a3)
									aP(a4, a3)
									return a4
								end
								a1("Export", aC)
								a1("Import", function()
									aD(as.Text)
								end)
							end
						end
						break
					end
				end
			end
			task.defer(aQ)
			task.delay(0.6, aQ)
			task.delay(1.5, aQ)
		end
		am:ApplyToTab(ao)
		if ac.beforeLoad then
			ac.beforeLoad(ah, aq)
		end
		an:LoadAutoloadConfig()
		if ac.afterLoad then
			ac.afterLoad(ah)
		end
		if al.KeybindFrame and not ac.hideKeybindList then
			al.KeybindFrame.Visible = ai.ShowKeybindList == nil or ai.ShowKeybindList.Value ~= false
		end
	end

	function ag.step()
	end

	function ag.unload()
	end

	return ag
end

return {
	create = ab,
}
end function a.f()local ab=a.cache.f if not ab then ab={c=aa()}a.cache.f=ab end return ab.c end end do local function aa()
local ab = a.f()

return ab.create({
	title = "Operation One - vault.cc",
	folder = "VaultCC/op1_full",
	tabs = { "Combat", "ESP", "Visuals", "Misc", "Settings" },
	ignore = { "menubind", "recoilmult" },
})
end function a.g()local ab=a.cache.g if not ab then ab={c=aa()}a.cache.g=ab end return ab.c end end do local function aa()
local ab = debug.profilebegin or function() end
local ac = debug.profileend or function() end

local function ag(ah, ai, aj)
	return function(...)
		ab(ah)
		if aj == 2 then
			local ak, al = ai(...)
			ac()
			return ak, al
		end
		local ak = ai(...)
		ac()
		return ak
	end
end

return {
	begin = ab,
	stop = ac,
	wrap = ag,
}
end function a.h()local ab=a.cache.h if not ab then ab={c=aa()}a.cache.h=ab end return ab.c end end do local function aa()
local ab = workspace.Raycast
local ac = a.h()

local ag = {
	Vector3.new(1, 0, 0),
	Vector3.new(-1, 0, 0),
	Vector3.new(0, 0, 1),
	Vector3.new(0, 0, -1),
	Vector3.new(0, 1, 0),
	Vector3.new(0, -1, 0),
}
local ah = {
	Vector3.new(0.5, 0, 0),
	Vector3.new(-0.5, 0, 0),
	Vector3.new(0, 0, 0.5),
	Vector3.new(0, 0, -0.5),
	Vector3.new(0, 0.5, 0),
	Vector3.new(0, -0.5, 0),
}
local ai = {
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

local function aj(...)
	local ak = {}
	for al = 1, select("#", ...) do
		local am = select(al, ...)
		for an = 1, #am do
			ak[#ak + 1] = am[an]
		end
	end
	return ak
end

local ak = {
	Low = ag,
	Medium = aj(ah, ag),
	High = aj(ah, ai, ag),
}

local al = RaycastParams.new()
al.FilterType = Enum.RaycastFilterType.Exclude
al.IgnoreWater = true

local function am(an, ao, ap, aq, ar, as, at)
	LPH_ATTRIBUTES(VM(NONE))
	if typeof(an) ~= "Vector3" or typeof(ao) ~= "Vector3" then
		return nil
	end
	if ar(an, ao) then
		return an
	end
	ap = tonumber(ap) or 0
	if ap <= 0 then
		return nil
	end
	at = tonumber(at)
	local au = ak[aq] or ak.High
	al.FilterDescendantsInstances = as or {}
	for av = 1, #au do
		local aw = au[av] * ap
		if at and math.abs(aw.Y) > at then
			aw = Vector3.new(aw.X, math.sign(aw.Y) * at, aw.Z)
		end
		local ax = an + aw
		if not ab(workspace, an, ax - an, al) and ar(ax, ao) then
			return ax
		end
	end
	return nil
end

return {
	solve = ac.wrap("manip.solve", am, 1),
}
end function a.i()local ab=a.cache.i if not ab then ab={c=aa()}a.cache.i=ab end return ab.c end end do local function aa()
local ab = a.i()
local ac = a.h()

local ag = {}

function ag.build(ah)
	local ai = ah.tv
	local aj = ah.ov
	local ak = ah.cloneOriginal
	local al = ah.wrap
	local am = ah.findGcFunction
	local an = ah.Players
	local ao = ah.LocalPlayer
	local ap = ah.UserInputService
	local aq = ah.Lighting
	local ar = ah.CollectionService
	local as = ah.ReplicatedStorage
	local at = ah.Modules
	local au = ah.Gun
	local av = ah.StateObject
	local aw = ah.Util
	local ax = ah.Targeting
	local ay = ah.ESP
	local az = ah.Library
	local aA = ah.owner.getLocalOwner
	local aB = ah.owner.getLiveCharacter
	local aC = ah.owner.getViewmodel
	local aD = ah.Tabs

	local aE = { "head" }
	local aF = game.FindFirstChild
	local aG = workspace.Raycast
	local aH = setmetatable({}, {
		__index = function(aH, aI)
			local aJ = (string.gsub(aI, "^%l", string.upper))
			aH[aI] = aJ
			return aJ
		end,
	})
	local aI = {
		["head"] = "head",
		["torso"] = "torso",
		["left arm"] = "arm2",
		["right arm"] = "arm1",
		["left leg"] = "leg2",
		["right leg"] = "leg1",
	}

	local function aJ()
		LPH_ATTRIBUTES(VM(NONE))
		local aK = aA()
		local aL = aj("targetfrom", "Muzzle")
		local aM = aL == "Head" or aL == 1
		if ai("antiaimfromhead", false) and ai("antiaim", false) then
			aM = true
		end
		if aM and aK then
			local aN = aK.values and aK.values.viewmodels
			local aO = typeof(aN) == "Instance" and (aN:FindFirstChild("head") or aN:FindFirstChild("Head"))
			if not (aO and aO:IsA("BasePart")) then
				local aP = aK.instance
				aO = typeof(aP) == "Instance" and (aP:FindFirstChild("head") or aP:FindFirstChild("Head"))
			end
			if aO and aO:IsA("BasePart") then
				return aO.Position
			end
		end
		local aN = aK and aK.values and aK.values.equipped
		local aO = aN and aN.shot
		if typeof(aO) == "Instance" and aO.Parent then
			return aO.Position
		end
		return ah.Camera.CFrame.Position
	end
	local function aK()
		table.clear(aE)
		local aL = aj("silenttarget", nil)
		if type(aL) == "table" then
			for aM, aN in pairs(aL) do
				if aN == true then
					local aO = aI[string.lower(tostring(aM))]
					if aO then
						table.insert(aE, aO)
					end
				end
			end
		end
		if #aE == 0 then
			aE[1] = "head"
		end
	end

	local aL = {
		Vector3.xAxis,
		-Vector3.xAxis,
		Vector3.yAxis,
		-Vector3.yAxis,
		Vector3.zAxis,
		-Vector3.zAxis,
	}

	local aM = {}
	local function aN(aO, aP, aQ)
		LPH_ATTRIBUTES(VM(NONE))
		if aP.Magnitude < 0.001 then
			return
		end
		aM[#aM + 1] = aO + aP.Unit * aQ
	end

	local aO = RaycastParams.new()
	aO.FilterType = Enum.RaycastFilterType.Exclude
	aO.IgnoreWater = true

	local aP = RaycastParams.new()
	aP.FilterType = Enum.RaycastFilterType.Exclude
	aP.IgnoreWater = true

	local aQ = {}
	local aR = {}

	local aS = function(aS, aT, aU, aV)
		LPH_ATTRIBUTES(VM(NONE))
		table.clear(aM)
		if not aS then
			return aM
		end
		aM[1] = aS
		if not (aU and aU > 0) then
			return aM
		end
		for aW, aX in aL do
			aN(aS, aX, aU)
		end
		local aW = ah.Camera.CFrame
		aN(aS, aW.LookVector, aU)
		aN(aS, aW.RightVector, aU)
		aN(aS, -aW.RightVector, aU)
		local aX = Vector3.new(aT.X - aS.X, 0, aT.Z - aS.Z)
		aN(aS, aX, aU)
		if aV == "Medium" or aV == "High" then
			aN(aS, aW.LookVector - Vector3.yAxis, aU)
			aN(aS, aX - Vector3.yAxis, aU)
			aN(aS, aW.RightVector - Vector3.yAxis, aU)
			aN(aS, -aW.RightVector - Vector3.yAxis, aU)
		end
		if aV == "High" then
			aN(aS, aW.LookVector + aW.RightVector, aU)
			aN(aS, aW.LookVector - aW.RightVector, aU)
			aN(aS, aX + Vector3.xAxis, aU)
			aN(aS, aX - Vector3.xAxis, aU)
		end
		return aM
	end
	local function aT(aU, aV)
		LPH_ATTRIBUTES(VM(NONE))
		for aW, aX in aV do
			if typeof(aX) == "Instance" and (aU == aX or aU:IsDescendantOf(aX)) then
				return true
			end
		end
		return false
	end

	local aU = {}
	local aV = {}

	local function aW(aX)
		LPH_ATTRIBUTES(VM(NONE))
		for aY, aZ in aU do
			if typeof(aZ) == "Instance" and aX:IsDescendantOf(aZ) then
				return true
			end
		end
		return false
	end

	local function aX(aY)
		LPH_ATTRIBUTES(VM(NONE))
		local aZ = aY
		for a_ = 1, 8 do
			if not aZ or aZ == workspace then
				break
			end
			local a0 = string.lower(aZ.Name)
			if string.find(a0, "shield", 1, true)
				or aZ:HasTag("Shield")
				or aZ:HasTag("BallisticShield")
				or aZ:HasTag("RiotShield")
				or aZ:HasTag("DeployableShield")
				or aZ:HasTag("GlassShield")
				or aZ:HasTag("MetalShield")
			then
				return true
			end
			aZ = aZ.Parent
		end
		return false
	end

	local function aY(aZ)
		LPH_ATTRIBUTES(VM(NONE))
		if aX(aZ) then
			return true
		end
		if aZ:GetAttribute("Hard") or (aZ.Parent and aZ.Parent:GetAttribute("Hard")) then
			return true
		end
		if aZ.Name == "MetalRoll" or aZ.Name == "MetalBarricade" then
			return true
		end
		local a_ = aZ
		for a0 = 1, 8 do
			if not a_ or a_ == workspace then
				break
			end
			if a_:HasTag("Reinforcement") or a_:HasTag("Hard") then
				return true
			end
			local a1 = string.lower(a_.Name)
			if string.find(a1, "metalbarricade", 1, true) or string.find(a1, "metal_barricade", 1, true) then
				return true
			end
			local a2 = a_.Name == "DoorBarricade" or a_:HasTag("DoorBarricade")
			if a2 then
				local a3 = aZ:GetAttribute("Soft") or a_:GetAttribute("Soft")
				local a4 = aZ.Material
				local a5 = a4 == Enum.Material.Metal
					or a4 == Enum.Material.CorrodedMetal
					or a4 == Enum.Material.DiamondPlate
				if aZ.Name == "MetalRoll" or aZ:IsA("UnionOperation") or a5 or not a3 then
					return true
				end
			end
			a_ = a_.Parent
		end
		return false
	end

	local function aZ(a_)
		LPH_ATTRIBUTES(VM(NONE))
		if a_:IsA("TrussPart") then
			return true
		end
		local a0 = string.lower(a_.Name)
		return string.find(a0, "ladder", 1, true) ~= nil or string.find(a0, "truss", 1, true) ~= nil
	end

	local function a_(a0)
		LPH_ATTRIBUTES(VM(NONE))
		if not a0 then
			return false
		end
		if aY(a0) or aX(a0) then
			return false
		end
		if a0.CanCollide == false or a0.Transparency >= 1 then
			return true
		end
		if a0.CollisionGroup == "char_block" then
			return true
		end
		local a1 = a0.Parent
		if a0:GetAttribute("Soft") or (a1 and a1:GetAttribute("Soft")) then
			return true
		end
		local a2 = string.lower(a0.Name)
		if string.find(a2, "glass", 1, true) or string.find(a2, "window", 1, true) then
			return true
		end
		return a0.Material == Enum.Material.Glass
	end

	local function a0(a1)
		LPH_ATTRIBUTES(VM(NONE))
		if aY(a1) or aX(a1) then
			return false
		end
		if aZ(a1) or a_(a1) then
			return true
		end
		return false
	end

	
	
	local a1 = setmetatable({}, { __mode = "k" })
	local a2 = setmetatable({}, { __mode = "k" })
	local function a3(a4)
		LPH_ATTRIBUTES(VM(NONE))
		local a5 = os.clock()
		local a6 = a2[a4]
		if a6 and a5 - a6 < 2 then
			return a1[a4]
		end
		local a7 = 0
		if aX(a4) then
			a7 = 1
		elseif aY(a4) then
			a7 = 2
		elseif aZ(a4) or a_(a4) then
			a7 = 3
		end
		a1[a4] = a7
		a2[a4] = a5
		return a7
	end

	local a4 = function(a4, a5, a6, a7)
		LPH_ATTRIBUTES(VM(NONE))
		local a8 = a5 - a4
		if a8.Magnitude <= 0.001 then
			return true
		end
		table.clear(aQ)
		if a7 then
			for a9 = 1, #a7 do
				aQ[a9] = a7[a9]
			end
		end
		aO.FilterDescendantsInstances = aQ
		local a9 = a4
		for b = 1, 8 do
			if a8.Magnitude <= 0.05 then
				return true
			end
			local ba = aG(workspace, a9, a8, aO)
			if not ba then
				return true
			end
			local bb = ba.Instance
			local bc = a3(bb)
			if bc == 1 then
				return false
			end
			if aT(bb, a6) then
				return true
			end
			local bd = ba.Position
			if (bd - a5).Magnitude <= 0.4 then
				return true
			end
			if bc ~= 3 or aW(bb) then
				return false
			end
			aQ[#aQ + 1] = bb
			aO.FilterDescendantsInstances = aQ
			a9 = bd + a8.Unit * 0.05
			a8 = a5 - a9
		end
		return false
	end

	local function a5(a6, a7, a8)
		LPH_ATTRIBUTES(VM(NONE))
		local a9 = a7 - a6
		local b = a9.Magnitude
		if b <= 0.05 then
			return a6
		end
		aO.FilterDescendantsInstances = a8 or {}
		local ba = aG(workspace, a6, a9, aO)
		if not ba then
			return a7
		end
		local bb = (ba.Position - a6).Magnitude
		if bb <= 0.15 then
			return nil
		end
		return a6 + a9.Unit * (bb - 0.15)
	end

	local a6 = 0
	local a7
	local a8
	local a9
	local b = false
	local ba = function(ba, bb, bc, bd, be)
		LPH_ATTRIBUTES(VM(NONE))
		local bf = os.clock()
		if bf - a6 < 1 / 60 and a7 == ba and a8 == bb then
			if b then
				return a9, bb
			end
			return nil
		end
		a6 = bf
		a7 = ba
		a8 = bb
		b = false
		a9 = nil
		local bg = (ai("manipulation", false) and aj("manipulationdistance", 0)) or 0
		local bh = (ai("manipulation", false) and aj("manipulationdepth", "Low")) or "Low"
		local bi = ab.solve(ba, bb, bg, bh, function(bi, bj)
			return a4(bi, bj, bc, bd)
		end, bd)
		if not bi then
			return nil
		end
		a9 = bi
		b = true
		return bi, bb
	end
	local bb = { origin = nil, dest = nil, at = 0 }
	local bc = { target = nil, time = 0 }
	local bd = 0
	local function be()
		LPH_ATTRIBUTES(VM(NONE))
		local bf = os.clock()
		if bf - bd < 0.25 then
			return
		end
		bd = bf
		table.clear(aU)
		for bg, bh in an:GetPlayers() do
			if bh == ao or not (ax.is_friendly and ax:is_friendly(bh)) then
				continue
			end
			local bi = aB(bh) or (ax.get_character and ax:get_character(bh))
			if not bi then
				continue
			end
			if typeof(bi.instance) == "Instance" and not bi.instance.Parent then
				continue
			end
			if bi.instance then
				table.insert(aU, bi.instance)
			end
			local bj = aC(bh, bi)
			if bj then
				table.insert(aU, bj)
			end
		end
	end

	local function bf(bg)
		LPH_ATTRIBUTES(VM(NONE))
		table.clear(aR)
		local bh = bg or aA()
		if bh then
			if bh.values and bh.values.viewmodels then
				aR[#aR + 1] = bh.values.viewmodels
			end
			if bh.instance then
				aR[#aR + 1] = bh.instance
			end
		end
		if ao.Character then
			aR[#aR + 1] = ao.Character
		end
		return aR
	end

	local bg = {
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

	local bh = workspace.CurrentCamera.WorldToViewportPoint
	local bi = math.huge
	local bj = math.sqrt
	local bk, bl, bm, bn, bo = -1, 0, 0, 0, 0
	local function bp(bq)
		LPH_ATTRIBUTES(VM(NONE))
		local br = ah.Camera
		local bs = ah.frame
		if bs ~= bk then
			bk = bs
			local bt = br.ViewportSize
			bl, bm = bt.X, bt.Y
			bn, bo = bl * 0.5, bm * 0.5
		end
		local bt, bu = bh(br, bq)
		local bv, bw = bt.X, bt.Y
		if not bu or bt.Z <= 0 or bv < 0 or bw < 0 or bv > bl or bw > bm then
			return false, bt, bi
		end
		local bx, by = bv - bn, bw - bo
		return true, bt, bj(bx * bx + by * by)
	end

	local function bq()
		local br = aj("multipointcount", "2^3")
		local bs = tonumber(br)
		if not bs then
			bs = tonumber(string.match(tostring(br), "%d+"))
		end
		return math.clamp(bs or 3, 1, 3)
	end

	local function br(bs, bt, bu)
		local bv = bs.Size * 0.5 * bu
		return bs.CFrame:PointToWorldSpace(Vector3.new(bv.X * bt.X, bv.Y * bt.Y, bv.Z * bt.Z))
	end

	local function bs(bt, bu)
		LPH_ATTRIBUTES(VM(NONE))
		local bv = bt and bt.Part
		if not bv or not bv.Parent then
			return
		end
		bt.AimPoint = bv.Position
		if not ai("multipoints", false) then
			return
		end
		local bw = math.clamp(tonumber(aj("multipointscale", 0.8)) or 0.8, 0.1, 1)
		local bx = bg[bq()]
		local by = bf()
		local bz = { bt.Viewmodel, bt.CharacterInstance, bv }
		local bA = ai("ragebotwallbang", false)
		local bB = ai("silentvischeck", false) or ai("ragebot", false) or ai("manipulation", false)
		local bC = bv.Position
		local bD = math.huge
		local bE = false
		local function c(d)
			local e, f, g = bp(d)
			if not e then
				g = (bu - d).Magnitude + 100000
			end
			if bB then
				if not a4(bu, d, bz, by, bA) then
					return
				end
				bE = true
			end
			if g < bD then
				bD = g
				bC = d
			end
		end
		c(bv.Position)
		for d = 1, #bx do
			c(br(bv, bx[d], bw))
		end
		if bB and not bE then
			bt.AimPoint = bv.Position
			return
		end
		bt.AimPoint = bC
		if bE then
			bt.Visible = true
		end
	end

	local bt = {
		{ "head", "Head" },
		{ "torso", "Torso", "UpperTorso" },
		{ "arm1", "Right Arm", "RightUpperArm" },
		{ "arm2", "Left Arm", "LeftUpperArm" },
		{ "leg1", "Right Leg", "RightUpperLeg" },
		{ "leg2", "Left Leg", "LeftUpperLeg" },
	}
	local bu = {
		Vector3.zero,
		Vector3.new(0, -1, 0),
		Vector3.new(0, 1, 0),
		Vector3.new(1, 0, 0),
		Vector3.new(-1, 0, 0),
		Vector3.new(0, 0, 1),
		Vector3.new(0, 0, -1),
	}

	local function bv(bw, bx)
		for by = 1, #bx do
			local bz = bw:FindFirstChild(bx[by])
			if bz and bz:IsA("BasePart") then
				return bz
			end
		end
	end

	local function bw(bx, by, bz, bA)
		LPH_ATTRIBUTES(VM(NONE))
		local bB = bx.Model
		if typeof(bB) ~= "Instance" then
			return nil
		end
		local bC = { bx.Viewmodel, bx.CharacterInstance, bB }
		for bD = 1, #bt do
			local bE = bv(bB, bt[bD])
			if bE then
				local c = bE.Size * 0.45
				local d = bE.CFrame
				for e = 1, #bu do
					local f = bu[e]
					local g = bE.Position
					if f.X ~= 0 or f.Y ~= 0 or f.Z ~= 0 then
						g = d:PointToWorldSpace(Vector3.new(c.X * f.X, c.Y * f.Y, c.Z * f.Z))
					end
					if a4(by, g, bC, bz, bA) then
						return bE, g
					end
				end
			end
		end
	end

	local function bx(by, bz, bA, bB)
		if bB >= bz[3] then
			return
		end
		local bC = 3
		if bB < bz[1] then
			bC = 1
		elseif bB < bz[2] then
			bC = 2
		end
		for bD = 3, bC + 1, -1 do
			by[bD] = by[bD - 1]
			bz[bD] = bz[bD - 1]
		end
		by[bC] = bA
		bz[bC] = bB
	end

	local function by()
		LPH_ATTRIBUTES(VM(NONE))
		be()
		local bz = aE
		if #bz == 0 then
			bz = { "head" }
		end

		local bA = math.huge
		if ai("silentdistancecheck", false) then
			local bB = aj("silentmaxdistance", 500)
			if bB > 0 then
				bA = bB
			end
		end

		local bB = math.huge
		local bC = ai("ragebot", false) and ai("rageignorefov", true)
		if ai("silentfovenabled", false) and not bC then
			bB = aj("silentfovsize", 100)
		end

		local bD = ai("ragebot", false)
		local bE = bD and ai("rageallparts", false)
		local c = not bD
		local d = ai("ragebotwallbang", false)
		local e = not bD and not ai("manipulation", false) and ai("silentvischeck", false)
		local f = ai("silentteamcheck", false)
		local g = aJ()
		local h = bf()
		local i = math.huge
		local j
		local k, l
		if bE then
			k = { nil, nil, nil }
			l = { math.huge, math.huge, math.huge }
		end

		for m, n in an:GetPlayers() do
			if n == ao then
				continue
			end
			if f and ax:is_friendly(n) then
				continue
			end

			local o = aB(n) or (ax.get_character and ax:get_character(n))
			if not o then
				continue
			end
			if typeof(o.instance) == "Instance" and not o.instance.Parent then
				continue
			end
			if ai("spawnprotcheck", false) or ai("ragebotspawnprot", false) then
				local p = o.instance
				if typeof(p) == "Instance" and p:GetAttribute("Protected") then
					continue
				end
			end

			local p = ax:get_health(n)
			if type(p) ~= "number" then
				local q = typeof(o.instance) == "Instance" and o.instance:FindFirstChildOfClass("Humanoid")
				p = q and q.Health or 100
			end
			if p <= 0 then
				continue
			end

			local q = aC(n, o)
			local r = o.instance
			local s = typeof(q) == "Instance" and q or (typeof(r) == "Instance" and r)
			if typeof(s) ~= "Instance" then
				continue
			end
			local t = s:FindFirstChild("torso")
				or s:FindFirstChild("head")
				or s:FindFirstChild("Head")
				or s:FindFirstChild("Torso")
				or s:FindFirstChild("HumanoidRootPart")
			if not t then
				continue
			end

			local u = t.Position
			local v = (g - u).Magnitude
			if v > bA then
				continue
			end

			if bE then
				if ai("silentfovenabled", false) and not ai("rageignorefov", true) then
					local w, x, y = bp(u)
					if not w or y > bB then
						continue
					end
				end
				bx(k, l, {
					Player = n,
					Part = t,
					Viewmodel = q,
					Character = o,
					CharacterInstance = r,
					Model = s,
					WorldPosition = u,
					ScreenDist = v,
					Visible = false,
				}, v)
				continue
			end

			local w
			local x
			local y = math.huge
			for z, A in bz do
				local B = aF(s, A) or aF(s, aH[A])
				if not B then
					continue
				end
				local C, D, E = bp(B.Position)
				if c and not C then
					continue
				end
				if E < y then
					y = E
					w = B
					x = D
				end
			end
			if not w then
				local z, A, B = bp(u)
				if c and not z then
					continue
				end
				w = t
				y = B
				x = A
			end
			if y > bB then
				continue
			end

			local z = ai("multipoints", false)
			local A = true
			if (e or bD) and not z then
				local B = aV
				B[1], B[2], B[3] = q, r, s
				A = a4(g, w.Position, B, h)
				if e and not A then
					continue
				end
			end

			local B = (bD and not z) and (A and v or v + 10000) or y
			if B < i then
				i = B
				j = {
					Player = n,
					Part = w,
					Viewmodel = q,
					Character = o,
					CharacterInstance = r,
					WorldPosition = u,
					ScreenPoint = x,
					ScreenDist = y,
					Visible = A,
				}
			end
		end

		if bE then
			for m = 1, 3 do
				local n = k[m]
				if not n then
					break
				end
				local o, p = bw(n, g, h, d)
				if o then
					n.Part = o
					n.AimPoint = p
					n.Visible = true
					return n
				end
			end
			return k[1]
		end

		return j
	end

	local function bz()
		LPH_ATTRIBUTES(VM(NONE))
		local bA = os.clock()
		if bA - bc.time < 1 / 60 then
			return bc.target
		end
		bc.time = bA
		if not (ai("silentenabled", false) or ai("ragebot", false) or ai("aimbotenabled", false) or ai("snaplines", false)) then
			bc.target = nil
			return nil
		end
		bc.target = by()
		if bc.target and not bc.target.AimPoint then
			bs(bc.target, aJ())
		end
		return bc.target
	end

	local function bA(bB, bC)
		LPH_ATTRIBUTES(VM(NONE))
		if bB and bC then
			bb.origin = bB
			bb.dest = bC
			bb.at = os.clock()
		else
			bb.origin = nil
			bb.dest = nil
		end
		return bB, bC
	end

	local function bB(bC, bD, bE, c)
		LPH_ATTRIBUTES(VM(NONE))
		local d = ai("ragebot", false)
		local e = ai("silentvischeck", false) or d
		local f = ai("ragebotwallbang", false)
		local g = ai("manipulation", false)

		if g then
			return bA(ba(bC, bD, bE, c, f))
		end
		if e then
			if a4(bC, bD, bE, c, f) then
				return bA(bC, bD)
			end
			return bA(nil)
		end
		return bA(bC, bD)
	end

	a4 = ac.wrap("aim.canHit", a4, 1)
	by = ac.wrap("aim.findBest", by, 1)
	ba = ac.wrap("aim.manipScan", ba, 2)
	bB = ac.wrap("aim.resolveShot", bB, 2)
	bw = ac.wrap("aim.rageHitscan", bw, 2)

	local bC = { direct = 0, hidden = 0, peeked = 0 }
	local function bD(bE, c, d)
		LPH_ATTRIBUTES(VM(NONE))
		local e = {}
		local f = {}
		local g = ai("manipulation", false) and (tonumber(aj("manipulationdistance", 0)) or 0) > 0
		local h = ai("silentteamcheck", false)
		for i, j in an:GetPlayers() do
			if j == ao then
				continue
			end
			if h and ax:is_friendly(j) then
				continue
			end
			local k = aB(j) or (ax.get_character and ax:get_character(j))
			if not k then
				continue
			end
			local l = k.instance
			if typeof(l) == "Instance" and not l.Parent then
				continue
			end
			if (ai("spawnprotcheck", false) or ai("ragebotspawnprot", false)) and typeof(l) == "Instance" and l:GetAttribute("Protected") then
				continue
			end
			local m = ax:get_health(j)
			if type(m) ~= "number" then
				local n = typeof(l) == "Instance" and l:FindFirstChildOfClass("Humanoid")
				m = n and n.Health or 100
			end
			if m <= 0 then
				continue
			end
			local n = aC(j, k)
			local o = typeof(n) == "Instance" and n or (typeof(l) == "Instance" and l)
			if typeof(o) ~= "Instance" then
				continue
			end
			local p = bv(o, { "head", "Head" })
			if not p then
				continue
			end
			local q = p.Position
			local r = { n, l, o, p }
			local s = {
				Player = j,
				Part = p,
				AimPoint = q,
				Viewmodel = n,
				Character = k,
				CharacterInstance = l,
				WorldPosition = q,
				Visible = true,
				Parents = r,
				Dist = (bE - q).Magnitude,
			}
			if a4(bE, q, r, c) then
				e[#e + 1] = s
			elseif g then
				
				f[#f + 1] = s
			end
		end
		table.sort(e, function(i, j)
			return i.Dist < j.Dist
		end)
		bC.direct, bC.hidden, bC.peeked = #e, #f, 0
		if g and #f > 0 then
			
			
			table.sort(f, function(i, j)
				return i.Dist < j.Dist
			end)
			for i = 1, math.min(#f, 3) do
				local j = f[i]
				local k = ba(bE, j.AimPoint, j.Parents, c)
				if k then
					j.Peek = k
					e[#e + 1] = j
					bC.peeked += 1
				end
			end
		end
		return e
	end

	local bE = {
		{ tag = "Claymore", label = "Claymore" },
		{ tag = "NeedleMine", label = "Needle Mine" },
		{ tag = "ProximityAlarm", label = "Proximity Alarm" },
		{ tag = "BarbedWire", label = "Barbed Wire" },
		{ tag = "ShockBattery", label = "Shock Battery" },
		{ tag = "IncendiaryCanister", label = "Incendiary Canister" },
	}
	local c = {
		{ tag = "BreachCharge", label = "Breach Charge" },
		{ tag = "HardBreachCharge", label = "Hard Breacher" },
		{ tag = "RemoteC4", label = "Remote C4" },
		{ tag = "ThermiteCharge", label = "Thermite Charge" },
		{ tag = "ToxicCharge", label = "Toxic Charge" },
		{ tag = "SignalDisruptor", label = "Signal Jammer" },
	}
	local d = {}
	for e, f in bE do
		d[#d + 1] = f.label
	end

	local function e(f)
		LPH_ATTRIBUTES(VM(NONE))
		if typeof(f) ~= "Instance" or not f.Parent then
			return nil
		end
		if f:GetAttribute("Destroyed") or f:GetAttribute("Disabled") then
			return nil
		end
		local g = f.Parent
		if g.Name == "Garbage" or g == as then
			return nil
		end
		local h = f:FindFirstChild("Root")
		if h and h:IsA("BasePart") then
			return h
		end
		if f:IsA("BasePart") then
			return f
		end
		if f:IsA("Model") and f.PrimaryPart then
			return f.PrimaryPart
		end
		for i, j in f:GetChildren() do
			if j:IsA("BasePart") and j.Transparency < 1 and j.Size.Magnitude > 0.05 then
				return j
			end
		end
		return nil
	end

	local function f(g)
		LPH_ATTRIBUTES(VM(NONE))
		local h = g:FindFirstChild("ClientModel")
		if h and h:IsA("ObjectValue") and typeof(h.Value) == "Instance" then
			return h.Value
		end
		return g
	end

	local function g(h, i)
		LPH_ATTRIBUTES(VM(NONE))
		local j = { h, i }
		local k = h:FindFirstChild("ClientModel")
		if k and k:IsA("ObjectValue") and typeof(k.Value) == "Instance" then
			j[#j + 1] = k.Value
		end
		return j
	end

	local function h(i, j)
		LPH_ATTRIBUTES(VM(NONE))
		local k
		if j and j.owner and type(j.owner.get) == "function" then
			local l, m = pcall(j.owner.get, j.owner)
			if l and typeof(m) == "Instance" then
				k = m
			end
		end
		if k then
			return aw.ownership(k, ao) == 0
		end
		local l = i:GetAttribute("UserId")
		if l and l == ao:GetAttribute("UserId") then
			return false
		end
		local m = i:GetAttribute("Team")
		if m and m == ao:GetAttribute("Team") then
			return false
		end
		return l ~= nil or m ~= nil
	end

	local function i(j)
		LPH_ATTRIBUTES(VM(NONE))
		local k = aj("ragetraps", nil)
		if type(k) ~= "table" then
			return false
		end
		return k[j] == true
	end

	local function j()
		LPH_ATTRIBUTES(VM(NONE))
		if not ai("ragebottraps", false) then
			return nil
		end
		local k = aJ()
		local l = aA()
		local m = bf(l)
		local n = ai("ragebotwallbang", false)
		local o = math.huge
		local p
		local q = {}
		for r, s in bE do
			if not i(s.label) then
				continue
			end
			local t = av.get_all(s.tag)
			if type(t) == "table" then
				for u, v in t do
					local w = v and v.instance
					if typeof(w) == "Instance" then
						q[w] = true
						local x = h(w, v) and e(w)
						if x then
							local y = (k - x.Position).Magnitude
							if y < o and a4(k, x.Position, g(w, x), m, n) then
								o = y
								p = {
									Part = x,
									AimPoint = x.Position,
									Viewmodel = nil,
									CharacterInstance = f(w),
									WorldPosition = x.Position,
									Visible = true,
								}
							end
						end
					end
				end
			end
			for u, v in ar:GetTagged(s.tag) do
				if q[v] then
					continue
				end
				local w = h(v, nil) and e(v)
				if not w then
					continue
				end
				local x = (k - w.Position).Magnitude
				if x < o and a4(k, w.Position, g(v, w), m, n) then
					o = x
					p = {
						Part = w,
						AimPoint = w.Position,
						Viewmodel = nil,
						CharacterInstance = f(v),
						WorldPosition = w.Position,
						Visible = true,
					}
				end
			end
		end
		return p
	end

	local function k()
		LPH_ATTRIBUTES(VM(NONE))
		local l = bz()
		local m = j()
		if not m or not m.Part then
			return l
		end
		if not (l and l.Part and l.Part.Parent) or l.Visible == false then
			return m
		end
		local n = aJ()
		local o = (n - m.Part.Position).Magnitude
		local p = (n - l.Part.Position).Magnitude
		if o < p then
			return m
		end
		return l
	end

	ah.aim = {
		refreshTargetParts = aK,
		getTarget = bz,
		shotOrigin = aJ,
		resolveShot = bB,
		rageAimTarget = k,
		trapTarget = j,
		rageTargets = bD,
		rageStats = bC,
		projectScreen = bp,
		getIgnoreList = bf,
		cache = bc,
		peek = bb,
		trapTypes = bE,
		gadgetTypes = c,
		trapLabels = d,
	}

end

function ag.step(ah)
end

function ag.unload()
end

return ag
end function a.j()local ab=a.cache.j if not ab then ab={c=aa()}a.cache.j=ab end return ab.c end end do local function aa()
local ab = {}

function ab.build(ac)
	local ag = ac.tv
	local ah = ac.ov
	local ai = ac.cloneOriginal
	local aj = ac.wrap
	local ak = ac.findGcFunction
	local al = ac.Players
	local am = ac.LocalPlayer
	local an = ac.UserInputService
	local ao = ac.Lighting
	local ap = ac.CollectionService
	local aq = ac.ReplicatedStorage
	local ar = ac.Modules
	local as = ac.Gun
	local at = ac.StateObject
	local au = ac.Util
	local av = ac.Targeting
	local aw = ac.ESP
	local ax = ac.Library
	local ay = ac.owner.getLocalOwner
	local az = ac.owner.getLiveCharacter
	local aA = ac.owner.getViewmodel
	local aB = ac.Tabs

	local function aC(aD)
		LPH_ATTRIBUTES(VM(NONE))
		return type(aD) == "table" and aD.owner ~= nil
	end

	local function aD(aE)
		LPH_ATTRIBUTES(VM(NONE))
		if aC(aE) then
			return aE
		end
		local aF = ay()
		local aG = aF and aF.values and aF.values.equipped
		if aC(aG) then
			return aG
		end
		return nil
	end
	local aE = RaycastParams.new()
	aE.FilterType = Enum.RaycastFilterType.Exclude
	aE.IgnoreWater = true
	
	local aF
	local function aG(aH)
		LPH_ATTRIBUTES(VM(NONE))
		if type(aH) == "table" then
			local aI = aH.shot
			if typeof(aI) == "Instance" then
				return aI.CFrame
			end
			local aJ = aH.instance
			local aK = typeof(aJ) == "Instance" and aJ:FindFirstChild("Root")
			if aK then
				return aK.CFrame
			end
		end
		return ac.Camera.CFrame
	end

	aF = ac.hook(as.get_shoot_look, function(aH, ...)
		LPH_ATTRIBUTES(VM(NONE))
		local aI, aJ = pcall(aF, aH, ...)
		if not aI or typeof(aJ) ~= "CFrame" then
			aJ = aG(aH)
		end
		if ac.aim.shotOrigin and typeof(aJ) == "CFrame" then
			local aK = ac.aim.shotOrigin()
			if aK then
				aJ = CFrame.new(aK) * aJ.Rotation
			end
		end
		if not (ag("silentenabled", false) or ag("ragebot", false)) then
			return aJ
		end
		if not aC(aH) then
			return aJ
		end
		local aK = ay()
		if not aK or aH.owner ~= aK then
			return aJ
		end

		local aL = ac.aim.rageShot
		if not aL then
			aL = ac.aim.getTarget()
			if ag("ragebot", false) and ag("ragebottraps", false) then
				aL = ac.aim.rageAimTarget()
			end
		end
		local aM = aL and aL.Part
		if not aM or not aM.Parent then
			return aJ
		end

		if ac.aim.peek.origin and ac.aim.peek.dest and os.clock() - ac.aim.peek.at < 0.05 then
			return CFrame.lookAt(ac.aim.peek.origin, ac.aim.peek.dest)
		end

		local aN = ac.aim.getIgnoreList(aH.owner)
		local aO, aP = ac.aim.resolveShot(
			aJ.Position,
			aL.AimPoint or aM.Position,
			{ aL.Viewmodel, aL.CharacterInstance },
			aN
		)
		if not aO or not aP then
			return aJ
		end

		return CFrame.lookAt(aO, aP)
	end)

	if type(au.validate_position) == "function" then
		local aH
		aH = ac.hook(au.validate_position, function(aI, aJ, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if ac.aim.peek.origin and os.clock() - ac.aim.peek.at < 0.1 and typeof(aJ) == "Vector3" and (aJ - ac.aim.peek.origin).Magnitude < 0.5 then
				return aJ
			end
			return aH(aI, aJ, ...)
		end)
	end

	
	local aH
	aH = ac.hook(as.recoil_function, function(aI, aJ)
		LPH_ATTRIBUTES(VM(NONE))
		if type(aI) ~= "table" or not aI.states then
			return
		end
		local aK = ah("recoilup", 0)
		local aL = ah("recoilside", 0)
		if aK <= 0 and aL <= 0 then
			return
		end
		if aK >= 1 and aL >= 1 then
			return aH(aI, aJ)
		end
		local aM, aN = aI.states.recoil_up, aI.states.recoil_side
		local aO, aP = aM.get, aN.get
		aM.get = function(...)
			LPH_ATTRIBUTES(VM(NONE))
			return aO(...) * aK
		end
		aN.get = function(...)
			LPH_ATTRIBUTES(VM(NONE))
			return aP(...) * aL
		end
		local aQ, aR = pcall(aH, aI, aJ)
		aM.get, aN.get = aO, aP
		if not aQ then
			warn(aR)
		end
	end)

	
	local aI
	aI = ac.hook(as.kickback, function(aJ, ...)
		LPH_ATTRIBUTES(VM(NONE))
		if type(aJ) ~= "table" then
			return
		end
		if ag("nokickback", false) then
			return
		end
		return aI(aJ, ...)
	end)


	local function aJ(aK, aL, aM, aN)
		LPH_ATTRIBUTES(VM(NONE))
		if not aK or type(aK[aL]) ~= "function" then
			return
		end
		local aO = aK[aL]
		aN[#aN + 1] = function()
			aK[aL] = aO
		end
		aK[aL] = function(...)
			LPH_ATTRIBUTES(VM(NONE))
			return aM
		end
	end

	local function aK(aL, aM, aN, ...)
		LPH_ATTRIBUTES(VM(NONE))
		if not aL or not aM then
			return aN(...)
		end
		local aO = {}
		if aM.running and aL.states and aL.states.running then
			aJ(aL.states.running, "get", false, aO)
		end
		if aM.falling and aL.values and aL.values.falling then
			aJ(aL.values.falling, "get", false, aO)
		end
		if aM.vault and aL.states and aL.states.vault then
			aJ(aL.states.vault, "get", 0, aO)
		end
		if aM.prone and aL.values then
			local aP = aL.values.prone_debounce
			aL.values.prone_debounce = false
			aO[#aO + 1] = function()
				aL.values.prone_debounce = aP
			end
		end
		if aM.equip and aL.values and aL.values.equip_debounce then
			aJ(aL.values.equip_debounce, "get", false, aO)
		end
		local aP, aQ, aR, aS = pcall(aN, ...)
		for aT = #aO, 1, -1 do
			aO[aT]()
		end
		if not aP then
			warn(aQ)
			return
		end
		return aQ, aR, aS
	end

	local function aL()
		LPH_ATTRIBUTES(VM(NONE))
		return ag("reloadwhilerunning", false) or ag("reloadwhilefalling", false) or ag("noreloadinterrupt", false)
	end

	local function aM()
		LPH_ATTRIBUTES(VM(NONE))
		return ag("shootwhilerunning", false) or ag("ragebot", false)
	end

	local function aN()
		LPH_ATTRIBUTES(VM(NONE))
		return ag("shootwhilefalling", false) or ag("ragebot", false)
	end

	local aO
	aO = ac.hook(as.input_shoot, function(aP, ...)
		LPH_ATTRIBUTES(VM(NONE))
		local aQ = aD(aP)
		if not aQ then
			return aO(aP, ...)
		end
		return aK(aQ.owner, {
			running = aM(),
			falling = aN(),
			vault = aM() or aN(),
			prone = aM() or aN(),
		}, aO, aQ, ...)
	end)

	local aP
	local aQ = 0
	local aR
	aR = ac.hook(as.reload, function(aS, aT, aU, ...)
		LPH_ATTRIBUTES(VM(NONE))
		if aU == false and aP and aS == aP then
			local aV = aS.reload_thread
			if aV and aV.running then
				return
			end
		end
		return aR(aS, aT, aU, ...)
	end)

	local aS
	aS = ac.hook(as.input_render, function(aT, ...)
		LPH_ATTRIBUTES(VM(NONE))
		local aU = aD(aT)
		if not aU then
			return aS(aT, ...)
		end
		return aK(aU.owner, {
			running = aM(),
			falling = aN(),
			vault = aL() or aM() or aN(),
			prone = aL() or aM() or aN(),
		}, aS, aU, ...)
	end)

	local aT
	aT = ac.hook(as.running, function(aU, aV, aW, ...)
		LPH_ATTRIBUTES(VM(NONE))
		local aX = aD(aU)
		if not aX then
			return aT(aU, aV, aW, ...)
		end
		aU = aX
		if aW and aL() and aU.reload then
			local aY = aU.reload
			aU.reload = function() end
			local aZ, a_, a0, a1 = pcall(aT, aU, aV, aW, ...)
			aU.reload = aY
			if not aZ then
				warn(a_)
				return
			end
			return a_, a0, a1
		end
		return aT(aU, aV, aW, ...)
	end)

	if type(as.walk_state) == "function" then
		local aU
		aU = ac.hook(as.walk_state, function(aV, aW, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if type(aV) ~= "table" then
				return
			end
			if aL() and aV.reload then
				local aX = aV.reload
				aV.reload = function() end
				local aY, aZ, a_, a0 = pcall(aU, aV, aW, ...)
				aV.reload = aX
				if not aY then
					warn(aZ)
					return
				end
				return aZ, a_, a0
			end
			return aU(aV, aW, ...)
		end)
	end

	if type(as.vault) == "function" then
		local aU
		aU = ac.hook(as.vault, function(aV, aW, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if type(aV) ~= "table" then
				return
			end
			if aL() and aV.reload then
				local aX = aV.reload
				aV.reload = function() end
				local aY, aZ, a_, a0 = pcall(aU, aV, aW, ...)
				aV.reload = aX
				if not aY then
					warn(aZ)
					return
				end
				return aZ, a_, a0
			end
			return aU(aV, aW, ...)
		end)
	end

	local aU = ac.gc.get_circular_spread
	if aU then
		local aV
		aV = ac.hook(aU, function(aW, aX)
			LPH_ATTRIBUTES(VM(NONE))
			return aV(aW, (aX or 0) * ah("spreadmult", 1))
		end)
	else
		local aV
		aV = ac.hook(as.send_shoot, function(aW, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if type(aW) ~= "table" then
				return aV(aW, ...)
			end
			local aX = aW.states and aW.states.spread
			local aY
			if aX then
				aY = aX.get
				aX.get = function(...)
					LPH_ATTRIBUTES(VM(NONE))
					return aY(...) * ah("spreadmult", 1)
				end
			end
			local aZ, a_, a0, a1 = pcall(aV, aW, ...)
			if aY then
				aX.get = aY
			end
			if not aZ then
				warn(a_)
				return
			end
			return a_, a0, a1
		end)
	end

	local aV = {}
	local aW = Instance.new("Folder")
	aW.Name = "vault_tracers"
	aW.Parent = workspace

	local function aX(aY, aZ)
		if not (aY and aZ) then
			return
		end
		if #aV >= 32 then
			local a_ = table.remove(aV, 1)
			if a_ and a_.part then
				a_.part:Destroy()
			end
		end
		if not aW or not aW.Parent then
			aW = Instance.new("Folder")
			aW.Name = "vault_tracers"
			aW.Parent = workspace
		end
		local a_ = (aZ - aY).Magnitude
		if a_ <= 0.001 then
			return
		end
		local a0 = ah("tracermaterial", "Neon")
		local a1 = Enum.Material[a0] or Enum.Material.Neon
		local a2 = ah("tracersize", 0.12)
		local a3 = Instance.new("Part")
		a3.Name = "tracer"
		a3.Anchored = true
		a3.CanCollide = false
		a3.CanQuery = false
		a3.CanTouch = false
		a3.CastShadow = false
		a3.Material = a1
		a3.Color = ah("tracercolor", Color3.fromRGB(255, 255, 255))
		a3.Transparency = ah("tracertransparency", 0.25)
		a3.Size = Vector3.new(a2, a2, a_)
		a3.CFrame = CFrame.lookAt((aY + aZ) / 2, aZ)
		local a4 = ah("tracertexture", "None")
		if a4 == "Glow" then
			local a5 = Instance.new("SurfaceLight")
			a5.Brightness = 2
			a5.Range = 12
			a5.Parent = a3
		elseif a4 == "Lightning" then
			local a5 = Instance.new("Texture")
			a5.Texture = "rbxassetid://10850031522"
			a5.Face = Enum.NormalId.Front
			a5.StudsPerTileU = 2
			a5.StudsPerTileV = 2
			a5.Parent = a3
		end
		a3.Parent = aW
		table.insert(aV, {
			part = a3,
			t0 = os.clock(),
			life = ah("tracerlifetime", 1),
			baseT = ah("tracertransparency", 0.25),
		})
	end

	local function aY()
		for aZ, a_ in aV do
			if a_.part then
				a_.part:Destroy()
			end
		end
		table.clear(aV)
	end

	local function aZ()
		LPH_ATTRIBUTES(VM(NONE))
		if not ag("tracersenabled", false) then
			if #aV > 0 then
				aY()
			end
			return
		end
		local a_ = os.clock()
		for a0 = #aV, 1, -1 do
			local a1 = aV[a0]
			if not a1.part or not a1.part.Parent or a_ - a1.t0 >= a1.life then
				if a1.part then
					a1.part:Destroy()
				end
				table.remove(aV, a0)
				continue
			end
			local a2 = (a_ - a1.t0) / a1.life
			a1.part.Transparency = a1.baseT + (1 - a1.baseT) * a2
		end
	end

	local a_
	a_ = ac.hook(as.send_shoot, function(a0, ...)
		LPH_ATTRIBUTES(VM(NONE))
		local a1 = aD(a0)
		if not a1 then
			return a_(a0, ...)
		end
		a0 = a1
		if ag("tracersenabled", false) then
			local a2 = a0:get_shoot_look()
			local a3 = a2.Position
			local a4 = a3 + a2.LookVector * 1000
			local a5 = ac.aim.cache.target
			local a6 = a5 and a5.Part
			if a6 and a6.Parent and (ag("silentenabled", false) or ag("ragebot", false)) then
				a4 = a5.AimPoint or a6.Position
			else
				aE.FilterDescendantsInstances = ac.aim.getIgnoreList(a0.owner)
				local a7 = workspace:Raycast(a3, a2.LookVector * 1000, aE)
				if a7 then
					a4 = a7.Position
				end
			end
			aX(a3, a4)
		end
		return a_(a0, ...)
	end)

	local function a0()
		LPH_ATTRIBUTES(VM(NONE))
		if not ag("aimbotenabled", false) then
			return
		end
		local a1 = ac.option("aimbotkey")
		if a1 and not a1:GetState() then
			return
		end
		local a2 = ac.aim.getTarget()
		local a3 = a2 and a2.Part
		if not (a3 and a3.Parent) then
			return
		end
		local a4 = math.max(1, ah("aimbotsmoothness", 1))
		local a5 = a2.AimPoint or a3.Position
		if ah("aimbotmethod", "Camera") == "Mouse" and mousemoverel then
			local a6, a7 = ac.Camera:WorldToViewportPoint(a5)
			if a7 and a6.Z > 0 then
				local a8 = an:GetMouseLocation()
				mousemoverel((a6.X - a8.X) / a4, (a6.Y - a8.Y) / a4)
			end
		else
			local a6 = ac.Camera.CFrame
			local a7 = CFrame.lookAt(a6.Position, a5)
			if a4 == 1 then
				ac.Camera.CFrame = a7
			else
				ac.Camera.CFrame = a6:Lerp(a7, 1 / a4)
			end
		end
	end

	local a1 = false
	local a2 = 0
	local a3 = false
	local a4 = 0
	local function a5()
		LPH_ATTRIBUTES(VM(NONE))
		local a6 = ay()
		local a7 = a6 and a6.values and a6.values.equipped
		if not a7 or type(a7.send_shoot) ~= "function" then
			a3 = false
			return
		end
		local a8 = a7.inputs and a7.inputs:get("reload")
		local a9 = a8 and a8.holding and a8:holding()
		if not a9 then
			a3 = false
			return
		end
		if a3 then
			return
		end

		local b = a6.states and a6.states.running and a6.states.running:get()
		local ba = a6.values.falling and a6.values.falling:get()
		local bb = a6.states and a6.states.vault and a6.states.vault:get() > 0
		local bc = a6.values.prone_debounce == true
		local bd = b or ba or bb or bc
		local be = (ag("reloadwhilerunning", false) and b)
			or (ag("reloadwhilefalling", false) and ba)
			or (ag("noreloadinterrupt", false) and bd)
		if not be then
			return
		end

		a3 = true
		if a7.reload_thread and a7.reload_thread.running then
			return
		end
		local bf = a7.states.bullets and a7.states.bullets:get() or 0
		local bg = a7.states.mag and a7.states.mag:get() or 0
		local bh = a7.states.mag_size and a7.states.mag_size:get() or 0
		if bf <= 0 or bg >= bh then
			return
		end
		if a7.states.reload and a7.states.reload.fire_instant then
			pcall(function()
				a7.states.reload:fire_instant()
			end)
		end
	end

	
	local a6 = {}
	local function a7(a8, a9)
		local b = ac.aim.peek
		local ba = {
			t = os.clock(),
			target = a8.Player and a8.Player.Name or "device",
			shift = b.origin and math.floor((b.origin - ac.aim.shotOrigin()).Magnitude * 10) / 10 or 0,
			sent = a9,
			dmg = 0,
		}
		a6[#a6 + 1] = ba
		if #a6 > 40 then
			table.remove(a6, 1)
		end
		local bb = a8.CharacterInstance
		local bc = typeof(bb) == "Instance" and bb:FindFirstChildOfClass("Humanoid")
		if bc then
			local bd = bc.Health
			local be
			be = bc.HealthChanged:Connect(function(bf)
				if bf < bd then
					ba.dmg += bd - bf
				end
				bd = bf
			end)
			task.delay(0.6, function()
				be:Disconnect()
			end)
		end
	end
	ac.aim.shotLog = a6

	local function a8()
		LPH_ATTRIBUTES(VM(NONE))
		if not ag("ragebot", false) then
			aP = nil
			if a1 then
				local a9 = ay()
				local b = a9 and a9.values and a9.values.equipped
				if b and b.input_shoot then
					pcall(b.input_shoot, b, false)
				end
				a1 = false
			end
			return
		end

		local a9 = ay()
		if not a9 or not a9.values then
			return
		end
		local b = a9.values.equipped
		if not b or type(b.send_shoot) ~= "function" then
			return
		end
		local ba = b.instance
		if typeof(ba) ~= "Instance" or not ba:FindFirstChild("Root") then
			return
		end
		if b.safety and b.safety.set and b.safety.get and b.safety:get() then
			pcall(function()
				b.safety:set(false)
			end)
		end

		if ag("ragebotautoreload", false) then
			local bb = b.states.mag and b.states.mag:get() or 0
			local bc = b.states.bullets and b.states.bullets:get() or 0
			local bd = b.reload_thread and b.reload_thread.running
			if bd then
				if a1 then
					pcall(b.input_shoot, b, false)
					a1 = false
				end
				return
			end
			if bb <= 0 and bc > 0 then
				if os.clock() - aQ < 0.4 then
					return
				end
				aQ = os.clock()
				if b.states.sights and b.states.sights.set then
					pcall(function()
						b.states.sights:set(false)
					end)
				end
				b.ads_hold = false
				aP = b
				if b.states.reload and b.states.reload.fire_instant then
					pcall(function()
						b.states.reload:fire_instant()
					end)
				end
				return
			end
			if aP == b then
				aP = nil
			end
		elseif aP == b then
			aP = nil
		end

		local bb = b.states.mag and b.states.mag:get() or 0
		if bb <= 0 then
			return
		end
		local bc = os.clock()
		local bd = b.states.firerate and b.states.firerate:get() or 0
		if bd == 0 and b.states.chambered and b.states.chambered.get and not b.states.chambered:get() then
			local be = b.cock_thread and b.cock_thread.running
			if not be and b.states.cock and b.states.cock.fire_instant then
				pcall(function()
					b.states.cock:fire_instant()
				end)
			end
			return
		end
		local be = bd ~= 0 and (1 / (bd / 60)) or 0
		if be > 0 and bc - a2 <= be then
			return
		end

		local bf = ac.Camera.CFrame.Position
		local bg = (ac.aim.shotOrigin and ac.aim.shotOrigin()) or bf
		if (bg - bf).Magnitude > 6 then
			bg = bf
		end
		local bh = ac.aim.rageTargets(bg, ac.aim.getIgnoreList(a9), ag("ragebotwallbang", false))
		if ag("ragebottraps", false) and ac.aim.trapTarget then
			local bi = ac.aim.trapTarget()
			if bi and bi.Part then
				bh[#bh + 1] = bi
			end
		end
		if #bh == 0 then
			if a1 then
				pcall(b.input_shoot, b, false)
				a1 = false
			end
			return
		end
		if a4 > #bh then
			a4 = 0
		end

		local bi = ac.aim.getIgnoreList(a9)
		local bj
		for bk = 1, #bh do
			a4 = (a4 % #bh) + 1
			local bl = bh[a4]
			local bm = bl.Part
			if bm and bm.Parent and ac.aim.resolveShot(bg, bl.AimPoint or bm.Position, { bl.Viewmodel, bl.CharacterInstance, bm }, bi) then
				bj = bl
				break
			end
		end
		if not bj then
			if a1 then
				pcall(b.input_shoot, b, false)
				a1 = false
			end
			return
		end
		a2 = bc
		ac.aim.rageShot = bj
		local bk = pcall(b.send_shoot, b)
		ac.aim.rageShot = nil
		a1 = true
		a7(bj, bk)
	end

	do
	    local a9 = aB.Combat:AddLeftGroupbox("Targeting")
	    a9:AddDropdown("silenttarget", {
	    	Text = "Target part",
	    	Values = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" },
	    	Default = 1,
	    	Multi = true,
	    })
	    a9:AddDropdown("targetfrom", {
	    	Text = "Target from",
	    	Values = { "Head", "Muzzle" },
	    	Default = 2,
	    	Multi = false,
	    })
	    a9:AddToggle("antiaimfromhead", { Text = "Head origin on antiaim", Default = false })
	    a9:AddToggle("silentteamcheck", { Text = "Team Check", Default = false })
	    a9:AddToggle("spawnprotcheck", { Text = "Spawn Protection", Default = false })
	    a9:AddToggle("silentvischeck", { Text = "Visible Check", Default = false })
	    a9:AddToggle("silentdistancecheck", { Text = "Distance Check", Default = false })
	    a9:AddSlider("silentmaxdistance", {
	    	Text = "Max Distance",
	    	Default = 500,
	    	Min = 10,
	    	Max = 2000,
	    	Rounding = 0,
	    	Suffix = " studs",
	    })
	    a9:AddToggle("silentfovenabled", { Text = "FOV Check", Default = false })
	    a9:AddSlider("silentfovsize", {
	    	Text = "FOV Size",
	    	Default = 100,
	    	Min = 3,
	    	Max = 1000,
	    	Rounding = 0,
	    	Suffix = " px",
	    })
	    a9:AddToggle("multipoints", { Text = "Multipoints", Default = false })
	    a9:AddDropdown("multipointcount", {
	    	Text = "Point count",
	    	Values = { "2^1", "2^2", "2^3" },
	    	Default = 3,
	    	Multi = false,
	    })
	    a9:AddSlider("multipointscale", {
	    	Text = "Point scale",
	    	Default = 0.8,
	    	Min = 0.1,
	    	Max = 1,
	    	Rounding = 2,
	    	Suffix = "x",
	    })
	    ac.option("silenttarget"):OnChanged(ac.aim.refreshTargetParts)
	    ac.aim.refreshTargetParts()

	    local b = aB.Combat:AddRightGroupbox("Silent Aim")
	    b:AddToggle("silentenabled", {Text = "Silent Aim", Default = false})
	        :AddKeyPicker(
	    		"silentenabledbind",
	    		{ Default = "None", SyncToggleState = true, Mode = "Toggle", Text = "Silent Aim Keybind" }
	    	)
	    b:AddToggle("silentfovdraw", {Text = "Draw FOV Circle", Default = true})
	    b:AddLabel("FOV color"):AddColorPicker("silentfovcolor", { Default = Color3.fromRGB(255, 255, 255), Title = "FOV color" })
	    b:AddSlider("silentfovthickness", { Text = "FOV Thickness", Default = 1, Min = 1, Max = 6, Rounding = 0 })
	    b:AddToggle("snaplines", { Text = "Snapline", Default = false })
	    b:AddLabel("Line color"):AddColorPicker("snapcolor", { Default = Color3.fromRGB(255, 0, 0), Title = "Target line" })
	    b:AddSlider("snapwidth", { Text = "Line Width", Default = 1, Min = 1, Max = 4, Rounding = 0 })

	    local ba = aB.Combat:AddRightGroupbox("Aimbot")
	    ba:AddToggle("aimbotenabled", { Text = "Enabled", Default = false })
	    	:AddKeyPicker("aimbotkey", { Default = "E", SyncToggleState = false, Mode = "Hold", Text = "Aimbot Key" })
	    ba:AddDropdown("aimbotmethod", { Text = "Aim Method", Values = { "Camera", "Mouse" }, Default = 1, Multi = false })
	    ba:AddSlider("aimbotsmoothness", {
	    	Text = "Smoothness",
	    	Default = 1,
	    	Min = 1,
	    	Max = 20,
	    	Rounding = 1,
	    })

	    local bb = aB.Combat:AddRightGroupbox("Gun Mods")
	    bb:AddSlider("recoilside", { Text = "Recoil X", Default = 0, Min = 0, Max = 1, Rounding = 2 })
	    bb:AddSlider("recoilup", { Text = "Recoil Y", Default = 0, Min = 0, Max = 1, Rounding = 2 })
	    bb:AddSlider("spreadmult", { Text = "Spread Multiplier", Default = 0, Min = 0, Max = 1, Rounding = 2 })
	    bb:AddSlider("fireratemult", { Text = "Firerate", Default = 1, Min = 0.1, Max = 5, Rounding = 2, Suffix = "x" })
	    bb:AddToggle("instantreload", { Text = "Instant Reload", Default = false })
	    bb:AddToggle("nokickback", { Text = "No Kickback", Default = true })
	    bb:AddToggle("shootwhilerunning", { Text = "Run Shoot", Default = false })
	    bb:AddToggle("shootwhilefalling", { Text = "Jump Shoot", Default = false })
	    bb:AddToggle("reloadwhilerunning", { Text = "Run Reload", Default = false })
	    bb:AddToggle("reloadwhilefalling", { Text = "Jump Reload", Default = false })
	    bb:AddToggle("noreloadinterrupt", { Text = "Keep Reloading", Default = true })
	    bb:AddToggle("fullaccuracy", { Text = "Force Accuracy", Default = false })
	    bb:AddToggle("forceauto", { Text = "Force Auto", Default = false })
	    bb:AddToggle("noviewbob", { Text = "No Viewbob", Default = false })

	    local bc = aB.Combat:AddLeftGroupbox("Rage")
	    bc:AddToggle("ragebot", { Text = "Ragebot", Default = false })
	    	:AddKeyPicker("ragebotbind", { Default = "None", SyncToggleState = true, Mode = "Toggle", Text = "Ragebot", Tooltip = "May require you to shoot once before working, idk why lol" })
	    bc:AddToggle("rageallparts", { Text = "Check all parts", Default = false })
	    bc:AddToggle("rageignorefov", { Text = "Ignore FOV", Default = true })
	    bc:AddToggle("ragebotautoreload", { Text = "Auto Reload", Default = true })
	    bc:AddToggle("ragebottraps", { Text = "Shoot Traps", Default = false })
	    bc:AddDropdown("ragetraps", {
	    	Text = "Traps",
	    	Values = ac.aim.trapLabels,
	    	Default = { "Claymore", "Needle Mine", "Proximity Alarm", "Barbed Wire", "Shock Battery", "Incendiary Canister" },
	    	Multi = true,
	    })
	    bc:AddToggle("manipulation", { Text = "Manipulation", Default = false })
	    bc:AddSlider("manipulationdistance", {
	    	Text = "Max Manipulation Distance",
	    	Default = 1,
	    	Min = 0,
	    	Max = 4,
	    	Rounding = 2,
	    	Suffix = " studs",
	    })
	    bc:AddDropdown("manipulationdepth", {
	    	Text = "Scan Depth",
	    	Values = { "Low", "Medium", "High" },
	    	Default = 1,
	    	Multi = false,
	    })
	end

	local a9 = aB.Visuals:AddLeftGroupbox("Tracers")
		a9:AddToggle("tracersenabled", { Text = "Tracers", Default = false })
		a9:AddLabel("Color"):AddColorPicker("tracercolor", { Default = Color3.fromRGB(255, 255, 255), Title = "Tracer" })
		a9:AddDropdown("tracermaterial", {
			Text = "Material",
			Values = { "Neon", "ForceField", "SmoothPlastic", "Plastic", "Glass", "Metal" },
			Default = 1,
			Multi = false,
		})
		a9:AddDropdown("tracertexture", {
			Text = "Texture",
			Values = { "None", "Glow", "Lightning" },
			Default = 1,
			Multi = false,
		})
		a9:AddSlider("tracersize", { Text = "Thickness", Default = 0.12, Min = 0.02, Max = 1, Rounding = 2 })
		a9:AddSlider("tracertransparency", { Text = "Transparency", Default = 0.25, Min = 0, Max = 1, Rounding = 2 })
		a9:AddSlider("tracerlifetime", { Text = "Lifetime", Default = 1, Min = 0.1, Max = 5, Rounding = 1, Suffix = "s" })

	local function b(ba, bb, bc, bd, be)
		LPH_ATTRIBUTES(VM(NONE))
		if not (bb and type(bb.get) == "function") then
			return
		end
		local bf, bg = bc .. "mul", bc .. "inst"
		if ba[bf] == bd and ba[bg] == be then
			return
		end
		local bh = ba[bc]
		if not bh then
			bh = bb.get
			ba[bc] = bh
		end
		ba[bf] = bd
		ba[bg] = be
		if be then
			bb.get = function()
				return 0.01
			end
		elseif bd == 1 then
			bb.get = bh
		else
			bb.get = function(...)
				return bh(...) * bd
			end
		end
	end

	local ba = setmetatable({}, { __mode = "k" })
	local function bb()
		LPH_ATTRIBUTES(VM(NONE))
		local bc = ay()
		local bd = bc and bc.values
		local be = bd and bd.equipped
		if be then
			if ag("fullaccuracy", false) and be.accuracy then
				be.accuracy.Value = 1
			end
			if ag("forceauto", false) then
				if be._vaultAuto == nil then
					be._vaultAuto = be.automatic
				end
				be.automatic = true
			elseif be._vaultAuto ~= nil then
				be.automatic = be._vaultAuto
				be._vaultAuto = nil
			end
			local bf = be.states
			if bf then
				ba[be] = true
				b(be, bf.firerate, "_vaultFirerate", ah("fireratemult", 1), false)
				b(be, bf.reload_speed, "_vaultReloadSpeed", 1, ag("instantreload", false))
			end
		end
		if bd and bd.bob_cframe and ag("noviewbob", false) then
			bd.bob_cframe.Value = CFrame.identity
		end
	end

	local function bc()
		for bd in ba do
			local be = bd.states
			if be then
				if bd._vaultFirerate and be.firerate then
					be.firerate.get = bd._vaultFirerate
				end
				if bd._vaultReloadSpeed and be.reload_speed then
					be.reload_speed.get = bd._vaultReloadSpeed
				end
			end
			if bd._vaultAuto ~= nil then
				bd.automatic = bd._vaultAuto
			end
			bd._vaultFirerate, bd._vaultFireratemul, bd._vaultFirerateinst = nil, nil, nil
			bd._vaultReloadSpeed, bd._vaultReloadSpeedmul, bd._vaultReloadSpeedinst = nil, nil, nil
			bd._vaultAuto = nil
		end
		table.clear(ba)
	end

	local function bd()
		if a1 then
			local be = ay()
			local bf = be and be.values and be.values.equipped
			if bf and bf.input_shoot then
				pcall(bf.input_shoot, bf, false)
			end
			a1 = false
		end
	end

	ac.combat = {
		updateTracers = aZ,
		gunModStep = bb,
		aimbotStep = a0,
		reloadStep = a5,
		rageStep = a8,
		release = bd,
		unload = function()
			bd()
			aY()
			bc()
			if aW then
				aW:Destroy()
			end
		end,
	}

end

function ab.step(ac)
end

function ab.unload()
end

return ab
end function a.k()local ab=a.cache.k if not ab then ab={c=aa()}a.cache.k=ab end return ab.c end end do local function aa()
local ab = a.h()

local ac = {}

function ac.build(ag)
	local ah = ag.tv
	local ai = ag.ov
	local aj = ag.cloneOriginal
	local ak = ag.wrap
	local al = ag.findGcFunction
	local am = ag.Players
	local an = ag.LocalPlayer
	local ao = ag.UserInputService
	local ap = ag.Lighting
	local aq = ag.CollectionService
	local ar = ag.ReplicatedStorage
	local as = ag.Modules
	local at = ag.Gun
	local au = ag.StateObject
	local av = ag.Util
	local aw = ag.Targeting
	local ax = ag.ESP
	local ay = ag.Library
	local az = ag.owner.getLocalOwner
	local aA = ag.owner.getLiveCharacter
	local aB = ag.owner.getViewmodel
	local aC = ag.Tabs

	local aD
	pcall(function()
		aD = require(as.Loadout)
	end)

	local aE, aF = -1, false
	local aG
	local function aH()
		if not (aG and aG.Parent) then
			local aI = an:FindFirstChildOfClass("PlayerGui")
			aG = aI and aI:FindFirstChild("LoadoutMenu")
		end
		if aG and aG:IsA("ScreenGui") and aG.Enabled then
			return true
		end
		if aD and aD.main_menu and aD.main_menu.get then
			local aI, aJ = pcall(aD.main_menu.get, aD.main_menu)
			return aI and aJ == true
		end
		return false
	end
	local function aI()
		local aJ = ag.frame
		if aJ ~= aE then
			aE = aJ
			aF = aH()
		end
		return aF
	end
	local aJ = {}
	local aK = {}
	local function aL(aM)
		LPH_ATTRIBUTES(VM(NONE))
		if typeof(aM) ~= "Instance" then
			return
		end
		local aN = os.clock()
		local aO = aJ[aM]
		if not aO or (aK[aM] or 0) + 0.5 < aN or not aM.Parent then
			aO = {}
			if aM:IsA("BasePart") or aM:IsA("Decal") then
				aO[1] = aM
			end
			for aP, aQ in aM:GetDescendants() do
				if aQ:IsA("BasePart") or aQ:IsA("Decal") then
					aO[#aO + 1] = aQ
				end
			end
			aJ[aM] = aO
			aK[aM] = aN
		end
		for aP, aQ in aO do
			if aQ.Parent and aQ.LocalTransparencyModifier > 0.9 then
				aQ.LocalTransparencyModifier = 0
			end
		end
	end

	local function aM(aN)
		LPH_ATTRIBUTES(VM(NONE))
		if not aN then
			return
		end
		local aO = az()
		local aP = aO and aO.values and aO.values.viewmodels
		if typeof(aP) ~= "Instance" then
			local aQ = workspace:FindFirstChild("Viewmodels")
			aP = aQ and aQ:FindFirstChild("LocalViewmodel")
		end
		if typeof(aP) == "Instance" then
			aL(aP)
		end
		aL(an.Character)
		if aO and typeof(aO.instance) == "Instance" then
			aL(aO.instance)
		end
	end
	local aN = Drawing.new("Circle")
	aN.Filled = false
	aN.NumSides = 64
	aN.Visible = false

	local aO = Drawing.new("Line")
	aO.Visible = false

	local aP = Drawing.new("Text")
	aP.Text = "x"
	aP.Size = 24
	aP.Center = true
	aP.Outline = true
	aP.Color = Color3.fromRGB(255, 255, 255)
	aP.Visible = false
	local aQ = 0
	local function aR()
		local aS = ag.Camera.ViewportSize
		aP.Position = Vector2.new(aS.X / 2, aS.Y / 2)
		aP.Visible = true
		aQ = os.clock() + 0.12
	end
	local function aS()
		LPH_ATTRIBUTES(VM(NONE))
		local aT = ag.Camera.ViewportSize
		aN.Position = Vector2.new(aT.X / 2, aT.Y / 2)
		aN.Radius = ai("silentfovsize", 100)
		aN.Color = ai("silentfovcolor", Color3.fromRGB(255, 255, 255))
		aN.Thickness = ai("silentfovthickness", 1)
		aN.Visible = ah("silentfovenabled", false) and ah("silentfovdraw", true)
	end

	local function aT()
		LPH_ATTRIBUTES(VM(NONE))
		local aU = ag.aim.cache.target
		local aV = aU and aU.Part
		if not (ah("snaplines", false) and aV and aV.Parent) then
			aO.Visible = false
			return
		end
		local aW, aX, aY = ag.aim.projectScreen(aU.AimPoint or aV.Position)
		if not aW then
			aO.Visible = false
			return
		end
		if ah("silentfovenabled", false) and not ah("ragebot", false) and aY > ai("silentfovsize", 100) then
			aO.Visible = false
			return
		end
		local aZ = Vector2.new(ag.Camera.ViewportSize.X / 2, ag.Camera.ViewportSize.Y / 2)
		aO.From = aZ
		aO.To = Vector2.new(aX.X, aX.Y)
		aO.Color = ai("snapcolor", Color3.fromRGB(255, 0, 0))
		aO.Thickness = ai("snapwidth", 1)
		aO.Visible = true
	end
	    ax:Load({ Enabled = false, Players = false, LocalPlayer = false })
	    local aU = ax:GetConfig()

	    local function aV()
	    	local aW = aU
	    	if not aW then
	    		return
	    	end

	    	
	    	aW.Enabled = Toggles.ESPMaster.Value
	    	aW.LocalPlayer = false 
	    	aW.MaxDistance = Options.ESPMaxDistance.Value
	    	aW.DynamicBoxes = true 
	     	aW.DynamicBoxesCheap = true
	    	aW.DynamicBoxesIncludeAll = false
	    	aW.Filter = function(aX, aY)
	    	    if not aX or not aY then
	    			return false
	    		end

	    		if not ah("ESPFilterTeam", false) then
	    			return true
	    		end

	    		return not aw:is_friendly(aY)
	    	end

	    	
	    	aW.Boxes = Toggles.ESPBoxes.Value
	    	aW.BoxType = Options.ESPBoxType.Value
	    	aW.BoxColor = Options.ESPBoxColor.Value
	    	aW.BoxThickness = Options.ESPBoxThickness.Value
	    	aW.Outlines.Style = Toggles.ESPBoxOutline.Value and "Full" or "None"
	    	aW.Outlines.Color = Options.ESPBoxOutlineColor.Value

	    	
	    	aW.BoxFill.Enabled = Toggles.ESPBoxFill.Value
	    	aW.BoxFill.Color = Options.ESPBoxFillColor.Value
	    	aW.BoxFill.Transparency = Options.ESPBoxFillTransparency.Value

	    	
	    	aW.Names = Toggles.ESPNames.Value
	    	aW.TextColor = Options.ESPNameColor.Value
	    	aW.TextSize = Options.ESPTextSize.Value
	    	aW.TextOutline = Toggles.ESPTextOutline.Value
	    	aW.Distance.Enabled = Toggles.ESPDistance.Value
	    	aW.Distance.Color = Options.ESPDistanceColor.Value
	    	aW.Weapon.Enabled = Toggles.ESPWeapon.Value
	    	aW.Weapon.UseToolFallback = true 
	    	aW.TeamIndicator.Enabled = false
	    	aW.FriendlyIndicator.Enabled = false
	    	aW.FriendlyIndicator.CheckTeam = false
	    	aW.FriendlyIndicator.CheckFriends = false

	    	
	    	aW.HealthBar.Enabled = Toggles.ESPHealth.Value
	    	aW.HealthBar.ShowText = true

	    	
	    	
	    	aW.Chams.Enabled = Toggles.ESPChams.Value
	    	aW.Chams.Type = Options.ESPChamsType.Value

	    	local aX = Options.ESPChamsFill.Value
	    	local aY = Options.ESPChamsFillT.Value
	    	local aZ = Options.ESPChamsOutline.Value
	    	local a_ = Options.ESPChamsOutlineT.Value
	    	local a0 = Toggles.ESPChamsVisible.Value

	    	aW.Chams.Highlight.FillColor = aX
	    	aW.Chams.Highlight.FillTransparency = aY
	    	aW.Chams.Highlight.OutlineColor = aZ
	    	aW.Chams.Highlight.OutlineTransparency = a_
	    	aW.Chams.Highlight.VisibleCheck = a0

	    	aW.Chams.MeshChams.FillColor = aX
	    	aW.Chams.MeshChams.FillTransparency = aY
	    	aW.Chams.MeshChams.OutlineColor = aZ
	    	aW.Chams.MeshChams.OutlineTransparency = a_
	    	aW.Chams.MeshChams.VisibleCheck = a0

	    	aW.Chams.Adornment.Color = aX
	    	aW.Chams.Adornment.Transparency = aY
	    	aW.Chams.Adornment.VisibleCheck = a0

	    	
	    	aW.OffScreenArrows.Enabled = Toggles.ESPArrows.Value
	    	aW.OffScreenArrows.Color = Options.ESPArrowColor.Value
	    	aW.OffScreenArrows.Size = Options.ESPArrowSize.Value
	    	aW.Directories = {}
	    end
	local aW = ag.gc.render_bobbing
	if aW then
		local aX
		aX = ag.hook(aW, function(aY, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if type(aY) ~= "table" then
				return
			end
			if ah("noviewbob", false) then
				if aY and aY.values and aY.values.bob_cframe then
					aY.values.bob_cframe.Value = CFrame.new()
				end
				return
			end
			return aX(aY, ...)
		end)
	end
	local aX, aY
	local function aZ(a_, a0, a1)
		LPH_ATTRIBUTES(VM(NONE))
		if a_ and a_.Parent then
			return a_
		end
		local a2 = Instance.new("Highlight")
		a2.Name = a0
		a2.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		a2.Parent = a1 or (gethui and gethui()) or game:GetService("CoreGui")
		return a2
	end

	local a_ = {}
	local a0 = {}
	local a1 = {}
	local function a2(a3)
		LPH_ATTRIBUTES(VM(NONE))
		if typeof(a3) ~= "Instance" then
			return nil
		end
		local a4 = os.clock()
		local a5 = a_[a3]
		if a5 and (a0[a3] or 0) + 0.25 >= a4 and a3.Parent then
			return a5
		end
		ab.begin("chams.list")
		a5 = {}
		if a3:IsA("BasePart") then
			a5[1] = a3
		end
		for a6, a7 in a3:GetDescendants() do
			if a7:IsA("BasePart") then
				a5[#a5 + 1] = a7
			end
		end
		a_[a3] = a5
		a0[a3] = a4
		ab.stop()
		return a5
	end
	local function a3(a4, a5, a6, a7)
		if a7 and (a4 == a7 or a4:IsDescendantOf(a7)) then
			return true
		end
		if a5 and a5[a4.Name] then
			return true
		end
		if a6 and not a6[a4.Name] then
			return true
		end
		return false
	end
	local function a4(a5, a6, a7, a8, a9, b, ba)
		LPH_ATTRIBUTES(VM(NONE))
		local bb = a2(a5)
		if not bb then
			return
		end
		local bc = Enum.Material[a6] or Enum.Material.ForceField
		ab.begin("chams.write")
		for bd, be in bb do
			if not be.Parent or a3(be, a9, b, ba) then
				continue
			end
			if not a1[be] then
				a1[be] = {
					Material = be.Material,
					Color = be.Color,
					LocalTransparencyModifier = be.LocalTransparencyModifier,
				}
			end
			if be.Material ~= bc then
				be.Material = bc
			end
			if be.Color ~= a7 then
				be.Color = a7
			end
			if be.LocalTransparencyModifier ~= a8 then
				be.LocalTransparencyModifier = a8
			end
		end
		ab.stop()
	end
	local function a5(a6, a7)
		LPH_ATTRIBUTES(VM(NONE))
		local a8 = a_[a6]
		if not a8 then
			return
		end
		for a9, b in a8 do
			if a7 and b.Parent and (b == a7 or b:IsDescendantOf(a7)) then
				continue
			end
			local ba = a1[b]
			if ba and b.Parent then
				b.Material = ba.Material
				b.Color = ba.Color
				b.LocalTransparencyModifier = ba.LocalTransparencyModifier
			end
			a1[b] = nil
		end
	end

	local a6 = {
		head = true, torso = true, arm1 = true, arm2 = true, leg1 = true, leg2 = true,
		shoulder1 = true, shoulder2 = true, hip1 = true, hip2 = true,
	}
	local a7
	local a8 = {}
	local a9 = {}
	local function b(ba)
		LPH_ATTRIBUTES(VM(NONE))
		local bb = a8[ba]
		if bb and not bb.Parent then
			bb = nil
			a8[ba] = nil
		end
		if not bb then
			local bc = os.clock()
			if (a9[ba] or 0) > bc then
				return
			end
			local bd = an:FindFirstChild("PlayerGui")
			bb = bd and bd:FindFirstChild(ba)
			a8[ba] = bb
			if not bb then
				a9[ba] = bc + 1
				return
			end
		end
		if bb:IsA("ScreenGui") then
			bb.Enabled = false
		elseif bb:IsA("GuiObject") then
			bb.Visible = false
			bb.BackgroundTransparency = 1
		end
	end
	local ba
	local function bb()
		LPH_ATTRIBUTES(VM(NONE))
		ab.begin("visuals.hitmarker")
		if aQ > 0 and os.clock() > aQ then
			aP.Visible = false
			aQ = 0
		end
		ab.stop()

		ab.begin("visuals.fov")
		if ah("customfov", false) then
			if a7 == nil then
				a7 = ag.Camera.FieldOfView
			end
			ag.Camera.FieldOfView = ai("customfovvalue", 90)
		elseif a7 ~= nil then
			ag.Camera.FieldOfView = a7
			a7 = nil
		end
		ab.stop()

		ab.begin("visuals.overlays")
		if ah("noflash", false) then
			b("Flash")
		end
		if ah("nostun", false) then
			b("Stun")
			b("Deaf")
			b("Ring")
		end
		ab.stop()

	end
	local function bc(bd)
		for be, bf in bd:GetChildren() do
			if bf.Name == "Model" and bf:FindFirstChild("torso") then
				return bf
			end
		end
		return nil
	end
	local function bd(be)
		if typeof(be) ~= "Instance" then
			return nil
		end
		for bf, bg in be:GetChildren() do
			if bg:IsA("Model") and bg:FindFirstChild("Root") then
				return bg
			end
		end
		return nil
	end
	ba = function()
		LPH_ATTRIBUTES(VM(NONE))
		ab.begin("chams.find")
		local be = workspace:FindFirstChild("Viewmodels")
		local bf = be and be:FindFirstChild("LocalViewmodel")
		local bg = ah("wepchams", false)
		local bh = ah("vmchams", false)
		local bi = az()
		local bj = bi and bi.values and bi.values.equipped
		local bk = bd(bf) or (bj and bj.instance)
		local bl = bf and bc(bf)
		ab.stop()
		if not bh then
			ab.begin("chams.restoreVm")
			a5(bf, bg and bk or nil)
			if aX then
				aX.Enabled = false
			end
			ab.stop()
		end
		if not bg then
			ab.begin("chams.restoreWep")
			a5(bk)
			if aY then
				aY.Enabled = false
			end
			ab.stop()
		end
		if bh and bf then
			ab.begin("chams.vm")
			if aX then
				aX.Enabled = false
			end
			a4(bf, ai("vmmaterial", "ForceField"), ai("vmchamcolor", Color3.fromRGB(59, 144, 204)), ai("vmtransparency", 0.4), nil, nil, bk)
			if bl then
				aX = aZ(aX, "vault_vmcham", bl)
				aX.Adornee = bl
				aX.FillColor = ai("vmchamcolor", Color3.fromRGB(59, 144, 204))
				aX.FillTransparency = ai("vmtransparency", 0.4)
				aX.OutlineTransparency = 1
				aX.Enabled = true
			end
			ab.stop()
		end
		if bg and typeof(bk) == "Instance" then
			ab.begin("chams.wep")
			aY = aZ(aY, "vault_wepcham", bk)
			aY.Adornee = bk
			aY.FillColor = ai("wepchamcolor", Color3.fromRGB(255, 255, 255))
			aY.FillTransparency = ai("weptransparency", 0.3)
			aY.OutlineTransparency = 1
			aY.Enabled = true
			a4(bk, ai("wepmaterial", "ForceField"), ai("wepchamcolor", Color3.fromRGB(255, 255, 255)), ai("weptransparency", 0.3), a6)
			ab.stop()
		end
	end
	local be = ag.gc.attach_camera

	local bf
	local bg
	local bh = 0
	local function bi()
		LPH_ATTRIBUTES(VM(NONE))
		if aI() then
			bg = nil
			return
		end
		local bj = ag.Camera
		local bk = az()
		local bl = bk and bk.values and bk.values.viewmodels
		if not bj or typeof(bl) ~= "Instance" then
			return
		end
		local bm = os.clock()
		local bn = bm - bh
		bh = bm
		if bn < 0 or bn > 0.2 then
			bn = 0.016
		end
		local bo = bj.CFrame.LookVector
		if not bg or bg.Magnitude < 0.001 then
			bg = bo
		end
		bg = bg:Lerp(bo, 1 - math.exp(-8 * bn))
		if bg.Magnitude < 0.001 then
			return
		end
		bg = bg.Unit
		local bp = Vector3.new(bg.X, 0, bg.Z)
		if bp.Magnitude < 0.001 then
			bp = Vector3.new(bj.CFrame.LookVector.X, 0, bj.CFrame.LookVector.Z)
		end
		if bp.Magnitude < 0.001 then
			return
		end
		local bq = bl:FindFirstChild("torso")
		if not bq then
			return
		end
		local br, bs = bq:GetPivot():ToOrientation()
		local bt, bu = CFrame.lookAt(Vector3.zero, bp.Unit):ToOrientation()
		local bv = math.atan2(math.sin(bu - bs), math.cos(bu - bs))
		if math.abs(bv) < 0.02 then
			return
		end
		local bw = CFrame.new(bq:GetPivot().Position)
		local bx = bw * CFrame.Angles(0, bv, 0) * bw:Inverse()
		local by = bl:FindFirstChild("head")
		if by and by:IsA("BasePart") then
			by:PivotTo(bx * by:GetPivot())
		end
		by = bl:FindFirstChild("head")
		if by then
			local bz = by:GetPivot().Position
			by:PivotTo(CFrame.lookAt(bz, bz + bg))
		end
	end
	local function bj()
		LPH_ATTRIBUTES(VM(NONE))
		local bk = az()
		if bk then
			local bl = bk.values and bk.values.equipped
			if bl and typeof(bl.shot) == "Instance" then
				bf = bl.shot.CFrame
				return bf
			end
			if not ah("antiaim", false) then
				local bm = bk.states and bk.states.look
				local bn = bm and bm.get and bm:get()
				local bo = bk.instance
				local bp = typeof(bo) == "Instance" and (bo:FindFirstChild("head") or bo:FindFirstChild("Head"))
				if bp and typeof(bn) == "Vector3" and bn.Magnitude > 0.001 then
					bf = CFrame.lookAt(bp.Position, bp.Position + bn)
					return bf
				end
			end
		end
		return bf or ag.Camera.CFrame
	end

	local function bk(bl)
		if not bl or not bl:IsA("BasePart") then
			return
		end
		bl.LocalTransparencyModifier = 0
		if bl.Transparency > 0.9 then
			bl.Transparency = bl:GetAttribute("OriginalTransparency") or 0
		end
	end
	local function bl()
		LPH_ATTRIBUTES(VM(NONE))
		ag.Camera = workspace.CurrentCamera
		if not ah("thirdperson", false) or aI() or not ag.Camera then
			return
		end
		local bm = az()
		local bn = bm and bm.instance
		local bo = typeof(bn) == "Instance" and (bn:FindFirstChild("HumanoidRootPart") or bn:FindFirstChild("Root"))
		if not bo then
			return
		end
		local bp = ag.Camera.CFrame.Position
		local bq = Vector3.new(bp.X - bo.Position.X, 0, bp.Z - bo.Position.Z)
		if bq.Magnitude <= 1.5 then
			return
		end
		local bs = bo.Position.Y + 1.6
		local bt = bm.states and bm.states.walk_state and bm.states.walk_state.get and bm.states.walk_state:get()
		if bt == "crouch" then
			bs = bo.Position.Y + 0.8
		elseif bt == "prone" then
			bs = bo.Position.Y + 0.35
		end
		ag.Camera.CFrame = CFrame.new(bo.Position.X, bs, bo.Position.Z) * ag.Camera.CFrame.Rotation
	end
	local function bm()
		LPH_ATTRIBUTES(VM(NONE))
		ag.Camera = workspace.CurrentCamera
		local bn = ah("thirdperson", false)
		local bo = aI()
		local bp = ao.TouchEnabled and not ao.KeyboardEnabled
		if not (bn and not bo) then
			if bp and ag._tpCamMode then
				an.CameraMode = ag._tpCamMode
				ag._tpCamMode = nil
			end
			bf = ag.Camera.CFrame
			return
		end
		if bp then
			if not ag._tpCamMode then
				ag._tpCamMode = an.CameraMode
			end
			an.CameraMode = Enum.CameraMode.Classic
		end
		local bq = ag.Camera.CFrame
		bf = bq
		bi()
		local bs = bq:VectorToWorldSpace(Vector3.new(0, ai("tpheight", 2), ai("tpdistance", 8)))
		local bt = bq.Position + bs
		ag.Camera.CFrame = CFrame.new(bt) * bq.Rotation
		aM(true)
	end

	if be then
		local bn
		bn = ag.hook(be, function(...)
			LPH_ATTRIBUTES(VM(NONE))
			local bo, bp, bq, bs = pcall(bn, ...)
			if bo then
				bf = workspace.CurrentCamera.CFrame
			end
			if not bo then
				warn(bp)
				return
			end
			return bp, bq, bs
		end)
	end

	local bn = ag.gc.can_climb
	if bn then
		local bo
		bo = ag.hook(bn, function(bp, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if not ah("thirdperson", false) or not bf or type(bp) ~= "table" then
				return bo(bp, ...)
			end
			local bq = bp.values and bp.values.camera and bp.values.camera.get and bp.values.camera:get()
			if typeof(bq) ~= "Instance" then
				return bo(bp, ...)
			end
			local bs = bq.CFrame
			local bt = bp.values and bp.values.viewmodels
			local bu = {}
			if typeof(bt) == "Instance" then
				for bv, bw in bt:GetDescendants() do
					if bw:IsA("BasePart") then
						bu[bw] = bw.CanQuery
						bw.CanQuery = false
					end
				end
			end
			bq.CFrame = bf
			local bv, bw, bx, by = pcall(bo, bp, ...)
			bq.CFrame = bs
			for bz, bA in bu do
				bz.CanQuery = bA
			end
			if not bv then
				return
			end
			return bw, bx, by
		end)
	end

	if type(at.send_melee) == "function" then
		local bo
		bo = ag.hook(at.send_melee, function(bp, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if not (ah("thirdperson", false) and bf) then
				return bo(bp, ...)
			end
			if type(bp) ~= "table" or not bp.states then
				return bo(bp, ...)
			end
			local bq = bj()
			pcall(function()
				bp.states.melee:fire_instant()
			end)
			local bs = bp.owner
			local bt = (tonumber(bp.melee_range) or 2.75) + 0.2
			if bp.client_sided_hitscan and bs then
				local bu = bp:ray_damage(bq.Position - bq.LookVector * 0.2, bq.LookVector * bt, { bs.values.viewmodels, bs.instance }, 0.2)
				bp.states.hit:fire(bq, bu)
			else
				bp.states.hit:fire(bq)
			end
		end)
	end

	    
	    local bo = aC.ESP:AddLeftGroupbox("Main")
	    bo:AddToggle("ESPMaster", { Text = "Enabled", Default = false })
	    bo:AddToggle(
	    	"ESPFilterTeam",
	    	{ Text = "Exclude Teammates", Default = false }
	    )
	    bo:AddSlider(
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

	    
	    local bp = aC.ESP:AddLeftGroupbox("Boxes")
	    bp:AddToggle("ESPBoxes", { Text = "Boxes", Default = true })
	    bp:AddDropdown("ESPBoxType", { Text = "Box type", Values = { "Normal", "Corner" }, Default = 1, Multi = false })
	    bp
	    	:AddLabel("Box color")
	    	:AddColorPicker("ESPBoxColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Box color" })
	    bp:AddSlider("ESPBoxThickness", { Text = "Box thickness", Default = 1, Min = 1, Max = 6, Rounding = 0 })
	    bp:AddToggle("ESPBoxOutline", { Text = "Box outline", Default = true })
	    bp
	    	:AddLabel("Outline color")
	    	:AddColorPicker("ESPBoxOutlineColor", { Default = Color3.fromRGB(0, 0, 0), Title = "Outline color" })
	    bp:AddDivider()
	    bp:AddToggle("ESPBoxFill", { Text = "Box fill", Default = false })
	    bp
	    	:AddLabel("Fill color")
	    	:AddColorPicker("ESPBoxFillColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Fill color" })
	    bp:AddSlider(
	    	"ESPBoxFillTransparency",
	    	{ Text = "Fill transparency", Default = 0.9, Min = 0, Max = 1, Rounding = 2 }
	    )

	    
	    local bq = aC.ESP:AddLeftGroupbox("Chams")
	    bq:AddToggle("ESPChams", { Text = "Chams", Default = false })
	    bq:AddDropdown(
	    	"ESPChamsType",
	    	{
	    		Text = "Chams type",
	    		Values = { "Highlight", "Adornment", "MeshChams" },
	     		Default = 1,
	     		Multi = false,
	     	}
	    )
	    bq
	    	:AddLabel("Fill color")
	    	:AddColorPicker("ESPChamsFill", { Default = Color3.fromRGB(59, 144, 204), Title = "Cham fill" })
	    bq:AddSlider("ESPChamsFillT", { Text = "Fill transparency", Default = 0.6, Min = 0, Max = 1, Rounding = 2 })
	    bq
	    	:AddLabel("Outline color")
	    	:AddColorPicker("ESPChamsOutline", { Default = Color3.fromRGB(255, 255, 255), Title = "Cham outline" })
	    bq:AddSlider("ESPChamsOutlineT", { Text = "Outline transparency", Default = 0, Min = 0, Max = 1, Rounding = 2 })
	    bq:AddToggle(
	    	"ESPChamsVisible",
	    	{ Text = "Visible check", Default = false }
	    )

	    
	    local bs = aC.ESP:AddRightGroupbox("Names & Info")
	    bs:AddToggle("ESPNames", { Text = "Names", Default = true })
	    bs
	    	:AddLabel("Name color")
	    	:AddColorPicker("ESPNameColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Name color" })
	    bs:AddSlider("ESPTextSize", { Text = "Text size", Default = 12, Min = 6, Max = 28, Rounding = 0 })
	    bs:AddToggle("ESPTextOutline", { Text = "Text outline", Default = true })
	    bs:AddDivider()
	    bs:AddToggle("ESPDistance", { Text = "Distance", Default = false })
	    bs
	    	:AddLabel("Distance color")
	    	:AddColorPicker("ESPDistanceColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Distance color" })
	    bs:AddToggle("ESPWeapon", { Text = "Weapon", Default = false })

	    
	    local bt = aC.ESP:AddRightGroupbox("Health")
	    bt:AddToggle("ESPHealth", { Text = "Health", Default = false })

	    
	    local bu = aC.ESP:AddRightGroupbox("OOF Arrows")
	    bu:AddToggle("ESPArrows", { Text = "Off-screen arrows", Default = false })
	    bu
	    	:AddLabel("Arrow color")
	    	:AddColorPicker("ESPArrowColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Arrow color" })
	    bu:AddSlider("ESPArrowSize", { Text = "Arrow size", Default = 14, Min = 8, Max = 40, Rounding = 0 })

	    
	    
	    local bv = {
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
	    local bw = {
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

	    for bx, by in ipairs(bv) do
	    	Toggles[by]:OnChanged(aV)
	    end
	    for bx, by in ipairs(bw) do
	    	Options[by]:OnChanged(aV)
	    end

	    aV()
		local bx = aC.Visuals:AddLeftGroupbox("Viewmodel")
		bx:AddToggle("vmchams", { Text = "Viewmodel Chams", Default = false })
			:AddColorPicker("vmchamcolor", { Default = Color3.fromRGB(59, 144, 204), Title = "Viewmodel" })
		bx:AddDropdown("vmmaterial", {
			Text = "Material",
			Values = { "ForceField", "Neon", "SmoothPlastic", "Plastic", "Glass", "Metal" },
			Default = 1,
			Multi = false,
		})
		bx:AddSlider("vmtransparency", { Text = "Transparency", Default = 0.4, Min = 0, Max = 1, Rounding = 2 })
		bx:AddToggle("wepchams", { Text = "Weapon Chams", Default = false })
			:AddColorPicker("wepchamcolor", { Default = Color3.fromRGB(255, 255, 255), Title = "Weapon" })
		bx:AddDropdown("wepmaterial", {
			Text = "Weapon Material",
			Values = { "ForceField", "Neon", "SmoothPlastic", "Plastic", "Glass", "Metal" },
			Default = 1,
			Multi = false,
		})
		bx:AddSlider("weptransparency", { Text = "Weapon Transparency", Default = 0.3, Min = 0, Max = 1, Rounding = 2 })

		local by = aC.Visuals:AddRightGroupbox("Camera")
		by:AddToggle("customfov", { Text = "Custom FOV", Default = false })
		by:AddSlider("customfovvalue", { Text = "FOV", Default = 90, Min = 40, Max = 120, Rounding = 0 })
		by:AddToggle("thirdperson", { Text = "Third Person", Default = false })
			:AddKeyPicker("thirdpersonbind", { Default = "None", SyncToggleState = true, Mode = "Toggle", Text = "Third Person" })
		by:AddSlider("tpdistance", { Text = "Distance", Default = 8, Min = 2, Max = 20, Rounding = 1 })
		by:AddSlider("tpheight", { Text = "Height", Default = 2, Min = 0, Max = 8, Rounding = 1 })
		by:AddToggle("noflash", { Text = "No Flash", Default = false })
		by:AddToggle("nostun", { Text = "No Stun", Default = false })

	local function bz()
		if aN then
			aN:Remove()
			aN = nil
		end
		if aO then
			aO:Remove()
			aO = nil
		end
		if aP then
			aP:Remove()
			aP = nil
		end
		if aX then
			aX:Destroy()
			aX = nil
		end
		if aY then
			aY:Destroy()
			aY = nil
		end
	end

	ag.visuals = {
		updateFOV = aS,
		updateSnap = aT,
		step = bb,
		applyThirdPerson = bm,
		prepareThirdPerson = bl,
		applyChams = function()
			if ba then
				ba()
			end
		end,
		applyESP = aV,
		unload = bz,
	}
	ac.step = bb
	ac.unload = bz

end

function ac.step(ag)
end

function ac.unload()
end

return ac
end function a.l()local ab=a.cache.l if not ab then ab={c=aa()}a.cache.l=ab end return ab.c end end do local function aa()
local ab = a.h()

local ac = {}

function ac.build(ag)
	local ah = ag.tv
	local ai = ag.ov
	local aj = ag.cloneOriginal
	local ak = ag.wrap
	local al = ag.findGcFunction
	local am = ag.Players
	local an = ag.LocalPlayer
	local ao = ag.UserInputService
	local ap = ag.Lighting
	local aq = ag.CollectionService
	local ar = ag.ReplicatedStorage
	local as = ag.Modules
	local at = ag.Gun
	local au = ag.StateObject
	local av = ag.Util
	local aw = ag.Targeting
	local ax = ag.ESP
	local ay = ag.Library
	local az = ag.owner.getLocalOwner
	local aA = ag.owner.getLiveCharacter
	local aB = ag.owner.getViewmodel
	local aC = ag.Tabs

	local aD = ag.aim.trapTypes
	local aE = ag.aim.gadgetTypes
	local aF
	local function aG()
		if aF then
			return
		end
		aF = {
			Brightness = ap.Brightness,
			ClockTime = ap.ClockTime,
			GlobalShadows = ap.GlobalShadows,
			Ambient = ap.Ambient,
			OutdoorAmbient = ap.OutdoorAmbient,
		}
	end

	local function aH()
		if not aF then
			return
		end
		ap.Brightness = aF.Brightness
		ap.ClockTime = aF.ClockTime
		ap.GlobalShadows = aF.GlobalShadows
		ap.Ambient = aF.Ambient
		ap.OutdoorAmbient = aF.OutdoorAmbient
	end

	local aI = {
		{ toggle = "ESPCameras", color = "ESPCameraColor", default = Color3.fromRGB(255, 220, 80), tags = { "DefaultCamera", "BulletproofCamera", "StickyCamera" }, label = "Camera" },
		{ toggle = "ESPDrones", color = "ESPDroneColor", default = Color3.fromRGB(80, 200, 255), tags = { "Drone" }, label = "Drone" },
	}
	for aJ, aK in aD do
		aI[#aI + 1] = {
			toggle = "ESP" .. aK.tag,
			color = "ESP" .. aK.tag .. "Color",
			default = Color3.fromRGB(255, 80, 80),
			tags = { aK.tag },
			label = aK.label,
		}
	end
	for aJ, aK in aE do
		aI[#aI + 1] = {
			toggle = "ESP" .. aK.tag,
			color = "ESP" .. aK.tag .. "Color",
			default = Color3.fromRGB(255, 160, 60),
			tags = { aK.tag },
			label = aK.label,
		}
	end

	local aJ = {}
	local aK = 0

	local function aL()
		aK += 1
		local aM = aJ[aK]
		if not aM then
			aM = Drawing.new("Text")
			aM.Center = true
			aM.Outline = true
			aM.Size = 13
			aJ[aK] = aM
		end
		return aM
	end

	local function aM()
		for aN = aK + 1, #aJ do
			aJ[aN].Visible = false
		end
	end

	local function aN()
		for aO, aP in aJ do
			aP:Remove()
		end
		table.clear(aJ)
		aK = 0
	end

	local function aO(aP)
		if aP:IsA("BasePart") then
			if aP.Transparency < 1 and aP.Size.Magnitude > 0.05 then
				return aP
			end
			return nil
		end
		local aQ = aP:IsA("Model") and aP.PrimaryPart
		if aQ and aQ.Transparency < 1 then
			return aQ
		end
		for aR, aS in aP:GetChildren() do
			if aS:IsA("BasePart") and aS.Transparency < 1 and aS.Size.Magnitude > 0.05 then
				return aS
			end
		end
		return nil
	end

	local function aP(aQ)
		local aR = aQ:FindFirstChild("Root")
		if aR and aR:IsA("BasePart") then
			return aR
		end
		if aQ:IsA("Model") and aQ.PrimaryPart then
			return aQ.PrimaryPart
		end
		if aQ:IsA("BasePart") then
			return aQ
		end
		return nil
	end

	local function aQ(aR)
		if not aR or not aR.Parent then
			return false
		end
		local aS = aR.Parent
		if aS.Name == "Garbage" or aS == ar then
			return false
		end
		if aR:GetAttribute("Destroyed") or aS:GetAttribute("Destroyed") then
			return false
		end
		local aT = aR:FindFirstChild("ClientModel")
		if aT and aT:IsA("ObjectValue") then
			local aU = aT.Value
			if typeof(aU) == "Instance" and aU.Parent and aU ~= aR then
				local aV = aU.Parent
				if aV.Name ~= "Garbage" and aV ~= ar and not aU:GetAttribute("Destroyed") then
					return aP(aU) or aO(aU)
				end
			end
		end
		local aU = aO(aR)
		if aU then
			return aU
		end
		if aR:HasTag("Thrown") then
			return aP(aR)
		end
		return false
	end

	local aR, aS = {}, 0
	local function aT()
		LPH_ATTRIBUTES(VM(NONE))
		ab.begin("world.espStep")
		aK = 0
		if not ah("ESPWorld", false) then
			aM()
			ab.stop()
			return
		end

		local aU = ai("ESPMaxDistance", 0)
		if aU <= 0 then
			aU = math.huge
		end
		local aV = ag.Camera.CFrame.Position
		local aW = os.clock()
		if aW - aS > 0.35 then
			aS = aW
			table.clear(aR)
			for aX, aY in aI do
				if not ah(aY.toggle, false) then
					continue
				end
				for aZ, a_ in aY.tags do
					aR[a_] = aq:GetTagged(a_)
				end
			end
		end

		for aX, aY in aI do
			if not ah(aY.toggle, false) then
				continue
			end
			local aZ = ai(aY.color, aY.default)
			for a_, a0 in aY.tags do
				local a1 = aR[a0]
				if not a1 then
					continue
				end
				for a2, a3 in a1 do
					if aK >= 60 then
						break
					end
					local a4 = aQ(a3)
					if not a4 then
						continue
					end
					local a5 = (aV - a4.Position).Magnitude
					if a5 > aU then
						continue
					end
					local a6, a7 = ag.Camera:WorldToViewportPoint(a4.Position)
					if not a7 or a6.Z <= 0 then
						continue
					end
					local a8 = aL()
					a8.Text = `{aY.label} [{math.floor(a5)}]`
					a8.Position = Vector2.new(a6.X, a6.Y)
					a8.Color = aZ
					a8.Visible = true
				end
			end
		end
		aM()
		ab.stop()
	end
	local aU
	local aV = {
		Night = "rbxassetid://12064107",
		Nebula = "rbxassetid://159454286",
		Sunset = "rbxassetid://151165214",
	}
	local function aW()
		LPH_ATTRIBUTES(VM(NONE))
			if ah("fullbright", false) then
				aG()
				ap.Brightness = ai("worldbrightness", 2)
				ap.ClockTime = 12
				ap.GlobalShadows = ah("worldshadows", false)
				ap.Ambient = ai("worldambient", Color3.fromRGB(255, 255, 255))
				ap.OutdoorAmbient = ai("worldoutdoor", Color3.fromRGB(255, 255, 255))
			elseif aF then
				aH()
				aF = nil
			end

			if ah("customsky", false) then
				local aX = ap:FindFirstChildOfClass("Sky")
				if aX then
					if not aU then
						aU = { Bk = aX.SkyboxBk, Dn = aX.SkyboxDn, Ft = aX.SkyboxFt, Lf = aX.SkyboxLf, Rt = aX.SkyboxRt, Up = aX.SkyboxUp }
					end
					local aY = aV[ai("skybox", "Default")]
					if aY then
						aX.SkyboxBk, aX.SkyboxDn, aX.SkyboxFt, aX.SkyboxLf, aX.SkyboxRt, aX.SkyboxUp = aY, aY, aY, aY, aY, aY
					end
				end
			elseif aU then
				local aX = ap:FindFirstChildOfClass("Sky")
				if aX then
					aX.SkyboxBk, aX.SkyboxDn, aX.SkyboxFt, aX.SkyboxLf, aX.SkyboxRt, aX.SkyboxUp =
						aU.Bk, aU.Dn, aU.Ft, aU.Lf, aU.Rt, aU.Up
				end
				aU = nil
			end
	end
	    local aX = aC.ESP:AddRightGroupbox("World")
	    aX:AddToggle("ESPWorld", { Text = "World ESP", Default = false })
	    aX:AddToggle("ESPCameras", { Text = "Cameras", Default = true })
	    	:AddColorPicker("ESPCameraColor", { Default = Color3.fromRGB(255, 220, 80), Title = "Cameras" })
	    aX:AddToggle("ESPDrones", { Text = "Drones", Default = true })
	    	:AddColorPicker("ESPDroneColor", { Default = Color3.fromRGB(80, 200, 255), Title = "Drones" })

	    local aY = aC.ESP:AddRightGroupbox("Traps")
	    for aZ, a_ in aD do
	    	aY:AddToggle("ESP" .. a_.tag, { Text = a_.label, Default = true })
	    		:AddColorPicker("ESP" .. a_.tag .. "Color", { Default = Color3.fromRGB(255, 80, 80), Title = a_.label })
	    end
	    local aZ = aC.ESP:AddRightGroupbox("Gadgets")
	    for a_, a0 in aE do
	    	aZ:AddToggle("ESP" .. a0.tag, { Text = a0.label, Default = true })
	    		:AddColorPicker("ESP" .. a0.tag .. "Color", { Default = Color3.fromRGB(255, 160, 60), Title = a0.label })
	    end
		local a_ = aC.Visuals:AddRightGroupbox("Atmosphere")
		a_:AddToggle("fullbright", { Text = "Fullbright", Default = false })
		a_:AddToggle("worldshadows", { Text = "Shadows", Default = false })
		a_:AddSlider("worldbrightness", { Text = "Brightness", Default = 2, Min = 0, Max = 10, Rounding = 1 })
		a_:AddLabel("Ambient"):AddColorPicker("worldambient", { Default = Color3.fromRGB(255, 255, 255), Title = "Ambient" })
		a_:AddLabel("Outdoor"):AddColorPicker("worldoutdoor", { Default = Color3.fromRGB(255, 255, 255), Title = "Outdoor" })
		a_:AddToggle("customsky", { Text = "Custom Sky", Default = false })
		a_:AddDropdown("skybox", {
			Text = "Skybox",
			Values = { "Default", "Night", "Nebula", "Sunset" },
			Default = 1,
			Multi = false,
		})

	local function a0()
		aN()
		aH()
	end

	ag.world = {
		applyLighting = aW,
		espStep = aT,
		unload = a0,
	}

end

function ac.step(ag)
end

function ac.unload()
end

return ac
end function a.m()local ab=a.cache.m if not ab then ab={c=aa()}a.cache.m=ab end return ab.c end end do local function aa()
local ab = {}



function ab.build(ac)
	local ag = ac.tv
	local ah = ac.ov
	local ai = ac.hook
	local aj = ac.gc
	local ak = ac.UserInputService
	local al = ac.Tabs
	local am = ac.owner.getLocalOwner
	local an = ak.IsKeyDown
	local ao, ap = Enum.KeyCode.D, Enum.KeyCode.A
	local aq, ar, as = Enum.KeyCode.W, Enum.KeyCode.S, Enum.KeyCode.Space
	local at, au = Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift
	local av = ac.Modules
	local aw = ac.Library
	local ax = Vector3.new

	local ay = false
	if aj.render_climbing then
		local az
		az = ai(aj.render_climbing, function(aA, aB, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if type(aA) == "table" and ag("fastladder", false) then
				aB = (tonumber(aB) or 0) * ah("fastladdermult", 3)
			end
			return az(aA, aB, ...)
		end)
		ay = az ~= nil
	end

	if aj.render_running then
		local az
		az = ai(aj.render_running, function(aA, ...)
			LPH_ATTRIBUTES(VM(NONE))
			local aB = type(aA) == "table" and aA.values
			local aC = aB and aB.move_direction
			if not (aC and ag("omnisprint", false)) then
				return az(aA, ...)
			end
			aB.move_direction = ax(aC.X, aC.Y, math.min(aC.Z, -0.5))
			local aD, aE, aF, aG = pcall(az, aA, ...)
			aB.move_direction = aC
			if aD then
				return aE, aF, aG
			end
		end)
	end

	do
	local az = { hook = nil, retryAt = 0, flatLook = Vector3.new(0, 0, -1) }
	local aA = game:GetService("RunService")
	local aB = "vault_flight_hide"
	local aC, aD
	local aE = {}
	az.soundRestore = aE
	do
		local aF, aG = pcall(require, av.Items.Item.Utility.GrapplingHook)
		local aH, aI = pcall(require, av.Items)
		aC = aF and aG or nil
		aD = aH and aI or nil
		if aC and type(aC.load) == "function" then
			pcall(aC.load, aC)
		end
		local aJ, aK = pcall(require, av.Items.Item.Utility.GrapplingHook.Sounds)
		if aJ and type(aK) == "table" then
			for aL, aM in aK do
				if type(aM) == "function" then
					local aN = aM
					aE[#aE + 1] = function()
						aK[aL] = aN
					end
					aK[aL] = function(...)
						if ag("flight", false) and az.hook then
							if aL == "Zipping" or aL == "Ropping" then
								local aO = aN(...)
								if typeof(aO) == "Instance" then
									aO.Volume = 0
									aO.Playing = false
								end
								return aO
							end
							return
						end
						return aN(...)
					end
				end
			end
		end
	end

	function az.isItem(aF)
		return type(aF) == "table" and (aF.tag == "GrapplingHook" or aF.name == "GrapplingHook")
	end

	function az.find(aF)
		LPH_ATTRIBUTES(VM(NONE))
		local aG = aF.values and aF.values.items
		if type(aG) == "table" then
			for aH, aI in aG do
				if az.isItem(aI) then
					return aI
				end
			end
		end
		local aH = aF.values and aF.values.Items
		if typeof(aH) == "Instance" and aD then
			local aI = aH:FindFirstChild("GrapplingHook", true)
			if aI then
				local aJ, aK = pcall(aD.get_item, aI)
				if aJ and az.isItem(aK) then
					return aK
				end
			end
		end
		return nil
	end

	function az.ensure(aF)
		LPH_ATTRIBUTES(VM(NONE))
		local aG = az.find(aF)
		if aG then
			return aG
		end
		local aH = aF.values and aF.values.Items
		if not (aC and aD and aC.model and typeof(aH) == "Instance" and aH.Parent) then
			return nil
		end
		if aH:FindFirstChild("GrapplingHook") then
			return nil
		end
		aC.model.Archivable = true
		local aI = aC.model:Clone()
		if not aI then
			return nil
		end
		aI.Name = "GrapplingHook"
		local aJ = pcall(function()
			aI.Parent = aH
		end)
		if not aJ or not aI.Parent then
			pcall(function()
				aI:Destroy()
			end)
			return nil
		end
		local aK, aL = pcall(aD.get_item, aI)
		if not aK or not az.isItem(aL) then
			aI:Destroy()
			return nil
		end
		if not aL.owner and type(aL.set_owner) == "function" then
			pcall(aL.set_owner, aL, aF)
		end
		if type(aF.values.items) == "table" then
			aF.values.items[aI] = aL
		end
		aL._vaultInjected = true
		return aL
	end

	function az.gone(aF)
		local aG = type(aF) == "table" and aF.instance
		if typeof(aG) ~= "Instance" or not aG.Parent then
			return true
		end
		return aG:FindFirstChild("Root") == nil
	end

	function az.hideVisuals()
		LPH_ATTRIBUTES(VM(NONE))
		local aF = az.hook
		if not aF or not ag("flight", false) then
			return
		end
		local aG = aF.hook_prop
		if typeof(aG) == "Instance" then
			for aH, aI in aG:GetDescendants() do
				if aI:IsA("Beam") or aI:IsA("Trail") or aI:IsA("RopeConstraint") then
					aI.Enabled = false
				elseif aI:IsA("Sound") then
					aI.Volume = 0
					aI.Playing = false
				end
			end
			if aG.Parent then
				aG.Parent = nil
			end
		end
		for aH, aI in { aF.zipping, aF.ropping } do
			if typeof(aI) == "Instance" then
				aI.Volume = 0
				aI.Playing = false
			end
		end
		local aH = aF.owner and aF.owner.instance
		local aI = typeof(aH) == "Instance" and aH:FindFirstChild("collision")
		if aI then
			for aJ, aK in aI:GetChildren() do
				if aK:IsA("Sound") then
					aK.Volume = 0
					aK.Playing = false
				end
			end
		end
		local aJ = typeof(aF.instance) == "Instance" and aF.instance:FindFirstChild("Root")
		if aJ then
			for aK, aL in aJ:GetChildren() do
				if aL:IsA("Sound") then
					aL.Volume = 0
					aL.Playing = false
				end
			end
		end
		if aF.action_button then
			aF.action_button.Visible = false
		end
		if aF.completion_bar and type(aF.completion_bar.cancel) == "function" then
			pcall(function()
				aF.completion_bar:cancel()
			end)
		end
	end
	function az.bindHide()
		pcall(function()
			aA:UnbindFromRenderStep(aB)
		end)
		aA:BindToRenderStep(aB, Enum.RenderPriority.Last.Value + 4, function()
			az.hideVisuals()
		end)
	end
	function az.unbindHide()
		pcall(function()
			aA:UnbindFromRenderStep(aB)
		end)
	end
	function az.stop()
		LPH_ATTRIBUTES(VM(NONE))
		local aF = az.hook
		az.hook = nil
		az.unbindHide()
		if not aF then
			return
		end
		local aG = aF._vaultJumpHum
		aF._vaultJumpHum = nil
		if aG then
			pcall(function()
				if aG.Parent then
					aG:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
				end
			end)
		end
		if az.gone(aF) then
			return
		end
		pcall(function()
			if aF.states and aF.states.rappeling and aF.states.rappeling.set then
				aF.states.rappeling:set(false)
			end
		end)
		pcall(function()
			if aF.owner and type(aF.stop_rappel_mode) == "function" then
				aF:stop_rappel_mode(aF.owner)
			elseif aF.move_position and aF.move_position.Parent then
				aF.move_position.Parent = nil
			end
		end)
		if aF._vaultInjected and typeof(aF.instance) == "Instance" and aF.instance.Parent then
			pcall(function()
				aF.instance:Destroy()
			end)
		end
	end

	function az.start(aF, aG, aH, aI)
		LPH_ATTRIBUTES(VM(NONE))
		if not aG.move_position and type(aG.init) == "function" then
			pcall(aG.init, aG)
		end
		if not aG.move_position then
			return false
		end
		if not aG.owner and type(aG.set_owner) == "function" then
			pcall(aG.set_owner, aG, aF)
		end
		local aJ = aH:FindFirstChild("RootAttachment") or aH:FindFirstChildWhichIsA("Attachment")
		if not aJ then
			return false
		end
		local aK = workspace.CurrentCamera
		local aL = aK and aK.CFrame.LookVector or Vector3.new(0, 0, -1)
		local aM = Vector3.new(aL.X, 0, aL.Z)
		if aM.Magnitude < 0.05 then
			aM = az.flatLook
		else
			aM = aM.Unit
			az.flatLook = aM
		end
		aG.move_position.Position = aH.Position
		aG.move_position.Parent = aH
		aG.move_position.Attachment0 = aJ
		aG.rappel_start = CFrame.new(aH.Position)
		aG.rappel_end = CFrame.new(aH.Position + Vector3.new(0, 800, 0))
		aG.rappel_time = 1
		aG.dt_passed = 0
		local aN = aH.Position + aM * 6 + Vector3.new(0, 40, 0)
		if aG.states and aG.states.hook and aG.states.hook.set then
			pcall(function()
				aG.states.hook:set(CFrame.lookAt(aN, aN + aM))
			end)
		end
		if aG.states and aG.states.rappeling and aG.states.rappeling.set then
			pcall(function()
				aG.states.rappeling:set(true)
			end)
		end
		if aF.states and aF.states.climbing and aF.states.climbing.set then
			pcall(function()
				aF.states.climbing:set(2)
			end)
		end
		if aI then
			pcall(function()
				aI:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
			end)
			aG._vaultJumpHum = aI
		end
		aG._vaultOwnerInst = aF.instance
		az.hook = aG
		az.bindHide()
		az.hideVisuals()
		return true
	end

	if aC and type(aC.input_render) == "function" then
		local aF
		aF = ai(aC.input_render, function(aG, ...)
			LPH_ATTRIBUTES(VM(NONE))
		if aG == az.hook then
			if not ag("flight", false) or az.gone(aG) then
				az.hook = nil
				return
			end
			aG.rappel_time = 1
			return
		end
		return aF(aG, ...)
		end)
	end

	local aF = aC and (aC.rappel_hook or aj.rappel_hook)
	if type(aF) == "function" then
		local aG
		aG = ai(aF, function(aH, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if type(aH) == "table" and az.gone(aH) then
				if aH == az.hook then
					az.hook = nil
				end
				return
			end
			return aG(aH, ...)
		end)
	end

	function az.step(aG, aH, aI, aJ, aK)
		LPH_ATTRIBUTES(VM(NONE))
		if not aG then
			if az.hook then
				az.stop()
			end
			return
		end
		if not ag("flight", false) then
			if az.hook then
				az.stop()
			end
			return
		end
		if not aI or not aI.Parent or (aJ and aJ.Health <= 0) then
			if az.hook then
				az.stop()
			end
			return
		end
		local aL = az.hook
		if not aL or aL._vaultOwnerInst ~= aH or (typeof(aL.instance) == "Instance" and not aL.instance.Parent) then
			if az.hook then
				az.stop()
			end
			if os.clock() >= az.retryAt then
				az.retryAt = os.clock() + 0.5
				aL = az.ensure(aG)
				if aL then
					az.start(aG, aL, aI, aJ)
				end
			end
			aL = az.hook
		end
		if not (aL and aL.move_position) or az.gone(aL) then
			az.hook = nil
			return
		end
		local aM = math.clamp(tonumber(aK) or 0.016, 0, 0.05)
		local aN = math.clamp(tonumber(ah("flightspeed", 10)) or 10, 5, 20)
		local aO = workspace.CurrentCamera
		local aP = aO and aO.CFrame or CFrame.new()
		local aQ = Vector3.new(aP.LookVector.X, 0, aP.LookVector.Z)
		if aQ.Magnitude > 0.05 then
			aQ = aQ.Unit
			az.flatLook = aQ
		else
			aQ = az.flatLook
		end
		local aR = Vector3.new(aP.RightVector.X, 0, aP.RightVector.Z)
		if aR.Magnitude > 0.05 then
			aR = aR.Unit
		else
			aR = Vector3.new(aQ.Z, 0, -aQ.X)
		end
		local aS = (an(ak, aq) and 1 or 0) - (an(ak, ar) and 1 or 0)
		local aT = (an(ak, ao) and 1 or 0) - (an(ak, ap) and 1 or 0)
		local aU = aQ * aS + aR * aT
		local aV = 0
		if an(ak, as) then
			aV += aN
		end
		if an(ak, at) or an(ak, au) then
			aV -= aN
		end
		local aW = Vector3.zero
		if aU.Magnitude > 0.001 then
			aW = aU.Unit * aN
		end
		aW += Vector3.new(0, aV, 0)
		aL.rappel_time = 1
		aL.dt_passed = 0
		aL.descending = aV < 0
		aL.rappel_end = CFrame.new(aI.Position + Vector3.new(0, 800, 0))
		if aL.states and aL.states.hook and aL.states.hook.set and (not aL._vaultAirAt or os.clock() - aL._vaultAirAt > 0.35) then
			aL._vaultAirAt = os.clock()
			local aX = aI.Position + az.flatLook * 6 + Vector3.new(0, 40, 0)
			pcall(function()
				aL.states.hook:set(CFrame.lookAt(aX, aX + az.flatLook))
			end)
		end
		if aG.states and aG.states.vault and aG.states.vault.get and aG.states.vault:get() ~= 0 and aG.states.vault.set then
			pcall(function()
				aG.states.vault:set(0)
			end)
		end
		if aL.states and aL.states.rappeling and aL.states.rappeling.get and not aL.states.rappeling:get() and aL.states.rappeling.set then
			pcall(function()
				aL.states.rappeling:set(true)
			end)
		end
		if aG.states and aG.states.climbing and aG.states.climbing.get and aG.states.climbing:get() < 2 and aG.states.climbing.set then
			pcall(function()
				aG.states.climbing:set(2)
			end)
		end
		local aX = aL.move_position
		if aX.Parent ~= aI and aI.Parent then
			pcall(function()
				aX.Position = aI.Position
				aX.Parent = aI
				aX.Attachment0 = aI:FindFirstChild("RootAttachment") or aI:FindFirstChildWhichIsA("Attachment")
			end)
		end
		if aW.Magnitude < 0.01 then
			aX.Position = aI.Position
		else
			aX.Position = aX.Position + aW * aM
			if (aX.Position - aI.Position).Magnitude > 10 then
				aX.Position = aI.Position + aW * aM
			end
		end
		az.hideVisuals()
	end

	ac.flight = az
	end


	local function az(aA)
		LPH_ATTRIBUTES(VM(NONE))
		local aB = ac.flight
		if aB and (aB.hook or ag("flight", false)) then
			local aC = am()
			local aD = aC and aC.instance
			aB.step(aC, aD, aD and (aD:FindFirstChild("HumanoidRootPart") or aD:FindFirstChild("Root")), aD and aD:FindFirstChildOfClass("Humanoid"), aA)
		end
		local aC, aD, aE = ag("noslowdown", false), ag("autostrafe", false), ag("fastladder", false) and not ay
		if not (aC or aD or aE) then
			return
		end
		local aF = am()
		if not aF then
			return
		end
		local aG, aH = aF.states, aF.values
		if aC and aG and aG.speed_multiplier and aG.speed_multiplier:get() ~= 1 then
			pcall(aG.speed_multiplier.set, aG.speed_multiplier, 1)
		end
		if aD and aH and aH.falling and aH.falling:get() then
			local aI = aF.instance
			local aJ = aI and aI:FindFirstChildOfClass("Humanoid")
			if aJ then
				local aK = ac.Camera.CFrame.RightVector
				local aL = an(ak, ap) and not an(ak, ao) and -1 or 1
				aJ:Move(ax(aK.X * aL, 0, aK.Z * aL), false)
			end
		end
		if aE and aH and aH.climbing_ladder then
			local aI = aH.climbing_ladder:get()
			local aJ = aH.climb_moving and aH.climb_moving:get()
			if aI and aJ and aJ ~= 0 and aH.climbing then
				local aK = (aI.start.WorldCFrame.Position - aI.finish.WorldCFrame.Position).Magnitude
				if aK > 0.1 then
					aH.climbing:set(aH.climbing:get() + aJ * 0.08 / aK * (ah("fastladdermult", 3) - 1))
				end
			end
		end
	end

	local aA = false
	local function aB()
		LPH_ATTRIBUTES(VM(NONE))
		local aC = ag("autosprint", false)
		if not aC and not aA then
			return
		end
		local aD = am()
		local aE = aD and aD.values
		if not aE then
			return
		end
		if not aC then
			aE.running_toggled = false
			aA = false
			return
		end
		local aF = aE.move_vector
		if aF and aF.Magnitude > 0.5 then
			aE.running_toggled = true
			aA = true
		elseif aA then
			aE.running_toggled = false
			aA = false
		end
	end

	
	local aC, aD, aE = 0.5 / 1.5, 0.3 / 1.5, 0.9 / 1.5
	local function aF()
		LPH_ATTRIBUTES(VM(NONE))
		if not ag("speedhack", false) then
			return
		end
		local aG = am()
		local aH = aG and aG.instance
		local aI = aH and aH:FindFirstChildOfClass("Humanoid")
		if not aI then
			return
		end
		local aJ, aK = aG.states, aG.values
		local aL = aK and aK.move_vector
		local aM = (ag("autosprint", false) and aL and aL.Magnitude > 0.2) or (aJ and aJ.running and aJ.running:get())
		local aN = 1
		if not aM then
			aN = aE
			local aO = aJ and aJ.walk_state and aJ.walk_state:get()
			if aO == "crouch" then
				aN = aC
			elseif aO == "prone" then
				aN = aD
			end
			if aJ and aJ.walking and aJ.walking:get() then
				aN *= 0.5
			end
		end
		aI.WalkSpeed = (tonumber(ah("speedvalue", 15)) or 15) * aN
	end

	local aG = al.Misc:AddLeftGroupbox("Movement")
	aG:AddToggle("omnisprint", { Text = "Omnisprint", Default = false })
	aG:AddToggle("instantlean", { Text = "Instant Lean", Default = false })
	aG:AddToggle("instantcrouch", { Text = "Instant Crouch", Default = false })
	aG:AddToggle("instantprone", { Text = "Instant Prone", Default = false })
	aG:AddToggle("autosprint", { Text = "Auto Sprint", Default = false })
	aG:AddToggle("speedhack", { Text = "Speed", Default = false })
	aG:AddSlider("speedvalue", { Text = "Speed Value", Default = 15, Min = 8, Max = 25, Rounding = 0 })
	aG:AddToggle("flight", {
		Text = "Flight",
		Default = false,
		Tooltip = "Space to ascend, Shift to descend",
	}):AddKeyPicker("flightkey", { Default = "None", SyncToggleState = true, Mode = "Toggle", Text = "Flight" })
	aG:AddSlider("flightspeed", { Text = "Flight Speed", Default = 10, Min = 5, Max = 20, Rounding = 0, Suffix = " studs/s" })
	aG:AddToggle("noslowdown", { Text = "No Slowdown", Default = false })
	aG:AddToggle("autostrafe", { Text = "Auto Strafe", Default = false })
	aG:AddToggle("fastladder", { Text = "Fast Ladder", Default = false })
	aG:AddSlider("fastladdermult", { Text = "Ladder Speed", Default = 3, Min = 1, Max = 8, Rounding = 1, Suffix = "x" })

	ac.movement = {
		step = az,
		applyAutoSprint = aB,
		speedStep = aF,
		getAim = function()
			return nil
		end,
		unload = function()
			local aH = ac.flight
			if aH then
				pcall(aH.stop)
				for aI, aJ in aH.soundRestore do
					pcall(aJ)
				end
			end
			if aA then
				local aI = am()
				if aI and aI.values then
					aI.values.running_toggled = false
				end
			end
		end,
	}
end

return ab
end function a.n()local ab=a.cache.n if not ab then ab={c=aa()}a.cache.n=ab end return ab.c end end do local function aa()
local ab = {}

function ab.build(ac)
	local ag = ac.tv
	local ah = ac.ov
	local ai = ac.cloneOriginal
	local aj = ac.wrap
	local ak = ac.findGcFunction
	local al = ac.Players
	local am = ac.LocalPlayer
	local an = ac.UserInputService
	local ao = ac.Lighting
	local ap = ac.CollectionService
	local aq = ac.ReplicatedStorage
	local ar = ac.Modules
	local as = ac.Gun
	local at = ac.StateObject
	local au = ac.Util
	local av = ac.Targeting
	local aw = ac.ESP
	local ax = ac.Library
	local ay = ac.owner.getLocalOwner
	local az = ac.owner.getLiveCharacter
	local aA = ac.owner.getViewmodel
	local aB = ac.Tabs

	local aC = ac.okInput
	local aD = ac.Input
	local aE = ac.okNet
	local aF = ac.Net
	local aG = ac.okShield
	local aH = ac.ShieldMod
	local aI = aC and aD and aD.current_device
	local aJ = aI and aI.get
	local aK = nil
	local aL = 0
	local aM = false

	local function aN()
		LPH_ATTRIBUTES(VM(NONE))
		local aO = an.PreferredInput
		local aP = "pc"
		if aO == Enum.PreferredInput.Touch then
			aP = "mobile"
		elseif aO == Enum.PreferredInput.Gamepad then
			aP = "console"
		end
		if am:GetAttribute("Spectator") then
			return aP
		end
		local aQ = workspace:GetAttribute("Devices")
		if type(aQ) ~= "string" or aQ == "" then
			return aP
		end
		local aR = string.split(aQ, ",")
		if #aR > 0 and not table.find(aR, "any") and aP ~= aR[1] then
			return aR[1]
		end
		return aP
	end

	local function aO()
		LPH_ATTRIBUTES(VM(NONE))
		if aM or not ag("devicespoof", false) then
			return nil
		end
		local aP = ah("spoofdevice", "Console")
		if type(aP) ~= "string" then
			return "console"
		end
		local aQ = string.lower(aP)
		if aQ == "pc" or aQ == "console" or aQ == "mobile" then
			return aQ
		end
		return "console"
	end

	local function aP(aQ)
		LPH_ATTRIBUTES(VM(NONE))
		if not aE or not aF or type(aF.send) ~= "function" then
			return
		end
		pcall(function()
			am:SetAttribute("Device", aQ)
		end)
		pcall(aF.send, "set_device", aQ)
	end

	local function aQ()
		LPH_ATTRIBUTES(VM(NONE))
		if not aK then
			return
		end
		local aR = aN()
		if aI and (aI.value == "pc" or aI.value == "console" or aI.value == "mobile") then
			aR = aI.value
		end
		aK = nil
		aP(aR)
	end

	local function aR()
		LPH_ATTRIBUTES(VM(NONE))
		local aS = aO()
		if not aS then
			aQ()
			return
		end
		if aK == aS and am:GetAttribute("Device") == aS then
			return
		end
		local aT = os.clock()
		if aK == aS and aT - aL < 2 then
			return
		end
		aL = aT
		aK = aS
		aP(aS)
	end

	local function aS()
		LPH_ATTRIBUTES(VM(NONE))
		aM = true
		aQ()
		if aI and aJ then
			aI.get = aJ
		end
	end

	if aI and type(aJ) == "function" then
		aI.get = function(aT, ...)
			LPH_ATTRIBUTES(VM(NONE))
			local aU = aO()
			if not aU or aT ~= aI then
				return aJ(aT, ...)
			end
			local aV = ""
			if type(debug) == "table" and type(debug.info) == "function" then
				aV = debug.info(2, "s") or ""
			end
			if string.find(aV, "Items.Item.Gun", 1, true) then
				return aU
			end
			return aJ(aT, ...)
		end
	end

	if aE and aF and type(aF.send) == "function" then
		local aT
		aT = ac.hook(aF.send, function(aU, ...)
			LPH_ATTRIBUTES(VM(NONE))
			if aU == "set_device" then
				local aV = aO()
				if aV then
					return aT("set_device", aV)
				end
			end
			return aT(aU, ...)
		end)
	end
	if aG and aH and type(aH.equip) == "function" then
		local aT
		aT = ac.hook(aH.equip, function(aU, aV, aW, ...)
			LPH_ATTRIBUTES(VM(NONE))
			local aX, aY, aZ, a_ = pcall(aT, aU, aV, aW, ...)
			if ag("shieldgun", false) and aW and aV and aV.values then
				local a0 = aV.values.equipped
				if a0 and a0.safety and a0.safety.set then
					pcall(function()
						a0.safety:set(false)
					end)
				end
			end
			if not aX then
				warn(aY)
				return
			end
			return aY, aZ, a_
		end)
	end
	local aT = {}
	local aU = {}
	local aV = {}
	local aW = false
	local aX

	local function aY()
		local aZ = ah("spoofedname", "vault.cc")
		if type(aZ) ~= "string" or aZ == "" then
			return "vault.cc"
		end
		return aZ
	end

	local function aZ(a_, a0, a1)
		LPH_ATTRIBUTES(VM(NONE))
		if a0 == "" or a0 == a1 or string.find(a1, a0, 1, true) then
			return a_
		end
		local a2 = table.create(4)
		local a3 = 1
		while true do
			local a4, a5 = string.find(a_, a0, a3, true)
			if not a4 then
				a2[#a2 + 1] = string.sub(a_, a3)
				break
			end
			a2[#a2 + 1] = string.sub(a_, a3, a4 - 1)
			a2[#a2 + 1] = a1
			a3 = a5 + 1
		end
		return table.concat(a2)
	end

	local function a_(a0, a1, a2, a3)
		LPH_ATTRIBUTES(VM(NONE))
		if type(a0) ~= "string" or a0 == "" then
			return a0
		end
		local a4 = aZ(a0, a1, a3)
		if a2 ~= a1 then
			a4 = aZ(a4, a2, a3)
		end
		return a4
	end

	local function a0(a1)
		if a1.Name ~= "Title" then
			return false
		end
		local a2 = a1.Parent
		local a3 = a2 and a2:GetAttribute("UserId")
		return a3 ~= nil and tonumber(a3) == am.UserId
	end

	local function a1(a2, a3, a4)
		if not (a2:IsA("TextLabel") or a2:IsA("TextButton") or a2:IsA("TextBox")) then
			return false
		end
		if a0(a2) then
			return true
		end
		local a5 = a2.Text
		if type(a5) ~= "string" or a5 == "" then
			return false
		end
		if a3 ~= "" and string.find(a5, a3, 1, true) then
			return true
		end
		if a4 ~= "" and a4 ~= a3 and string.find(a5, a4, 1, true) then
			return true
		end
		return false
	end

	local function a2(a3, a4, a5, a6)
		LPH_ATTRIBUTES(VM(NONE))
		if not a3.Parent then
			return
		end
		local a7 = a3.Text
		local a8 = a_(a7, a4, a5, a6)
		if a0(a3) or (a3.Name == "Username" and (a7 == a4 or a7 == a5)) then
			a8 = a6
		end
		if a8 ~= a7 then
			a3.Text = a8
		end
	end

	local function a3(a4)
		if aT[a4] then
			return
		end
		aT[a4] = a4.Text
		local a5 = false
		local function a6()
			LPH_ATTRIBUTES(VM(NONE))
			if a5 or not ag("namespoof", false) then
				return
			end
			a5 = true
			a2(a4, am.Name, am.DisplayName, aY())
			a5 = false
		end
		a6()
		aU[#aU + 1] = a4:GetPropertyChangedSignal("Text"):Connect(a6)
		aU[#aU + 1] = a4.Destroying:Connect(function()
			aT[a4] = nil
		end)
	end

	local function a4(a5, a6)
		aU[#aU + 1] = a5:Connect(a6)
	end

	local function a5(a6)
		if a6 and a1(a6, am.Name, am.DisplayName) then
			a3(a6)
		end
	end

	local function a6(a7, a8, a9)
		if not a7 or aV[a7] then
			return
		end
		aV[a7] = true
		for b, ba in a7:GetChildren() do
			if a8(ba) then
				a9(ba)
			end
		end
		a4(a7.ChildAdded, function(b)
			if ag("namespoof", false) and a8(b) then
				a9(b)
			end
		end)
	end

	local function a7(a8)
		local function a9()
			if tonumber(a8:GetAttribute("UserId")) ~= am.UserId then
				return
			end
			a5(a8:FindFirstChild("Title"))
		end
		a9()
		a4(a8:GetAttributeChangedSignal("UserId"), a9)
		a4(a8.ChildAdded, function(b)
			if b.Name == "Title" then
				a9()
			end
		end)
	end

	local function a8(a9)
		local function b(ba)
			if ba.Name ~= "RedTeam" and ba.Name ~= "BlueTeam" then
				return
			end
			a6(ba, function(bb)
				return bb.Name == "PlayerBoardInfo"
			end, a7)
		end
		for ba, bb in a9:GetChildren() do
			b(bb)
		end
		if not aV[a9] then
			aV[a9] = true
			a4(a9.ChildAdded, b)
		end
	end

	local function a9(b, ba)
		for bb, bc in ba do
			local bd = b:FindFirstChild(bc)
			if not bd then
				continue
			end
			a5(bd)
			a4(bd:GetPropertyChangedSignal("Text"), function()
				if ag("namespoof", false) then
					a5(bd)
				end
			end)
		end
	end

	local function b(ba)
		a6(ba, function(bb)
			return bb.Name == "Kill"
		end, function(bb)
			a9(bb, { "KillerName", "VictimName" })
		end)
	end

	local function ba(bb)
		local bc = bb:FindFirstChild("head")
		if not bc then
			return
		end
		local bd = bc:FindFirstChild("Username")
		local be = bd and bd:FindFirstChild("Username")
		a5(be)
	end

	local function bb(bc)
		a6(bc, function(bd)
			return bd.Name == "Viewmodel" or bd.Name == "LocalViewmodel"
		end, ba)
	end

	local function bc(bd)
		a6(bd, function(be)
			return be:FindFirstChild("Username") ~= nil
		end, function(be)
			a9(be, { "Username" })
		end)
	end

	local function bd()
		LPH_ATTRIBUTES(VM(NONE))
		local be = am:FindFirstChild("PlayerGui")
		if not be then
			return
		end
		local bf = be:FindFirstChild("Game")
		if bf then
			local bg = bf:FindFirstChild("Center")
			bg = bg and bg:FindFirstChild("Center")
			local bh = bg and bg:FindFirstChild("Scoreboard")
			if bh then
				a8(bh)
			end
			local bi = bf:FindFirstChild("Right")
			bi = bi and bi:FindFirstChild("Top")
			local bj = bi and bi:FindFirstChild("KillFeed")
			if bj then
				b(bj)
			end
		end
		local bg = be:FindFirstChild("LoadoutMenu")
		bg = bg and bg:FindFirstChild("Center")
		bg = bg and bg:FindFirstChild("Center")
		bg = bg and bg:FindFirstChild("CustomMatch")
		bg = bg and bg:FindFirstChild("Players")
		if bg then
			for bh, bi in bg:GetChildren() do
				local bj = bi:FindFirstChildWhichIsA("Frame") or bi
				bc(bj)
			end
		end
		local bh = be:FindFirstChild("LoadoutOverlay")
		bh = bh and bh:FindFirstChild("Left")
		bh = bh and bh:FindFirstChild("Center")
		bh = bh and bh:FindFirstChild("LeftOverlayMenu")
		bh = bh and bh:FindFirstChild("ScrollingFrame")
		bh = bh and bh:FindFirstChild("InvitePeopleFrame")
		if bh then
			bc(bh)
		end
		local bi = workspace:FindFirstChild("Viewmodels")
		if bi then
			bb(bi)
		end
	end

	local function be(bf)
		local bg = am.Name
		local bh = am.DisplayName
		for bi in aT do
			if typeof(bi) == "Instance" and bi.Parent then
				a2(bi, bg, bh, bf)
			end
		end
	end

	local function bf()
		LPH_ATTRIBUTES(VM(NONE))
		for bg, bh in aU do
			bh:Disconnect()
		end
		table.clear(aU)
		table.clear(aV)
		aX = nil
		for bg, bh in aT do
			if typeof(bg) == "Instance" and bg.Parent and type(bh) == "string" then
				pcall(function()
					bg.Text = bh
				end)
			end
		end
		table.clear(aT)
		local bg = ay()
		local bh = bg and bg.instance
		local bi = bh and bh:FindFirstChildOfClass("Humanoid")
		if bi then
			pcall(function()
				bi.DisplayName = am.DisplayName
			end)
		end
	end

	local bg = 0
	local function bh()
		LPH_ATTRIBUTES(VM(NONE))
		if not ag("namespoof", false) then
			if aW then
				aW = false
				bf()
			end
			return
		end
		aW = true
		local bi = aY()
		local bj = ay()
		local bk = bj and bj.instance
		local bl = bk and bk:FindFirstChildOfClass("Humanoid")
		if bl and bl.DisplayName ~= bi then
			pcall(function()
				bl.DisplayName = bi
			end)
		end
		local bm = os.clock()
		if bm >= bg then
			bg = bm + 1
			bd()
		end
		if bi ~= aX then
			aX = bi
			be(bi)
		end
	end

	local function bi(bj)
		if type(bj) ~= "table" then
			return false
		end
		local bk = bj.tag
		if bk == "Shield" or bk == "BallisticShield" or bk == "RiotShield" then
			return true
		end
		local bl = bj.display_name or bj.name
		return type(bl) == "string" and string.find(string.lower(bl), "shield", 1, true) ~= nil
	end

	local function bj()
		LPH_ATTRIBUTES(VM(NONE))
		bh()
		if not ag("shieldgun", false) then
			return
		end
		local bk = ay()
		local bl, bm = bk and bk.values, bk and bk.states
		if not (bl and bm) then
			return
		end
		if bm.climbing and bm.climbing:get() ~= 0 then
			return
		end
		local bn = bl.holding
		if not bi(bn) and bl.items then
			for bo, bp in bl.items do
				if bi(bp) then
					bn = bp
					break
				end
			end
		end
		if not bi(bn) then
			return
		end
		bn.can_reload = true
		local bo = bl.equipped
		local bp = bo and not bi(bo)
		local bq = bn.instance
		if typeof(bq) ~= "Instance" then
			return
		end
		if bp then
			if bn._vaultItemType == nil then
				bn._vaultItemType = bq:GetAttribute("item_type")
			end
			if bq:GetAttribute("item_type") ~= 0 then
				bq:SetAttribute("item_type", 0)
			end
			if bm.holding:get() ~= bq then
				pcall(bm.holding.set, bm.holding, bq)
			end
			if bo.safety and bo.safety.set and bo.safety:get() then
				pcall(bo.safety.set, bo.safety, false)
			end
		elseif bn._vaultItemType ~= nil then
			bq:SetAttribute("item_type", bn._vaultItemType)
		end
	end
		local bk = aB.Misc:AddLeftGroupbox("Local")
		bk:AddToggle("shieldgun", {
			Text = "Shield + Gun",
			Default = false,
		})
		bk:AddToggle("namespoof", { Text = "Name Spoof", Default = false })
		bk:AddInput("spoofedname", { Text = "Name", Default = "vault.cc", Placeholder = "Name", Finished = false })
		bk:AddToggle("devicespoof", { Text = "Device Spoof", Default = false })
		bk:AddDropdown("spoofdevice", {
			Text = "Device",
			Values = { "PC", "Console", "Mobile" },
			Default = 2,
			Multi = false,
		})

	local function bl()
		bf()
		aS()
	end
	ac.network = {
		apply = aR,
		restore = bl,
		step = bj,
	}
	ab.step = bj
	ab.unload = bl

end

function ab.step(ac)
end

function ab.unload()
end

return ab
end function a.o()local ab=a.cache.o if not ab then ab={c=aa()}a.cache.o=ab end return ab.c end end do local function aa()
local ab = {}

function ab.build(ac)
	local ag = ac.tv
	local ah = ac.hook
	local ai = ac.Util
	local aj = ac.LocalPlayer
	local ak = ac.okCharAnim and ac.CharAnim

	
	local al = false
	local am = TweenInfo.new
	for an, ao in { "tween", "base_tween" } do
		local ap = ai[ao]
		if type(ap) == "function" then
			local aq
			aq = ah(ap, function(ar, as, at, ...)
				LPH_ATTRIBUTES(VM(NONE))
				if al and typeof(as) == "TweenInfo" then
					as = am(0, as.EasingStyle, as.EasingDirection)
				end
				return aq(ar, as, at, ...)
			end)
		end
	end

	local function an(ao, ap)
		if type(ao) ~= "function" then
			return
		end
		local aq
		aq = ah(ao, function(...)
			LPH_ATTRIBUTES(VM(NONE))
			if not ag(ap, false) then
				return aq(...)
			end
			al = true
			local ar, as, at, au = pcall(aq, ...)
			al = false
			if ar then
				return as, at, au
			end
		end)
	end

	if type(ak) == "table" then
		if type(ak.Lean) == "table" then
			for ao, ap in ak.Lean do
				an(ap, "instantlean")
			end
		end
		if type(ak.Movement) == "table" then
			local ao = { crouch = true, crouch_torso = true, crouch_slow = true, crouch_torso_slow = true, base = true }
			local ap = { prone = true, prone_torso_down = true, prone_torso_up = true, rise = true, rise2 = true, down = true, drop = true, base_slow = true }
			for aq, ar in ak.Movement do
				if ao[aq] then
					an(ar, "instantcrouch")
				elseif ap[aq] then
					an(ar, "instantprone")
				end
			end
		end
	end

	ac.utility = {
		step = function() end,
	}
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



local aa = (getreg and getreg()) or getgenv()
local ab = "__vaultcc_op1"
do
	local ac = rawget(aa, ab)
	if type(ac) == "table" and type(ac.unload) == "function" then
		pcall(ac.unload)
	end
end

local ac = game:GetService("Players")
local ag = game:GetService("RunService")
local ah = game:GetService("ReplicatedStorage")
local ai = game:GetService("UserInputService")
local aj = game:GetService("Lighting")
local ak = game:GetService("CollectionService")
local al = ac.LocalPlayer

local am = ah.Modules
local an = require(am.Items.Item.Gun)
local ao = require(am.StateObject)
local ap = require(am.Util)
local aq, ar = pcall(require, am.Items.Item.Utility.Shield)
local as, at = pcall(require, am.Character.Animations)
local au, av = pcall(require, am.Input)
local aw, ax = pcall(require, am.Net)

local ay, az, aA = loadstring(game:HttpGet("https://raw.githubusercontent.com/ttokennxyz/vaultcc/refs/heads/main/uilib.lua"))()

local aB = a.a()
aB.bind(getgenv().Toggles, getgenv().Options)
local aC = a.b()
local aD = a.c()
local aE = a.d()
local aF = a.e()
local aG = a.g()
local aH = a.j()
local aI = a.k()
local aJ = a.l()
local aK = a.m()
local aL = a.n()
local aM = a.o()
local aN = a.p()

local aO = {
	Players = ac,
	RunService = ag,
	UserInputService = ai,
	Lighting = aj,
	CollectionService = ak,
	ReplicatedStorage = ah,
	LocalPlayer = al,
	Modules = am,
	Camera = workspace.CurrentCamera,
	Gun = an,
	StateObject = ao,
	Util = ap,
	Library = ay,
	ThemeManager = az,
	SaveManager = aA,
	okCharAnim = as,
	CharAnim = at,
	okShield = aq,
	ShieldMod = ar,
	okInput = au,
	Input = av,
	okNet = aw,
	Net = ax,
	tv = aB.tv,
	ov = aB.ov,
	option = aB.option,
	hook = aC.hook,
	cloneOriginal = aC.cloneOriginal,
	wrap = aC.wrap,
	findGcFunction = aC.findGcFunction,
	frame = 0,
	Toggles = getgenv().Toggles,
	Options = getgenv().Options,
}

aO.owner = aD.create(aO)
aO.Targeting = aE.create(aO)
aO.ESP = aF(aO.Targeting)

aO.gc = aC.findGcFunctions({
	render_bobbing = "Character",
	attach_camera = "Character",
	can_climb = "FirstPersonInterface",
	render_climbing = "FirstPersonInterface",
	render_running = "FirstPersonInterface",
	get_circular_spread = "Gun",
	rappel_hook = "GrapplingHook",
})

aG.build(aO)
aH.build(aO)
aI.build(aO)
aJ.build(aO)
aK.build(aO)
aL.build(aO)
aM.build(aO)
aN.build(aO)
aG.finish(aO)

aO.aim.refreshTargetParts()
aO.visuals.applyESP()

local aP
local aQ = false
local function aR()
	if aQ then
		return
	end
	aQ = true
	if rawget(aa, ab) and rawget(aa, ab).ctx == aO then
		rawset(aa, ab, nil)
	end
	if aP then
		aP:Disconnect()
		aP = nil
	end
	pcall(ag.UnbindFromRenderStep, ag, "vault_cam_pre")
	pcall(ag.UnbindFromRenderStep, ag, "vault_cam")
	aC.restoreAll()
	for aS, aT in { "network", "movement", "combat", "visuals", "world" } do
		local aU = aO[aT]
		if aU and aU.unload then
			pcall(aU.unload)
		end
	end
	if aO.ESP and aO.ESP.Unload then
		pcall(aO.ESP.Unload, aO.ESP)
	end
end

local aS, aT, aU, aV, aW, aX =
	aO.aim, aO.visuals, aO.combat, aO.world, aO.movement, aO.network

aP = ag.RenderStepped:Connect(function(aY)
	LPH_ATTRIBUTES(VM(NONE))
	aO.Camera = workspace.CurrentCamera
	aO.frame += 1
	aX.apply()
	aS.getTarget()
	aT.updateFOV()
	aT.updateSnap()
	aU.updateTracers()
	aU.gunModStep()
	aT.step()
	aV.applyLighting()
	aW.step(aY)
	aX.step()
	aV.espStep()
	aU.aimbotStep()
	aU.reloadStep()
	aU.rageStep()
end)
ag:BindToRenderStep("vault_cam_pre", Enum.RenderPriority.Last.Value, function()
	LPH_ATTRIBUTES(VM(NONE))
	aO.Camera = workspace.CurrentCamera
	aT.prepareThirdPerson()
	aW.applyAutoSprint()
end)

ag:BindToRenderStep("vault_cam", Enum.RenderPriority.Last.Value + 3, function()
	LPH_ATTRIBUTES(VM(NONE))
	aO.Camera = workspace.CurrentCamera
	aW.applyAutoSprint()
	aT.applyThirdPerson()
	aW.speedStep()
	aT.applyChams()
end)

ay:OnUnload(aR)
rawset(aa, ab, {
	unload = function()
		pcall(ay.Unload, ay)
		aR()
	end,
	ctx = aO,
})
if ay and ay.KeybindFrame then
	ay.KeybindFrame.Visible = aB.tv("ShowKeybindList", true)
end
