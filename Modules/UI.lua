local gui = Instance.new("ScreenGui")
gui.Name = "OrangeHubGUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- Главный фрейм
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0,400,0,300)
mainFrame.Position = UDim2.new(0.5,-200,0.5,-150)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame)

-- Заголовок
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "🍊 OrangeHub | 99 Nights"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,165,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Функция создания кнопок в центре (универсальная)
local function createMenuButton(name, pos, callback)
    local btn = Instance.new("TextButton", centerPanel)
    btn.Size = UDim2.new(0,180,0,35)
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
    return btn
end

-- Правая панель вкладок
local rightPanel = Instance.new("Frame", mainFrame)
rightPanel.Size = UDim2.new(0,100,1,0)
rightPanel.Position = UDim2.new(1,-100,0,0)
rightPanel.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner", rightPanel)

-- Центральная панель
centerPanel = Instance.new("Frame", mainFrame)
centerPanel.Size = UDim2.new(1,-100,1,0)
centerPanel.Position = UDim2.new(0,0,0,0)
centerPanel.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", centerPanel)

-- Вкладки
local tabs = {"Combat","Player","ESP"}

local function clearCenter()
    for _,v in ipairs(centerPanel:GetChildren()) do
        if not v:IsA("UICorner") then v:Destroy() end
    end
end

local function createTabButton(name, position)
    local btn = Instance.new("TextButton", rightPanel)
    btn.Size = UDim2.new(1,0,0,45)
    btn.Position = position
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn)
    return btn
end

for i,name in ipairs(tabs) do
    local btn = createTabButton(name, UDim2.new(0,0,0,(i-1)*50))
    btn.MouseButton1Click:Connect(function()
        clearCenter()
        
        if name == "Combat" then
            createMenuButton("KillAura", UDim2.new(0.5,-90,0,40), function(val)
                local m = _G.Modules["Combat"]
                if m then m.KillAura = val end
            end)

        elseif name == "Player" then
            createMenuButton("Auto Tree Farm", UDim2.new(0.5,-90,0,40), function(val)
                local m = _G.Modules["Player"]
                if m then m.AutoTree = val end
            end)
            
            createMenuButton("Auto Log Farm", UDim2.new(0.5,-90,0,85), function(val)
                local m = _G.Modules["Player"]
                if m then m.AutoLog = val end
            end)

            createMenuButton("Speed Hack (100)", UDim2.new(0.5,-90,0,130), function(val)
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.WalkSpeed = val and 100 or 16
                end
            end)

        elseif name == "ESP" then
            createMenuButton("Toggle ESP", UDim2.new(0.5,-90,0,40), function(val)
                local m = _G.Modules["ESP"]
                if m then m.Enabled = val end
            end)
        end
    end)
end

print("🍊 OrangeHub UI Loaded")
return gui
