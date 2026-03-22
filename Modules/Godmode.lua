-- [[ ORANGE HUB V4 - TRUE GODMODE ]]
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local GodmodeMod = {
    Enabled = false
}

local connection = nil

local function attachGodmode(char)
    local hum = char:WaitForChild("Humanoid", 10)
    if not hum then return end

    -- Отключаем предыдущее соединение если было
    if connection then
        connection:Disconnect()
        connection = nil
    end

    connection = hum.HealthChanged:Connect(function(newHealth)
        if GodmodeMod.Enabled and newHealth < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
    end)
end

-- Подключаемся к текущему персонажу
if player.Character then
    attachGodmode(player.Character)
end

-- И к каждому новому после респауна
player.CharacterAdded:Connect(function(char)
    attachGodmode(char)
end)

return GodmodeMod
