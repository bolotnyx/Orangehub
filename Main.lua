-- ORANGE HUB - AUTO-CONFIG MAIN
_G.Modules = {}

-- Эта функция автоматически берет ссылку на твой Main, чтобы не ошибиться в буквах
local function getBaseUrl()
    -- Если ты запускаешь через loadstring(game:HttpGet("ссылка")), 
    -- мы попробуем достать корень этой ссылки
    return "https://raw.githubusercontent.com/bolotnyx/Orangehub/main/"
end

local baseUrl = getBaseUrl()

local function Load(name, path)
    local success, content = pcall(function() return game:HttpGet(baseUrl .. path) end)
    if success and content and not content:find("404") then
        local func, err = loadstring(content)
        if func then
            _G.Modules[name] = func()
            print("✅ Модуль загружен: " .. name)
        else
            warn("❌ Ошибка в коде модуля " .. name .. ": " .. tostring(err))
        end
    else
        warn("❌ Не найден файл по ссылке: " .. baseUrl .. path)
    end
end

-- ЗАГРУЗКА
Load("InfiniteJump", "Modules/InfiniteJump.lua")
Load("FullBright", "Modules/FullBright.lua")
Load("Fly", "Modules/Fly.lua")

-- ЗАПУСК UI
local uiSuccess, uiContent = pcall(function() return game:HttpGet(baseUrl .. "UI.lua") end)
if uiSuccess and not uiContent:find("404") then
    loadstring(uiContent)()
else
    warn("❌ UI.lua не найден! Проверь, лежит ли он в корне рядом с Main.lua")
end
