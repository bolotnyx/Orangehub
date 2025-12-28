local FlyMod = { Enabled = false }

local LP = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

function FlyMod.SetState(state)
	FlyMod.Enabled = state

	local char = LP.Character or LP.CharacterAdded:Wait()
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")

	if not hum or not root then return end

	if state then
		hum.PlatformStand = true

		-- стабилизация
		local bg = Instance.new("BodyGyro")
		bg.Name = "OrangeFlyBG"
		bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
		bg.P = 9000
		bg.Parent = root

		-- движение
		local bv = Instance.new("BodyVelocity")
		bv.Name = "OrangeFlyBV"
		bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
		bv.Velocity = Vector3.zero
		bv.Parent = root

		task.spawn(function()
			while FlyMod.Enabled and char.Parent do
				local speed = _G.FlySpeedValue or 50
				local moveDir = hum.MoveDirection

				if moveDir.Magnitude > 0 then
					-- ЛЕТИМ ПО ДЖОЙСТИКУ
					bv.Velocity = moveDir.Unit * speed

					-- ПОВОРАЧИВАЕМСЯ ПО НАПРАВЛЕНИЮ ДВИЖЕНИЯ
					bg.CFrame = CFrame.lookAt(
						root.Position,
						root.Position + moveDir
					)
				else
					-- зависаем
					bv.Velocity = Vector3.zero
				end

				RunService.Heartbeat:Wait()
			end

			-- очистка
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
