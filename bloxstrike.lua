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

local u
local v

if getgenv().SensoryESP_Unload then
    pcall(getgenv().SensoryESP_Unload)
end

local w = l:FindFirstChild("SensoryESP_Chams")
if w then
    pcall(function() w:Destroy() end)
end

local x = g:FindFirstChild("SensoryESP_MeshChams")
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

z(g)

for B, C in ipairs(m:GetPlayers()) do
    A(C.Character)
end

local function B()
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
    local S = Q:FindFirstChild(R)
    if S then return S.Position end

    
    if R == "Head" then
        S = Q:FindFirstChild("Head")
    elseif R == "UpperTorso" then
        S = Q:FindFirstChild("Torso")
    elseif R == "LowerTorso" then
        S = Q:FindFirstChild("Torso")
        if S then return (S.CFrame * CFrame.new(0, -1.2, 0)).Position end
    elseif R == "LeftUpperArm" then
        S = Q:FindFirstChild("Left Arm") or Q:FindFirstChild("LeftArm")
    elseif R == "LeftLowerArm" then
        S = Q:FindFirstChild("Left Arm") or Q:FindFirstChild("LeftArm")
        if S then return (S.CFrame * CFrame.new(0, -0.8, 0)).Position end
    elseif R == "LeftHand" then
        S = Q:FindFirstChild("Left Arm") or Q:FindFirstChild("LeftArm")
        if S then return (S.CFrame * CFrame.new(0, -1.5, 0)).Position end
    elseif R == "RightUpperArm" then
        S = Q:FindFirstChild("Right Arm") or Q:FindFirstChild("RightArm")
    elseif R == "RightLowerArm" then
        S = Q:FindFirstChild("Right Arm") or Q:FindFirstChild("RightArm")
        if S then return (S.CFrame * CFrame.new(0, -0.8, 0)).Position end
    elseif R == "RightHand" then
        S = Q:FindFirstChild("Right Arm") or Q:FindFirstChild("RightArm")
        if S then return (S.CFrame * CFrame.new(0, -1.5, 0)).Position end
    elseif R == "LeftUpperLeg" then
        S = Q:FindFirstChild("Left Leg") or Q:FindFirstChild("LeftLeg")
    elseif R == "LeftLowerLeg" then
        S = Q:FindFirstChild("Left Leg") or Q:FindFirstChild("LeftLeg")
        if S then return (S.CFrame * CFrame.new(0, -0.8, 0)).Position end
    elseif R == "LeftFoot" then
        S = Q:FindFirstChild("Left Leg") or Q:FindFirstChild("LeftLeg")
        if S then return (S.CFrame * CFrame.new(0, -1.5, 0)).Position end
    elseif R == "RightUpperLeg" then
        S = Q:FindFirstChild("Right Leg") or Q:FindFirstChild("RightLeg")
    elseif R == "RightLowerLeg" then
        S = Q:FindFirstChild("Right Leg") or Q:FindFirstChild("RightLeg")
        if S then return (S.CFrame * CFrame.new(0, -0.8, 0)).Position end
    elseif R == "RightFoot" then
        S = Q:FindFirstChild("Right Leg") or Q:FindFirstChild("RightLeg")
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
        writefile(U .. ".ttf.json", h:JSONEncode(Y))
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
            X = g
        elseif X == game and Z == "Players" then
            X = e
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
    Y.Parent = q
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
    aj.Parent = q
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
    ak.Parent = q
    X.ArrowOutline = ak

    local function al()
        local am = Instance.new("TextLabel")
        am.BackgroundTransparency = 1
        am.Size = UDim2.new(0, 150, 0, 12)
        am.TextStrokeTransparency = 1
        am.ZIndex = 110
        am.TextColor3 = Color3.fromRGB(255, 255, 255)
        am.Visible = false
        am.Parent = q
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

local function ac(ad)
    if not ad then
        return nil
    end
    local ae = ad:GetAttribute("Health")
    if type(ae) ~= "number" then
        return nil
    end
    local af = ad:GetAttribute("MaxHealth")
    if type(af) ~= "number" or af <= 0 then
        af = 100
    end
    return ae, af
end


local function ad(ae, af, ag, ah, ai)
    local aj, ak = ac(ae)
    if aj then
        return aj, ak
    end
    if ag == "Average" then
        local al, am, an = 0, 0, 0
        for W, X in ipairs(ae:GetChildren()) do
            if X:IsA("BasePart") then
                local Y, Z = ab(X)
                if Y then
                    al = al + Y
                    am = am + Z
                    an = an + 1
                end
            end
        end
        if an > 0 then return al / an, am / an end
    elseif ag == "Part" then
        local al, am = ab(ae:FindFirstChild(ah))
        if al then return al, am end
    end

    
    if ai then
        return ai.Health, 100
    end
    return 100, 100
end

local ae = function(ae, af, ag, ah, ai, aj, ak, al,
                                               am,
                                               an, W, X)
    LPH_ATTRIBUTES(VM(NONE))
    local Y = {}
    local function Z(_)
        local ao = Y[_]
        if ao ~= nil then return ao end
        local ap = _:split(".")
        local aq = an
        local ar = E

        local as = true
        for at, au in ipairs(ap) do
            if type(aq) == "table" and aq[au] ~= nil then
                aq = aq[au]
            else
                as = false
                break
            end
        end

        if as then
            Y[_] = aq
            return aq
        end

        local at = ar
        for au, av in ipairs(ap) do
            at = at[av]
        end
        Y[_] = at
        return at
    end

    local ao = tick()
    local ap = not al and aj:FindFirstChild("Humanoid") or nil

    
    local aq = Z("MaxDistance")
    if aq and aq > 0 and ai and ai > aq then
        ae.Container.Visible = false
        if ae.Highlight then ae.Highlight:Destroy() ae.Highlight = nil end
        if ae.MeshShell then ae.MeshShell:Destroy() ae.MeshShell = nil ae.MeshHighlight = nil end
        if ae.Adornments then for ar, as in pairs(ae.Adornments) do as.Visible = false end end
        if ae.ArrowInner then
            ae.ArrowInner.Visible = false
            ae.ArrowOutline.Visible = false
            ae.ArrowName.Visible = false
            ae.ArrowDist.Visible = false
        end
        if ae.Bones then for ar, as in ipairs(ae.Bones) do as.Visible = false end end
        if ae.BoneOutlines then for ar, as in ipairs(ae.BoneOutlines) do as.Visible = false end end
        return
    end

    
    local ar = X and X.Alive == false
    local as = Z("Chams.Enabled")
    if as and not ar then
        local at = Z("Chams.Type")
        if at == "Highlight" and (aj:IsA("Model") or aj:IsA("BasePart")) then
            
            if ae.MeshShell then
                ae.MeshShell:Destroy()
                ae.MeshShell = nil
                ae.MeshHighlight = nil
            end
            if not ae.Highlight then
                ae.Highlight = Instance.new("Highlight")
            end
            local au = ae.Highlight
            au.Parent = o
            au.Adornee = aj
            au.FillColor = Z("Chams.Highlight.FillColor")
            au.FillTransparency = Z("Chams.Highlight.FillTransparency")
            au.OutlineColor = Z("Chams.Highlight.OutlineColor")
            au.OutlineTransparency = Z("Chams.Highlight.OutlineTransparency")
            au.DepthMode = Z("Chams.Highlight.VisibleCheck") and Enum.HighlightDepthMode.Occluded or
                Enum.HighlightDepthMode.AlwaysOnTop
            au.Enabled = true

            
            if ae.Adornments then
                for av, _ in pairs(ae.Adornments) do _.Visible = false end
            end
        elseif at == "Adornment" then
            if ae.Highlight then
                ae.Highlight:Destroy()
                ae.Highlight = nil
            end
            
            if ae.MeshShell then
                ae.MeshShell:Destroy()
                ae.MeshShell = nil
                ae.MeshHighlight = nil
            end

            local au = aj:IsA("Model") and aj:GetChildren() or { aj }
            local av = 0

            local _ = Z("Chams.Adornment.VisibleCheck")
            local aw = Z("VisibilityCheckRate") or 0.1
            local ax = ao
            local ay = ae.LastVisCheck or 0
            local az = (ax - ay) > aw

            if _ and az then
                ae.LastVisCheck = ax
                local aA = { l }
                if i.Character then table.insert(aA, i.Character) end
                if aj:IsA("Model") then
                    for aB, aC in ipairs(aj:GetDescendants()) do table.insert(aA, aC) end
                else
                    table.insert(aA, aj)
                end

                local aB = aj:IsA("Model") and
                    (aj.PrimaryPart or aj:FindFirstChild("HumanoidRootPart") or aj:FindFirstChildWhichIsA("BasePart")) or
                    aj
                if aB and aB:IsA("BasePart") then
                    local aC = j:GetPartsObscuringTarget({ aB.Position }, aA)
                    ae.CachedModelVisible = (#aC == 0)
                end
            end

            local aA = Z("Chams.Adornment.Color")
            local aB = Z("Chams.Adornment.VisibleColor")
            local aC = (_ and ae.CachedModelVisible) and aB or aA

            for aD, aE in ipairs(au) do
                if aE:IsA("BasePart") and aE.Name ~= "HumanoidRootPart" then
                    av = av + 1
                    local aF = ae.Adornments[av]
                    if not aF then
                        aF = Instance.new("BoxHandleAdornment")
                        aF.Name = "Cham"
                        aF.Parent = o
                        ae.Adornments[av] = aF
                    end

                    aF.Adornee = aE
                    aF.Size = aE.Size
                    aF.Color3 = aC
                    aF.Transparency = Z("Chams.Adornment.Transparency")
                    aF.AlwaysOnTop = Z("Chams.Adornment.AlwaysOnTop")
                    aF.ZIndex = 10
                    aF.Visible = true
                end
            end
            
            for aD = av + 1, #ae.Adornments do
                ae.Adornments[aD].Visible = false
            end
        elseif at == "MeshChams" then
            
            
            local au = e:GetPlayerFromCharacter(aj)
            if not au then
                if ae.MeshShell then
                    ae.MeshShell:Destroy()
                    ae.MeshShell = nil
                    ae.MeshHighlight = nil
                end
            else
                
                if ae.Highlight then
                    ae.Highlight:Destroy()
                    ae.Highlight = nil
                end
                if ae.Adornments then
                    for av, aw in pairs(ae.Adornments) do aw.Visible = false end
                end

                
                if not ae.MeshShell or not ae.MeshShell.Parent then
                    if ae.MeshShell then
                        ae.MeshShell:Destroy()
                        ae.MeshShell = nil
                        ae.MeshHighlight = nil
                    end

                    A(aj)

                    local av      = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }
                    local aw     = {
                        "Head", "UpperTorso", "LowerTorso",
                        "LeftUpperArm", "LeftLowerArm", "LeftHand",
                        "RightUpperArm", "RightLowerArm", "RightHand",
                        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
                        "RightUpperLeg", "RightLowerLeg", "RightFoot",
                    }
                    local ax = aj:FindFirstChild("Humanoid")
                    local ay        = ax and (ax.RigType == Enum.HumanoidRigType.R15)
                    local az    = ay and aw or av

                    local aA   = Instance.new("Model")
                    aA.Name    = "ChamShells"
                    aA:SetAttribute("SensoryESP_MeshCham", true)
                    aA:SetAttribute("SensoryESP_RunId", t)
                    aA.Parent = aj

                    for aB, aC in ipairs(az) do
                        local aD = aj:FindFirstChild(aC)
                        if aD and aD:IsA("BasePart") then
                            local aE = Instance.new("Part")
                            aE.Name  = "ChamShell_" .. aC
                            aE:SetAttribute("SensoryESP_MeshCham", true)
                            aE:SetAttribute("SensoryESP_RunId", t)
                            aE.Size         = aD.Size * 1.015
                            aE.Transparency = 0.9999999
                            aE.CastShadow   = false
                            aE.CanCollide   = false
                            aE.CanQuery     = false
                            aE.CanTouch     = false
                            aE.Anchored     = false
                            aE.Massless     = true
                            aE.CFrame       = aD.CFrame
                            aE.Parent       = aA

                            local aF         = Instance.new("Weld")
                            aF.Part0         = aE
                            aF.Part1         = aD
                            aF.C0            = CFrame.new()
                            aF.C1            = CFrame.new()
                            aF.Parent        = aE
                        end
                    end

                    
                    local aB = Instance.new("Highlight")
                    aB.Name  = "ChamShellHighlight"
                    aB:SetAttribute("SensoryESP_MeshCham", true)
                    aB:SetAttribute("SensoryESP_RunId", t)
                    aB.Adornee           = aA
                    aB.Parent            = aA
                    ae.MeshShell     = aA
                    ae.MeshHighlight = aB
                end

                
                if ae.MeshHighlight then
                    local av               = ae.MeshHighlight
                    av.FillColor           = Z("Chams.MeshChams.FillColor")
                    av.FillTransparency    = Z("Chams.MeshChams.FillTransparency")
                    av.OutlineColor        = Z("Chams.MeshChams.OutlineColor")
                    av.OutlineTransparency = Z("Chams.MeshChams.OutlineTransparency")
                    av.DepthMode           = Z("Chams.MeshChams.VisibleCheck")
                        and Enum.HighlightDepthMode.Occluded
                        or Enum.HighlightDepthMode.AlwaysOnTop
                    av.Enabled             = true
                end
            end
        end
    else
        
        if ae.Highlight then
            ae.Highlight:Destroy()
            ae.Highlight = nil
        end
        if ae.Adornments then
            for at, au in pairs(ae.Adornments) do au.Visible = false end
        end
        if ae.MeshShell then
            ae.MeshShell:Destroy()
            ae.MeshShell = nil
            ae.MeshHighlight = nil
        end
    end

    local function at(au, av, aw)
        local ax = C[au] or au:FindFirstChildOfClass("UIStroke")
        if not ax then return end
        if av == "None" then
            ax.Enabled = false
        elseif av == "Shadow" then
            ax.Enabled = true
            ax.Thickness = 1
            ax.Color = aw or Color3.fromRGB(0, 0, 0)
        else
            ax.Enabled = true
            ax.Thickness = 1
            ax.Color = aw or Color3.fromRGB(0, 0, 0)
        end
    end

    
    if ae.ArrowInner and Z("OffScreenArrows.Enabled") and aj:IsA("Model") then
        local au = aj.PrimaryPart or aj:FindFirstChild("HumanoidRootPart") or aj:FindFirstChildWhichIsA("BasePart")
        if au then
            local av = j:WorldToViewportPoint(au.Position)
            local aw = j.ViewportSize
            local ax, ay = aw.X / 2, aw.Y / 2
            local az = av.Z > 0 and av.X >= 0 and av.X <= aw.X and av.Y >= 0 and av.Y <= aw.Y
            if not az then
                local aA = Z("OffScreenArrows.OrbitRadius")
                local aB, aC, aD
                if Z("OffScreenArrows.ArrowMode") == "Compass" then
                    
                    local aE = i.Character and (
                        i.Character:FindFirstChild("HumanoidRootPart") or
                        i.Character:FindFirstChild("Torso") or
                        i.Character:FindFirstChildWhichIsA("BasePart")
                    )
                    local aF = aE and aE.Position or j.CFrame.Position
                    local _ = (Vector3.new(au.Position.X, 0, au.Position.Z) - Vector3.new(aF.X, 0, aF.Z)).Unit
                    local aG = aE and aE.CFrame:VectorToObjectSpace(_) or _
                    aB, aC = aG.X, aG.Z
                    aD = math.deg(math.atan2(aG.Z, aG.X)) + 90
                else
                    
                    local aE = (au.Position - j.CFrame.Position).Unit
                    local aF = j.CFrame:VectorToObjectSpace(aE)
                    aB, aC = aF.X, -aF.Y
                    aD = math.deg(math.atan2(-aF.Y, aF.X)) + 90
                end
                local aE = math.sqrt(aB * aB + aC * aC)
                if aE > 0.001 then
                    aB, aC = aB / aE, aC / aE
                else
                    aB, aC = 0, -1
                end
                local aF, aG = ax + aB * aA, ay + aC * aA
                local _ = Z("OffScreenArrows.Size")
                local aH = Z("OffScreenArrows.Color")

                if Z("OffScreenArrows.Outline") then
                    ae.ArrowOutline.TextSize = _ + 2
                    ae.ArrowOutline.TextColor3 = Z("OffScreenArrows.OutlineColor")
                    ae.ArrowOutline.Position = UDim2.new(0, aF - _ - 2, 0, aG - _ - 2)
                    ae.ArrowOutline.Rotation = aD
                    ae.ArrowOutline.Visible = true
                else
                    ae.ArrowOutline.Visible = false
                end

                local aI = K[Z("OffScreenArrows.Font")] or Enum.Font.SourceSans
                ae.ArrowInner.Text = "▲"
                ae.ArrowInner.Font = aI
                ae.ArrowInner.TextSize = _
                ae.ArrowInner.TextColor3 = aH
                ae.ArrowInner.Position = UDim2.new(0, aF - _, 0, aG - _)
                ae.ArrowInner.Size = UDim2.new(0, _ * 2, 0, _ * 2)
                ae.ArrowInner.Rotation = aD
                ae.ArrowInner.Visible = true

                
                local aJ = aG + _ + 4

                if Z("OffScreenArrows.Names.Enabled") and ah and ah ~= "" then
                    local aK = Z("OffScreenArrows.Names.Font")
                    local aL = Z("OffScreenArrows.Names.TextSize")
                    local aM = K[aK] or Enum.Font.Code
                    local aN = M.Loaded[aK]
                    local aO = Z("OffScreenArrows.Names.Side")
                    local aP = Z("OffScreenArrows.Names.Gap") or 4
                    local aQ = Z("OffScreenArrows.Names.Color")
                    local aR = Z("OffScreenArrows.Names.Outline")
                    local aS = Z("OffScreenArrows.Names.OutlineColor")
                    ae.ArrowName.Font = aM
                    if aN then ae.ArrowName.FontFace = aN end
                    ae.ArrowName.TextSize = aL
                    ae.ArrowName.TextColor3 = aQ
                    ae.ArrowName.Text = ah
                    if aO == "Top" then
                        ae.ArrowName.Position = UDim2.new(0, aF - 75, 0, aG - _ - aP - aL)
                    elseif aO == "Left" then
                        ae.ArrowName.Position = UDim2.new(0, aF - _ - aP - 150, 0, aG - 6)
                    elseif aO == "Right" then
                        ae.ArrowName.Position = UDim2.new(0, aF + _ + aP, 0, aG - 6)
                    else
                        ae.ArrowName.Position = UDim2.new(0, aF - 75, 0, aJ)
                        aJ = aJ + aL + 1
                    end
                    at(ae.ArrowName, aR and "Full" or "None", aS or Color3.fromRGB(0, 0, 0))
                    ae.ArrowName.Visible = true
                else
                    ae.ArrowName.Visible = false
                end

                if Z("OffScreenArrows.Distance.Enabled") then
                    local aK = Z("OffScreenArrows.Distance.Font")
                    local aL = Z("OffScreenArrows.Distance.TextSize")
                    local aM = K[aK] or Enum.Font.Code
                    local aN = M.Loaded[aK]
                    local aO = Z("OffScreenArrows.Distance.Side")
                    local aP = Z("OffScreenArrows.Distance.Gap") or 2
                    local aQ = Z("OffScreenArrows.Distance.Color")
                    local aR = Z("OffScreenArrows.Distance.Outline")
                    local aS = Z("OffScreenArrows.Distance.OutlineColor")
                    local aT = Z("Distance.Unit")
                    local aU
                    if aT == "Meters" then
                        aU = math.floor(ai / Z("Distance.StudsPerMeter"))
                    else
                        aU = math.floor(ai)
                    end
                    ae.ArrowDist.Font = aM
                    if aN then ae.ArrowDist.FontFace = aN end
                    ae.ArrowDist.TextSize = aL
                    ae.ArrowDist.TextColor3 = aQ
                    ae.ArrowDist.Text = aU .. Z("Distance.Ending")
                    if aO == "Top" then
                        ae.ArrowDist.Position = UDim2.new(0, aF - 75, 0, aG - _ - aP - aL)
                    elseif aO == "Left" then
                        ae.ArrowDist.Position = UDim2.new(0, aF - _ - aP - 150, 0, aG - 6)
                    elseif aO == "Right" then
                        ae.ArrowDist.Position = UDim2.new(0, aF + _ + aP, 0, aG - 6)
                    else
                        ae.ArrowDist.Position = UDim2.new(0, aF - 75, 0, aJ)
                    end
                    at(ae.ArrowDist, aR and "Full" or "None", aS or Color3.fromRGB(0, 0, 0))
                    ae.ArrowDist.Visible = true
                else
                    ae.ArrowDist.Visible = false
                end
            else
                ae.ArrowInner.Visible = false
                ae.ArrowOutline.Visible = false
                ae.ArrowName.Visible = false
                ae.ArrowDist.Visible = false
            end
        else
            ae.ArrowInner.Visible = false
            ae.ArrowOutline.Visible = false
            ae.ArrowName.Visible = false
            ae.ArrowDist.Visible = false
        end
    else
        if ae.ArrowInner then
            ae.ArrowInner.Visible = false
            ae.ArrowOutline.Visible = false
            ae.ArrowName.Visible = false
            ae.ArrowDist.Visible = false
        end
    end

    if not W or not af or not ag then
        ae.Container.Visible = false
        return
    end

    ae.Container.Visible = true
    ae.Container.ZIndex = al and 1 or 10
    if Z("Names") then
        ae.Text.Text = ah
    end

    local au = Z("TextOutlineStyle")
    
    if Z("TextOutline") == false then au = "None" end
    local av = Z("TextOutlineColor") or Z("Outlines.Color")

    local aw = Z("BoxThickness")
    local ax = Z("Outlines.Thickness")
    local ay = Z("TextSize")
    local az = Z("TextColor")
    local aA = Z("Font")
    local aB = K[aA] or Enum.Font.Code
    local aC = M.Loaded[aA]
    local aD = Z("BoxColor")
    
    ae.Text.TextSize = ay
    ae.Text.TextColor3 = az
    ae.Text.Font = aB
    if aC then
        ae.Text.FontFace = aC
    end
    at(ae.Text, au, av)

    do
        local aE = Z("Distance.Font")
        local aF = K[aE] or Enum.Font.Code
        ae.DistanceText.TextSize = Z("Distance.TextSize") or ay
        ae.DistanceText.TextColor3 = Z("Distance.Color")
        ae.DistanceText.Font = aF
        if M.Loaded[aE] then
            ae.DistanceText.FontFace = M.Loaded[aE]
        end
        at(ae.DistanceText, Z("Distance.OutlineStyle") or au, av)
    end

    do
        local aE = Z("Weapon.Font")
        local aF = K[aE] or Enum.Font.Code
        ae.WeaponText.TextSize = Z("Weapon.TextSize") or ay
        ae.WeaponText.TextColor3 = Z("Weapon.Color")
        ae.WeaponText.Font = aF
        if M.Loaded[aE] then
            ae.WeaponText.FontFace = M.Loaded[aE]
        end
        at(ae.WeaponText, Z("Weapon.OutlineStyle") or au, av)
    end

    local aE, aF = math.floor(af.X), math.floor(af.Y)
    local aG, aH = math.floor(ag.X), math.floor(ag.Y)
    local aI, aJ = math.floor(aE - aG / 2), math.floor(aF - aH / 2)

    
    local aK, aL, aM = 100, 100, 1
    local aN, aO = ac(aj)
    local aP = Z("HealthBar.Source")
    if aN then
        aK, aL = aN, aO
        aM = math.clamp(aK / (aL > 0 and aL or 1), 0, 1)
    elseif aP and aP ~= "Humanoid" then
        aK, aL = ad(aj, ap, aP, Z("HealthBar.Part"), X)
        aM = math.clamp(aK / (aL > 0 and aL or 1), 0, 1)
    elseif X then
        aK = X.Health
        aL = 100
        aM = math.clamp(aK / aL, 0, 1)
    elseif ap then
        aK = ap.Health
        aL = ap.MaxHealth
        aM = math.clamp(aK / (aL > 0 and aL or 1), 0, 1)
    end

    
    local aQ = 0
    local aR = 0
    local aS = 0
    local aT = 0
    if Z("HealthBar.Enabled") and aj:IsA("Model") and (ap or aN) then
        local aU = Z("HealthBar.Position")
        local _ = Z("HealthBar.Width") + 2 + Z("HealthBar.SideGap")
        local aV = Z("Flags.Position") == "Right"
        local aW = (Z("HealthBar.ShowText") and aK < aL) and 20 or 0

        if aU == "Top" then
            aQ = _
        elseif aU == "Bottom" then
            aR = _
        elseif aU == "Left" then
            aS = _ + aW
        elseif aU == "Right" then
            aT = _ + aW
        end
    end

    if ak then
        for aU = 1, 4 do
            ae.Lines[aU].Visible = false
            ae.Outlines[aU].Visible = false
        end
        ae.HealthBarOutline.Visible = false
        ae.HealthText.Visible = false
        ae.WeaponText.Visible = false
        for aU, aV in ipairs(ae.FlagLabels) do aV.Visible = false end

        local aU = Z("Distance.Unit")
        local aV = ai
        if aU == "Meters" then
            aV = math.floor(ai / Z("Distance.StudsPerMeter"))
        else
            aV = math.floor(ai)
        end

        ae.Text.Text = ah .. " " .. aV .. Z("Distance.Ending")
        ae.Text.Position = UDim2.new(0, aE - 50, 0, aF - (ay / 2))
        ae.Text.Visible = Z("Names")
        ae.DistanceText.Visible = false
        return
    end

    
    ae.Lines[1].Position = UDim2.new(0, aI, 0, aJ)
    ae.Lines[1].Size = UDim2.new(0, aG, 0, aw)
    
    ae.Lines[2].Position = UDim2.new(0, aI, 0, aJ + aH)
    ae.Lines[2].Size = UDim2.new(0, aG + aw, 0, aw)
    
    ae.Lines[3].Position = UDim2.new(0, aI, 0, aJ)
    ae.Lines[3].Size = UDim2.new(0, aw, 0, aH)
    
    ae.Lines[4].Position = UDim2.new(0, aI + aG, 0, aJ)
    ae.Lines[4].Size = UDim2.new(0, aw, 0, aH + aw)

    local aU = Z("Boxes")
    local aV = Z("BoxType") or "Normal"
    local aW = aV == "Corner"

    local _ = Z("Outlines.Style")
    local aX = Z("Outlines.Color")
    local aY = Z("Outlines.Thickness")
    
    if Z("Outlines.Enabled") == false then _ = "None" end
    local aZ = 0
    local a_ = _ ~= "None"

    if aW then
        local a0 = math.max(math.floor(aG * 0.25), aw * 3)
        local a1 = math.max(math.floor(aH * 0.25), aw * 3)

        local a2 = {
            { aI,                        aJ,                         a0, aw },
            { aI,                        aJ,                         aw,           a1 },
            { aI + aG - a0 + aw, aJ,                         a0, aw },
            { aI + aG,                   aJ,                         aw,           a1 },
            { aI,                        aJ + aH,                    a0, aw },
            { aI,                        aJ + aH - a1 + aw, aw,           a1 },
            { aI + aG - a0 + aw, aJ + aH,                    a0, aw },
            { aI + aG,                   aJ + aH - a1 + aw, aw,           a1 },
        }

        for a3 = 1, 8 do
            local a4 = a2[a3]
            ae.CornerLines[a3].Position = UDim2.new(0, a4[1], 0, a4[2])
            ae.CornerLines[a3].Size = UDim2.new(0, a4[3], 0, a4[4])
        end
    end

    for a0 = 1, 4 do
        ae.Lines[a0].Visible = aU and not aW
        ae.Outlines[a0].Visible = aU and a_ and not aW

        ae.Outlines[a0].Position = UDim2.new(0, -aY, 0, -aY)
        ae.Outlines[a0].Size = UDim2.new(1, aY * 2, 1, aY * 2)
        ae.Outlines[a0].BackgroundTransparency = aZ
        ae.Lines[a0].BackgroundColor3 = aD
        ae.Outlines[a0].BackgroundColor3 = aX
    end

    for a0 = 1, 8 do
        ae.CornerLines[a0].Visible = aU and aW
        ae.CornerOutlines[a0].Visible = aU and a_ and aW

        ae.CornerOutlines[a0].Position = UDim2.new(0, -aY, 0, -aY)
        ae.CornerOutlines[a0].Size = UDim2.new(1, aY * 2, 1, aY * 2)
        ae.CornerOutlines[a0].BackgroundTransparency = aZ
        ae.CornerLines[a0].BackgroundColor3 = aD
        ae.CornerOutlines[a0].BackgroundColor3 = aX
    end

    
    local a0 = ae.BoxFill
    local a1 = ae.BoxFillGradient
    if Z("BoxFill.Enabled") and aU then
        a0.Visible = true
        a0.Position = UDim2.new(0, aI, 0, aJ)
        a0.Size = UDim2.new(0, aG, 0, aH)
        a0.BackgroundTransparency = Z("BoxFill.Transparency")

        if Z("BoxFill.Gradient.Enabled") then
            a1.Enabled = true
            local a2 = Z("BoxFill.Gradient.Color1")
            local a3 = Z("BoxFill.Gradient.Color2")
            local a4 = Z("BoxFill.Gradient.Color3")
            a1.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, a2),
                ColorSequenceKeypoint.new(0.5, a3),
                ColorSequenceKeypoint.new(1, a4)
            })

            local a5 = Z("BoxFill.Gradient.Rotation")
            if Z("BoxFill.Gradient.Animated") then
                local a6 = Z("BoxFill.Gradient.Speed")
                local a7 = Z("BoxFill.Gradient.Direction") == "Left" and -1 or 1
                a5 = (a5 + (ao * a6 * a7)) % 360
            end
            a1.Rotation = a5
            a0.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            a1.Enabled = false
            a0.BackgroundColor3 = Z("BoxFill.Color")
        end
    else
        a0.Visible = false
    end

    local a2 = aJ - ay - (Z("TextGap") or 0) - aQ
    local a3 = aj:IsA("Model") and e:GetPlayerFromCharacter(aj) or nil
    local a4 = {}
    local a5 = {}

    if Z("TeamIndicator.Enabled") and a3 and u then
        a3 = u.Clients[a3] or u:GetClientFromPlayer(a3)
        if a3.Squad then
            local a6 = Z("TeamIndicator.UseTeamColor") and BrickColor.new(tostring(a3.Squad)).Color or
            Z("TeamIndicator.Color")
            local a7 = a3.Squad
            local a8 = Z("TeamIndicator.Compact") and I(a7) or a7
            local a9 = string.format('<font color="%s">[%s]</font>', J(a6), a8)
            if Z("TeamIndicator.Position") == "Left" then
                table.insert(a4, a9)
            else
                table.insert(a5, a9)
            end
        end
    end

    local a6 = false
    if a3 and u and v and Z("FriendlyIndicator.Enabled") then
        local a7 = u.Clients[a3] or u:GetClientFromPlayer(a3)
        if Z("FriendlyIndicator.CheckTeam") and v.Squad ~= nil and a7.Squad == v.Squad then
            a6 = true
        end
        if not a6 and Z("FriendlyIndicator.CheckFriends") then
            local a8, a9 = pcall(function()
                return i:IsFriendsWith(a3.UserId)
            end)
            if a8 and a9 then
                a6 = true
            end
        end
    end

    if a6 then
        local a7 = string.format('<font color="%s">%s</font>', J(Z("FriendlyIndicator.Color")),
            Z("FriendlyIndicator.Text"))
        if Z("FriendlyIndicator.Position") == "Left" then
            table.insert(a4, a7)
        else
            table.insert(a5, a7)
        end
    end

    local a7 = ah
    if #a4 > 0 then
        a7 = table.concat(a4, " ") .. " " .. a7
    end
    if #a5 > 0 then
        a7 = a7 .. " " .. table.concat(a5, " ")
    end

    if Z("Names") then
        ae.Text.Text = a7
        ae.Text.Position = UDim2.new(0, aE - 50, 0, a2)
        ae.Text.Visible = true
    else
        ae.Text.Visible = false
    end

    local a8 = Z("Distance.Gap") or 0
    local a9 = aJ + aH + a8 + aR
    if Z("Distance.Enabled") then
        ae.DistanceText.Visible = true
        ae.DistanceText.Position = UDim2.new(0, aE - 50, 0, a9)

        local ba = Z("Distance.Unit")
        local bb = ai
        if ba == "Meters" then
            bb = math.floor(ai / Z("Distance.StudsPerMeter"))
        else
            bb = math.floor(ai)
        end
        ae.DistanceText.Text = bb .. Z("Distance.Ending")
        a9 = a9 + (Z("Distance.TextSize") or ay) + (Z("Weapon.Gap") or 0)
    else
        ae.DistanceText.Visible = false
    end

    
    if Z("Weapon.Enabled") then
        local ba = nil

        
        local bb = X and X._inventory
        local bc = X and X._equipped
        if bb and bc then
            local bd = bb[bc]
            if bd then
                local be = bd._lodModel
                if be then
                    ba = tostring(be)
                else
                    local bf = bd._heroModel
                    if bf then
                        ba = tostring(bf)
                    end
                end
            end
        end

        
        if (not ba or ba == "" or ba == "nil") and Z("Weapon.UseToolFallback") then
            local bd = aj:FindFirstChildWhichIsA("Tool")
            if bd then ba = bd.Name end
        end

        
        if not ba or ba == "" or ba == "nil" then
            ba = "None"
        end

        ae.WeaponText.Visible = true
        ae.WeaponText.Text = ba
        ae.WeaponText.Position = UDim2.new(0, aE - 50, 0, a9)
    else
        ae.WeaponText.Visible = false
    end

    
    if Z("HealthBar.Enabled") and aj:IsA("Model") and (ap or aN) then
        
        local ba = Z("HealthBar.Position")
        local bb = (ba == "Top" or ba == "Bottom")
        local bc = Z("HealthBar.Width")
        local bd = Z("HealthBar.SideGap")
        local be = Z("HealthBar.TextFollowBar")

        local bf = Z("HealthBar.Outline.Style")
        
        if Z("HealthBar.Outline.Enabled") == false then bf = "None" end
        ae.HealthBarOutline.Visible = bf ~= "None"
        ae.HealthBarOutline.BackgroundTransparency = 0
        ae.HealthBarOutline.BackgroundColor3 = Z("HealthBar.Outline.Color")
        local bg

        if bb then
            bg = math.floor((aG + 1) * aM)
            ae.HealthBarOutline.Size = UDim2.new(0, aG + 3, 0, bc + 2)

            if ba == "Top" then
                ae.HealthBarOutline.Position = UDim2.new(0, aI - 1, 0,
                    aJ - ax - bd - bc - 1)
            else 
                ae.HealthBarOutline.Position = UDim2.new(0, aI - 1, 0, aJ + aH + ax + bd)
            end

            ae.HealthBarContainer.Size = UDim2.new(0, bg, 0, bc)
            ae.HealthBarContainer.Position = UDim2.new(0, 1, 0, 1)

            ae.HealthBar.Size = UDim2.new(0, aG + 1, 0, bc)
            ae.HealthBar.Position = UDim2.new(0, 0, 0, 0)
        else 
            local bh = math.floor((aH + 1) * aM)
            ae.HealthBarOutline.Size = UDim2.new(0, bc + 2, 0, aH + 3)

            if ba == "Left" then
                ae.HealthBarOutline.Position = UDim2.new(0,
                    aI - ax - bd - bc - 1, 0, aJ - 1)
            else 
                ae.HealthBarOutline.Position = UDim2.new(0, aI + aG + ax + bd, 0, aJ - 1)
            end

            ae.HealthBarContainer.Size = UDim2.new(0, bc, 0, bh)
            ae.HealthBarContainer.Position = UDim2.new(0, 1, 0, (aH + 1) - bh + 1)

            ae.HealthBar.Size = UDim2.new(0, bc, 0, aH + 1)
            ae.HealthBar.Position = UDim2.new(0, 0, 0, -(aH + 1 - bh))
        end

        
        local bh = Z("HealthBar.Gradient.Enabled")
        local bi = Z("HealthBar.ShowText")
        if Z("HealthBar.HideWhenFullHP") and aK >= aL then
            bi = false
        end
        local bj = bi and Z("HealthBar.FollowGradientColorText")
        local bk = Color3.fromHSV(aM * 0.3, 1, 1)

        if bh and not bb then
            ae.HealthGradient.Rotation = 90
            ae.HealthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

            if bj then
                if aM > 0.5 then
                    local bl = (1 - aM) * 2
                    bk = Z("HealthBar.Gradient.Color1"):Lerp(Z("HealthBar.Gradient.Color2"), bl)
                else
                    local bl = (0.5 - aM) * 2
                    bk = Z("HealthBar.Gradient.Color2"):Lerp(Z("HealthBar.Gradient.Color3"), bl)
                end
            end
        else
            ae.HealthBar.BackgroundColor3 = bk
        end

        if bi then
            ae.HealthText.Visible = true
            ae.HealthText.Text = math.floor(aK)
            ae.HealthText.TextSize = Z("HealthBar.TextSize")
            local bl = Z("HealthBar.Font")
            local bm = K[bl] or Enum.Font.Code
            ae.HealthText.Font = bm
            if M.Loaded[bl] then
                ae.HealthText.FontFace = M.Loaded[bl]
            end
            ae.HealthText.TextColor3 = bj and bk or Z("TextColor")
            at(ae.HealthText, bf, av)

            if bb then
                bg = math.floor((aG + 1) * aM)
                local bn = aI + bg - 1
                local bo = ae.HealthBarOutline.Position.Y.Offset

                ae.HealthText.TextXAlignment = Enum.TextXAlignment.Center
                ae.HealthText.Size = UDim2.new(0, 0, 0, 0)

                if be then
                    ae.HealthText.Position = UDim2.new(0, bn, 0, bo + (bc / 2) + 1)
                else
                    ae.HealthText.Position = UDim2.new(0, aI + aG, 0, bo + (bc / 2) + 1)
                end
            else
                local bn = math.floor((aH + 1) * aM)
                local bo = ae.HealthBarOutline.Position.X.Offset
                local bp = aJ + (aH + 1) - bn

                ae.HealthText.TextXAlignment = ba == "Left" and Enum.TextXAlignment.Right or
                    Enum.TextXAlignment.Left
                ae.HealthText.Size = UDim2.new(0, 0, 0, 0)

                local bq = ba == "Left" and (bo - 2) or (bo + bc + 4)
                local br = be and bp or aJ
                ae.HealthText.Position = UDim2.new(0, bq, 0, br)
            end
        else
            ae.HealthText.Visible = false
        end
    else
        ae.HealthBarOutline.Visible = false
        ae.HealthText.Visible = false
    end

    
    for ba, bb in ipairs(ae.FlagLabels) do bb.Visible = false end
    if Z("Flags.Enabled") and aj:IsA("Model") and not am and ap then
            local ba = ap:GetState()
            local bb = ap.MoveDirection.Magnitude > 0
            local bc = (ba == Enum.HumanoidStateType.Jumping or ba == Enum.HumanoidStateType.FallingDown or ba == Enum.HumanoidStateType.Freefall)
            local bd = ba == Enum.HumanoidStateType.Swimming
            local be = Z("Flags.Options.Moving")
            local bf = Z("Flags.Options.Jumping")
            local bg = Z("Flags.Options.Swimming")
            local bh = Z("Flags.Options.Idle")
            local bi = Z("Flags.Colors.Moving")
            local bj = Z("Flags.Colors.Jumping")
            local bk = Z("Flags.Colors.Swimming")
            local bl = Z("Flags.Colors.Idle")
            local bm = Z("Flags.Font")
            local bn = Z("Flags.TextSize")
            local bo = Z("Flags.TextGap")
            local bp = Z("Flags.Gap") or 2
            local bq = Z("Flags.SideGap")
            local br = Z("Flags.Position")
            local bs = {}

            if bb and bc and be and bf then
                table.insert(bs, { text = "Moving & Jumping", color = bi })
            elseif bc and bf then
                table.insert(bs, { text = "Jumping", color = bj })
            elseif bb and be then
                table.insert(bs, { text = "Moving", color = bi })
            elseif bd and bg then
                table.insert(bs, { text = "Swimming", color = bk })
            elseif bh then
                table.insert(bs, { text = "Idle", color = bl })
            end

            local bt = br == "Right"
            local bu = bt and (aI + aG + bq + aT) or
                (aI - 100 - bq - aS)
            local bv = aJ - bp

            if bm == "Smallest Pixel-7" then
                bv = bv - 3
            end

            local bw = K[bm] or Enum.Font.Code
            local bx = M.Loaded[bm]
            local by = Z("Flags.OutlineStyle") or au

            for bz, bA in ipairs(bs) do
                local bB = ae.FlagLabels[bz]
                if bB then
                    bB.Visible = true
                    bB.Text = bA.text
                    bB.TextColor3 = bA.color
                    bB.Font = bw
                    if bx then
                        bB.FontFace = bx
                    end
                    bB.TextSize = bn
                    bB.TextXAlignment = bt and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right
                    bB.Position = UDim2.new(0, bu, 0,
                        bv + (bz - 1) * (bn + bo))
                    at(bB, by, av)
                end
        end
    end

    
    if Z("Skeleton.Enabled") and aj:IsA("Model") then
        local ba = Z("Skeleton.Outline")
        local bb = Z("Skeleton.Color")
        local bc = Z("Skeleton.OutlineColor")

        local bd = {}
        for be, bf in ipairs(O) do
            for bg, bh in ipairs(bf) do
                if bd[bh] == nil then
                    local bi = P(aj, bh)
                    local bj, bk = bi and k(j, bi)
                    bd[bh] = (bi and bk) and Vector2.new(bj.X, bj.Y) or false
                end
            end
        end

        for be, bf in ipairs(O) do
            local bg = bd[bf[1] ]
            local bh = bd[bf[2] ]

            if bg and bh then
                if ba then
                    D(ae.BoneOutlines[be], bg, bh, 3, bc)
                else
                    ae.BoneOutlines[be].Visible = false
                end

                D(ae.Bones[be], bg, bh, 1, bb)
            else
                ae.Bones[be].Visible = false
                ae.BoneOutlines[be].Visible = false
            end
        end
    else
        if ae.Bones then
            for ba, bb in ipairs(ae.Bones) do bb.Visible = false end
            for ba, bb in ipairs(ae.BoneOutlines) do bb.Visible = false end
        end
    end
end



local af = function(af)
    LPH_ATTRIBUTES(VM(NONE))
    local ag
    if af:IsA("Model") then
        ag = af:FindFirstChild("HumanoidRootPart") or af:FindFirstChild("Torso") or
            af.PrimaryPart or af:FindFirstChildWhichIsA("BasePart")
    elseif af:IsA("BasePart") then
        ag = af
    end

    if not ag then return false, nil, nil end

    local ah, ai = j:WorldToViewportPoint(ag.Position)
    if not ai then return false, nil, nil end

    if not E.DynamicBoxes then
        
        local aj = af:IsA("Model") and af:FindFirstChild("Humanoid")
        if aj then
            
            local ak = aj.RigType == Enum.HumanoidRigType.R6
            local al = ak and 2.8 or 3.0
            local am = ak and 3.0 or 3.5

            local an = ag.Position + Vector3.new(0, al, 0)
            local ao = ag.Position - Vector3.new(0, am, 0)
            local ap = j:WorldToViewportPoint(an)
            local aq = j:WorldToViewportPoint(ao)
            local ar = math.abs(ap.Y - aq.Y)
            return true, Vector2.new(ah.X, (ap.Y + aq.Y) / 2), Vector2.new(ar * 0.65, ar)
        end

        
        local ak, al
        if af:IsA("Model") then
            ak, al = af:GetBoundingBox()
        else
            ak, al = af.CFrame, af.Size
        end

        local am, an, ao, ap = math.huge, math.huge, -math.huge, -math.huge
        local aq = {
            ak * Vector3.new(al.X / 2, al.Y / 2, al.Z / 2),
            ak * Vector3.new(-al.X / 2, al.Y / 2, al.Z / 2),
            ak * Vector3.new(al.X / 2, -al.Y / 2, al.Z / 2),
            ak * Vector3.new(-al.X / 2, -al.Y / 2, al.Z / 2),
            ak * Vector3.new(al.X / 2, al.Y / 2, -al.Z / 2),
            ak * Vector3.new(-al.X / 2, al.Y / 2, -al.Z / 2),
            ak * Vector3.new(al.X / 2, -al.Y / 2, -al.Z / 2),
            ak * Vector3.new(-al.X / 2, -al.Y / 2, -al.Z / 2),
        }
        for ar, as in ipairs(aq) do
            local at = j:WorldToViewportPoint(as)
            if at.X < am then am = at.X end
            if at.X > ao then ao = at.X end
            if at.Y < an then an = at.Y end
            if at.Y > ap then ap = at.Y end
        end
        return true, Vector2.new((am + ao) / 2, (an + ap) / 2), Vector2.new(ao - am, ap - an)
    else
        
        local aj, ak, al, am = math.huge, math.huge, -math.huge, -math.huge
        local an = {}
        if af:IsA("Model") then
            local ao = E.DynamicBoxesIncludeAll
            for ap, aq in ipairs(af:GetChildren()) do
                if aq:IsA("BasePart") and (ao or (aq.Name ~= "HumanoidRootPart" and aq.Transparency ~= 1)) then
                    table.insert(an, aq)
                end
            end
        else
            table.insert(an, af)
        end

        if #an == 0 then return false, nil, nil end

        if E.DynamicBoxesCheap then
            for ao, ap in ipairs(an) do
                local aq, ar = ap.CFrame, ap.Size
                local as = ar / 2
                local at = aq * Vector3.new(as.X, as.Y, as.Z)
                local au = aq * Vector3.new(-as.X, -as.Y, -as.Z)
                local av = j:WorldToViewportPoint(at)
                local aw = j:WorldToViewportPoint(au)
                if av.X < aj then aj = av.X end
                if av.X > al then al = av.X end
                if av.Y < ak then ak = av.Y end
                if av.Y > am then am = av.Y end
                if aw.X < aj then aj = aw.X end
                if aw.X > al then al = aw.X end
                if aw.Y < ak then ak = aw.Y end
                if aw.Y > am then am = aw.Y end
            end
        else
            for ao, ap in ipairs(an) do
                local aq, ar = ap.CFrame, ap.Size
                local as = {
                    aq * Vector3.new(ar.X / 2, ar.Y / 2, ar.Z / 2),
                    aq * Vector3.new(-ar.X / 2, ar.Y / 2, ar.Z / 2),
                    aq * Vector3.new(ar.X / 2, -ar.Y / 2, ar.Z / 2),
                    aq * Vector3.new(-ar.X / 2, -ar.Y / 2, ar.Z / 2),
                    aq * Vector3.new(ar.X / 2, ar.Y / 2, -ar.Z / 2),
                    aq * Vector3.new(-ar.X / 2, ar.Y / 2, -ar.Z / 2),
                    aq * Vector3.new(ar.X / 2, -ar.Y / 2, -ar.Z / 2),
                    aq * Vector3.new(-ar.X / 2, -ar.Y / 2, -ar.Z / 2),
                }
                for at, au in ipairs(as) do
                    local av = j:WorldToViewportPoint(au)
                    if av.X < aj then aj = av.X end
                    if av.X > al then al = av.X end
                    if av.Y < ak then ak = av.Y end
                    if av.Y > am then am = av.Y end
                end
            end
        end
        return true, Vector2.new((aj + al) / 2, (ak + am) / 2), Vector2.new(al - aj, am - ak)
    end
end



local function ag(ah, ai)
    if type(ai) ~= "table" or #ai == 0 then return true end
    if #ai == 1 and ai[1] == "" then return true end
    for aj, ak in ipairs(ai) do
        local al = false
        for am, an in ipairs(ah:GetChildren()) do
            if an.Name == ak then
                al = true
                break
            end
        end
        if not al then return false end
    end
    return true
end

local function ah(ai, aj)
    if type(aj) ~= "table" or #aj == 0 then return true end
    if #aj == 1 and aj[1] == "" then return true end
    for ak, al in ipairs(aj) do
        if ai.Name == al then
            return true
        end
    end
    return false
end

local function ai(aj, ak)
    if not ak or #ak == 0 then return false end
    local al = aj
    while al and al ~= game do
        for am, an in ipairs(ak) do
            if an ~= "" and al.Name == an then
                return true
            end
        end
        al = al.Parent
    end
    return false
end

local aj = function()
    LPH_ATTRIBUTES(VM(NONE))
    local aj = {}

    

    











if u and u.GetClients then
        for ak, al in pairs(u:GetClients()) do
            local am = al.Actor
            if am then
                local an = am.Character
                if an and an.Parent and an:IsA("Model") then
                    if am and am.Health > 0 then
                        local ao = am.Owner
                        if not E.Filter or E.Filter(an, ao, al) then
                            aj[an] = {
                                name = (ao and ao.Name) or am.OwnerName or an.Name,
                                Cheap = false,
                                NonHuman = false,
                                NoStatus = false,
                                Actor = am,
                                Config = {}
                            }
                        end
                    end
                end
            end
        end
    end

    for ak, al in pairs(E.Directories) do
        local am = nil
        if type(al) == "table" and al.DisplayName and al.DisplayName ~= "" then
            am = al.DisplayName
        elseif type(ak) == "string" then
            am = ak
        end

        if type(al) == "string" then
            local an = U(al)
            if an then
                aj[an] = { name = am or an.Name, Cheap = false }
            end
        elseif type(al) == "table" then
            local an = al.Path
            if not an then continue end
            local ao = U(an)
            if not ao then continue end

            local ap = al.Cheap or false
            local aq = al.NonHuman or false
            local ar = al.NoStatus or false
            local as = al.Config or {}
            local at = al.Recursive or false

            if al.Multiple then
                local au = at and ao:GetDescendants() or ao:GetChildren()
                for av, aw in ipairs(au) do
                    if (aw:IsA("Model") or aw:IsA("BasePart")) then
                        
                        local ax = false
                        local ay = aw.Parent
                        while ay and ay ~= ao and ay ~= game do
                            if aj[ay] then
                                ax = true
                                break
                            end
                            ay = ay.Parent
                        end

                        if not ax and ah(aw, al.Names) and ag(aw, al.Contains) and not ai(aw, al.BlockNames) then
                            local az = aw:FindFirstChild("Humanoid")
                            if aq or (not az or az.Health > 0) then
                                local aA = (am and am ~= "") and am or aw.Name
                                aj[aw] = {
                                    name = aA,
                                    Cheap = ap,
                                    NonHuman = aq,
                                    NoStatus = ar,
                                    Config = as
                                }
                            end
                        end
                    end
                end
            else
                if ah(ao, al.Names) and ag(ao, al.Contains) and not ai(ao, al.BlockNames) then
                    local au = ao:FindFirstChild("Humanoid")
                    if aq or (not au or au.Health > 0) then
                        local av = (am and am ~= "") and am or ao.Name
                        aj[ao] = {
                            name = av,
                            Cheap = ap,
                            NonHuman = aq,
                            NoStatus = ar,
                            Config = as
                        }
                    end
                end
            end
        end
    end

    for ak, al in pairs(aj) do
        if not T[ak] then
            T[ak] = {
                espObj = aa(al.name),
                name = al.name,
                Cheap = al.Cheap,
                NonHuman = al.NonHuman,
                NoStatus = al.NoStatus,
                Actor = al.Actor,
                Config = al.Config
            }
        else
            T[ak].name = al.name
            T[ak].Cheap = al.Cheap
            T[ak].NonHuman = al.NonHuman
            T[ak].NoStatus = al.NoStatus
            T[ak].Config = al.Config
        end
    end

    for ak, al in pairs(T) do
        if not aj[ak] or not ak.Parent then
            al.espObj:Destroy()
            T[ak] = nil
        end
    end
end

local ak = 0
local al = 0
local am = 0
local function an()
    if setthreadidentity then
        pcall(setthreadidentity, 8)
    elseif setthreadcontext then
        pcall(setthreadcontext, 8)
    end
    j = g.CurrentCamera or j
    if not E.Enabled then
        for ao, ap in pairs(T) do
            if ap.espObj then
                local aq = F(ap.Config or {})
                aq.Chams = aq.Chams or {}
                aq.Chams.Enabled = false
                ae(ap.espObj, nil, nil, "", 0, ao, ap.Cheap, ap.NonHuman, ap.NoStatus, aq,
                    false, ap.Actor)
            end
        end
        return
    end

    local ao = tick()

    if N and ao - am > 5 then
        am = ao
        S()
    end

    if E.LimitFPS and E.LimitFPS > 0 then
        if ao - al < (1 / E.LimitFPS) then return end
        al = ao
    end

    if ao - ak > 1 then
        ak = ao
        aj()
    end

    for ap, aq in pairs(T) do
        if not ap or not ap.Parent then
            aq.espObj:Destroy()
            T[ap] = nil
            continue
        end

        local ar = not aq.NonHuman and ap:FindFirstChild("Humanoid") or nil
        if ar and ar.Health <= 0 then
            aq.espObj:Destroy()
            T[ap] = nil
            continue
        end

        local as = ap:IsA("Model") and
            (ap.PrimaryPart or ap:FindFirstChild("HumanoidRootPart") or ap:FindFirstChildWhichIsA("BasePart")) or
            (ap:IsA("BasePart") and ap)

        if as then
            local at, au, av = af(ap)
            local aw = (j.CFrame.Position - as.Position).Magnitude
            ae(aq.espObj, au, av, aq.name, aw, ap, aq.Cheap, aq.NonHuman,
                aq.NoStatus, aq.Config, at, aq.Actor)
        else
            ae(aq.espObj, nil, nil, aq.name, 0, ap, aq.Cheap, aq.NonHuman, aq.NoStatus, aq
                .Config, false, aq.Actor)
        end
    end
end

function n:Unload()
    for ao, ap in pairs(T) do
        if ap.espObj then
            ap.espObj:Destroy()
        end
        T[ao] = nil
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

    z(g)
    for ao, ap in ipairs(m:GetPlayers()) do
        A(ap.Character)
    end

    getgenv().SensoryESP_UI = nil
end

function n:Load(ao)
    self:Unload()

    E = G(F(H), ao or {})
    B()
    t = h:GenerateGUID(false)
    ak = 0
    al = 0

    r = e.PlayerRemoving:Connect(function(ap)
        for aq, ar in pairs(T) do
            if e:GetPlayerFromCharacter(aq) == ap then
                ar.espObj:Destroy()
                T[aq] = nil
            end
        end
    end)

    s = c.InputBegan:Connect(function(ap, aq)
        if not aq and E.Keybind.Enabled and ap.KeyCode == E.Keybind.Key then
            E.Enabled = not E.Enabled
        end
    end)

    getgenv().SensoryESP_Loop = d.RenderStepped:Connect(an)
    aj()
    return self
end

function n:GetConfig()
    return E
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
local ab = game:GetService("HttpService")
local ac = game:GetService("Players")

local ad = {
	head = { "Head" },
	["upper torso"] = { "UpperTorso", "Torso" },
	["lower torso"] = { "LowerTorso", "Torso" },
	["left upper arm"] = { "LeftUpperArm", "Left Arm" },
	["left lower arm"] = { "LeftLowerArm", "Left Arm" },
	["left hand"] = { "LeftHand", "Left Arm" },
	["right upper arm"] = { "RightUpperArm", "Right Arm" },
	["right lower arm"] = { "RightLowerArm", "Right Arm" },
	["right hand"] = { "RightHand", "Right Arm" },
	["left upper leg"] = { "LeftUpperLeg", "Left Leg" },
	["left lower leg"] = { "LeftLowerLeg", "Left Leg" },
	["left foot"] = { "LeftFoot", "Left Leg" },
	["right upper leg"] = { "RightUpperLeg", "Right Leg" },
	["right lower leg"] = { "RightLowerLeg", "Right Leg" },
	["right foot"] = { "RightFoot", "Right Leg" },
}

local ae = {
	"head",
	"upper torso",
	"lower torso",
	"left upper arm",
	"left lower arm",
	"left hand",
	"right upper arm",
	"right lower arm",
	"right hand",
	"left upper leg",
	"left lower leg",
	"left foot",
	"right upper leg",
	"right lower leg",
	"right foot",
}

local af = setmetatable({}, { __mode = "k" })

local function ag(ah)
	return type(ah) == "number" and ah == ah and math.abs(ah) < math.huge
end

local function ah(ai)
	if type(ai) == "string" then
		return { ai }
	end
	if type(ai) ~= "table" then
		return {}
	end
	if ai[1] ~= nil then
		return ai
	end
	local aj = {}
	for ak, al in ai do
		if al then
			aj[#aj + 1] = ak
		end
	end
	return aj
end



local function ai(aj)
	if not aj then
		return nil
	end
	if aj:IsA("Model") then
		return aj
	end
	local ak = workspace:FindFirstChild("Characters")
	local al = ak and (ak:FindFirstChild(aj.Name) or ak:FindFirstChild(aj.DisplayName))
	if al and al:IsA("Model") and al:FindFirstChild("Head") then
		return al
	end
	local am = aj.Character
	if am and am.Parent then
		return am
	end
	return al
end


local function aj(ak)
	local al = ac:GetPlayerFromCharacter(ak)
	if al then
		return al
	end
	if ak:GetAttribute("Bot") == true then
		return ak
	end
	local am = ac:FindFirstChild(ak.Name)
	return am and am:IsA("Player") and am or nil
end


local ak = {}
local function al(am)
	LPH_ATTRIBUTES(VM(NONE))
	table.clear(ak)
	local an = workspace:FindFirstChild("Characters")
	if not an then
		return ak
	end
	for ao, ap in an:GetChildren() do
		if ap:IsA("Model") then
			local aq = aj(ap)
			if aq and aq ~= am then
				ak[#ak + 1] = aq
				ak[#ak + 1] = ap
			end
		end
	end
	return ak
end

local function am(an)
	local ao = an:GetAttribute("Team")
	if ao == "Terrorists" then
		return "Counter-Terrorists"
	end
	if ao == "Counter-Terrorists" then
		return "Terrorists"
	end
	return nil
end

local function an(ao, ap)
	if ao:GetAttribute("Dead") == true then
		return true
	end
	return ap ~= nil and ap:GetAttribute("Dead") == true
end

local function ao(ap)
	LPH_ATTRIBUTES(VM(NONE))
	local aq = ai(ap)
	if not aq or an(ap, aq) then
		return nil
	end
	local ar = aq:GetAttribute("Health")
	if not ag(ar) then
		return nil
	end
	local as = aq:GetAttribute("MaxHealth")
	if not ag(as) or as <= 0 then
		as = 100
	end
	return {
		Health = ar,
		MaxHealth = as,
	}
end

local function ap(aq, ar)
	LPH_ATTRIBUTES(VM(NONE))
	if aq == ar then
		return nil
	end
	if workspace:GetAttribute("Gamemode") == "Deathmatch" then
		return ao(aq)
	end
	local as = am(ar)
	if as == nil or aq:GetAttribute("Team") ~= as then
		return nil
	end
	return ao(aq)
end

local function aq(ar)
	local as = ar:GetAttribute("Team")
	if as ~= nil then
		return as
	end
	local at = ai(ar)
	return at and at:GetAttribute("Team")
end

local function ar(as, at)
	
	if workspace:GetAttribute("Gamemode") == "Deathmatch" then
		return false
	end
	local au = aq(at)
	return au ~= nil and aq(as) == au
end

return {
	aimParts = ad,
	aimPartOptions = ae,
	finite = ag,
	selectedList = ah,
	characterOf = ai,
	ownerOf = aj,
	liveTargets = al,
	armorHealth = ao,
	enemyHealth = ap,
	teamOf = aq,
	sameTeam = ar,
	isDead = an,
}
end function a.e()local ab=a.cache.e if not ab then ab={c=aa()}a.cache.e=ab end return ab.c end end do local function aa()
local ab = a.e()

local ac = {}

function ac.build(ad)
	local ae = ad.tv
	local af = ad.ov
	local ag = ad.Players
	local ah = ad.LocalPlayer
	local ai = ad.ReplicatedStorage
	local aj = ad.manipulation

	local ak = Instance.new("Camera").WorldToViewportPoint

	local al
	local function am()
		LPH_ATTRIBUTES(VM(NONE))
		if al then
			return al
		end
		local an, ao = pcall(function()
			local an = require(ai.Shared.Raycast)
			return {
				inventory = require(ai.Controllers.InventoryController),
				ignore = require(ai.Components.Common.GetRayIgnore),
				cast = an.cast,
				castThrough = an.castThrough,
				castThroughDistance = an.castThroughDistance,
				bullet = require(ai.Components.Weapon.Classes.Bullet),
			}
		end)
		if an then
			al = ao
		end
		return al
	end

	local function an()
		local ao = ab.selectedList(af("silenttarget", { Head = true }))
		if #ao == 0 then
			ao = { "Head" }
		end
		return ao
	end

	local function ao(ap, aq)
		if aq == "Torso" then
			return ap:FindFirstChild("UpperTorso") or ap:FindFirstChild("Torso")
		end
		if aq == "Left Arm" then
			return ap:FindFirstChild("LeftUpperArm") or ap:FindFirstChild("Left Arm")
		end
		if aq == "Right Arm" then
			return ap:FindFirstChild("RightUpperArm") or ap:FindFirstChild("Right Arm")
		end
		if aq == "Left Leg" then
			return ap:FindFirstChild("LeftUpperLeg") or ap:FindFirstChild("Left Leg")
		end
		if aq == "Right Leg" then
			return ap:FindFirstChild("RightUpperLeg") or ap:FindFirstChild("Right Leg")
		end
		return ap:FindFirstChild(aq)
	end

	local function ap(aq)
		local ar = { aq.Position }
		if not ae("multipoints", false) then
			return ar
		end
		local as = tonumber(af("multipointscale", 0.8)) or 0.8
		local at = aq.Size * as * 0.5
		local au = af("multipointcount", "2^3")
		local av = au == "2^1" and 2 or 1
		for aw = -1, 1, av do
			for ax = -1, 1, av do
				for ay = -1, 1, av do
					if aw ~= 0 or ax ~= 0 or ay ~= 0 then
						ar[#ar + 1] = aq.CFrame:PointToWorldSpace(Vector3.new(at.X * aw, at.Y * ax, at.Z * ay))
					end
				end
			end
		end
		return ar
	end

	local function aq()
		local ar = am()
		if not ar then
			return nil
		end
		local as, at = pcall(ar.inventory.peekCurrentEquippedForMovement, ar.inventory)
		if as and type(at) == "table" and at.IsEquipped and not at.IsDestroyed then
			return at
		end
		return nil
	end

	
	
	
	local function ar(as, at)
		LPH_ATTRIBUTES(VM(NONE))
		if af("targetfrom", "Camera") == "Head" then
			local au = ab.characterOf(ah)
			local av = au and au:FindFirstChild("Head")
			if av then
				return av.Position
			end
		end
		return as.CFrame.Position
	end

	
	
	
	local function as(at, au, av, aw)
		LPH_ATTRIBUTES(VM(NONE))
		local ax = am()
		if not ax or not av then
			return false
		end
		local ay = av.Parent
		local az = au - at
		local aA = az.Magnitude
		if aA < 0.05 then
			return true
		end
		local aB = az / aA
		local aC = 0
		if aw then
			local aD = aq()
			aC = aD and aD.Properties and aD.Properties.Penetration or 0
		end
		local aD = ax.castThroughDistance
		if type(aD) == "function" then
			local aE, aF = pcall(aD, at, aB * (aA + 0.5), aC, ax.ignore())
			if aE and type(aF) == "table" then
				for aG = 1, #aF do
					local aH = aF[aG].instance
					if aH and ay and aH:IsDescendantOf(ay) then
						return true
					end
				end
				return false
			end
		end
		local aE = ax.cast(at, aB * (aA + 0.05), nil, ax.ignore())
		return not aE or not aE.instance or (ay ~= nil and aE.instance:IsDescendantOf(ay))
	end

	
	local function at(au, av, aw, ax, ay, az)
		LPH_ATTRIBUTES(VM(NONE))
		local aA = ae("silentteamcheck", true)
		if aA and ab.sameTeam(au, ah) then
			return nil
		end
		local aB = ab.enemyHealth(au, ah)
		if aA and not aB then
			return nil
		end
		if not aB and ab.isDead(au, ab.characterOf(au)) then
			return nil
		end
		if ae("silentdistancecheck", false) then
			local aC = tonumber(af("silentmaxdistance", 500)) or 500
			local aD = ax - aw
			if aD:Dot(aD) > aC * aC then
				return nil
			end
		end
		local aC, aD = ak(av, ax)
		local aE, aF = aC.X - az.X, aC.Y - az.Y
		local aG = aE * aE + aF * aF
		if not ay then
			if not aD then
				return nil
			end
			if ae("silentfovenabled", false) then
				local aH = tonumber(af("silentfovsize", 100)) or 100
				if aG > aH * aH then
					return nil
				end
			end
		elseif not aD then
			
			aG += 1e12
		end
		return aG
	end

	local au = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }
	
	
	local av = 72
	local aw = 14
	local ax = 3
	local ay = {}
	local az = {}

	local function aA(aB)
		local aC = az[aB]
		if not aC then
			aC = { parts = {}, points = {} }
			az[aB] = aC
		end
		table.clear(aC.parts)
		table.clear(aC.points)
		return aC
	end

	local function aB(aC, aD)
		return aC.best < aD.best
	end

	
	
	

	
	
	local function aC(aD, aE, aF)
		LPH_ATTRIBUTES(VM(NONE))
		if not aD then
			return nil
		end
		local aG = ar(aD, aE)
		local aH = aD.ViewportSize * 0.5
		local aI = (aF and ae("rageallparts", false)) and au or an()
		local aJ = 0
		local aK = ab.liveTargets(ah)
		for aL = 1, #aK, 2 do
			local aM, aN = aK[aL], aK[aL + 1]
			if ab.isDead(aM, aN) then
				continue
			end
			local aO
			local aP = 0
			
			for aQ, aR in aI do
				local aS = ao(aN, aR)
				if aS and aS:IsA("BasePart") then
					local aT = aS.Position
					local aU = at(aM, aD, aG, aT, aF, aH)
					if aU then
						if not aO then
							aJ += 1
							aO = aA(aJ)
							aO.player = aM
							aO.best = aU
						elseif aU < aO.best then
							aO.best = aU
						end
						aP += 1
						aO.parts[aP] = aS
						aO.points[aP] = aT
					end
				end
			end
			
			if aO and ae("multipoints", false) then
				for aQ = 1, aP do
					local aR = ap(aO.parts[aQ])
					for aS = 2, #aR do
						local aT = #aO.points + 1
						aO.parts[aT] = aO.parts[aQ]
						aO.points[aT] = aR[aS]
					end
				end
			end
			if aO then
				ay[aJ] = aO
			end
		end
		for aL = aJ + 1, #ay do
			ay[aL] = nil
		end
		if aJ == 0 then
			return nil
		end
		table.sort(ay, aB)
		local aL = aF or ae("silentvischeck", false)
		if not aL then
			local aM = ay[1]
			return { player = aM.player, part = aM.parts[1], point = aM.points[1], origin = aG }
		end
		local aM = aF and ae("ragebotwallbang", false)
		local aN = aF and ae("manipulation", false) and aj and aj.solve
		local aO = tonumber(af("manipulationdistance", 1)) or 1
		local aP = af("manipulationdepth", "Low")
		local aQ = { ah.Character }
		local aR = av
		local aS = 0
		for aT = 1, aJ do
			local aU = ay[aT]
			local aV, aW = aU.parts, aU.points
			for aX = 1, math.min(#aW, aw, aR) do
				aR -= 1
				if as(aG, aW[aX], aV[aX], aM) then
					return { player = aU.player, part = aV[aX], point = aW[aX], origin = aG }
				end
			end
			if aN and aO > 0 and aS < ax then
				aS += 1
				local aX, aY = aV[1], aW[1]
				local aZ = aj.solve(aG, aY, aO, aP, function(aZ, a_)
					return as(aZ, a_, aX, aM)
				end, aQ, 4)
				if aZ then
					return { player = aU.player, part = aX, point = aY, origin = aZ }
				end
			end
			if aR <= 0 then
				break
			end
		end
		return nil
	end

	ad.aim = {
		weapon = aq,
		mods = am,
		origin = ar,
		canHit = as,
		resolve = aC,
		refreshTargetParts = function() end,
	}
end

return ac
end function a.f()local ab=a.cache.f if not ab then ab={c=aa()}a.cache.f=ab end return ab.c end end do local function aa()
local ab = a.e()

local ac = {}

function ac.build(ad)
	local ae = ad.tv
	local af = ad.ov
	local ag = ad.UserInputService
	local ah = ad.Tabs
	local ai = ad.aim

	local aj = ah.Combat:AddLeftGroupbox("Targeting")
	aj:AddDropdown("silenttarget", {
		Text = "Target part",
		Values = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" },
		Default = { "Head" },
		Multi = true,
	})
	aj:AddDropdown("targetfrom", {
		Text = "Shoot from",
		Values = { "Camera", "Head" },
		Default = 1,
		Multi = false,
	})
	aj:AddToggle("silentteamcheck", { Text = "Team Check", Default = true })
	aj:AddToggle("silentvischeck", { Text = "Visible Check", Default = false })
	aj:AddToggle("silentdistancecheck", { Text = "Distance Check", Default = false })
	aj:AddSlider("silentmaxdistance", {
		Text = "Max Distance",
		Default = 500,
		Min = 10,
		Max = 2000,
		Rounding = 0,
		Suffix = " studs",
	})
	aj:AddToggle("silentfovenabled", { Text = "FOV Check", Default = false })
	aj:AddSlider("silentfovsize", {
		Text = "FOV Size",
		Default = 100,
		Min = 3,
		Max = 1000,
		Rounding = 0,
		Suffix = " px",
	})
	aj:AddToggle("multipoints", { Text = "Multipoints", Default = false })
	aj:AddDropdown("multipointcount", {
		Text = "Point count",
		Values = { "2^1", "2^2", "2^3" },
		Default = 3,
		Multi = false,
	})
	aj:AddSlider("multipointscale", {
		Text = "Point scale",
		Default = 0.8,
		Min = 0.1,
		Max = 1,
		Rounding = 2,
		Suffix = "x",
	})

	local ak = ah.Combat:AddRightGroupbox("Silent Aim")
	ak:AddToggle("silentenabled", { Text = "Silent Aim", Default = false }):AddKeyPicker("silentenabledbind", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Silent Aim",
	})
	ak:AddToggle("silentfovdraw", { Text = "Draw FOV Circle", Default = true })
	ak:AddLabel("FOV color"):AddColorPicker("silentfovcolor", { Default = Color3.fromRGB(255, 255, 255), Title = "FOV color" })
	ak:AddSlider("silentfovthickness", { Text = "FOV Thickness", Default = 1, Min = 1, Max = 6, Rounding = 0 })
	ak:AddToggle("snaplines", { Text = "Snapline", Default = false })
	ak:AddLabel("Line color"):AddColorPicker("snapcolor", { Default = Color3.fromRGB(255, 0, 0), Title = "Target line" })
	ak:AddSlider("snapwidth", { Text = "Line Width", Default = 1, Min = 1, Max = 4, Rounding = 0 })

	local al = ah.Combat:AddRightGroupbox("Aimbot")
	al:AddToggle("aimbotenabled", { Text = "Enabled", Default = false }):AddKeyPicker("aimbotkey", {
		Default = "E",
		SyncToggleState = false,
		Mode = "Hold",
		Text = "Aimbot",
	})
	al:AddDropdown("aimbotmethod", {
		Text = "Aim Method",
		Values = { "Camera", "Mouse" },
		Default = 1,
		Multi = false,
	})
	al:AddSlider("aimbotsmoothness", { Text = "Smoothness", Default = 1, Min = 1, Max = 20, Rounding = 1 })

	local am = ah.Combat:AddLeftGroupbox("Triggerbot")
	am:AddToggle("triggerbot", { Text = "Enabled", Default = false }):AddKeyPicker("triggerbotkey", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Triggerbot",
	})
	am:AddSlider("triggerdelay", { Text = "Delay", Default = 0, Min = 0, Max = 500, Rounding = 0, Suffix = "ms" })
	am:AddSlider("triggerhold", { Text = "Hold", Default = 40, Min = 0, Max = 250, Rounding = 0, Suffix = "ms" })

	local an = ah.Combat:AddRightGroupbox("Gun Mods")
	an:AddSlider("recoil", { Text = "Recoil", Default = 1, Min = 0, Max = 1, Rounding = 2 })
	an:AddSlider("spreadmult", { Text = "Spread Multiplier", Default = 0, Min = 0, Max = 1, Rounding = 2 })
	an:AddToggle("forceauto", { Text = "Force Auto", Default = false })
	an:AddToggle("noscope", { Text = "Remove Scope Overlay", Default = false })

	local ao = ah.Combat:AddLeftGroupbox("Rage")
	ao:AddToggle("ragebot", { Text = "Ragebot", Default = false }):AddKeyPicker("ragebotbind", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Ragebot",
	})
	ao:AddToggle("rageallparts", { Text = "Check all parts", Default = false })
	ao:AddToggle("rageignorefov", { Text = "Ignore FOV", Default = true })
	ao:AddToggle("ragebotautoreload", { Text = "Auto Reload", Default = true })
	ao:AddToggle("ragebotwallbang", { Text = "Wallbang", Default = false })
	ao:AddToggle("manipulation", { Text = "Manipulation", Default = false })
	ao:AddSlider("manipulationdistance", {
		Text = "Max Manipulation Distance",
		Default = 1,
		Min = 0,
		Max = 4,
		Rounding = 2,
		Suffix = " studs",
	})
	ao:AddDropdown("manipulationdepth", {
		Text = "Scan Depth",
		Values = { "Low", "Medium", "High" },
		Default = 1,
		Multi = false,
	})

	local ap = true
	local aq = false
	local ar
	local as
	local at = 0
	local au = 0
	local av = 0
	local aw, ax
	if Drawing then
		local ay, az = pcall(Drawing.new, "Circle")
		local aA, aB = pcall(Drawing.new, "Line")
		aw = ay and az or nil
		ax = aA and aB or nil
	end
	if aw then
		aw.Filled = false
		aw.NumSides = 64
		aw.Visible = false
	end
	if ax then
		ax.Visible = false
	end

	local function ay(az, aA)
		local aB = Options and Options[az]
		if not aB then
			return ae(aA, false)
		end
		if aB.Mode == "Hold" or aB.Mode == "hold" then
			local aC = aB.Value
			if typeof(aC) == "EnumItem" then
				return ag:IsKeyDown(aC)
			end
			if type(aC) == "string" and Enum.KeyCode[aC] then
				return ag:IsKeyDown(Enum.KeyCode[aC])
			end
		end
		return ae(aA, false)
	end

	local function az()
		return workspace:GetAttribute("GameState") == "Buy Period"
	end

	local function aA(aB)
		local aC = aB.Properties and aB.Properties.FireRate
		if type(aC) ~= "number" or aC <= 0 then
			return 0.1
		end
		return aC
	end

	local function aB(aC)
		LPH_ATTRIBUTES(VM(NONE))
		if az() or not ae("forceauto", false) or not aC.IsFireHeld or aC.IsReloading or aC.IsShooting or aC.IsDestroyed then
			return
		end
		if not aC.Rounds or aC.Rounds <= 0 then
			return
		end
		local aD = aC.Properties
		if type(aD) ~= "table" or aD.Class ~= "Weapon" or aD.Automatic ~= false then
			return
		end
		local aE = aA(aC)
		if os.clock() < av then
			return
		end
		av = os.clock() + aE
		task.defer(function()
			if aC.IsFireHeld and not aC.IsDestroyed and not aC.IsReloading and not aC.IsShooting then
				pcall(aC.shoot, aC, "Primary")
			end
		end)
	end

	local function aC(aD, aE)
		local aF = aE.point - aE.origin
		local aG = aF.Magnitude
		if aG < 0.001 then
			return nil
		end
		local aH = aF.Unit
		return {
			Origin = aE.origin,
			Direction = aH,
			Distance = aG,
			Hits = {
				{
					Instance = aE.part,
					Position = aE.point,
					Normal = -aH,
					Material = aE.part.Material.Name,
					Exit = false,
				},
			},
		}
	end

	local function aD()
		LPH_ATTRIBUTES(VM(NONE))
		if aq or type(hookfunction) ~= "function" then
			return
		end
		local aE = ai.mods()
		if not aE or type(aE.bullet._performRaycast) ~= "function" then
			return
		end
		local aF
		aF = ad.hook(aE.bullet._performRaycast, function(aG, aH)
			local aI = ar
			local aJ = aI and aG == aI.Bullet and (ae("silentenabled", false) or ae("ragebot", false) or ae("triggerbot", false))
			if aJ and ad.aimTarget then
				local aK = aC(aI, ad.aimTarget)
				if aK then
					return aK
				end
			end
			return aF(aG, aH)
		end)
		pcall(function()
			local aG = require(ad.ReplicatedStorage.Controllers.CameraController)
			local function aH()
				local aI = tonumber(af("recoil", 1)) or 1
				if aI < 0 then
					return 0
				end
				return aI
			end
			local function aI(aJ, aK)
				if aK == 1 or type(aJ) ~= "table" then
					return aJ
				end
				local aL = aJ.Value
				if typeof(aL) ~= "Vector3" and typeof(aL) ~= "Vector2" and type(aL) ~= "number" then
					return aJ
				end
				return {
					Value = aL * aK,
					Damper = aJ.Damper,
					Speed = aJ.Speed,
				}
			end
			if type(aG.weaponKick) == "function" then
				local aJ
				local aK = false
				aJ = ad.hook(aG.weaponKick, function(aL, aM)
					if aK then
						return
					end
					aK = true
					local aN = aH()
					local aO, aP, aQ = pcall(aJ, aI(aL, aN), aI(aM, aN))
					aK = false
					if aO then
						return aP, aQ
					end
				end)
			end
			if type(aG.setWeaponRecoil) == "function" then
				local aJ
				local aK = false
				aJ = ad.hook(aG.setWeaponRecoil, function(aL, aM)
					if aK then
						return
					end
					aK = true
					local aN, aO, aP = pcall(aJ, aI(aL, aH()), aM)
					aK = false
					if aN then
						return aO, aP
					end
				end)
			end
		end)
		if type(aE.bullet.getSpreadForConfig) == "function" then
			local aG
			aG = ad.hook(aE.bullet.getSpreadForConfig, function(aH, ...)
				local aI = aG(aH, ...)
				local aJ = tonumber(af("spreadmult", 0)) or 0
				if type(aI) == "number" and ar and aH == ar.Bullet then
					return aI * aJ
				end
				return aI
			end)
		end
		aq = type(aF) == "function"
	end

	local function aE(aF)
		if type(aF.shoot) ~= "function" or aF.IsReloading or aF.IsShooting then
			return
		end
		if not aF.Rounds or aF.Rounds <= 0 then
			return
		end
		local aG = aA(aF)
		if os.clock() - at < aG * 0.85 then
			return
		end
		at = os.clock()
		local aH = ad.aimTarget
		pcall(aF.shoot, aF, "Primary")
		if aH and ae("tracersenabled", false) then
			pcall(function()
			local aI = (aH.point - aH.origin).Magnitude
			if aI > 0.05 then
				local aJ = Instance.new("Part")
				aJ.Name = "vault_tracer"
				aJ.Anchored = true
				aJ.CanCollide = false
				aJ.CanQuery = false
				aJ.CanTouch = false
				aJ.Material = Enum.Material[af("tracermaterial", "Neon")] or Enum.Material.Neon
				aJ.Color = af("tracercolor", Color3.new(1, 1, 1))
				aJ.Transparency = tonumber(af("tracertransparency", 0.25)) or 0.25
				aJ.Size = Vector3.new(tonumber(af("tracersize", 0.12)) or 0.12, tonumber(af("tracersize", 0.12)) or 0.12, aI)
				aJ.CFrame = CFrame.lookAt(aH.origin, aH.point) * CFrame.new(0, 0, -aI * 0.5)
				aJ.Parent = workspace.CurrentCamera or workspace
				task.delay(tonumber(af("tracerlifetime", 1)) or 1, function()
					aJ:Destroy()
				end)
			end
			end)
		end
	end

	local function aF()
		LPH_ATTRIBUTES(VM(NONE))
		local aG = ab.characterOf(ad.LocalPlayer)
		if not aG or ab.isDead(ad.LocalPlayer, aG) then
			return true
		end
		return az()
	end

	local function aG()
		LPH_ATTRIBUTES(VM(NONE))
		local aH = ad.Camera or workspace.CurrentCamera
		if not aH then
			return
		end
		if aw then
			local aI = aH.ViewportSize * 0.5
			aw.Position = Vector2.new(aI.X, aI.Y)
			aw.Radius = tonumber(af("silentfovsize", 100)) or 100
			aw.Thickness = tonumber(af("silentfovthickness", 1)) or 1
			aw.Color = af("silentfovcolor", Color3.new(1, 1, 1))
			aw.Visible = ae("silentfovdraw", true)
		end
		if ax then
			local aI = ad.aimTarget
			local aJ = ae("snaplines", false) and aI and aI.part
			ax.Visible = false
			if aJ then
				local aK = aI.point
				if typeof(aK) ~= "Vector3" then
					local aL = ab.characterOf(aI.player)
					local aM = aL and (aL:FindFirstChild("Head") or aI.part)
					aK = aM and aM.Position
				end
				if typeof(aK) ~= "Vector3" then
					return
				end
				local aL, aM = aH:WorldToViewportPoint(aK)
				local aN = aH.ViewportSize
				local aO = Vector2.new(aN.X / 2, aN.Y / 2)
				if typeof(aL) == "Vector3" and aM and aL.Z > 0 and aL.X >= 0 and aL.Y >= 0 and aL.X <= aN.X and aL.Y <= aN.Y then
					if ae("silentfovenabled", false) and not ae("ragebot", false) then
						local aP = (Vector2.new(aL.X, aL.Y) - aO).Magnitude
						if aP > (tonumber(af("silentfovsize", 100)) or 100) then
							return
						end
					end
					ax.From = aO
					ax.To = Vector2.new(aL.X, aL.Y)
					ax.Color = af("snapcolor", Color3.fromRGB(255, 0, 0))
					ax.Thickness = tonumber(af("snapwidth", 1)) or 1
					ax.Visible = true
				end
			end
		end
	end

	local function aH(aI, aJ)
		if not (ae("aimbotenabled", false) and ay("aimbotkey", "aimbotenabled") and aJ) then
			return
		end
		local aK = math.max(tonumber(af("aimbotsmoothness", 1)) or 1, 1)
		local aL = CFrame.lookAt(aI.CFrame.Position, aJ.point)
		if af("aimbotmethod", "Camera") == "Mouse" then
			local aM = aI:WorldToViewportPoint(aJ.point)
			local aN = ag:GetMouseLocation()
			local aO = (Vector2.new(aM.X, aM.Y) - aN) / aK
			if mousemoverel then
				pcall(mousemoverel, aO.X, aO.Y)
			end
			return
		end
		aI.CFrame = aI.CFrame:Lerp(aL, 1 / aK)
	end

	ad.combat = {
		step = function()
			LPH_ATTRIBUTES(VM(NONE))
			if not ap then
				return
			end
			aD()
			local aI = ai.weapon()
			ar = aI
			if aI then
				aB(aI)
				if ae("ragebotautoreload", true) and ae("ragebot", false) and aI.Rounds and aI.Rounds <= 0 and not aI.IsReloading and type(aI.reload) == "function" then
					pcall(aI.reload, aI)
				end
			end
		end,
		renderStep = function()
			LPH_ATTRIBUTES(VM(NONE))
			if not ap then
				return
			end
			local aI = ad.Camera or workspace.CurrentCamera
			local aJ = ar
			if aJ then
				aB(aJ)
			end
			local aK = ae("ragebot", false)
			local aL = ae("silentenabled", false)
			local aM = ae("triggerbot", false)
			
			
			if aI and aJ and (aK or aL or aM or ae("aimbotenabled", false) or ae("snaplines", false)) then
				local aN = os.clock()
				local aO = ad.aimTarget
				if aN - au >= 1 / 60 or not (aO and aO.part and aO.part.Parent) then
					au = aN
					ad.aimTarget = ai.resolve(aI, aJ, aK)
				end
			else
				ad.aimTarget = nil
			end
			aG()
			if aI then
				aH(aI, ad.aimTarget)
			end
			if not aJ or not ad.aimTarget or aF() then
				as = nil
				return
			end
			if aK then
				aE(aJ)
				return
			end
			if aM then
				local aN = os.clock()
				as = as or aN
				if aN - as >= (tonumber(af("triggerdelay", 0)) or 0) / 1000 then
					aE(aJ)
					if aN - as >= ((tonumber(af("triggerdelay", 0)) or 0) + (tonumber(af("triggerhold", 40)) or 0)) / 1000 then
						as = nil
					end
				end
			else
				as = nil
			end
		end,
		unload = function()
			ap = false
			ad.aimTarget = nil
			if aw then
				aw:Remove()
			end
			if ax then
				ax:Remove()
			end
		end,
	}
end

return ac
end function a.g()local ab=a.cache.g if not ab then ab={c=aa()}a.cache.g=ab end return ab.c end end do local function aa()
local ab = a.e()

local ac = {}

local ad = { "ForceField", "Neon", "SmoothPlastic", "Plastic", "Glass", "Metal" }
local ae = {
	Night = "rbxassetid://12064107",
	Nebula = "rbxassetid://159454286",
	Sunset = "rbxassetid://151165214",
}

function ac.build(af)
	local ag = af.tv
	local ah = af.ov
	local ai = af.Players
	local aj = af.LocalPlayer
	local ak = af.Lighting
	local al = af.Tabs
	local am = af.ESP
	local an

	if am and am.Load then
		pcall(function()
			am:Load({
				Enabled = false,
				Players = false,
				LocalPlayer = false,
			})
			an = am:GetConfig()
		end)
	end

	local ao = al.ESP:AddLeftGroupbox("Main")
	ao:AddToggle("ESPMaster", { Text = "Enabled", Default = false })
	ao:AddToggle("ESPFilterTeam", { Text = "Exclude Teammates", Default = true })
	ao:AddToggle("ESPFogOfWar", { Text = "Track hidden (footsteps)", Default = true })
	ao:AddSlider("ESPFogTimeout", { Text = "Hidden timeout (s)", Default = 8, Min = 0, Max = 30, Rounding = 0 })
	ao:AddSlider("ESPMaxDistance", {
		Text = "Max distance",
		Default = 0,
		Min = 0,
		Max = 2000,
		Rounding = 0,
		Suffix = " studs",
	})

	local ap = al.ESP:AddLeftGroupbox("Boxes")
	ap:AddToggle("ESPBoxes", { Text = "Boxes", Default = true })
	ap:AddDropdown("ESPBoxType", { Text = "Box type", Values = { "Normal", "Corner" }, Default = 1, Multi = false })
	ap:AddLabel("Box color"):AddColorPicker("ESPBoxColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Box color" })
	ap:AddSlider("ESPBoxThickness", { Text = "Box thickness", Default = 1, Min = 1, Max = 6, Rounding = 0 })
	ap:AddToggle("ESPBoxOutline", { Text = "Box outline", Default = true })
	ap:AddLabel("Outline color"):AddColorPicker("ESPBoxOutlineColor", { Default = Color3.fromRGB(0, 0, 0), Title = "Outline color" })
	ap:AddToggle("ESPBoxFill", { Text = "Box fill", Default = false })
	ap:AddLabel("Fill color"):AddColorPicker("ESPBoxFillColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Fill color" })
	ap:AddSlider("ESPBoxFillTransparency", { Text = "Fill transparency", Default = 0.9, Min = 0, Max = 1, Rounding = 2 })

	local aq = al.ESP:AddLeftGroupbox("Chams")
	aq:AddToggle("ESPChams", { Text = "Chams", Default = false })
	aq:AddDropdown("ESPChamsType", {
		Text = "Chams type",
		Values = { "Highlight", "Adornment", "MeshChams" },
		Default = 1,
		Multi = false,
	})
	aq:AddLabel("Fill color"):AddColorPicker("ESPChamsFill", { Default = Color3.fromRGB(59, 144, 204), Title = "Cham fill" })
	aq:AddSlider("ESPChamsFillT", { Text = "Fill transparency", Default = 0.6, Min = 0, Max = 1, Rounding = 2 })
	aq:AddLabel("Outline color"):AddColorPicker("ESPChamsOutline", { Default = Color3.fromRGB(255, 255, 255), Title = "Cham outline" })
	aq:AddSlider("ESPChamsOutlineT", { Text = "Outline transparency", Default = 0, Min = 0, Max = 1, Rounding = 2 })
	aq:AddToggle("ESPChamsVisible", { Text = "Visible check", Default = false })

	local ar = al.ESP:AddRightGroupbox("Names & Info")
	ar:AddToggle("ESPNames", { Text = "Names", Default = true })
	ar:AddLabel("Name color"):AddColorPicker("ESPNameColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Name color" })
	ar:AddSlider("ESPTextSize", { Text = "Text size", Default = 12, Min = 6, Max = 28, Rounding = 0 })
	ar:AddToggle("ESPTextOutline", { Text = "Text outline", Default = true })
	ar:AddToggle("ESPDistance", { Text = "Distance", Default = false })
	ar:AddLabel("Distance color"):AddColorPicker("ESPDistanceColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Distance color" })
	ar:AddToggle("ESPWeapon", { Text = "Weapon", Default = false })

	local as = al.ESP:AddRightGroupbox("Health")
	as:AddToggle("ESPHealth", { Text = "Health", Default = false })

	local at = al.ESP:AddRightGroupbox("OOF Arrows")
	at:AddToggle("ESPArrows", { Text = "Off-screen arrows", Default = false })
	at:AddLabel("Arrow color"):AddColorPicker("ESPArrowColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Arrow color" })
	at:AddSlider("ESPArrowSize", { Text = "Arrow size", Default = 14, Min = 8, Max = 40, Rounding = 0 })

	local au = al.Visuals:AddLeftGroupbox("Tracers")
	au:AddToggle("tracersenabled", { Text = "Tracers", Default = false })
	au:AddLabel("Color"):AddColorPicker("tracercolor", { Default = Color3.fromRGB(255, 255, 255), Title = "Tracer" })
	au:AddDropdown("tracermaterial", { Text = "Material", Values = ad, Default = 1, Multi = false })
	au:AddSlider("tracersize", { Text = "Thickness", Default = 0.12, Min = 0.02, Max = 1, Rounding = 2 })
	au:AddSlider("tracertransparency", { Text = "Transparency", Default = 0.25, Min = 0, Max = 1, Rounding = 2 })
	au:AddSlider("tracerlifetime", { Text = "Lifetime", Default = 1, Min = 0.1, Max = 5, Rounding = 1, Suffix = "s" })

	local av = al.Visuals:AddRightGroupbox("Camera")
	av:AddToggle("customfov", { Text = "Custom FOV", Default = false })
	av:AddSlider("customfovvalue", { Text = "FOV", Default = 90, Min = 40, Max = 120, Rounding = 0 })
	av:AddToggle("thirdperson", { Text = "Third Person", Default = false }):AddKeyPicker("thirdpersonbind", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Third Person",
	})
	av:AddSlider("tpdistance", { Text = "Distance", Default = 8, Min = 2, Max = 20, Rounding = 1 })
	av:AddSlider("tpheight", { Text = "Height", Default = 2, Min = 0, Max = 8, Rounding = 1 })
	av:AddToggle("noflash", { Text = "No Flash", Default = false })
	av:AddToggle("nosmoke", { Text = "No Smoke", Default = false })

	

	local aw = al.Visuals:AddRightGroupbox("Atmosphere")
	aw:AddToggle("fullbright", { Text = "Fullbright", Default = false })
	aw:AddToggle("worldshadows", { Text = "Shadows", Default = false })
	aw:AddSlider("worldbrightness", { Text = "Brightness", Default = 2, Min = 0, Max = 10, Rounding = 1 })
	aw:AddLabel("Ambient"):AddColorPicker("worldambient", { Default = Color3.fromRGB(255, 255, 255), Title = "Ambient" })
	aw:AddLabel("Outdoor"):AddColorPicker("worldoutdoor", { Default = Color3.fromRGB(255, 255, 255), Title = "Outdoor" })
	aw:AddToggle("customsky", { Text = "Custom Sky", Default = false })
	aw:AddDropdown("skybox", {
		Text = "Skybox",
		Values = { "Default", "Night", "Nebula", "Sunset" },
		Default = 1,
		Multi = false,
	})

	local ax, ay
	local az, aA
	local aB = {}
	local aC
	local aD = false
	local aE
	local aF = false
	local aG = false
	local aH
	local aI = game:GetService("CoreGui")

	local function aJ(aK, aL)
		local aM = ah(aK, aL)
		return typeof(aM) == "Color3" and aM or aL
	end

	local function aK()
		LPH_ATTRIBUTES(VM(NONE))
		local aL = an
		if not aL then
			return
		end
		aL.Enabled = ag("ESPMaster", false)
		aL.Players = false
		aL.LocalPlayer = false
		aL.MaxDistance = tonumber(ah("ESPMaxDistance", 0)) or 0
		aL.DynamicBoxes = true
		aL.DynamicBoxesCheap = true
		aL.Boxes = ag("ESPBoxes", true)
		aL.BoxType = ah("ESPBoxType", "Normal")
		aL.BoxColor = aJ("ESPBoxColor", Color3.new(1, 1, 1))
		aL.BoxThickness = tonumber(ah("ESPBoxThickness", 1)) or 1
		aL.Outlines.Style = ag("ESPBoxOutline", true) and "Full" or "None"
		aL.Outlines.Color = aJ("ESPBoxOutlineColor", Color3.new(0, 0, 0))
		aL.BoxFill.Enabled = ag("ESPBoxFill", false)
		aL.BoxFill.Color = aJ("ESPBoxFillColor", Color3.new(1, 1, 1))
		aL.BoxFill.Transparency = tonumber(ah("ESPBoxFillTransparency", 0.9)) or 0.9
		aL.Names = ag("ESPNames", true)
		aL.TextColor = aJ("ESPNameColor", Color3.new(1, 1, 1))
		aL.TextSize = tonumber(ah("ESPTextSize", 12)) or 12
		aL.TextOutline = ag("ESPTextOutline", true)
		aL.Distance.Enabled = ag("ESPDistance", false)
		aL.Distance.Color = aJ("ESPDistanceColor", Color3.new(1, 1, 1))
		aL.Weapon.Enabled = ag("ESPWeapon", false)
		aL.Weapon.UseToolFallback = true
		aL.HealthBar.Enabled = ag("ESPHealth", false)
		aL.HealthBar.ShowText = true
		aL.Chams.Enabled = ag("ESPChams", false)
		aL.Chams.Type = ah("ESPChamsType", "Highlight")
		local aM = aJ("ESPChamsFill", Color3.fromRGB(59, 144, 204))
		local aN = tonumber(ah("ESPChamsFillT", 0.6)) or 0.6
		local aO = aJ("ESPChamsOutline", Color3.new(1, 1, 1))
		local aP = tonumber(ah("ESPChamsOutlineT", 0)) or 0
		local aQ = ag("ESPChamsVisible", false)
		aL.Chams.Highlight.FillColor = aM
		aL.Chams.Highlight.FillTransparency = aN
		aL.Chams.Highlight.OutlineColor = aO
		aL.Chams.Highlight.OutlineTransparency = aP
		aL.Chams.Highlight.VisibleCheck = aQ
		aL.Chams.MeshChams.FillColor = aM
		aL.Chams.MeshChams.FillTransparency = aN
		aL.Chams.MeshChams.OutlineColor = aO
		aL.Chams.MeshChams.OutlineTransparency = aP
		aL.Chams.MeshChams.VisibleCheck = aQ
		aL.Chams.Adornment.Color = aM
		aL.Chams.Adornment.Transparency = aN
		aL.Chams.Adornment.VisibleCheck = aQ
		aL.OffScreenArrows.Enabled = ag("ESPArrows", false)
		aL.OffScreenArrows.Color = aJ("ESPArrowColor", Color3.new(1, 1, 1))
		aL.OffScreenArrows.Size = tonumber(ah("ESPArrowSize", 14)) or 14
		local aR = { aj.Name }
		if ag("ESPFilterTeam", true) then
			
			for aS, aT in { workspace:FindFirstChild("Characters"), af.ReplicatedStorage:FindFirstChild("_PVS_CulledCharacters") } do
				for aU, aV in aT and aT:GetChildren() or {} do
					local aW = aV:IsA("Model") and ab.ownerOf(aV)
					if aW and aW ~= aj and ab.sameTeam(aW, aj) then
						aR[#aR + 1] = aV.Name
					end
				end
			end
		end
		aL.Directories = {
			{
				DisplayName = "",
				Path = "workspace.Characters",
				Multiple = true,
				NonHuman = true,
				NoStatus = true,
				Names = { "" },
				BlockNames = aR,
			},
		}
		
		if ag("ESPFogOfWar", true) and af.fow then
			local aS = table.clone(aR)
			af.fow.hidden(aS)
			aL.Directories[2] = {
				DisplayName = "",
				Path = "ReplicatedStorage._PVS_CulledCharacters",
				Multiple = true,
				NonHuman = true,
				NoStatus = true,
				Names = { "" },
				BlockNames = aS,
			}
		end
	end

	local function aL()
		if ax then
			return
		end
		ax = {
			Brightness = ak.Brightness,
			ClockTime = ak.ClockTime,
			GlobalShadows = ak.GlobalShadows,
			Ambient = ak.Ambient,
			OutdoorAmbient = ak.OutdoorAmbient,
		}
	end

	local function aM()
		if not ax then
			return
		end
		ak.Brightness = ax.Brightness
		ak.ClockTime = ax.ClockTime
		ak.GlobalShadows = ax.GlobalShadows
		ak.Ambient = ax.Ambient
		ak.OutdoorAmbient = ax.OutdoorAmbient
		ax = nil
	end

	local function aN()
		LPH_ATTRIBUTES(VM(NONE))
		if ag("fullbright", false) then
			aL()
			ak.Brightness = tonumber(ah("worldbrightness", 2)) or 2
			ak.ClockTime = 12
			ak.GlobalShadows = ag("worldshadows", false)
			ak.Ambient = aJ("worldambient", Color3.new(1, 1, 1))
			ak.OutdoorAmbient = aJ("worldoutdoor", Color3.new(1, 1, 1))
		else
			aM()
		end
		if ag("customsky", false) then
			local aO = ak:FindFirstChildOfClass("Sky")
			local aP = ae[ah("skybox", "Default")]
			if aO and aP then
				if not ay then
					ay = { aO.SkyboxBk, aO.SkyboxDn, aO.SkyboxFt, aO.SkyboxLf, aO.SkyboxRt, aO.SkyboxUp }
				end
				aO.SkyboxBk, aO.SkyboxDn, aO.SkyboxFt, aO.SkyboxLf, aO.SkyboxRt, aO.SkyboxUp = aP, aP, aP, aP, aP, aP
			end
		elseif ay then
			local aO = ak:FindFirstChildOfClass("Sky")
			if aO then
				aO.SkyboxBk, aO.SkyboxDn, aO.SkyboxFt, aO.SkyboxLf, aO.SkyboxRt, aO.SkyboxUp = ay[1], ay[2], ay[3], ay[4], ay[5], ay[6]
			end
			ay = nil
		end
	end

	local function aO(aP, aQ)
		if aP and aP.Parent then
			return aP
		end
		local aR = Instance.new("Highlight")
		aR.Name = aQ
		aR.Parent = aI
		return aR
	end

	local function aP()
		for aQ, aR in aB do
			if aQ.Parent then
				aQ.Material = aR.material
				aQ.Color = aR.color
				aQ.Transparency = aR.transparency
			end
		end
		table.clear(aB)
		if az then
			az.Enabled = false
			az.Adornee = nil
		end
		if aA then
			aA.Enabled = false
			aA.Adornee = nil
		end
	end

	local function aQ(aR)
		local aS = aR and aR.Viewmodel
		if type(aS) == "table" then
			for aT, aU in { "Model", "CameraModel", "WorldModel" } do
				if typeof(aS[aU]) == "Instance" then
					return aS[aU]
				end
			end
			if typeof(aS.MuzzlePart) == "Instance" then
				return aS.MuzzlePart:FindFirstAncestorOfClass("Model")
			end
		end
		local aT = workspace.CurrentCamera
		if aT then
			for aU, aV in aT:GetChildren() do
				if aV:IsA("Model") then
					return aV
				end
			end
		end
	end

	local function aR(aS)
		LPH_ATTRIBUTES(VM(NONE))
		local aT = aQ(aS)
		if not aT then
			aP()
			return
		end
		local aU = aT:FindFirstChild("Weapon") or aT:FindFirstChild("WeaponL") or aT:FindFirstChild("WeaponR")
		if ag("vmchams", false) then
			az = aO(az, "vault_vmcham")
			az.Adornee = aU or aT
			az.FillColor = aJ("vmchamcolor", Color3.fromRGB(59, 144, 204))
			az.FillTransparency = tonumber(ah("vmtransparency", 0.45)) or 0.45
			az.OutlineColor = aJ("vmchamcolor", Color3.fromRGB(59, 144, 204))
			az.OutlineTransparency = 0
			az.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			az.Enabled = true
		elseif az then
			az.Enabled = false
			az.Adornee = nil
		end
		if ag("wepchams", false) and aU then
			aA = aO(aA, "vault_wepcham")
			aA.Adornee = aU
			aA.FillColor = aJ("wepchamcolor", Color3.new(1, 1, 1))
			aA.FillTransparency = tonumber(ah("weptransparency", 0.45)) or 0.45
			aA.OutlineTransparency = 0
			aA.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			aA.Enabled = true
		elseif aA then
			aA.Enabled = false
			aA.Adornee = nil
		end
		aP()
	end

	local function aS()
		LPH_ATTRIBUTES(VM(NONE))
		if not ag("noscope", false) then
			return
		end
		local aT = aj:FindFirstChild("PlayerGui")
		aT = aT and aT:FindFirstChild("MainGui")
		aT = aT and aT:FindFirstChild("Gameplay")
		local aU = aT and aT:FindFirstChild("Middle")
		local aV = aU and aU:FindFirstChild("SniperScope")
		if not aV then
			return
		end
		if aV:IsA("GuiObject") then
			aV.Visible = false
			if not aV:GetAttribute("vault_scope") then
				aV:SetAttribute("vault_scope", true)
				aV:GetPropertyChangedSignal("Visible"):Connect(function()
					if ag("noscope", false) then
						aV.Visible = false
					end
				end)
			end
		end
		for aW, aX in aV:GetDescendants() do
			if aX:IsA("GuiObject") then
				aX.Visible = false
			elseif aX:IsA("LayerCollector") then
				aX.Enabled = false
			end
		end
	end

	local aT = {
		["HE Grenade"] = true,
		["Smoke Grenade"] = true,
		["Flashbang"] = true,
		["Decoy Grenade"] = true,
		["Incendiary Grenade"] = true,
		Molotov = true,
	}
	local aU
	local aV
	local aW = RaycastParams.new()
	aW.FilterType = Enum.RaycastFilterType.Exclude
	local aX = {}
	local aY = {}
	local aZ = setmetatable({}, { __mode = "k" })

	local function a_(a0)
		if type(a0) ~= "table" then
			return nil
		end
		local a1 = a0.Name or a0.Weapon
		if type(a1) ~= "string" and type(a0.Properties) == "table" then
			a1 = a0.Properties.Name
		end
		return aT[a1] and a1 or nil
	end

	local function a0()
		if aU then
			return aU
		end
		local a1, a2 = pcall(function()
			return require(af.ReplicatedStorage.Shared.GrenadeSimulator)
		end)
		if a1 and type(a2) == "table" then
			aU = a2
		end
		if not aV then
			local a3, a4 = pcall(function()
				return require(af.ReplicatedStorage.Components.Common.GetCharacterVelocity)
			end)
			if a3 and type(a4) == "function" then
				aV = a4
			end
		end
		return aU
	end

	local function a1(a2, a3, a4)
		local a5 = a2[a3]
		if not a5 and Drawing then
			local a6, a7 = pcall(Drawing.new, "Line")
			if a6 then
				a7.Thickness = 1.5
				a2[a3] = a7
				a5 = a7
			end
		end
		if a5 then
			a5.Color = a4
			a5.Thickness = tonumber(ah("grenadethickness", 1.5)) or 1.5
		end
		return a5
	end

	local function a2(a3, a4)
		for a5 = a4, #a3 do
			a3[a5].Visible = false
		end
	end

	local function a3(a4, a5, a6, a7, a8)
		a8 = a8 or 1
		for a9 = 1, #a5 - 1 do
			local b, ba = a6:WorldToViewportPoint(a5[a9])
			local bb, bc = a6:WorldToViewportPoint(a5[a9 + 1])
			if (ba or bc) and b.Z > 0 and bb.Z > 0 then
				local bd = a1(a4, a8, a7)
				if bd then
					bd.From = Vector2.new(b.X, b.Y)
					bd.To = Vector2.new(bb.X, bb.Y)
					bd.Visible = true
					a8 += 1
				end
			end
		end
		return a8
	end

	local function a4(a5, a6, a7, a8)
		local a9 = a0()
		if not a9 or typeof(a5) ~= "Vector3" or typeof(a6) ~= "Vector3" then
			return {}
		end
		local b = {}
		local ba = ab.characterOf(aj)
		if ba then
			b[1] = ba
		end
		local bb = workspace.CurrentCamera
		if bb then
			b[#b + 1] = bb
		end
		aW.FilterDescendantsInstances = b
		local bc, bd = a9.calculateThrowParameters(a5, a6, a7, 1)
		local be = a9.createInitialState(bc, bd, a7, a8 or Vector3.zero, 1, workspace:GetServerTimeNow())
		local bf = a9.createConfig(2, 1, a7 == "Near")
		local bg = { be.position }
		for bh = 1, 36 do
			local bi = a9.simulate(be, bf, aW, 0.05)
			be = bi.state
			bg[#bg + 1] = be.position
			if be.isAtRest then
				break
			end
		end
		return bg
	end

	local function a5(a6)
		LPH_ATTRIBUTES(VM(NONE))
		if not ag("grenadetrajectory", false) then
			a2(aX, 1)
			a2(aY, 1)
			return
		end
		local a7 = af.aim and af.aim.weapon and af.aim.weapon()
		if a_(a7) then
			local a8 = af.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) and "Near" or "Far"
			local a9 = Vector3.zero
			local b = ab.characterOf(aj)
			if aV and b then
				local ba, bb = pcall(aV, b)
				if ba and typeof(bb) == "Vector3" then
					a9 = bb
				end
			end
			local ba = b and (b:FindFirstChild("CameraPart") or b:FindFirstChild("Head") or b:FindFirstChild("HumanoidRootPart"))
			local bb = ba and ba.Position or a6.CFrame.Position
			a2(aX, a3(aX, a4(bb, a6.CFrame.LookVector, a8, a9), a6, aJ("grenadethrowcolor", Color3.fromRGB(255, 220, 80))))
		else
			a2(aX, 1)
		end
		local a8 = workspace:FindFirstChild("Debris")
		local a9 = os.clock()
		local b = {}
		local ba = 1
		local bb = aJ("grenadelivecolor", Color3.fromRGB(80, 220, 255))
		if a8 then
			for bc, bd in a8:GetChildren() do
				if bd:GetAttribute("GrenadeName") and not bd:IsDescendantOf(a6) then
					b[bd] = true
					local be = bd:GetPivot().Position
					local bf = aZ[bd]
					if not bf then
						bf = { pos = be, t = a9, points = nil }
						aZ[bd] = bf
					elseif not bf.points and a9 - bf.t > 0.03 then
						local bg = (be - bf.pos) / (a9 - bf.t)
						if bg.Magnitude > 2 then
							local bh = a0()
							if bh then
								local bi = {
									position = bf.pos,
									velocity = bg,
									simulationTime = 0,
									bounceCount = 0,
									isGrounded = false,
									isAtRest = false,
									hasTouched = false,
									accumulatedTime = 0,
									angularVelocity = Vector3.zero,
									timestamp = workspace:GetServerTimeNow(),
									isJumpThrow = false,
								}
								local bj = bh.createConfig(2, 1, false)
								local bk = { bf.pos }
								for bl = 1, 28 do
									local bm = bh.simulate(bi, bj, aW, 0.05)
									bi = bm.state
									bk[#bk + 1] = bi.position
									if bi.isAtRest then
										break
									end
								end
								bf.points = bk
							end
						end
					end
					if bf.points then
						ba = a3(aY, bf.points, a6, bb, ba)
					end
				end
			end
		end
		for bc in aZ do
			if not b[bc] then
				aZ[bc] = nil
			end
		end
		a2(aY, ba)
	end

	local function a6()
		if aF or type(hookfunction) ~= "function" then
			return
		end
		local a7, a8 = pcall(function()
			return require(af.ReplicatedStorage.Components.Common.VFXLibary.CreateVoxelSmoke)
		end)
		if not a7 or type(a8) ~= "table" then
			return
		end
		aE = a8
		if type(a8.Create) == "function" then
			local a9
			a9 = af.hook(a8.Create, function(...)
				if ag("nosmoke", false) then
					return
				end
				return a9(...)
			end)
		end
		if type(a8.DoesRayIntersectActiveSmoke) == "function" then
			local a9
			a9 = af.hook(a8.DoesRayIntersectActiveSmoke, function(...)
				if ag("nosmoke", false) then
					return false
				end
				return a9(...)
			end)
		end
		aF = true
	end

	local function a7()
		LPH_ATTRIBUTES(VM(NONE))
		if not ag("nosmoke", false) then
			return
		end
		a6()
		if aE and type(aE.DestroyAll) == "function" then
			pcall(aE.DestroyAll)
		end
		local a8 = workspace:FindFirstChild("Debris")
		if not a8 then
			return
		end
		for a9, b in a8:GetChildren() do
			if string.sub(b.Name, 1, 11) == "VoxelSmoke_" then
				b:Destroy()
			end
		end
	end

	local function a8()
		if aD or type(hookfunction) ~= "function" then
			return
		end
		local a9, b = pcall(function()
			return require(af.ReplicatedStorage.Components.Common.VFXLibary.FlashEffect)
		end)
		if not a9 or type(b) ~= "table" or type(b.Flash) ~= "function" then
			return
		end
		aC = b
		local ba
		ba = af.hook(b.Flash, function(...)
			if ag("noflash", false) then
				return
			end
			return ba(...)
		end)
		aD = type(ba) == "function"
	end

	local a9 = {
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
	for b, ba in a9 do
		if Toggles[ba] then
			Toggles[ba]:OnChanged(aK)
		end
	end

	af.visuals = {
		applyESP = aK,
		step = function()
			LPH_ATTRIBUTES(VM(NONE))
			aN()
			a7()
			if os.clock() - (af._espAt or 0) > 0.35 then
				af._espAt = os.clock()
				aK()
			end
			a8()
			if ag("noflash", false) and aC and aC.CancelFlash then
				pcall(aC.CancelFlash)
			end
		end,
		applyCamera = function(b)
			LPH_ATTRIBUTES(VM(NONE))
			b = b or af.Camera or workspace.CurrentCamera
			if not b then
				return
			end
			if ag("customfov", false) then
				b.FieldOfView = tonumber(ah("customfovvalue", 90)) or 90
			end
			local ba = ag("thirdperson", false)
			local bb = Options and Options.thirdpersonbind
			if bb and (bb.Mode == "Hold" or bb.Mode == "hold") then
				local bc = bb.Value
				ba = typeof(bc) == "EnumItem" and af.UserInputService:IsKeyDown(bc) or ba
			end
			local bc = workspace:FindFirstChild("Characters")
			local bd = bc and (bc:FindFirstChild(aj.Name) or bc:FindFirstChild(aj.DisplayName))
			if not (bd and bd:IsA("Model") and bd.Parent) then
				bd = ab.characterOf(aj)
			end
			local be = tonumber(ah("tpdistance", 8)) or 8
			if ba then
				if not aH then
					local bf, bg = pcall(function()
						return require(af.ReplicatedStorage.Controllers.CameraController)
					end)
					if bf then
						aH = bg
					end
				end
				if aH and type(aH.setPerspective) == "function" then
					pcall(aH.setPerspective, false, false, be)
				end
			elseif aG and aH and type(aH.setPerspective) == "function" then
				pcall(aH.setPerspective, true, false)
			end
			if bd then
				for bf, bg in bd:GetDescendants() do
					if bg:IsA("BasePart") or bg:IsA("Decal") then
						if ba and bg.Transparency < 1 then
							bg.LocalTransparencyModifier = 0
						elseif aG and not ba then
							bg.LocalTransparencyModifier = 1
						end
					end
				end
			end
			aG = ba
			if ba and bd then
				local bf = bd:FindFirstChild("HumanoidRootPart") or bd.PrimaryPart or bd:FindFirstChild("Head") or bd:FindFirstChild("CameraPart")
				if bf then
					local bg = b.CFrame.LookVector
					local bh = tonumber(ah("tpheight", 2)) or 2
					local bi = bf.Position + Vector3.new(0, bh * 0.4, 0)
					b.CFrame = CFrame.lookAt(bi - bg * be + Vector3.new(0, bh, 0), bi)
				end
			end
		end,
		renderStep = function()
			LPH_ATTRIBUTES(VM(NONE))
			local b = af.Camera or workspace.CurrentCamera
			aS()
			if not b then
				return
			end
			af.visuals.applyCamera(b)
			a5(b)
		end,
		unload = function()
			aM()
			aP()
			if az then
				az:Destroy()
			end
			if aA then
				aA:Destroy()
			end
			if ay then
				local b = ak:FindFirstChildOfClass("Sky")
				if b then
					b.SkyboxBk, b.SkyboxDn, b.SkyboxFt, b.SkyboxLf, b.SkyboxRt, b.SkyboxUp = ay[1], ay[2], ay[3], ay[4], ay[5], ay[6]
				end
			end
			a2(aX, 1)
			a2(aY, 1)
			if am and am.Unload then
				pcall(function()
					am:Unload()
				end)
			end
		end,
	}
end

return ac
end function a.h()local ab=a.cache.h if not ab then ab={c=aa()}a.cache.h=ab end return ab.c end end do local function aa()
local ab = a.e()

local ac = {}

function ac.build(ad)
	local ae = ad.tv
	local af = ad.ov
	local ag = ad.UserInputService
	local ah = ad.LocalPlayer
	local ai = ad.ReplicatedStorage
	local aj = ad.Tabs

	local ak = aj.Misc:AddLeftGroupbox("Movement")
	ak:AddToggle("bhop", { Text = "Bhop", Default = false })
	ak:AddToggle("autostrafe", { Text = "Auto Strafe", Default = false })
	ak:AddLabel("Hold space to hop. Steer with mouse / WASD.")

	local al = aj.Misc:AddRightGroupbox("Antiaim")
	al:AddToggle("antiaim", { Text = "Enabled", Default = false }):AddKeyPicker("antiaimkey", {
		Default = "None",
		SyncToggleState = true,
		Mode = "Toggle",
		Text = "Antiaim",
	})
	al:AddToggle("antiaimpitch", { Text = "Pitch modifier", Default = false })
	al:AddDropdown("antiaimpitchvalue", {
		Text = "Pitch value",
		Values = { "Down", "Up", "Zero", "Perfect up", "Perfect down" },
		Default = 5,
		Multi = false,
	})
	al:AddToggle("antiaimyaw", { Text = "Yaw modifier", Default = false })
	al:AddSlider("antiaimyawvalue", { Text = "Yaw value", Default = 180, Min = -180, Max = 180, Rounding = 0 })
	al:AddToggle("antiaimjitter", { Text = "Yaw jitter", Default = false })
	al:AddSlider("antiaimjitterstrength", { Text = "Jitter strength", Default = 45, Min = 0, Max = 90, Rounding = 0 })
	al:AddToggle("antiaimspin", { Text = "Yaw spin", Default = false })
	al:AddSlider("antiaimspinspeed", { Text = "Spin speed", Default = 1.8, Min = 0, Max = 10, Rounding = 1 })

	local am = true
	local an = false
	local ao = false
	local ap = 0
	local aq = 1
	local ar = 0
	local as
	local at
	local function au(av, aw)
		local ax, ay = math.sin(aw), math.cos(aw)
		local az = -av.Y
		return Vector3.new(ay * av.X - ax * az, 0, -ax * av.X - ay * az)
	end

	local function av(aw, ax)
		local ay, az = math.sin(ax), math.cos(ax)
		return Vector2.new(az * aw.X - ay * aw.Z, ay * aw.X + az * aw.Z)
	end

	local aw = false
	local ax, ay
	local az = RaycastParams.new()
	az.FilterType = Enum.RaycastFilterType.Exclude
	local aA = 0
	local aB = nil 
	local aC = 0
	local aD = 1

	local function aE(aF)
		return ag:IsKeyDown(aF) and 1 or 0
	end

	
	local function aF()
		local aG = workspace:GetAttribute("ServerGamemode")
		if ax and ay == aG then
			return ax
		end
		local aH, aI = pcall(function()
			local aH = require(ai.MovementV2.Simulation.Config)
			return aH.resolveServerGamemode(aG) or aH.Default
		end)
		if aH and type(aI) == "table" then
			ax, ay = aI, aG
		end
		return ax
	end

	local function aG(aH, aI)
		local aJ = os.clock()
		if aJ > aA then
			aA = aJ + 2
			local aK = { workspace.CurrentCamera }
			for aL, aM in { "Characters", "Debris" } do
				local aN = workspace:FindFirstChild(aM)
				if aN then
					aK[#aK + 1] = aN
				end
			end
			az.FilterDescendantsInstances = aK
		end
		local aK = workspace:Raycast(aH, Vector3.new(0, -aI, 0), az)
		return aK and aK.Position.Y
	end

	
	local function aH(aI, aJ, aK)
		if not aB then
			return nil
		end
		local aL, aM = aI.Position, aI.Velocity
		local aN = aJ.Gravity or 60
		local aO = aG(aL, 60)
		if not aO then
			return nil
		end
		local aP = aL.Y - aB - aO
		local aQ = aM.Y
		local aR = aQ * aQ + 2 * aN * math.max(aP, 0)
		local aS = (aQ + math.sqrt(aR)) / aN
		
		local aT = aL + Vector3.new(aM.X * aS, 0, aM.Z * aS)
		local aU = aG(Vector3.new(aT.X, aL.Y, aT.Z), 60)
		if aU then
			aP = aL.Y - aB - aU
			aR = aQ * aQ + 2 * aN * math.max(aP, 0)
			aS = (aQ + math.sqrt(aR)) / aN
		end
		return aS / aK
	end

	
	local function aI(aJ, aK, aL, aM, aN)
		local aO = aJ:Dot(aK)
		local aP = math.min(aL, aM.AirSpeedCap) - aO
		if aP <= 0 then
			return aJ
		end
		local aQ = aM.AirAccelerate * aL * aN
		local aR = aJ + aK * math.min(aP, aQ)
		local aS = aM.BunnyHopSpeedCap or 0
		if aS > 0 and aR.Magnitude > aS then
			aR = aR.Unit * aS
		end
		return aR
	end

	local function aJ(aK, aL)
		local aM, aN = math.cos(aL), math.sin(aL)
		return Vector3.new(aK.X * aM + aK.Z * aN, 0, -aK.X * aN + aK.Z * aM)
	end

	
	
	
	
	local function aK(aL, aM, aN)
		local aO = aF()
		if not aO or aL.OnGround or aL.MovementMode ~= "Walking" then
			return nil
		end
		local aP = aL.Velocity
		local aQ = Vector3.new(aP.X, 0, aP.Z)
		local aR = aQ.Magnitude
		if aR < 1 then
			return nil
		end
		local aS = aM.LookYaw or 0
		local aT = aE(Enum.KeyCode.D) - aE(Enum.KeyCode.A)
		local aU = aE(Enum.KeyCode.S) - aE(Enum.KeyCode.W)
		if aT == 0 and aU == 0 then
			aU = -1
		end
		local aV = au(Vector2.new(aT, aU).Unit, aS)
		local aW = aN or (1 / 60)
		local aX = math.clamp((aL.Stamina or 100) / math.max(aO.StaminaMax or 100, 1), 0, 1)
		local aY = math.min(aL.BaseMoveSpeed or aO.MaxSpeed or 18, aO.MaxBaseMoveSpeed or 19.5) * aX * aX
		if aY <= 0 then
			return nil
		end
		local aZ = aQ / aR
		local a_ = aO.AirAccelerate * aY * aW
		local a0 = math.max(0, math.min(aY, aO.AirSpeedCap) - a_)
		local a1 = math.acos(math.clamp(a0 / aR, 0, 1))

		
		local a2 = aZ.Z * aV.X - aZ.X * aV.Z
		local a3 = math.atan2(a2, aZ:Dot(aV))
		local a4 = math.atan2(math.min(aY, aO.AirSpeedCap), aR)
		local a5
		if math.abs(a3) > a4 then
			a5 = a3 > 0 and 1 or -1
		else
			aD = -aD
			a5 = aD
		end
		local a6 = aJ(aZ, a5 * a1)

		local a7 = aO.BunnyHopPenaltyThreshold or 0
		if a7 > 0 and aR > a7 - 0.6 then
			local a8 = aH(aL, aO, aW)
			local a9 = a7 - 0.25
			local b = math.ceil((aR - a9) / math.max(a_, 0.01)) + 1
			if a8 and a8 <= b then
				
				local ba, bb = nil, math.huge
				for bc = 0, 36 do
					local bd = aJ(aZ, a5 * (math.pi * 0.5 + bc * math.pi / 72))
					local be = aI(aQ, bd, aY, aO, aW).Magnitude
					local bf = be > a7 and (be - a7) * 4 + 1 or math.abs(be - a9)
					if bf < bb then
						ba, bb = bd, bf
					end
				end
				a6 = ba or a6
			end
		end
		return av(a6, aS)
	end

	local function aL(aM)
		LPH_ATTRIBUTES(VM(NONE))
		if type(aM) ~= "table" then
			return false
		end
		local aN = aM.MovementState
		return type(aN) == "table" and aN.OnGround == true
	end

	local function aM()
		local aN = af("antiaimpitchvalue", "Perfect down")
		if aN == "Perfect up" or aN == "Up" then
			return aN == "Perfect up" and 1 or 0.7
		end
		if aN == "Zero" then
			return 0
		end
		if aN == "Down" then
			return -0.7
		end
		return -1
	end

	local function aN(aO)
		if not ae("antiaim", false) or type(aO) ~= "table" then
			return aO
		end
		local aP = table.clone(aO)
		local aQ = aP.LookYaw or 0
		local aR = aQ
		if ae("antiaimyaw", false) then
			aQ += math.rad(tonumber(af("antiaimyawvalue", 180)) or 180)
		end
		if ae("antiaimspin", false) then
			aQ += os.clock() * (tonumber(af("antiaimspinspeed", 1.8)) or 1.8)
		end
		if ae("antiaimjitter", false) then
			if os.clock() - ar > 0.08 then
				aq = -aq
				ar = os.clock()
			end
			aQ += math.rad(tonumber(af("antiaimjitterstrength", 45)) or 45) * aq
		end
		aP.LookYaw = aQ
		if typeof(aP.Move) == "Vector2" and aQ ~= aR then
			aP.Move = av(au(aP.Move, aR), aQ)
		end
		if ae("antiaimpitch", false) then
			aP.VerticalLook = aM()
		end
		return aP
	end

	local function aO()
		LPH_ATTRIBUTES(VM(NONE))
		if an or os.clock() < ap then
			return
		end
		if not ae("bhop", false) and not ae("autostrafe", false) and not ae("antiaim", false) then
			return
		end
		ap = os.clock() + 3
		if type(hookfunction) ~= "function" then
			return
		end
		local aP = pcall(function()
			local aP = require(ai.Classes.Character)
			local aQ = require(ai.MovementV2.Buttons)
			local aR
			aR = ad.hook(aP.SampleInput, function(aS, aT, ...)
				LPH_ATTRIBUTES(VM(NONE))
				local aU = aR(aS, aT, ...)
				at = aS
				if type(aU) ~= "table" or not am then
					return aU
				end
				
				local aV = type(aT) == "table" and aT.State
				if type(aV) ~= "table" or type(aV.OnGround) ~= "boolean" then
					return aN(aU)
				end
				local aW
				local aX = ag:GetFocusedTextBox() ~= nil
				local aY = ae("bhop", false) and not aX and ag:IsKeyDown(Enum.KeyCode.Space)
				if aV.OnGround and typeof(aV.Position) == "Vector3" and os.clock() > aC then
					aC = os.clock() + 0.5
					local aZ = aG(aV.Position, 12)
					if aZ then
						aB = aV.Position.Y - aZ
					end
				end
				if aY and type(aU.Buttons) == "number" then
					
					
					local aZ = aV.OnGround and not aw
					aW = table.clone(aU)
					aW.Buttons = aQ.with(aW.Buttons, aQ.Jump, aZ)
					aw = aZ
				else
					aw = type(aU.Buttons) == "number" and aQ.has(aU.Buttons, aQ.Jump) or false
				end
				if ae("autostrafe", false) and not aX and not aV.OnGround then
					local aZ = aY
						or aE(Enum.KeyCode.W) == 1
						or aE(Enum.KeyCode.A) == 1
						or aE(Enum.KeyCode.S) == 1
						or aE(Enum.KeyCode.D) == 1
					local a_ = aZ and aK(aV, aU, type(aT.StepSeconds) == "number" and aT.StepSeconds or nil)
					if a_ then
						aW = aW or table.clone(aU)
						aW.Move = a_
					end
				end
				return aN(aW or aU)
			end)
			assert(type(aR) == "function")
		end)
		if aP then
			an = true
		elseif not ao then
			ao = true
			ad.notify("Movement hook failed.", true)
		end
	end

	local aP = ad.RunService.PreSimulation:Connect(function()
		LPH_ATTRIBUTES(VM(NONE))
		if am then
			aO()
		end
	end)

	ad.movement = {
		step = function()
			LPH_ATTRIBUTES(VM(NONE))
		end,
		renderStep = function()
			LPH_ATTRIBUTES(VM(NONE))
			local function aQ()
				if not as then
					return
				end
				local aR = as.joints
				pcall(function()
					aR.RightShoulder.C0 = aR.BaseRightShoulderC0
					aR.LeftShoulder.C0 = aR.BaseLeftShoulderC0
					aR.Waist.C0 = aR.BaseWaistC0
					if aR.Neck and aR.BaseNeckC0 then
						aR.Neck.C0 = aR.BaseNeckC0
					end
				end)
				as = nil
			end
			if not am or not ae("antiaim", false) or not ae("antiaimpitch", false) or not ae("thirdperson", false) then
				aQ()
				return
			end
			local aR = workspace:FindFirstChild("Characters")
			local aS = aR and aR:FindFirstChild(ah.Name)
			if not (aS and aS:IsA("Model")) then
				as = nil
				return
			end
			if not as or as.character ~= aS then
				local aT, aU = pcall(function()
					return require(ai.Components.Common.CharacterPose)
				end)
				local aV = aT and aU and aU.getJoints and aU.getJoints(aS)
				as = aV and { character = aS, api = aU, joints = aV } or nil
			end
			if as then
				pcall(as.api.applyVerticalLook, as.joints, aM(), 0)
			end
		end,
		unload = function()
			am = false
			if aP then
				aP:Disconnect()
			end
		end,
	}
end

return ac
end function a.i()local ab=a.cache.i if not ab then ab={c=aa()}a.cache.i=ab end return ab.c end end do local function aa()
local ab = {}

local ac = {
	"knife",
	"bayonet",
	"karambit",
	"daggers",
	"navaja",
	"stiletto",
	"talon",
	"ursus",
	"paracord",
	"nomad",
	"skeleton",
	"kukri",
	"lightsaber",
}

local function ad(ae)
	if type(ae) ~= "string" then
		return false
	end
	local af = ae:lower()
	for ag, ah in ac do
		if af:find(ah, 1, true) then
			return true
		end
	end
	return false
end

local function ae(af)
	return type(af) == "string" and af:match("^Gloves / (.+)$") or nil
end

function ab.build(af)
	local ag = af.tv
	local ah = af.ov
	local ai = af.ReplicatedStorage
	local aj = af.LocalPlayer
	local ak = af.Tabs

	local al = ak.Misc:AddLeftGroupbox("Weapon Skins")
	al:AddToggle("weaponskin", { Text = "Weapon Skin Changer", Default = false })
	local am = ak.Misc:AddRightGroupbox("Knife Skins")
	am:AddToggle("knifeskin", { Text = "Knife Skin Changer", Default = false })

	local function an()
		local ao, ap = {}, {}
		local aq = ai:FindFirstChild("Database")
		aq = aq and aq:FindFirstChild("Custom")
		aq = aq and aq:FindFirstChild("Weapons")
		local ar = ai:FindFirstChild("Assets")
		ar = ar and ar:FindFirstChild("Skins")
		if not ar then
			return ao
		end
		local function as(at)
			local au = ar:FindFirstChild(at)
			if at ~= "Knife" and at ~= "T Knife" and at ~= "CT Knife" and (at == "Lightsaber" or at == "LightSaber" or (au and #au:GetChildren() > 0)) and not ap[at] then
				ap[at] = true
				ao[#ao + 1] = at
			end
		end
		if aq then
			for at, au in aq:GetChildren() do
				if au:IsA("ModuleScript") and ad(au.Name) then
					as(au.Name)
				elseif au:IsA("ModuleScript") then
					local av, aw = pcall(require, au)
					if av and type(aw) == "table" and (aw.Type == "Knife" or aw.Type == "Melee" or aw.Slot == "Knife") then
						as(au.Name)
					end
				end
			end
		end
		for at, au in ar:GetChildren() do
			if ad(au.Name) then
				as(au.Name)
			end
		end
		table.sort(ao)
		return ao
	end

	local function ao()
		local ap = {}
		local aq, ar = {}, {}
		for as, at in an() do
			ar[at] = true
		end
		local as = ai:FindFirstChild("Database")
		as = as and as:FindFirstChild("Custom")
		local at = as and as:FindFirstChild("Weapons")
		if at then
			for au, av in at:GetChildren() do
				if av:IsA("ModuleScript") and av.Name ~= "SprayPatterns" and av.Name ~= "Types" then
					if av.Name ~= "C4" and av.Name ~= "AUG" and not ad(av.Name) and not ar[av.Name] then
						ap[#ap + 1] = av.Name
					end
					aq[av.Name] = true
				end
			end
		end
		table.sort(ap)
		return ap
	end

	local function ap(aq)
		if aq == "AUG" or aq == nil then
			return {}
		end
		local ar = ai:FindFirstChild("Assets")
		ar = ar and ar:FindFirstChild("Skins")
		local as = ae(aq)
		local at = ar and ar:FindFirstChild("Gloves")
		local au = ar and (as and ((at and at:FindFirstChild(as)) or ar:FindFirstChild(as)) or ar:FindFirstChild(aq))
		local av = {}
		if au then
			for aw, ax in au:GetChildren() do
				av[#av + 1] = ax.Name
			end
		end
		table.sort(av)
		return av
	end

	local aq = ao()
	local ar = an()
	if #aq == 0 then
		aq = { "AK-47" }
	end
	if #ar == 0 then
		ar = { "Karambit" }
	end

	al:AddDropdown("skinitem", {
		Text = "Weapon",
		Values = aq,
		Default = 1,
		Multi = false,
	})
	al:AddDropdown("weaponskinname", {
		Text = "Skin",
		Values = (function()
			local as = ap(aq[1])
			if #as == 0 then
				as = { "Stock" }
			end
			return as
		end)(),
		Default = 1,
		Multi = false,
	})
	am:AddDropdown("skinknife", {
		Text = "Knife",
		Values = ar,
		Default = 1,
		Multi = false,
	})
	am:AddDropdown("knifeskinname", {
		Text = "Skin",
		Values = (function()
			local as = ap(ar[1])
			if #as == 0 then
				as = { "Stock" }
			end
			return as
		end)(),
		Default = 1,
		Multi = false,
	})

	local as = {}
	local at
	local au = false

	local function av(aw, ax)
		local ay = Options and Options[aw]
		if ay and ay.SetValues and type(ax) == "table" and #ax > 0 then
			pcall(ay.SetValues, ay, ax)
		end
	end

	local function aw()
		local ax = ah("skinitem", aq[1])
		if type(ax) ~= "string" then
			ax = aq[1]
		end
		return ax
	end

	local function ax()
		local ay = ah("skinknife", ar[1])
		if type(ay) ~= "string" then
			ay = ar[1]
		end
		return ay
	end

	local function ay()
		local az = ah("weaponskinname", nil)
		return type(az) == "string" and az or nil
	end

	local function az()
		local aA = ah("knifeskinname", nil)
		return type(aA) == "string" and aA or nil
	end

	local function aA()
		return ag("weaponskin", false) or ag("knifeskin", false)
	end

	local function aB()
		local aC = ap(aw())
		if #aC == 0 then
			aC = { "Stock" }
		end
		av("weaponskinname", aC)
		local aD = ap(ax())
		if #aD == 0 then
			aD = { "Stock" }
		end
		av("knifeskinname", aD)
	end

	local function aC()
		return af.HttpService:JSONEncode({
			overrides = as,
			knife = at,
		})
	end

	local function aD()
		if type(writefile) ~= "function" then
			return
		end
		pcall(writefile, "VaultCC_Bloxstrike_skins.json", aC())
	end

	local function aE()
	end

	local aF, aG
	local aH = setmetatable({}, { __mode = "k" })
	local aI = setmetatable({}, { __mode = "k" })
	local aJ = setmetatable({}, { __mode = "k" })
	local aK = setmetatable({}, { __mode = "k" })
	local aL, aM = false, true
	local aN, aO, aP, aQ = false, false, false

	local function aR(aS, aT)
		if not ag("weaponskin", false) then
			return nil
		end
		if aS == "AUG" then
			return nil
		end
		return as[aS] or (aT and as[aT.ViewmodelCameraWeapon])
	end

	local function aS(aT)
		return ag("knifeskin", false) and ad(aT) and at or nil
	end

	local function aT()
		if not ag("weaponskin", false) then
			return nil
		end
		local aU
		for aV in as do
			if ae(aV) and (not aU or aV < aU) then
				aU = aV
			end
		end
		return aU and ae(aU), aU and as[aU], aU
	end

	local function aU()
		LPH_ATTRIBUTES(VM(NONE))
		if not aF then
			return
		end
		local aV, aW = pcall(function()
			return require(ai.Controllers.InventoryController).peekCurrentEquippedForMovement()
		end)
		if aV and type(aW) == "table" then
			for aX, aY in { "Viewmodel", "ViewModel", "CameraViewmodel" } do
				local aZ = aW[aY]
				if type(aZ) == "table" and getmetatable(aZ) == aF and aZ.Player == aj and not aH[aZ] then
					aH[aZ] = { skin = aZ.Skin, cameraWeapon = aZ.CameraModelWeapon }
				end
			end
		end
		if type(getgc) ~= "function" then
			return
		end
		local aX, aY = pcall(getgc, true)
		if not aX or type(aY) ~= "table" then
			return
		end
		for aZ, a_ in aY do
			if type(a_) == "table" and getmetatable(a_) == aF and a_.Player == aj and not a_.IsDestroyed and not aH[a_] then
				aH[a_] = { skin = a_.Skin, cameraWeapon = a_.CameraModelWeapon }
			end
		end
	end

	local function aV(aW)
		LPH_ATTRIBUTES(VM(NONE))
		if not aW or aW.Player ~= aj or aW.IsDestroyed or not aW.WeaponComponent then
			return false
		end
		local aX = aH[aW]
		if not aX then
			aX = { skin = aW.Skin, cameraWeapon = aW.CameraModelWeapon }
			aH[aW] = aX
		end
		local aY = aS(aW.Weapon)
		local aZ = (aY and aY.skin) or aR(aW.Weapon, aW.WeaponComponent) or aX.skin
		local a_ = (aY and aY.name) or aX.cameraWeapon
		local a0, a1, a2 = aT()
		local a3 = a2 and (a2 .. "\0" .. as[a2]) or nil
		if (aW.Skin == aZ and aW.CameraModelWeapon == a_ and aJ[aW] == a3) or aI[aW] then
			return false
		end
		local a4 = aW.WeaponComponent.Character or aj.Character
		if not a4 then
			return false
		end
		local a5 = aW.Skin
		local a6 = aW.CameraModelWeapon
		aI[aW] = true
		aW.Skin = aZ
		aW.CameraModelWeapon = a_
		local a7, a8 = pcall(aW.construct, aW, a4, aW.WeaponComponent)
		if a7 then
			aJ[aW] = a3
		else
			aW.Skin = a5
			aW.CameraModelWeapon = a6
			pcall(aW.construct, aW, a4, aW.WeaponComponent)
			warn("[vault.cc] Could not rebuild skinned viewmodel: " .. tostring(a8))
		end
		aI[aW] = nil
		return a7
	end

	local function aW()
		LPH_ATTRIBUTES(VM(NONE))
		if aL then
			return
		end
		assert(type(hookfunction) == "function", "Skin changer needs hookfunction.")
		local aX = ai.Classes.WeaponComponent.Classes:FindFirstChild("Viewmodel")
		if not aX then
			aX = ai:FindFirstChild("Viewmodel", true)
		end
		local aY = ai.Database.Components.Libraries:FindFirstChild("Skins")
		assert(aX and aX:IsA("ModuleScript"), "Viewmodel module was not found.")
		assert(aY and aY:IsA("ModuleScript"), "Skins module was not found.")
		aF = require(aX)
		aG = require(aY)
		assert(type(aF) == "table" and type(aF.new) == "function" and type(aF.equip) == "function" and type(aF.construct) == "function" and type(aF.addAttachments) == "function", "Viewmodel class is unsupported.")
		assert(type(aG.GetCameraModel) == "function" and type(aG.GetGloves) == "function", "Skins library is unsupported.")
		if not aQ then
			local aZ
			aZ = af.hook(aF.addAttachments, function(a_, a1)
				local a2, a3 = aT()
				if aM and a_ and a_.Player == aj and a2 and a3 then
					aK[a_] = true
					local a4, a5 = pcall(aG.GetGloves, a2, a3, 0.5)
					if not a4 or not a5 then
						return aZ(a_, a1)
					end
					local a6, a7 = pcall(aZ, a_, { Name = a2, Skin = a3, Float = 0.5 })
					if a6 then
						return a7
					end
					warn("[vault.cc] Glove override failed: " .. tostring(a7))
				end
				return aZ(a_, a1)
			end)
			assert(type(aZ) == "function", "Glove hook did not return the original function.")
			aQ = true
		end
		if not aP then
			local aZ
			aZ = af.hook(aF.construct, function(a_, ...)
				local a1 = aI[a_]
				aI[a_] = true
				aK[a_] = nil
				local a2, a3 = pcall(aZ, a_, ...)
				local a4, a5, a6 = aT()
				if a2 and aM and a_ and a_.Player == aj and a4 and not aK[a_] then
					local a7, a8 = pcall(a_.addAttachments, a_, { Name = a4, Skin = a5, Float = 0.5 })
					if not a7 then
						warn("[vault.cc] Could not attach gloves: " .. tostring(a8))
					end
				end
				if a2 and a_ and a_.Player == aj then
					aJ[a_] = a6 and (a6 .. "\0" .. a5) or nil
				end
				if not a1 then
					aI[a_] = nil
				end
				if not a2 then
					error(a3, 0)
				end
				return a3
			end)
			assert(type(aZ) == "function", "Viewmodel construct hook did not return the original function.")
			aP = true
		end
		if not aN then
			local aZ
			aZ = af.hook(aF.new, function(a_, a1, a2, ...)
				local a3 = aM and a_ and a_.Player == aj
				local a4 = a3 and aS(a1)
				local a5 = a3 and not a4 and aR(a1, a_) or nil
				local a6
				if a5 then
					local a7, a8 = pcall(aZ, a_, a1, a5, ...)
					if a7 then
						a6 = a8
					else
						warn("[vault.cc] Skin override failed: " .. tostring(a8))
						a6 = aZ(a_, a1, a2, ...)
					end
				else
					a6 = aZ(a_, a1, a2, ...)
				end
				if a3 and a6 then
					aH[a6] = { skin = a2, cameraWeapon = a6.CameraModelWeapon }
					if a4 then
						aV(a6)
					end
				end
				return a6
			end)
			assert(type(aZ) == "function", "Viewmodel hook did not return the original function.")
			aN = true
		end
		if not aO then
			local aZ
			aZ = af.hook(aF.equip, function(a_, ...)
				if aM and a_ and a_.Player == aj and not aI[a_] then
					aV(a_)
				end
				return aZ(a_, ...)
			end)
			assert(type(aZ) == "function", "Viewmodel equip hook did not return the original function.")
			aO = true
		end
		aL = true
		aU()
	end

	local function aX(aY, aZ)
		assert(aY ~= "AUG", "AUG is not available in Skin Changer.")
		aW()
		local a_ = ae(aY)
		if a_ then
			local a1, a2 = pcall(aG.GetGloves, a_, aZ, 0.5)
			assert(a1 and typeof(a2) == "Instance", "That glove and skin could not produce a glove asset.")
			return
		end
		local a1, a2 = pcall(aG.GetCameraModel, aY, aZ, 0.5)
		assert(a1 and typeof(a2) == "Instance" and a2:IsA("Model"), "That weapon and skin could not produce a camera model.")
		a2:Destroy()
	end

	local function aY()
		LPH_ATTRIBUTES(VM(NONE))
		if not aL and not aA() then
			return 0
		end
		aW()
		aU()
		local aZ = 0
		for a_ in aH do
			if aV(a_) then
				aZ += 1
			end
		end
		return aZ
	end

	local function aZ(a_)
		if au or type(a_) ~= "string" or a_ == "" then
			return
		end
		local a1, a2 = pcall(af.HttpService.JSONDecode, af.HttpService, a_)
		if not a1 or type(a2) ~= "table" then
			return
		end
		table.clear(as)
		if type(a2.overrides) == "table" then
			for a3, a4 in a2.overrides do
				if type(a3) == "string" and type(a4) == "string" then
					as[a3] = a4
				end
			end
		end
		if type(a2.knife) == "table" and type(a2.knife.name) == "string" and type(a2.knife.skin) == "string" then
			at = { name = a2.knife.name, skin = a2.knife.skin }
		else
			at = nil
		end
		aE()
	end

	al:AddButton({
		Text = "Apply weapon skin",
		Func = function()
			local a_, a1 = aw(), ay()
			local a2, a3 = pcall(function()
				assert(a_ and a1 and not ad(a_), "Select a weapon and skin.")
				aX(a_, a1)
				as[a_] = a1
				if Toggles.weaponskin and Toggles.weaponskin.SetValue then
					Toggles.weaponskin:SetValue(true)
				end
				aD()
				return aY()
			end)
			if a2 then
				af.notify((type(a3) == "number" and a3 > 0) and "Weapon skin applied." or "Weapon skin saved; re-equip to see it.")
			else
				af.notify(tostring(a3):gsub("^.-:%d+: ", ""), true)
			end
		end,
	})
	al:AddButton({
		Text = "Clear weapon skin",
		Func = function()
			local a_ = aw()
			if not a_ then
				af.notify("Select a weapon.", true)
				return
			end
			as[a_] = nil
			aD()
			local a1, a2 = pcall(aY)
			af.notify(a1 and ("Removed skin for " .. a_ .. ".") or tostring(a2), not a1)
		end,
	})
	am:AddButton({
		Text = "Apply knife skin",
		Func = function()
			local a_, a1 = ax(), az()
			local a2, a3 = pcall(function()
				assert(a_ and a1, "Select a knife and skin.")
				aX(a_, a1)
				at = { name = a_, skin = a1 }
				if Toggles.knifeskin and Toggles.knifeskin.SetValue then
					Toggles.knifeskin:SetValue(true)
				end
				aD()
				return aY()
			end)
			if a2 then
				af.notify((type(a3) == "number" and a3 > 0) and "Knife skin applied." or "Knife skin saved; re-equip to see it.")
			else
				af.notify(tostring(a3):gsub("^.-:%d+: ", ""), true)
			end
		end,
	})
	am:AddButton({
		Text = "Clear knife skin",
		Func = function()
			at = nil
			aD()
			local a_, a1 = pcall(aY)
			af.notify(a_ and "Removed knife skin." or tostring(a1), not a_)
		end,
	})

	if Options.skinitem then
		Options.skinitem:OnChanged(aB)
	end
	if Options.skinknife then
		Options.skinknife:OnChanged(aB)
	end
	if type(readfile) == "function" and type(isfile) == "function" and isfile("VaultCC_Bloxstrike_skins.json") then
		local a_, a1 = pcall(readfile, "VaultCC_Bloxstrike_skins.json")
		if a_ then
			aZ(a1)
		end
	end
	local function a_()
		local a1, a2 = pcall(aY)
		if not a1 then
			af.notify(tostring(a2):gsub("^.-:%d+: ", ""), true)
		end
	end
	if Toggles.weaponskin then
		Toggles.weaponskin:OnChanged(a_)
	end
	if Toggles.knifeskin then
		Toggles.knifeskin:OnChanged(a_)
	end

	aB()
	aE()

	af.skins = {
		applySaved = function()
			if aA() then
				pcall(aY)
			end
		end,
		step = function()
			LPH_ATTRIBUTES(VM(NONE))
		end,
		unload = function()
			aM = false
			if Toggles.weaponskin and Toggles.weaponskin.SetValue then
				Toggles.weaponskin:SetValue(false)
			end
			if Toggles.knifeskin and Toggles.knifeskin.SetValue then
				Toggles.knifeskin:SetValue(false)
			end
			pcall(aY)
		end,
	}
end

return ab
end function a.j()local ab=a.cache.j if not ab then ab={c=aa()}a.cache.j=ab end return ab.c end end do local function aa()
local ab = a.e()

local ac = {}

function ac.build(ad)
	local ae = ad.tv
	local af = ad.Players
	local ag = ad.LocalPlayer
	local ah = ad.CollectionService
	local ai = ad.Tabs

	local aj = ai.Misc:AddRightGroupbox("Spectators")
	aj:AddToggle("spectatorlist", { Text = "Spectator List", Default = true })

	local ak = Instance.new("ScreenGui")
	ak.Name = "vault_spectators"
	ak.ResetOnSpawn = false
	ak.Parent = game:GetService("CoreGui")
	local al = Instance.new("Frame")
	al.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
	al.BorderSizePixel = 0
	al.Position = UDim2.fromOffset(16, 220)
	al.Size = UDim2.fromOffset(180, 28)
	al.Visible = false
	al.Parent = ak
	local am = Instance.new("TextLabel")
	am.BackgroundTransparency = 1
	am.Size = UDim2.new(1, -8, 0, 22)
	am.Position = UDim2.fromOffset(8, 2)
	am.Font = Enum.Font.Code
	am.TextSize = 14
	am.TextXAlignment = Enum.TextXAlignment.Left
	am.TextColor3 = Color3.fromRGB(235, 235, 235)
	am.Text = "spectators"
	am.Parent = al
	local an = Instance.new("TextLabel")
	an.BackgroundTransparency = 1
	an.Position = UDim2.fromOffset(8, 22)
	an.Size = UDim2.new(1, -12, 1, -26)
	an.Font = Enum.Font.Code
	an.TextSize = 13
	an.TextXAlignment = Enum.TextXAlignment.Left
	an.TextYAlignment = Enum.TextYAlignment.Top
	an.TextColor3 = Color3.fromRGB(180, 180, 180)
	an.TextWrapped = true
	an.Text = "none"
	an.Parent = al

	local function ao()
		local ap = {}
		local aq = ag:GetAttribute("Spectators")
		if type(aq) == "number" and aq > 0 then
			ap[#ap + 1] = string.format("%d watching", aq)
		end
		for ar, as in af:GetPlayers() do
			if as ~= ag and as:GetAttribute("Team") == "Spectators" then
				ap[#ap + 1] = as.Name
			end
		end
		if #ap == 0 then
			return "none"
		end
		return table.concat(ap, "\n")
	end

	ad.misc = {
		apply = function() end,
		step = function()
			LPH_ATTRIBUTES(VM(NONE))
			local ap = ae("spectatorlist", true)
			pcall(function()
				al.Visible = ap
				if ap then
					an.Text = ao()
					al.Size = UDim2.fromOffset(180, 28 + math.max(18, an.TextBounds.Y + 8))
				end
			end)
		end,
		unload = function()
			ak:Destroy()
		end,
	}
end

return ac
end function a.k()local ab=a.cache.k if not ab then ab={c=aa()}a.cache.k=ab end return ab.c end end do local function aa()
local ab = a.e()








local ac = {}

local ad = 32 
local ae = 14
local af = 4.5

function ac.build(ag)
	local ah = ag.tv
	local ai = ag.ov
	local aj = ag.Players
	local ak = ag.LocalPlayer
	local al = ag.ReplicatedStorage

	local am = true
	local an = setmetatable({}, { __mode = "k" }) 
	local ao = 2.9 
	local ap = false

	local function aq()
		return al:FindFirstChild("_PVS_CulledCharacters")
	end

	local function ar(as)
		return not ab.sameTeam(as, ak)
	end

	local function as(at)
		LPH_ATTRIBUTES(VM(NONE))
		if not am or type(at) ~= "table" or not ah("ESPFogOfWar", true) then
			return
		end
		local au = os.clock()
		local av = at.Parent
		if typeof(av) == "Instance" then
			
			local aw = av:FindFirstAncestorOfClass("Model")
			local ax = aw and ab.ownerOf(aw)
			local ay = ax and an[ax]
			if ay then
				ay.at = au
			end
			return
		end
		local aw = at.Position
		if typeof(aw) ~= "Vector3" or at.Class ~= "FloorSounds" then
			return
		end
		local ax = aw + Vector3.new(0, ao, 0)
		
		local ay = workspace:FindFirstChild("Characters")
		if ay then
			for az, aA in ay:GetChildren() do
				local aB = aA:FindFirstChild("HumanoidRootPart")
				if aB then
					local aC = aB.Position - aw
					local aD = Vector3.new(aC.X, 0, aC.Z).Magnitude
					if aD < af and math.abs(aC.Y) < 6 then
						if aD < 1.5 and aC.Y > 1 and aC.Y < 4.5 then
							ao += (aC.Y - ao) * 0.2
						end
						return
					end
				end
			end
		end
		local az = aq()
		if not az then
			return
		end
		local aA, aB, aC, aD = nil, math.huge, nil, 0
		for aE, aF in az:GetChildren() do
			local aG = aF:IsA("Model") and ab.ownerOf(aF)
			if not aG or aG == ak then
				continue
			end
			if ab.isDead(aG, aF) or not ar(aG) then
				continue
			end
			aD += 1
			aC = aG
			local aH = an[aG]
			if aH then
				local aI = ad * (au - aH.at) + ae
				local aJ = (aH.pos - ax).Magnitude
				if aJ <= aI and aJ / aI < aB then
					aA, aB = aG, aJ / aI
				end
			end
		end
		if not aA and aD == 1 then
			aA = aC
		end
		if not aA then
			return
		end
		local aE = an[aA]
		if not aE then
			aE = {}
			an[aA] = aE
		end
		aE.pos, aE.at, aE.heard = ax, au, true
		local aF = ab.characterOf(aA)
		if aA:IsA("Player") then
			aF = aA.Character
		end
		local aG = aF and aF.Parent == az and aF:FindFirstChild("HumanoidRootPart")
		if aG then
			pcall(function()
				aF:PivotTo(aF:GetPivot() + (ax - aG.Position))
			end)
		end
	end

	local function at()
		if ap then
			return
		end
		local au = pcall(function()
			local au = require(al.Database.Security.Remotes)
			au.Sound.ReplicateSound.Listen(as)
		end)
		ap = au
	end

	local au = 0

	ag.fow = {
		
		step = function()
			LPH_ATTRIBUTES(VM(NONE))
			if not am or not ah("ESPFogOfWar", true) then
				return
			end
			if not ap and os.clock() > au then
				au = os.clock() + 5
				at()
			end
			local av = workspace:FindFirstChild("Characters")
			if not av then
				return
			end
			local aw = os.clock()
			for ax, ay in av:GetChildren() do
				local az = ay:IsA("Model") and ay:FindFirstChild("HumanoidRootPart")
				local aA = az and ab.ownerOf(ay)
				if aA and aA ~= ak then
					local aB = an[aA]
					if not aB then
						aB = {}
						an[aA] = aB
					end
					aB.pos, aB.at, aB.heard = az.Position, aw, false
				end
			end
			
			local ax = aq()
			for ay, az in ax and ax:GetChildren() or {} do
				local aA = az:IsA("Model") and az:FindFirstChild("HumanoidRootPart")
				local aB = aA and ab.ownerOf(az)
				if aB and not an[aB] then
					an[aB] = { pos = aA.Position, at = aw - 5, heard = false }
				end
			end
		end,
		
		hidden = function(av)
			LPH_ATTRIBUTES(VM(NONE))
			local aw = aq()
			if not aw then
				return av
			end
			local ax = tonumber(ai("ESPFogTimeout", 10)) or 10
			local ay = os.clock()
			for az, aA in aw:GetChildren() do
				local aB = aA:IsA("Model") and ab.ownerOf(aA)
				local aC = aB and an[aB]
				if
					not aB
					or not aC
					or ab.isDead(aB, aA)
					or not ar(aB)
					or (ax > 0 and ay - aC.at > ax)
				then
					av[#av + 1] = aA.Name
				end
			end
			return av
		end,
		unload = function()
			am = false
		end,
	}
end

return ac
end function a.l()local ab=a.cache.l if not ab then ab={c=aa()}a.cache.l=ab end return ab.c end end do local function aa()
local ab = debug.profilebegin or function() end
local ac = debug.profileend or function() end

local function ad(ae, af, ag)
	return function(...)
		ab(ae)
		if ag == 2 then
			local ah, ai = af(...)
			ac()
			return ah, ai
		end
		local ah = af(...)
		ac()
		return ah
	end
end

return {
	begin = ab,
	stop = ac,
	wrap = ad,
}
end function a.m()local ab=a.cache.m if not ab then ab={c=aa()}a.cache.m=ab end return ab.c end end do local function aa()
local ab = workspace.Raycast
local ac = a.m()

local ad = {
	Vector3.new(1, 0, 0),
	Vector3.new(-1, 0, 0),
	Vector3.new(0, 0, 1),
	Vector3.new(0, 0, -1),
	Vector3.new(0, 1, 0),
	Vector3.new(0, -1, 0),
}
local ae = {
	Vector3.new(0.5, 0, 0),
	Vector3.new(-0.5, 0, 0),
	Vector3.new(0, 0, 0.5),
	Vector3.new(0, 0, -0.5),
	Vector3.new(0, 0.5, 0),
	Vector3.new(0, -0.5, 0),
}
local af = {
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

local function ag(...)
	local ah = {}
	for ai = 1, select("#", ...) do
		local aj = select(ai, ...)
		for ak = 1, #aj do
			ah[#ah + 1] = aj[ak]
		end
	end
	return ah
end

local ah = {
	Low = ad,
	Medium = ag(ae, ad),
	High = ag(ae, af, ad),
}

local ai = RaycastParams.new()
ai.FilterType = Enum.RaycastFilterType.Exclude
ai.IgnoreWater = true

local function aj(ak, al, am, an, ao, ap, aq)
	LPH_ATTRIBUTES(VM(NONE))
	if typeof(ak) ~= "Vector3" or typeof(al) ~= "Vector3" then
		return nil
	end
	if ao(ak, al) then
		return ak
	end
	am = tonumber(am) or 0
	if am <= 0 then
		return nil
	end
	aq = tonumber(aq)
	local ar = ah[an] or ah.High
	ai.FilterDescendantsInstances = ap or {}
	for as = 1, #ar do
		local at = ar[as] * am
		if aq and math.abs(at.Y) > aq then
			at = Vector3.new(at.X, math.sign(at.Y) * aq, at.Z)
		end
		local au = ak + at
		if not ab(workspace, ak, au - ak, ai) and ao(au, al) then
			return au
		end
	end
	return nil
end

return {
	solve = ac.wrap("manip.solve", aj, 1),
}
end function a.n()local ab=a.cache.n if not ab then ab={c=aa()}a.cache.n=ab end return ab.c end end end
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


local aa = getgenv()
local ab = "__vaultcc_bs"
if aa[ab] then
	pcall(aa[ab].unload)
	aa[ab] = nil
end

local ac = game:GetService("Players")
local ad = game:GetService("HttpService")
local ae = game:GetService("RunService")
local af = game:GetService("UserInputService")
local ag = game:GetService("Lighting")
local ah = game:GetService("CollectionService")
local ai = game:GetService("ReplicatedStorage")
local aj = ac.LocalPlayer

local ak, al, am = loadstring(game:HttpGet("https://raw.githubusercontent.com/ttokennxyz/vaultcc/refs/heads/main/uilib.lua"))()


local an, ao = pcall(function()
	return a.a()
end)
if not an or type(ao) ~= "table" then
	ao = nil
end

local ap = a.b()
local aq = a.c()

local function ar(as, at)
	LPH_ATTRIBUTES(VM(NONE))
	return ap.tv(as, at)
end

local function as(at, au)
	LPH_ATTRIBUTES(VM(NONE))
	return ap.ov(at, au)
end

local at = a.d().create({
	title = "Bloxstrike - vault.cc",
	folder = "VaultCC/Bloxstrike",
	tabs = { "Combat", "ESP", "Visuals", "Misc", "Settings" },
	keybind = "menubind",
	ignore = { "menubind" },
	afterLoad = function(at)
		if at.skins and at.skins.applySaved then
			at.skins.applySaved()
		end
		if at.visuals and at.visuals.applyESP then
			at.visuals.applyESP()
		end
		if at.misc and at.misc.apply then
			at.misc.apply()
		end
	end,
})

local au = a.f()
local av = a.g()
local aw = a.h()
local ax = a.i()
local ay = a.j()
local az = a.k()
local aA = a.l()

local aB = {
	Players = ac,
	RunService = ae,
	UserInputService = af,
	Lighting = ag,
	CollectionService = ah,
	ReplicatedStorage = ai,
	LocalPlayer = aj,
	Camera = workspace.CurrentCamera,
	HttpService = ad,
	ESP = ao,
	Library = ak,
	ThemeManager = al,
	SaveManager = am,
	tv = ar,
	ov = as,
	cloneOriginal = aq.cloneOriginal,
	hook = aq.hook,
	wrap = aq.wrap,
	findGcFunction = aq.findGcFunction,
	manipulation = a.n(),
	notify = function(aB, aC)
		if ak and ak.Notify then
			pcall(ak.Notify, ak, aB, aC and 4 or 3)
		end
	end,
}

at.build(aB)
au.build(aB)
av.build(aB)
aw.build(aB)
ax.build(aB)
ay.build(aB)
az.build(aB)
aA.build(aB)
at.finish(aB)

if aB.visuals and aB.visuals.applyESP then
	aB.visuals.applyESP()
end
if aB.misc and aB.misc.apply then
	aB.misc.apply()
end

local aC = false
local aD
local function aE()
	if aC then
		return
	end
	aC = true
	if aD then
		aD:Disconnect()
		aD = nil
	end
	pcall(function()
		ae:UnbindFromRenderStep("vault_cam")
	end)
	if aB.combat and aB.combat.unload then
		aB.combat.unload()
	end
	if aB.visuals and aB.visuals.unload then
		aB.visuals.unload()
	end
	if aB.movement and aB.movement.unload then
		aB.movement.unload()
	end
	if aB.skins and aB.skins.unload then
		aB.skins.unload()
	end
	if aB.misc and aB.misc.unload then
		aB.misc.unload()
	end
	if aB.fow then
		aB.fow.unload()
	end
	if ao and ao.Unload then
		pcall(function()
			ao:Unload()
		end)
	end
	aq.restoreAll()
	if aa[ab] and aa[ab].ctx == aB then
		aa[ab] = nil
	end
end

local function aF()
	if setthreadidentity then
		pcall(setthreadidentity, 8)
	elseif setthreadcontext then
		pcall(setthreadcontext, 8)
	end
end

aD = ae.Heartbeat:Connect(function(aG)
	LPH_ATTRIBUTES(VM(NONE))
	aF()
	aB.Camera = workspace.CurrentCamera
	if aB.combat and aB.combat.step then
		aB.combat.step(aG)
	end
	if aB.visuals and aB.visuals.step then
		aB.visuals.step(aG)
	end
	if aB.movement and aB.movement.step then
		aB.movement.step(aG)
	end
	if aB.skins and aB.skins.step then
		aB.skins.step(aG)
	end
	if aB.misc and aB.misc.step then
		aB.misc.step(aG)
	end
	if aB.fow then
		aB.fow.step()
	end
end)

ae:BindToRenderStep("vault_cam", Enum.RenderPriority.Last.Value + 1, function()
	LPH_ATTRIBUTES(VM(NONE))
	aF()
	aB.Camera = workspace.CurrentCamera
	if aB.visuals and aB.visuals.applyCamera then
		aB.visuals.applyCamera(aB.Camera)
	end
	if aB.combat and aB.combat.renderStep then
		aB.combat.renderStep()
	end
	if aB.visuals and aB.visuals.renderStep then
		aB.visuals.renderStep()
	end
	if aB.movement and aB.movement.renderStep then
		aB.movement.renderStep()
	end
end)

ak:OnUnload(aE)
aa[ab] = {
	ctx = aB,
	unload = function()
		pcall(ak.Unload, ak)
		aE()
	end,
}
if ak and ak.KeybindFrame then
	ak.KeybindFrame.Visible = ar("ShowKeybindList", true)
end
ak:Notify("Bloxstrike loaded.")
