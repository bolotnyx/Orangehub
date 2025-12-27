-- Удаляем старый UI, чтобы не было дубликатов
if game.CoreGui:FindFirstChild("OrangeHub_Final") then
    game.CoreGui["OrangeHub_Final"]:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "OrangeHub_Final"
gui.Parent = game.CoreGui

-- ГЛАВНОЕ ОКНО
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 450, 0, 300)
Main.Position = UDim2.new(0.5, -225, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Active = true
Main.Draggable = true

-- КНОПКА ЗАКРЫТИЯ
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Close.TextColor3 = Color3.new(1, 1, 1)

-- КНОПКА ОТКРЫТИЯ
local OpenBtn = Instance.new("TextButton", gui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -25)
OpenBtn.Text = "🍊"
OpenBtn.Visible = false
OpenBtn.TextSize = 30

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

-- КОНТЕЙНЕР ДЛЯ КНОПОК
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 40)
Container.BackgroundTransparency = 1
local layout = Instance.new("UIListLayout", Container)
layout.Padding = UDim.new(0, 5)

-- ФУНКЦИЯ СОЗДАНИЯ КНОПКИ (БЕЗ СЛОЖНЫХ ШАРИКОВ)
local function createToggle(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            btn.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- Оранжевый
            btn.Text = name .. ": ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Серый
            btn.Text = name .. ": OFF"
        end
        
        -- Запуск функции
        if callback then
            pcall(function() callback(enabled) end)
        end
    end)
end

-- ДОБАВЛЯЕМ КНОПКИ СРАЗУ (БЕЗ ВКЛАДОК ДЛЯ ТЕСТА)
createToggle("Speed Hack (100)", function(state)
    local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = state and 100 or 16
    end
end)

createToggle("Auto Tree Farm", function(state)
    if _G.Modules and _G.Modules["Player"] then
        _G.Modules["Player"].AutoTree = state
    end
end)

return gui
