-- Modules/ESP.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ESP = true

RunService.RenderStepped:Connect(function()
	if not ESP then return end

	for _,v in ipairs(workspace:GetDescendants()) do
		-- Только модели с Humanoid
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
			
			-- Пропускаем игроков
			if not Players:GetPlayerFromCharacter(v) then
				
				local humanoid = v:FindFirstChild("Humanoid")
				-- Только живые NPC
				if humanoid.Health > 0 then
					
					-- Проверяем, что это “враждебный NPC” (например, в 99 Nights их можно пометить через тег)
					if not v:FindFirstChild("ESP") then
						local box = Instance.new("BoxHandleAdornment", v)
						box.Name = "ESP"
						box.Adornee = v
						box.Size = v:GetExtentsSize()
						box.Color3 = Color3.fromRGB(255,0,0)
						box.Transparency = 0.6
						box.AlwaysOnTop = true
						box.ZIndex = 5
					end
				end
			end
		end
	end
end)

return ESP
