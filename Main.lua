_G.Modules = {}

local userName = "bolotnyx"
local repoName = "Orangehub" -- Все как ты сказал
local branch = "main"

local function getRawUrl(path)
    return "https://raw.githubusercontent.com/" .. userName .. "/" .. repoName .. "/" .. branch .. "/" .. path
end

local function LoadModule(name, path)
    local url = getRawUrl(path)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if success then
        _G.Modules[name] = result
        print("🍊 [Orange Hub]: " .. name .. " загружен успешно!")
    else
        -- Это поможет нам увидеть в F9, если ссылка битая
        warn("🍊 [Orange Hub]: ОШИБКА ЗАГРУЗКИ " .. name .. " по адресу: " .. url)
    end
end

-- ЗАГРУЗКА (Проверь, что папка Modules с большой буквы на GitHub!)
LoadModule("Fly", "Modules/Fly.lua")
LoadModule("InfiniteJump", "Modules/InfiniteJump.lua")
LoadModule("FullBright", "Modules/FullBright.lua")
LoadModule("ESP", "Modules/ESP.lua")
LoadModule("Combat", "Modules/Combat.lua")
LoadModule("AntiAFK", "Modules/AntiAFK.lua")

-- ЗАПУСК UI
local uiUrl = getRawUrl("UI.lua")
local uiSuccess, uiResult = pcall(function()
    return loadstring(game:HttpGet(uiUrl))()
end)

if not uiSuccess then
    warn("🍊 [Orange Hub]: UI не скачался! Проверь файл UI.lua в корне.")
end
