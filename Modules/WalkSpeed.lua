-- [[ ORANGE HUB - WALK SPEED MODULE (ANTI-STIFF) ]]
local LP = game:GetService("Players").LocalPlayer

local function FixHumanoid(hum)
    if not hum then return end
    -- Блокируем состояния, которые делают персонажа "деревянным"
    hum.PlatformStand = false
    hum.Sit = false
    hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
end

local function ApplySpeed()
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            FixHumanoid(hum)
            if _G.SpeedEnabled and _G.WalkSpeedValue then
                hum.WalkSpeed = _G.WalkSpeedValue
            else
                hum.WalkSpeed = 16 -- Стандарт
            end
        end
    end
end

-- Основной цикл контроля (максимально легкий)
task.spawn(function()
    while true do
        if _G.SpeedEnabled then
            ApplySpeed()
        end
        task.wait(0.1) -- Проверка 10 раз в секунду, чтобы не лагало
    end
end)

-- Исправление при прыжке (UserInputService)
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.SpeedEnabled or _G.InfJumpEnabled then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

LP.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    task.wait(0.5)
    ApplySpeed()
end)

print("✅ WalkSpeed Fixed: Anti-Stiff Active")
