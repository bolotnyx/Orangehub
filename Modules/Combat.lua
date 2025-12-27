local CombatModule = {
    KillAura = false,
    Range = 25
}

local LP = game.Players.LocalPlayer
-- Твой черный список (игнорируем эти объекты)
local blacklist = {"Mammoth Tusk", "wolf spawner", "wolf respawner", "wolf head", "bunny burrow"}

task.spawn(function()
    while true do
        task.wait(0.1) -- Скорость проверки
        
        if CombatModule.KillAura and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            if not tool then continue end

            local myRoot = LP.Character.HumanoidRootPart
            
            -- Ищем вообще всех существ в игре
            for _, obj in ipairs(workspace:GetDescendants()) do
                -- Проверяем: модель, есть здоровье, это не ты
                if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= LP.Character then
                    
                    -- Проверка черного списка
                    local skip = false
                    for _, bName in ipairs(blacklist) do
                        if obj.Name:find(bName) then skip = true break end
                    end

                    if not skip then
                        local tRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                        if tRoot then
                            local dist = (myRoot.Position - tRoot.Position).Magnitude
                            if dist <= CombatModule.Range then
                                -- 1. ПОВОРОТ (Если это сработает, персонаж дернется к зайцу)
                                myRoot.CFrame = CFrame.new(myRoot.Position, Vector3.new(tRoot.Position.X, myRoot.Position.Y, tRoot.Position.Z))
                                
                                -- 2. УДАР (Анимация)
                                tool:Activate()
                                
                                -- 3. УРОН (Для мобильных читов через симуляцию касания)
                                local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
                                if handle then
                                    firetouchinterest(tRoot, handle, 0)
                                    firetouchinterest(tRoot, handle, 1)
                                end
                                
                                -- 4. Дополнительный пробив через Remote
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
