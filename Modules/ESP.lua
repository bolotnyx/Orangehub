-- Modules/ESP.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ESP = {}
ESP.Enabled = false

RunService.RenderStepped:Connect(function()
	if not ESP.Enabled then return end

	for _,v in ipairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
			if not Players:GetPlayerFromCharacter(v) then
				if v.Humanoid.Health > 0 then
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
