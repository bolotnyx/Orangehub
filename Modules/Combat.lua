local CombatModule = {
    KillAura = false,
    Range = 25 -- Тот самый радиус из Moondate
}

local LP = game.Players.LocalPlayer
local enemies = {"Wolf", "Bear", "Cultist", "Mammoth", "Bunny", "Alpha", "Культист", "Медведь"}

-- Функция для поиска ВСЕХ целей в радиусе (а не одной)
local function getAllTargets()
    local targets = {}
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return targets end
    
    local myPos = char.HumanoidRootPart.Position

    -- Глубокий поиск по всему миру
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            if not game.Players:GetPlayerFromCharacter(obj) and obj:FindFirstChildOfClass("Humanoid").Health > 0 then
                for _, name in ipairs(enemies) do
                    if obj.Name:find(name) then
                        local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                        if root and (root.Position - myPos).Magnitude <= CombatModule.Range then
                            table.insert(targets, obj)
                        end
                        break
                    end
                end
            end
        end
    end
    return targets
end

task.spawn(function()
    while true do
        task.wait(0.1) -- Скорость атаки
        
        if CombatModule.KillAura and LP.Character then
            local targets = getAllTargets()
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            
            if #targets > 0 and tool then
                -- 1. Активируем топор визуально
                tool:Activate()

                -- 2. ГЛОБАЛЬНЫЙ УДАР (бьем всех сразу)
                for _, target in ipairs(targets) do
                    local humanoid = target:FindFirstChildOfClass("Humanoid")
                    
                    -- Пробуем найти скрытые Remote в игре, которые юзает Moondate
                    local remoteNames = {"Hit", "Damage", "Attack", "Swing", "MainEvent"}
                    
                    -- Ищем в инструменте
                    for _, r in ipairs(tool:GetDescendants()) do
                        if r:IsA("RemoteEvent") then
                            r:FireServer(target, humanoid, target:FindFirstChild("HumanoidRootPart"))
                        end
                    end
                    
                    -- Ищем в ReplicatedStorage (если в инструменте пусто)
                    for _, rName in ipairs(remoteNames) do
                        local r = game.ReplicatedStorage:FindFirstChild(rName)
                        if r and r:IsA("RemoteEvent") then
                            r:FireServer(target, humanoid)
                        end
                    end
                end
            end
        end
    end
end)

return CombatModule
