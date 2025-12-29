-- [[ ORANGE HUB - GODMODE (NO-GLITCH VERSION) ]]
local LP = game:GetService("Players").LocalPlayer

local function RunGodmodeEngine()
    task.spawn(function()
        while true do
            if _G.GodmodeActive then
                local char = LP.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                
                if char and hum then
                    -- 1. Защита от распада (Anti-Wolf)
                    char.BreakJointsOnDeath = false
                    
                    -- 2. Блокируем смерть
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    
                    -- 3. Мгновенный хил (каждый кадр)
                    if hum.Health < hum.MaxHealth then
                        hum.Health = hum.MaxHealth
                    end
                    
                    -- 4. Если ХП упало в 0 (серверный килл), не даем застыть
                    if hum:GetState() == Enum.HumanoidStateType.Dead then
                        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end

                    -- 5. Удаляем скрипт урона
                    local hScript = char:FindFirstChild("Health")
                    if hScript then hScript:Destroy() end
                end
            end
            task.wait() -- Работает быстро, но не ломает систему
        end
    end)
end

-- ЗАПУСК (только один раз при загрузке модуля)
if not _G.GodmodeInitialized then
    _G.GodmodeInitialized = true
    RunGodmodeEngine()
end

-- Возвращаем пустую таблицу, чтобы ядро не ругалось
return {}
