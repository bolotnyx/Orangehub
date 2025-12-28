local InfiniteJump = { Enabled = false }

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer

function InfiniteJump.SetState(state)
	InfiniteJump.Enabled = state
end

-- основной цикл
RunService.Heartbeat:Connect(function()
	if not InfiniteJump.Enabled then return end

	local char = LP.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")

	if not hum then return end

	-- если игрок в воздухе и нажимает прыжок — разрешаем прыжок снова
	if hum:GetState() == Enum.HumanoidStateType.Freefall and hum.Jump then
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

return InfiniteJump
