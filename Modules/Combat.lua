local CombatModule = {
    KillAura = false,
    Range = 18
}

local LP = game.Players.LocalPlayer
local Vim = game:GetService("VirtualInputManager")

local enemies = {"Wolf", "Bear", "Cultist", "Mammoth", "Bunny", "Alpha", "Культист", "Медведь"}

local function getTarget()
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local closest, lastDist = nil, CombatModule.Range

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local isEnemy = false
            for _, eName in ipairs(enemies) do
                if obj.Name:find(eName) then isEnemy = true break end
            end
            
            if isEnemy and not game.Players:GetPlayerFromCharacter(obj) then
                local pos = (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))) or obj
                if pos then
                    local dist = (char.HumanoidRootPart.Position - pos.Position).Magnitude
                    if dist < lastDist then
                        lastDist = dist
                        closest = obj -- Берем саму модель
                    end
                end
            end
        end
    end
    return closest
end

task.spawn(function()
    while task.wait(0.15) do -- Чуть быстрее атака
        if CombatModule.KillAura and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local target = getTarget()
            
            if target then
                local root = LP.Character.HumanoidRootPart
                local targetPart = target:IsA("Model") and (target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")) or target
                
                -- 1. Точный разворот
                root.CFrame = CFrame.new(root.Position, Vector3.new(targetPart.Position.X, root.Position.Y, targetPart.Position.Z))

                -- 2. Работа с инструментом
                local tool = LP.Character:FindFirstChildOfClass("Tool")
                if not tool then
                    tool = LP.Backpack:FindFirstChildOfClass("Tool")
                    if tool then tool.Parent = LP.Character end
                end

                if tool then
                    -- МЕТОД 1: Стандартная активация
                    tool:Activate()

                    -- МЕТОД 2: Поиск RemoteEvent внутри инструмента (самый эффективный)
                    for _, child in ipairs(tool:GetDescendants()) do
                        if child:IsA("RemoteEvent") or child:IsA("UnreliableRemoteEvent") then
                            -- Пробуем отправить сигнал атаки серверу
                            child:FireServer(targetPart.Position) 
                            child:FireServer(target) -- Некоторые игры требуют саму модель
                        end
                    end

                    -- МЕТОД 3: Эмуляция тапа по кнопке атаки (координаты типичной мобильной кнопки)
                    Vim:SendMouseButtonEvent(800, 400, 0, true, game, 1)
                    task.wait(0.02)
                    Vim:SendMouseButtonEvent(800, 400, 0, false, game, 1)
                end
            end
        end
    end
end)

return CombatModule
