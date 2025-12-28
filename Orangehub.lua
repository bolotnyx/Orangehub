-- Ждём загрузку игры
repeat task.wait() until game:IsLoaded()

-- Защита от повторного запуска
if _G.OrangeHubLoaded then
    warn("🍊 OrangeHub уже загружен")
    return
end
_G.OrangeHubLoaded = true

print("🍊 OrangeHub: Запуск ядра...")

-- Глобальная таблица для связи всех частей
_G.OrangeHub = {
    Modules = {},
    Settings = {
        WalkSpeed = 100,
        FlySpeed = 50,
        ESPEnabled = false
    }
}

-- Ссылка на твой репозиторий
local BASE_URL = "https://raw.githubusercontent.com/bolotnyx/Orangehub/main/"

-- Список файлов для загрузки (Modules/Player.lua и т.д.)
local ModuleList = {
    {Name = "Player", Path = "Modules/Player.lua"},
    {Name = "Combat", Path = "Modules/Combat.lua"},
    {Name = "ESP",    Path = "Modules/ESP.lua"},
    {Name = "UI",     Path = "UI.lua"} -- UI обычно лежит в корне или папке, проверь путь
}

-- Функция загрузки
for _, mod in ipairs(ModuleList) do
    local success, result = pcall(function()
        -- Добавляем случайное число в конец ссылки, чтобы избежать кэша GitHub
        local cacheBuster = "?t=" .. os.time()
        local source = game:HttpGet(BASE_URL .. mod.Path .. cacheBuster)
        local func = loadstring(source)
        if func then
            return func()
        else
            error("Ошибка синтаксиса в файле " .. mod.Name)
        end
    end)

    if success then
        _G.OrangeHub.Modules[mod.Name] = result
        print("✅ Модуль загружен: " .. mod.Name)
    else
        warn("❌ Ошибка загрузки модуля " .. mod.Name .. ": " .. tostring(result))
    end
end

print("🍊 OrangeHub полностью готов к работе!")
