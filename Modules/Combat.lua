-- Modules/Combat.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()
local HumanoidRoot = Character:WaitForChild("HumanoidRootPart")

local Combat = {}
Combat.KillAura = false
Combat.Radius = 15

local function getNPCs()
	local npcs = {}
	for _,v in ipairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
			if not Players:GetPlayerFromCharacter(v) and v.Humanoid.Health > 0 then
				table.insert(npcs,v)
			end
		end
	end
	return npcs
end

RunService.Heartbeat:Connect(function()
	if not Combat.KillAura then return end
	local tool = Character:FindFirstChildOfClass("Tool")
	if not tool then return end
	for _,npc in ipairs(getNPCs()) do
		if (npc.HumanoidRootPart.Position - HumanoidRoot.Position).Magnitude <= Combat.Radius then
			pcall(function()
				tool:Activate()
			end)
		end
	end
end)

return Combat
