-- [[ ORANGE HUB - WALK SPEED MODULE ]]
local LP = game:GetService("Players").LocalPlayer

local function Unfreeze(hum)
    hum.PlatformStand = false
    hum.Sit = false
    if hum:GetState() == Enum.HumanoidStateType.Physics then
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

task.spawn(function()
    while true do
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if _G.SpeedEnabled and hum then
            hum.WalkSpeed = _G.WalkSpeedValue or 16
            Unfreeze(hum) -- Постоянно выбиваем из состояния кирпича
            
            -- Проверка анимаций
            local anim = char:FindFirstChild("Animate")
            if anim and anim.Disabled then anim.Disabled = false end
        elseif not _G.SpeedEnabled and hum then
            if hum.WalkSpeed ~= 16 then hum.WalkSpeed = 16 end
        end
        task.wait()
    end
end)

return {Loaded = true}
