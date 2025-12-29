-- [[ ORANGE HUB V4 - CINEMATIC INTRO ]]
repeat task.wait() until game:IsLoaded()

if _G.OrangeHubLoaded then return end
_G.OrangeHubLoaded = true

-- ==========================================
--        ПРОФЕССИОНАЛЬНАЯ АНИМАЦИЯ 🍊
-- ==========================================
local function RunCinematicIntro()
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local Lighting = game:GetService("Lighting")
    
    local sg = Instance.new("ScreenGui")
    sg.Name = "OrangeIntro"
    sg.DisplayOrder = 999
    sg.IgnoreGuiInset = true
    sg.Parent = CoreGui

    -- Размытие фона
    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Lighting
    TweenService:Create(blur, TweenInfo.new(1), {Size = 25}):Play()

    local main = Instance.new("Frame")
    main.Size = UDim2.new(1, 0, 1, 0)
    main.BackgroundTransparency = 1
    main.Parent = sg

    -- 1. Появление Апельсина
    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(0, 100, 0, 100)
    logo.Position = UDim2.new(0.5, -50, 0.45, -50)
    logo.BackgroundTransparency = 1
    logo.Text = "🍊"
    logo.TextSize = 100
    logo.TextTransparency = 1
    logo.Parent = main

    TweenService:Create(logo, TweenInfo.new(1.2, Enum.EasingStyle.Back), {TextTransparency = 0, Position = UDim2.new(0.5, -50, 0.4, -50)}):Play()
    task.wait(1.2)

    -- 2. Постепенное появление надписи (по буквам)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 400, 0, 50)
    title.Position = UDim2.new(0.5, -200, 0.55, 0)
    title.BackgroundTransparency = 1
    title.Text = ""
    title.TextColor3 = Color3.fromRGB(255, 140, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 40
    title.Parent = main

    -- Эффект свечения для текста
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 165, 0)
    stroke.Thickness = 0
    stroke.Transparency = 1
    stroke.Parent = title
    TweenService:Create(stroke, TweenInfo.new(1), {Thickness = 2, Transparency = 0.5}):Play()

    local fullText = "ORANGE HUB"
    for i = 1, #fullText do
        title.Text = string.sub(fullText, 1, i)
        -- Звук клика можно добавить тут, если нужно
        task.wait(0.12) -- Скорость печати букв
    end

    task.wait(1.5) -- Пауза в конце, когда всё появилось

    -- 3. Плавное исчезновение перед открытием меню
    local fadeOut = TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    TweenService:Create(logo, fadeOut, {TextTransparency = 1}):Play()
    TweenService:Create(title, fadeOut, {TextTransparency = 1}):Play()
    TweenService:Create(stroke, fadeOut, {Transparency = 1}):Play()
    TweenService:Create(blur, fadeOut, {Size = 0}):Play()
    
    task.wait(0.7)
    sg:Destroy()
    blur:Destroy()
end

-- ЗАПУСК АНИМАЦИИ (ждем её окончания перед загрузкой меню)
RunCinematicIntro()

-- ==========================================
--    ЗАГРУЗКА МОДУЛЕЙ И ОТКРЫТИЕ МЕНЮ
-- ==========================================
local BASE_URL = "https://raw.githubusercontent.com/bolotnyx/Orangehub/main/Modules/"
_G.Modules = {}

local function Load(name)
    local url = BASE_URL .. name .. ".lua?nocache=" .. tostring(os.clock())
    local s, res = pcall(function() return game:HttpGet(url) end)
    
    if s and res and not res:find("404") then
        local f, err = loadstring(res)
        if f then
            _G.Modules[name] = f()
            print("✅ Loaded: " .. name)
        else
            warn("❌ Error: " .. err)
        end
    end
end

-- Теперь модули и UI загружаются только ПОСЛЕ анимации
Load("Player")
Load("Fly")
Load("InfiniteJump")
Load("FullBright")
Load("ESP")
Load("UI") -- Меню откроется здесь

print("--- ORANGE HUB V4 ACTIVATED ---")
