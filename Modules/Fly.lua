local FlyModule = {
    Enabled = false,
    Speed = 50
}

local LP = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

RunService.RenderStep:Connect(function()
    if FlyModule.Enabled and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local Root = LP.Character.HumanoidRootPart
        local Hum = LP.Character:FindFirstChildOfClass("Humanoid")
        
        -- Ищем или создаем объекты силы
        local BV = Root:FindFirstChild("FlyVelocity") or Instance.new("BodyVelocity", Root)
        local BG = Root:FindFirstChild("FlyGyro") or Instance.new("BodyGyro", Root)
        
        BV.Name = "FlyVelocity"
        BG.Name = "FlyGyro"
        
        BV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        BG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        BG.D = 50 -- Плавность поворота
        
        Hum.PlatformStand = true
        
        -- ЛОГИКА УПРАВЛЕНИЯ
        if Hum.MoveDirection.Magnitude > 0 then
            -- Вычисляем направление полета:
            -- Берем направление взгляда камеры и умножаем на вектор движения джойстика
            local camCF = Camera.CFrame
            local direction = (camCF.RightVector * Hum.MoveDirection.X) + (camCF.LookVector * -Hum.MoveDirection.Z)
            
            BV.Velocity = direction.Unit * FlyModule.Speed
            BG.CFrame = CFrame.new(Root.Position, Root.Position + direction)
        else
            -- Замираем в воздухе
            BV.Velocity = Vector3.new(0, 0, 0)
            BG.CFrame = Camera.CFrame
        end
    else
        -- Очистка при выключении
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local Root = LP.Character.HumanoidRootPart
            if Root:FindFirstChild("FlyVelocity") then Root.FlyVelocity:Destroy() end
            if Root:FindFirstChild("FlyGyro") then Root.FlyGyro:Destroy() end
            if LP.Character:FindFirstChildOfClass("Humanoid") then
                LP.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
            end
        end
    end
end)

return FlyModule
