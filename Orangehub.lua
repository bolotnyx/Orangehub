-- ORANGE HUB V4 [BEAUTIFUL CORE]
local LP = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- НАСТРОЙКИ
_G.WalkSpeedValue = 100
local Modules = {
    InfJump = false,
    FullBright = false,
    ESP = false
}

-- [ЛОГИКА ESP]
local function applyESP(obj)
    local name = obj.Name:lower()
    -- Твои фильтры: Мамонты (без бивней), Медведи, Культисты
    if (name:find("mammoth") and not name:find("tusk")) or name:find("bear") or name:find("cultist") then
        if not obj:FindFirstChild("OrangeHighlight") then
            local hi = Instance.new("Highlight", obj)
            hi.Name = "OrangeHighlight"
            hi.FillColor = Color3.fromRGB(255, 165, 0)
            hi.OutlineColor = Color3.new(1, 1, 1)
            hi.Adornee = obj
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

-- [УДАЛЕНИЕ СТАРОГО UI]
if game.CoreGui:FindFirstChild("OrangeHub_V4") then 
    game.CoreGui["OrangeHub_V4"]:Destroy() 
end

-- [СОЗДАНИЕ UI]
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "OrangeHub_V4"
gui.ResetOnSpawn = false

local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 27)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Оранжевая полоска
local Accent = Instance.new("Frame", Main)
Accent.Size = UDim2.new(1, 0, 0, 3)
Accent.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
Accent.ZIndex = 11
Instance.new("UICorner", Accent)

-- САЙДБАР
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(33, 33, 35)
Sidebar.ZIndex = 2
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "ORANGE HUB"
Title.TextColor3 = Color3.fromRGB(255, 165, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.ZIndex = 3

local TabHolder = Instance.new("Frame", Sidebar)
TabHolder.Size = UDim2.new(1, -10, 1, -80)
TabHolder.Position = UDim2.new(0, 5, 0, 70)
TabHolder.BackgroundTransparency = 1
TabHolder.ZIndex = 3
local TabList = Instance.new("UIListLayout", TabHolder)
TabList.Padding = UDim.new(0, 8)

-- КОНТЕЙНЕР ФУНКЦИЙ
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -170, 1, -70)
Container.Position = UDim2.new(0, 160, 0, 55)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Container.ZIndex = 5
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 10)

-- Функция создания кнопок (Тот самый стиль)
local function createToggle(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 6
    Instance.new("UICorner", btn)

    local bg = Instance.new("Frame", btn)
    bg.Size = UDim2.new(0, 34, 0, 18)
    bg.Position = UDim2.new(1, -45, 0.5, -9)
    bg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    bg.ZIndex = 7
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", bg)
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = UDim2.new(0, 3, 0.5, -6)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    dot.ZIndex = 8
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local enabled = false
    btn.MouseButton1Down:Connect(function()
        enabled = not enabled
        dot:TweenPosition(enabled and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6), "Out", "Sine", 0.15, true)
        bg.BackgroundColor3 = enabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(60, 60, 60)
        callback(enabled)
    end)
end

-- ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК
local function showTab(name)
    for _, v in ipairs(Container:GetChildren()) do 
        if not v:IsA("UIListLayout") then v:Destroy() end 
    end
    
    if name == "Player" then
        createToggle("Speed Hack (100)", function(v)
            _G.SpeedEnabled = v
            task.spawn(function()
                while _G.SpeedEnabled do
                    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                        LP.Character.Humanoid.WalkSpeed = _G.WalkSpeedValue
                    end
                    task.wait(0.1)
                end
                if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.WalkSpeed = 16 end
            end)
        end)
        createToggle("Infinite Jump", function(v) Modules.InfJump = v end)
        createToggle("FullBright", function(v) 
            Modules.FullBright = v 
            if v then Lighting.Ambient = Color3.new(1,1,1) else Lighting.Ambient = Color3.new(0.5,0.5,0.5) end
        end)
    elseif name == "Combat" then
        createToggle("ESP (Bears/Mammoths/Cultists)", function(v) Modules.ESP = v end)
    end
end

local function addSidebarButton(name)
    local t = Instance.new("TextButton", TabHolder)
    t.Size = UDim2.new(1, 0, 0, 45)
    t.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    t.Text = name
    t.TextColor3 = Color3.new(1, 1, 1)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 16
    t.ZIndex = 4
    Instance.new("UICorner", t)
    t.MouseButton1Click:Connect(function() showTab(name) end)
end

-- ЗАПУСК
addSidebarButton("Player")
addSidebarButton("Combat")
showTab("Player")

-- ЛОГИКА ПРЫЖКА
UIS.JumpRequest:Connect(function()
    if Modules.InfJump and LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

print("🍊 Orange Hub V4 Beautiful Core загружен!")
