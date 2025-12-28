local FlyMod = { Enabled = false }

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer

function FlyMod.SetState(state)
	FlyMod.Enabled = state

	local char = LP.Character or LP.CharacterAdded:Wait()
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")

	if not hum or not root then return end

	if state then
		hum.PlatformStand = true

		local bg = Instance.new("BodyGyro")
		bg.Name = "OrangeFlyBG"
		bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
		bg.P = 9000
		bg.Parent = root

		local bv = Instance.new("BodyVelocity")
		bv.Name = "OrangeFlyBV"
		bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
		bv.Velocity = Vector3.zero
		bv.Parent = root

		task.spawn(function()
			while FlyMod.Enabled and char.Parent do
				local speed = _G.FlySpeedValue or 50
				local cam = workspace.CurrentCamera
				local moveDir = hum.MoveDirection

				if moveDir.Magnitude > 0 then
					-- направление = КУДА СМОТРИШЬ
					local dir = cam.CFrame.LookVector

					-- сила зависит от джойстика
					bv.Velocity = dir * speed * moveDir.Magnitude

					-- поворот за камерой
					bg.CFrame = cam.CFrame
				else
					-- зависаем
					bv.Velocity = Vector3.zero
				end

				RunService.Heartbeat:Wait()
			end

			hum.PlatformStand = false
			if root:FindFirstChild("OrangeFlyBV") then root.OrangeFlyBV:Destroy() end
			if root:FindFirstChild("OrangeFlyBG") then root.OrangeFlyBG:Destroy() end
		end)

	else
		hum.PlatformStand = false
		if root:FindFirstChild("OrangeFlyBV") then root.OrangeFlyBV:Destroy() end
		if root:FindFirstChild("OrangeFlyBG") then root.OrangeFlyBG:Destroy() end
	end
end

return FlyMod
