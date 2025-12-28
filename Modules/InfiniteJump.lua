-- InfiniteJump.lua
local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local InfJumpEnabled = false

local module = {}

module.SetState = function(state)
    InfJumpEnabled = state
end

-- Событие прыжка
local connection
connection = UIS.JumpRequest:Connect(function()
    if InfJumpEnabled and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Чтобы можно было через UI менять состояние
module.InfJumpEnabled = InfJumpEnabled

return module
