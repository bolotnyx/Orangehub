-- [[ ORANGE HUB V4 - TRUE GODMODE ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local GodmodeMod = {
    Enabled = false
}

local heartbeatConn = nil
local deadStateConns = {}

local function attachGodmode(char)
    -- Очищаем старые соединения
    if heartbeatConn then heartbeatConn:Disconnect(); heartbeatConn = nil end
    for _, c in ipairs(deadStateConns) do c:Disconnect() end
    deadStateConns = {}

    local hum = char:WaitForChild("Humanoid", 10)
    if not hum then return end

    local originalMax = hum.MaxHealth

    heartbeatConn = RunService.Heartbeat:Connect(function()
        if not GodmodeMod.Enabled then return end

        -- 1. Запрещаем умирание
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

        -- 2. Восстанавливаем здоровье каждый кадр
        if hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end

        -- 3. Если MaxHealth изменился — возвращаем
        if hum.MaxHealth ~= originalMax and originalMax > 0 then
            hum.MaxHealth = originalMax
        end
    end)

    -- При выключении — возвращаем Dead state
    table.insert(deadStateConns, hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not GodmodeMod.Enabled then
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end
    end))
end

-- Подключаемся к текущему персонажу
if player.Character then
    attachGodmode(player.Character)
end

-- И к каждому новому после респауна
player.CharacterAdded:Connect(function(char)
    task.wait(0.5) -- ждём загрузки персонажа
    attachGodmode(char)
end)

return GodmodeMod
