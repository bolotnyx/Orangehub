-- [[ ORANGE HUB - ULTIMATE GODMODE ]]
local LP = game:GetService("Players").LocalPlayer

local function ActivateGodmode()
    local Character = LP.Character
    if not Character then return end
    
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return end

    -- ЭФФЕКТ "БЕССМЕРТНОГО ПРИЗРАКА"
    -- Мы отключаем состояния, в которых сервер может убить персонажа
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    
    -- Цикл принудительного удержания жизни
    task.spawn(function()
        while _G.GodmodeEnabled do
            if Character and Humanoid then
                -- Возвращаем ХП на максимум каждый кадр
                Humanoid.Health = Humanoid.MaxHealth
                
                -- Если сервер все-таки "убил" нас (HP = 0), мы принудительно воскрешаем модель локально
                if Humanoid:GetState() == Enum.HumanoidStateType.Dead then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                end
            end
            task.wait() -- Ждем 1 кадр (максимальная скорость)
        end
        
        -- Если выключили — разрешаем умирать снова
        if Humanoid then
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end
    end)
end

-- Запуск
_G.GodmodeEnabled = true
ActivateGodmode()
