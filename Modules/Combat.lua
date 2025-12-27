local CombatModule = {
    KillAura = false,
    Range = 30
}

local LP = game.Players.LocalPlayer
local enemies = {"Wolf", "Bear", "Cultist", "Mammoth", "Bunny", "Alpha"}
local blacklist = {"Mammoth Tusk", "wolf spawner", "wolf respawner", "wolf head", "bunny burrow"}

-- Функция поиска папки с мобами (если они не в корне Workspace)
local function getEnemyContainer()
    return workspace:FindFirstChild("NPCs") or workspace:FindFirstChild("Entities") or workspace:FindFirstChild("Living") or workspace
end

task.spawn(function()
    while true do
        task.wait(0.2)
        if CombatModule.KillAura and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            if not tool then continue end

            local myRoot = LP.Character.HumanoidRootPart
            local container = getEnemyContainer()

            -- Ищем врагов ВЕЗДЕ (Descendants), но только раз в цикле
            for _, obj in ipairs(container:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= LP.Character then
                    
                    local name = obj.Name
                    local isEnemy = false

                    -- 1. Проверяем, подходит ли имя
                    for _, enName in ipairs(enemies) do
                        if name:find(enName) then
                            isEnemy = true
                            -- 2. Проверяем черный список (бивни, спавнеры)
                            for _, bName in ipairs(blacklist) do
                                if name:find(bName) then isEnemy = false break end
                            end
                            break
                        end
                    end

                    if isEnemy then
                        local tRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head") or obj:FindFirstChildWhichIsA("BasePart")
                        if tRoot then
                            local dist = (myRoot.Position - tRoot.Position).Magnitude
                            if dist <= CombatModule.Range then
                                -- ПОВОРОТ
                                myRoot.CFrame = CFrame.new(myRoot.Position, Vector3.new(tRoot.Position.X, myRoot.Position.Y, tRoot.Position.Z))
                                
                                -- АТАКА (Пробуем все способы сразу)
                                tool:Activate()
                                
                                -- Симуляция касания (для топоров)
                                local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
                                if handle then
                                    firetouchinterest(tRoot, handle, 0)
                                    firetouchinterest(tRoot, handle, 1)
                                end

                                -- Прямой вызов Remote
                                local re = tool:FindFirstChildOfClass("RemoteEvent")
                                if re then re:FireServer(obj) end
                            end
                        end
                    end
                end
            end
        end
    end
end)

return CombatModule
