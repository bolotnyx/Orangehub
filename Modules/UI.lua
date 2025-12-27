local gui = Instance.new("ScreenGui")
gui.Name = "OrangeHubGUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- ГЛАВНЫЙ ФРЕЙМ
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Темно-серый
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 165, 0) -- Оранжевая рамка
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ZIndex = 1

-- ЗАГОЛОВОК
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "🍊 ORANGE HUB"
title.TextColor3 = Color3.fromRGB(255, 165, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.ZIndex = 2

-- КНОПКА СВЕРНУТЬ
local collapseBtn = Instance.new("TextButton", mainFrame)
collapseBtn.Size = UDim2.new(0, 30, 0, 30)
collapseBtn.Position = UDim2.new(1, -35, 0, 5)
collapseBtn.Text = "—"
collapseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
collapseBtn.TextColor3 = Color3.new(1, 1, 1)
collapseBtn.ZIndex = 3

-- КНОПКА ОТКРЫТИЯ (АПЕЛЬСИН)
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0, 20, 0.5, -25)
openBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
openBtn.Text = "🍊"
openBtn.TextSize = 30
openBtn.Visible = false
openBtn.ZIndex = 10
Instance.new("UICorner", openBtn)

collapseBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)

-- КОНТЕЙНЕР ДЛЯ КНОПОК (Чтобы не сливались с фоном)
local contentFrame = Instance.new("ScrollingFrame", mainFrame)
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.CanvasSize = UDim2.new(0, 0, 2, 0) -- Можно скроллить
contentFrame.ZIndex = 2

local function createButton(name, pos, callback)
    local btn = Instance.new("TextButton", contentFrame)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 3
    Instance.new("UICorner", btn)
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.BackgroundColor3 = enabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(50, 50, 50)
        callback(enabled)
    end)
end

-- СРАЗУ ВЫВОДИМ ВСЕ КНОПКИ (Без вкладок, чтобы не было черных панелей)
createButton("Auto Tree Farm", UDim2.new(0, 0, 0, 0), function(v)
    if _G.Modules["Player"] then _G.Modules["Player"].AutoTree = v end
end)

createButton("Auto Log Farm", UDim2.new(0, 0, 0, 50), function(v)
    if _G.Modules["Player"] then _G.Modules["Player"].AutoLog = v end
end)

createButton("KillAura", UDim2.new(0, 0, 0, 100), function(v)
    if _G.Modules["Combat"] then _G.Modules["Combat"].KillAura = v end
end)

createButton("Speed x2", UDim2.new(0, 0, 0, 150), function(v)
    local h = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if h then h.WalkSpeed = v and 80 or 16 end
end)

createButton("Toggle ESP", UDim2.new(0, 0, 0, 200), function(v)
    if _G.Modules["ESP"] then _G.Modules["ESP"].Enabled = v end
end)

print("🍊 OrangeHub UI Simplified & Fixed")
return gui
