local userName = "bolotnyx"
local repoName = "Orangehub"
local branch = "main"

local function getRaw(path)
    return "https://raw.githubusercontent.com/" .. userName .. "/" .. repoName .. "/" .. branch .. "/" .. path
end

-- Глобальная таблица для связи
_G.Modules = {}

-- Функция загрузки
local function Load(name, path)
    local success, content = pcall(function() return game:HttpGet(getRaw(path)) end)
    if success then
        local func, err = loadstring(content)
        if func then
            _G.Modules[name] = func()
        else
            warn("Ошибка в коде модуля " .. name .. ": " .. tostring(err))
        end
    else
        warn("Не удалось скачать модуль " .. name)
    end
end

-- Сначала качаем функции (проверь, что файлы реально есть в папке Modules!)
Load("InfiniteJump", "Modules/InfiniteJump.lua")
Load("FullBright", "Modules/FullBright.lua")
Load("Fly", "Modules/Fly.lua")

-- В самом конце запускаем UI
local uiSuccess, uiContent = pcall(function() return game:HttpGet(getRaw("UI.lua")) end)
if uiSuccess then
    loadstring(uiContent)()
else
    warn("Не удалось загрузить UI.lua")
end
