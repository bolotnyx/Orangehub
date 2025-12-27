-- Orangehub.lua
repeat task.wait() until game:IsLoaded()

-- Очищаем старое, если было
_G.Modules = nil
task.wait(0.1)

local Modules = {}
local cacheBuster = "?v=" .. tostring(math.random(1, 999999))
local base = "https://raw.githubusercontent.com/bolotnyx/Orangehub/main/Modules/"

-- СПИСОК ИСПРАВЛЕН: UI теперь в самом конце
local moduleList = {"Combat", "ESP", "Player", "AntiAFK", "Fly", "UI"}

for _, m in ipairs(moduleList) do
    local url = base .. m .. ".lua" .. cacheBuster
    local ok, mod = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if ok then
        Modules[m] = mod
        _G.Modules = Modules -- Обновляем глобальную таблицу после каждой загрузки
        print("🍊 [OrangeHub]: Loaded " .. m)
    else
        warn("🍊 [OrangeHub]: Failed to load " .. m .. " | Error: " .. tostring(mod))
    end
end

if Modules["UI"] then
    print("🍊 OrangeHub initialized successfully!")
else
    warn("🍊 OrangeHub: UI Module missing!")
end
