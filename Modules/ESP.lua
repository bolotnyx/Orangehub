-- Modules/ESP.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ESP = {}
ESP.Enabled = false

RunService.RenderStepped:Connect(function()
	if not ESP.Enabled then return end
	local enemiesFolder = workspace:FindFirstChild("Enemies") -- папка с NPC
	if not enemiesFolder then return end

	for _,v in ipairs(enemiesFolder:GetChildren()) do
		if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
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
end)

return ESP
