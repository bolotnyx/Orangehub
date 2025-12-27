local CombatModule = {
    KillAura = false,
    Range = 25
}

local LP = game.Players.LocalPlayer
local enemies = {"Wolf", "Bear", "Cultist", "Mammoth", "Bunny", "Alpha"}
local blacklist = {"Mammoth Tusk", "wolf spawner", "wolf respawner", "wolf head", "bunny burrow"}

task.spawn(function()
    while true do
        task.wait(0.1) -- Скорость ударов
        
        -- Проверяем либо внутреннюю переменную, либо глобальную (для надежности)
        if (CombatModule.KillAura or _G.KillAura) and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            if not tool then continue end

            local myPos = LP.Character.HumanoidRootPart.Position

            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= LP.Character then
                    
                    local name = obj.Name
                    local isEnemy = false

                    -- Проверка имен врагов
                    for _, enName in ipairs(enemies) do
                        if name:find(enName) then
                            isEnemy = true
                            -- Проверка черного списка (Tusk, Spawners и т.д.)
                            for _, bName in ipairs(blacklist) do
                                if name:find(bName) then isEnemy = false break end
                            end
                            break
                        end
                    end

                    if isEnemy then
                        local tRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                        if tRoot then
                            local dist = (myPos - tRoot.Position).Magnitude
                            if dist <= CombatModule.Range then
                                -- 1. РЕЗКИЙ ПОВОРОТ (индикатор того, что цель найдена)
                                LP.Character.HumanoidRootPart.CFrame = CFrame.new(myPos, Vector3.new(tRoot.Position.X, myPos.Y, tRoot.Position.Z))
                                
                                -- 2. УДАР
                                tool:Activate()
                                
                                -- 3. НАНЕСЕНИЕ УРОНА (TouchInterest)
                                local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
                                if handle then
                                    firetouchinterest(tRoot, handle, 0)
                                    firetouchinterest(tRoot, handle, 1)
                                end
                                
                                -- 4. RemoteEvent (на случай, если Touch отключен)
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
