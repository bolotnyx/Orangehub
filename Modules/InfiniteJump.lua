local InfJumpModule = {
    Enabled = false
}

local LP = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Подключаем событие один раз при загрузке модуля
UIS.JumpRequest:Connect(function()
    if InfJumpModule.Enabled and LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            -- Принудительно заставляем персонажа прыгнуть
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

return InfJumpModule
