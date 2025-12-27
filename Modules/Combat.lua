local CombatModule = {
    KillAura = false,
    Range = 18
}

local LP = game.Players.LocalPlayer
local enemies = {"Wolf", "Bear", "Cultist", "Mammoth", "Bunny", "Alpha", "Культист", "Медведь"}

-- Чистая функция поиска без лишнего мусора
local function findTarget()
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local closest, dist = nil, CombatModule.Range
    local myPos = char.HumanoidRootPart.Position

    -- Ищем только в workspace (не заходя слишком глубоко)
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= char then
            local isEnemy = false
            for _, name in ipairs(enemies) do
                if obj.Name:find(name) then isEnemy = true break end
            end

            if isEnemy then
                local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head") or obj:FindFirstChildWhichIsA("BasePart")
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
    return closest
end

task.spawn(function()
    while true do
        task.wait(0.2) -- Оптимальная задержка
        
        if CombatModule.KillAura and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local target = findTarget()
            
            if target then
                local tPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head") or target:FindFirstChildWhichIsA("BasePart")
                local tool = LP.Character:FindFirstChildOfClass("Tool")
                
                if tPart and tool then
                    -- 1. ПОВОРОТ (обязательно через CFrame)
                    LP.Character.HumanoidRootPart.CFrame = CFrame.new(
                        LP.Character.HumanoidRootPart.Position, 
                        Vector3.new(tPart.Position.X, LP.Character.HumanoidRootPart.Position.Y, tPart.Position.Z)
                    )

                    -- 2. ВЗМАХ (через встроенную функцию топора)
                    tool:Activate()
                    
                    -- 3. ПРЯМОЙ СИГНАЛ (если есть Remote)
                    local remote = tool:FindFirstChildOfClass("RemoteEvent")
                    if remote then
                        remote:FireServer(target)
                    end
                end
            end
        end
    end
end)

return CombatModule
