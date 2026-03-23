-- [[ ORANGE HUB V4 - GODMODE ]]
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local player     = Players.LocalPlayer

local GodmodeMod = { Enabled = false }

-- ── 1. __namecall — перехват TakeDamage ──────────────────────────────────────────
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

-- ── 2. __newindex — перехват прямого урона: humanoid.Health = x ──────────────────
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNI = mt.__newindex
    mt.__newindex = newcclosure(function(self, key, value)
        if GodmodeMod.Enabled and key == "Health" then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and rawequal(self, hum) then
                    if value < hum.MaxHealth then return end
                end
            end
        end
        return oldNI(self, key, value)
    end)
    setreadonly(mt, true)
end)

-- ── 3. Heartbeat — ForceField-петля + восстановление HP ──────────────────────────
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end

    if GodmodeMod.Enabled then
        -- Пересоздаём ForceField если игра удалила
        if not char:FindFirstChildOfClass("ForceField") then
            local ff = Instance.new("ForceField")
            ff.Visible = false
            ff.Parent = char
        end
        -- Восстанавливаем HP
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                if hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
            end)
        end
    else
        -- Выключен — убираем ForceField
        local ff = char:FindFirstChildOfClass("ForceField")
        if ff then ff:Destroy() end
        -- Возвращаем дефолт
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            end)
        end
    end
end)

return GodmodeMod
