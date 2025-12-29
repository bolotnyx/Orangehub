-- [[ ORANGE HUB - REFINED GODMODE MODULE ]]
local LP = game:GetService("Players").LocalPlayer

-- Функция запуска движка бессмертия
local function StartGodmode()
    task.spawn(function()
        while true do
            if _G.GodmodeActive then
                local char = LP.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                
                if char and hum then
                    -- 1. ЗАЩИТА ОТ РАЗВАЛА (Anti-Wolf / Anti-Killbrick)
                    -- Не дает персонажу развалиться на части при получении урона
                    char.BreakJointsOnDeath = false
                    
                    -- 2. БЛОКИРОВКА СМЕРТИ
                    -- Запрещает Humanoid переходить в состояние "Dead"
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    
                    -- 3. СУПЕР-РЕГЕНЕРАЦИЯ
                    -- Мгновенно лечит любые укусы волков
                    if hum.Health < hum.MaxHealth then
                        hum.Health = hum.MaxHealth
                    end
                    
                    -- 4. АНТИ-ФРИЗ (Фикс "кирпичности")
                    -- Если сервер поставил 0 HP, персонаж может упасть. Мы его поднимаем.
                    if hum.Health <= 0.1 then
                        hum.Health = 100
                        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end

                    -- 5. УДАЛЕНИЕ СКРИПТА УРОНА
                    -- Находим и удаляем стандартный скрипт Health, который есть в каждом персонаже
                    local hScript = char:FindFirstChild("Health")
                    if hScript then hScript:Destroy() end
                end
            end
            task.wait() -- Максимальная скорость работы
        end
    end)
end

-- Автозапуск логики при загрузке модуля
if not _G.GodmodeInitialized then
    _G.GodmodeInitialized = true
    StartGodmode()
end

print("✅ [ORANGE HUB] Godmode Module Loaded (Anti-Brick Version)")
return {Loaded = true}
