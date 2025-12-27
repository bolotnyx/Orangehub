local CombatModule = {
    KillAura = false,
    Range = 18 -- Чуть увеличил дистанцию для запаса
}

local LP = game.Players.LocalPlayer
local Vim = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

-- Твой список врагов (совпадает с ESP)
local enemyNames = {"Wolf", "Bear", "Cultist", "Mammoth", "Bunny", "Alpha", "Культист", "Медведь"}

local function getClosestEnemy()
    local closest = nil
    local dist = CombatModule.Range
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChildOfClass("Humanoid") then
            -- Проверка: не игрок и не мертв
            if not game.Players:GetPlayerFromCharacter(obj) and obj:FindFirstChildOfClass("Humanoid").Health > 0 then
                local isEnemy = false
                for _, name in ipairs(enemyNames) do
                    if obj.Name:find(name) then isEnemy = true break end
                end

                if isEnemy then
                    local magnitude = (root.Position - obj.HumanoidRootPart.Position).Magnitude
                    if magnitude < dist then
                        dist = magnitude
                        closest = obj
                    end
                end
            end
        end
    end
    return closest
end

task.spawn(function()
    while task.wait(0.2) do -- Скорость атаки (0.2 - безопасно)
        if CombatModule.KillAura and LP.Character then
            local target = getClosestEnemy()
            
            if target and target:FindFirstChild("HumanoidRootPart") then
                -- 1. Берем оружие в руки (если еще не в руках)
                local tool = LP.Character:FindFirstChildOfClass("Tool") or LP.Backpack:FindFirstChildOfClass("Tool")
                if tool and tool.Parent ~= LP.Character then
                    tool.Parent = LP.Character
                end

                -- 2. Поворот к цели (без этого урон часто не идет)
                local root = LP.Character.HumanoidRootPart
                root.CFrame = CFrame.new(root.Position, Vector3.new(target.HumanoidRootPart.Position.X, root.Position.Y, target.HumanoidRootPart.Position.Z))

                -- 3. АТАКА (Комбинированный метод)
                if tool then
                    -- Метод А: Активация инструмента
                    tool:Activate()
                    
                    -- Метод Б: Имитация клика по центру экрана (для мобилок/ПК)
                    Vim:SendMouseButtonEvent(500, 500, 0, true, game, 1)
                    Vim:SendMouseButtonEvent(500, 500, 0, false, game, 1)
                    
                    -- Метод В: Попытка найти RemoteEvent (если он стандартный)
                    local attackRemote = tool:FindFirstChild("RemoteClick") or tool:FindFirstChild("Attack")
                    if attackRemote and attackRemote:IsA("RemoteEvent") then
                        attackRemote:FireServer(target.HumanoidRootPart.Position)
                    end
                end
            end
        end
    end
end)

return CombatModule
