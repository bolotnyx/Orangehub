-- [[ ORANGE HUB - WALK SPEED MODULE (ULTIMATE FIX) ]]
local LP = game:GetService("Players").LocalPlayer

task.spawn(function()
    while true do
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if _G.SpeedEnabled and hum then
            -- ПРИНУДИТЕЛЬНАЯ РАЗМОРОЗКА
            hum.PlatformStand = false -- ГЛАВНЫЙ ФИКС "ДЕРЕВЯННОСТИ"
            hum.JumpPower = 50 -- Убеждаемся, что прыжок не 0
            
            -- Установка скорости
            if _G.WalkSpeedValue then
                hum.WalkSpeed = _G.WalkSpeedValue
            end
            
            -- Фикс состояний (разрешаем прыгать)
            if hum:GetState() == Enum.HumanoidStateType.Physics then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
        task.wait(0.1) -- Проверка 10 раз в секунду
    end
end)

-- Фикс прыжка (дополнительно)
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.SpeedEnabled then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

return {Loaded = true}
