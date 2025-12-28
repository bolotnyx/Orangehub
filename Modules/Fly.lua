local FlyModule = {
    Enabled = false,
    Speed = 50
}

local LP = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

task.spawn(function()
    local BV = Instance.new("BodyVelocity")
    local BG = Instance.new("BodyGyro")
    BV.MaxForce = Vector3.new(0, 0, 0)
    BG.MaxTorque = Vector3.new(0, 0, 0)

    RunService.RenderStepped:Connect(function()
        if FlyModule.Enabled and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local Root = LP.Character.HumanoidRootPart
            local Hum = LP.Character:FindFirstChildOfClass("Humanoid")
            local Camera = workspace.CurrentCamera
            
            -- Обновляем скорость из глобальной переменной UI
            FlyModule.Speed = _G.FlySpeedValue or 50

            BV.Parent = Root
            BG.Parent = Root
            
            BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            
            BG.CFrame = Camera.CFrame
            
            -- Логика движения (совместима с джойстиком)
            local MoveDir = Hum.MoveDirection
            if MoveDir.Magnitude > 0 then
                BV.Velocity = MoveDir * FlyModule.Speed
            else
                BV.Velocity = Vector3.new(0, 0.1, 0) -- Висение на месте
            end
        else
            -- Выключаем физику полета, когда Fly выключен
            BV.MaxForce = Vector3.new(0, 0, 0)
            BG.MaxTorque = Vector3.new(0, 0, 0)
            if BV.Parent then BV.Parent = nil end
            if BG.Parent then BG.Parent = nil end
        end
    end)
end)

return FlyModule
