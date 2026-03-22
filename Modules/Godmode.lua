-- [[ ORANGE HUB V4 - GODMODE (MULTI-METHOD) ]]
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local GodmodeMod = { Enabled = false }

local steppedConn = nil
local hooked = false

local function attachGodmode(char)
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end

    local hum = char:WaitForChild("Humanoid", 10)
    if not hum then return end

    -- ── Метод 1: Запрещаем Dead-стейт ──────────────────────────────
    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)

    -- ── Метод 2: Перехват TakeDamage (если executor поддерживает) ───
    if not hooked and hookfunction and newcclosure then
        local orig = hum.TakeDamage
        hookfunction(orig, newcclosure(function(self, amount)
            if GodmodeMod.Enabled then return end
            return orig(self, amount)
        end))
        hooked = true
    end

    -- ── Метод 3: RenderStepped — восстанавливаем HP каждый кадр ────
    -- RenderStepped выполняется ДО рендера, это самая быстрая петля
    local ok, err = pcall(function()
        steppedConn = RunService.RenderStepped:Connect(function()
            if not GodmodeMod.Enabled then return end
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            if hum.Health ~= hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end)
    end)

    -- Если RenderStepped недоступен (серверный контекст), используем Heartbeat
    if not ok then
        steppedConn = RunService.Heartbeat:Connect(function()
            if not GodmodeMod.Enabled then return end
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            if hum.Health ~= hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end)
    end
end

if player.Character then
    task.spawn(function() attachGodmode(player.Character) end)
end

player.CharacterAdded:Connect(function(char)
    hooked = false
    task.wait(0.3)
    attachGodmode(char)
end)

return GodmodeMod
