local CombatModule = {
    KillAura = false,
    Range = 20
}

local LP = game.Players.LocalPlayer
local enemies = {"Wolf", "Bear", "Cultist", "Mammoth", "Bunny", "Alpha", "Культист", "Медведь"}

-- ФУНКЦИЯ УВЕЛИЧЕНИЯ ХИТБОКСОВ (Глобальный метод)
local function expandHitboxes()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local isEnemy = false
            for _, name in ipairs(enemies) do
                if obj.Name:find(name) then isEnemy = true break end
            end

            if isEnemy then
                local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                if root then
                    -- Если аура включена, раздуваем хитбокс до гигантских размеров
                    if CombatModule.KillAura then
                        root.Size = Vector3.new(15, 15, 15)
                        root.Transparency = 0.7 -- Слегка подсветим зону попадания
                        root.CanCollide = false
                    else
                        -- Возвращаем как было
                        root.Size = Vector3.new(2, 2, 1)
                        root.Transparency = 0
                    end
                end
            end
        end
    end
end

-- Основной цикл атаки
task.spawn(function()
    while true do
        task.wait(0.2)
        if CombatModule.KillAura and LP.Character then
            -- 1. Раздуваем хитбоксы врагов поблизости
            expandHitboxes()

            -- 2. Берем инструмент и машем
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
                
                -- Попытка найти глобальное событие урона в игре
                local rs = game:GetService("ReplicatedStorage")
                local attackRemotes = {
                    rs:FindFirstChild("Attack"),
                    rs:FindFirstChild("Hit"),
                    rs:FindFirstChild("Damage")
                }
                
                for _, remote in ipairs(attackRemotes) do
                    if remote and remote:IsA("RemoteEvent") then
                        -- Пытаемся отправить сигнал атаки "в воздух" перед собой
                        remote:FireServer() 
                    end
                end
            end
        end
    end
end)

return CombatModule
