-- Очищаем старые данные, чтобы всё загрузилось "с чистого листа"
_G.Modules = {}

-- Ссылка на твой репозиторий (проверь, что ник и название папки верные)
local repo = "https://raw.githubusercontent.com/bolotnyx/Orangehub/main/Modules/"

-- Эта штука (math.random) заставляет GitHub выдавать САМЫЙ новый код, игнорируя кэш
local cacheBuster = "?t=" .. tostring(math.random(1, 100000))

local function loadMod(name)
    local url = repo .. name .. ".lua" .. cacheBuster
    local success, result = pcall(function()
        -- Скачиваем и сразу запускаем код модуля
        return loadstring(game:HttpGet(url))()
    end)
    
    if success then
        _G.Modules[name] = result
        print("🍊 [OrangeHub]: Модуль " .. name .. " успешно загружен!")
    else
        warn("🍊 [OrangeHub]: ОНИМАТЕЛЬНО! Ошибка в модуле " .. name .. ": " .. tostring(result))
    end
end

-- ВАЖНО: UI должен загружаться ПОСЛЕДНИМ, 
-- чтобы он "видел" функции из Player и AntiAFK
loadMod("Player")
loadMod("Combat")
loadMod("AntiAFK")
loadMod("UI")

print("🍊 [OrangeHub]: Все системы запущены!")
