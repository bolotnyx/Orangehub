-- [[ ORANGE HUB - ULTIMATE GODMODE ENGINE ]]
local LP = game:GetService("Players").LocalPlayer

local function GodmodeEngine(state)
    _G.GodmodeActive = state
    
    if _G.GodmodeActive then
        task.spawn(function()
            local char = LP.Character
            if not char then return end
            
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                -- МЕТОД 1: ПОДМЕНА ХЬЮМАНОИДА (Обход серверного урона)
                -- Мы создаем копию, которая не привязана к серверным скриптам урона
                local newHum = hum:Clone()
                newHum.Parent = char
                hum:Destroy()
                LP.Character = char -- Переподключаем персонажа
                
                -- МЕТОД 2: УДАЛЕНИЕ ОБРАБОТЧИКА
                -- Удаляем стандартный скрипт Roblox, который отвечает за получение урона
                local healthScript = char:FindFirstChild("Health")
                if healthScript then healthScript:Destroy() end
                
                -- МЕТОД 3: БЛОКИРОВКА СОСТОЯНИЙ
                newHum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                newHum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                newHum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                
                print("🛡️ Godmode Engine: FULL ACTIVE")

                -- ЦИКЛ ПОДДЕРЖКИ (Бесконечный хил и проверка на развал тела)
                while _G.GodmodeActive and char and char.Parent do
                    if newHum then
                        if newHum.Health < newHum.MaxHealth then
                            newHum.Health = newHum.MaxHealth
                        end
                        -- Если сервер принудительно ставит 0 HP
                        if newHum:GetState() == Enum.HumanoidStateType.Dead then
                            newHum:ChangeState(Enum.HumanoidStateType.Physics)
                        end
                    end
                    task.wait() -- Максимальная частота (каждый кадр)
                end
            end
        end)
    else
        -- ОТКЛЮЧЕНИЕ: Убиваем персонажа, чтобы сбросить баги и вернуть нормальный Humanoid
        if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
            LP.Character:FindFirstChildOfClass("Humanoid").Health = 0
            print("🛡️ Godmode Engine: DISABLED (Resetting Character)")
        end
    end
end

-- Как использовать в твоем UI:
-- createToggle("Godmode", "GodmodeActive", function(v) GodmodeEngine(v) end)

-- Или просто запустить:
GodmodeEngine(true)
