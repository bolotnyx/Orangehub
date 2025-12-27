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
            
            -- Управление через джойстик/клавиши (MoveDirection)
            if Hum then
                -- Если джойстик не трогают, персонаж просто висит (Velocity = 0)
                -- Если джойстик отклонен, летим в сторону направления движения
                BV.Velocity = Hum.MoveDirection * FlyModule.Speed
                
                -- Поворачиваем персонажа лицом туда, куда он летит (если движется)
                if Hum.MoveDirection.Magnitude > 0 then
                    BG.CFrame = CFrame.new(Root.Position, Root.Position + Hum.MoveDirection)
                end
            end
        else
            -- Удаляем силы, если выключили полет
            if BV then BV:Destroy() BV = nil end
            if BG then BG:Destroy() BG = nil end
        end
    end)
end)

return FlyModule
