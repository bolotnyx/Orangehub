local InfiniteJump = { Enabled = false }

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer

function InfiniteJump.SetState(state)
	InfiniteJump.Enabled = state
end

-- ПК (Space)
UIS.JumpRequest:Connect(function()
	if not InfiniteJump.Enabled then return end

	local char = LP.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")

	if hum then
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- Android (кнопка прыжка)
task.spawn(function()
	while true do
		if InfiniteJump.Enabled then
			local char = LP.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")

			if hum and hum.Jump then
				hum:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
		task.wait(0.1)
	end
end)

return InfiniteJump
