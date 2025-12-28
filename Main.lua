-- ORANGE HUB V4 [CORE EDITION]
local LP = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

-- Удаляем старое меню
if game.CoreGui:FindFirstChild("OrangeHub_V4") then 
    game.CoreGui["OrangeHub_V4"]:Destroy() 
end

-- НАСТРОЙКИ ЯДРА
_G.WalkSpeedValue = 100
_G.FlySpeedValue = 50
local Modules = {
    InfJump = false,
    FullBright = false,
    Fly = false,
    ESP = false
}

-- [ЛОГИКА: ПРЫЖОК]
UIS.JumpRequest:Connect(function()
    if Modules.InfJump and LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- [ЛОГИКА: СВЕТ]
task.spawn(function()
    while true do
        if Modules.FullBright then
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.GlobalShadows = false
        end
        task.wait(0.5)
    end
end)

-- [ЛОГИКА: ПОЛЕТ]
RunService.Stepped:Connect(function()
    local Char = LP.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    local Hum = Char and Char:FindFirstChildOfClass("Humanoid")
    if Modules.Fly and Root and Hum then
        local BV = Root:FindFirstChild("FlyVel") or Instance.new("BodyVelocity", Root)
        local BG = Root:FindFirstChild("FlyGyro") or Instance.new("BodyGyro", Root)
        BV.Name = "FlyVel"
        BG.Name = "FlyGyro"
        BV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        BG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        Hum.PlatformStand = true
        local cam = workspace.CurrentCamera
        if Hum.MoveDirection.Magnitude > 0 then
            local rawMove = cam.CFrame:VectorToObjectSpace(Hum.MoveDirection)
            local dir = (cam.CFrame.LookVector * -rawMove.Z) + (cam.CFrame.RightVector * rawMove.X)
            BV.Velocity = dir.Unit * _G.FlySpeedValue
        else
            BV.Velocity = Vector3.new(0, 0.1, 0)
        end
        BG.CFrame = cam.CFrame
    else
        if Root and Root:FindFirstChild("FlyVel") then Root.FlyVel:Destroy() Root.FlyGyro:Destroy() end
        if Hum then Hum.PlatformStand = false end
    end
end)

-- [ЛОГИКА: ESP (МАМОНТЫ, МЕДВЕДИ, КУЛЬТИСТЫ)]
local function createESP(part, color, name)
    if part:FindFirstChild("OrangeESP") then return end
    local box = Instance.new("BoxHandleAdornment", part)
    box.Name = "OrangeESP"
    box.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Transparency = 0.5
    box.Color3 = color
    box.Adornee = part
end

task.spawn(function()
    while true do
        if Modules.ESP then
            for _, obj in pairs(workspace:GetChildren()) do
                if obj:IsA("Model") and obj.PrimaryPart then
                    local lowerName = obj.Name:lower()
                    -- Фильтр по твоим предпочтениям
                    if (lowerName:find("mammoth") and not lowerName:find("tusk")) or 
                       lowerName:find("bear") or 
                       lowerName:find("cultist") then
                        createESP(obj.PrimaryPart, Color3.fromRGB(255, 165, 0), obj.Name)
                    end
                end
            end
        else
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "OrangeESP" then v:Destroy() end
            end
        end
        task.wait(2)
    end
end)

-- [ИНТЕРФЕЙС]
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "OrangeHub_V4"

local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 450, 0, 300)
Main.Position = UDim2.new(0.5, -225, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)

local function addToggle(text, callback)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(45, 45, 48)
        callback(state)
    end)
end

addToggle("Speed Hack", function(v) 
    task.spawn(function()
        while v do
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid.WalkSpeed = _G.WalkSpeedValue
            end
            task.wait(0.1)
        end
    end)
end)
addToggle("Fly Mode", function(v) Modules.Fly = v end)
addToggle("Infinite Jump", function(v) Modules.InfJump = v end)
addToggle("FullBright", function(v) Modules.FullBright = v end)
addToggle("ESP (Bears/Mammoth/Cultist)", function(v) Modules.ESP = v end)

print("🍊 Orange Core запущен!")
