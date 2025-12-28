local InfJumpModule = {
    Enabled = false
}

local UserInputService = game:GetService("UserInputService")
local LP = game.Players.LocalPlayer

UserInputService.JumpRequest:Connect(function()
    if InfJumpModule.Enabled and LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState("Jumping")
        end
    end
end)

return InfJumpModule
