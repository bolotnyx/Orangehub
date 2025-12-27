-- Очистка старого UI
if game.CoreGui:FindFirstChild("OrangeHub_V4") then 
    game.CoreGui["OrangeHub_V4"]:Destroy() 
end

local gui = Instance.new("ScreenGui")
gui.Name = "OrangeHub_V4"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

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

-- Оранжевая линия
local Accent = Instance.new("Frame", Main)
Accent.Size = UDim2.new(1, 0, 0, 3)
Accent.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
Accent.ZIndex = 5
Instance.new("UICorner", Accent)

-- КОНТЕЙНЕР ДЛЯ КНОПОК
local Container = Instance.new("ScrollingFrame", Main)
Container.Name = "Container"
Container.Size = UDim2.new(1, -160, 1, -70)
Container.Position = UDim2.new(0, 150, 0, 55)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Container.ZIndex = 3

local layout = Instance.new("UIListLayout", Container)
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- КНОПКА ЗАКРЫТИЯ (—)
local Collapse = Instance.new("TextButton", Main)
Collapse.Size = UDim2.new(0, 30, 0, 30)
Collapse.Position = UDim2.new(1, -35, 0, 8)
Collapse.Text = "—"
Collapse.TextColor3 = Color3.new(1, 1, 1)
Collapse.BackgroundColor3 = Color3.fromRGB(45, 45, 47)
Collapse.ZIndex = 10
Instance.new("UICorner", Collapse)

-- ФУНКЦИЯ СОЗДАНИЯ ПЕРЕКЛЮЧАТЕЛЕЙ (ТОГГЛОВ)
local function createToggle(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Name = name .. "Toggle"
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 42)
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 4
    Instance.new("UICorner", btn)

    local bg = Instance.new("Frame", btn)
    bg.Size = UDim2.new(0, 34, 0, 18)
    bg.Position = UDim2.new(1, -45, 0.5, -9)
    bg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    bg.ZIndex = 5
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", bg)
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = UDim2.new(0, 3, 0.5, -6)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    dot.ZIndex = 6
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local enabled = false
    btn.MouseButton1Down:Connect(function()
        enabled = not enabled
        dot:TweenPosition(enabled and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6), "Out", "Sine", 0.15, true)
        bg.BackgroundColor3 = enabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(60, 60, 60)
        if callback then task.spawn(pcall, callback, enabled) end
    end)
end

-- ПАНЕЛЬ ВКЛАДОК (СЛЕВА)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Sidebar.ZIndex = 2
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "ORANGE HUB"
Title.TextColor3 = Color3.fromRGB(255, 165, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

local TabHolder = Instance.new("Frame", Sidebar)
TabHolder.Size = UDim2.new(1, -10, 1, -80)
TabHolder.Position = UDim2.new(0, 5, 0, 70)
TabHolder.BackgroundTransparency = 1
Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 5)

-- ФУНКЦИЯ ДОБАВЛЕНИЯ ВКЛАДКИ
local function addTab(name, isDefault)
    local t = Instance.new("TextButton", TabHolder)
    t.Size = UDim2.new(1, 0, 0, 35)
    t.Text = name
    t.BackgroundColor3 = Color3.fromRGB(45, 45, 47)
    t.TextColor3 = Color3.new(1, 1, 1)
    t.Font = Enum.Font.GothamBold
    Instance.new("UICorner", t)

    local function loadContent()
        -- Очищаем контейнер
        for _, v in ipairs(Container:GetChildren()) do 
            if v:IsA("TextButton") then v:Destroy() end 
        end
        
        -- Загружаем кнопки в зависимости от вкладки
        if name == "Player" then
            createToggle("Speed Hack", function(v) 
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v and 100 or 16 
            end)
            createToggle("Auto Tree Farm", function(v) 
                if _G.Modules and _G.Modules["Player"] then _G.Modules["Player"].AutoTree = v end 
            end)
        elseif name == "Combat" then
            createToggle("KillAura", function(v) 
                if _G.Modules and _G.Modules["Combat"] then _G.Modules["Combat"].KillAura = v end 
            end)
        elseif name == "ESP" then
            createToggle("Player ESP", function(v) 
                if _G.Modules and _G.Modules["ESP"] then _G.Modules["ESP"].Enabled = v end 
            end)
        end
    end

    t.MouseButton1Click:Connect(loadContent)
    if isDefault then loadContent() end -- Загружаем контент сразу для первой вкладки
end

-- Создаем вкладки
addTab("Player", true) -- Эта откроется сразу
addTab("Combat")
addTab("ESP")

-- КНОПКА ОТКРЫТИЯ (АПЕЛЬСИН)
local OpenBtn = Instance.new("TextButton", gui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundTransparency = 1
OpenBtn.Text = "🍊"
OpenBtn.TextSize = 40
OpenBtn.Visible = false

Collapse.MouseButton1Click:Connect(function() Main.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true OpenBtn.Visible = false end)

return gui
