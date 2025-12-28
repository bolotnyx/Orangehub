local FlyMod = { Enabled = false }
local LP = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

function FlyMod.SetState(state)
    FlyMod.Enabled = state
    
    local char = LP.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if not root or not hum then 
        warn("🍊 Fly: Персонаж не найден!")
        return 
    end

    if state then
        print("🍊 Fly: Включен")
        -- 1. Отключаем физику ног, чтобы не падать
        hum.PlatformStand = true
        
        -- 2. Создаем двигатели
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "OrangeBV"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)

        local bg = Instance.new("BodyGyro", root)
        bg.Name = "OrangeBG"
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 9000
        bg.CFrame = root.CFrame

        -- 3. Цикл полета
        task.spawn(function()
            while FlyMod.Enabled and char and char.Parent and root do
                local cam = workspace.CurrentCamera
                local speed = _G.FlySpeedValue or 50 -- Читаем скорость из UI
                
                -- Направление камеры
                bv.Velocity = cam.CFrame.LookVector * speed
                bg.CFrame = cam.CFrame
                
                task.wait()
            end
            
            -- Очистка при выходе из цикла (смерть или отключение)
            if root:FindFirstChild("OrangeBV") then root.OrangeBV:Destroy() end
            if root:FindFirstChild("OrangeBG") then root.OrangeBG:Destroy() end
            if hum then hum.PlatformStand = false end
        end)

    else
        print("🍊 Fly: Выключен")
        -- Удаляем двигатели и возвращаем физику
        if root:FindFirstChild("OrangeBV") then root.OrangeBV:Destroy() end
        if root:FindFirstChild("OrangeBG") then root.OrangeBG:Destroy() end
        hum.PlatformStand = false
    end
end

return FlyMod
