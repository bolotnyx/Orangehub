local FlyMod = { Enabled = false }
local LP = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

function FlyMod.SetState(state)
    FlyMod.Enabled = state
    
    local char = LP.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if not root or not hum then 
        return 
    end

    if state then
        -- Отключаем физику, чтобы не падать и не "шагать" в воздухе
        hum.PlatformStand = true
        
        -- Создаем стабилизатор вращения (чтобы персонаж не кувыркался)
        local bg = Instance.new("BodyGyro", root)
        bg.Name = "OrangeFlyBG"
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.P = 9000
        bg.CFrame = root.CFrame

        -- Создаем двигатель
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "OrangeFlyBV"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)

        -- Цикл управления
        task.spawn(function()
            while FlyMod.Enabled and char and char.Parent and root do
                local cam = workspace.CurrentCamera
                local speed = _G.FlySpeedValue or 50
                
                -- Читаем направление джойстика/WASD
                local moveDir = hum.MoveDirection
                
                if moveDir.Magnitude > 0 then
                    -- Если джойстик отклонен, летим по направлению камеры
                    bv.Velocity = cam.CFrame.LookVector * speed * moveDir.Magnitude
                else
                    -- Если джойстик в покое, просто висим
                    bv.Velocity = Vector3.new(0, 0, 0)
                end
                
                -- Всегда поворачиваем персонажа туда, куда смотрит камера
                bg.CFrame = cam.CFrame
                
                task.wait()
            end
            
            -- Очистка при выключении
            if hum then hum.PlatformStand = false end
            if root:FindFirstChild("OrangeFlyBV") then root.OrangeFlyBV:Destroy() end
            if root:FindFirstChild("OrangeFlyBG") then root.OrangeFlyBG:Destroy() end
        end)
    else
        -- Принудительная очистка при выключении кнопки
        hum.PlatformStand = false
        if root:FindFirstChild("OrangeFlyBV") then root.OrangeFlyBV:Destroy() end
        if root:FindFirstChild("OrangeFlyBG") then root.OrangeFlyBG:Destroy() end
    end
end

return FlyMod
