local CombatModule = {
    KillAura = false,
    Range = 20
}

local LP = game.Players.LocalPlayer
local Vim = game:GetService("VirtualInputManager")
local PlayerGui = LP:FindFirstChild("PlayerGui")

local enemies = {"Wolf", "Bear", "Cultist", "Mammoth", "Bunny", "Alpha", "Культист", "Медведь"}

-- Функция для поиска кнопки атаки в интерфейсе игры
local function clickAttackButton()
    -- Пытаемся найти кнопку в стандартных местах для 99 ночей
    -- Обычно они называются 'Attack', 'Punch', 'Use' или лежат в 'MainGui'
    if PlayerGui then
        for _, v in ipairs(PlayerGui:GetDescendants()) do
            if v:IsA("ImageButton") or v:IsA("TextButton") then
                if v.Visible and (v.Name:lower():find("attack") or v.Name:lower():find("action") or v.Name:lower():find("hit")) then
                    -- Имитируем нажатие прямо по центру этой кнопки
                    local pos = v.AbsolutePosition
                    local size = v.AbsoluteSize
                    Vim:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2, 0, true, game, 1)
                    task.wait(0.01)
                    Vim:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2, 0, false, game, 1)
                    return true
                end
            end
        end
    end
    return false
end

task.spawn(function()
    while true do
        task.wait(0.2)
        if CombatModule.KillAura and LP.Character then
            local foundTarget = false
            local myPos = LP.Character.HumanoidRootPart.Position

            -- 1. Работа с хитбоксами и поиск цели
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") then
                    local isEnemy = false
                    for _, name in ipairs(enemies) do
                        if obj.Name:find(name) then isEnemy = true break end
                    end

                    if isEnemy and not game.Players:GetPlayerFromCharacter(obj) then
                        local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                        if root then
                            local dist = (myPos - root.Position).Magnitude
                            if dist < CombatModule.Range then
                                -- Раздуваем куб
                                root.Size = Vector3.new(12, 12, 12)
                                root.Transparency = 0.8
                                root.CanCollide = false
                                foundTarget = true
                                
                                -- Поворачиваемся
                                LP.Character.HumanoidRootPart.CFrame = CFrame.new(myPos, Vector3.new(root.Position.X, myPos.Y, root.Position.Z))
                            else
                                -- Сдуваем обратно, если далеко
                                root.Size = Vector3.new(2, 2, 2)
                                root.Transparency = 1
                            end
                        end
                    end
                end
            end

            -- 2. Если враг рядом — бьем через кнопку интерфейса
            if foundTarget then
                local tool = LP.Character:FindFirstChildOfClass("Tool")
                if tool then
                    -- Если не нашли кнопку в UI, просто кликаем в правую часть экрана
                    if not clickAttackButton() then
                        Vim:SendMouseButtonEvent(900, 500, 0, true, game, 1)
                        task.wait(0.01)
                        Vim:SendMouseButtonEvent(900, 500, 0, false, game, 1)
                    end
                end
            end
        end
    end
end)

return CombatModule
