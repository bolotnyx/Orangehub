local InfJumpModule = {
    Enabled = false
}

local UserInputService = game:GetService("UserInputService")
local LP = game.Players.LocalPlayer

UserInputService.JumpRequest:Connect(function()
    if InfJumpModule.Enabled then
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            -- Даем персонажу импульс прыжка, даже если он в воздухе
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

return InfJumpModule
