local FlyModule = {
    Enabled = false,
    Speed = 50
}

local LP = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

task.spawn(function()
    local BV, BG
    
    RunService.Heartbeat:Connect(function()
        if FlyModule.Enabled and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local Root = LP.Character.HumanoidRootPart
            local Hum = LP.Character:FindFirstChildOfClass("Humanoid")
            
            if not BV or BV.Parent ~= Root then
                BV = Instance.new("BodyVelocity", Root)
                BV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                
                BG = Instance.new("BodyGyro", Root)
                BG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                BG.D = 10
            end
            
            if Hum then
                Hum.PlatformStand = true
                
                -- Если джойстик отклонен
                if Hum.MoveDirection.Magnitude > 0 then
                    -- Направление джойстика относительно камеры (учитывает наклон вверх/вниз)
                    local lookVec = Camera.CFrame.LookVector
                    local rightVec = Camera.CFrame.RightVector
                    
                    -- Вычисляем вектор движения на основе WASD/Джойстика и Камеры
                    local moveVec = Vector3.new(0,0,0)
                    
                    -- Определяем, куда именно жмет игрок относительно взгляда
                    local forward = lookVec * (Hum.MoveDirection:Dot(Camera.CFrame.LookVector.Unit))
                    local side = rightVec * (Hum.MoveDirection:Dot(Camera.CFrame.RightVector.Unit))
                    
                    BV.Velocity = (Camera.CFrame:VectorToWorldSpace(Vector3.new(
                        Hum.MoveDirection:Dot(Camera.CFrame.RightVector),
                        0,
                        -Hum.MoveDirection:Dot(Camera.CFrame.LookVector)
                    )) * -1 + Vector3.new(0, Hum.MoveDirection.Z * -lookVec.Y, 0)) * FlyModule.Speed
                    
                    -- Простой и надежный расчет для 3D полета:
                    -- Мы берем направление, куда смотрит камера, и умножаем на силу нажатия джойстика
                    local moveDir = (Camera.CFrame.LookVector * (Hum.MoveDirection.Z < 0 and -1 or (Hum.MoveDirection.Z > 0 and 1 or 0))) + 
                                    (Camera.CFrame.RightVector * (Hum.MoveDirection.X > 0 and 1 or (Hum.MoveDirection.X < 0 and -1 or 0)))
                    
                    if moveDir.Magnitude > 0 then
                        BV.Velocity = moveDir.Unit * FlyModule.Speed
                        BG.CFrame = Camera.CFrame
                    else
                        BV.Velocity = Vector3.new(0, 0.1, 0)
                    end
                else
                    BV.Velocity = Vector3.new(0, 0.1, 0)
                    BG.CFrame = Camera.CFrame
                end
            end
        else
            if BV then BV:Destroy() BV = nil end
            if BG then BG:Destroy() BG = nil end
            if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
                LP.Character.Humanoid.PlatformStand = false
            end
        end
    end)
end)

return FlyModule
