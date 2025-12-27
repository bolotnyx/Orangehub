local CombatModule = {
    KillAura = false,
    Range = 25 -- Теперь можно даже чуть дальше
}

local LP = game.Players.LocalPlayer
local enemies = {"Wolf", "Bear", "Cultist", "Mammoth", "Bunny", "Alpha", "Культист", "Медведь"}

-- Функция поиска ближайшей цели
local function getClosest()
    local closest, dist = nil, CombatModule.Range
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
            if not game.Players:GetPlayerFromCharacter(v) then
                for _, name in ipairs(enemies) do
                    if v.Name:find(name) then
                        local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Head")
                        if root then
                            local d = (LP.Character.HumanoidRootPart.Position - root.Position).Magnitude
                            if d < dist then dist = d closest = v end
                        end
                        break
                    end
                end
            end
        end
    end
    return closest
end

-- СЕРЬЕЗНЫЙ ВЗЛОМ ЛОГИКИ (Raycast Hook)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if CombatModule.KillAura and method == "Raycast" then
        local target = getClosest()
        if target and target:FindFirstChild("Head") then
            -- Подменяем направление луча так, чтобы он всегда попадал в голову моба
            args[2] = (target.Head.Position - args[1]).Unit * 1000
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- Цикл авто-атаки
task.spawn(function()
    while true do
        task.wait(0.1)
        if CombatModule.KillAura and LP.Character then
            local target = getClosest()
            if target then
                local tool = LP.Character:FindFirstChildOfClass("Tool")
                if tool then
                    -- 1. Визуальный поворот (обязателен для сервера)
                    local tRoot = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head")
                    LP.Character.HumanoidRootPart.CFrame = CFrame.new(LP.Character.HumanoidRootPart.Position, 
                        Vector3.new(tRoot.Position.X, LP.Character.HumanoidRootPart.Position.Y, tRoot.Position.Z))
                    
                    -- 2. Активация инструмента
                    tool:Activate()
                    
                    -- 3. Прямой вызов всех событий (на всякий случай)
                    for _, r in ipairs(tool:GetDescendants()) do
                        if r:IsA("RemoteEvent") then 
                            r:FireServer(target)
                            r:FireServer(target:FindFirstChildOfClass("Humanoid"))
                        end
                    end
                end
            end
        end
    end
end)

return CombatModule
