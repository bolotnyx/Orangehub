local gui = Instance.new("ScreenGui")
gui.Name = "OrangeHubGUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- ГЛАВНЫЙ ФРЕЙМ (Меню)
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 420, 0, 320)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Темно-серый, не черный
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 10)

-- Верхняя полоска (Заголовок)
local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
topBar.BorderSizePixel = 0
local topCorner = Instance.new("UICorner", topBar)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "🍊 OrangeHub | 99 Nights"
title.TextColor3 = Color3.fromRGB(255, 165, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1

-- Кнопка сворачивания (—)
local collapseBtn = Instance.new("TextButton", topBar)
collapseBtn.Size = UDim2.new(0, 30, 0, 30)
collapseBtn.Position = UDim2.new(1, -35, 0, 5)
collapseBtn.Text = "—"
collapseBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
collapseBtn.TextColor3 = Color3.new(1, 1, 1)
collapseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", collapseBtn)

-- Кнопка открытия (АПЕЛЬСИН)
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0, 20, 0.5, -25)
openBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
openBtn.Text = "🍊"
openBtn.TextSize = 30
openBtn.Visible = false
openBtn.Draggable = true
local openCorner = Instance.new("UICorner", openBtn)
openCorner.CornerRadius = UDim.new(1, 0)

collapseBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)

-- Левая панель (Кнопки вкладок)
local sidePanel = Instance.new("Frame", mainFrame)
sidePanel.Size = UDim2.new(0, 110, 1, -50)
sidePanel.Position = UDim2.new(0, 5, 0, 45)
sidePanel.BackgroundTransparency = 1

-- Центральная панель (Контент)
local centerPanel = Instance.new("Frame", mainFrame)
centerPanel.Size = UDim2.new(1, -125, 1, -55)
centerPanel.Position = UDim2.new(0, 120, 0, 50)
centerPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Сделал чуть темнее для контраста
local centerCorner = Instance.new("UICorner", centerPanel)

local function clearCenter()
    for _, v in ipairs(centerPanel:GetChildren()) do
        if not v:IsA("UICorner") then v:Destroy() end
    end
end

local function createMenuButton(name, pos, callback)
    local btn = Instance.new("TextButton", centerPanel)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn)
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.BackgroundColor3 = enabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(45, 45, 45)
        callback(enabled)
    end)
end

-- Вкладки
local tabs = {"Combat", "Player", "ESP"}
for i, name in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton", sidePanel)
    tabBtn.Size = UDim2.new(1, 0, 0, 40)
    tabBtn.Position = UDim2.new(0, 0, 0, (i-1)*45)
    tabBtn.Text = name
    tabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    tabBtn.TextColor3 = Color3.new(1, 1, 1)
    tabBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", tabBtn)
    
    tabBtn.MouseButton1Click:Connect(function()
        clearCenter()
        if name == "Combat" then
            createMenuButton("KillAura", UDim2.new(0, 5, 0, 10), function(v)
                if _G.Modules["Combat"] then _G.Modules["Combat"].KillAura = v end
            end)
        elseif name == "Player" then
            createMenuButton("Auto Tree Farm", UDim2.new(0, 5, 0, 10), function(v)
                if _G.Modules["Player"] then _G.Modules["Player"].AutoTree = v end
            end)
            createMenuButton("Auto Log Farm", UDim2.new(0, 5, 0, 55), function(v)
                if _G.Modules["Player"] then _G.Modules["Player"].AutoLog = v end
            end)
            createMenuButton("WalkSpeed (100)", UDim2.new(0, 5, 0, 100), function(v)
                local h = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                if h then h.WalkSpeed = v and 100 or 16 end
            end)
        elseif name == "ESP" then
            createMenuButton("Toggle ESP", UDim2.new(0, 5, 0, 10), function(v)
                if _G.Modules["ESP"] then _G.Modules["ESP"].Enabled = v end
            end)
        end
    end)
end

print("🍊 OrangeHub UI Refined")
return gui
