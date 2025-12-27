local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local Combat = {
    KillAura = false,
    Radius = 20
}

RunService.Stepped:Connect(function()
    if not Combat.KillAura then return end
    local char = LP.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    
    if char and tool then
        for _, v in pairs(workspace:GetChildren()) do
            -- Проверяем, что это NPC, а не мы, и он живой
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= char then
                local hrp = v:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - char.HumanoidRootPart.Position).Magnitude <= Combat.Radius then
                    tool:Activate() -- Бьем
                end
            end
        end
    end
end)

return Combat
