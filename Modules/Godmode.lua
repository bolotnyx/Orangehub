-- [[ ADVANCED REMOTE BYPASS - GODMODE ]]
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- Список подозрительных названий событий, которые игры используют для урона
local damageKeywords = {"Damage", "TakeDamage", "Hit", "Ouch", "Health", "Hurt", "Burn"}

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- Если скрипт игры пытается вызвать FireServer
    if method == "FireServer" then
        local remoteName = tostring(self)
        
        -- Проверяем, есть ли в названии события слова, связанные с уроном
        for _, keyword in ipairs(damageKeywords) do
            if string.find(remoteName:lower(), keyword:lower()) then
                warn("Блокирована попытка нанести урон через: " .. remoteName)
                return nil -- Прерываем выполнение, сервер никогда не узнает об уроне
            end
        end
    end

    return oldNamecall(self, unpack(args))
end)

setreadonly(mt, true)
print("Anti-Damage Remote Bypass Loaded.")
