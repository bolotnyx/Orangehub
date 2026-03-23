-- [[ ORANGE HUB V4 - GODMODE ]]
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local player     = Players.LocalPlayer

local GodmodeMod = { Enabled = false }

local function applyToHumanoid(hum)
    if not hum then return end
    pcall(function() hum.BreakJointsOnDeath = false end)
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end)
end

local function applyForceField(char, on)
    if not char then return end
    local existing = char:FindFirstChildOfClass("ForceField")
    if on and not existing then
        local ff = Instance.new("ForceField")
        ff.Visible = false
        ff.Parent = char
    elseif not on and existing then
        existing:Destroy()
    end
end

-- Применяем каждый раз при спавне персонажа
local function onCharacter(char)
    task.wait(0.2)
    local hum = char:WaitForChild("Humanoid", 8)
    applyToHumanoid(hum)
    if GodmodeMod.Enabled then
        applyForceField(char, true)
    end
    -- Защищаем от смерти с самого начала если включён
    if hum then
        hum.Died:Connect(function()
            if GodmodeMod.Enabled then
                task.wait(0.05)
                -- Немедленно перезаряжаем персонажа
                player:LoadCharacter()
            end
        end)
    end
end

if player.Character then task.spawn(onCharacter, player.Character) end
player.CharacterAdded:Connect(onCharacter)

-- Heartbeat: ForceField + HP каждый кадр
RunService.Heartbeat:Connect(function()
    if not GodmodeMod.Enabled then
        -- Убрать ForceField если выключен
        local c = player.Character
        if c then applyForceField(c, false) end
        return
    end

    local char = player.Character
    if not char then return end

    -- ForceField — постоянно
    applyForceField(char, true)

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- Состояние смерти выключено
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
    pcall(function() hum.BreakJointsOnDeath = false end)

    -- Мгновенное восстановление HP
    pcall(function()
        if hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
    end)
end)

-- __namecall: перехват TakeDamage (для случаев когда всё же вызывается клиентом)
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNC = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        if GodmodeMod.Enabled and getnamecallmethod() == "TakeDamage" then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and rawequal(self, hum) then return end
            end
        end
        return oldNC(self, ...)
    end)
    setreadonly(mt, true)
end)

return GodmodeMod
