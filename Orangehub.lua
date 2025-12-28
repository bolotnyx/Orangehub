repeat task.wait() until game:IsLoaded()

if _G.OrangeHubLoaded then
    warn("🍊 OrangeHub уже загружен")
    return
end
_G.OrangeHubLoaded = true

-- Создаем единую таблицу для всех модулей
_G.Modules = {}

local BASE_URL = "https://raw.githubusercontent.com/bolotnyx/Orangehub/main/"

local ModuleList = {
    {Name = "Player", Path = "Modules/Player.lua"},
    {Name = "Combat", Path = "Modules/Combat.lua"},
    {Name = "ESP",    Path = "Modules/ESP.lua"},
    {Name = "UI",     Path = "UI.lua"}
}

for _, mod in ipairs(ModuleList) do
    local success, result = pcall(function()
        local cacheBuster = "?t=" .. os.time()
        local source = game:HttpGet(BASE_URL .. mod.Path .. cacheBuster)
        local func = loadstring(source)
        if func then
            return func()
        else
            error("Ошибка синтаксиса в " .. mod.Name)
        end
    end)

    if success then
        _G.Modules[mod.Name] = result
        print("✅ Загружен: " .. mod.Name)
    else
        warn("❌ Ошибка загрузки " .. mod.Name .. ": " .. tostring(result))
    end
end
