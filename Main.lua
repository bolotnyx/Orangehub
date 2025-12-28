local userName = "bolotnyx"
local repoName = "Orangehub"
local branch = "main"

-- Подготовка глобальных данных
_G.Modules = {}
_G.FlySpeedValue = 50
_G.WalkSpeedValue = 100

local function getRaw(path)
    return "https://raw.githubusercontent.com/" .. userName .. "/" .. repoName .. "/" .. branch .. "/" .. path
end

local function Load(name, path)
    local url = getRaw(path)
    local success, content = pcall(function() return game:HttpGet(url) end)
    
    if success and content and content ~= "" then
        local func, err = loadstring(content)
        if func then
            _G.Modules[name] = func()
            print("🍊 [Orange Hub]: Модуль " .. name .. " готов!")
        else
            warn("🍊 [Orange Hub]: Ошибка в коде " .. name .. ": " .. err)
        end
    else
        warn("🍊 [Orange Hub]: Не удалось загрузить " .. path)
    end
end

-- ЗАГРУЗКА МОДУЛЕЙ
Load("InfiniteJump", "Modules/InfiniteJump.lua")
Load("FullBright", "Modules/FullBright.lua")
Load("Fly", "Modules/Fly.lua")

task.wait(0.3) -- Пауза, чтобы функции успели прописаться в памяти

-- ЗАГРУЗКА ИНТЕРФЕЙСА
local uiSuccess, uiContent = pcall(function() return game:HttpGet(getRaw("UI.lua")) end)
if uiSuccess and uiContent ~= "" then
    loadstring(uiContent)()
else
    warn("🍊 [Orange Hub]: UI.lua не найден на GitHub!")
end
