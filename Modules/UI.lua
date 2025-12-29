-- [[ ORANGE HUB V4 - UI ENHANCED ]]
local LP = game.Players.LocalPlayer
if game.CoreGui:FindFirstChild("OrangeHub_V4") then game.CoreGui.OrangeHub_V4:Destroy() end

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "OrangeHub_V4"

-- Главная панель
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 520, 0, 360)
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 27)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

-- Сайдбар
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(33, 33, 35)
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "ORANGE HUB"
Title.TextColor3 = Color3.fromRGB(255, 165, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.BackgroundTransparency = 1

-- Кнопка сворачивания
local Collapse = Instance.new("TextButton", Main)
Collapse.Size = UDim2.new(0, 35, 0, 35)
Collapse.Position = UDim2.new(1, -40, 0, 5)
Collapse.Text = "—"
Collapse.TextSize = 25
Collapse.Font = Enum.Font.GothamBold
Collapse.TextColor3 = Color3.new(1, 1, 1)
Collapse.BackgroundTransparency = 1

local OpenBtn = Instance.new("TextButton", gui)
OpenBtn.Size = UDim2.new(0, 65, 0, 65)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -32)
OpenBtn.Text = "🍊"
OpenBtn.TextSize = 45
OpenBtn.BackgroundTransparency = 1
OpenBtn.Visible = false
OpenBtn.Draggable = true

Collapse.MouseButton1Click:Connect(function() Main.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true OpenBtn.Visible = false end)

-- Контейнер для кнопок и полей
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -180, 1, -70)
Container.Position = UDim2.new(0, 170, 0, 60)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 10)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Создание поля ввода
local function createInput(name, callback)
    local box = Instance.new("TextBox", Container)
    box.Size = UDim2.new(1, -10, 0, 45)
    box.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    box.PlaceholderText = name
    box.Text = ""
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 14
    Instance.new("UICorner", box)
    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)
        if num then callback(num) end
        box.Text = ""
    end)
end

-- Создание toggle-кнопки
local function createToggle(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(45, 45, 48)
        callback(state)
    end)
end

-- Вкладки
local TabHolder = Instance.new("Frame", Sidebar)
TabHolder.Size = UDim2.new(1, 0, 1, -80)
TabHolder.Position = UDim2.new(0, 0, 0, 70)
TabHolder.BackgroundTransparency = 1
local TabLayout = Instance.new("UIListLayout", TabHolder)
TabLayout.Padding = UDim.new(0, 5)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function showTab(name)
    for _, v in pairs(Container:GetChildren()) do
        if v:IsA("TextButton") or v:IsA("TextBox") then v:Destroy() end
    end

    if name == "Player" then
        createInput("WALK SPEED (Example: 100)", function(v) _G.WalkSpeedValue = v end)
        createToggle("Enable Walk Speed", function(v)
            _G.SpeedEnabled = v
            task.spawn(function()
                while _G.SpeedEnabled do
                    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                        LP.Character.Humanoid.WalkSpeed = _G.WalkSpeedValue or 16
                    end
                    task.wait(0.1)
                end
                if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.WalkSpeed = 16 end
            end)
        end)

        createInput("FLY SPEED (Example: 50)", function(v) _G.FlySpeedValue = v end)
        createToggle("Enable Fly", function(v)
            if _G.Modules.Fly then _G.Modules.Fly.SetState(v) end
        end)

        createToggle("Infinite Jump", function(v)
            if _G.Modules.Player then
                _G.Modules.Player.InfJumpEnabled = v
            end
        end)

        createToggle("FullBright", function(v)
            if v then
                _G.OriginalLighting = {
                    Brightness = game.Lighting.Brightness,
                    ClockTime = game.Lighting.ClockTime,
                    FogEnd = game.Lighting.FogEnd,
                    FogStart = game.Lighting.FogStart,
                    GlobalShadows = game.Lighting.GlobalShadows
                }
                game.Lighting.Brightness = 2
                game.Lighting.ClockTime = 14
                game.Lighting.FogEnd = 100000
                game.Lighting.FogStart = 0
                game.Lighting.GlobalShadows = false
            else
                if _G.OriginalLighting then
                    game.Lighting.Brightness = _G.OriginalLighting.Brightness
                    game.Lighting.ClockTime = _G.OriginalLighting.ClockTime
                    game.Lighting.FogEnd = _G.OriginalLighting.FogEnd
                    game.Lighting.FogStart = _G.OriginalLighting.FogStart
                    game.Lighting.GlobalShadows = _G.OriginalLighting.GlobalShadows
                end
            end
        end)

    elseif name == "Combat" then
        -- ДОБАВЛЕНА КНОПКА GODMODE
        createToggle("Godmode (Invincible)", function(v)
            _G.GodmodeEnabled = v
            task.spawn(function()
                while _G.GodmodeEnabled do
                    if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
                        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
                        hum.Health = hum.MaxHealth
                        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    end
                    task.wait(0.1)
                end
                -- Когда выключаем, разрешаем умирать обратно
                if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
                    LP.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                end
            end)
        end)

        createToggle("ESP Monsters", function(v)
            if _G.Modules.ESP then _G.Modules.ESP.Enabled = v end
        end)
    end
end

local function addTabBtn(name)
    local t = Instance.new("TextButton", TabHolder)
    t.Size = UDim2.new(1, 0, 0, 45)
    t.Text = name
    t.Font = Enum.Font.GothamBold
    t.TextSize = 16
    t.TextColor3 = Color3.new(1, 1, 1)
    t.BackgroundTransparency = 1
    t.MouseButton1Click:Connect(function() showTab(name) end)
end

addTabBtn("Player")
addTabBtn("Combat")
showTab("Player")

return gui
