-- [[ ORANGE HUB V4 - UI MODULE ]]
local LP = game.Players.LocalPlayer
local gui = game.CoreGui:FindFirstChild("OrangeHub_V4") or Instance.new("ScreenGui", game.CoreGui)

if gui:FindFirstChild("Main") then gui.Main:Destroy() end

local Main = Instance.new("Frame", gui)
Main.Name = "Main"
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 27)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

-- Оранжевая полоска
local Accent = Instance.new("Frame", Main)
Accent.Size = UDim2.new(1, 0, 0, 3)
Accent.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
Instance.new("UICorner", Accent)

-- Сайдбар
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(33, 33, 35)
Instance.new("UICorner", Sidebar)

local TabHolder = Instance.new("Frame", Sidebar)
TabHolder.Size = UDim2.new(1, -10, 1, -80)
TabHolder.Position = UDim2.new(0, 5, 0, 70)
TabHolder.BackgroundTransparency = 1
Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 8)

-- Контейнер функций
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -170, 1, -70)
Container.Position = UDim2.new(0, 160, 0, 55)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 10)

-- Утилиты создания элементов
local function createInput(name, callback)
    local box = Instance.new("TextBox", Container)
    box.Size = UDim2.new(1, -10, 0, 40)
    box.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    box.PlaceholderText = name
    box.Text = ""
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Font = "GothamBold"
    box.TextSize = 14
    Instance.new("UICorner", box)
    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)
        if num then callback(num) end
        box.Text = ""
    end)
end

local function createToggle(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = "GothamBold"
    btn.TextXAlignment = "Left"
    Instance.new("UICorner", btn)

    local bg = Instance.new("Frame", btn)
    bg.Size = UDim2.new(0, 34, 0, 18)
    bg.Position = UDim2.new(1, -45, 0.5, -9)
    bg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", bg)
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = UDim2.new(0, 3, 0.5, -6)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        dot:TweenPosition(state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6), "Out", "Sine", 0.1)
        bg.BackgroundColor3 = state and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(60, 60, 60)
        callback(state)
    end)
end

-- Вкладки
local function showTab(name)
    for _, v in pairs(Container:GetChildren()) do if v:IsA("TextButton") or v:IsA("TextBox") then v:Destroy() end end
    
    if name == "Player" then
        createInput("СКОРОСТЬ (16-200)", function(v) _G.WalkSpeedValue = v end)
        createToggle("Speed Hack", function(v) 
            _G.SpeedEnabled = v 
            task.spawn(function()
                while _G.SpeedEnabled do
                    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                        LP.Character.Humanoid.WalkSpeed = _G.WalkSpeedValue or 100
                    end
                    task.wait(0.1)
                end
            end)
        end)
        createToggle("Fly Mode", function(v)
            if _G.Modules["Player"] and _G.Modules["Player"].SetFly then _G.Modules["Player"].SetFly(v) end
        end)
        createToggle("Infinite Jump", function(v)
            if _G.Modules["Player"] then _G.Modules["Player"].InfJumpEnabled = v end
        end)
    elseif name == "Combat" then
        createToggle("ESP Monsters", function(v)
            if _G.Modules["ESP"] then _G.Modules["ESP"].Enabled = v end
        end)
    end
end

-- Сайдбар кнопки
local function addTabBtn(name)
    local b = Instance.new("TextButton", TabHolder)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = "GothamBold"
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() showTab(name) end)
end

addTabBtn("Player")
addTabBtn("Combat")
showTab("Player")

return gui
