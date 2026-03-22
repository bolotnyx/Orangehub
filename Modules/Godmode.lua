-- [[ ORANGE HUB V4 - GODMODE (DELTA COMPATIBLE) ]]
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local GodmodeMod = { Enabled = false }

local heartbeatConn = nil
local metatableHooked = false

-- ── Метатаблица: перехватывает изменение Health с ЛЮБОГО источника (включая сервер) ──
local function hookMetatable()
    if metatableHooked then return end
    if not (getrawmetatable and setreadonly and newcclosure) then return end

    pcall(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)

        local oldNewIndex = mt.__newindex
        mt.__newindex = newcclosure(function(self, key, value)
            -- Блокируем снижение HP только для нашего персонажа
            if GodmodeMod.Enabled and key == "Health" and type(value) == "number" then
                pcall(function()
                    local char = player.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum and rawequal(self, hum) and value < hum.MaxHealth then
                            return -- Отменяем урон
                        end
                    end
                end)
                -- Проверяем снова после pcall (Lua не поддерживает ранний return из pcall)
                local char = player.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and rawequal(self, hum) and value < hum.MaxHealth then
                        return
                    end
                end
            end
            return oldNewIndex(self, key, value)
        end)

        setreadonly(mt, true)
        metatableHooked = true
    end)
end

-- ── Heartbeat: дополнительный слой — восстановление HP + Dead state ──────────────
local function attachHeartbeat(char)
    if heartbeatConn then pcall(function() heartbeatConn:Disconnect() end) end

    local hum = char:WaitForChild("Humanoid", 10)
    if not hum then return end

    pcall(function() hum.BreakJointsOnDeath = false end)

    heartbeatConn = RunService.Heartbeat:Connect(function()
        if not GodmodeMod.Enabled then return end
        pcall(function()
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end)
    end)
end

-- ── hookfunction: перехват TakeDamage (Delta поддерживает) ───────────────────────
local function hookTakeDamage(char)
    pcall(function()
        local hum = char:WaitForChild("Humanoid", 5)
        if not hum then return end
        if not (hookfunction and newcclosure) then return end

        local orig = hum.TakeDamage
        hookfunction(orig, newcclosure(function(self, amount)
            if GodmodeMod.Enabled then return end
            return orig(self, amount)
        end))
    end)
end

-- ── Инициализация ─────────────────────────────────────────────────────────────────
hookMetatable() -- Один раз для всей сессии

local function onCharacter(char)
    task.wait(0.3)
    attachHeartbeat(char)
    hookTakeDamage(char)
end

if player.Character then
    task.spawn(onCharacter, player.Character)
end

player.CharacterAdded:Connect(onCharacter)

return GodmodeMod
