local gui = Instance.new("ScreenGui")
gui.Name = "OrangeHub_Advanced"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- ГЛАВНЫЙ ФОН
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- БОКОВАЯ ПАНЕЛЬ (Sidebar)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Sidebar.BorderSizePixel = 0
local sideCorner = Instance.new("UICorner", Sidebar)
sideCorner.CornerRadius = UDim.new(0, 8)

-- Линия-разделитель (чтобы скрыть закругления справа у сайдбара)
local line = Instance.new("Frame", Sidebar)
line.Size = UDim2.new(0, 5, 1, 0)
line.Position = UDim2.new(1, -5, 0, 0)
line.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
line.BorderSizePixel = 0

-- ЗАГОЛОВОК
local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "ORANGE HUB"
Title.TextColor3 = Color3.fromRGB(255, 165, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

-- КОНТЕЙНЕР ДЛЯ КНОПОК ВКЛАДОК
local TabButtons = Instance.new("Frame", Sidebar)
TabButtons.Size = UDim2.new(1, 0, 1, -60)
TabButtons.Position = UDim2.new(0, 0, 0, 60)
TabButtons.BackgroundTransparency = 1

-- ПАНЕЛЬ КОНТЕНТА (Где все функции)
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -150, 1, -30)
Container.Position = UDim2.new(0, 140, 0, 15)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Container.CanvasSize = UDim2.new(0,0,1.5,0)

-- КНОПКА СВОРАЧИВАНИЯ
local Collapse = Instance.new("TextButton", Main)
Collapse.Size = UDim2.new(0, 30, 0, 30)
Collapse.Position = UDim2.new(1, -35, 0, 5)
Collapse.Text = "—"
Collapse.TextColor3 = Color3.new(1,1,1)
Collapse.BackgroundTransparency = 1
Collapse.TextSize = 20

local OpenBtn = Instance.new("TextButton", gui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
OpenBtn.Text = "🍊"
OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1,0)

Collapse.MouseButton1Click:Connect(function() Main.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true OpenBtn.Visible = false end)

-- ФУНКЦИИ ИНТЕРФЕЙСА
local function clear()
    for _, v in ipairs(Container:GetChildren()) do v:Destroy() end
end

local function addToggle(name, callback)
    local frame = Instance.new("Frame", Container)
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = #Container:GetChildren()

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)

    local status = Instance.new("Frame", btn)
    status.Size = UDim2.new(0, 10, 0, 10)
    status.Position = UDim2.new(1, -25, 0.5, -5)
    status.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Instance.new("UICorner", status)

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        status.BackgroundColor3 = enabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        callback(enabled)
    end)
end

local function addTab(name, icon_id)
    local btn = Instance.new("TextButton", TabButtons)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, (#TabButtons:GetChildren()-1) * 45)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        clear()
        local list = Instance.new("UIListLayout", Container)
        list.Padding = UDim.new(0, 5)
        
        if name == "Combat" then
            addToggle("KillAura", function(v) if _G.Modules["Combat"] then _G.Modules["Combat"].KillAura = v end end)
        elseif name == "Player" then
            addToggle("Auto Tree Farm", function(v) if _G.Modules["Player"] then _G.Modules["Player"].AutoTree = v end end)
            addToggle("Auto Log Farm", function(v) if _G.Modules["Player"] then _G.Modules["Player"].AutoLog = v end end)
            addToggle("Speed x2", function(v) 
                local h = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                if h then h.WalkSpeed = v and 100 or 16 end
            end)
        elseif name == "ESP" then
            addToggle("Toggle ESP", function(v) if _G.Modules["ESP"] then _G.Modules["ESP"].Enabled = v end end)
        end
    end)
end

-- Создаем вкладки
addTab("Combat")
addTab("Player")
addTab("ESP")

-- Авто-открытие первой вкладки
print("🍊 Advanced UI Loaded")
return gui
