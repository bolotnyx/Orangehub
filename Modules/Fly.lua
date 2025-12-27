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
            
            -- Создаем силы управления
            if not BV or BV.Parent ~= Root then
                BV = Instance.new("BodyVelocity")
                BV.Parent = Root
                BV.MaxForce = Vector3.new(1e9, 1e9, 1e9) -- Огромная сила для преодоления физики
                
                BG = Instance.new("BodyGyro")
                BG.Parent = Root
                BG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                BG.D = 10
            end
            
            if Hum then
                -- 1. Отключаем физику ног
                Hum.PlatformStand = true 
                
                -- 2. Принудительно поднимаем чуть выше, чтобы не цеплять пол
                -- (Добавляем небольшую силу вверх, если джойстик на нуле)
                if Hum.MoveDirection.Magnitude > 0 then
                    BV.Velocity = Hum.MoveDirection * FlyModule.Speed
                else
                    -- Зависание на месте без падения
                    BV.Velocity = Vector3.new(0, 0.1, 0) 
                end
                
                -- 3. Удержание ориентации
                if Hum.MoveDirection.Magnitude > 0 then
                    BG.CFrame = CFrame.new(Root.Position, Root.Position + Hum.MoveDirection)
                else
                    BG.CFrame = CFrame.new(Root.Position, Root.Position + Root.CFrame.LookVector)
                end
            end
            
            -- Убираем гравитацию для всех частей тела (чтобы не тянуло вниз)
            for _, part in ipairs(LP.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false -- Пролёт сквозь мелкие объекты (опционально)
                end
            end
            
        else
            -- ВОЗВРАТ В НОРМАЛЬНОЕ СОСТОЯНИЕ
            if BV then BV:Destroy() BV = nil end
            if BG then BG:Destroy() BG = nil end
            
            if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
                local Hum = LP.Character:FindFirstChildOfClass("Humanoid")
                Hum.PlatformStand = false
                
                -- Возвращаем коллизию частям тела
                for _, part in ipairs(LP.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end)
end)

return FlyModule
