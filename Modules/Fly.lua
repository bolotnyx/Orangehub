local FlyMod = { Enabled = false }
local LP = game.Players.LocalPlayer

function FlyMod.SetState(state)
    FlyMod.Enabled = state
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if state and root then
        local bv = root:FindFirstChild("OrangeBV") or Instance.new("BodyVelocity", root)
        local bg = root:FindFirstChild("OrangeBG") or Instance.new("BodyGyro", root)
        bv.Name = "OrangeBV"
        bg.Name = "OrangeBG"
        
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        
        task.spawn(function()
            while FlyMod.Enabled and root and char:Parent() do
                -- Используем глобальную скорость или 50 по умолчанию
                local speed = _G.FlySpeedValue or 50
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed
                bg.CFrame = workspace.CurrentCamera.CFrame
                task.wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end)
    end
end

return FlyMod
