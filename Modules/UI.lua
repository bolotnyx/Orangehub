-- [[ ORANGE HUB V4 - TOTAL FIXED CORE ]]
repeat task.wait() until game:IsLoaded()

if _G.OrangeHubLoaded then return end
_G.OrangeHubLoaded = true

-- 1. АНИМАЦИЯ (Профессиональная заставка)
local function RunCinematicIntro()
    local TS = game:GetService("TweenService")
    local blur = Instance.new("BlurEffect", game:GetService("Lighting"))
    local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(1, 0, 1, 0)
    main.BackgroundTransparency = 1
    
    local logo = Instance.new("TextLabel", main)
    logo.Size = UDim2.new(0, 100, 0, 100)
    logo.Position = UDim2.new(0.5, -50, 0.4, -50)
    logo.Text = "🍊"
    logo.TextSize = 100
    logo.BackgroundTransparency = 1
    logo.TextTransparency = 1

    TS:Create(blur, TweenInfo.new(1), {Size = 20}):Play()
    TS:Create(logo, TweenInfo.new(1), {TextTransparency = 0}):Play()
    task.wait(1.5)
    TS:Create(blur, TweenInfo.new(1), {Size = 0}):Play()
    TS:Create(logo, TweenInfo.new(1), {TextTransparency = 1}):Play()
    task.wait(1)
    sg:Destroy()
    blur:Destroy()
end

RunCinematicIntro()

-- 2. ЗАГРУЗКА ИНТЕРФЕЙСА (Твой чистый UI)
-- Мы загружаем его первым, чтобы появились кнопки
local UI_URL = "https://raw.githubusercontent.com/bolotnyx/Orangehub/main/Modules/UI.lua" 
-- (Если UI.lua у тебя на гитхабе, он загрузится. Если нет - вставь код UI сюда)
pcall(function() loadstring(game:HttpGet(UI_URL))() end)

-- 3. ЛОГИКА ФУНКЦИЙ (Тот самый "мозг", который заставляет кнопки работать)
local LP = game.Players.LocalPlayer

-- Логика Speed
task.spawn(function()
    while task.wait(0.1) do
        if _G.SpeedEnabled and LP.Character and LP.Character:FindFirstChild("Humanoid") then
            LP.Character.Humanoid.WalkSpeed = _G.WalkSpeedValue or 16
        elseif LP.Character and LP.Character:FindFirstChild("Humanoid") then
            -- Если выключено, возвращаем стандартную скорость
            if LP.Character.Humanoid.WalkSpeed ~= 16 and not _G.SpeedEnabled then
                LP.Character.Humanoid.WalkSpeed = 16
            end
        end
    end
end)

-- Логика Godmode
task.spawn(function()
    while task.wait(0.1) do
        if _G.GodmodeEnabled and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Health = hum.MaxHealth
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            end
        end
    end
end)

-- Логика ESP (С учетом твоих предпочтений)
-- Подсвечиваем: Mammoth, Cultist, Bears
-- Игнорируем: Mammoth Tusk, Wolf Spawner и т.д.
task.spawn(function()
    while task.wait(2) do
        if _G.MonsterESPActive then
            for _, obj in pairs(game.Workspace:GetDescendants()) do
                if (obj.Name:find("Mammoth") and not obj.Name:find("Tusk")) or 
                   obj.Name:find("Cultist") or 
                   obj.Name:find("Bear") then
                    
                    if not obj:FindFirstChild("SelectionBox") then
                        local box = Instance.new("SelectionBox", obj)
                        box.Adornee = obj
                        box.Color3 = Color3.fromRGB(255, 165, 0) -- Оранжевый для мамонтов и культистов
                        box.LineThickness = 0.05
                    end
                end
            end
        end
    end
end)

-- 4. ЗАГРУЗКА ОСТАЛЬНЫХ МОДУЛЕЙ
local function Load(name)
    local BASE_URL = "https://raw.githubusercontent.com/bolotnyx/Orangehub/main/Modules/"
    local url = BASE_URL .. name .. ".lua?nocache=" .. tostring(os.clock())
    pcall(function() loadstring(game:HttpGet(url))() end)
end

Load("Fly")
Load("InfiniteJump")
Load("FullBright")

print("--- ORANGE HUB V4 FULLY OPERATIONAL ---")
