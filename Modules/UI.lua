local gui = Instance.new("ScreenGui")
gui.Name = "OrangeHub_Final_Visual"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- ГЛАВНОЕ ОКНО
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Оранжевая линия сверху
local Accent = Instance.new("Frame", Main)
Accent.Size = UDim2.new(1, 0, 0, 2)
Accent.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
Accent.BorderSizePixel = 0
Instance.new("UICorner", Accent)

-- КНОПКА СВЕРНУТЬ (—)
local Collapse = Instance.new("TextButton", Main)
Collapse.Size = UDim2.new(0, 30, 0, 30)
Collapse.Position = UDim2.new(1, -35, 0, 5)
Collapse.Text = "—"
Collapse.TextColor3 = Color3.fromRGB(200, 200, 200)
Collapse.BackgroundTransparency = 1
Collapse.Font = Enum.Font.GothamBold
Collapse.TextSize = 20

-- КНОПКА ОТКРЫТИЯ (ДВИЖУЩИЙСЯ АПЕЛЬСИН)
local OpenBtn = Instance.new("TextButton", gui)
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -30)
OpenBtn.BackgroundTransparency = 1 -- Убрали оранжевый круг
OpenBtn.Text = "🍊"
OpenBtn.TextSize = 50 -- Теперь апельсин большой и один
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true

-- СКРИПТ АНИМАЦИИ ПУЛЬСАЦИИ
task.spawn(function()
    while true do
        if OpenBtn.Visible then
            -- Увеличиваем
            OpenBtn:TweenSize(UDim2.new(0, 70, 0, 70), "Out", "Sine", 0.8, true)
            task.wait(0.8)
            -- Уменьшаем
            OpenBtn:TweenSize(UDim2.new(0, 55, 0, 55), "Out", "Sine", 0.8, true)
            task.wait(0.8)
        else
            task.wait(1)
        end
    end
end)

-- Логика кнопок
Collapse.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

-- ПАНЕЛИ И ФУНКЦИИ (Оставил твою рабочую структуру)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, -10)
Sidebar.Position = UDim2.new(0, 5, 0, 5)
Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 37)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar)

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -160, 1, -20)
Container.Position = UDim2.new(0, 150, 0, 10)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
local ContainerList = Instance.new("UIListLayout", Container)
ContainerList.Padding = UDim.new(0, 8)

local function createToggle(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)

    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0, 30, 0, 15)
    indicator.Position = UDim2.new(1, -40, 0.5, -7)
    indicator.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", indicator)
    dot.Size = UDim2.new(0, 11, 0, 11)
    dot.Position = UDim2.new(0, 2, 0.5, -5)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        dot:TweenPosition(enabled and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5), "Out", "Quad", 0.2)
        indicator.BackgroundColor3 = enabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(60, 60, 60)
        callback(enabled)
    end)
end

local TabHolder = Instance.new("Frame", Sidebar)
TabHolder.Size = UDim2.new(1, -10, 1, -60)
TabHolder.Position = UDim2.new(0, 5, 0, 60)
TabHolder.BackgroundTransparency = 1
Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 5)

local function addTab(name)
    local t = Instance.new("TextButton", TabHolder)
    t.Size = UDim2.new(1, 0, 0, 35)
    t.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    t.Text = name
    t.TextColor3 = Color3.new(1, 1, 1)
    t.Font = Enum.Font.GothamBold
    Instance.new("UICorner", t)

    t.MouseButton1Click:Connect(function()
        for _, v in ipairs(Container:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        if name == "Combat" then
            createToggle("KillAura", function(v) if _G.Modules["Combat"] then _G.Modules["Combat"].KillAura = v end end)
        elseif name == "Player" then
            createToggle("Auto Tree", function(v) if _G.Modules["Player"] then _G.Modules["Player"].AutoTree = v end end)
            createToggle("Auto Log", function(v) if _G.Modules["Player"] then _G.Modules["Player"].AutoLog = v end end)
        elseif name == "ESP" then
            createToggle("Visual ESP", function(v) if _G.Modules["ESP"] then _G.Modules["ESP"].Enabled = v end end)
        end
    end)
end

addTab("Combat")
addTab("Player")
addTab("ESP")

return gui
