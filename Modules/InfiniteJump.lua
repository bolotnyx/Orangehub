local InfiniteJump = {}
InfiniteJump.Enabled = false

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

UIS.JumpRequest:Connect(function()
	if InfiniteJump.Enabled then
		local char = Players.LocalPlayer.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum:ChangeState("Jumping")
			end
		end
	end
end)

function InfiniteJump.SetState(state)
	InfiniteJump.Enabled = state
end

return InfiniteJump
