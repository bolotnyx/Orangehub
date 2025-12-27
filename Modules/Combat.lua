local CombatModule = {
    KillAura = false,
    Range = 16
}

local LP = game.Players.LocalPlayer
local enemies = {"Wolf", "Bear", "Cultist", "Mammoth", "Bunny", "Alpha", "Культист", "Медведь"}

local function getTarget()
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local closest, dist = nil, CombatModule.Range

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local isEnemy = false
            for _, name in ipairs(enemies) do
                if obj.Name:find(name) then isEnemy = true break end
            end
            
            if isEnemy and not game.Players:GetPlayerFromCharacter(obj) then
                local tPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
                if tPart then
                    local d = (LP.Character.HumanoidRootPart.Position - tPart.Position).Magnitude
                    if d < dist then
                        dist = d
                        closest = obj
                    end
                end
            end
        end
    end
    return closest
end

task.spawn(function()
    while true do
        task.wait(0.1) -- Максимально быстрая проверка
        if CombatModule.KillAura and LP.Character then
            local target = getTarget()
            if target then
                local tool = LP.Character:FindFirstChildOfClass("Tool")
                local tPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChildWhichIsA("BasePart")
                
                if tPart then
                    -- 1. Принудительный взгляд на врага
                    LP.Character.HumanoidRootPart.CFrame = CFrame.new(
                        LP.Character.HumanoidRootPart.Position, 
                        Vector3.new(tPart.Position.X, LP.Character.HumanoidRootPart.Position.Y, tPart.Position.Z)
                    )

                    if tool then
                        -- МЕТОД: Спам всех найденных Remote-событий в инструменте
                        -- Многие мобильные игры называют их 'Handle', 'Attack', 'Hit' или 'Action'
                        for _, remote in ipairs(tool:GetDescendants()) do
                            if remote:IsA("RemoteEvent") then
                                -- Отправляем данные серверу: либо саму модель, либо позицию
                                remote:FireServer(target)
                                remote:FireServer(tPart.Position)
                                remote:FireServer(target:FindFirstChildOfClass("Humanoid"))
                            end
                        end
                        -- Визуальный взмах
                        tool:Activate()
                    end
                end
            end
        end
    end
end)

return CombatModule
