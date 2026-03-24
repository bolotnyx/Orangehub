-- [[ ORANGE HUB V5 - ULTRA PREMIUM ]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer

-- CLEAN
if LP.PlayerGui:FindFirstChild("OrangeHub_V5") then
    LP.PlayerGui.OrangeHub_V5:Destroy()
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "OrangeHub_V5"
gui.Parent = LP.PlayerGui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- BLUR
local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0

TweenService:Create(blur, TweenInfo.new(0.4), {Size = 12}):Play()

-- MAIN
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 0, 0, 0)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.BackgroundColor3 = Color3.fromRGB(18,18,20)
Main.ZIndex = 10
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,14)

-- GLOW
local stroke = Instance.new("UIStroke", Main)
stroke.Color = Color3.fromRGB(255,140,0)
stroke.Thickness = 2
stroke.Transparency = 0.3

-- OPEN ANIMATION
TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 560, 0, 400)
}):Play()

-- SIDEBAR
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(25,25,28)
Sidebar.ZIndex = 11
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0,14)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1,0,0,60)
Title.Text = "ORANGE HUB"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(255,170,0)
Title.BackgroundTransparency = 1
Title.ZIndex = 12

-- CONTAINER
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -200, 1, -70)
Container.Position = UDim2.new(0, 190, 0, 60)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 3
Container.ZIndex = 11

local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0,12)

-- FIX CLICK LAYER
local function makeButtonClickable(obj)
    obj.Active = true
    obj.ZIndex = 15
end

-- INPUT
local function createInput(name, callback)
    local box = Instance.new("TextBox", Container)
    box.Size = UDim2.new(1, -10, 0, 50)
    box.BackgroundColor3 = Color3.fromRGB(40,40,45)
    box.PlaceholderText = "⚙ "..name
    box.TextColor3 = Color3.new(1,1,1)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 14
    box.ZIndex = 15
    makeButtonClickable(box)
    Instance.new("UICorner", box)

    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)
        if num then callback(num) end
        box.Text = ""
    end)
end

-- PREMIUM TOGGLE (FIXED)
local function createToggle(name, globalVar, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -10, 0, 50)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,45)
    btn.Text = "   "..name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 15
    makeButtonClickable(btn)
    Instance.new("UICorner", btn)

    local toggle = Instance.new("Frame", btn)
    toggle.Size = UDim2.new(0,50,0,24)
    toggle.Position = UDim2.new(1,-60,0.5,-12)
    toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
    toggle.ZIndex = 16
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame", toggle)
    knob.Size = UDim2.new(0,22,0,22)
    knob.Position = UDim2.new(0,1,0.5,-11)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.ZIndex = 17
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local state = _G[globalVar] or false

    local function update()
        TweenService:Create(knob, TweenInfo.new(0.25), {
            Position = state and UDim2.new(1,-23,0.5,-11) or UDim2.new(0,1,0.5,-11)
        }):Play()

        TweenService:Create(toggle, TweenInfo.new(0.25), {
            BackgroundColor3 = state and Color3.fromRGB(255,140,0) or Color3.fromRGB(70,70,70)
        }):Play()
    end

    update()

    btn.MouseButton1Click:Connect(function()
        state = not state
        _G[globalVar] = state
        update()
        callback(state)
    end)
end

-- TABS
local TabHolder = Instance.new("Frame", Sidebar)
TabHolder.Size = UDim2.new(1, 0, 1, -80)
TabHolder.Position = UDim2.new(0, 0, 0, 70)
TabHolder.BackgroundTransparency = 1
TabHolder.ZIndex = 12

local TabLayout = Instance.new("UIListLayout", TabHolder)
TabLayout.Padding = UDim.new(0,8)

local function clear()
    for _, v in ipairs(Container:GetChildren()) do
        if not v:IsA("UIListLayout") then
            v:Destroy()
        end
    end
end

local function showTab(name)
    clear()

    if name == "Player" then
        createInput("Walk Speed", function(v) print("Speed:", v) end)
        createToggle("Enable Walk Speed", "SpeedEnabled", function(v) print(v) end)

        createInput("Fly Speed", function(v) print("Fly:", v) end)
        createToggle("Enable Fly", "FlyEnabled", function(v) print(v) end)

    elseif name == "Combat" then
        createToggle("Godmode", "GodmodeEnabled", function(v) print(v) end)
        createToggle("ESP Monsters", "MonsterESPActive", function(v) print(v) end)
    end
end

local function addTab(name)
    local btn = Instance.new("TextButton", TabHolder)
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,38)
    btn.ZIndex = 13
    makeButtonClickable(btn)
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        showTab(name)
    end)
end

addTab("Player")
addTab("Combat")

task.wait()
showTab("Player")
