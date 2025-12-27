local CombatModule = {
    KillAura = false,
    Range = 16
}

local LP = game.Players.LocalPlayer
local Vim = game:GetService("VirtualInputManager")

local enemies = {"Wolf", "Bear", "Cultist", "Mammoth", "Bunny", "Alpha", "Культист", "Медведь"}

-- Оптимизированный поиск (сканирует раз в секунду и кеширует цель)
local currentTarget = nil
task.spawn(function()
    while true do
        if CombatModule.KillAura and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local closest = nil
            local dist = CombatModule.Range
            local myPos = LP.Character.HumanoidRootPart.Position

            for _, obj in ipairs(workspace:GetDescendants()) do
                -- Ищем только модели с именами из нашего списка
                if obj:IsA("Model") then
                    local isEnemy = false
                    for _, name in ipairs(enemies) do
                        if obj.Name:find(name) then isEnemy = true break end
                    end

                    if isEnemy and not game.Players:GetPlayerFromCharacter(obj) then
                        local tPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
                        if tPart then
                            local d = (myPos - tPart.Position).Magnitude
                            if d < dist then
                                dist = d
                                closest = obj
                            end
                        end
                    end
                end
            end
            currentTarget = closest
        end
        task.wait(0.5) -- Не ищем слишком часто, чтобы не лагало
    end
end)

-- Цикл атаки (работает быстро)
task.spawn(function()
    while true do
        task.wait(0.2)
        if CombatModule.KillAura and LP.Character and currentTarget then
            local tPart = currentTarget:FindFirstChild("HumanoidRootPart") or currentTarget:FindFirstChildWhichIsA("BasePart")
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            
            if tPart and LP.Character:FindFirstChild("HumanoidRootPart") then
                -- Поворот
                LP.Character.HumanoidRootPart.CFrame = CFrame.new(
                    LP.Character.HumanoidRootPart.Position, 
                    Vector3.new(tPart.Position.X, LP.Character.HumanoidRootPart.Position.Y, tPart.Position.Z)
                )

                if tool then
                    -- Активация
                    tool:Activate()
                    
                    -- Имитация нажатия в центре экрана (для мобильной кнопки атаки)
                    Vim:SendMouseButtonEvent(500, 500, 0, true, game, 1)
                    task.wait(0.01)
                    Vim:SendMouseButtonEvent(500, 500, 0, false, game, 1)
                end
            end
        end
    end
end)

return CombatModule
