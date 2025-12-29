-- [[ ORANGE HUB V4 - FINAL CORE WITH PRO INTRO ]]
repeat task.wait() until game:IsLoaded()

if _G.OrangeHubLoaded then return end
_G.OrangeHubLoaded = true

-- ==========================================
--        ПРОФЕССИОНАЛЬНАЯ АНИМАЦИЯ 🍊
-- ==========================================
local function ShowProfessionalIntro()
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local Lighting = game:GetService("Lighting")
    
    -- Создаем контейнер интерфейса
    local sg = Instance.new("ScreenGui")
    sg.Name = "OrangeIntro"
    sg.DisplayOrder = 999
    sg.IgnoreGuiInset = true
    sg.Parent = CoreGui

    -- Эффект размытия заднего плана
    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Lighting
    TweenService:Create(blur, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = 20}):Play()

    -- Главный фрейм на весь экран
    local main = Instance.new("Frame")
    main.Size = UDim2.new(1, 0, 1, 0)
    main.BackgroundTransparency = 1
    main.Parent = sg

    -- Иконка Апельсина
    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(0, 100, 0, 100)
    logo.Position = UDim2.new(0.5, -50, 0.5, -60)
    logo.BackgroundTransparency = 1
    logo.Text = "🍊"
    logo.TextSize = 80
    logo.TextTransparency = 1
    logo.ZIndex = 2
    logo.Parent = main

    -- Текст ORANGE HUB
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 300, 0, 50)
    title.Position = UDim2.new(0.5, -150, 0.5, 40)
    title.BackgroundTransparency = 1
    title.Text = "ORANGE HUB"
    title.TextColor3 = Color3.fromRGB(255, 145, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 32
    title.TextTransparency = 1
    title.Parent = main

    -- Кольцо загрузки
    local ring = Instance.new("Frame")
    ring.Size = UDim2.new(0, 130, 0, 130)
    ring.Position = UDim2.new(0.5, -65, 0.5, -75)
    ring.BackgroundTransparency = 1
    ring.Parent = main

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 165, 0)
    stroke.Thickness = 4
    stroke.Transparency = 1
    stroke.Parent = ring

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ring

    -- Анимация появления элементов
    local fadeInInfo = TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(logo, fadeInInfo, {TextTransparency = 0, Position = UDim2.new(0.5, -50, 0.5, -75)}):Play()
    TweenService:Create(title, fadeInInfo, {TextTransparency = 0}):Play()
    TweenService:Create(stroke, fadeInInfo, {Transparency = 0.2}):Play()

    -- Анимация бесконечного вращения кольца
    local rotateInfo = TweenInfo.new(2.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
    local rotationTween = TweenService:Create(ring, rotateInfo, {Rotation = 360})
    rotationTween:Play()

    -- Имитация "умной загрузки" (ждем чуть-чуть для красоты)
    task.wait(3.5)

    -- Анимация исчезновения
    local fadeOutInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    TweenService:Create(logo, fadeOutInfo, {TextTransparency = 1}):Play()
    TweenService:Create(title, fadeOutInfo, {TextTransparency = 1}):Play()
    TweenService:Create(stroke, fadeOutInfo, {Transparency = 1}):Play()
    TweenService:Create(blur, fadeOutInfo, {Size = 0}):Play()
    
    task.wait(0.8)
    sg:Destroy()
    blur:Destroy()
end

-- Запускаем анимацию в отдельном потоке
task.spawn(ShowProfessionalIntro)

-- ==========================================
--         ЛОГИКА ЗАГРУЗКИ МОДУЛЕЙ
-- ==========================================
local BASE_URL = "https://raw.githubusercontent.com/bolotnyx/Orangehub/main/Modules/"
_G.Modules = {}

local function Load(name)
    -- Уникальная ссылка для обхода кэша GitHub
    local url = BASE_URL .. name .. ".lua?nocache=" .. tostring(os.clock())
    local s, res = pcall(function() return game:HttpGet(url) end)
    
    if s and res and not res:find("404") then
        local f, err = loadstring(res)
        if f then
            _G.Modules[name] = f()
            print("✅ [ORANGE HUB] " .. name .. " loaded")
        else
            warn("❌ [ORANGE HUB] Error in " .. name .. ": " .. err)
        end
    else
        warn("❌ [ORANGE HUB] Failed to fetch " .. name)
    end
end

-- Порядок загрузки модулей
-- Напоминание: ESP настроен на Мамонтов, Культистов и Медведей
Load("Player")
Load("Fly")
Load("InfiniteJump")
Load("FullBright")
Load("ESP")
Load("UI")

print("--- ORANGE HUB V4 ACTIVATED ---")
