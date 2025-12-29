-- [[ ORANGE HUB - WALK SPEED MODULE (ULTIMATE ANIMATION FIX) ]]
local LP = game:GetService("Players").LocalPlayer

local function FixCharacter(char)
    local hum = char:WaitForChild("Humanoid")
    
    -- Принудительно включаем все анимационные состояния
    hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
    
    -- Выключаем режим, который делает тебя "кирпичом"
    hum.PlatformStand = false
    hum.Sit = false
end

task.spawn(function()
    while true do
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if _G.SpeedEnabled and hum then
            -- 1. Ставим скорость
            hum.WalkSpeed = _G.WalkSpeedValue or 16
            
            -- 2. ГЛАВНЫЙ ФИКС: Если персонаж застыл
            if hum.PlatformStand == true then
                hum.PlatformStand = false
            end
            
            -- 3. Если анимации "зависли" в состоянии Physics
            if hum:GetState() == Enum.HumanoidStateType.Physics then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            
            -- 4. Проверяем наличие скрипта анимаций
            local animate = char:FindFirstChild("Animate")
            if animate and animate.Disabled then
                animate.Disabled = false
            end
        elseif not _G.SpeedEnabled and hum then
            if hum.WalkSpeed ~= 16 then
                hum.WalkSpeed = 16
            end
        end
        task.wait() -- Ждем 1 кадр для моментальной реакции
    end
end)

-- Принудительный прыжок (решает проблему с пробелом)
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.SpeedEnabled then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Фикс при спавне
LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    FixCharacter(char)
end)

if LP.Character then FixCharacter(LP.Character) end

return {Loaded = true}
