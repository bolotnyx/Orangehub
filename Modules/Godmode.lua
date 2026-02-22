-- Настройки Killaura
local KillauraSettings = {
    Distance = 15,        -- Радиус атаки (в метрах/студах)
    AttackSpeed = 0.5,    -- Задержка между ударами (в секундах)
    Enabled = true        -- Включена ли функция по умолчанию
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Функция для поиска ближайшей цели
local function getNearestTarget()
    local closestTarget = nil
    local shortestDistance = KillauraSettings.Distance
    
    -- Получаем текущую позицию нашего персонажа
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end

    -- Перебираем всех существ в Workspace
    for _, obj in pairs(workspace:GetChildren()) do
        local human = obj:FindFirstChildOfClass("Humanoid")
        local targetRoot = obj:FindFirstChild("HumanoidRootPart")
        
        -- Проверяем: это не мы, у него есть здоровье, и это живое существо
        if human and targetRoot and obj ~= character and human.Health > 0 then
            local distance = (rootPart.Position - targetRoot.Position).Magnitude
            
            if distance <= shortestDistance then
                closestTarget = obj
                shortestDistance = distance
            end
        end
    end
    return closestTarget
end

-- Основной цикл работы (выполняется постоянно)
task.spawn(function()
    while true do
        if KillauraSettings.Enabled then
            local target = getNearestTarget()
            
            if target then
                -- Проверяем, держит ли игрок инструмент (Tool)
                local tool = character:FindFirstChildOfClass("Tool")
                
                if tool then
                    -- Активируем инструмент (наносим удар)
                    tool:Activate()
                end
            end
        end
        -- Ждем перед следующим ударом, чтобы не вызывать лаги
        task.wait(KillauraSettings.AttackSpeed)
    end
end)

-- Чтобы ты мог управлять этим из других скриптов Гитхаба:
return KillauraSettings
