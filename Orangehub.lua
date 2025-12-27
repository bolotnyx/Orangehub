-- Orangehub.lua
repeat task.wait() until game:IsLoaded()

local Modules = {}
-- Добавляем метку времени, чтобы GitHub не выдавал старый код из кэша
local cacheBuster = "?v=" .. tostring(math.random(1, 999999))
local base = "https://raw.githubusercontent.com/bolotnyx/Orangehub/main/Modules/"

-- Список модулей для загрузки
local moduleList = {"UI", "Combat", "ESP", "Player", "AntiAFK"}

for _, m in ipairs(moduleList) do
    local url = base .. m .. ".lua" .. cacheBuster
    local ok, mod = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if ok then
        Modules[m] = mod
        print("🍊 [OrangeHub]: Loaded " .. m)
    else
        warn("🍊 [OrangeHub]: Failed to load " .. m .. " | Error: " .. tostring(mod))
    end
end

-- Делаем модули доступными глобально для взаимодействия
_G.Modules = Modules

-- Если UI загрузился, сообщаем об успехе
if Modules["UI"] then
    print("🍊 OrangeHub initialized successfully!")
else
    warn("🍊 OrangeHub: UI Module missing!")
end
