repeat task.wait() until game:IsLoaded()

if _G.OrangeHubLoaded then
    warn("🍊 OrangeHub уже загружен")
    return
end
_G.OrangeHubLoaded = true
_G.Modules = {}

local BASE_URL = "https://raw.githubusercontent.com/bolotnyx/Orangehub/main/"

local ModuleList = {
    {Name = "Player", Path = "Modules/Player.lua"},
    {Name = "Combat", Path = "Modules/Combat.lua"},
    {Name = "ESP",    Path = "Modules/ESP.lua"},
    {Name = "UI",     Path = "Modules/UI.lua"} -- ПУТЬ ИСПРАВЛЕН
}

print("🍊 OrangeHub: Запуск...")

for _, mod in ipairs(ModuleList) do
    local url = BASE_URL .. mod.Path .. "?t=" .. os.time()
    local success, source = pcall(function() return game:HttpGet(url) end)
    
    if success and source and not source:find("404: Not Found") then
        local func, err = loadstring(source)
        if func then
            local modSuccess, result = pcall(func)
            if modSuccess then
                _G.Modules[mod.Name] = result
                print("✅ Загружен: " .. mod.Name)
            else
                warn("❌ Ошибка выполнения " .. mod.Name .. ": " .. tostring(result))
            end
        else
            warn("❌ Ошибка кода в " .. mod.Name .. ": " .. tostring(err))
        end
    else
        warn("❌ Не найден файл: " .. mod.Path)
    end
end
