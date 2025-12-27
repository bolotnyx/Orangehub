local CombatModule = {
    KillAura = false,
    Range = 16 -- Оптимальная дистанция для регистрации сервером
}

local LP = game.Players.LocalPlayer
local enemies = {"Wolf", "Bear", "Cultist", "Mammoth", "Bunny", "Alpha", "Культист", "Медведь"}

-- Функция поиска ближайшего живого врага
local function getClosestEnemy()
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local closest, dist = nil, CombatModule.Range
    local myPos = char.HumanoidRootPart.Position

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            -- Проверка: не игрок и есть здоровье
            if not game.Players:GetPlayerFromCharacter(obj) and obj:FindFirstChildOfClass("Humanoid").Health > 0 then
                local isEnemy = false
                for _, name in ipairs(enemies) do
                    if obj.Name:find(name) then isEnemy = true break end
                end

                if isEnemy then
                    local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                    if root then
                        local d = (myPos - root.Position).Magnitude
                        if d < dist then
                            dist = d
                            closest = obj
                        end
                    end
                end
            end
        end
    end
    return closest
end

task.spawn(function()
    while true do
        task.wait(0.15) -- Скорость ударов
        
        if CombatModule.KillAura and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local target = getClosestEnemy()
            
            if target then
                local tool = LP.Character:FindFirstChildOfClass("Tool")
                local targetRoot = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head")
                
                if targetRoot and tool then
                    -- 1. МОМЕНТАЛЬНЫЙ РАЗВОРОТ (необходим для сервера)
                    LP.Character.HumanoidRootPart.CFrame = CFrame.new(
                        LP.Character.HumanoidRootPart.Position, 
                        Vector3.new(targetRoot.Position.X, LP.Character.HumanoidRootPart.Position.Y, targetRoot.Position.Z)
                    )

                    -- 2. ВИЗУАЛЬНЫЙ ВЗМАХ
                    tool:Activate()

                    -- 3. ПРЯМАЯ ОТПРАВКА УРОНА (Remote Injection)
                    -- Мы ищем любое событие внутри топора, которое отвечает за урон
                    for _, remote in ipairs(tool:GetDescendants()) do
                        if remote:IsA("RemoteEvent") then
                            -- Пробуем самые частые форматы данных, которые ждут серверы
                            remote:FireServer(target) 
                            remote:FireServer(targetRoot)
                            remote:FireServer(targetRoot.Position)
                            remote:FireServer(target:FindFirstChildOfClass("Humanoid"))
                        end
                    end
                end
            end
        end
    end
end)

return CombatModule
