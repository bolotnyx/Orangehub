local FlyModule = {
    Enabled = false,
    Speed = 50
}

local LP = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

RunService.RenderStep:Connect(function()
    local Char = LP.Character
    if FlyModule.Enabled and Char and Char:FindFirstChild("HumanoidRootPart") then
        local Root = Char.HumanoidRootPart
        local Hum = Char:FindFirstChildOfClass("Humanoid")
        
        -- Получаем или создаем силы
        local BV = Root:FindFirstChild("FlyVelocity") or Instance.new("BodyVelocity", Root)
        local BG = Root:FindFirstChild("FlyGyro") or Instance.new("BodyGyro", Root)
        
        BV.Name = "FlyVelocity"
        BG.Name = "FlyGyro"
        
        BV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        BG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        BG.D = 50 
        
        Hum.PlatformStand = true
        
        -- Направление камеры
        local camCF = Camera.CFrame
        
        -- Если джойстик двигается
        if Hum.MoveDirection.Magnitude > 0 then
            -- Вычисляем вектор на основе того, КУДА МЫ ЖМЕМ на джойстике
            -- относительно того, КУДА СМОТРИТ КАМЕРА
            local direction = camCF:VectorToWorldSpace(Vector3.new(
                Hum.MoveDirection:Dot(camCF.RightVector),
                0, 
                -Hum.MoveDirection:Dot(camCF.LookVector)
            ))
            
            -- Если нужно лететь вверх/вниз при наклоне камеры
            -- Мы просто используем LookVector камеры напрямую
            local finalVelocity = camCF.LookVector * (Hum.MoveDirection:Dot(camCF.LookVector) > 0 and 1 or -1)
            
            -- Упрощенная логика: летим ровно туда, куда направлен джойстик в 3D пространстве камеры
            BV.Velocity = camCF:VectorToWorldSpace(Vector3.new(Hum.MoveDirection:Dot(camCF.RightVector), 0, -Hum.MoveDirection:Dot(camCF.LookVector))).Unit * FlyModule.Speed
            
            -- Плавный поворот персонажа по вектору движения
            BG.CFrame = camCF
        else
            -- Замираем и не падаем
            BV.Velocity = Vector3.new(0, 0, 0)
            BG.CFrame = camCF
        end
    else
        -- Отключение
        if Char and Char:FindFirstChild("HumanoidRootPart") then
            local Root = Char.HumanoidRootPart
            if Root:FindFirstChild("FlyVelocity") then Root.FlyVelocity:Destroy() end
            if Root:FindFirstChild("FlyGyro") then Root.FlyGyro:Destroy() end
            if Char:FindFirstChildOfClass("Humanoid") then
                Char:FindFirstChildOfClass("Humanoid").PlatformStand = false
            end
        end
    end
end)

return FlyModule
