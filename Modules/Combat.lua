local CombatModule = {
    KillAura = false,
    Range = 25 -- Тот самый радиус. Можно менять.
}

local LP = game.Players.LocalPlayer
-- Список целей (включая мамонтов и медведей по твоей просьбе)
local enemies = {"Wolf", "Bear", "Cultist", "Mammoth", "Bunny", "Alpha"}
-- Черный список (то, что не трогаем)
local blacklist = {"Mammoth Tusk", "wolf spawner", "wolf respawner", "wolf head", "bunny burrow"}

task.spawn(function()
    while true do
        task.wait(0.1) -- Скорость ударов (0.1 сек = очень быстро)
        
        if CombatModule.KillAura and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            
            -- Проверяем, есть ли инструмент (топор/меч) в руках
            if tool then
                local myPos = LP.Character.HumanoidRootPart.Position

                for _, obj in ipairs(workspace:GetChildren()) do
                    -- Ищем модели с Humanoid (живые существа)
                    if obj:IsA("Model") and obj ~= LP.Character and obj:FindFirstChildOfClass("Humanoid") then
                        
                        local isEnemy = false
                        local name = obj.Name
                        
                        -- Проверяем, подходит ли имя под список врагов
                        for _, enemyName in ipairs(enemies) do
                            if name:find(enemyName) then
                                isEnemy = true
                                -- Но если это в черном списке (например, бивень), то отменяем
                                for _, blackName in ipairs(blacklist) do
                                    if name:find(blackName) then
                                        isEnemy = false
                                        break
                                    end
                                end
                                break
                            end
                        end

                        if isEnemy then
                            local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                            if root then
                                local dist = (myPos - root.Position).Magnitude
                                if dist <= CombatModule.Range then
                                    -- 1. МОМЕНТАЛЬНЫЙ РАЗВОРОТ (как в Moondate для регистрации хита)
                                    LP.Character.HumanoidRootPart.CFrame = CFrame.new(myPos, Vector3.new(root.Position.X, myPos.Y, root.Position.Z))
                                    
                                    -- 2. ВИЗУАЛЬНЫЙ ВЗМАХ
                                    tool:Activate()
                                    
                                    -- 3. ПРЯМОЙ ВЫЗОВ УРОНА (через Touch или Remote)
                                    -- Имитируем касание лезвия и врага
                                    local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
                                    if handle then
                                        firetouchinterest(root, handle, 0) -- Касание началось
                                        firetouchinterest(root, handle, 1) -- Касание закончилось
                                    end

                                    -- Пробуем отправить RemoteEvent (если игра его использует)
                                    local event = tool:FindFirstChildOfClass("RemoteEvent")
                                    if event then
                                        event:FireServer(obj)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

return CombatModule
