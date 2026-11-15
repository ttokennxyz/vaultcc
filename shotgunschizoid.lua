local a={cache={}}do do local function b()







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
    LPH_ENCSTR = function(c) return c end
    LPH_ENCNUM = function(c) return c end
    LPH_ENCBUF = function(c) return c end
    LPH_CRASH = function() end
    LPH_STACKALLOC = function(c) return table.create(c) end
    LPH_PRECHECK = function(...) end
    LPH_REWRITE = function(c) return c end
    LPH_LINE = 0
end

local c = game:GetService("UserInputService")
local d = game:GetService("RunService")
local e = game:GetService("Players")
local f = game:GetService("CoreGui")
local g = game:GetService("Workspace")
local h = game:GetService("HttpService")
local i = e.LocalPlayer
local j = g.CurrentCamera
local k = j.WorldToViewportPoint
local l = f
local m = e
local n = {}
local o
local p
local q
local r
local s
local t = h:GenerateGUID(false)

if getgenv().SensoryESP_Unload then
    pcall(getgenv().SensoryESP_Unload)
end

local u = l:FindFirstChild("SensoryESP_Chams")
if u then
    pcall(function() u:Destroy() end)
end

local v = g:FindFirstChild("SensoryESP_MeshChams")
if v then
    pcall(function() v:Destroy() end)
end

local function w(x)
    if not x then
        return false
    end

    if x:GetAttribute("SensoryESP_MeshCham") == true then
        return true
    end

    if x:IsA("Model") and x.Name == "ChamShells" then
        return true
    end

    if x:IsA("BasePart") and x.Name:match("^ChamShell_") then
        return true
    end

    if x:IsA("Highlight") and x.Name == "ChamShellHighlight" then
        return true
    end

    return false
end

local function x(y)
    if not y then
        return
    end

    for z, A in ipairs(y:GetDescendants()) do
        if w(A) then
            pcall(function() A:Destroy() end)
        end
    end
end

local function y(z)
    if not z then
        return
    end

    for A, B in ipairs(z:GetChildren()) do
        if w(B) then
            pcall(function() B:Destroy() end)
        end
    end
end

x(g)

for z, A in ipairs(m:GetPlayers()) do
    y(A.Character)
end

local function z()
    if not o or not o.Parent then
        o = Instance.new("Folder")
        o.Name = "SensoryESP_Chams"
        o.Parent = l
    end

    if not p or not p.Parent then
        p = Instance.new("Folder")
        p.Name = "SensoryESP_MeshChams"
        p.Parent = g
    end

    if not q or not q.Parent then
        q = Instance.new("ScreenGui")
        q.Name = "SensoryESP"
        q.ResetOnSpawn = false
        q.IgnoreGuiInset = true
        q.ZIndexBehavior = Enum.ZIndexBehavior.Global
        getgenv().SensoryESP_UI = q

        q.Parent = f
    end
end

local A = setmetatable({}, { __mode = "k" })
local B = function(B, C, D, E, F)
    LPH_ATTRIBUTES(VM(NONE))
    local G = D - C
    local H = G.Magnitude
    local I = math.deg(math.atan2(G.Y, G.X))

    B.Size = UDim2.new(0, math.floor(H + 0.5), 0, E)
    B.Position = UDim2.new(0, math.floor(C.X + G.X / 2 - H / 2 + 0.5), 0,
        math.floor(C.Y + G.Y / 2 - E / 2 + 0.5))
    B.Rotation = I
    B.BackgroundColor3 = F
    B.Visible = true
end

local C = {
    
    Enabled = false,
    Keybind = {
        Enabled = false,
        Key = Enum.KeyCode.Insert,
    },
    Players = false,
    LocalPlayer = false,
    LimitFPS = 70, 
    MaxDistance = 0, 
    DynamicBoxes = true,
    DynamicBoxesCheap = false,           
    DynamicBoxesIncludeAll = false,      
    VisibilityCheckRate = 0.3,
    Filter = nil, 
    FlagProvider = nil, 

    
    Boxes = false,
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

    
    Names = false,
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

local function D(E)
    if type(E) ~= "table" then
        return E
    end

    local F = {}
    for G, H in pairs(E) do
        F[G] = D(H)
    end
    return F
end

local function E(F, G)
    if type(G) ~= "table" then
        return F
    end

    for H, I in pairs(G) do
        if type(I) == "table" and type(F[H]) == "table" then
            E(F[H], I)
        else
            F[H] = I
        end
    end

    return F
end

local F = D(C)

local function G(H)
    if type(H) ~= "string" or H == "" then
        return ""
    end

    local I = {}
    for J in H:gmatch("[^%s%-_]+") do
        if J ~= "" then
            table.insert(I, J)
        end
    end

    if #I == 0 then
        return H
    end

    if #I == 1 then
        local J = I[1]
        if #J <= 4 then
            return J:upper()
        end
        return J:sub(1, 1):upper()
    end

    local J = {}
    for K, L in ipairs(I) do
        table.insert(J, L:sub(1, 1):upper())
    end
    return table.concat(J)
end

local function H(I)
    local J = math.clamp(math.floor(I.R * 255 + 0.5), 0, 255)
    local K = math.clamp(math.floor(I.G * 255 + 0.5), 0, 255)
    local L = math.clamp(math.floor(I.B * 255 + 0.5), 0, 255)
    return string.format("#%02X%02X%02X", J, K, L)
end



local I = {
    ["Proggy Clean"] = Enum.Font.SourceSans,
    ["Smallest Pixel-7"] = Enum.Font.SourceSans,
    ["Tahoma"] = Enum.Font.SourceSans,
    ["Minecraftia"] = Enum.Font.SourceSans,
    ["Tahoma Modern Bold"] = Enum.Font.SourceSansBold,
}

local J = {
    ["Tahoma"] = { TTF = "https://github.com/LuckyHub1/LuckyHub/raw/main/zekton_rg.ttf" },
    ["Minecraftia"] = { TTF = "https://github.com/LuckyHub1/LuckyHub/raw/refs/heads/main/Minecraftia.ttf" },
    ["Smallest Pixel-7"] = { TTF = "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/smallest_pixel-7.ttf" },
    ["Proggy Clean"] = { TTF = "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyClean.ttf" },
    ["Tahoma Modern Bold"] = { TTF = "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Tahoma-Modern-Bold.ttf" },
}

local K = { Loaded = {} }
local L = true


local M = {
    
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

local function N(O, P)
    local Q = O:FindFirstChild(P)
    if Q then return Q.Position end

    
    if P == "Head" then
        Q = O:FindFirstChild("Head")
    elseif P == "UpperTorso" then
        Q = O:FindFirstChild("Torso")
    elseif P == "LowerTorso" then
        Q = O:FindFirstChild("Torso")
        if Q then return (Q.CFrame * CFrame.new(0, -1.2, 0)).Position end
    elseif P == "LeftUpperArm" then
        Q = O:FindFirstChild("Left Arm") or O:FindFirstChild("LeftArm")
    elseif P == "LeftLowerArm" then
        Q = O:FindFirstChild("Left Arm") or O:FindFirstChild("LeftArm")
        if Q then return (Q.CFrame * CFrame.new(0, -0.8, 0)).Position end
    elseif P == "LeftHand" then
        Q = O:FindFirstChild("Left Arm") or O:FindFirstChild("LeftArm")
        if Q then return (Q.CFrame * CFrame.new(0, -1.5, 0)).Position end
    elseif P == "RightUpperArm" then
        Q = O:FindFirstChild("Right Arm") or O:FindFirstChild("RightArm")
    elseif P == "RightLowerArm" then
        Q = O:FindFirstChild("Right Arm") or O:FindFirstChild("RightArm")
        if Q then return (Q.CFrame * CFrame.new(0, -0.8, 0)).Position end
    elseif P == "RightHand" then
        Q = O:FindFirstChild("Right Arm") or O:FindFirstChild("RightArm")
        if Q then return (Q.CFrame * CFrame.new(0, -1.5, 0)).Position end
    elseif P == "LeftUpperLeg" then
        Q = O:FindFirstChild("Left Leg") or O:FindFirstChild("LeftLeg")
    elseif P == "LeftLowerLeg" then
        Q = O:FindFirstChild("Left Leg") or O:FindFirstChild("LeftLeg")
        if Q then return (Q.CFrame * CFrame.new(0, -0.8, 0)).Position end
    elseif P == "LeftFoot" then
        Q = O:FindFirstChild("Left Leg") or O:FindFirstChild("LeftLeg")
        if Q then return (Q.CFrame * CFrame.new(0, -1.5, 0)).Position end
    elseif P == "RightUpperLeg" then
        Q = O:FindFirstChild("Right Leg") or O:FindFirstChild("RightLeg")
    elseif P == "RightLowerLeg" then
        Q = O:FindFirstChild("Right Leg") or O:FindFirstChild("RightLeg")
        if Q then return (Q.CFrame * CFrame.new(0, -0.8, 0)).Position end
    elseif P == "RightFoot" then
        Q = O:FindFirstChild("Right Leg") or O:FindFirstChild("RightLeg")
        if Q then return (Q.CFrame * CFrame.new(0, -1.5, 0)).Position end
    end

    return Q and Q.Position
end
local O = writefile and isfile and getcustomasset
local function P(Q, R)
    if not O then return end
    local S = Q:gsub("%s+", "")
    local T, U = pcall(function() return game:HttpGet(R) end)
    if not T or not U or U == "" then return end
    local V = pcall(writefile, S .. ".ttf", U)
    if not V then return end
    local W = pcall(function()
        local W = {
            name = S,
            faces = { { name = "Regular", weight = 400, style = "normal", assetId = getcustomasset(S .. ".ttf") } }
        }
        writefile(S .. ".ttf.json", h:JSONEncode(W))
    end)
    if not W then return end
    local X, Y = pcall(Font.new, getcustomasset(S .. ".ttf.json"), Enum.FontWeight.Regular)
    if X and Y then
        K.Loaded[Q] = Y
    end
end

local function Q()
    if not O then L = false; return end
    for R, S in pairs(J) do
        if K.Loaded[R] then continue end
        P(R, S.TTF)
    end
    L = false
    for R in pairs(J) do
        if not K.Loaded[R] then L = true; break end
    end
end

task.spawn(function()
    task.wait(1)
    Q()
end)



local R = {}


local function S(T)
    local U = string.split(T, ".")
    local V = game
    for W, X in ipairs(U) do
        if V == game and (X == "Workspace" or X == "workspace") then
            V = g
        elseif V == game and X == "Players" then
            V = e
        else
            local Y = V:FindFirstChild(X)
            if Y then
                V = Y
            else
                return nil
            end
        end
    end
    return V ~= game and V or nil
end

local function T(U)
    local V = Instance.new("Frame")
    V.BorderSizePixel = 0
    V.BackgroundColor3 = C.BoxColor
    V.Parent = U

    local W = Instance.new("Frame")
    W.BorderSizePixel = 0
    W.BackgroundColor3 = C.Outlines.Color
    W.ZIndex = 0
    W.Parent = V

    return V, W
end

local aa = function(U)
    LPH_ATTRIBUTES(VM(NONE))
    local V = {
        Visible = false,
        Lines = {},
        Outlines = {},
        CornerLines = {},
        CornerOutlines = {},

        FlagLabels = {},
        LastVisCheck = 0,
        CachedModelVisible = true
    }

    local W = Instance.new("Frame")
    W.BackgroundTransparency = 1
    W.Name = "ESPObj"
    W.Parent = q
    V.Container = W

    local X = Instance.new("Frame")
    X.BorderSizePixel = 0
    X.ZIndex = 0
    X.Visible = false
    X.Parent = W
    V.BoxFill = X

    local Y = Instance.new("UIGradient")
    Y.Parent = X
    V.BoxFillGradient = Y

    for Z = 1, 4 do
        local _, aa = T(W)
        V.Lines[Z] = _
        V.Outlines[Z] = aa
    end

    for aa = 1, 8 do
        local Z, _ = T(W)
        Z.Visible = false
        _.Visible = false
        V.CornerLines[aa] = Z
        V.CornerOutlines[aa] = _
    end

    local function aa(Z)
        Z.BackgroundTransparency = 1
        Z.Size = UDim2.new(0, 100, 0, C.TextSize)
        Z.Font = I[C.Font] or Enum.Font.Code
        if K.Loaded[C.Font] then
            Z.FontFace = K.Loaded[C.Font]
        end
        Z.TextSize = C.TextSize
        Z.TextColor3 = C.TextColor
        Z.TextStrokeTransparency = 1
        Z.ZIndex = 2
        Z.Parent = W

        local _ = Instance.new("UIStroke")
        _.Thickness = 1
        _.Color = C.TextOutlineColor or C.Outlines.Color
        _.LineJoinMode = Enum.LineJoinMode.Miter
        _.Enabled = C.TextOutline
        _.Parent = Z
        A[Z] = _
    end

    local Z = Instance.new("TextLabel")
    aa(Z)
    Z.TextYAlignment = Enum.TextYAlignment.Bottom
    Z.RichText = true
    Z.Text = U
    Z.Visible = C.Names
    V.Text = Z

    V.TeamText = nil
    V.TeamTextStroke = nil
    V.FriendlyText = nil
    V.FriendlyTextStroke = nil

    local _ = Instance.new("TextLabel")
    aa(_)
    _.TextYAlignment = Enum.TextYAlignment.Top
    _.Visible = false
    V.DistanceText = _

    local ab = Instance.new("TextLabel")
    aa(ab)
    ab.TextYAlignment = Enum.TextYAlignment.Top
    ab.Visible = false
    V.WeaponText = ab

    local ac = Instance.new("Frame")
    ac.BackgroundColor3 = C.Outlines.Color
    ac.BorderSizePixel = 0
    ac.Visible = false
    ac.ZIndex = 1
    ac.Parent = W
    V.HealthBarOutline = ac

    local ad = Instance.new("Frame")
    ad.BackgroundTransparency = 1
    ad.ClipsDescendants = true
    ad.BorderSizePixel = 0
    ad.ZIndex = 2
    ad.Parent = ac
    V.HealthBarContainer = ad

    local ae = Instance.new("Frame")
    ae.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ae.BorderSizePixel = 0
    ae.ZIndex = 2
    ae.Parent = ad
    V.HealthBar = ae

    local af = Instance.new("UIGradient")
    af.Enabled = C.HealthBar.Gradient.Enabled
    af.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.HealthBar.Gradient.Color1),
        ColorSequenceKeypoint.new(0.5, C.HealthBar.Gradient.Color2),
        ColorSequenceKeypoint.new(1, C.HealthBar.Gradient.Color3)
    })
    af.Parent = ae
    V.HealthGradient = af

    local ag = Instance.new("TextLabel")
    aa(ag)
    ag.TextYAlignment = Enum.TextYAlignment.Center
    ag.ZIndex = 3
    ag.Visible = false
    V.HealthText = ag

    for ah = 1, 12 do 
        local ai = Instance.new("TextLabel")
        aa(ai)
        ai.TextSize = C.Flags.TextSize
        ai.Font = I[C.Flags.Font] or Enum.Font.Code
        if K.Loaded[C.Flags.Font] then
            ai.FontFace = K.Loaded[C.Flags.Font]
        end
        ai.Visible = false
        V.FlagLabels[ah] = ai
    end

    V.Bones = {}
    V.BoneOutlines = {}
    for ah = 1, #M do
        local ai = Instance.new("Frame")
        ai.BorderSizePixel = 0
        ai.Visible = false
        ai.ZIndex = 1
        ai.Parent = W
        V.BoneOutlines[ah] = ai

        local aj = Instance.new("Frame")
        aj.BorderSizePixel = 0
        aj.Visible = false
        aj.ZIndex = 2
        aj.Parent = W
        V.Bones[ah] = aj
    end

    local ah = Instance.new("TextLabel")
    ah.BackgroundTransparency = 1
    ah.Text = "▲"
    ah.TextColor3 = C.OffScreenArrows.Color
    ah.TextSize = C.OffScreenArrows.Size
    ah.Font = Enum.Font.SourceSans
    ah.Size = UDim2.new(0, C.OffScreenArrows.Size * 2, 0, C.OffScreenArrows.Size * 2)
    ah.ZIndex = 100
    ah.Visible = false
    ah.Parent = q
    V.ArrowInner = ah

    local ai = Instance.new("TextLabel")
    ai.BackgroundTransparency = 1
    ai.Text = "▲"
    ai.TextColor3 = C.OffScreenArrows.OutlineColor
    ai.TextSize = C.OffScreenArrows.Size + 2
    ai.Font = Enum.Font.SourceSans
    ai.Size = UDim2.new(0, (C.OffScreenArrows.Size + 2) * 2, 0, (C.OffScreenArrows.Size + 2) * 2)
    ai.ZIndex = 99
    ai.Visible = false
    ai.Parent = q
    V.ArrowOutline = ai

    local function aj()
        local ak = Instance.new("TextLabel")
        ak.BackgroundTransparency = 1
        ak.Size = UDim2.new(0, 150, 0, 12)
        ak.TextStrokeTransparency = 1
        ak.ZIndex = 110
        ak.TextColor3 = Color3.fromRGB(255, 255, 255)
        ak.Visible = false
        ak.Parent = q
        local al = Instance.new("UIStroke")
        al.Parent = ak
        A[ak] = al
        return ak
    end
    V.ArrowName = aj()
    V.ArrowDist = aj()

    V.Adornments = {}
    V.Highlight = nil

    V.Destroy = function()
        W:Destroy()
        if V.Highlight then V.Highlight:Destroy() end
        if V.MeshShell then V.MeshShell:Destroy() end
        for ak, al in pairs(V.Adornments) do al:Destroy() end
        if V.ArrowInner then V.ArrowInner:Destroy() end
        if V.ArrowOutline then V.ArrowOutline:Destroy() end
        if V.ArrowName then V.ArrowName:Destroy() end
        if V.ArrowDist then V.ArrowDist:Destroy() end
    end

    return V
end



local function ab(ac)
    if not ac then return nil end
    local ad = ac:FindFirstChild("Health")
    if ad and ad:IsA("ValueBase") then
        return ad.Value, (ad:GetAttribute("MaxHealth") or 100)
    end
    return nil
end


local function ac(ad, ae, af, ag)
    if af == "Average" then
        local ah, ai, aj = 0, 0, 0
        for ak, al in ipairs(ad:GetChildren()) do
            if al:IsA("BasePart") then
                local U, V = ab(al)
                if U then
                    ah = ah + U
                    ai = ai + V
                    aj = aj + 1
                end
            end
        end
        if aj > 0 then return ah / aj, ai / aj end
    elseif af == "Part" then
        local ah, ai = ab(ad:FindFirstChild(ag))
        if ah then return ah, ai end
    end

    
    if ae then
        return ae.Health, ae.MaxHealth
    end
    return 100, 100
end

local ad = function(ad, ae, af, ag, ah, ai, aj, ak,
                                               al,
                                               U, V)
    LPH_ATTRIBUTES(VM(NONE))
    local W = {}
    local function X(Y)
        local Z = W[Y]
        if Z ~= nil then return Z end
        local _ = Y:split(".")
        local am = U
        local an = C

        local ao = true
        for ap, aq in ipairs(_) do
            if type(am) == "table" and am[aq] ~= nil then
                am = am[aq]
            else
                ao = false
                break
            end
        end

        if ao then
            W[Y] = am
            return am
        end

        local ap = an
        for aq, ar in ipairs(_) do
            ap = ap[ar]
        end
        W[Y] = ap
        return ap
    end

    local am = tick()
    local an = not ak and ai:FindFirstChild("Humanoid") or nil

    
    local ao = X("MaxDistance")
    if ao and ao > 0 and ah and ah > ao then
        ad.Container.Visible = false
        if ad.Highlight then ad.Highlight:Destroy() ad.Highlight = nil end
        if ad.MeshShell then ad.MeshShell:Destroy() ad.MeshShell = nil ad.MeshHighlight = nil end
        if ad.Adornments then for ap, aq in pairs(ad.Adornments) do aq.Visible = false end end
        if ad.ArrowInner then
            ad.ArrowInner.Visible = false
            ad.ArrowOutline.Visible = false
            ad.ArrowName.Visible = false
            ad.ArrowDist.Visible = false
        end
        if ad.Bones then for ap, aq in ipairs(ad.Bones) do aq.Visible = false end end
        if ad.BoneOutlines then for ap, aq in ipairs(ad.BoneOutlines) do aq.Visible = false end end
        return
    end

    
    local ap = (an and an.Health <= 0)
    local aq = X("Chams.Enabled")
    if aq and not ap then
        local ar = X("Chams.Type")
        if ar == "Highlight" and (ai:IsA("Model") or ai:IsA("BasePart")) then
            
            if ad.MeshShell then
                ad.MeshShell:Destroy()
                ad.MeshShell = nil
                ad.MeshHighlight = nil
            end
            if not ad.Highlight then
                ad.Highlight = Instance.new("Highlight")
            end
            local Y = ad.Highlight
            Y.Parent = o
            Y.Adornee = ai
            Y.FillColor = X("Chams.Highlight.FillColor")
            Y.FillTransparency = X("Chams.Highlight.FillTransparency")
            Y.OutlineColor = X("Chams.Highlight.OutlineColor")
            Y.OutlineTransparency = X("Chams.Highlight.OutlineTransparency")
            Y.DepthMode = X("Chams.Highlight.VisibleCheck") and Enum.HighlightDepthMode.Occluded or
                Enum.HighlightDepthMode.AlwaysOnTop
            Y.Enabled = true

            
            if ad.Adornments then
                for Z, _ in pairs(ad.Adornments) do _.Visible = false end
            end
        elseif ar == "Adornment" then
            if ad.Highlight then
                ad.Highlight:Destroy()
                ad.Highlight = nil
            end
            
            if ad.MeshShell then
                ad.MeshShell:Destroy()
                ad.MeshShell = nil
                ad.MeshHighlight = nil
            end

            local Y = ai:IsA("Model") and ai:GetChildren() or { ai }
            local Z = 0

            local _ = X("Chams.Adornment.VisibleCheck")
            local as = X("VisibilityCheckRate") or 0.1
            local at = am
            local au = ad.LastVisCheck or 0
            local av = (at - au) > as

            if _ and av then
                ad.LastVisCheck = at
                local aw = { l }
                if i.Character then table.insert(aw, i.Character) end
                if ai:IsA("Model") then
                    for ax, ay in ipairs(ai:GetDescendants()) do table.insert(aw, ay) end
                else
                    table.insert(aw, ai)
                end

                local ax = ai:IsA("Model") and
                    (ai.PrimaryPart or ai:FindFirstChild("HumanoidRootPart") or ai:FindFirstChildWhichIsA("BasePart")) or
                    ai
                if ax and ax:IsA("BasePart") then
                    local ay = j:GetPartsObscuringTarget({ ax.Position }, aw)
                    ad.CachedModelVisible = (#ay == 0)
                end
            end

            local aw = X("Chams.Adornment.Color")
            local ax = X("Chams.Adornment.VisibleColor")
            local ay = (_ and ad.CachedModelVisible) and ax or aw

            for az, aA in ipairs(Y) do
                if aA:IsA("BasePart") and aA.Name ~= "HumanoidRootPart" then
                    Z = Z + 1
                    local aB = ad.Adornments[Z]
                    if not aB then
                        aB = Instance.new("BoxHandleAdornment")
                        aB.Name = "Cham"
                        aB.Parent = o
                        ad.Adornments[Z] = aB
                    end

                    aB.Adornee = aA
                    aB.Size = aA.Size
                    aB.Color3 = ay
                    aB.Transparency = X("Chams.Adornment.Transparency")
                    aB.AlwaysOnTop = X("Chams.Adornment.AlwaysOnTop")
                    aB.ZIndex = 10
                    aB.Visible = true
                end
            end
            
            for az = Z + 1, #ad.Adornments do
                ad.Adornments[az].Visible = false
            end
        elseif ar == "MeshChams" then
            
            
            local as = e:GetPlayerFromCharacter(ai)
            if not as then
                if ad.MeshShell then
                    ad.MeshShell:Destroy()
                    ad.MeshShell = nil
                    ad.MeshHighlight = nil
                end
            else
                
                if ad.Highlight then
                    ad.Highlight:Destroy()
                    ad.Highlight = nil
                end
                if ad.Adornments then
                    for at, au in pairs(ad.Adornments) do au.Visible = false end
                end

                
                if not ad.MeshShell or not ad.MeshShell.Parent then
                    if ad.MeshShell then
                        ad.MeshShell:Destroy()
                        ad.MeshShell = nil
                        ad.MeshHighlight = nil
                    end

                    y(ai)

                    local at      = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }
                    local au     = {
                        "Head", "UpperTorso", "LowerTorso",
                        "LeftUpperArm", "LeftLowerArm", "LeftHand",
                        "RightUpperArm", "RightLowerArm", "RightHand",
                        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
                        "RightUpperLeg", "RightLowerLeg", "RightFoot",
                    }
                    local av = ai:FindFirstChild("Humanoid")
                    local aw        = av and (av.RigType == Enum.HumanoidRigType.R15)
                    local ax    = aw and au or at

                    local ay   = Instance.new("Model")
                    ay.Name    = "ChamShells"
                    ay:SetAttribute("SensoryESP_MeshCham", true)
                    ay:SetAttribute("SensoryESP_RunId", t)
                    ay.Parent = ai

                    for az, aA in ipairs(ax) do
                        local aB = ai:FindFirstChild(aA)
                        if aB and aB:IsA("BasePart") then
                            local Y = Instance.new("Part")
                            Y.Name  = "ChamShell_" .. aA
                            Y:SetAttribute("SensoryESP_MeshCham", true)
                            Y:SetAttribute("SensoryESP_RunId", t)
                            Y.Size         = aB.Size * 1.015
                            Y.Transparency = 0.9999999
                            Y.CastShadow   = false
                            Y.CanCollide   = false
                            Y.CanQuery     = false
                            Y.CanTouch     = false
                            Y.Anchored     = false
                            Y.Massless     = true
                            Y.CFrame       = aB.CFrame
                            Y.Parent       = ay

                            local Z         = Instance.new("Weld")
                            Z.Part0         = Y
                            Z.Part1         = aB
                            Z.C0            = CFrame.new()
                            Z.C1            = CFrame.new()
                            Z.Parent        = Y
                        end
                    end

                    
                    local az = Instance.new("Highlight")
                    az.Name  = "ChamShellHighlight"
                    az:SetAttribute("SensoryESP_MeshCham", true)
                    az:SetAttribute("SensoryESP_RunId", t)
                    az.Adornee           = ay
                    az.Parent            = ay
                    ad.MeshShell     = ay
                    ad.MeshHighlight = az
                end

                
                if ad.MeshHighlight then
                    local at               = ad.MeshHighlight
                    at.FillColor           = X("Chams.MeshChams.FillColor")
                    at.FillTransparency    = X("Chams.MeshChams.FillTransparency")
                    at.OutlineColor        = X("Chams.MeshChams.OutlineColor")
                    at.OutlineTransparency = X("Chams.MeshChams.OutlineTransparency")
                    at.DepthMode           = X("Chams.MeshChams.VisibleCheck")
                        and Enum.HighlightDepthMode.Occluded
                        or Enum.HighlightDepthMode.AlwaysOnTop
                    at.Enabled             = true
                end
            end
        end
    else
        
        if ad.Highlight then
            ad.Highlight:Destroy()
            ad.Highlight = nil
        end
        if ad.Adornments then
            for ar, as in pairs(ad.Adornments) do as.Visible = false end
        end
        if ad.MeshShell then
            ad.MeshShell:Destroy()
            ad.MeshShell = nil
            ad.MeshHighlight = nil
        end
    end

    local function ar(as, at, au)
        local av = A[as] or as:FindFirstChildOfClass("UIStroke")
        if not av then return end
        if at == "None" then
            av.Enabled = false
        elseif at == "Shadow" then
            av.Enabled = true
            av.Thickness = 1
            av.Color = au or Color3.fromRGB(0, 0, 0)
        else
            av.Enabled = true
            av.Thickness = 1
            av.Color = au or Color3.fromRGB(0, 0, 0)
        end
    end

    
    if ad.ArrowInner and X("OffScreenArrows.Enabled") and ai:IsA("Model") then
        local as = ai.PrimaryPart or ai:FindFirstChild("HumanoidRootPart") or ai:FindFirstChildWhichIsA("BasePart")
        if as then
            local at = j:WorldToViewportPoint(as.Position)
            local au = j.ViewportSize
            local av, aw = au.X / 2, au.Y / 2
            local ax = at.Z > 0 and at.X >= 0 and at.X <= au.X and at.Y >= 0 and at.Y <= au.Y
            if not ax then
                local ay = X("OffScreenArrows.OrbitRadius")
                local az, aA, aB
                if X("OffScreenArrows.ArrowMode") == "Compass" then
                    
                    local Y = i.Character and (
                        i.Character:FindFirstChild("HumanoidRootPart") or
                        i.Character:FindFirstChild("Torso") or
                        i.Character:FindFirstChildWhichIsA("BasePart")
                    )
                    local Z = Y and Y.Position or j.CFrame.Position
                    local _ = (Vector3.new(as.Position.X, 0, as.Position.Z) - Vector3.new(Z.X, 0, Z.Z)).Unit
                    local aC = Y and Y.CFrame:VectorToObjectSpace(_) or _
                    az, aA = aC.X, aC.Z
                    aB = math.deg(math.atan2(aC.Z, aC.X)) + 90
                else
                    
                    local aC = (as.Position - j.CFrame.Position).Unit
                    local Y = j.CFrame:VectorToObjectSpace(aC)
                    az, aA = Y.X, -Y.Y
                    aB = math.deg(math.atan2(-Y.Y, Y.X)) + 90
                end
                local aC = math.sqrt(az * az + aA * aA)
                if aC > 0.001 then
                    az, aA = az / aC, aA / aC
                else
                    az, aA = 0, -1
                end
                local Y, Z = av + az * ay, aw + aA * ay
                local _ = X("OffScreenArrows.Size")
                local aD = X("OffScreenArrows.Color")

                if X("OffScreenArrows.Outline") then
                    ad.ArrowOutline.TextSize = _ + 2
                    ad.ArrowOutline.TextColor3 = X("OffScreenArrows.OutlineColor")
                    ad.ArrowOutline.Position = UDim2.new(0, Y - _ - 2, 0, Z - _ - 2)
                    ad.ArrowOutline.Rotation = aB
                    ad.ArrowOutline.Visible = true
                else
                    ad.ArrowOutline.Visible = false
                end

                local aE = I[X("OffScreenArrows.Font")] or Enum.Font.SourceSans
                ad.ArrowInner.Text = "▲"
                ad.ArrowInner.Font = aE
                ad.ArrowInner.TextSize = _
                ad.ArrowInner.TextColor3 = aD
                ad.ArrowInner.Position = UDim2.new(0, Y - _, 0, Z - _)
                ad.ArrowInner.Size = UDim2.new(0, _ * 2, 0, _ * 2)
                ad.ArrowInner.Rotation = aB
                ad.ArrowInner.Visible = true

                
                local aF = Z + _ + 4

                if X("OffScreenArrows.Names.Enabled") and ag and ag ~= "" then
                    local aG = X("OffScreenArrows.Names.Font")
                    local aH = X("OffScreenArrows.Names.TextSize")
                    local aI = I[aG] or Enum.Font.Code
                    local aJ = K.Loaded[aG]
                    local aK = X("OffScreenArrows.Names.Side")
                    local aL = X("OffScreenArrows.Names.Gap") or 4
                    local aM = X("OffScreenArrows.Names.Color")
                    local aN = X("OffScreenArrows.Names.Outline")
                    local aO = X("OffScreenArrows.Names.OutlineColor")
                    ad.ArrowName.Font = aI
                    if aJ then ad.ArrowName.FontFace = aJ end
                    ad.ArrowName.TextSize = aH
                    ad.ArrowName.TextColor3 = aM
                    ad.ArrowName.Text = ag
                    if aK == "Top" then
                        ad.ArrowName.Position = UDim2.new(0, Y - 75, 0, Z - _ - aL - aH)
                    elseif aK == "Left" then
                        ad.ArrowName.Position = UDim2.new(0, Y - _ - aL - 150, 0, Z - 6)
                    elseif aK == "Right" then
                        ad.ArrowName.Position = UDim2.new(0, Y + _ + aL, 0, Z - 6)
                    else
                        ad.ArrowName.Position = UDim2.new(0, Y - 75, 0, aF)
                        aF = aF + aH + 1
                    end
                    ar(ad.ArrowName, aN and "Full" or "None", aO or Color3.fromRGB(0, 0, 0))
                    ad.ArrowName.Visible = true
                else
                    ad.ArrowName.Visible = false
                end

                if X("OffScreenArrows.Distance.Enabled") then
                    local aG = X("OffScreenArrows.Distance.Font")
                    local aH = X("OffScreenArrows.Distance.TextSize")
                    local aI = I[aG] or Enum.Font.Code
                    local aJ = K.Loaded[aG]
                    local aK = X("OffScreenArrows.Distance.Side")
                    local aL = X("OffScreenArrows.Distance.Gap") or 2
                    local aM = X("OffScreenArrows.Distance.Color")
                    local aN = X("OffScreenArrows.Distance.Outline")
                    local aO = X("OffScreenArrows.Distance.OutlineColor")
                    local aP = X("Distance.Unit")
                    local aQ
                    if aP == "Meters" then
                        aQ = math.floor(ah / X("Distance.StudsPerMeter"))
                    else
                        aQ = math.floor(ah)
                    end
                    ad.ArrowDist.Font = aI
                    if aJ then ad.ArrowDist.FontFace = aJ end
                    ad.ArrowDist.TextSize = aH
                    ad.ArrowDist.TextColor3 = aM
                    ad.ArrowDist.Text = aQ .. X("Distance.Ending")
                    if aK == "Top" then
                        ad.ArrowDist.Position = UDim2.new(0, Y - 75, 0, Z - _ - aL - aH)
                    elseif aK == "Left" then
                        ad.ArrowDist.Position = UDim2.new(0, Y - _ - aL - 150, 0, Z - 6)
                    elseif aK == "Right" then
                        ad.ArrowDist.Position = UDim2.new(0, Y + _ + aL, 0, Z - 6)
                    else
                        ad.ArrowDist.Position = UDim2.new(0, Y - 75, 0, aF)
                    end
                    ar(ad.ArrowDist, aN and "Full" or "None", aO or Color3.fromRGB(0, 0, 0))
                    ad.ArrowDist.Visible = true
                else
                    ad.ArrowDist.Visible = false
                end
            else
                ad.ArrowInner.Visible = false
                ad.ArrowOutline.Visible = false
                ad.ArrowName.Visible = false
                ad.ArrowDist.Visible = false
            end
        else
            ad.ArrowInner.Visible = false
            ad.ArrowOutline.Visible = false
            ad.ArrowName.Visible = false
            ad.ArrowDist.Visible = false
        end
    else
        if ad.ArrowInner then
            ad.ArrowInner.Visible = false
            ad.ArrowOutline.Visible = false
            ad.ArrowName.Visible = false
            ad.ArrowDist.Visible = false
        end
    end

    if not V or not ae or not af then
        ad.Container.Visible = false
        return
    end

    ad.Container.Visible = true
    ad.Container.ZIndex = ak and 1 or 10
    if X("Names") then
        ad.Text.Text = ag
    end

    local as = X("TextOutlineStyle")
    
    if X("TextOutline") == false then as = "None" end
    local at = X("TextOutlineColor") or X("Outlines.Color")

    local au = X("BoxThickness")
    local av = X("Outlines.Thickness")
    local aw = X("TextSize")
    local ax = X("TextColor")
    local ay = X("Font")
    local az = I[ay] or Enum.Font.Code
    local aA = K.Loaded[ay]
    local aB = X("BoxColor")
    
    ad.Text.TextSize = aw
    ad.Text.TextColor3 = ax
    ad.Text.Font = az
    if aA then
        ad.Text.FontFace = aA
    end
    ar(ad.Text, as, at)

    do
        local aC = X("Distance.Font")
        local aD = I[aC] or Enum.Font.Code
        ad.DistanceText.TextSize = X("Distance.TextSize") or aw
        ad.DistanceText.TextColor3 = X("Distance.Color")
        ad.DistanceText.Font = aD
        if K.Loaded[aC] then
            ad.DistanceText.FontFace = K.Loaded[aC]
        end
        ar(ad.DistanceText, X("Distance.OutlineStyle") or as, at)
    end

    do
        local aC = X("Weapon.Font")
        local aD = I[aC] or Enum.Font.Code
        ad.WeaponText.TextSize = X("Weapon.TextSize") or aw
        ad.WeaponText.TextColor3 = X("Weapon.Color")
        ad.WeaponText.Font = aD
        if K.Loaded[aC] then
            ad.WeaponText.FontFace = K.Loaded[aC]
        end
        ar(ad.WeaponText, X("Weapon.OutlineStyle") or as, at)
    end

    local aC, aD = math.floor(ae.X), math.floor(ae.Y)
    local aE, aF = math.floor(af.X), math.floor(af.Y)
    local aG, aH = math.floor(aC - aE / 2), math.floor(aD - aF / 2)

    
    local aI, aJ, aK = 100, 100, 1
    local aL = X("HealthBar.Source")
    if aL and aL ~= "Humanoid" then
        aI, aJ = ac(ai, an, aL, X("HealthBar.Part"))
        aK = math.clamp(aI / (aJ > 0 and aJ or 1), 0, 1)
    elseif an then
        aI = an.Health
        aJ = an.MaxHealth
        aK = math.clamp(aI / aJ, 0, 1)
    end

    
    local aM = 0
    local aN = 0
    local aO = 0
    local aP = 0
    if X("HealthBar.Enabled") and ai:IsA("Model") and an then
        local aQ = X("HealthBar.Position")
        local Y = X("HealthBar.Width") + 2 + X("HealthBar.SideGap")
        local Z = X("Flags.Position") == "Right"
        local _ = (X("HealthBar.ShowText") and aI < aJ) and 20 or 0

        if aQ == "Top" then
            aM = Y
        elseif aQ == "Bottom" then
            aN = Y
        elseif aQ == "Left" then
            aO = Y + _
        elseif aQ == "Right" then
            aP = Y + _
        end
    end

    if aj then
        for aQ = 1, 4 do
            ad.Lines[aQ].Visible = false
            ad.Outlines[aQ].Visible = false
        end
        ad.HealthBarOutline.Visible = false
        ad.HealthText.Visible = false
        ad.WeaponText.Visible = false
        for aQ, Y in ipairs(ad.FlagLabels) do Y.Visible = false end

        local aQ = X("Distance.Unit")
        local Y = ah
        if aQ == "Meters" then
            Y = math.floor(ah / X("Distance.StudsPerMeter"))
        else
            Y = math.floor(ah)
        end

        ad.Text.Text = ag .. " " .. Y .. X("Distance.Ending")
        ad.Text.Position = UDim2.new(0, aC - 50, 0, aD - (aw / 2))
        ad.Text.Visible = X("Names")
        ad.DistanceText.Visible = false
        return
    end

    
    ad.Lines[1].Position = UDim2.new(0, aG, 0, aH)
    ad.Lines[1].Size = UDim2.new(0, aE, 0, au)
    
    ad.Lines[2].Position = UDim2.new(0, aG, 0, aH + aF)
    ad.Lines[2].Size = UDim2.new(0, aE + au, 0, au)
    
    ad.Lines[3].Position = UDim2.new(0, aG, 0, aH)
    ad.Lines[3].Size = UDim2.new(0, au, 0, aF)
    
    ad.Lines[4].Position = UDim2.new(0, aG + aE, 0, aH)
    ad.Lines[4].Size = UDim2.new(0, au, 0, aF + au)

    local aQ = X("Boxes")
    local Y = X("BoxType") or "Normal"
    local Z = Y == "Corner"

    local _ = X("Outlines.Style")
    local aR = X("Outlines.Color")
    local aS = X("Outlines.Thickness")
    
    if X("Outlines.Enabled") == false then _ = "None" end
    local aT = 0
    local aU = _ ~= "None"

    if Z then
        local aV = math.max(math.floor(aE * 0.25), au * 3)
        local aW = math.max(math.floor(aF * 0.25), au * 3)

        local aX = {
            { aG,                        aH,                         aV, au },
            { aG,                        aH,                         au,           aW },
            { aG + aE - aV + au, aH,                         aV, au },
            { aG + aE,                   aH,                         au,           aW },
            { aG,                        aH + aF,                    aV, au },
            { aG,                        aH + aF - aW + au, au,           aW },
            { aG + aE - aV + au, aH + aF,                    aV, au },
            { aG + aE,                   aH + aF - aW + au, au,           aW },
        }

        for aY = 1, 8 do
            local aZ = aX[aY]
            ad.CornerLines[aY].Position = UDim2.new(0, aZ[1], 0, aZ[2])
            ad.CornerLines[aY].Size = UDim2.new(0, aZ[3], 0, aZ[4])
        end
    end

    for aV = 1, 4 do
        ad.Lines[aV].Visible = aQ and not Z
        ad.Outlines[aV].Visible = aQ and aU and not Z

        ad.Outlines[aV].Position = UDim2.new(0, -aS, 0, -aS)
        ad.Outlines[aV].Size = UDim2.new(1, aS * 2, 1, aS * 2)
        ad.Outlines[aV].BackgroundTransparency = aT
        ad.Lines[aV].BackgroundColor3 = aB
        ad.Outlines[aV].BackgroundColor3 = aR
    end

    for aV = 1, 8 do
        ad.CornerLines[aV].Visible = aQ and Z
        ad.CornerOutlines[aV].Visible = aQ and aU and Z

        ad.CornerOutlines[aV].Position = UDim2.new(0, -aS, 0, -aS)
        ad.CornerOutlines[aV].Size = UDim2.new(1, aS * 2, 1, aS * 2)
        ad.CornerOutlines[aV].BackgroundTransparency = aT
        ad.CornerLines[aV].BackgroundColor3 = aB
        ad.CornerOutlines[aV].BackgroundColor3 = aR
    end

    
    local aV = ad.BoxFill
    local aW = ad.BoxFillGradient
    if X("BoxFill.Enabled") and aQ then
        aV.Visible = true
        aV.Position = UDim2.new(0, aG, 0, aH)
        aV.Size = UDim2.new(0, aE, 0, aF)
        aV.BackgroundTransparency = X("BoxFill.Transparency")

        if X("BoxFill.Gradient.Enabled") then
            aW.Enabled = true
            local aX = X("BoxFill.Gradient.Color1")
            local aY = X("BoxFill.Gradient.Color2")
            local aZ = X("BoxFill.Gradient.Color3")
            aW.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, aX),
                ColorSequenceKeypoint.new(0.5, aY),
                ColorSequenceKeypoint.new(1, aZ)
            })

            local a_ = X("BoxFill.Gradient.Rotation")
            if X("BoxFill.Gradient.Animated") then
                local a0 = X("BoxFill.Gradient.Speed")
                local a1 = X("BoxFill.Gradient.Direction") == "Left" and -1 or 1
                a_ = (a_ + (am * a0 * a1)) % 360
            end
            aW.Rotation = a_
            aV.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            aW.Enabled = false
            aV.BackgroundColor3 = X("BoxFill.Color")
        end
    else
        aV.Visible = false
    end

    local aX = aH - aw - (X("TextGap") or 0) - aM
    local aY = ai:IsA("Model") and e:GetPlayerFromCharacter(ai) or nil
    local aZ = {}
    local a_ = {}

    if X("TeamIndicator.Enabled") and aY and aY.Team then
        local a0 = X("TeamIndicator.UseTeamColor") and aY.TeamColor.Color or
        X("TeamIndicator.Color")
        local a1 = aY.Team.Name
        local a2 = X("TeamIndicator.Compact") and G(a1) or a1
        local a3 = string.format('<font color="%s">[%s]</font>', H(a0), a2)
        if X("TeamIndicator.Position") == "Left" then
            table.insert(aZ, a3)
        else
            table.insert(a_, a3)
        end
    end

    local a0 = false
    if aY and X("FriendlyIndicator.Enabled") then
        if X("FriendlyIndicator.CheckTeam") and i.Team ~= nil and aY.Team == i.Team then
            a0 = true
        end
        if not a0 and X("FriendlyIndicator.CheckFriends") then
            local a1, a2 = pcall(function()
                return i:IsFriendsWith(aY.UserId)
            end)
            if a1 and a2 then
                a0 = true
            end
        end
    end

    if a0 then
        local a1 = string.format('<font color="%s">%s</font>', H(X("FriendlyIndicator.Color")),
            X("FriendlyIndicator.Text"))
        if X("FriendlyIndicator.Position") == "Left" then
            table.insert(aZ, a1)
        else
            table.insert(a_, a1)
        end
    end

    local a1 = ag
    if #aZ > 0 then
        a1 = table.concat(aZ, " ") .. " " .. a1
    end
    if #a_ > 0 then
        a1 = a1 .. " " .. table.concat(a_, " ")
    end

    if X("Names") then
        ad.Text.Text = a1
        ad.Text.Position = UDim2.new(0, aC - 50, 0, aX)
        ad.Text.Visible = true
    else
        ad.Text.Visible = false
    end

    local a2 = X("Distance.Gap") or 0
    local a3 = aH + aF + a2 + aN
    if X("Distance.Enabled") then
        ad.DistanceText.Visible = true
        ad.DistanceText.Position = UDim2.new(0, aC - 50, 0, a3)

        local a4 = X("Distance.Unit")
        local a5 = ah
        if a4 == "Meters" then
            a5 = math.floor(ah / X("Distance.StudsPerMeter"))
        else
            a5 = math.floor(ah)
        end
        ad.DistanceText.Text = a5 .. X("Distance.Ending")
        a3 = a3 + (X("Distance.TextSize") or aw) + (X("Weapon.Gap") or 0)
    else
        ad.DistanceText.Visible = false
    end

    
    if X("Weapon.Enabled") then
        local a4 = nil

        
        local a5 = ai:FindFirstChild("Holding")
        if a5 then
            if a5:IsA("ValueBase") then
                if a5.Value then
                    a4 = tostring(a5.Value)
                end
            else
                a4 = a5.Name
            end
        end

        
        if (not a4 or a4 == "" or a4 == "nil") and X("Weapon.UseToolFallback") then
            local a6 = ai:FindFirstChildWhichIsA("Tool")
            if a6 then a4 = a6.Name end
        end

        
        if not a4 or a4 == "" or a4 == "nil" then
            a4 = "None"
        end

        ad.WeaponText.Visible = true
        ad.WeaponText.Text = a4
        ad.WeaponText.Position = UDim2.new(0, aC - 50, 0, a3)
    else
        ad.WeaponText.Visible = false
    end

    
    if X("HealthBar.Enabled") and ai:IsA("Model") and an then
        
        local a4 = X("HealthBar.Position")
        local a5 = (a4 == "Top" or a4 == "Bottom")
        local a6 = X("HealthBar.Width")
        local a7 = X("HealthBar.SideGap")
        local a8 = X("HealthBar.TextFollowBar")

        local a9 = X("HealthBar.Outline.Style")
        
        if X("HealthBar.Outline.Enabled") == false then a9 = "None" end
        ad.HealthBarOutline.Visible = a9 ~= "None"
        ad.HealthBarOutline.BackgroundTransparency = 0
        ad.HealthBarOutline.BackgroundColor3 = X("HealthBar.Outline.Color")
        local ba

        if a5 then
            ba = math.floor((aE + 1) * aK)
            ad.HealthBarOutline.Size = UDim2.new(0, aE + 3, 0, a6 + 2)

            if a4 == "Top" then
                ad.HealthBarOutline.Position = UDim2.new(0, aG - 1, 0,
                    aH - av - a7 - a6 - 1)
            else 
                ad.HealthBarOutline.Position = UDim2.new(0, aG - 1, 0, aH + aF + av + a7)
            end

            ad.HealthBarContainer.Size = UDim2.new(0, ba, 0, a6)
            ad.HealthBarContainer.Position = UDim2.new(0, 1, 0, 1)

            ad.HealthBar.Size = UDim2.new(0, aE + 1, 0, a6)
            ad.HealthBar.Position = UDim2.new(0, 0, 0, 0)
        else 
            local bb = math.floor((aF + 1) * aK)
            ad.HealthBarOutline.Size = UDim2.new(0, a6 + 2, 0, aF + 3)

            if a4 == "Left" then
                ad.HealthBarOutline.Position = UDim2.new(0,
                    aG - av - a7 - a6 - 1, 0, aH - 1)
            else 
                ad.HealthBarOutline.Position = UDim2.new(0, aG + aE + av + a7, 0, aH - 1)
            end

            ad.HealthBarContainer.Size = UDim2.new(0, a6, 0, bb)
            ad.HealthBarContainer.Position = UDim2.new(0, 1, 0, (aF + 1) - bb + 1)

            ad.HealthBar.Size = UDim2.new(0, a6, 0, aF + 1)
            ad.HealthBar.Position = UDim2.new(0, 0, 0, -(aF + 1 - bb))
        end

        
        local bb = X("HealthBar.Gradient.Enabled")
        local bc = X("HealthBar.ShowText")
        if X("HealthBar.HideWhenFullHP") and aI >= aJ then
            bc = false
        end
        local bd = bc and X("HealthBar.FollowGradientColorText")
        local be = Color3.fromHSV(aK * 0.3, 1, 1)

        if bb and not a5 then
            ad.HealthGradient.Rotation = 90
            ad.HealthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

            if bd then
                if aK > 0.5 then
                    local bf = (1 - aK) * 2
                    be = X("HealthBar.Gradient.Color1"):Lerp(X("HealthBar.Gradient.Color2"), bf)
                else
                    local bf = (0.5 - aK) * 2
                    be = X("HealthBar.Gradient.Color2"):Lerp(X("HealthBar.Gradient.Color3"), bf)
                end
            end
        else
            ad.HealthBar.BackgroundColor3 = be
        end

        if bc then
            ad.HealthText.Visible = true
            ad.HealthText.Text = math.floor(aI)
            ad.HealthText.TextSize = X("HealthBar.TextSize")
            local bf = X("HealthBar.Font")
            local bg = I[bf] or Enum.Font.Code
            ad.HealthText.Font = bg
            if K.Loaded[bf] then
                ad.HealthText.FontFace = K.Loaded[bf]
            end
            ad.HealthText.TextColor3 = bd and be or X("TextColor")
            ar(ad.HealthText, a9, at)

            if a5 then
                ba = math.floor((aE + 1) * aK)
                local bh = aG + ba - 1
                local bi = ad.HealthBarOutline.Position.Y.Offset

                ad.HealthText.TextXAlignment = Enum.TextXAlignment.Center
                ad.HealthText.Size = UDim2.new(0, 0, 0, 0)

                if a8 then
                    ad.HealthText.Position = UDim2.new(0, bh, 0, bi + (a6 / 2) + 1)
                else
                    ad.HealthText.Position = UDim2.new(0, aG + aE, 0, bi + (a6 / 2) + 1)
                end
            else
                local bh = math.floor((aF + 1) * aK)
                local bi = ad.HealthBarOutline.Position.X.Offset
                local bj = aH + (aF + 1) - bh

                ad.HealthText.TextXAlignment = a4 == "Left" and Enum.TextXAlignment.Right or
                    Enum.TextXAlignment.Left
                ad.HealthText.Size = UDim2.new(0, 0, 0, 0)

                local bk = a4 == "Left" and (bi - 2) or (bi + a6 + 4)
                local bl = a8 and bj or aH
                ad.HealthText.Position = UDim2.new(0, bk, 0, bl)
            end
        else
            ad.HealthText.Visible = false
        end
    else
        ad.HealthBarOutline.Visible = false
        ad.HealthText.Visible = false
    end

    
    for a4, a5 in ipairs(ad.FlagLabels) do a5.Visible = false end
    if X("Flags.Enabled") and ai:IsA("Model") and not al and an then
            local a4 = an:GetState()
            local a5 = an.MoveDirection.Magnitude > 0
            local a6 = (a4 == Enum.HumanoidStateType.Jumping or a4 == Enum.HumanoidStateType.FallingDown or a4 == Enum.HumanoidStateType.Freefall)
            local a7 = a4 == Enum.HumanoidStateType.Swimming
            local a8 = X("Flags.Options.Moving")
            local a9 = X("Flags.Options.Jumping")
            local ba = X("Flags.Options.Swimming")
            local bb = X("Flags.Options.Idle")
            local bc = X("Flags.Colors.Moving")
            local bd = X("Flags.Colors.Jumping")
            local be = X("Flags.Colors.Swimming")
            local bf = X("Flags.Colors.Idle")
            local bg = X("Flags.Font")
            local bh = X("Flags.TextSize")
            local bi = X("Flags.TextGap")
            local bj = X("Flags.Gap") or 2
            local bk = X("Flags.SideGap")
            local bl = X("Flags.Position")
            local bm = {}

            if a5 and a6 and a8 and a9 then
                table.insert(bm, { text = "Moving & Jumping", color = bc })
            elseif a6 and a9 then
                table.insert(bm, { text = "Jumping", color = bd })
            elseif a5 and a8 then
                table.insert(bm, { text = "Moving", color = bc })
            elseif a7 and ba then
                table.insert(bm, { text = "Swimming", color = be })
            elseif bb then
                table.insert(bm, { text = "Idle", color = bf })
            end

            local bn = C.FlagProvider
            if bn then
                local bo, bp = pcall(bn, ai, e:GetPlayerFromCharacter(ai))
                if bo and type(bp) == "table" then
                    for bq, br in ipairs(bp) do
                        if #bm >= #ad.FlagLabels then break end
                        bm[#bm + 1] = br
                    end
                end
            end

            local bo = bl == "Right"
            local bp = bo and (aG + aE + bk + aP) or
                (aG - 100 - bk - aO)
            local bq = aH - bj

            if bg == "Smallest Pixel-7" then
                bq = bq - 3
            end

            local br = I[bg] or Enum.Font.Code
            local bs = K.Loaded[bg]
            local bt = X("Flags.OutlineStyle") or as

            for bu, bv in ipairs(bm) do
                local bw = ad.FlagLabels[bu]
                if bw then
                    bw.Visible = true
                    bw.Text = bv.text
                    bw.TextColor3 = bv.color
                    bw.Font = br
                    if bs then
                        bw.FontFace = bs
                    end
                    bw.TextSize = bh
                    bw.TextXAlignment = bo and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right
                    bw.Position = UDim2.new(0, bp, 0,
                        bq + (bu - 1) * (bh + bi))
                    ar(bw, bt, at)
                end
        end
    end

    
    if X("Skeleton.Enabled") and ai:IsA("Model") then
        local a4 = X("Skeleton.Outline")
        local a5 = X("Skeleton.Color")
        local a6 = X("Skeleton.OutlineColor")

        local a7 = {}
        for a8, a9 in ipairs(M) do
            for ba, bb in ipairs(a9) do
                if a7[bb] == nil then
                    local bc = N(ai, bb)
                    local bd, be = bc and k(j, bc)
                    a7[bb] = (bc and be) and Vector2.new(bd.X, bd.Y) or false
                end
            end
        end

        for a8, a9 in ipairs(M) do
            local ba = a7[a9[1] ]
            local bb = a7[a9[2] ]

            if ba and bb then
                if a4 then
                    B(ad.BoneOutlines[a8], ba, bb, 3, a6)
                else
                    ad.BoneOutlines[a8].Visible = false
                end

                B(ad.Bones[a8], ba, bb, 1, a5)
            else
                ad.Bones[a8].Visible = false
                ad.BoneOutlines[a8].Visible = false
            end
        end
    else
        if ad.Bones then
            for a4, a5 in ipairs(ad.Bones) do a5.Visible = false end
            for a4, a5 in ipairs(ad.BoneOutlines) do a5.Visible = false end
        end
    end
end



local ae = function(ae)
    LPH_ATTRIBUTES(VM(NONE))
    local af
    if ae:IsA("Model") then
        af = ae:FindFirstChild("HumanoidRootPart") or ae:FindFirstChild("Torso") or
            ae.PrimaryPart or ae:FindFirstChildWhichIsA("BasePart")
    elseif ae:IsA("BasePart") then
        af = ae
    end

    if not af then return false, nil, nil end

    local ag, ah = j:WorldToViewportPoint(af.Position)
    if not ah then return false, nil, nil end

    if not C.DynamicBoxes then
        
        local ai = ae:IsA("Model") and ae:FindFirstChild("Humanoid")
        if ai then
            
            local aj = ai.RigType == Enum.HumanoidRigType.R6
            local ak = aj and 2.8 or 3.0
            local al = aj and 3.0 or 3.5

            local am = af.Position + Vector3.new(0, ak, 0)
            local an = af.Position - Vector3.new(0, al, 0)
            local ao = j:WorldToViewportPoint(am)
            local ap = j:WorldToViewportPoint(an)
            local aq = math.abs(ao.Y - ap.Y)
            return true, Vector2.new(ag.X, (ao.Y + ap.Y) / 2), Vector2.new(aq * 0.65, aq)
        end

        
        local aj, ak
        if ae:IsA("Model") then
            aj, ak = ae:GetBoundingBox()
        else
            aj, ak = ae.CFrame, ae.Size
        end

        local al, am, an, ao = math.huge, math.huge, -math.huge, -math.huge
        local ap = {
            aj * Vector3.new(ak.X / 2, ak.Y / 2, ak.Z / 2),
            aj * Vector3.new(-ak.X / 2, ak.Y / 2, ak.Z / 2),
            aj * Vector3.new(ak.X / 2, -ak.Y / 2, ak.Z / 2),
            aj * Vector3.new(-ak.X / 2, -ak.Y / 2, ak.Z / 2),
            aj * Vector3.new(ak.X / 2, ak.Y / 2, -ak.Z / 2),
            aj * Vector3.new(-ak.X / 2, ak.Y / 2, -ak.Z / 2),
            aj * Vector3.new(ak.X / 2, -ak.Y / 2, -ak.Z / 2),
            aj * Vector3.new(-ak.X / 2, -ak.Y / 2, -ak.Z / 2),
        }
        for aq, ar in ipairs(ap) do
            local as = j:WorldToViewportPoint(ar)
            if as.X < al then al = as.X end
            if as.X > an then an = as.X end
            if as.Y < am then am = as.Y end
            if as.Y > ao then ao = as.Y end
        end
        return true, Vector2.new((al + an) / 2, (am + ao) / 2), Vector2.new(an - al, ao - am)
    else
        
        local ai, aj, ak, al = math.huge, math.huge, -math.huge, -math.huge
        local am = {}
        if ae:IsA("Model") then
            local an = C.DynamicBoxesIncludeAll
            for ao, ap in ipairs(ae:GetChildren()) do
                if ap:IsA("BasePart") and (an or (ap.Name ~= "HumanoidRootPart" and ap.Transparency ~= 1)) then
                    table.insert(am, ap)
                end
            end
        else
            table.insert(am, ae)
        end

        if #am == 0 then return false, nil, nil end

        if C.DynamicBoxesCheap then
            for an, ao in ipairs(am) do
                local ap, aq = ao.CFrame, ao.Size
                local ar = aq / 2
                local as = ap * Vector3.new(ar.X, ar.Y, ar.Z)
                local at = ap * Vector3.new(-ar.X, -ar.Y, -ar.Z)
                local au = j:WorldToViewportPoint(as)
                local av = j:WorldToViewportPoint(at)
                if au.X < ai then ai = au.X end
                if au.X > ak then ak = au.X end
                if au.Y < aj then aj = au.Y end
                if au.Y > al then al = au.Y end
                if av.X < ai then ai = av.X end
                if av.X > ak then ak = av.X end
                if av.Y < aj then aj = av.Y end
                if av.Y > al then al = av.Y end
            end
        else
            for an, ao in ipairs(am) do
                local ap, aq = ao.CFrame, ao.Size
                local ar = {
                    ap * Vector3.new(aq.X / 2, aq.Y / 2, aq.Z / 2),
                    ap * Vector3.new(-aq.X / 2, aq.Y / 2, aq.Z / 2),
                    ap * Vector3.new(aq.X / 2, -aq.Y / 2, aq.Z / 2),
                    ap * Vector3.new(-aq.X / 2, -aq.Y / 2, aq.Z / 2),
                    ap * Vector3.new(aq.X / 2, aq.Y / 2, -aq.Z / 2),
                    ap * Vector3.new(-aq.X / 2, aq.Y / 2, -aq.Z / 2),
                    ap * Vector3.new(aq.X / 2, -aq.Y / 2, -aq.Z / 2),
                    ap * Vector3.new(-aq.X / 2, -aq.Y / 2, -aq.Z / 2),
                }
                for as, at in ipairs(ar) do
                    local au = j:WorldToViewportPoint(at)
                    if au.X < ai then ai = au.X end
                    if au.X > ak then ak = au.X end
                    if au.Y < aj then aj = au.Y end
                    if au.Y > al then al = au.Y end
                end
            end
        end
        return true, Vector2.new((ai + ak) / 2, (aj + al) / 2), Vector2.new(ak - ai, al - aj)
    end
end



local function af(ag, ah)
    if type(ah) ~= "table" or #ah == 0 then return true end
    if #ah == 1 and ah[1] == "" then return true end
    for ai, aj in ipairs(ah) do
        local ak = false
        for al, am in ipairs(ag:GetChildren()) do
            if am.Name == aj then
                ak = true
                break
            end
        end
        if not ak then return false end
    end
    return true
end

local function ag(ah, ai)
    if type(ai) ~= "table" or #ai == 0 then return true end
    if #ai == 1 and ai[1] == "" then return true end
    for aj, ak in ipairs(ai) do
        if ah.Name == ak then
            return true
        end
    end
    return false
end

local function ah(ai, aj)
    if not aj or #aj == 0 then return false end
    local ak = ai
    while ak and ak ~= game do
        for al, am in ipairs(aj) do
            if am ~= "" and ak.Name:find(am) then
                return true
            end
        end
        ak = ak.Parent
    end
    return false
end

local ai = function()
    LPH_ATTRIBUTES(VM(NONE))
    local ai = {}

    if C.Players then
        for aj, ak in ipairs(e:GetPlayers()) do
            if not C.LocalPlayer and ak == i then continue end
            if ak.Character then
                local al = ak.Character:FindFirstChild("Humanoid")
                if al and al.Health > 0 and (not C.Filter or C.Filter(ak.Character, ak)) then
                    ai[ak.Character] = { name = ak.Name, Cheap = false }
                end
            end
        end
    end

    for aj, ak in pairs(C.Directories) do
        local al = nil
        if type(ak) == "table" and ak.DisplayName and ak.DisplayName ~= "" then
            al = ak.DisplayName
        elseif type(aj) == "string" then
            al = aj
        end

        if type(ak) == "string" then
            local am = S(ak)
            if am then
                ai[am] = { name = al or am.Name, Cheap = false }
            end
        elseif type(ak) == "table" then
            local am = ak.Path
            if not am then continue end
            local an = S(am)
            if not an then continue end

            local ao = ak.Cheap or false
            local ap = ak.NonHuman or false
            local aq = ak.NoStatus or false
            local ar = ak.Config or {}
            local as = ak.Recursive or false

            if ak.Multiple then
                local at = as and an:GetDescendants() or an:GetChildren()
                for au, av in ipairs(at) do
                    if (av:IsA("Model") or av:IsA("BasePart")) then
                        
                        local aw = false
                        local ax = av.Parent
                        while ax and ax ~= an and ax ~= game do
                            if ai[ax] then
                                aw = true
                                break
                            end
                            ax = ax.Parent
                        end

                        if not aw and ag(av, ak.Names) and af(av, ak.Contains) and not ah(av, ak.BlockNames) then
                            local ay = av:FindFirstChild("Humanoid")
                            if ap or (not ay or ay.Health > 0) then
                                local az = (al and al ~= "") and al or av.Name
                                ai[av] = {
                                    name = az,
                                    Cheap = ao,
                                    NonHuman = ap,
                                    NoStatus = aq,
                                    Config = ar
                                }
                            end
                        end
                    end
                end
            else
                if ag(an, ak.Names) and af(an, ak.Contains) and not ah(an, ak.BlockNames) then
                    local at = an:FindFirstChild("Humanoid")
                    if ap or (not at or at.Health > 0) then
                        local au = (al and al ~= "") and al or an.Name
                        ai[an] = {
                            name = au,
                            Cheap = ao,
                            NonHuman = ap,
                            NoStatus = aq,
                            Config = ar
                        }
                    end
                end
            end
        end
    end

    for aj, ak in pairs(ai) do
        if not R[aj] then
            R[aj] = {
                espObj = aa(ak.name),
                name = ak.name,
                Cheap = ak.Cheap,
                NonHuman = ak.NonHuman,
                NoStatus = ak.NoStatus,
                Config = ak.Config
            }
        else
            R[aj].name = ak.name
            R[aj].Cheap = ak.Cheap
            R[aj].NonHuman = ak.NonHuman
            R[aj].NoStatus = ak.NoStatus
            R[aj].Config = ak.Config
        end
    end

    for aj, ak in pairs(R) do
        if not ai[aj] or not aj.Parent then
            ak.espObj:Destroy()
            R[aj] = nil
        end
    end
end

local aj = 0
local ak = 0
local al = 0
local function am()
    if not C.Enabled then
        for an, ao in pairs(R) do
            if ao.espObj then
                local ap = D(ao.Config or {})
                ap.Chams = ap.Chams or {}
                ap.Chams.Enabled = false
                ad(ao.espObj, nil, nil, "", 0, an, ao.Cheap, ao.NonHuman, ao.NoStatus, ap,
                    false)
            end
        end
        return
    end

    local an = tick()

    if L and an - al > 5 then
        al = an
        Q()
    end

    if C.LimitFPS and C.LimitFPS > 0 then
        if an - ak < (1 / C.LimitFPS) then return end
        ak = an
    end

    if an - aj > 1 then
        aj = an
        ai()
    end

    for ao, ap in pairs(R) do
        if not ao or not ao.Parent then
            ap.espObj:Destroy()
            R[ao] = nil
            continue
        end

        local aq = not ap.NonHuman and ao:FindFirstChild("Humanoid") or nil
        if aq and aq.Health <= 0 then
            ap.espObj:Destroy()
            R[ao] = nil
            continue
        end

        local ar = ao:IsA("Model") and
            (ao.PrimaryPart or ao:FindFirstChild("HumanoidRootPart") or ao:FindFirstChildWhichIsA("BasePart")) or
            (ao:IsA("BasePart") and ao)

        if ar then
            local as, at, au = ae(ao)
            local av = (j.CFrame.Position - ar.Position).Magnitude
            ad(ap.espObj, at, au, ap.name, av, ao, ap.Cheap, ap.NonHuman,
                ap.NoStatus, ap.Config, as)
        else
            ad(ap.espObj, nil, nil, ap.name, 0, ao, ap.Cheap, ap.NonHuman, ap.NoStatus, ap
                .Config, false)
        end
    end
end

function n:Unload()
    for an, ao in pairs(R) do
        if ao.espObj then
            ao.espObj:Destroy()
        end
        R[an] = nil
    end

    if r then
        r:Disconnect()
        r = nil
    end
    if s then
        s:Disconnect()
        s = nil
    end
    if getgenv().SensoryESP_Loop then
        getgenv().SensoryESP_Loop:Disconnect()
        getgenv().SensoryESP_Loop = nil
    end
    if q then
        q:Destroy()
        q = nil
    end
    if o then
        o:Destroy()
        o = nil
    end
    if p then
        p:Destroy()
        p = nil
    end

    x(g)
    for an, ao in ipairs(m:GetPlayers()) do
        y(ao.Character)
    end

    getgenv().SensoryESP_UI = nil
end

function n:Load(an)
    self:Unload()

    C = E(D(F), an or {})
    z()
    t = h:GenerateGUID(false)
    aj = 0
    ak = 0

    r = e.PlayerRemoving:Connect(function(ao)
        for ap, aq in pairs(R) do
            if e:GetPlayerFromCharacter(ap) == ao then
                aq.espObj:Destroy()
                R[ap] = nil
            end
        end
    end)

    s = c.InputBegan:Connect(function(ao, ap)
        if not ap and C.Keybind.Enabled and ao.KeyCode == C.Keybind.Key then
            C.Enabled = not C.Enabled
        end
    end)

    getgenv().SensoryESP_Loop = d.RenderStepped:Connect(am)
    ai()
    return self
end

function n:GetConfig()
    return C
end

getgenv().SensoryESP_Unload = function()
    n:Unload()
end

return n
end function a.a()local aa=a.cache.a if not aa then aa={c=b()}a.cache.a=aa end return aa.c end end do local function aa()


local ab, ac

local function ad(ae, af)
	ab = ae
	ac = af
end

local function ae(af, ag)
	LPH_ATTRIBUTES(VM(NONE))
	local ah = ab or Toggles
	local ai = ah and ah[af]
	if ai then
		local aj = ai.Value
		if aj ~= nil then
			return aj
		end
	end
	return ag
end

local function af(ag, ah)
	LPH_ATTRIBUTES(VM(NONE))
	local ai = ac or Options
	local aj = ai and ai[ag]
	if aj then
		local ak = aj.Value
		if ak ~= nil then
			return ak
		end
	end
	return ah
end

local function ag(ah)
	local ai = ac or Options
	return ai and ai[ah]
end

return {
	bind = ad,
	tv = ae,
	ov = af,
	option = ag,
}
end function a.b()local ab=a.cache.b if not ab then ab={c=aa()}a.cache.b=ab end return ab.c end end do local function aa()
local function ab(ac)
	return clonefunction and clonefunction(ac) or ac
end

local function ac(ad)
	return ad
end


local ad = {}

local function ae(af, ag)
	if type(af) ~= "function" or not hookfunction then
		return nil
	end
	local ah = hookfunction(af, ag)
	ad[#ad + 1] = { target = af, original = ah }
	return ah
end

local function af()
	for ag = #ad, 1, -1 do
		local ah = ad[ag]
		pcall(function()
			if restorefunction then
				restorefunction(ah.target)
			else
				hookfunction(ah.target, ah.original)
			end
		end)
		ad[ag] = nil
	end
end

local function ag(ah, ai)
	local aj
	if filtergc then
		local ak = filtergc("function", { Name = ah, IgnoreExecutor = true }, false)
		if type(ak) == "table" then
			for al, am in ak do
				if type(am) == "function" then
					local an = debug.info(am, "s")
					if not ai or (an and string.find(an, ai, 1, true)) then
						return am
					end
				end
			end
		elseif type(ak) == "function" then
			return ak
		end
	end
	for ak, al in getgc(false) do
		if type(al) == "function" and islclosure(al) and not (isexecutorclosure and isexecutorclosure(al)) and debug.info(al, "n") == ah then
			local am = debug.info(al, "s")
			if not ai or (am and string.find(am, ai, 1, true)) then
				aj = al
				break
			end
		end
	end
	return aj
end


local function ah(ai)
	local aj = {}
	local ak = 0
	for al in ai do
		ak += 1
	end
	for al, am in getgc(false) do
		if ak == 0 then
			break
		end
		if type(am) == "function" and islclosure(am) then
			local an = debug.info(am, "n")
			local ao = an and ai[an]
			if ao and not aj[an] and not (isexecutorclosure and isexecutorclosure(am)) then
				local ap = debug.info(am, "s")
				if ap and string.find(ap, ao, 1, true) then
					aj[an] = am
					ak -= 1
				end
			end
		end
	end
	return aj
end

return {
	cloneOriginal = ab,
	wrap = ac,
	hook = ae,
	restoreAll = af,
	findGcFunction = ag,
	findGcFunctions = ah,
}
end function a.c()local ab=a.cache.c if not ab then ab={c=aa()}a.cache.c=ab end return ab.c end end do local function aa()
local function ab(ac)
	local ad = {}

	function ad.build(ae)
		local af = ae.Library
		local ag = af:CreateWindow({
			Title = ac.title,
			Center = true,
			AutoShow = true,
			TabPadding = 8,
			MenuFadeTime = 0.2,
		})
		ae.Window = ag
		ae.Tabs = {}
		for ah, ai in ac.tabs do
			ae.Tabs[ai] = ag:AddTab(ai)
		end
	end

	function ad.finish(ae)
		local af = getgenv().Toggles
		local ag = getgenv().Options
		local ah = ae.Tabs
		local ai = ae.Library
		local aj = ae.ThemeManager
		local ak = ae.SaveManager
		local al = ah.Settings or ah["UI Settings"]
		if not al then
			return
		end
		local am = ac.keybind or "menubind"
		local an = al:AddLeftGroupbox("Menu")
		an:AddButton({
			Text = "Unload",
			Func = function()
				ai:Unload()
			end,
		})
		an:AddLabel("Menu keybind"):AddKeyPicker(am, {
			Default = ac.keybindDefault or "RightShift",
			NoUI = true,
			Text = "Menu keybind",
		})
		ai.ToggleKeybind = ag[am]
		if not ac.hideKeybindList then
			an
				:AddToggle("ShowKeybindList", { Text = "Show Keybind List", Default = true })
				:OnChanged(function(ao)
					if ai and ai.KeybindFrame then
						ai.KeybindFrame.Visible = ao
					end
				end)
		end
		aj:SetLibrary(ai)
		ak:SetLibrary(ai)
		if ak.Parser and ak.Parser.Slider then
			local ao = ak.Parser.Slider.Load
			ak.Parser.Slider.Load = function(ap, aq)
				if ag[ap] then
					ag[ap]:SetValue(tonumber(aq.value) or aq.value)
				elseif ao then
					ao(ap, aq)
				end
			end
		end
		ak:IgnoreThemeSettings()
		ak:SetIgnoreIndexes(ac.ignore or { am })
		aj:SetFolder("VaultCC")
		ak:SetFolder(ac.folder)
		ak:BuildConfigSection(al)
		local ao = game:GetService("HttpService")
		local ap
		local function aq(ar)
			return ar == "VaultConfigCode" or ar:find("SaveManager_") or ar:find("ThemeManager_")
		end
		local function ar(as)
			if as and as.Changed then
				pcall(as.Changed, as.Value)
			end
		end
		local function as(at, au)
			if not at then
				return false
			end
			local av = false
			if at.SetValue then
				av = pcall(function()
					at:SetValue(au)
				end)
			end
			if not av then
				at.Value = au
			end
			ar(at)
			return true
		end
		local function at(au)
			local av = 0
			if type(au) ~= "table" then
				return 0
			end
			for aw, ax in au do
				if type(aw) ~= "string" or aq(aw) then
					continue
				end
				local ay = af[aw]
				if ay and type(ax) == "table" and ax.boolean ~= nil then
					if as(ay, ax.boolean == true) then
						av += 1
					end
					continue
				end
				local az = ag[aw]
				if not az then
					continue
				end
				if az.Type == "ColorPicker" and type(ax) == "table" and type(ax.color) == "string" then
					local aA, aB = pcall(Color3.fromHex, ax.color)
					if aA then
						if az.SetValueRGB then
							pcall(function()
								az:SetValueRGB(aB, ax.transparency)
							end)
						end
						az.Value = aB
						ar(az)
						av += 1
					end
				elseif az.Type == "KeyPicker" and type(ax) == "table" then
					if as(az, { ax.keycode or ax.key or az.Value, az.Mode }) then
						av += 1
					end
				elseif az.Type == "Slider" then
					if as(az, tonumber(ax) or ax) then
						av += 1
					end
				elseif as(az, ax) then
					av += 1
				end
			end
			return av
		end
		local function au(av)
			if type(av) ~= "table" or type(av.idx) ~= "string" or aq(av.idx) then
				return false
			end
			local aw = ak.Parser and ak.Parser[av.type]
			if aw and aw.Load then
				local ax = pcall(function()
					aw.Load(av.idx, av)
				end)
				if ax then
					return true
				end
			end
			if av.type == "Toggle" then
				return as(af[av.idx], av.value == true)
			end
			if av.type == "Slider" then
				return as(ag[av.idx], tonumber(av.value) or av.value)
			end
			if av.type == "Dropdown" then
				return as(ag[av.idx], av.value)
			end
			if av.type == "ColorPicker" then
				local ax = ag[av.idx]
				local ay, az = pcall(Color3.fromHex, av.value)
				if not ay or not ax then
					return false
				end
				if ax.SetValueRGB then
					pcall(function()
						ax:SetValueRGB(az, av.transparency)
					end)
				end
				ax.Value = az
				ar(ax)
				return true
			end
			if av.type == "KeyPicker" then
				return as(ag[av.idx], { av.key, av.mode })
			end
			if av.type == "Input" then
				return as(ag[av.idx], av.text)
			end
			return false
		end
		local function av()
			local aw = {}
			for ax, ay in af do
				if not aq(ax) then
					aw[#aw + 1] = { type = "Toggle", idx = ax, value = ay.Value == true }
				end
			end
			for ax, ay in ag do
				if aq(ax) then
					continue
				end
				if ay.Type == "Slider" then
					aw[#aw + 1] = { type = "Slider", idx = ax, value = tostring(ay.Value) }
				elseif ay.Type == "Dropdown" then
					aw[#aw + 1] = { type = "Dropdown", idx = ax, value = ay.Value, mutli = ay.Multi }
				elseif ay.Type == "ColorPicker" then
					local az = ay.Value
					aw[#aw + 1] = {
						type = "ColorPicker",
						idx = ax,
						value = typeof(az) == "Color3" and az:ToHex() or tostring(az),
						transparency = ay.Transparency,
					}
				elseif ay.Type == "KeyPicker" then
					aw[#aw + 1] = { type = "KeyPicker", idx = ax, mode = ay.Mode, key = ay.Value }
				elseif ay.Type == "Input" then
					aw[#aw + 1] = { type = "Input", idx = ax, text = tostring(ay.Value or "") }
				end
			end
			return ao:JSONEncode({ vault = 1, objects = aw })
		end
		local function aw(ax)
			if type(ax) ~= "string" then
				return false, "empty"
			end
			ax = ax:match("^%s*(.-)%s*$") or ""
			if ax == "" then
				return false, "empty"
			end
			local ay, az = pcall(function()
				return ao:JSONDecode(ax)
			end)
			if not ay or type(az) ~= "table" then
				return false, "invalid json"
			end
			local aA = 0
			if type(az.flagValues) == "table" then
				aA = at(az.flagValues)
			end
			local aB = az.objects or az
			if aA == 0 and type(aB) == "table" then
				for aC, aD in aB do
					if au(aD) then
						aA += 1
					end
				end
			end
			if aA == 0 then
				return false, "no settings in that code"
			end
			return true, aA
		end
		local ax = 0
		local function ay()
			local az = os.clock()
			if az - ax < 0.35 then
				return false
			end
			ax = az
			return true
		end
		local function az()
			if not ay() then
				return
			end
			local aA = av()
			if ap then
				ap.Text = aA
			end
			if ag.VaultConfigCode and ag.VaultConfigCode.SetValue then
				pcall(function()
					ag.VaultConfigCode:SetValue(aA)
				end)
			end
			local aB = false
			pcall(function()
				setclipboard(aA)
				aB = true
			end)
			ai:Notify(aB and "Config copied" or "Config ready, copy the box")
		end
		local function aA(aB)
			if not ay() then
				return
			end
			if type(aB) ~= "string" or aB:match("^%s*(.-)%s*$") == "" then
				local aC = ""
				pcall(function()
					aC = getclipboard()
				end)
				if aC == "" then
					pcall(function()
						aC = clipboard()
					end)
				end
				aB = aC
			end
			local aC, aD = aw(aB)
			if not aC then
				ai:Notify("Import failed: " .. tostring(aD))
				return
			end
			ai:Notify("Imported " .. tostring(aD) .. " settings")
		end
		local aB = al:AddLeftGroupbox("Import / Export")
		aB:AddInput("VaultConfigCode", {
			Text = "Config code",
			Placeholder = "Paste a config here",
			PlaceholderText = "Paste a config here",
		})
		aB:AddButton({
			Text = "Export",
			Func = az,
		})
		aB:AddButton({
			Text = "Import",
			Func = function()
				aA(ag.VaultConfigCode and ag.VaultConfigCode.Value or "")
			end,
		})
		pcall(function()
			ak:SetIgnoreIndexes({ "VaultConfigCode" })
		end)
		if ai.IsMobile then
			local aC = game:GetService("GuiService")
			local aD = game:GetService("UserInputService")
			local aE
			local aF = {}
			local function aG(aH)
				local aI = aH
				while aI and aI ~= game do
					if aI:IsA("GuiObject") and not aI.Visible then
						return false
					end
					aI = aI.Parent
				end
				return aH and aH.Parent ~= nil
			end
			local function aH(aI)
				local aJ, aK
				for aL, aM in aF do
					if aG(aL) then
						local aN, aO = aL.AbsolutePosition, aL.AbsoluteSize
						if aO.X > 0 and aO.Y > 0 and aI.X >= aN.X and aI.X <= aN.X + aO.X and aI.Y >= aN.Y and aI.Y <= aN.Y + aO.Y then
							local aP = aN + aO / 2
							local aQ = (Vector2.new(aP.X, aP.Y) - aI).Magnitude
							if not aK or aQ < aK then
								aJ, aK = aM, aQ
							end
						end
					end
				end
				return aJ
			end
			local function aI(aJ)
				if type(aJ) ~= "string" or aJ == "" or not isfolder("darius/VaultCC") then
					return nil
				end
				for aK, aL in listfiles("darius/VaultCC") do
					local aM, aN = pcall(function()
						return ao:JSONDecode(readfile(aL))
					end)
					if aM and type(aN) == "table" and aN.name == aJ then
						return aN
					end
				end
				return nil
			end
			local function aJ(aK)
				local aL = aI(aK)
				if not aL then
					ai:Notify("Config not found")
					return
				end
				local aM = getgenv and getgenv().dariusInstance
				if aM and aL.uid and aM.SetConfiguration then
					pcall(function()
						aM:SetConfiguration(aL.uid)
					end)
				end
				at(aL.flagValues)
				ai:Notify("Loaded " .. aK)
			end
			local function aK()
				local aL = game:GetService("CoreGui")
				for aM, aN in aL:GetDescendants() do
					if aN:IsA("TextLabel") then
						local aO = aN.Text:match("^Configs:%s*(.+)$")
						if aO and aO ~= "" then
							return aO
						end
					end
				end
				return nil
			end
			local function aL()
				if not ay() then
					return
				end
				local aM = aE or aK()
				if not aM or aM == "" then
					ai:Notify("Select a config first")
					return
				end
				aJ(aM)
			end
			if not ai._vaultCfgHook then
				ai._vaultCfgHook = true
				local aM
				aD.InputBegan:Connect(function(aN)
					local aO = aN.UserInputType
					if aO == Enum.UserInputType.Touch or aO == Enum.UserInputType.MouseButton1 then
						aM = aN.Position
					end
				end)
				aD.InputEnded:Connect(function(aN)
					local aO = aN.UserInputType
					if aO ~= Enum.UserInputType.Touch and aO ~= Enum.UserInputType.MouseButton1 then
						return
					end
					if not aM or (aN.Position - aM).Magnitude > 18 then
						return
					end
					local aP = Vector2.new(aN.Position.X, aN.Position.Y)
					local aQ = aC:GetGuiInset()
					local aR = aH(aP) or aH(aP - aQ) or aH(aP + aQ)
					if aR then
						aR()
					end
				end)
			end
			local function aM(aN, aO)
				if not aN or aF[aN] then
					return
				end
				aF[aN] = aO
			end
			local function aN()
				local aO = game:GetService("CoreGui")
				local aP = UDim2.new(1, 0, 0, 36)
				local function aQ(aR)
					if aR:IsA("TextButton") and aR.Text ~= "" then
						return aR.Text
					end
					local aS
					for aT, aU in aR:GetDescendants() do
						if aU:IsA("TextLabel") then
							local aV = aU.Text
							if aV == "Load" or aV == "Save" or aV == "Create" or aV == "Delete" or aV == "Export" or aV == "Import" then
								aS = aV
							end
						end
					end
					return aS
				end
				for aR, aS in aO:GetDescendants() do
					if aS:IsA("TextLabel") and aS.Text:sub(1, 7) == "Configs" then
						local aT = aS:FindFirstAncestorWhichIsA("TextButton")
						local aU = aT and aT.Parent
						local aV = aU and aU:FindFirstChildWhichIsA("ScrollingFrame")
						if aV and not aV:GetAttribute("vaultCfgWatch") then
							aV:SetAttribute("vaultCfgWatch", true)
							local function aW(aX)
								if not aX:IsA("TextButton") then
									return
								end
								aM(aX, function()
									aE = aX.Name
								end)
							end
							for aX, aY in aV:GetChildren() do
								aW(aY)
							end
							aV.ChildAdded:Connect(aW)
						end
					end
				end
				for aR, aS in aO:GetDescendants() do
					if aS:IsA("TextLabel") and aS.Text == "Load" then
						local aT = aS:FindFirstAncestorWhichIsA("TextButton")
						local aU = aT and aT.Parent
						if aU and aU:IsA("GuiObject") then
							local aV = aU:FindFirstChildOfClass("UIListLayout")
							if aV then
								aV.FillDirection = Enum.FillDirection.Vertical
								aV.HorizontalAlignment = Enum.HorizontalAlignment.Center
								aV.Padding = UDim.new(0, 4)
							end
							aU.AutomaticSize = Enum.AutomaticSize.Y
							aU.Size = UDim2.new(1, 0, 0, 0)
							if not aU:GetAttribute("vaultSizePin") then
								aU:SetAttribute("vaultSizePin", true)
								aU:GetPropertyChangedSignal("Size"):Connect(function()
									if aU.Parent and aU.Size ~= UDim2.new(1, 0, 0, 0) then
										aU.Size = UDim2.new(1, 0, 0, 0)
									end
								end)
								aU:GetPropertyChangedSignal("AutomaticSize"):Connect(function()
									if aU.Parent and aU.AutomaticSize ~= Enum.AutomaticSize.Y then
										aU.AutomaticSize = Enum.AutomaticSize.Y
									end
								end)
							end
							local aW
							for aX, aY in aU:GetChildren() do
								if aY:IsA("GuiButton") then
									aY.Size = aP
									if aQ(aY) == "Save" then
										aW = aY
									end
									if not aY:GetAttribute("vaultPinned") then
										aY:SetAttribute("vaultPinned", true)
										aY:GetPropertyChangedSignal("Size"):Connect(function()
											if aY.Parent and aY.Size ~= aP then
												aY.Size = aP
											end
										end)
									end
								end
							end
							aM(aT, aL)
							if aW and aT and not aT:GetAttribute("vaultLoadGuard") then
								aT:SetAttribute("vaultLoadGuard", true)
								aT.InputBegan:Connect(function(aX)
									local aY = aX.UserInputType
									if aY ~= Enum.UserInputType.Touch and aY ~= Enum.UserInputType.MouseButton1 then
										return
									end
									aW.Active = false
									task.delay(0.4, function()
										if aW.Parent then
											aW.Active = true
										end
									end)
								end)
							end
							if not aU:GetAttribute("vaultShare") then
								aU:SetAttribute("vaultShare", true)
								ap = Instance.new("TextBox")
								ap.Name = "VaultConfigCode"
								ap.Size = UDim2.new(1, 0, 0, 72)
								ap.BackgroundColor3 = aT.BackgroundColor3
								ap.TextColor3 = Color3.new(1, 1, 1)
								ap.PlaceholderText = "Paste config code"
								ap.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
								ap.Text = ""
								ap.ClearTextOnFocus = false
								ap.TextWrapped = true
								ap.MultiLine = true
								ap.TextXAlignment = Enum.TextXAlignment.Left
								ap.TextYAlignment = Enum.TextYAlignment.Top
								ap.Font = Enum.Font.Gotham
								ap.TextSize = 12
								ap.Parent = aU
								local aX = Instance.new("UICorner")
								aX.CornerRadius = UDim.new(0, 6)
								aX.Parent = ap
								local aY = Instance.new("UIPadding")
								aY.PaddingTop = UDim.new(0, 6)
								aY.PaddingLeft = UDim.new(0, 8)
								aY.PaddingRight = UDim.new(0, 8)
								aY.Parent = ap
								local function aZ(a_, a0)
									local a1 = Instance.new("TextButton")
									a1.Name = a_
									a1.Size = aP
									a1.BackgroundColor3 = aT.BackgroundColor3
									a1.Text = a_
									a1.TextColor3 = Color3.new(1, 1, 1)
									a1.Font = Enum.Font.GothamBold
									a1.TextSize = 14
									a1.AutoButtonColor = true
									a1.Parent = aU
									local a2 = Instance.new("UICorner")
									a2.CornerRadius = UDim.new(0, 6)
									a2.Parent = a1
									a1.Activated:Connect(a0)
									aM(a1, a0)
									return a1
								end
								aZ("Export", az)
								aZ("Import", function()
									aA(ap.Text)
								end)
							end
						end
						break
					end
				end
			end
			task.defer(aN)
			task.delay(0.6, aN)
			task.delay(1.5, aN)
		end
		aj:ApplyToTab(al)
		if ac.beforeLoad then
			ac.beforeLoad(ae, an)
		end
		ak:LoadAutoloadConfig()
		if ac.afterLoad then
			ac.afterLoad(ae)
		end
		if ai.KeybindFrame and not ac.hideKeybindList then
			ai.KeybindFrame.Visible = af.ShowKeybindList == nil or af.ShowKeybindList.Value ~= false
		end
	end

	function ad.step()
	end

	function ad.unload()
	end

	return ad
end

return {
	create = ab,
}
end function a.d()local ab=a.cache.d if not ab then ab={c=aa()}a.cache.d=ab end return ab.c end end do local function aa()
local ab = game:GetService("Players")
local ac = game:GetService("ReplicatedStorage")

local ad = {}

local ae = ab.LocalPlayer

local af = {
	"M1897",
	"DesertEagle",
	"TT33",
	"Revolver",
	"AK74",
	"ASVal",
	"SKS",
	"M99",
	"M70Tundra",
	"DoubleBarrel",
	"Bow",
}

local ag = {}
local ah = {}
for ai, aj in af do
	ah[string.lower(aj)] = aj
end

local function ai(aj)
	return (string.gsub(string.lower(aj), "[^%w]", ""))
end

function ad.characterOf(aj)
	LPH_ATTRIBUTES(VM(NONE))
	local ak = aj and aj.Character
	if ak and ak.Parent then
		return ak
	end
	return nil
end

function ad.humanoidOf(aj)
	LPH_ATTRIBUTES(VM(NONE))
	return aj and aj:FindFirstChildOfClass("Humanoid")
end

function ad.isAlive(aj)
	LPH_ATTRIBUTES(VM(NONE))
	if not aj or not aj.Parent then
		return false
	end
	if aj:GetAttribute("Ragdolled") then
		return false
	end
	local ak = aj:FindFirstChildOfClass("Humanoid")
	return ak ~= nil and ak.Health > 0
end

function ad.toolOf(aj)
	LPH_ATTRIBUTES(VM(NONE))
	return aj and aj:FindFirstChildOfClass("Tool")
end

function ad.weaponFolder(aj)
	LPH_ATTRIBUTES(VM(NONE))
	if not aj then
		return nil
	end
	local ak
	if aj:GetAttribute("IsRevolver") then
		ak = "Revolver"
	elseif aj:GetAttribute("IsTT33") then
		ak = "TT33"
	elseif aj:GetAttribute("IsBow") then
		ak = "Bow"
	elseif aj:GetAttribute("BreakAction") then
		ak = "DoubleBarrel"
	elseif type(aj:GetAttribute("RifleAssets")) == "string" then
		ak = aj:GetAttribute("RifleAssets")
	elseif aj:GetAttribute("IsDeagle") then
		ak = "DesertEagle"
	else
		ak = ah[ai(aj.Name)]
	end
	return ak
end

function ad.weaponConfig(aj)
	LPH_ATTRIBUTES(VM(NONE))
	local ak = ad.weaponFolder(aj)
	if not ak then
		return nil
	end
	local al = ag[ak]
	if al ~= nil then
		return al or nil
	end
	local am = ac:FindFirstChild(ak)
	local an = am and am:FindFirstChild("Config")
	if an then
		al = an:GetAttributes()
	else
		al = false
	end
	ag[ak] = al
	return al or nil
end

function ad.isGun(aj)
	LPH_ATTRIBUTES(VM(NONE))
	return aj ~= nil and aj:GetAttribute("GunReadyAt") ~= nil
end

function ad.fireCooldown(aj)
	LPH_ATTRIBUTES(VM(NONE))
	local ak = ad.weaponConfig(aj)
	if not ak then
		return 0
	end
	if aj:GetAttribute("Att_SlamFire") and ak.SlamFireCooldown then
		return ak.SlamFireCooldown
	end
	return ak.FireCooldown or 0
end


local aj = {}
ad.shots = aj

local function ak(al)
	LPH_ATTRIBUTES(VM(NONE))
	local am = al and al.Parent
	return am and ab:GetPlayerFromCharacter(am)
end

local al = { Pumped = true, RifleBolted = true, BreakAction = true }

local function am(an, ao, ap)
	LPH_ATTRIBUTES(VM(NONE))
	if typeof(ao) ~= "Instance" or not ao:IsA("Tool") then
		return
	end
	local aq = ak(ao)
	if not aq then
		return
	end
	local ar = workspace:GetServerTimeNow()
	local as = aj[aq]
	if not as then
		as = { intervals = 0, fast = 0, lastFired = 0, readyAt = 0, cycling = false }
		aj[aq] = as
	end
	if an == "Fired" then
		local at = ad.fireCooldown(ao)
		if as.lastFired > 0 and as.tool == ao and at > 0.2 then
			as.intervals += 1
			if ar - as.lastFired < at * 0.7 then
				as.fast += 1
			end
		end
		as.lastFired = ar
		as.tool = ao
		as.readyAt = ar + at
		local au = ad.weaponConfig(ao)
		as.cycling = au ~= nil and (au.PumpEnd ~= nil or au.BoltDelay ~= nil) or false
	elseif al[an] then
		if an ~= "RifleBolted" or ap == "Close" then
			as.cycling = false
		end
	end
end

function ad.cooldownLeft(an, ao)
	LPH_ATTRIBUTES(VM(NONE))
	local ap = ad.toolOf(ao)
	if not ap or not ad.isGun(ap) then
		return 0
	end
	local aq = workspace:GetServerTimeNow()
	local ar = 0
	local as = ap:GetAttribute("GunReadyAt")
	if type(as) == "number" and as > aq then
		ar = as - aq
	end
	local at = aj[an]
	if at and at.tool == ap then
		if at.readyAt > aq then
			ar = math.max(ar, at.readyAt - aq)
		end
		if at.cycling and aq - at.lastFired < 4 then
			ar = math.max(ar, 0.05)
		end
	end
	return ar
end


local an = {}
local ao = os.clock()
ad.loadedAt = ao

local function ap(aq)
	if not an[aq] then
		an[aq] = { at = os.clock(), before = os.clock() - ao < 2 }
	end
end

function ad.sessionTime(aq)
	LPH_ATTRIBUTES(VM(NONE))
	local ar = an[aq]
	if not ar then
		return 0, true
	end
	return os.clock() - ar.at, ar.before
end

function ad.formatTime(aq)
	aq = math.floor(aq)
	local ar = aq // 3600
	local as = (aq % 3600) // 60
	if ar > 0 then
		return string.format("%dh%02dm", ar, as)
	end
	return string.format("%dm", as)
end

function ad.formatCash(aq)
	local ar = tostring(math.floor(aq))
	local as = ar:reverse():gsub("(%d%d%d)", "%1,"):reverse()
	if as:sub(1, 1) == "," then
		as = as:sub(2)
	end
	return "$" .. as
end

function ad.stats(aq)
	LPH_ATTRIBUTES(VM(NONE))
	local ar = aq:FindFirstChild("leaderstats")
	local as = ar and ar:FindFirstChild("Kills")
	local at = ar and ar:FindFirstChild("Deaths")
	local au = as and as.Value or 0
	local av = at and at.Value or 0
	return au, av, au / math.max(av, 1)
end

local aq = {}


local ar = {}
local as = {}
local at = 0.15

function ad.track()
	LPH_ATTRIBUTES(VM(NONE))
	local au = os.clock()
	for av, aw in ab:GetPlayers() do
		if aw == ae then
			continue
		end
		local ax = aw.Character
		local ay = ax and ax:FindFirstChild("HumanoidRootPart")
		if not ay then
			ar[aw] = nil
			as[aw] = nil
			continue
		end
		local az = ar[aw]
		if not az or az.character ~= ax then
			az = { character = ax, t = {}, p = {} }
			ar[aw] = az
		end
		local aA = #az.t
		local aB = ay.Position
		if aA == 0 or az.p[aA] ~= aB then
			az.t[aA + 1] = au
			az.p[aA + 1] = aB
			aA += 1
		end
		while aA > 2 and au - az.t[1] > at * 2 do
			table.remove(az.t, 1)
			table.remove(az.p, 1)
			aA -= 1
		end
		if aA >= 2 then
			local aC = 1
			while aC < aA - 1 and au - az.t[aC + 1] > at do
				aC += 1
			end
			local aD = az.t[aA] - az.t[aC]
			local aE = aD > 0.02 and (az.p[aA] - az.p[aC]) / aD or Vector3.zero
			if au - az.t[aA] > 0.3 then
				aE = Vector3.zero
			end
			as[aw] = aE
		end
	end
end

function ad.velocity(au)
	return as[au] or Vector3.zero
end

function ad.start()
	local au = ac:FindFirstChild("M1897")
	au = au and au:FindFirstChild("ShotgunRemote")
	if au then
		aq[#aq + 1] = au.OnClientEvent:Connect(am)
	end
	for av, aw in ab:GetPlayers() do
		ap(aw)
	end
	aq[#aq + 1] = ab.PlayerAdded:Connect(ap)
	aq[#aq + 1] = ab.PlayerRemoving:Connect(function(av)
		an[av] = nil
		aj[av] = nil
		ar[av] = nil
		as[av] = nil
	end)
end

function ad.stop()
	for au, av in aq do
		av:Disconnect()
	end
	table.clear(aq)
end

ad.LocalPlayer = ae

return ad
end function a.e()local ab=a.cache.e if not ab then ab={c=aa()}a.cache.e=ab end return ab.c end end do local function aa()
local ab = a.e()

local ac = {}

local ad = {
	Head = { "Head" },
	Torso = { "Torso" },
	Arms = { "Left Arm", "Right Arm" },
	Legs = { "Left Leg", "Right Leg" },
}



local ae = { 0.25, 0.5, 0.75, 1 }
local function af(ag, ah)
	local ai = {}
	for aj = 0, ag - 1 do
		local ak = aj * (2 * math.pi / ag)
		local al = Vector3.new(math.cos(ak), 0, math.sin(ak))
		for am, an in ae do
			ai[#ai + 1] = al * an
		end
		if ah then
			ai[#ai + 1] = al * 0.7 + Vector3.new(0, 0.5, 0)
		end
	end
	if ah then
		ai[#ai + 1] = Vector3.new(0, 0.5, 0)
		ai[#ai + 1] = Vector3.new(0, 1, 0)
	end
	table.sort(ai, function(aj, ak)
		return aj.Magnitude < ak.Magnitude
	end)
	return ai
end
local ag = {
	Low = af(4, false),
	Medium = af(8, false),
	High = af(8, true),
}

function ac.build(ah)
	local ai = ah.tv
	local aj = ah.ov
	local ak = ah.Players
	local al = ah.LocalPlayer

	local am = workspace.Raycast
	local an = workspace.CurrentCamera.WorldToViewportPoint
	local ao = Vector2.new

	
	local ap = RaycastParams.new()
	ap.FilterType = Enum.RaycastFilterType.Exclude
	ap.IgnoreWater = true
	pcall(function()
		ap.CollisionGroup = "WeaponRaycast"
	end)
	
	local aq = RaycastParams.new()
	aq.FilterType = Enum.RaycastFilterType.Exclude
	aq.IgnoreWater = true
	aq.RespectCanCollide = true
	local ar = {}
	local as = {}

	local function at(au)
		LPH_ATTRIBUTES(VM(NONE))
		table.clear(ar)
		ar[1] = au or workspace.CurrentCamera
		local av = workspace:FindFirstChild("ShotgunFX")
		if av then
			ar[#ar + 1] = av
		end
		local aw = al.Character
		if aw then
			ar[#ar + 1] = aw
		end
		ap.FilterDescendantsInstances = ar
		table.clear(as)
		for ax = 1, #ar do
			as[ax] = ar[ax]
		end
		for ax, ay in ak:GetPlayers() do
			if ay.Character then
				as[#as + 1] = ay.Character
			end
		end
		aq.FilterDescendantsInstances = as
	end

	local function au(av, aw)
		LPH_ATTRIBUTES(VM(NONE))
		return am(workspace, av, aw, ap)
	end

	local function av(aw, ax, ay)
		LPH_ATTRIBUTES(VM(NONE))
		local az = ax - aw
		local aA = az.Magnitude
		if aA < 1e-3 or aA ~= aA then
			return false
		end
		local aB = am(workspace, aw, az + az / aA * 0.5, ap)
		return aB ~= nil and aB.Instance:IsDescendantOf(ay)
	end

	local function aw(ax, ay)
		LPH_ATTRIBUTES(VM(NONE))
		local az = ay - ax
		local aA = az.Magnitude
		if aA < 0.01 then
			return true
		end
		if aA ~= aA then
			return false
		end
		
		return am(workspace, ax, az + az / aA * 0.35, aq) == nil
	end

	
	
	local function ax(ay, az, aA)
		LPH_ATTRIBUTES(VM(NONE))
		local aB = tonumber(aj("manipdistance", 4)) or 4
		local aC = tonumber(aj("manipmaxup", 3)) or 3
		local aD = ag[aj("manipdepth", "High")] or ag.High
		for aE = 1, #aD do
			local aF = aD[aE] * aB
			if aF.Y > aC then
				aF = Vector3.new(aF.X, aC, aF.Z)
			end
			local aG = ay + aF
			if aw(ay, aG) and av(aG, az, aA) then
				return aG
			end
		end
		return nil
	end

	local function ay()
		local az = {}
		local aA = aj("silentparts", { Head = true })
		if type(aA) == "table" then
			for aB, aC in aA do
				local aD = aC and ad[aB]
				if aD then
					for aE, aF in aD do
						az[#az + 1] = aF
					end
				end
			end
		end
		if #az == 0 then
			az[1] = "Head"
		end
		return az
	end

	local function az()
		local aA = ab.toolOf(al.Character)
		local aB = ab.weaponConfig(aA)
		local aC = tonumber(aj("silentmaxdist", 0)) or 0
		local aD = aB and (aB.SlugRange and aA:GetAttribute("Att_Slugs") and aB.SlugRange or aB.Range) or 300
		if aC <= 0 then
			return aD
		end
		return math.min(aC, aD)
	end

	local function aA()
		return aj("originmode", "Off")
	end

	
	local function aB(aC, aD, aE, aF, aG)
		LPH_ATTRIBUTES(VM(NONE))
		if aF == "Next to target" then
			local aH = aC - aD
			local aI = tonumber(aj("originoffset", 3)) or 3
			if aH.Magnitude <= aI then
				return aC
			end
			return aD + aH.Unit * aI
		end
		if av(aC, aD, aE) then
			return aC
		end
		if aF == "Manipulation" then
			return ax(aC, aD, aE)
		end
		if not aG then
			return aC
		end
		return nil
	end

	local aC, aD, aE = nil, 0, nil

	
	local function aF(aG)
		LPH_ATTRIBUTES(VM(NONE))
		if not aG then
			return nil
		end
		local aH = os.clock()
		local aI = aG.CFrame.Position
		if aH - aD < 1 / 60 and aE == aI then
			return aC
		end
		local aJ = aG.ViewportSize * 0.5
		local aK = ai("silentfov", true)
		local aL = tonumber(aj("silentfovsize", 150)) or 150
		local aM = ai("silentvischeck", true)
		local aN = aj("silentpriority", "Crosshair")
		local aO = aA()
		local aP = ai("prediction", false) and (tonumber(aj("predictms", 100)) or 100) / 1000 or 0
		local aQ = az()
		local aR = aQ * aQ
		local aS = ay()
		at(aG)

		local aT = {}
		for aU, aV in ak:GetPlayers() do
			if aV == al then
				continue
			end
			local aW = ab.characterOf(aV)
			if not ab.isAlive(aW) then
				continue
			end
			local aX = aW:FindFirstChild("HumanoidRootPart")
			if not aX then
				continue
			end
			local aY = aX.Position - aI
			local aZ = aY.X * aY.X + aY.Y * aY.Y + aY.Z * aY.Z
			if aZ > aR then
				continue
			end
			local a_ = aP > 0 and ab.velocity(aV) * aP or Vector3.zero
			for a0, a1 in aS do
				local a2 = aW:FindFirstChild(a1)
				if not a2 then
					continue
				end
				local a3 = a2.Position + a_
				local a4, a5 = an(aG, a2.Position)
				if not a5 or a4.Z <= 0 then
					continue
				end
				local a6 = (ao(a4.X, a4.Y) - aJ).Magnitude
				if aK and a6 > aL then
					continue
				end
				local a7
				if aN == "Distance" then
					a7 = aZ
				elseif aN == "Health" then
					local a8 = ab.humanoidOf(aW)
					a7 = (a8 and a8.Health or 100) * 10000 + a6
				else
					a7 = a6
				end
				aT[#aT + 1] = { player = aV, part = a2, point = a3, character = aW, score = a7 }
			end
		end
		table.sort(aT, function(aU, aV)
			return aU.score < aV.score
		end)
		local aU
		local aV = aO == "Manipulation" and 3 or 6
		for aW = 1, math.min(#aT, aV) do
			local aX = aT[aW]
			local aY = aB(aI, aX.point, aX.character, aO, aM)
			if aY then
				aX.origin = aY
				aU = aX
				break
			end
		end
		aC, aD, aE = aU, aH, aI
		return aU
	end

	ah.aim = {
		resolve = aF,
		visible = av,
		cast = au,
		setIgnore = at,
		originMode = aA,
		solve = ax,
	}
end

return ac
end function a.f()local ab=a.cache.f if not ab then ab={c=aa()}a.cache.f=ab end return ab.c end end do local function aa()
local ab = a.e()

local ac = {}

local ad = {
	CameraClimb = true,
	CameraKick = true,
	CameraYaw = true,
	RecoilRise = true,
	RecoilBack = true,
	RecoilFlip = true,
}

local function ae(af)
	return string.sub(af, -6) == "Spread" or af == "BloomPerShot" or af == "MaxBloom"
end

function ac.build(af)
	local ag = af.tv
	local ah = af.ov
	local ai = af.Tabs
	local aj = af.LocalPlayer
	local ak = af.ReplicatedStorage
	local al = af.aim

	local am = ai.Combat:AddLeftGroupbox("Targeting")
	am:AddDropdown("silentparts", {
		Text = "Target parts",
		Values = { "Head", "Torso", "Arms", "Legs" },
		Default = { "Head" },
		Multi = true,
	})
	am:AddDropdown("silentpriority", {
		Text = "Priority",
		Values = { "Crosshair", "Distance", "Health" },
		Default = 1,
		Multi = false,
	})
	am:AddToggle("silentvischeck", { Text = "Visible check", Default = true })
	am:AddSlider("silentmaxdist", { Text = "Max distance", Default = 0, Min = 0, Max = 600, Rounding = 0, Suffix = " studs" })
	am:AddLabel("0 = weapon range", true)
	am:AddToggle("silentfov", { Text = "FOV check", Default = true })
	am:AddSlider("silentfovsize", { Text = "FOV size", Default = 150, Min = 10, Max = 1000, Rounding = 0, Suffix = " px" })
	am:AddToggle("prediction", { Text = "Prediction", Default = false })
	am:AddSlider("predictms", { Text = "Prediction time", Default = 100, Min = 0, Max = 400, Rounding = 0, Suffix = " ms" })

	local an = ai.Combat:AddLeftGroupbox("Gun Mods")
	an:AddToggle("recoilcontrol", { Text = "Recoil control", Default = false })
	an:AddSlider("recoilamount", { Text = "Recoil", Default = 0, Min = 0, Max = 100, Rounding = 0, Suffix = "%" })
	an:AddToggle("spreadcontrol", { Text = "Spread control", Default = false })
	an:AddSlider("spreadamount", { Text = "Spread", Default = 0, Min = 0, Max = 100, Rounding = 0, Suffix = "%" })

	local ao = ai.Combat:AddRightGroupbox("Silent Aim")
	ao:AddToggle("silentenabled", { Text = "Silent Aim", Default = false }):AddKeyPicker("silentenabledbind", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Silent Aim",
	})
	ao:AddToggle("silentfovdraw", { Text = "Draw FOV circle", Default = true })
	ao:AddLabel("FOV color"):AddColorPicker("silentfovcolor", { Default = Color3.fromRGB(255, 255, 255), Title = "FOV color" })
	ao:AddSlider("silentfovthickness", { Text = "FOV thickness", Default = 1, Min = 1, Max = 6, Rounding = 0 })
	ao:AddToggle("snaplines", { Text = "Target line", Default = false })
	ao:AddLabel("Line color"):AddColorPicker("snapcolor", { Default = Color3.fromRGB(255, 60, 60), Title = "Target line" })

	local ap = ai.Combat:AddRightGroupbox("Origin")
	ap:AddDropdown("originmode", {
		Text = "Origin mode",
		Values = { "Off", "Next to target", "Manipulation" },
		Default = 1,
		Multi = false,
	})
	ap:AddSlider("originoffset", { Text = "Target gap", Default = 3, Min = 0.5, Max = 15, Rounding = 1, Suffix = " studs" })
	ap:AddSlider("manipdistance", { Text = "Max shift", Default = 4, Min = 0.5, Max = 25, Rounding = 1, Suffix = " studs" })
	ap:AddDropdown("manipdepth", { Text = "Search depth", Values = { "Low", "Medium", "High" }, Default = 3, Multi = false })
	ap:AddSlider("manipmaxup", { Text = "Max height", Default = 3, Min = 0, Max = 15, Rounding = 1, Suffix = " studs" })
	ap:AddToggle("origindraw", { Text = "Show shot origin", Default = false })
	ap:AddLabel("Uses Silent Aim's target.", true)

	local aq, ar, as
	if Drawing then
		local at, au = pcall(Drawing.new, "Circle")
		local av, aw = pcall(Drawing.new, "Line")
		local ax, ay = pcall(Drawing.new, "Circle")
		aq = at and au or nil
		ar = av and aw or nil
		as = ax and ay or nil
	end
	if aq then
		aq.Filled = false
		aq.NumSides = 64
		aq.Visible = false
	end
	if ar then
		ar.Visible = false
		ar.Thickness = 1
	end
	if as then
		as.Filled = true
		as.Radius = 4
		as.NumSides = 12
		as.Color = Color3.fromRGB(80, 200, 255)
		as.Visible = false
	end

	local function at(au, av)
		local aw = ah(au, av)
		return typeof(aw) == "Color3" and aw or av
	end

	local function au()
		LPH_ATTRIBUTES(VM(NONE))
		local av = ab.toolOf(aj.Character)
		return av ~= nil and ab.isGun(av) and not av:GetAttribute("IsBow"), av
	end

	local function av()
		LPH_ATTRIBUTES(VM(NONE))
		return ag("silentenabled", false) and ab.isAlive(aj.Character)
	end

	
	
	local aw = {}
	local ax
	
	local ay = {
		RecoilMul = {
			toggle = "recoilcontrol",
			default = 1.45,
			scale = function()
				return (tonumber(ah("recoilamount", 0)) or 0) / 100
			end,
		},
		Intensity = {
			toggle = "aimsway",
			default = 1,
			scale = function()
				return (tonumber(ah("aimswaymult", 100)) or 100) / 100
			end,
		},
	}
	local az = {}
	for aA in ay do
		az[aA] = { original = nil, last = nil }
	end

	local function aA(aB)
		if ad[aB] then
			return ag("recoilcontrol", false) and (tonumber(ah("recoilamount", 0)) or 0) / 100 or 1
		end
		if ae(aB) then
			return ag("spreadcontrol", false) and (tonumber(ah("spreadamount", 0)) or 0) / 100 or 1
		end
		if aB == "AimTime" or aB == "AimOutTime" then
			local aC = ag("aimspeed", false) and (tonumber(ah("aimspeedmult", 100)) or 100) / 100 or 1
			return 1 / math.max(aC, 0.05)
		end
		if aB == "IdleSway" or aB == "WalkSway" then
			return ag("aimsway", false) and (tonumber(ah("aimswaymult", 100)) or 100) / 100 or 1
		end
		return nil
	end

	local function aB()
		LPH_ATTRIBUTES(VM(NONE))
		for aC, aD in ak:GetChildren() do
			local aE = aD:IsA("Folder") and aD:FindFirstChild("Config")
			if not aE or not aE:IsA("Configuration") then
				continue
			end
			local aF = aw[aE]
			if not aF then
				aF = { original = {}, last = {} }
				aw[aE] = aF
			end
			for aG, aH in aE:GetAttributes() do
				if type(aH) ~= "number" then
					continue
				end
				local aI = aA(aG)
				if not aI then
					continue
				end
				
				if aF.last[aG] == nil or aH ~= aF.last[aG] then
					aF.original[aG] = aH
				end
				local aJ = aF.original[aG] * aI
				if aH ~= aJ then
					aE:SetAttribute(aG, aJ)
				end
				aF.last[aG] = aJ
			end
		end
		if not ax then
			local aC = ak:FindFirstChild("WeaponHandling")
			ax = aC and aC:FindFirstChild("WeaponMotion")
		end
		if ax then
			for aC, aD in ay do
				local aE = az[aC]
				local aF = ax:GetAttribute(aC)
				if aF ~= aE.last then
					aE.original = aF
				end
				local aG = ag(aD.toggle, false)
				if aG then
					local aH = (aE.original or aD.default) * aD.scale()
					if aF ~= aH then
						ax:SetAttribute(aC, aH)
					end
					aE.last = aH
				elseif aE.last ~= nil and aE.last ~= aE.original then
					ax:SetAttribute(aC, aE.original)
					aE.last = aE.original
				end
			end
		end
	end

	local function aC()
		for aD, aE in aw do
			if aD.Parent then
				for aF, aG in aE.original do
					pcall(aD.SetAttribute, aD, aF, aG)
				end
			end
		end
		table.clear(aw)
		if ax then
			for aD, aE in az do
				if aE.last ~= nil and aE.last ~= aE.original then
					pcall(ax.SetAttribute, ax, aD, aE.original)
				end
				aE.last = nil
			end
		end
	end

	for aD, aE in { "recoilcontrol", "spreadcontrol" } do
		local aF = getgenv().Toggles[aE]
		if aF then
			aF:OnChanged(aB)
		end
	end
	for aD, aE in { "recoilamount", "spreadamount" } do
		local aF = getgenv().Options[aE]
		if aF then
			aF:OnChanged(aB)
		end
	end

	
	
	local aD
	local aE
	local aF
	local aG
	local aH

	local function aI(aJ, aK, ...)
		LPH_ATTRIBUTES(VM(NONE))
		local aL = aE(aJ, aK, ...)
		if not av() or typeof(aK) ~= "CFrame" then
			return aL
		end
		local aM = debug.info(2, "n")
		if aM ~= "fire" then
			return aL
		end
		if not au() then
			return aL
		end
		local aN = al.resolve(workspace.CurrentCamera)
		if not aN then
			return aL
		end
		aF = aN
		local aO = aK.Position
		local aP = aN.origin
		aH = { origin = aO, point = aN.point, camPos = aO, at = os.clock(), target = aN }
		if aP and (aP - aO).Magnitude > 0.05 then
			aG = { origin = aP, point = aN.point, camPos = aO, at = os.clock(), target = aN }
		else
			aG = nil
		end
		local aQ = aN.point - aO
		if aQ.Magnitude < 0.01 then
			return aL
		end
		return aQ.Unit
	end

	local function aJ()
		if aE then
			return true
		end
		local aK = ak:FindFirstChild("WeaponHandling")
		local aL = aK and aK:FindFirstChild("WeaponMotion")
		if not aL then
			return false
		end
		local aM, aN = pcall(require, aL)
		if not aM or type(aN) ~= "table" or type(aN.aimDirection) ~= "function" then
			return false
		end
		aD = aN
		aE = aN.aimDirection
		aN.aimDirection = aI
		return true
	end

	local function aK()
		if aD and aE and aD.aimDirection == aI then
			aD.aimDirection = aE
		end
		aD = nil
		aE = nil
	end

	
	
	
	local aL = Vector3.zero
	local aM = {}
	getgenv().VaultSS_ShotLog = aM

	local function aN(aO)
		local aP = aO:FindFirstAncestorOfClass("Model")
		while aP do
			if aP:FindFirstChildOfClass("Humanoid") then
				return true
			end
			aP = aP:FindFirstAncestorOfClass("Model")
		end
		return false
	end

	local function aO()
		local aP = ab.toolOf(aj.Character)
		local aQ = ab.weaponConfig(aP)
		if not aQ then
			return 300
		end
		if aP:GetAttribute("Att_Slugs") and aQ.SlugRange then
			return aQ.SlugRange
		end
		return aQ.Range or 300
	end

	local function aP(aQ, aR, aS)
		local aT = al.cast(aQ, aR * aS)
		if aT and aN(aT.Instance) then
			return aT.Instance
		end
		return false
	end

	local function aQ(aR, aS, aT, aU)
		local aV = aR.target
		local aW = aV and ab.humanoidOf(aV.character)
		local aX = aj.Character
		local aY = {
			t = os.clock(),
			verb = aS,
			mode = ag("silentenabled", false) and al.originMode() or "NoSilent",
			shift = math.floor((aT - aR.camPos).Magnitude * 10) / 10,
			targetDist = math.floor((aR.point - aT).Magnitude * 10) / 10,
			target = aV and aV.player.Name,
			part = aV and aV.part.Name,
			hits = aU,
			hpBefore = aW and aW.Health,
			dmg = 0,
			aiming = aX ~= nil and aX:GetAttribute("PAim") == true,
			spread = ag("spreadcontrol", false) and (tonumber(ah("spreadamount", 0)) or 0) or 100,
			recoil = ag("recoilcontrol", false) and (tonumber(ah("recoilamount", 0)) or 0) or 100,
			sway = ag("aimsway", false) and (tonumber(ah("aimswaymult", 100)) or 100) or 100,
			pred = ag("prediction", false) and (tonumber(ah("predictms", 100)) or 100) or 0,
			targetSpeed = aV and math.floor(ab.velocity(aV.player).Magnitude * 10) / 10 or 0,
			weapon = (ab.toolOf(aX) or {}).Name,
		}
		table.insert(aM, aY)
		if #aM > 60 then
			table.remove(aM, 1)
		end
		
		if aW then
			local aZ = aW.Health
			local a_
			a_ = aW.HealthChanged:Connect(function(a0)
				if a0 < aZ then
					aY.dmg += aZ - a0
				end
				aZ = a0
			end)
			task.delay(0.6, function()
				a_:Disconnect()
				aY.hpAfter = aW.Parent and aW.Health
			end)
		end
	end

	local function aR(aS, aT, aU, aV, aW, aX, ...)
		LPH_ATTRIBUTES(VM(NONE))
		local aY = aS.origin
		local aZ = aS.point - aY
		if aZ.Magnitude < 0.01 then
			return nil
		end
		local a_ = aZ.Unit
		local a0 = CFrame.lookAt(aL, aV)
		local a1 = CFrame.lookAt(aL, a_)
		local a2 = aO()
		al.setIgnore(workspace.CurrentCamera)
		local a3 = {}
		if typeof(aW) == "Vector3" then
			local a4 = a1:VectorToWorldSpace(a0:VectorToObjectSpace(aW))
			local a5 = aP(aY, a4, a2)
			a3[1] = a5 and a5.Name or "-"
			aQ(aS, aT, aY, a3)
			return aT, aY, a_, a4, a5, ...
		end
		if type(aW) == "table" then
			local a4, a5 = {}, {}
			for a6, a7 in aW do
				if typeof(a7) == "Vector3" then
					local a8 = a1:VectorToWorldSpace(a0:VectorToObjectSpace(a7))
					a4[a6] = a8
					local a9 = aP(aY, a8, a2)
					a5[a6] = a9
					a3[#a3 + 1] = a9 and a9.Name or "-"
				else
					a4[a6] = a7
					a5[a6] = type(aX) == "table" and aX[a6] or false
				end
			end
			aQ(aS, aT, aY, a3)
			return aT, aY, a_, a4, a5, ...
		end
		return nil
	end

	local aS = false
	local aT = true
	local aU
	local aV
	local aW

	local function aX()
		if aS then
			return
		end
		local aY = ak:FindFirstChild("M1897")
		aU = aY and aY:FindFirstChild("ShotgunRemote")
		if not aU or not hookmetamethod then
			return
		end
		aS = true
		
		
		local aZ = aU.FireServer
		local function a_(a0, ...)
			if setnamecallmethod then
				setnamecallmethod("FireServer")
				return aV(a0, ...)
			end
			return aZ(a0, ...)
		end
		aV = hookmetamethod(game, "__namecall", newcclosure(function(a0, ...)
			if not (aT and a0 == aU and getnamecallmethod() == "FireServer" and not checkcaller()) then
				return aV(a0, ...)
			end
			local a1, a2, a3 = ...
			if not (type(a1) == "string" and string.sub(a1, -4) == "Fire" and typeof(a2) == "Vector3" and typeof(a3) == "Vector3") then
				return aV(a0, ...)
			end
			local a4 = aG
			aG = nil
			if a4 and os.clock() - a4.at < 0.25 and (a2 - a4.camPos).Magnitude < 1 then
				local a5 = table.pack(pcall(aR, a4, ...))
				if a5[1] and a5[2] ~= nil then
					return a_(a0, table.unpack(a5, 2, a5.n))
				end
			end
			local a5 = aH
			aH = nil
			local a6 = table.pack(...)
			a_(a0, ...)
			
			task.defer(function()
				local a7, a8, a9, b, ba = table.unpack(a6, 1, a6.n)
				if not (a5 and os.clock() - a5.at < 0.3) then
					
					local bb = typeof(ba) == "Instance" and ba
					if not bb and type(ba) == "table" then
						for bc, bd in ba do
							if typeof(bd) == "Instance" then
								bb = bd
								break
							end
						end
					end
					local bc = bb and bb:FindFirstAncestorOfClass("Model")
					local bd = bc and game:GetService("Players"):GetPlayerFromCharacter(bc)
					a5 = {
						origin = a2,
						camPos = a2,
						point = bb and bb.Position or a2 + a3 * 50,
						at = os.clock(),
						target = bd and { player = bd, part = bb, character = bc } or nil,
					}
				end
				local bb = {}
				if typeof(ba) == "Instance" then
					bb[1] = ba.Name
				elseif type(ba) == "table" then
					for bc, bd in ba do
						bb[#bb + 1] = typeof(bd) == "Instance" and bd.Name or "-"
					end
				else
					bb[1] = "-"
				end
				pcall(aQ, a5, a1, a2, bb)
			end)
			return nil
		end))
		aW = aU.OnClientEvent:Connect(function(a0, a1, a2)
			if a0 ~= "Fired" or typeof(a1) ~= "Instance" or a1.Parent ~= aj.Character then
				return
			end
			local a3
			for a4 = #aM, 1, -1 do
				local a5 = aM[a4]
				if a5.server == nil and os.clock() - a5.t < 1.5 then
					a3 = a5
				else
					break
				end
			end
			if not a3 then
				return
			end
			local a4 = {}
			if type(a2) == "table" then
				for a5, a6 in a2 do
					local b = a6[4]
					if a6[3] == true then
						local ba = typeof(b) == "Instance" and b.Parent and b.Parent.Name or "?"
						a4[#a4 + 1] = (typeof(b) == "Instance" and b.Name or "?") .. "@" .. ba
					end
				end
			end
			a3.server = #a4 > 0 and table.concat(a4, ",") or "miss"
		end)
	end

	local aY = 0
	local aZ = 0
	function ac.step()
		LPH_ATTRIBUTES(VM(NONE))
		local a_ = os.clock()
		if not aE and a_ - aY > 2 then
			aY = a_
			aJ()
		end
		if a_ - aZ > 1 then
			aZ = a_
			aB()
		end
	end

	function ac.renderStep()
		LPH_ATTRIBUTES(VM(NONE))
		local a_ = workspace.CurrentCamera
		if not a_ then
			return
		end
		local a0 = a_.ViewportSize * 0.5
		local a1 = av()
		if aq then
			local a2 = a1 and ag("silentfov", true) and ag("silentfovdraw", true)
			aq.Visible = a2
			if a2 then
				aq.Position = a0
				aq.Radius = tonumber(ah("silentfovsize", 150)) or 150
				aq.Color = at("silentfovcolor", Color3.new(1, 1, 1))
				aq.Thickness = tonumber(ah("silentfovthickness", 1)) or 1
			end
		end
		local a2 = ar and a1 and ag("snaplines", false)
		local a3 = as and a1 and ag("origindraw", false) and al.originMode() ~= "Off"
		local a4 = (a2 or a3) and au() and al.resolve(a_)
		if ar then
			if a2 and a4 then
				local a5 = a_:WorldToViewportPoint(a4.point)
				ar.From = a0
				ar.To = Vector2.new(a5.X, a5.Y)
				ar.Color = at("snapcolor", Color3.fromRGB(255, 60, 60))
				ar.Visible = true
			else
				ar.Visible = false
			end
		end
		if as then
			if a3 and a4 and a4.origin then
				local a5, a6 = a_:WorldToViewportPoint(a4.origin)
				as.Position = Vector2.new(a5.X, a5.Y)
				as.Visible = a6
			else
				as.Visible = false
			end
		end
	end

	function ac.lastTarget()
		return aF
	end

	function ac.unload()
		aT = false
		if aW then
			aW:Disconnect()
			aW = nil
		end
		aK()
		aC()
		for a_, a0 in { aq, ar, as } do
			pcall(function()
				a0:Remove()
			end)
		end
	end

	ac.applyMods = aB
	aJ()
	aX()
	af.combat = ac
end

return ac
end function a.g()local ab=a.cache.g if not ab then ab={c=aa()}a.cache.g=ab end return ab.c end end do local function aa()
local ab = a.e()

local ac = {}

local ad = {
	"Reloading",
	"Cooldown",
	"Sprinting",
	"Aiming",
	"Crouching",
	"Ammo",
	"Cash",
	"Session Time",
	"KDR",
	"K/D",
	"Primary",
	"Grenades",
	"Case Keys",
	"Cheater",
}

local ae = { "TurnBlur", "HitColor", "TowerVertigoBlur", "TowerVertigoColor", "HallucinationGrade", "DeathBlur" }

function ac.build(af)
	local ag = af.tv
	local ah = af.ov
	local ai = af.LocalPlayer
	local aj = af.Lighting
	local ak = af.Tabs
	local al = af.ESP
	local am

	if al and al.Load then
		pcall(function()
			al:Load({
				Enabled = false,
				Players = false,
				LocalPlayer = false,
			})
			am = al:GetConfig()
		end)
	end

	local an = ak.ESP:AddLeftGroupbox("Main")
	an:AddToggle("ESPMaster", { Text = "Enabled", Default = false })
	an:AddSlider("ESPMaxDistance", { Text = "Max distance", Default = 0, Min = 0, Max = 1500, Rounding = 0, Suffix = " studs" })

	local ao = ak.ESP:AddLeftGroupbox("Boxes")
	ao:AddToggle("ESPBoxes", { Text = "Boxes", Default = true })
	ao:AddDropdown("ESPBoxType", { Text = "Box type", Values = { "Normal", "Corner" }, Default = 1, Multi = false })
	ao:AddLabel("Box color"):AddColorPicker("ESPBoxColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Box color" })
	ao:AddSlider("ESPBoxThickness", { Text = "Box thickness", Default = 1, Min = 1, Max = 6, Rounding = 0 })
	ao:AddToggle("ESPBoxOutline", { Text = "Box outline", Default = true })
	ao:AddLabel("Outline color"):AddColorPicker("ESPBoxOutlineColor", { Default = Color3.fromRGB(0, 0, 0), Title = "Outline color" })
	ao:AddToggle("ESPBoxFill", { Text = "Box fill", Default = false })
	ao:AddLabel("Fill color"):AddColorPicker("ESPBoxFillColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Fill color" })
	ao:AddSlider("ESPBoxFillTransparency", { Text = "Fill transparency", Default = 0.9, Min = 0, Max = 1, Rounding = 2 })

	local ap = ak.ESP:AddLeftGroupbox("Chams")
	ap:AddToggle("ESPChams", { Text = "Chams", Default = false })
	ap:AddDropdown("ESPChamsType", { Text = "Chams type", Values = { "Highlight", "Adornment", "MeshChams" }, Default = 1, Multi = false })
	ap:AddLabel("Fill color"):AddColorPicker("ESPChamsFill", { Default = Color3.fromRGB(59, 144, 204), Title = "Cham fill" })
	ap:AddSlider("ESPChamsFillT", { Text = "Fill transparency", Default = 0.6, Min = 0, Max = 1, Rounding = 2 })
	ap:AddLabel("Outline color"):AddColorPicker("ESPChamsOutline", { Default = Color3.fromRGB(255, 255, 255), Title = "Cham outline" })
	ap:AddSlider("ESPChamsOutlineT", { Text = "Outline transparency", Default = 0, Min = 0, Max = 1, Rounding = 2 })
	ap:AddToggle("ESPChamsVisible", { Text = "Visible check", Default = false })

	local aq = ak.ESP:AddRightGroupbox("Names & Info")
	aq:AddToggle("ESPNames", { Text = "Names", Default = true })
	aq:AddLabel("Name color"):AddColorPicker("ESPNameColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Name color" })
	aq:AddSlider("ESPTextSize", { Text = "Text size", Default = 12, Min = 6, Max = 28, Rounding = 0 })
	aq:AddToggle("ESPTextOutline", { Text = "Text outline", Default = true })
	aq:AddToggle("ESPDistance", { Text = "Distance", Default = false })
	aq:AddLabel("Distance color"):AddColorPicker("ESPDistanceColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Distance color" })
	aq:AddToggle("ESPWeapon", { Text = "Weapon", Default = false })
	aq:AddToggle("ESPHealth", { Text = "Health bar", Default = false })
	aq:AddToggle("ESPSkeleton", { Text = "Skeleton", Default = false })
	aq:AddLabel("Skeleton color"):AddColorPicker("ESPSkeletonColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Skeleton color" })

	local ar = ak.ESP:AddRightGroupbox("Flags")
	ar:AddToggle("ESPFlags", { Text = "Flags", Default = false })
	ar:AddDropdown("ESPFlagList", {
		Text = "Shown flags",
		Values = ad,
		Default = { "Reloading", "Cooldown", "Sprinting", "Cash", "KDR", "Cheater" },
		Multi = true,
	})
	ar:AddDropdown("ESPFlagSide", { Text = "Side", Values = { "Right", "Left" }, Default = 1, Multi = false })
	ar:AddLabel("Info color"):AddColorPicker("ESPFlagColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Info flags" })
	ar:AddLabel("State color"):AddColorPicker("ESPFlagState", { Default = Color3.fromRGB(255, 200, 60), Title = "State flags" })
	ar:AddLabel("Safe color"):AddColorPicker("ESPFlagSafe", { Default = Color3.fromRGB(90, 255, 120), Title = "Cooldown / reload" })
	ar:AddLabel("Cheater color"):AddColorPicker("ESPFlagCheater", { Default = Color3.fromRGB(255, 60, 60), Title = "Cheater flag" })

	local as = ak.ESP:AddRightGroupbox("OOF Arrows")
	as:AddToggle("ESPArrows", { Text = "Off-screen arrows", Default = false })
	as:AddLabel("Arrow color"):AddColorPicker("ESPArrowColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Arrow color" })
	as:AddSlider("ESPArrowSize", { Text = "Arrow size", Default = 14, Min = 8, Max = 40, Rounding = 0 })

	local at = ak.Visuals:AddLeftGroupbox("World")
	at:AddToggle("fullbright", { Text = "Fullbright", Default = false })
	at:AddSlider("worldbrightness", { Text = "Brightness", Default = 2, Min = 0, Max = 10, Rounding = 1 })
	at:AddLabel("Ambient"):AddColorPicker("worldambient", { Default = Color3.fromRGB(160, 160, 160), Title = "Ambient" })
	at:AddToggle("worldshadows", { Text = "Shadows", Default = false })
	at:AddToggle("nofog", { Text = "No fog", Default = false })

	local au = ak.Visuals:AddRightGroupbox("Screen")
	au:AddToggle("nodof", { Text = "No depth of field", Default = false })
	au:AddToggle("noscreenfx", { Text = "No blur / hit tint", Default = false })
	au:AddToggle("nomotionblur", { Text = "No motion blur", Default = false })

	local av = ak.Visuals:AddLeftGroupbox("Camera")
	av:AddToggle("customfov", { Text = "Custom FOV", Default = false })
	av:AddSlider("customfovvalue", { Text = "FOV", Default = 80, Min = 40, Max = 120, Rounding = 0 })
	av:AddToggle("zoom", { Text = "Zoom", Default = false }):AddKeyPicker("zoombind", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Hold",
		Text = "Zoom",
	})
	av:AddSlider("zoomfov", { Text = "Zoom FOV", Default = 20, Min = 5, Max = 60, Rounding = 0 })

	local aw = ak.Visuals:AddRightGroupbox("Weapon Feel")
	aw:AddToggle("aimsway", { Text = "Aim sway", Default = false })
	aw:AddSlider("aimswaymult", { Text = "Sway multiplier", Default = 0, Min = 0, Max = 200, Rounding = 0, Suffix = "%" })
	aw:AddToggle("aimspeed", { Text = "Aim speed", Default = false })
	aw:AddSlider("aimspeedmult", { Text = "Aim speed multiplier", Default = 200, Min = 50, Max = 500, Rounding = 0, Suffix = "%" })
	for ax, ay in { "aimsway", "aimspeed" } do
		getgenv().Toggles[ay]:OnChanged(function()
			if af.combat and af.combat.applyMods then
				af.combat.applyMods()
			end
		end)
	end
	for ax, ay in { "aimswaymult", "aimspeedmult" } do
		getgenv().Options[ay]:OnChanged(function()
			if af.combat and af.combat.applyMods then
				af.combat.applyMods()
			end
		end)
	end

	local function ax(ay, az)
		local aA = ah(ay, az)
		return typeof(aA) == "Color3" and aA or az
	end

	local ay = {}
	local function az()
		table.clear(ay)
		local aA = ah("ESPFlagList", {})
		if type(aA) == "table" then
			for aB, aC in aA do
				if aC then
					ay[aB] = true
				end
			end
		end
	end

	local function aA(aB, aC)
		LPH_ATTRIBUTES(VM(NONE))
		if not aC or aC == ai then
			return nil
		end
		local aD = {}
		local aE = ax("ESPFlagColor", Color3.new(1, 1, 1))
		local aF = ax("ESPFlagState", Color3.fromRGB(255, 200, 60))
		local aG = ax("ESPFlagSafe", Color3.fromRGB(90, 255, 120))
		if ay.Cheater and af.misc and af.misc.cheater then
			local aH = af.misc.cheater(aC)
			if aH then
				aD[#aD + 1] = { text = "CHEATER " .. table.concat(aH, " "), color = ax("ESPFlagCheater", Color3.fromRGB(255, 60, 60)) }
			end
		end
		if ay.Reloading and aB:GetAttribute("PReload") then
			aD[#aD + 1] = { text = "RELOADING", color = aG }
		end
		if ay.Cooldown then
			local aH = ab.cooldownLeft(aC, aB)
			if aH > 0 then
				aD[#aD + 1] = { text = string.format("COOLDOWN %.1f", aH), color = aG }
			end
		end
		if ay.Sprinting and aB:GetAttribute("PSprint") then
			aD[#aD + 1] = { text = "SPRINTING", color = aF }
		end
		if ay.Aiming and aB:GetAttribute("PAim") then
			aD[#aD + 1] = { text = "AIMING", color = aF }
		end
		if ay.Crouching and aB:GetAttribute("PCrouch") then
			aD[#aD + 1] = { text = "CROUCHED", color = aF }
		end
		if ay.Ammo then
			local aH = ab.toolOf(aB)
			local aI = aH and aH:GetAttribute("Mag")
			if type(aI) == "number" then
				local aJ = aH:GetAttribute("Reserve")
				aD[#aD + 1] = { text = string.format("AMMO %d/%s", aI, tostring(aJ or "?")), color = aI == 0 and aG or aE }
			end
		end
		if ay.Cash then
			local aH = aC:GetAttribute("Money")
			if type(aH) == "number" then
				aD[#aD + 1] = { text = ab.formatCash(aH), color = aE }
			end
		end
		if ay["Session Time"] then
			local aH, aI = ab.sessionTime(aC)
			aD[#aD + 1] = { text = (aI and ">" or "") .. ab.formatTime(aH), color = aE }
		end
		if ay.KDR or ay["K/D"] then
			local aH, aI, aJ = ab.stats(aC)
			if ay.KDR then
				aD[#aD + 1] = { text = string.format("KDR %.2f", aJ), color = aE }
			end
			if ay["K/D"] then
				aD[#aD + 1] = { text = string.format("%d/%d", aH, aI), color = aE }
			end
		end
		if ay.Primary then
			local aH = aC:GetAttribute("Primary")
			if type(aH) == "string" and aH ~= "" then
				aD[#aD + 1] = { text = aH, color = aE }
			end
		end
		if ay.Grenades then
			local aH = aC:GetAttribute("GrenadeCount")
			if type(aH) == "number" and aH > 0 then
				aD[#aD + 1] = { text = "NADES " .. aH, color = aE }
			end
		end
		if ay["Case Keys"] then
			local aH = aC:GetAttribute("CaseKeys")
			if type(aH) == "number" then
				aD[#aD + 1] = { text = "KEYS " .. aH, color = aE }
			end
		end
		return aD
	end

	local function aB(aC, aD)
		LPH_ATTRIBUTES(VM(NONE))
		return aD ~= ai and not aC:GetAttribute("Ragdolled")
	end

	local function aC()
		LPH_ATTRIBUTES(VM(NONE))
		local aD = am
		if not aD then
			return
		end
		az()
		aD.Enabled = ag("ESPMaster", false)
		aD.Players = true
		aD.LocalPlayer = false
		aD.Filter = aB
		aD.FlagProvider = aA
		aD.Directories = {}
		aD.MaxDistance = tonumber(ah("ESPMaxDistance", 0)) or 0
		aD.DynamicBoxes = true
		aD.DynamicBoxesCheap = true
		aD.Boxes = ag("ESPBoxes", true)
		aD.BoxType = ah("ESPBoxType", "Normal")
		aD.BoxColor = ax("ESPBoxColor", Color3.new(1, 1, 1))
		aD.BoxThickness = tonumber(ah("ESPBoxThickness", 1)) or 1
		aD.Outlines.Style = ag("ESPBoxOutline", true) and "Full" or "None"
		aD.Outlines.Color = ax("ESPBoxOutlineColor", Color3.new(0, 0, 0))
		aD.BoxFill.Enabled = ag("ESPBoxFill", false)
		aD.BoxFill.Color = ax("ESPBoxFillColor", Color3.new(1, 1, 1))
		aD.BoxFill.Transparency = tonumber(ah("ESPBoxFillTransparency", 0.9)) or 0.9
		aD.Names = ag("ESPNames", true)
		aD.TextColor = ax("ESPNameColor", Color3.new(1, 1, 1))
		aD.TextSize = tonumber(ah("ESPTextSize", 12)) or 12
		aD.TextOutline = ag("ESPTextOutline", true)
		aD.Distance.Enabled = ag("ESPDistance", false)
		aD.Distance.Color = ax("ESPDistanceColor", Color3.new(1, 1, 1))
		aD.Weapon.Enabled = ag("ESPWeapon", false)
		aD.Weapon.UseToolFallback = true
		aD.HealthBar.Enabled = ag("ESPHealth", false)
		aD.HealthBar.ShowText = true
		aD.Skeleton.Enabled = ag("ESPSkeleton", false)
		aD.Skeleton.Color = ax("ESPSkeletonColor", Color3.new(1, 1, 1))
		aD.Flags.Enabled = ag("ESPFlags", false)
		aD.Flags.Position = ah("ESPFlagSide", "Right")
		aD.Flags.Options.Idle = false
		aD.Flags.Options.Moving = false
		aD.Flags.Options.Jumping = false
		aD.Flags.Options.Swimming = false
		aD.Chams.Enabled = ag("ESPChams", false)
		aD.Chams.Type = ah("ESPChamsType", "Highlight")
		local aE = ax("ESPChamsFill", Color3.fromRGB(59, 144, 204))
		local aF = tonumber(ah("ESPChamsFillT", 0.6)) or 0.6
		local aG = ax("ESPChamsOutline", Color3.new(1, 1, 1))
		local aH = tonumber(ah("ESPChamsOutlineT", 0)) or 0
		local aI = ag("ESPChamsVisible", false)
		aD.Chams.Highlight.FillColor = aE
		aD.Chams.Highlight.FillTransparency = aF
		aD.Chams.Highlight.OutlineColor = aG
		aD.Chams.Highlight.OutlineTransparency = aH
		aD.Chams.Highlight.VisibleCheck = aI
		aD.Chams.MeshChams.FillColor = aE
		aD.Chams.MeshChams.FillTransparency = aF
		aD.Chams.MeshChams.OutlineColor = aG
		aD.Chams.MeshChams.OutlineTransparency = aH
		aD.Chams.MeshChams.VisibleCheck = aI
		aD.Chams.Adornment.Color = aE
		aD.Chams.Adornment.Transparency = aF
		aD.Chams.Adornment.VisibleCheck = aI
		aD.OffScreenArrows.Enabled = ag("ESPArrows", false)
		aD.OffScreenArrows.Color = ax("ESPArrowColor", Color3.new(1, 1, 1))
		aD.OffScreenArrows.Size = tonumber(ah("ESPArrowSize", 14)) or 14
	end

	local aD = getgenv().Toggles
	local aE = getgenv().Options
	for aF, aG in aD do
		if string.sub(aF, 1, 3) == "ESP" then
			aG:OnChanged(aC)
		end
	end
	for aF, aG in aE do
		if string.sub(aF, 1, 3) == "ESP" and aG.OnChanged then
			aG:OnChanged(aC)
		end
	end

	
	local aF = {}
	local function aG(aH, aI)
		local aJ = aH
		aF[aJ] = aF[aJ] or {}
		if aF[aJ][aI] == nil then
			aF[aJ][aI] = aH[aI]
		end
	end
	local function aH(aI, aJ)
		local aK = aF[aI]
		if aK and aK[aJ] ~= nil then
			pcall(function()
				aI[aJ] = aK[aJ]
			end)
			aK[aJ] = nil
		end
	end
	local function aI(aJ, aK, aL)
		if aJ[aK] ~= aL then
			aG(aJ, aK)
			aJ[aK] = aL
		end
	end

	local aJ = 0

	
	local aK = { MaxBlur = 0, MaxVignette = 0 }
	local aL
	local function aM()
		local aN = ai:FindFirstChildOfClass("PlayerScripts")
		return aN and aN:FindFirstChild("TurnBlur")
	end
	local function aN()
		local aO = aM()
		if not aO then
			return
		end
		if ag("nomotionblur", false) then
			if not aL then
				aL = {}
				for aP in aK do
					aL[aP] = aO:GetAttribute(aP)
				end
			end
			for aP, aQ in aK do
				if aO:GetAttribute(aP) ~= aQ then
					aO:SetAttribute(aP, aQ)
				end
			end
		elseif aL then
			for aP in aK do
				aO:SetAttribute(aP, aL[aP])
			end
			aL = nil
		end
	end
	function ac.step()
		LPH_ATTRIBUTES(VM(NONE))
		local aO = os.clock()
		if aO - aJ < 0.1 then
			return
		end
		aJ = aO
		if ag("fullbright", false) then
			aI(aj, "Brightness", tonumber(ah("worldbrightness", 2)) or 2)
			aI(aj, "Ambient", ax("worldambient", Color3.fromRGB(160, 160, 160)))
			aI(aj, "OutdoorAmbient", ax("worldambient", Color3.fromRGB(160, 160, 160)))
			aI(aj, "GlobalShadows", ag("worldshadows", false))
			aI(aj, "ExposureCompensation", 0)
		else
			aH(aj, "Brightness")
			aH(aj, "Ambient")
			aH(aj, "OutdoorAmbient")
			aH(aj, "GlobalShadows")
			aH(aj, "ExposureCompensation")
		end
		local aP = aj:FindFirstChildOfClass("Atmosphere")
		if ag("nofog", false) then
			aI(aj, "FogEnd", 1e6)
			if aP then
				aI(aP, "Density", 0)
				aI(aP, "Haze", 0)
			end
		else
			aH(aj, "FogEnd")
			if aP then
				aH(aP, "Density")
				aH(aP, "Haze")
			end
		end
		local aQ = aj:FindFirstChildOfClass("DepthOfFieldEffect")
		if aQ then
			if ag("nodof", false) then
				aI(aQ, "Enabled", false)
			else
				aH(aQ, "Enabled")
			end
		end
		for aR, aS in ae do
			local aT = aj:FindFirstChild(aS)
			if aT then
				if ag("noscreenfx", false) then
					aI(aT, "Enabled", false)
				else
					aH(aT, "Enabled")
				end
			end
		end
		aN()
	end

	
	
	local aO, aP
	local function aQ()
		local aR = ai.Character
		local aS = aR and aR:FindFirstChildOfClass("Tool")
		local aT = ab.weaponConfig(aS)
		if aT and type(aT.HipFOV) == "number" then
			return aT.HipFOV
		end
		if aS and aS:GetAttribute("IsKnife") then
			local aU = game:GetService("ReplicatedStorage"):FindFirstChild("CombatKnife")
			local aV = aU and aU:FindFirstChild("Config")
			local aW = aV and aV:GetAttribute("HipFOV")
			if type(aW) == "number" then
				return aW
			end
		end
		return 70
	end

	function ac.renderStep()
		LPH_ATTRIBUTES(VM(NONE))
		local aR = workspace.CurrentCamera
		if not aR then
			return
		end
		local aS = ai.Character
		local aT = aS and aS:GetAttribute("ExecutionLocked")
		local aU = ag("zoom", false)
		local aV = ag("customfov", false)
		if aT or not (aU or aV) then
			if aO then
				if math.abs(aR.FieldOfView - aO) < 1e-3 and aP then
					aR.FieldOfView = aP
				end
				aO, aP = nil, nil
			end
			return
		end
		local aW = aR.FieldOfView
		if aO and math.abs(aW - aO) < 1e-3 and aP then
			aW = aP 
		end
		aP = aW
		local aX
		if aU then
			aX = tonumber(ah("zoomfov", 20)) or 20
		else
			local aY = tonumber(ah("customfovvalue", 80)) or 80
			aX = aW * aY / math.max(aQ(), 1)
		end
		aX = math.clamp(aX, 1, 120)
		aR.FieldOfView = aX
		aO = aX
	end

	function ac.unload()
		for aR, aS in aF do
			for aT, aU in aS do
				pcall(function()
					aR[aT] = aU
				end)
			end
		end
		table.clear(aF)
		if aL then
			local aR = aM()
			if aR then
				for aS in aK do
					pcall(aR.SetAttribute, aR, aS, aL[aS])
				end
			end
			aL = nil
		end
	end

	ac.applyESP = aC
	af.visuals = ac
end

return ac
end function a.h()local ab=a.cache.h if not ab then ab={c=aa()}a.cache.h=ab end return ab.c end end do local function aa()
local ab = a.e()

local ac = {}

function ac.build(ad)
	local ae = ad.tv
	local af = ad.ov
	local ag = ad.Players
	local ah = ad.LocalPlayer
	local ai = ad.Tabs

	local aj = ai.Misc:AddLeftGroupbox("Cheater Detection")
	aj:AddToggle("cheatmv", { Text = "Movement violations", Default = true })
	aj:AddSlider("cheatmvmin", { Text = "Min violations", Default = 3, Min = 1, Max = 30, Rounding = 0 })
	aj:AddToggle("cheatspeed", { Text = "Speed check", Default = true })
	aj:AddSlider("cheatspeedmax", { Text = "Max speed", Default = 24, Min = 16, Max = 80, Rounding = 0, Suffix = " st/s" })
	aj:AddSlider("cheatspeedtime", { Text = "Over speed for", Default = 1.5, Min = 0.2, Max = 5, Rounding = 1, Suffix = "s" })
	aj:AddToggle("cheattp", { Text = "Teleport check", Default = true })
	aj:AddSlider("cheattpdist", { Text = "Teleport distance", Default = 25, Min = 10, Max = 200, Rounding = 0, Suffix = " st" })
	aj:AddSlider("cheattpmin", { Text = "Min teleports", Default = 2, Min = 1, Max = 10, Rounding = 0 })
	aj:AddToggle("cheatair", { Text = "Hover / fly check", Default = true })
	aj:AddSlider("cheatairtime", { Text = "Hover time", Default = 2.5, Min = 0.5, Max = 10, Rounding = 1, Suffix = "s" })
	aj:AddToggle("cheatfirerate", { Text = "Fire rate check", Default = true })
	aj:AddSlider("cheatfiremin", { Text = "Min fast shots", Default = 3, Min = 1, Max = 20, Rounding = 0 })
	aj:AddToggle("cheatkdr", { Text = "KDR check", Default = false })
	aj:AddSlider("cheatkdrmin", { Text = "Min KDR", Default = 6, Min = 1, Max = 30, Rounding = 1 })
	aj:AddSlider("cheatkdrkills", { Text = "Min kills", Default = 40, Min = 5, Max = 500, Rounding = 0 })
	aj:AddToggle("cheatsticky", { Text = "Remember for session", Default = true })

	local ak = ai.Misc:AddRightGroupbox("Alerts")
	ak:AddToggle("cheatnotify", { Text = "Notify on new cheater", Default = true })
	ak:AddButton({
		Text = "Clear cheater list",
		Func = function()
			ac.reset()
		end,
	})
	local al = ak:AddLabel("Your movement violations: 0", true)

	local am = {}
	local an = {}
	local ao = Vector3.new(0, -6, 0)
	local ap = RaycastParams.new()
	ap.FilterType = Enum.RaycastFilterType.Exclude
	ap.IgnoreWater = false
	local aq = {}

	local function ar(as)
		local at = am[as]
		if not at then
			at = { overSpeed = 0, air = 0, teleports = 0, lastPos = nil, lastAt = 0, character = nil, reasons = {} }
			am[as] = at
		end
		return at
	end

	function ac.reset()
		table.clear(am)
		table.clear(an)
	end

	local function as(at, au, av)
		LPH_ATTRIBUTES(VM(NONE))
		local aw = ab.characterOf(at)
		if not ab.isAlive(aw) then
			au.lastPos = nil
			au.overSpeed = 0
			au.air = 0
			return
		end
		local ax = aw:FindFirstChild("HumanoidRootPart")
		local ay = ab.humanoidOf(aw)
		if not ax or not ay then
			return
		end
		local az = ax.Position
		if au.character ~= aw then
			au.character = aw
			au.lastPos = az
			au.lastAt = av
			au.spawnedAt = av
			return
		end
		local aA = av - au.lastAt
		if not au.lastPos or aA <= 0 then
			au.lastPos = az
			au.lastAt = av
			return
		end
		local aB = az - au.lastPos
		local aC = Vector3.new(aB.X, 0, aB.Z).Magnitude
		local aD = av - (au.spawnedAt or 0) > 3
		local aE = aw:GetAttribute("TowerClimbing") == true
		if aD and ae("cheattp", true) and aC > (tonumber(af("cheattpdist", 25)) or 25) and aA < 0.5 then
			au.teleports += 1
		end
		local aF = aC / aA
		if aD and aF > (tonumber(af("cheatspeedmax", 24)) or 24) and aC < (tonumber(af("cheattpdist", 25)) or 25) then
			au.overSpeed += aA
		else
			au.overSpeed = math.max(0, au.overSpeed - aA * 0.5)
		end
		local aG = aB.Y / aA
		local aH = false
		if aD and not aE and math.abs(aG) < 1.5 and ay.SeatPart == nil then
			aq[1] = aw
			ap.FilterDescendantsInstances = aq
			aH = workspace:Raycast(az, ao, ap) == nil
		end
		if aH then
			au.air += aA
		else
			au.air = 0
		end
		au.lastPos = az
		au.lastAt = av
	end

	local function at(au, av)
		LPH_ATTRIBUTES(VM(NONE))
		local aw = {}
		local ax = tonumber(au:GetAttribute("MovementViolations")) or 0
		if ae("cheatmv", true) and ax >= (tonumber(af("cheatmvmin", 3)) or 3) then
			aw[#aw + 1] = "MV" .. ax
		end
		if ae("cheatspeed", true) and av.overSpeed >= (tonumber(af("cheatspeedtime", 1.5)) or 1.5) then
			aw[#aw + 1] = "SPD"
		end
		if ae("cheattp", true) and av.teleports >= (tonumber(af("cheattpmin", 2)) or 2) then
			aw[#aw + 1] = "TP" .. av.teleports
		end
		if ae("cheatair", true) and av.air >= (tonumber(af("cheatairtime", 2.5)) or 2.5) then
			aw[#aw + 1] = "FLY"
		end
		local ay = ab.shots[au]
		if ae("cheatfirerate", true) and ay and ay.fast >= (tonumber(af("cheatfiremin", 3)) or 3) then
			aw[#aw + 1] = "RATE"
		end
		if ae("cheatkdr", false) then
			local az, aA, aB = ab.stats(au)
			if az >= (tonumber(af("cheatkdrkills", 40)) or 40) and aB >= (tonumber(af("cheatkdrmin", 6)) or 6) then
				aw[#aw + 1] = string.format("KDR%.1f", aB)
			end
		end
		return aw
	end

	local au = 0
	function ac.step()
		LPH_ATTRIBUTES(VM(NONE))
		local av = os.clock()
		if av - au < 0.1 then
			return
		end
		au = av
		for aw, ax in ag:GetPlayers() do
			if ax == ah then
				continue
			end
			local ay = ar(ax)
			as(ax, ay, av)
			local az = at(ax, ay)
			if #az > 0 then
				if not an[ax] and ae("cheatnotify", true) then
					ad.notify(ax.Name .. " flagged: " .. table.concat(az, " "))
				end
				an[ax] = az
			elseif an[ax] and not ae("cheatsticky", true) then
				an[ax] = nil
			end
		end
		local aw = tonumber(ah:GetAttribute("MovementViolations")) or 0
		al:SetText("Your movement violations: " .. aw)
	end

	function ac.cheater(av)
		LPH_ATTRIBUTES(VM(NONE))
		return an[av]
	end

	local av = ag.PlayerRemoving:Connect(function(av)
		am[av] = nil
		an[av] = nil
	end)

	function ac.unload()
		av:Disconnect()
		ac.reset()
	end

	ad.misc = ac
end

return ac
end function a.i()local ab=a.cache.i if not ab then ab={c=aa()}a.cache.i=ab end return ab.c end end do local function aa()
local ab = {}

local ac = { "Mil-Spec", "Restricted", "Classified", "Covert", "Rare Special" }
local ad = { 5, 3, 1 }

function ab.build(ae)
	local af = ae.tv
	local ag = ae.ov
	local ah = ae.Tabs
	local ai = ae.LocalPlayer
	local aj = ae.ReplicatedStorage

	local ak = ah.Misc:AddRightGroupbox("Cases")
	ak:AddToggle("autoopencases", { Text = "Auto open cases", Default = false })
	ak:AddDropdown("autoopentype", { Text = "Case", Values = { "Knife", "Clothing", "Alternate" }, Default = 1, Multi = false })
	ak:AddLabel("Only spends keys, never cash.", true)
	ak:AddToggle("notifyknife", { Text = "Knife notifications", Default = true })
	ak:AddToggle("notifycloth", { Text = "Clothing notifications", Default = true })
	ak:AddDropdown("notifyrarity", {
		Text = "Notify rarities",
		Values = ac,
		Default = { "Classified", "Covert", "Rare Special" },
		Multi = true,
	})
	local al = ak:AddLabel("Keys: 0", true)

	local am = aj:FindFirstChild("KnifeCases")
	local an = aj:FindFirstChild("ClothingCases")
	local ao, ap
	pcall(function()
		ao = require(am.Config)
	end)
	pcall(function()
		ap = require(an.Config)
	end)
	local aq = am and am:FindFirstChild("CaseRequest")
	local ar = an and an:FindFirstChild("ClothingRequest")

	local function as(at, au)
		local av = at and at.TierById and at.TierById[au]
		return av and av.name or tostring(au)
	end

	local function at(au, av)
		if au == "Knife" then
			local aw = ao and ao.KnifeById and ao.KnifeById[av]
			return aw and aw.name or av, aw and as(ao, aw.tier) or "?"
		end
		local aw = ap and ap.ItemById and ap.ItemById[av]
		return aw and aw.name or av, aw and as(ap, aw.tier) or "?"
	end

	local function au(av)
		local aw = ag("notifyrarity", {})
		return type(aw) == "table" and aw[av] == true
	end

	
	local av = {}
	for aw, ax in ai:GetAttributes() do
		if type(ax) == "number" and (string.sub(aw, 1, 11) == "KnifeCount_" or string.sub(aw, 1, 11) == "ClothCount_") then
			av[aw] = ax
		end
	end

	local aw = {}
	aw[#aw + 1] = ai.AttributeChanged:Connect(function(ax)
		local ay
		if string.sub(ax, 1, 11) == "KnifeCount_" then
			ay = "Knife"
		elseif string.sub(ax, 1, 11) == "ClothCount_" then
			ay = "Clothing"
		else
			return
		end
		local az = ai:GetAttribute(ax)
		if type(az) ~= "number" then
			return
		end
		local aA = av[ax] or 0
		av[ax] = az
		if az <= aA then
			return
		end
		if ay == "Knife" and not af("notifyknife", true) then
			return
		end
		if ay == "Clothing" and not af("notifycloth", true) then
			return
		end
		local aB = string.sub(ax, 12)
		local aC, aD = at(ay, aB)
		if not au(aD) then
			return
		end
		local aE = az - aA
		ae.notify(string.format("%s: %s [%s]%s", ay, aC, aD, aE > 1 and (" x" .. aE) or ""))
	end)

	local ax = false
	local ay = false

	local function az()
		return tonumber(ai:GetAttribute("CaseKeys")) or 0
	end

	local function aA()
		local aB = ag("autoopentype", "Knife")
		if aB == "Alternate" then
			ay = not ay
			aB = ay and "Knife" or "Clothing"
		end
		return aB == "Clothing" and ar or aq
	end

	local function aB(aC)
		local aD = os.clock()
		while az() > aC and os.clock() - aD < 3 do
			task.wait(0.1)
		end
	end

	local function aC()
		if ax then
			return
		end
		ax = true
		task.spawn(function()
			local aD = 0
			while af("autoopencases", false) and not ab.unloaded do
				if ai:GetAttribute("ProgressReady") ~= true then
					break
				end
				local aE = az()
				local aF
				for aG, aH in ad do
					if aH <= aE then
						aF = aH
						break
					end
				end
				if not aF then
					break
				end
				local aG = aA()
				if not aG then
					break
				end
				local aH, aI = pcall(aG.InvokeServer, aG, "Open", aF)
				if not aH or type(aI) ~= "table" then
					break
				end
				if aI.ok then
					aD += aF
					aB(aE - aF)
					task.wait(0.4)
				elseif aI.msg == "Busy" then
					task.wait(math.clamp(tonumber(aI.retryAfter) or 0.3, 0.1, 1.05))
				else
					ae.notify("Case open stopped: " .. tostring(aI.msg), true)
					break
				end
			end
			if aD > 0 then
				ae.notify("Opened " .. aD .. " case" .. (aD == 1 and "" or "s"))
			end
			ax = false
		end)
	end

	aw[#aw + 1] = ai:GetAttributeChangedSignal("CaseKeys"):Connect(function()
		if af("autoopencases", false) then
			aC()
		end
	end)
	local aD = getgenv().Toggles.autoopencases
	if aD then
		aD:OnChanged(function(aE)
			if aE then
				aC()
			end
		end)
	end

	local aE = 0
	function ab.step()
		local aF = os.clock()
		if aF - aE < 2 then
			return
		end
		aE = aF
		al:SetText("Keys: " .. az())
		if af("autoopencases", false) and az() > 0 then
			aC()
		end
	end

	function ab.unload()
		ab.unloaded = true
		for aF, aG in aw do
			aG:Disconnect()
		end
		table.clear(aw)
	end

	ae.cases = ab
end

return ab
end function a.j()local ab=a.cache.j if not ab then ab={c=aa()}a.cache.j=ab end return ab.c end end do local function aa()
local ab = a.e()

local ac = {}




function ac.build(ad)
	local ae = ad.tv
	local af = ad.ov
	local ag = ad.Tabs
	local ah = ad.LocalPlayer
	local ai = ad.ReplicatedStorage
	local aj = ad.HttpService

	local ak = ag.Combat:AddLeftGroupbox("Knife")
	ak:AddToggle("knifereach", { Text = "Knife reach", Default = false })
	ak:AddSlider("knifereachdist", { Text = "Reach", Default = 7.5, Min = 6.5, Max = 12, Rounding = 1, Suffix = " studs" })
	ak:AddLabel("Server allows ~7.4, ~10 while sprinting.", true)

	local al = ag.Combat:AddLeftGroupbox("Knife Aura")
	al:AddToggle("knifeaura", { Text = "Enabled", Default = false }):AddKeyPicker("knifeaurabind", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Knife Aura",
	})
	al:AddSlider("knifeaurareach", { Text = "Reach", Default = 6.5, Min = 2, Max = 12, Rounding = 1, Suffix = " studs" })
	al:AddLabel("Hold the knife. Only stabs from behind, like the game.", true)

	local am = ai:FindFirstChild("CombatKnife")
	am = am and am:FindFirstChild("Execution")
	local an = am and am:FindFirstChild("Config")
	local ao = am and am:FindFirstChild("Remote")
	local ap
	pcall(function()
		ap = require(am.Targeting)
	end)

	local aq
	local ar
	local function as()
		if not an then
			return
		end
		local at = an:GetAttribute("MaxRange")
		if at ~= ar then
			aq = at
		end
		local au = aq or 6.5
		local av = au
		if ae("knifereach", false) then
			av = math.max(av, tonumber(af("knifereachdist", 7.5)) or 7.5)
		end
		if ae("knifeaura", false) then
			av = math.max(av, tonumber(af("knifeaurareach", 6.5)) or 6.5)
		end
		if av ~= at then
			an:SetAttribute("MaxRange", av)
		end
		ar = av
	end

	local at = aj:GenerateGUID(false)
	local au = 0
	local av = 0

	local function aw(ax)
		local ay = ax and ax:FindFirstChildOfClass("Tool")
		return ay ~= nil and ay:GetAttribute("IsKnife") == true
	end

	local function ax()
		LPH_ATTRIBUTES(VM(NONE))
		if not ap or not ao or not ae("knifeaura", false) then
			return
		end
		local ay = os.clock()
		if ay - av < 0.25 then
			return
		end
		local az = ah.Character
		if not ab.isAlive(az) or not aw(az) or az:GetAttribute("ExecutionLocked") then
			return
		end
		local aA = tonumber(af("knifeaurareach", 6.5)) or 6.5
		local aB = az:FindFirstChild("HumanoidRootPart")
		if not aB then
			return
		end
		
		local aC, aD = pcall(ap.Best, az)
		if not aC or typeof(aD) ~= "Instance" then
			return
		end
		local aE = aD:FindFirstChild("HumanoidRootPart")
		if not aE then
			return
		end
		local aF = (aE.Position - aB.Position) * Vector3.new(1, 0, 1)
		if aF.Magnitude > aA then
			return
		end
		av = ay
		au += 1
		ao:FireServer("Request", aD, at .. ":" .. au, workspace:GetServerTimeNow())
	end

	local ay = 0
	function ac.step()
		LPH_ATTRIBUTES(VM(NONE))
		local az = os.clock()
		if az - ay > 0.5 then
			ay = az
			as()
		end
		ax()
	end

	for az, aA in { "knifereach", "knifeaura" } do
		local aB = getgenv().Toggles[aA]
		if aB then
			aB:OnChanged(as)
		end
	end
	for az, aA in { "knifereachdist", "knifeaurareach" } do
		local aB = getgenv().Options[aA]
		if aB then
			aB:OnChanged(as)
		end
	end

	function ac.unload()
		if an and ar ~= nil and ar ~= aq then
			pcall(an.SetAttribute, an, "MaxRange", aq)
		end
	end

	ad.knife = ac
end

return ac
end function a.k()local ab=a.cache.k if not ab then ab={c=aa()}a.cache.k=ab end return ab.c end end end
if not LPH_OBFUSCATED then
	LPH_ATTRIBUTES = function(...) end
	OPTIMIZE = function(...)
		return ...
	end
	ERROR_HANDLING = function(...)
		return ...
	end
	ENCRYPT = function(...)
		return ...
	end
	PRESET = function(...)
		return ...
	end
	VM = function(...)
		return ...
	end
	FAST = "FAST"
	NONE = "NONE"
	NO_UPVALUES = "NO_UPVALUES"
	LPH_ENCSTR = function(aa)
		return aa
	end
	LPH_ENCNUM = function(aa)
		return aa
	end
	LPH_ENCBUF = function(aa)
		return aa
	end
	LPH_CRASH = function() end
	LPH_STACKALLOC = function(aa)
		return table.create(aa)
	end
	LPH_PRECHECK = function(...) end
	LPH_REWRITE = function(aa)
		return aa
	end
	LPH_LINE = 0
end

if getgenv().VaultSS_Unload then
	pcall(getgenv().VaultSS_Unload)
end

local aa = game:GetService("Players")
local ab = game:GetService("RunService")
local ac = game:GetService("UserInputService")
local ad = game:GetService("Lighting")
local ae = game:GetService("ReplicatedStorage")
local af = game:GetService("HttpService")
local ag = aa.LocalPlayer

local ah, ai, aj = loadstring(game:HttpGet("https://raw.githubusercontent.com/ttokennxyz/vaultcc/refs/heads/main/uilib.lua"))()

local ak, al = pcall(function()
	return a.a()
end)
if not ak or type(al) ~= "table" then
	al = nil
end

local am = a.b()
local an = a.c()

local ao = a.d().create({
	title = "Shotgun Schizoid - vault.cc",
	folder = "VaultCC/ShotgunSchizoid",
	tabs = { "Combat", "ESP", "Visuals", "Misc", "Settings" },
	keybind = "menubind",
	ignore = { "menubind" },
	afterLoad = function(ao)
		if ao.visuals and ao.visuals.applyESP then
			ao.visuals.applyESP()
		end
	end,
})

local ap = a.e()
local aq = a.f()
local ar = a.g()
local as = a.h()
local at = a.i()
local au = a.j()
local av = a.k()

local aw = {
	Players = aa,
	RunService = ab,
	UserInputService = ac,
	Lighting = ad,
	ReplicatedStorage = ae,
	LocalPlayer = ag,
	Camera = workspace.CurrentCamera,
	HttpService = af,
	ESP = al,
	Library = ah,
	ThemeManager = ai,
	SaveManager = aj,
	tv = am.tv,
	ov = am.ov,
	cloneOriginal = an.cloneOriginal,
	findGcFunction = an.findGcFunction,
	util = ap,
	notify = function(aw, ax)
		if ah and ah.Notify then
			pcall(ah.Notify, ah, aw, ax and 4 or 3)
		end
	end,
}

ap.start()
ao.build(aw)
aq.build(aw)
ar.build(aw)
av.build(aw)
at.build(aw)
au.build(aw)
as.build(aw)
ao.finish(aw)

if aw.visuals and aw.visuals.applyESP then
	aw.visuals.applyESP()
end

local ax = false
local ay
local function az()
	if ax then
		return
	end
	ax = true
	getgenv().VaultSS_Unload = nil
	getgenv().VaultSS_Debug = nil
	if ay then
		ay:Disconnect()
		ay = nil
	end
	pcall(function()
		ab:UnbindFromRenderStep("vault_ss")
	end)
	for aA, aB in { "combat", "knife", "visuals", "misc", "cases" } do
		local aC = aw[aB]
		if aC and aC.unload then
			pcall(aC.unload)
		end
	end
	ap.stop()
	if al and al.Unload then
		pcall(function()
			al:Unload()
		end)
	end
end

ay = ab.Heartbeat:Connect(function(aA)
	LPH_ATTRIBUTES(VM(NONE))
	aw.Camera = workspace.CurrentCamera
	ap.track()
	if aw.combat and aw.combat.step then
		aw.combat.step(aA)
	end
	if aw.knife and aw.knife.step then
		aw.knife.step(aA)
	end
	if aw.visuals and aw.visuals.step then
		aw.visuals.step(aA)
	end
	if aw.misc and aw.misc.step then
		aw.misc.step(aA)
	end
	if aw.cases and aw.cases.step then
		aw.cases.step(aA)
	end
end)

ab:BindToRenderStep("vault_ss", Enum.RenderPriority.Last.Value + 1, function()
	LPH_ATTRIBUTES(VM(NONE))
	if aw.visuals and aw.visuals.renderStep then
		aw.visuals.renderStep()
	end
	if aw.combat and aw.combat.renderStep then
		aw.combat.renderStep()
	end
end)

ah:OnUnload(az)
getgenv().VaultSS_Debug = { ctx = aw, util = ap }
getgenv().VaultSS_Unload = function()
	pcall(function()
		ah:Unload()
	end)
	az()
end
if ah and ah.KeybindFrame then
	ah.KeybindFrame.Visible = am.tv("ShowKeybindList", true)
end
ah:Notify("Shotgun Schizoid loaded.")
