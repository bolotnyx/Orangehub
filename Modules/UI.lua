-- Очистка старого UI
if game.CoreGui:FindFirstChild("OrangeHub_V4") then 
    game.CoreGui["OrangeHub_V4"]:Destroy() 
end

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "OrangeHub_V4"
gui.ResetOnSpawn = false

-- ГЛАВНОЕ ОКНО
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 27)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Оранжевая линия сверху
local Accent = Instance.new("Frame", Main)
Accent.Size = UDim2.new(1, 0, 0, 3)
Accent.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
Accent.ZIndex = 5
Instance.new("UICorner", Accent)

-- КНОПКА ЗАКРЫТИЯ (Красивая)
local Collapse = Instance.new("TextButton", Main)
Collapse.Size = UDim2.new(0, 26, 0, 26)
Collapse.Position = UDim2.new(1, -32, 0, 8)
Collapse.BackgroundColor3 = Color3.fromRGB(45, 45, 47)
Collapse.Text = "—"
Collapse.TextColor3 = Color3.new(1, 1, 1)
Collapse.Font = Enum.Font.GothamBold
Collapse.TextSize = 14
Collapse.ZIndex = 10
Instance.new("UICorner", Collapse).CornerRadius = UDim.new(0, 6)

-- САЙДБАР
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(33, 33, 35)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 1
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "ORANGE HUB"
Title.TextColor3 = Color3.fromRGB(255, 165, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.ZIndex = 2

-- КОНТЕЙНЕРЫ
local TabHolder = Instance.new("Frame", Sidebar)
TabHolder.Size = UDim2.new(1, -10, 1, -80)
TabHolder.Position = UDim2.new(0, 5, 0, 70)
TabHolder.BackgroundTransparency = 1
TabHolder.ZIndex = 2
Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 5)

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -160, 1, -70)
Container.Position = UDim2.new(0, 150, 0, 55)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Container.ZIndex = 2
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 10)

-- Функция тоггла
local function createToggle(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 3
    Instance.new("UICorner", btn)

    local bg = Instance.new("Frame", btn)
    bg.Size = UDim2.new(0, 34, 0, 18)
    bg.Position = UDim2.new(1, -45, 0.5, -9)
    bg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    bg.ZIndex = 4
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", bg)
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = UDim2.new(0, 3, 0.5, -6)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    dot.ZIndex = 5
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local enabled = false
    btn.MouseButton1Down:Connect(function()
        enabled = not enabled
        dot:TweenPosition(enabled and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6), "Out", "Sine", 0.15, true)
        bg.BackgroundColor3 = enabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(60, 60, 60)
        if callback then task.spawn(pcall, callback, enabled) end
    end)
end

-- Логика вкладок
local function showTab(name)
    for _, v in ipairs(Container:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    if name == "Player" then
        createToggle("Speed Hack", function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v and 100 or 16 end)
        createToggle("Auto Tree Farm", function(v) if _G.Modules["Player"] then _G.Modules["Player"].AutoTree = v end end)
    elseif name == "Combat" then
        createToggle("KillAura", function(v) if _G.Modules["Combat"] then _G.Modules["Combat"].KillAura = v end end)
    end
end

local function addSidebarButton(name)
    local t = Instance.new("TextButton", TabHolder)
    t.Size = UDim2.new(1, 0, 0, 40)
    t.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    t.Text = name
    t.TextColor3 = Color3.new(1, 1, 1)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 14
    t.ZIndex = 5
    Instance.new("UICorner", t)
    t.MouseButton1Click:Connect(function() showTab(name) end)
end

addSidebarButton("Player")
addSidebarButton("Combat")
showTab("Player")

-- КНОПКА ОТКРЫТИЯ (АПЕЛЬСИН - ПЕРЕДВИГАЕМЫЙ)
local OpenBtn = Instance.new("TextButton", gui)
OpenBtn.Size = UDim2.new(0, 55, 0, 55)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -27)
OpenBtn.BackgroundTransparency = 1
OpenBtn.Text = "🍊"
OpenBtn.TextSize = 40
OpenBtn.Visible = false
OpenBtn.Active = true -- Важно для Draggable
OpenBtn.Draggable = true -- Теперь можно двигать!
OpenBtn.ZIndex = 10

-- Анимация пульсации
task.spawn(function()
    while true do
        if OpenBtn.Visible then
            OpenBtn:TweenSize(UDim2.new(0, 60, 0, 60), "Out", "Sine", 0.8, true)
            task.wait(0.8)
            OpenBtn:TweenSize(UDim2.new(0, 50, 0, 50), "Out", "Sine", 0.8, true)
            task.wait(0.8)
        else task.wait(1) end
    end
end)

Collapse.MouseButton1Click:Connect(function() Main.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true OpenBtn.Visible = false end)

return gui
