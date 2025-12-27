-- Modules/Combat.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()
local KillAura = false
local Radius = 15 -- радиус атаки

-- Найти оружие в руках
local function getTool()
	Character = LP.Character
	if not Character then return nil end
	for _, tool in ipairs(Character:GetChildren()) do
		if tool:IsA("Tool") then
			return tool
		end
	end
	return nil
end

-- Найти NPC
local function getNPCs()
	local npcs = {}
	for _,v in ipairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and not Players:GetPlayerFromCharacter(v) then
			table.insert(npcs,v)
		end
	end
	return npcs
end

-- AutoAttack Loop
RunService.Heartbeat:Connect(function()
	if not KillAura then return end
	local tool = getTool()
	if not tool then return end
	local hrp = Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	for _,npc in ipairs(getNPCs()) do
		local dist = (npc.HumanoidRootPart.Position - hrp.Position).Magnitude
		if dist <= Radius then
			pcall(function() tool:Activate() end)
		end
	end
end)

-- Возврат таблицы
return {
	KillAura = KillAura
}
