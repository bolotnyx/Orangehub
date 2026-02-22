local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Settings = {
    Distance = 18,         -- Радиус (лучше не ставить больше 20)
    AttackSpeed = 0.3,     -- Задержка между ударами
    Enabled = true,
    AutoEquip = true       -- Автоматически брать меч в руки
}

local player = Players.LocalPlayer

-- Функция проверки: является ли объект врагом (твои условия)
local function isValidEnemy(item)
    if not item:IsA("Model") then return nil end
    
    -- Твои условия из ESP
    local isEnemy = item.Name:find("Wolf") or 
                    item.Name:find("Bunny") or 
                    item.Name:find("Cultist") or 
                    item.Name:find("Bear") or 
                    item.Name:find("Alpha") or
                    item.Name:find("Культист") or
                    item.Name:find("Медведь") or
                    item.Name:find("Mammoth")
    
    local humanoid = item:FindFirstChildOfClass("Humanoid")
    local rootPart = item:FindFirstChild("HumanoidRootPart") or item:FindFirstChild("Head")

    -- Если имя совпало И есть гуманоид со здоровьем > 0
    if (isEnemy or humanoid) and humanoid and rootPart and humanoid.Health > 0 then
        if item ~= player.Character then
            return rootPart
        end
    end
    return nil
end

-- Функция для экипировки оружия
local function equipWeapon()
    local char = player.Character
    if not char then return end
    
    -- Если в руках ничего нет
    if not char:FindFirstChildOfClass("Tool") then
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            local tool = backpack:FindFirstChildOfClass("Tool")
            if tool then
                -- Экипируем первый попавшийся инструмент
                humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:EquipTool(tool)
                end
            end
        end
    end
end

-- Основной цикл
task.spawn(function()
    while task.wait(Settings.AttackSpeed) do
        if not Settings.Enabled then continue end
        
        local char = player.Character
        local myRoot = char and char:FindFirstChild("HumanoidRootPart")
        
        if myRoot then
            -- Пытаемся взять меч, если нужно
            if Settings.AutoEquip then equipWeapon() end
            
            local tool = char:FindFirstChildOfClass("Tool")
            
            -- Ищем врагов в Workspace
            for _, obj in pairs(workspace:GetChildren()) do
                local targetPart = isValidEnemy(obj)
                
                if targetPart then
                    local distance = (myRoot.Position - targetPart.Position).Magnitude
                    
                    if distance <= Settings.Distance then
                        if tool then
                            -- Наносим удар
                            tool:Activate()
                        end
                    end
                end
            end
        end
    end
end)

return Settings
