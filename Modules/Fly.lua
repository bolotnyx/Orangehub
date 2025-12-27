local FlyModule = {
    Enabled = false,
    Speed = 50
}

local LP = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

RunService.Stepped:Connect(function()
    local Char = LP.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    local Hum = Char and Char:FindFirstChildOfClass("Humanoid")
    local Camera = workspace.CurrentCamera

    if FlyModule.Enabled and Root and Hum then
        local BV = Root:FindFirstChild("FlyVelocity") or Instance.new("BodyVelocity", Root)
        local BG = Root:FindFirstChild("FlyGyro") or Instance.new("BodyGyro", Root)

        BV.Name = "FlyVelocity"
        BG.Name = "FlyGyro"
        BV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        BG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        BG.D = 50
        
        Hum.PlatformStand = true

        -- РАСЧЕТ ДВИЖЕНИЯ
        if Hum.MoveDirection.Magnitude > 0 then
            -- Определяем направление относительно экрана
            -- На мобилках: MoveDirection.Z < 0 это "вперед" (джойстик вверх)
            -- MoveDirection.X > 0 это "вправо"
            
            local camCF = Camera.CFrame
            local lv = camCF.LookVector
            local rv = camCF.RightVector
            
            -- Вычисляем вектор:
            -- Берем "вперед" камеры и умножаем на силу наклона джойстика по вертикали
            -- Берем "право" камеры и умножаем на силу наклона джойстика по горизонтали
            -- Используем локальные координаты джойстика (ControlModule), но так как мы 
            -- работаем с Hum.MoveDirection, нам нужно просто "отвязать" его от мировых координат
            
            -- Самый стабильный способ для мобилок:
            local rawMove = camCF:VectorToObjectSpace(Hum.MoveDirection)
            local finalDir = (camCF.LookVector * -rawMove.Z) + (camCF.RightVector * rawMove.X)
            
            BV.Velocity = finalDir.Unit * FlyModule.Speed
            BG.CFrame = camCF
        else
            BV.Velocity = Vector3.new(0, 0, 0)
            BG.CFrame = camCF
        end
    else
        -- Очистка
        if Root then
            if Root:FindFirstChild("FlyVelocity") then Root.FlyVelocity:Destroy() end
            if Root:FindFirstChild("FlyGyro") then Root.FlyGyro:Destroy() end
        end
        if Hum then Hum.PlatformStand = false end
    end
end)

return FlyModule
