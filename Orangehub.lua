-- [[ ORANGE HUB V4 - FINAL CORE ]]
repeat task.wait() until game:IsLoaded()

if _G.OrangeHubLoaded then return end
_G.OrangeHubLoaded = true

-- === АНИМАЦИЯ АПЕЛЬСИНА ===
local function ShowOrangeIntro()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "OrangeIntro"
    screenGui.Parent = game:GetService("CoreGui") -- Чтобы не удалялось при смерти

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0, 200, 0, 100)
    textLabel.Position = UDim2.new(0.5, -100, 0.4, -50)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 165, 0) -- Оранжевый цвет
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.FredokaOne
    textLabel.Text = "🍊"
    textLabel.Parent = screenGui

    -- Простая анимация появления и увеличения
    for i = 1, 10 do
        textLabel.TextTransparency = 1 - (i/10)
        textLabel.Size = UDim2.new(0, 200 + (i*5), 0, 100 + (i*5))
        task.wait(0.05)
    end
    
    textLabel.Text = "🍊 ORANGE HUB"
    task.wait(1.5) -- Время показа апельсина

    -- Исчезновение
    for i = 1, 10 do
        textLabel.TextTransparency = i/10
        task.wait(0.05)
    end
    screenGui:Destroy()
end

-- Запускаем анимацию в отдельном потоке, чтобы она не тормозила загрузку модулей
task.spawn(ShowOrangeIntro)
-- ==========================

local BASE_URL = "https://raw.githubusercontent.com/bolotnyx/Orangehub/main/Modules/"
_G.Modules = {}

-- (Дальше идет твой стандартный код загрузки)
local function Load(name)
    local url = BASE_URL .. name .. ".lua?nocache=" .. tostring(os.clock())
    local s, res = pcall(function() return game:HttpGet(url) end)
    if s and res and not res:find("404") then
        local f, err = loadstring(res)
        if f then
            _G.Modules[name] = f()
            print("✅ " .. name .. " loaded")
        else
            warn("❌ Error in " .. name .. ": " .. err)
        end
    end
end

Load("Player")
Load("Fly")
Load("InfiniteJump")
Load("FullBright")
Load("ESP")
Load("UI")
