-- [[ ORANGE HUB V4 - UI MODULE (RESTORED) ]]
local LP = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Очистка старого UI
if game.CoreGui:FindFirstChild("OrangeHub_V4") then 
    game.CoreGui["OrangeHub_V4"]:Destroy() 
end

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "OrangeHub_V4"
gui.ResetOnSpawn = false

-- ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
_G.WalkSpeedValue = 100
_G.FlySpeedValue = 50

-- ГЛАВНОЕ ОКНО
local Main = Instance.new("Frame", gui)
Main.Name = "Main"
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 27)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Оранжевая полоска сверху
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

-- ВОЗВРАЩАЕМ ЗАГОЛОВОК (Orange HUB)
local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "ORANGE HUB"
Title.TextColor3 = Color3.fromRGB(255, 165, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20 -- Увеличен размер
Title.BackgroundTransparency = 1
Title.ZIndex = 3

-- КОНТЕЙНЕР ВКЛАДОК
local TabHolder = Instance.new("Frame", Sidebar)
TabHolder.Size = UDim2.new(1, -10, 1, -80)
TabHolder.Position = UDim2.new(0, 5, 0, 70)
TabHolder.BackgroundTransparency = 1
TabHolder.ZIndex = 3
Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 8)

-- КОНТЕЙНЕР ФУНКЦИЙ
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -170, 1, -70)
Container.Position = UDim2.new(0, 160, 0, 55)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Container.ZIndex = 5
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 10)

-- [УТИЛИТЫ]
local function createInput(name, callback)
    local box = Instance.new("TextBox", Container)
    box.Size = UDim2.new(1, -10, 0, 45)
    box.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    box.PlaceholderText = name
    box.Text = ""
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 16 -- Увеличен размер шрифта
    box.ZIndex = 10
    Instance.new("UICorner", box)
    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)
        if num then callback(num) end
        box.Text = ""
    end)
end

local function createToggle(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14 -- Увеличен размер шрифта
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

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        dot:TweenPosition(state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6), "Out", "Sine", 0.15, true)
        bg.BackgroundColor3 = state and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(60, 60, 60)
        callback(state)
    end)
end

-- [ВКЛАДКИ]
local function showTab(name)
    for _, v in pairs(Container:GetChildren()) do 
        if not v:IsA("UIListLayout") then v:Destroy() end 
    end
    
    if name == "Player" then
        createInput("СКОРОСТЬ (16-200)", function(v) _G.WalkSpeedValue = v end)
        createToggle("Speed Hack", function(v) 
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
        createToggle("Fly Mode", function(v)
            if _G.Modules["Fly"] then _G.Modules["Fly"].SetState(v) end
        end)
        createToggle("Infinite Jump", function(v)
            if _G.Modules["Player"] then _G.Modules["Player"].InfJumpEnabled = v end
        end)
    elseif name == "Combat" then
        createToggle("ESP Monsters", function(v)
            if _G.Modules["ESP"] then _G.Modules["ESP"].Enabled = v end
        end)
    end
end

-- [КНОПКИ САЙДБАРА]
local function addTabBtn(name)
    local b = Instance.new("TextButton", TabHolder)
    b.Size = UDim2.new(1, 0, 0, 45)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16 -- Увеличен шрифт кнопок
    b.ZIndex = 4
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() showTab(name) end)
end

addTabBtn("Player")
addTabBtn("Combat")
showTab("Player")

-- [ВОЗВРАЩАЕМ КНОПКУ ЗАКРЫТИЯ (Сворачивания)]
local Collapse = Instance.new("TextButton", Main)
Collapse.Name = "Collapse"
Collapse.Size = UDim2.new(0, 30, 0, 30)
Collapse.Position = UDim2.new(1, -35, 0, 10)
Collapse.Text = "—"
Collapse.TextSize = 20
Collapse.ZIndex = 12
Collapse.BackgroundColor3 = Color3.fromRGB(45, 45, 47)
Collapse.TextColor3 = Color3.new(1, 1, 1)
Collapse.Font = Enum.Font.GothamBold
Instance.new("UICorner", Collapse)

local OpenBtn = Instance.new("TextButton", gui)
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -30)
OpenBtn.Text = "🍊"
OpenBtn.TextSize = 40
OpenBtn.BackgroundTransparency = 1
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.ZIndex = 20

Collapse.MouseButton1Click:Connect(function() 
    Main.Visible = false 
    OpenBtn.Visible = true 
end)

OpenBtn.MouseButton1Click:Connect(function() 
    Main.Visible = true 
    OpenBtn.Visible = false 
end)

print("🍊 OrangeHub: UI восстановлен!")
return gui
