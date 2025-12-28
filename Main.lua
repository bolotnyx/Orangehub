_G.Modules = {}

local userName = "bolotnyx"
local repoName = "Orangehub"
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
        print("🍊 [Orange Hub]: " .. name .. " загружен!")
    else
        warn("🍊 [Orange Hub]: Ошибка загрузки модуля " .. name)
    end
end

-- ЗАГРУЗКА ВСЕХ МОДУЛЕЙ
LoadModule("Fly", "Modules/Fly.lua")
LoadModule("InfiniteJump", "Modules/InfiniteJump.lua")
LoadModule("FullBright", "Modules/FullBright.lua")
LoadModule("ESP", "Modules/ESP.lua")
LoadModule("Combat", "Modules/Combat.lua")
LoadModule("AntiAFK", "Modules/AntiAFK.lua")

-- ЗАПУСК ИНТЕРФЕЙСА (UI.lua должен быть в корне репозитория)
local uiUrl = getRawUrl("UI.lua")
task.spawn(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet(uiUrl))()
    end)
    if not success then
        warn("🍊 [Orange Hub]: Ошибка UI: " .. tostring(err))
    end
end)
