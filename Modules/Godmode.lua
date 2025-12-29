-- [[ ORANGE HUB MODULE: GODMODE ]]
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local Godmode = {}

function Godmode.Activate()
    -- Метод 1: Удаление скриптов урона (работает во многих простых плейсах)
    -- Мы ищем компоненты, которые отвечают за получение урона
    local humanoid = Character:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        -- Попытка заблокировать изменение здоровья локально
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        
        -- Метод 2: "Fake Dead" (Персонаж не умирает при 0 HP в некоторых играх)
        humanoid.Health = humanoid.MaxHealth
        
        local connection
        connection = humanoid.HealthChanged:Connect(function(health)
            if health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
        
        print("🛡️ [ORANGE HUB] Godmode Activated")
    end
end

return Godmode
