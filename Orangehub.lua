-- ORANGE HUB CORE
local LP = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Настройки
_G.WalkSpeedValue = 100
local Modules = {
    InfJump = false,
    FullBright = false,
    ESP = false
}

-- [ESP ЛОГИКА]
-- Подсвечиваем: Mammoth, Bear, Cultist
-- Игнорируем: Mammoth Tusk, Wolf, Bunny Burrow
local function applyESP(obj)
    local name = obj.Name:lower()
    if (name:find("mammoth") and not name:find("tusk")) or name:find("bear") or name:find("cultist") then
        if not obj:FindFirstChild("OrangeHighlight") then
            local hi = Instance.new("Highlight", obj)
            hi.Name = "OrangeHighlight"
            hi.FillColor = Color3.fromRGB(255, 165, 0)
            hi.OutlineColor = Color3.new(1, 1, 1)
        end
    end
end

task.spawn(function()
    while true do
        if Modules.ESP then
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Model") then applyESP(v) end
            end
        else
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "OrangeHighlight" then v:Destroy() end
            end
        end
        task.wait(2)
    end
end)

-- [ОСТАЛЬНЫЕ ФУНКЦИИ]
UIS.JumpRequest:Connect(function()
    if Modules.InfJump and LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- [ИНТЕРФЕЙС]
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "OrangeHub_V4"

local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 400, 0, 250)
Main.Position = UDim2.new(0.5, -200, 0.5, -125)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ORANGE HUB (CORE)"
Title.TextColor3 = Color3.fromRGB(255, 165, 0)
Title.BackgroundTransparency = 1
Title.Font = "GothamBold"
Title.TextSize = 18

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)

local function addBtn(txt, cb)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    local s = false
    b.MouseButton1Click:Connect(function()
        s = not s
        b.BackgroundColor3 = s and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(40, 40, 40)
        cb(s)
    end)
end

addBtn("Speed Hack (100)", function(v)
    task.spawn(function()
        while v do
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid.WalkSpeed = _G.WalkSpeedValue
            end
            task.wait(0.1)
        end
    end)
end)
addBtn("Infinite Jump", function(v) Modules.InfJump = v end)
addBtn("FullBright", function(v)
    Modules.FullBright = v
    if v then Lighting.Ambient = Color3.new(1,1,1) else Lighting.Ambient = Color3.new(0.5,0.5,0.5) end
end)
addBtn("ESP (Mammoth/Bear/Cultist)", function(v) Modules.ESP = v end)

print("🍊 Orangehub.lua успешно загружен!")
