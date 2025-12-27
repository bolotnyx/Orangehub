local FlyModule = {
    Enabled = false,
    Speed = 50
}

local LP = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Основной цикл полета
RunService.Stepped:Connect(function()
    if FlyModule.Enabled then
        local Char = LP.Character
        local Root = Char and Char:FindFirstChild("HumanoidRootPart")
        local Hum = Char and Char:FindFirstChildOfClass("Humanoid")
        local Camera = workspace.CurrentCamera

        if Root and Hum then
            -- Создаем или берем существующие силы
            local BV = Root:FindFirstChild("FlyVelocity") or Instance.new("BodyVelocity", Root)
            local BG = Root:FindFirstChild("FlyGyro") or Instance.new("BodyGyro", Root)

            BV.Name = "FlyVelocity"
            BG.Name = "FlyGyro"

            -- Настройки сил
            BV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            BG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            BG.D = 50
            
            -- Отключаем стандартную физику
            Hum.PlatformStand = true

            -- УПРАВЛЕНИЕ
            if Hum.MoveDirection.Magnitude > 0 then
                -- Мы берем направление джойстика и ПЕРЕНОСИМ его на наклон камеры
                -- Это Самый стабильный метод для мобилок
                local camCF = Camera.CFrame
                local moveDir = (camCF.RightVector * Hum.MoveDirection.X) + (camCF.LookVector * -Hum.MoveDirection.Z)
                
                BV.Velocity = moveDir.Unit * FlyModule.Speed
                BG.CFrame = CFrame.new(Root.Position, Root.Position + moveDir)
            else
                -- Зависаем в воздухе
                BV.Velocity = Vector3.new(0, 0, 0)
                BG.CFrame = Camera.CFrame
            end
        end
    else
        -- Очистка при выключении
        local Char = LP.Character
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
