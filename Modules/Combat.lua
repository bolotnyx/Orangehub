local CombatModule = {
    KillAura = false,
    Range = 20
}

local LP = game.Players.LocalPlayer
local enemies = {"Wolf", "Bear", "Cultist", "Mammoth", "Bunny", "Alpha", "Культист", "Медведь"}

local function getTarget()
    local closest, dist = nil, CombatModule.Range
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
            if not game.Players:GetPlayerFromCharacter(v) then
                for _, name in ipairs(enemies) do
                    if v.Name:find(name) then
                        local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Head")
                        if root then
                            local d = (LP.Character.HumanoidRootPart.Position - root.Position).Magnitude
                            if d < dist then dist = d closest = v end
                        end
                        break
                    end
                end
            end
        end
    end
    return closest
end

task.spawn(function()
    while true do
        task.wait(0.1) -- Максимальная скорость
        if CombatModule.KillAura and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local target = getTarget()
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            
            if target and tool then
                local tRoot = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head")
                local myRoot = LP.Character.HumanoidRootPart
                
                -- СОХРАНЯЕМ ПОЗИЦИЮ МОБА
                local oldPos = tRoot.CFrame
                
                -- 1. ТЕЛЕПОРТИРУЕМ МОБА ПРЯМО ПЕРЕД СОБОЙ
                tRoot.CFrame = myRoot.CFrame * CFrame.new(0, 0, -3) 
                
                -- 2. УДАР
                tool:Activate()
                
                -- 3. МОМЕНТАЛЬНО ВОЗВРАЩАЕМ МОБА (чтобы сервер не заподозрил ТП)
                task.delay(0.05, function()
                    if tRoot then tRoot.CFrame = oldPos end
                end)
                
                -- Дополнительно: спамим активацию, если есть тачи
                for _, part in ipairs(tool:GetDescendants()) do
                    if part:IsA("TouchTransmitter") then
                        firetouchinterest(tRoot, part.Parent, 0)
                        firetouchinterest(tRoot, part.Parent, 1)
                    end
                end
            end
        end
    end
end)

return CombatModule
