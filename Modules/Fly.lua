local FlyModule = {
    Enabled = false,
    Speed = 50
}

local LP = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

task.spawn(function()
    local BV, BG
    
    RunService.Heartbeat:Connect(function()
        if FlyModule.Enabled and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local Root = LP.Character.HumanoidRootPart
            local Hum = LP.Character:FindFirstChildOfClass("Humanoid")
            
            -- Создаем силы, если их нет
            if not BV or BV.Parent ~= Root then
                BV = Instance.new("BodyVelocity")
                BV.Parent = Root
                BV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                
                BG = Instance.new("BodyGyro")
                BG.Parent = Root
                BG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                BG.D = 10
            end
            
            -- ГЛАВНОЕ ИСПРАВЛЕНИЕ:
            -- Отключаем падение и ходьбу, чтобы персонаж не "бегал"
            if Hum then
                Hum.PlatformStand = true -- Отключает стандартную физику ходьбы
                
                -- Движение по направлению джойстика
                BV.Velocity = Hum.MoveDirection * FlyModule.Speed
                
                -- Поворот персонажа
                if Hum.MoveDirection.Magnitude > 0 then
                    BG.CFrame = CFrame.new(Root.Position, Root.Position + Hum.MoveDirection)
                else
                    BG.CFrame = CFrame.new(Root.Position, Root.Position + Root.CFrame.LookVector)
                end
            end
        else
            -- Возвращаем всё как было, когда выключаем
            if BV then BV:Destroy() BV = nil end
            if BG then BG:Destroy() BG = nil end
            
            if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
                LP.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
            end
        end
    end)
end)

return FlyModule
