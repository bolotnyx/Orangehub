-- Modules/Combat.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")

local Combat = {}
Combat.KillAura = false
Combat.Radius = 15

local function getNPCs()
	local npcs = {}
	local enemiesFolder = workspace:FindFirstChild("Enemies") -- измени на папку с NPC
	if enemiesFolder then
		for _,v in ipairs(enemiesFolder:GetChildren()) do
			if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
				if v.Humanoid.Health > 0 then
					table.insert(npcs,v)
				end
			end
		end
	end
	return npcs
end

RunService.Heartbeat:Connect(function()
	if not Combat.KillAura then return end
	local tool = Char:FindFirstChildOfClass("Tool")
	if not tool then return end
	for _,npc in ipairs(getNPCs()) do
		if (npc.HumanoidRootPart.Position - HRP.Position).Magnitude <= Combat.Radius then
			pcall(function()
				tool:Activate()
			end)
		end
	end
end)

return Combat
