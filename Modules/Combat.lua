local CombatModule = {
    KillAura = false,
    Range = 15 -- Немного уменьшил, чтобы сервер засчитывал хиты
}

local LP = game.Players.LocalPlayer
local enemies = {"Wolf", "Bear", "Cultist", "Mammoth", "Bunny", "Alpha", "Культист", "Медведь"}

-- Функция поиска цели без лагов
local function getTarget()
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local rootPos = char.HumanoidRootPart.Position
    local closest, dist = nil, CombatModule.Range

    -- Ищем только в папках, где обычно лежат мобы (ускоряет работу)
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= char then
            local isEnemy = false
            for _, name in ipairs(enemies) do
                if obj.Name:find(name) then isEnemy = true break end
            end

            if isEnemy then
                local targetPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
                if targetPart then
                    local d = (rootPos - targetPart.Position).Magnitude
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
        task.wait(0.3) -- Увеличил интервал до 0.3с (меньше лагов, стабильнее урон)
        
        if CombatModule.KillAura and LP.Character then
            local target = getTarget()
            if target then
                local tool = LP.Character:FindFirstChildOfClass("Tool")
                
                -- Разворот (только если есть цель)
                local targetPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChildWhichIsA("BasePart")
                if targetPart and LP.Character:FindFirstChild("HumanoidRootPart") then
                    LP.Character.HumanoidRootPart.CFrame = CFrame.new(
                        LP.Character.HumanoidRootPart.Position, 
                        Vector3.new(targetPart.Position.X, LP.Character.HumanoidRootPart.Position.Y, targetPart.Position.Z)
                    )
                end

                -- Атака
                if tool then
                    tool:Activate() -- Взмах
                    
                    -- Пробуем вызвать Remote, если он есть (без перебора всех папок)
                    local event = tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("Attack") or tool:FindFirstChild("Event")
                    if event and event:IsA("RemoteEvent") then
                        event:FireServer(target)
                    end
                end
            end
        end
    end
end)

return CombatModule
