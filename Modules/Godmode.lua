-- [[ ORANGE HUB V4 - GODMODE ]]
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local GodmodeMod = { Enabled = false }

local conn = nil

local function attachGodmode(char)
    if conn then pcall(function() conn:Disconnect() end); conn = nil end

    local hum = char:WaitForChild("Humanoid", 10)
    if not hum then return end

    -- Не разрушать суставы при смерти
    pcall(function() hum.BreakJointsOnDeath = false end)

    conn = RunService.Heartbeat:Connect(function()
        if not GodmodeMod.Enabled then return end

        pcall(function()
            -- 1. Запрет состояния смерти каждый кадр
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

            -- 2. Восстановление HP
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end

            -- 3. Убираем возможность касания у частей тела (блокируем урон через Touch)
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanTouch then
                    part.CanTouch = false
                end
            end
        end)
    end)
end

-- hookfunction — перехват TakeDamage (работает в Synapse X, Wave и др.)
local function tryHookTakeDamage(char)
    pcall(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if hookfunction and newcclosure then
            local orig = hum.TakeDamage
            hookfunction(orig, newcclosure(function(self, amount)
                if GodmodeMod.Enabled and self == hum then return end
                return orig(self, amount)
            end))
        end
    end)
end

local function onCharacter(char)
    task.wait(0.5)
    attachGodmode(char)
    tryHookTakeDamage(char)
end

if player.Character then
    task.spawn(onCharacter, player.Character)
end

player.CharacterAdded:Connect(onCharacter)

return GodmodeMod
