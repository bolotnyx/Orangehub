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
    else
        warn("Ошибка загрузки: " .. name)
    end
end

-- Загружаем только два нужных нам модуля для теста
LoadModule("InfiniteJump", "Modules/InfiniteJump.lua")
LoadModule("FullBright", "Modules/FullBright.lua")

-- Загружаем UI
local uiUrl = getRawUrl("UI.lua")
local success, err = pcall(function()
    loadstring(game:HttpGet(uiUrl))()
end)

if not success then
    print("Ошибка UI: " .. tostring(err))
end
