-- [[ ORANGE HUB V4 - ПРЯМОЕ ЯДРО ]]
repeat task.wait() until game:IsLoaded()

-- Защита от дублей
if _G.OrangeHubLoaded then
    warn("🍊 OrangeHub уже запущен!")
    return
end
_G.OrangeHubLoaded = true

print("🍊 OrangeHub: Начинаю прямую загрузку модулей...")

_G.Modules = {}

-- Прямые ссылки (Проверь, чтобы названия файлов на GitHub точно совпадали!)
local files = {
    ["Player"] = "https://raw.githubusercontent.com/bolotnyx/Orangehub/main/Modules/Player.lua",
    ["Combat"] = "https://raw.githubusercontent.com/bolotnyx/Orangehub/main/Modules/Combat.lua",
    ["ESP"]    = "https://raw.githubusercontent.com/bolotnyx/Orangehub/main/Modules/ESP.lua",
    ["UI"]     = "https://raw.githubusercontent.com/bolotnyx/Orangehub/main/Modules/UI.lua"
}

for name, url in pairs(files) do
    task.spawn(function()
        local success, source = pcall(function() 
            return game:HttpGet(url .. "?t=" .. os.time()) 
        end)
        
        if success and source and not source:find("404") then
            local func, err = loadstring(source)
            if func then
                local modSuccess, result = pcall(func)
                if modSuccess then
                    _G.Modules[name] = result
                    print("✅ Модуль [" .. name .. "] загружен")
                else
                    warn("❌ Ошибка выполнения модуля " .. name .. ": " .. tostring(result))
                end
            else
                warn("❌ Ошибка кода в " .. name .. ": " .. tostring(err))
            end
        else
            warn("❌ Не удалось скачать файл: " .. name .. " (Проверь ссылку!)")
        end
    end)
end

print("🍊 OrangeHub: Все запросы отправлены. Проверь наличие UI.")
