local InfiniteJump = {}
InfiniteJump.Enabled = false

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local jumpConnection = nil

local function onJump()
	if not InfiniteJump.Enabled then return end

	local char = Players.LocalPlayer.Character
	if not char then return end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end

function InfiniteJump.SetState(state)
	InfiniteJump.Enabled = state

	-- ВКЛ
	if state then
		if not jumpConnection then
			jumpConnection = UIS.JumpRequest:Connect(onJump)
		end
	else
		-- ВЫКЛ
		if jumpConnection then
			jumpConnection:Disconnect()
			jumpConnection = nil
		end
	end
end

return InfiniteJump
