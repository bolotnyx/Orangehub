-- Инициализация таблицы модулей
_G.Modules = {}

local userName = "bolotnyx" -- Ник с маленькой буквы
local repoName = "Orangehub" -- ЗАМЕНИ, если репозиторий на GitHub называется иначе
local branch = "main"

local function getRawUrl(path)
    return "https://raw.githubusercontent.com/" .. userName .. "/" .. repoName .. "/" .. branch .. "/" .. path
end

-- Функция безопасной загрузки
local function LoadModule(name, path)
    local url = getRawUrl(path)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if success then
        _G.Modules[name] = result
        print("🍊 [Orange Hub]: " .. name .. " загружен!")
    else
        warn("🍊 [Orange Hub]: Ошибка загрузки " .. name .. ": " .. tostring(result))
    end
end

-- 1. ЗАГРУЖАЕМ МОДУЛИ (Пути внутри твоего репозитория)
LoadModule("Fly", "Modules/Fly.lua")
LoadModule("InfiniteJump", "Modules/InfiniteJump.lua")
LoadModule("FullBright", "Modules/FullBright.lua")
LoadModule("ESP", "Modules/ESP.lua")
LoadModule("Combat", "Modules/Combat.lua")
LoadModule("AntiAFK", "Modules/AntiAFK.lua")

-- 2. ЗАПУСКАЕМ ИНТЕРФЕЙС (UI.lua лежит в корне репозитория)
local uiSuccess, uiResult = pcall(function()
    return loadstring(game:HttpGet(getRawUrl("UI.lua")))()
end)

if uiSuccess then
    print("🍊 [Orange Hub]: Интерфейс запущен!")
else
    warn("🍊 [Orange Hub]: Ошибка запуска UI: " .. tostring(uiResult))
end
