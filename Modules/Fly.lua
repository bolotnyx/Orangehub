local FlyModule = {
    Enabled = false
}

local LP = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

task.spawn(function()
    local BV = Instance.new("BodyVelocity")
    local BG = Instance.new("BodyGyro")
    BV.MaxForce = Vector3.new(0, 0, 0)
    BG.MaxTorque = Vector3.new(0, 0, 0)

    RunService.RenderStepped:Connect(function()
        local Character = LP.Character
        if FlyModule.Enabled and Character and Character:FindFirstChild("HumanoidRootPart") then
            local Root = Character.HumanoidRootPart
            local Hum = Character:FindFirstChildOfClass("Humanoid")
            local Camera = workspace.CurrentCamera
            
            -- ВАЖНО: Берем скорость из твоего UI
            local currentSpeed = _G.FlySpeedValue or 50 

            BV.Parent = Root
            BG.Parent = Root
            
            BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            
            BG.CFrame = Camera.CFrame
            
            -- Читаем направление джойстика
            local moveDir = Hum.MoveDirection
            if moveDir.Magnitude > 0 then
                BV.Velocity = moveDir * currentSpeed
            else
                BV.Velocity = Vector3.new(0, 0.1, 0) -- Зависание в воздухе
            end
        else
            -- Полное отключение полета
            BV.MaxForce = Vector3.new(0, 0, 0)
            BG.MaxTorque = Vector3.new(0, 0, 0)
            if BV.Parent then BV.Parent = nil end
            if BG.Parent then BG.Parent = nil end
        end
    end)
end)

return FlyModule
