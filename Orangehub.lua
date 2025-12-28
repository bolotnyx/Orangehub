-- ORANGE HUB [NEW CORE LOADER]
_G.Modules = {}

-- Авто-определение пути (чтобы не ошибиться в ссылках)
local baseUrl = "https://raw.githubusercontent.com/bolotnyx/Orangehub/main/"

local function Load(name, path)
    local success, content = pcall(function() return game:HttpGet(baseUrl .. path) end)
    if success and content and not content:find("404") then
        local func, err = loadstring(content)
        if func then
            _G.Modules[name] = func()
            print("✅ Модуль загружен: " .. name)
        else
            warn("❌ Ошибка в " .. name .. ": " .. err)
        end
    else
        warn("❌ Файл не найден: " .. path)
    end
end

-- Загружаем запчасти
Load("InfiniteJump", "Modules/InfiniteJump.lua")
Load("FullBright", "Modules/FullBright.lua")
Load("Fly", "Modules/Fly.lua")

-- Загружаем внешний вид
local uiSuccess, uiContent = pcall(function() return game:HttpGet(baseUrl .. "UI.lua") end)
if uiSuccess and not uiContent:find("404") then
    loadstring(uiContent)()
else
    warn("❌ UI.lua не найден по ссылке: " .. baseUrl .. "UI.lua")
end
