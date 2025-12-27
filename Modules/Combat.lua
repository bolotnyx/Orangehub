local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local Combat = {
    KillAura = false,
    Radius = 15
}

RunService.Heartbeat:Connect(function()
    if not Combat.KillAura then return end
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local tool = char and char:FindFirstChildOfClass("Tool")
    
    if hrp and tool then
        -- Ищем врагов по наличию Humanoid и здоровья
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Humanoid") and v.Parent ~= char and v.Health > 0 then
                local enemyHrp = v.Parent:FindFirstChild("HumanoidRootPart")
                if enemyHrp and (enemyHrp.Position - hrp.Position).Magnitude <= Combat.Radius then
                    tool:Activate()
                end
            end
        end
    end
end)

return Combat
