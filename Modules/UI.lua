local gui = Instance.new("ScreenGui")
gui.Name = "OrangeHub_Fixed"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- ГЛАВНОЕ ОКНО
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 27)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Верхняя оранжевая полоска
local Accent = Instance.new("Frame", Main)
Accent.Size = UDim2.new(1, 0, 0, 3)
Accent.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
Accent.BorderSizePixel = 0
Instance.new("UICorner", Accent)

-- КНОПКА ЗАКРЫТИЯ (В верхнем углу)
local Collapse = Instance.new("TextButton", Main)
Collapse.Size = UDim2.new(0, 30, 0, 30)
Collapse.Position = UDim2.new(1, -35, 0, 8)
Collapse.BackgroundColor3 = Color3.fromRGB(40, 40, 42)
Collapse.Text = "—"
Collapse.TextColor3 = Color3.new(1, 1, 1)
Collapse.Font = Enum.Font.GothamBold
Collapse.TextSize = 18
local collCorner = Instance.new("UICorner", Collapse)
collCorner.CornerRadius = UDim.new(0, 6)

-- КНОПКА ОТКРЫТИЯ (Маленький пульсирующий апельсин)
local OpenBtn = Instance.new("TextButton", gui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundTransparency = 1
OpenBtn.Text = "🍊"
OpenBtn.TextSize = 40
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true

-- АНИМАЦИЯ ПУЛЬСАЦИИ (Более мягкая)
task.spawn(function()
    while true do
        if OpenBtn.Visible then
            OpenBtn:TweenSize(UDim2.new(0, 60, 0, 60), "Out", "Sine", 1, true)
            task.wait(1)
            OpenBtn:TweenSize(UDim2.new(0, 45, 0, 45), "Out", "Sine", 1, true)
            task.wait(1)
        else
            task.wait(1)
        end
    end
end)

-- ЛОГИКА
Collapse.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

-- САЙДБАР (С крупной надписью)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, -10)
Sidebar.Position = UDim2.new(0, 5, 0, 5)
Sidebar.BackgroundColor3 = Color3.fromRGB(33, 33, 35)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "ORANGE HUB"
Title.TextColor3 = Color3.fromRGB(255, 165, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20 -- Крупный текст вернулся
Title.BackgroundTransparency = 1

-- КОНТЕЙНЕР ДЛЯ ФУНКЦИЙ
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -165, 1, -30)
Container.Position = UDim2.new(0, 155, 0, 20)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
local ContainerList = Instance.new("UIListLayout", Container)
ContainerList.Padding = UDim.new(0, 10)

-- Функция создания Тогглов
local function createToggle(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16 -- Текст стал нормального размера
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)

    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0, 34, 0, 18)
    indicator.Position = UDim2.new(1, -45, 0.5, -9)
    indicator.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", indicator)
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = UDim2.new(0, 3, 0.5, -6)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        dot:TweenPosition(enabled and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6), "Out", "Quad", 0.2)
        indicator.BackgroundColor3 = enabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(60, 60, 60)
        callback(enabled)
    end)
end

-- Вкладки
local TabHolder = Instance.new("Frame", Sidebar)
TabHolder.Size = UDim2.new(1, -10, 1, -70)
TabHolder.Position = UDim2.new(0, 5, 0, 70)
TabHolder.BackgroundTransparency = 1
local TabList = Instance.new("UIListLayout", TabHolder)
TabList.Padding = UDim.new(0, 6)

local function addTab(name)
    local t = Instance.new("TextButton", TabHolder)
    t.Size = UDim2.new(1, 0, 0, 40)
    t.BackgroundColor3 = Color3.fromRGB(48, 48, 50)
    t.Text = name
    t.TextColor3 = Color3.new(1, 1, 1)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 15
    Instance.new("UICorner", t)

    t.MouseButton1Click:Connect(function()
        for _, v in ipairs(Container:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        if name == "Combat" then
            createToggle("KillAura", function(v) if _G.Modules["Combat"] then _G.Modules["Combat"].KillAura = v end end)
        elseif name == "Player" then
            createToggle("Auto Tree Farm", function(v) if _G.Modules["Player"] then _G.Modules["Player"].AutoTree = v end end)
            createToggle("Auto Log Farm", function(v) if _G.Modules["Player"] then _G.Modules["Player"].AutoLog = v end end)
            createToggle("WalkSpeed Hack", function(v) 
                local h = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                if h then h.WalkSpeed = v and 100 or 16 end
            end)
        elseif name == "ESP" then
            createToggle("Player ESP", function(v) if _G.Modules["ESP"] then _G.Modules["ESP"].Enabled = v end end)
        end
    end)
end

addTab("Combat")
addTab("Player")
addTab("ESP")

return gui
