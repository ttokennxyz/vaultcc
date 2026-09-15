local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local repo = "https://raw.githubusercontent.com/ttokennxyz/vaultcc/refs/heads/main/"
local queueOnTeleport = queue_on_teleport or (syn and syn.queue_on_teleport) or queueonteleport

local function load(filename)
  loadstring(game:HttpGet(repo .. filename .. ".lua"))()
end

local function queueLoad(filename)
	local src = 'loadstring(game:HttpGet("' .. repo .. filename .. '.lua"))()'
	local key = getgenv().script_key
	if type(key) == "string" and key ~= "" then
		src = "getgenv().script_key = " .. string.format("%q", key) .. "\n" .. src
	end
	if queueOnTeleport then
		queueOnTeleport(src)
	end
end

local function fflagEnabled()
	if not getfflag then
		return false
	end
	local ok, value = pcall(getfflag, "DebugRunParallelLuaOnMainThread")
	if not ok then
		return false
	end
	return value == true or value == "true" or value == "True"
end

local function enableFflag()
	if not setfflag then
		return
	end
	pcall(setfflag, "DebugRunParallelLuaOnMainThread", true)
end

local function inLobby()
	local PlayerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
	local left = PlayerGui.LoadoutMenu.Left
	local center = left.Center
    local crate = left.Bottom.CrateFrame
    local loadouts = center.Loadouts
    local mainmenu = center.MainMenu
    local play = center.PlayFrame
	return crate.Visible or loadouts.Visible or mainmenu.Visible or play.Visible
end

local lobby = inLobby()
if lobby then
	enableFflag()
end
local canLoad = lobby or fflagEnabled()

local gui = Instance.new("ScreenGui")
gui.Name = "vaultcc"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local layer1Color = Color3.fromRGB(24, 24, 24)
local layer2Color = Color3.fromRGB(15, 15, 15)
local layer3Color = Color3.fromRGB(20, 20, 20)
local blueAccent = Color3.fromRGB(35, 110, 255)
local borderColor = Color3.fromRGB(45, 45, 45)
local textColor = Color3.fromRGB(240, 240, 240)
local font = Enum.Font.Code

local mainFrame = Instance.new("Frame")
mainFrame.Name = "BaseLayer"
mainFrame.Size = UDim2.new(0, 420, 0, 160)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -80)
mainFrame.BackgroundColor3 = layer1Color
mainFrame.BorderColor3 = blueAccent
mainFrame.BorderSizePixel = 1
mainFrame.Parent = gui

local headerLabel = Instance.new("TextLabel")
headerLabel.Name = "HeaderLabel"
headerLabel.Size = UDim2.new(1, -20, 0, 25)
headerLabel.Position = UDim2.new(0, 10, 0, 5)
headerLabel.BackgroundTransparency = 1
headerLabel.Text = "Operation One - vault.cc"
headerLabel.TextColor3 = textColor
headerLabel.Font = font
headerLabel.TextSize = 14
headerLabel.TextXAlignment = Enum.TextXAlignment.Left
headerLabel.Parent = mainFrame

local innerContentFrame = Instance.new("Frame")
innerContentFrame.Name = "ContentLayer"
innerContentFrame.Size = UDim2.new(1, -20, 1, -40)
innerContentFrame.Position = UDim2.new(0, 10, 0, 30)
innerContentFrame.BackgroundColor3 = layer2Color
innerContentFrame.BorderColor3 = borderColor
innerContentFrame.BorderSizePixel = 1
innerContentFrame.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -20, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = canLoad and "Which script would you like to load?" or "Load from the lobby first"
titleLabel.TextColor3 = textColor
titleLabel.Font = font
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = innerContentFrame

local liteBtn = Instance.new("TextButton")
liteBtn.Name = "LiteButton"
liteBtn.Size = UDim2.new(0, 180, 0, 35)
liteBtn.Position = UDim2.new(0, 10, 0, 55)
liteBtn.BackgroundColor3 = layer3Color
liteBtn.BorderColor3 = borderColor
liteBtn.BorderSizePixel = 1
liteBtn.Text = "Lite"
liteBtn.TextColor3 = canLoad and textColor or Color3.fromRGB(100, 100, 100)
liteBtn.Font = font
liteBtn.TextSize = 14
liteBtn.Parent = innerContentFrame
liteBtn.Interactable = canLoad

local fullBtn = Instance.new("TextButton")
fullBtn.Name = "FullButton"
fullBtn.Size = UDim2.new(0, 180, 0, 35)
fullBtn.Position = UDim2.new(1, -190, 0, 55)
fullBtn.BackgroundColor3 = layer3Color
fullBtn.BorderColor3 = borderColor
fullBtn.BorderSizePixel = 1
fullBtn.Text = "Full"
fullBtn.TextColor3 = canLoad and textColor or Color3.fromRGB(100, 100, 100)
fullBtn.Font = font
fullBtn.TextSize = 14
fullBtn.Parent = innerContentFrame
fullBtn.Interactable = canLoad

local function applyHoverEffect(button)
    button.MouseEnter:Connect(function()
        button.BorderColor3 = blueAccent
    end)
    button.MouseLeave:Connect(function()
        button.BorderColor3 = borderColor
    end)
end

if canLoad then
	applyHoverEffect(liteBtn)
	applyHoverEffect(fullBtn)
end

local function selectScript(filename)
	if not canLoad then
		return
	end
	if lobby then
		enableFflag()
		queueLoad(filename)
		titleLabel.Text = "Loaded, join a match"
		liteBtn.Interactable = false
		fullBtn.Interactable = false
		liteBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
		fullBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
		return
	end
	gui:Destroy()
	load(filename)
end

-- Button Logic
liteBtn.MouseButton1Click:Connect(function() -- lite
	selectScript("op1_lite")
end)

fullBtn.MouseButton1Click:Connect(function() -- full
	selectScript("op1_full")
end)
