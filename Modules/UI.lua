-- [[ ORANGE HUB V4 - UI ENHANCED (CLEAN & FIXED) ]]
local LP = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- Удаление старой панели
if game.CoreGui:FindFirstChild("OrangeHub_V4") then 
    game.CoreGui.OrangeHub_V4:Destroy() 
end

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "OrangeHub_V4"

-- === ГЛАВНАЯ ПАНЕЛЬ ===
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 520, 0, 360)
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 27)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- === САЙДБАР ===
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(33, 33, 35)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "ORANGE HUB"
Title.TextColor3 = Color3.fromRGB(255, 165, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.BackgroundTransparency = 1

-- === КНОПКИ СВЕРНУТЬ / РАЗВЕРНУТЬ ===
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

-- === КОНТЕЙНЕР ДЛЯ ЭЛЕМЕНТОВ ===
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -180, 1, -70)
Container.Position = UDim2.new(0, 175, 0, 60)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 10)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- === ФУНКЦИИ КОНСТРУКТОРА (С ПАМЯТЬЮ ЦВЕТА) ===

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

local function createToggle(name, globalVar, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -10, 0, 45)
    
    -- Проверка состояния при отрисовке (чтобы кнопка не была черной)
    local state = _G[globalVar] or false
    btn.BackgroundColor3 = state and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(45, 45, 48)
    
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        _G[globalVar] = not _G[globalVar]
        local newState = _G[globalVar]
        
        -- Плавная смена цвета
        TweenService:Create(btn, TweenInfo.new(0.3), {
            BackgroundColor3 = newState and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(45, 45, 48)
        }):Play()
        
        callback(newState)
    end)
end

-- === ВКЛАДКИ ===
local TabHolder = Instance.new("Frame", Sidebar)
TabHolder.Size = UDim2.new(1, 0, 1, -80)
TabHolder.Position = UDim2.new(0, 0, 0, 70)
TabHolder.BackgroundTransparency = 1
local TabLayout = Instance.new("UIListLayout", TabHolder)
TabLayout.Padding = UDim.new(0, 5)

local function showTab(name)
    for _, v in pairs(Container:GetChildren()) do
        if v:IsA("TextButton") or v:IsA("TextBox") then v:Destroy() end
    end

    if name == "Player" then
        createInput("WALK SPEED", function(v) _G.WalkSpeedValue = v end)
        createToggle("Enable Walk Speed", "SpeedEnabled", function(v)
            -- Вся логика теперь в WalkSpeed.lua на GitHub
        end)

        createInput("FLY SPEED", function(v) _G.FlySpeedValue = v end)
        createToggle("Enable Fly", "FlyEnabled", function(v)
            if _G.Modules.Fly then _G.Modules.Fly.SetState(v) end
        end)

        createToggle("Infinite Jump", "InfJumpEnabled", function(v)
            -- Логика в InfiniteJump.lua
        end)

        createToggle("FullBright", "FullBrightEnabled", function(v)
            if v then
                _G.OriginalLighting = {Brightness = game.Lighting.Brightness, ClockTime = game.Lighting.ClockTime}
                game.Lighting.Brightness = 2
                game.Lighting.ClockTime = 14
            elseif _G.OriginalLighting then
                game.Lighting.Brightness = _G.OriginalLighting.Brightness
                game.Lighting.ClockTime = _G.OriginalLighting.ClockTime
            end
        end)

    elseif name == "Combat" then
        createToggle("Godmode (Anti-Wolf)", "GodmodeEnabled", function(v)
            -- Логика в Godmode.lua
        end)

        createToggle("ESP Monsters", "MonsterESPActive", function(v)
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
