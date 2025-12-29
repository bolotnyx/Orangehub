-- [[ ORANGE HUB - WALK SPEED MODULE ]]
local LP = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

-- Функция настройки Humanoid
local function ApplySpeedLogic(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end

    -- Очистка старой связи, если она была (для предотвращения утечек памяти)
    if _G.SpeedConnection then 
        _G.SpeedConnection:Disconnect() 
        _G.SpeedConnection = nil
    end

    -- Основная логика через событие изменения скорости
    _G.SpeedConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if _G.SpeedEnabled and _G.WalkSpeedValue then
            -- Если текущая скорость не равна нашей чит-скорости — ставим свою
            if humanoid.WalkSpeed ~= _G.WalkSpeedValue then
                humanoid.WalkSpeed = _G.WalkSpeedValue
            end
        end
    end)

    -- Первичная установка при включении
    if _G.SpeedEnabled and _G.WalkSpeedValue then
        humanoid.WalkSpeed = _G.WalkSpeedValue
    end

    -- Фикс анимации прыжка (чтобы не застывал "прямым")
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
end

-- Следим за смертью и респавном персонажа
LP.CharacterAdded:Connect(function(newChar)
    ApplySpeedLogic(newChar)
end)

-- Если персонаж уже загружен на момент запуска скрипта
if LP.Character then
    ApplySpeedLogic(LP.Character)
end

-- Дополнительный "мягкий" цикл для критических случаев (раз в секунду)
-- Это поможет, если античит игры очень агрессивно сбрасывает значения
task.spawn(function()
    while true do
        if _G.SpeedEnabled and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and _G.WalkSpeedValue and hum.WalkSpeed ~= _G.WalkSpeedValue then
                hum.WalkSpeed = _G.WalkSpeedValue
            end
        end
        task.wait(1) 
    end
end)

print("✅ [ORANGE HUB] WalkSpeed Module Loaded Successfully")
