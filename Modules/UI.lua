local gui = Instance.new("ScreenGui")
gui.Name = "OrangeHubGUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- Главный фрейм (Меню)
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0,400,0,300)
mainFrame.Position = UDim2.new(0.5,-200,0.5,-150)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.Active = true
mainFrame.Draggable = true -- Можно перетаскивать
Instance.new("UICorner", mainFrame)

-- Заголовок
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "🍊 OrangeHub"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,165,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Кнопка сворачивания (внутри меню)
local collapseBtn = Instance.new("TextButton", mainFrame)
collapseBtn.Size = UDim2.new(0,30,0,30)
collapseBtn.Position = UDim2.new(1,-35,0,2)
collapseBtn.Text = "—"
collapseBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
collapseBtn.TextColor3 = Color3.new(1,1,1)
collapseBtn.Font = Enum.Font.GothamBold
collapseBtn.TextSize = 18
Instance.new("UICorner", collapseBtn)

-- Кнопка открытия (появится, когда меню скрыто)
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0,45,0,45)
openBtn.Position = UDim2.new(0, 10, 0.5, -22) -- Слева сбоку
openBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
openBtn.Text = "🍊"
openBtn.TextSize = 25
openBtn.Visible = false -- Скрыта, пока меню открыто
openBtn.Draggable = true -- Ее тоже можно двигать
Instance.new("UICorner", openBtn)

-- Логика сворачивания
collapseBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)

-- Левая панель вкладок (переместил для удобства)
local sidePanel = Instance.new("Frame", mainFrame)
sidePanel.Size = UDim2.new(0,100,1,-40)
sidePanel.Position = UDim2.new(0,0,0,40)
sidePanel.BackgroundTransparency = 1

-- Центральная панель контента
local centerPanel = Instance.new("Frame", mainFrame)
centerPanel.Size = UDim2.new(1,-110,1,-50)
centerPanel.Position = UDim2.new(0,105,0,45)
centerPanel.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", centerPanel)

-- Функция очистки контента при смене вкладок
local function clearCenter()
    for _,v in ipairs(centerPanel:GetChildren()) do
        if not v:IsA("UICorner") then v:Destroy() end
    end
end

-- Функция создания кнопок функций
local function createMenuButton(name, pos, callback)
    local btn = Instance.new("TextButton", centerPanel)
    btn.Size = UDim2.new(0,270,0,35)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn)
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.BackgroundColor3 = enabled and Color3.fromRGB(255,165,0) or Color3.fromRGB(50,50,50)
        callback(enabled)
    end)
end

-- Настройка вкладок
local tabs = {"Combat","Player","ESP"}
for i, name in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton", sidePanel)
    tabBtn.Size = UDim2.new(1,0,0,40)
    tabBtn.Position = UDim2.new(0,5,0,(i-1)*45)
    tabBtn.Text = name
    tabBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    tabBtn.TextColor3 = Color3.new(1,1,1)
    tabBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", tabBtn)
    
    tabBtn.MouseButton1Click:Connect(function()
        clearCenter()
        if name == "Combat" then
            createMenuButton("KillAura", UDim2.new(0,5,0,10), function(v)
                if _G.Modules["Combat"] then _G.Modules["Combat"].KillAura = v end
            end)
        elseif name == "Player" then
            createMenuButton("Auto Tree Farm", UDim2.new(0,5,0,10), function(v)
                if _G.Modules["Player"] then _G.Modules["Player"].AutoTree = v end
            end)
            createMenuButton("Auto Log Farm", UDim2.new(0,5,0,55), function(v)
                if _G.Modules["Player"] then _G.Modules["Player"].AutoLog = v end
            end)
            createMenuButton("Speed Hack (100)", UDim2.new(0,5,0,100), function(v)
                local h = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                if h then h.WalkSpeed = v and 100 or 16 end
            end)
        elseif name == "ESP" then
            createMenuButton("Toggle ESP", UDim2.new(0,5,0,10), function(v)
                if _G.Modules["ESP"] then _G.Modules["ESP"].Enabled = v end
            end)
        end
    end)
end

print("🍊 OrangeHub UI Loaded with Collapse System")
return gui
