local CombatModule = {
    KillAura = false,
    Range = 15, -- Дистанция удара
}

local LP = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Список целей, которых будем бить (те же, что в ESP)
local enemyNames = {"Wolf", "Bear", "Cultist", "Mammoth", "Bunny", "Alpha", "Культист", "Медведь"}

local function getClosestEnemy()
    local closest = nil
    local dist = CombatModule.Range
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
            -- Проверка: не игрок ли это?
            if not game.Players:GetPlayerFromCharacter(obj) then
                -- Проверка: в списке ли врагов?
                local isEnemy = false
                for _, name in ipairs(enemyNames) do
                    if obj.Name:find(name) then isEnemy = true break end
                end

                if isEnemy then
                    local magnitude = (char.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
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
    while task.wait(0.1) do -- Частота ударов
        if CombatModule.KillAura then
            local target = getClosestEnemy()
            if target and target:FindFirstChild("HumanoidRootPart") then
                -- 1. Экипируем оружие, если оно есть в инвентаре
                local tool = LP.Character:FindFirstChildOfClass("Tool") or LP.Backpack:FindFirstChildOfClass("Tool")
                if tool and tool.Parent ~= LP.Character then
                    tool.Parent = LP.Character
                end

                -- 2. Поворачиваемся к цели (важно для регистрации удара)
                LP.Character.HumanoidRootPart.CFrame = CFrame.new(LP.Character.HumanoidRootPart.Position, 
                    Vector3.new(target.HumanoidRootPart.Position.X, LP.Character.HumanoidRootPart.Position.Y, target.HumanoidRootPart.Position.Z))

                -- 3. Атакуем (отправляем сигнал активации инструмента)
                if tool then
                    tool:Activate()
                end
                
                -- Если в игре есть специфический RemoteEvent для урона, 
                -- его нужно будет добавить сюда после тестов.
            end
        end
    end
end)

return CombatModule
