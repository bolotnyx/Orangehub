local CombatModule = {
    KillAura = false,
    Range = 20
}

local LP = game.Players.LocalPlayer
local Vim = game:GetService("VirtualInputManager")

-- Список для поиска (упрощенный)
local enemies = {"Wolf", "Bear", "Cultist", "Mammoth", "Bunny", "Alpha", "Культист", "Медведь", "Журнал"}

local function getTarget()
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local closest = nil
    local lastDist = CombatModule.Range

    -- Ищем во всем Workspace
    for _, obj in ipairs(workspace:GetDescendants()) do
        -- Ищем среди Моделей или Деталей
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local name = obj.Name
            local isEnemy = false
            
            for _, eName in ipairs(enemies) do
                if name:find(eName) then
                    isEnemy = true
                    break
                end
            end
            
            if isEnemy and not game.Players:GetPlayerFromCharacter(obj) then
                -- Пытаемся найти позицию объекта
                local pos = (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))) or obj
                if pos then
                    local dist = (char.HumanoidRootPart.Position - pos.Position).Magnitude
                    if dist < lastDist then
                        lastDist = dist
                        closest = pos
                    end
                end
            end
        end
    end
    return closest
end

task.spawn(function()
    while task.wait(0.2) do
        if CombatModule.KillAura and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local targetPart = getTarget()
            
            if targetPart then
                -- 1. Разворот персонажа к цели
                local root = LP.Character.HumanoidRootPart
                root.CFrame = CFrame.new(root.Position, Vector3.new(targetPart.Position.X, root.Position.Y, targetPart.Position.Z))

                -- 2. Берем инструмент
                local tool = LP.Character:FindFirstChildOfClass("Tool") or LP.Backpack:FindFirstChildOfClass("Tool")
                if tool and tool.Parent ~= LP.Character then
                    tool.Parent = LP.Character
                end

                -- 3. Кликаем (пробуем все способы сразу)
                if tool then
                    tool:Activate()
                    -- Эмуляция тапа по центру экрана (для мобилок)
                    Vim:SendMouseButtonEvent(500, 500, 0, true, game, 1)
                    task.wait(0.01)
                    Vim:SendMouseButtonEvent(500, 500, 0, false, game, 1)
                end
            end
        end
    end
end)

return CombatModule
