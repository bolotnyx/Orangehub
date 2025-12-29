-- [[ ORANGE HUB - SEMI-GODMODE (NO-BRICK) ]]
local LP = game:GetService("Players").LocalPlayer

task.spawn(function()
    while task.wait() do
        if _G.GodmodeEnabled then
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            if char and hum then
                -- 1. Защита от распада (Волки не смогут тебя "съесть")
                char.BreakJointsOnDeath = false
                
                -- 2. Блокируем регистрацию смерти
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                
                -- 3. Мгновенный хил
                if hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
                
                -- 4. Если сервер принудительно убил (0 HP), не даем застыть
                if hum.Health <= 0 then
                    hum.Health = 0.1
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
                
                -- 5. Удаляем скрипт урона (важно для многих игр)
                local hs = char:FindFirstChild("Health")
                if hs then hs:Destroy() end
            end
        end
    end
end)

return {Loaded = true}
