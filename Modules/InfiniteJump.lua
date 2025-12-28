local InfiniteJump = { Enabled = false }

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer

function InfiniteJump.SetState(state)
	InfiniteJump.Enabled = state
end

UIS.JumpRequest:Connect(function()
	if not InfiniteJump.Enabled then return end

	local char = LP.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")

	if hum then
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

return InfiniteJump
