-- [[ ORANGE HUB V4 - GODMODE (ULTIMATE) ]]
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local player     = Players.LocalPlayer

local GodmodeMod = { Enabled = false }

local heartbeatConn = nil

-- ── 1. ForceField — блокирует TakeDamage() ───────────────────────────────────────
local function setForceField(char, state)
    if not char then return end
    local existing = char:FindFirstChildOfClass("ForceField")
    if state and not existing then
        local ff = Instance.new("ForceField")
        ff.Visible = false
        ff.Parent = char
    elseif not state and existing then
        existing:Destroy()
    end
end

-- ── 2. __namecall hook — перехватывает TakeDamage и Fire на уровне движка ────────
local namecallHooked = false
local function hookNamecall()
    if namecallHooked then return end
    if not (getrawmetatable and setreadonly and getnamecallmethod and newcclosure) then return end
    pcall(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local oldNamecall = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if GodmodeMod.Enabled and method == "TakeDamage" then
                pcall(function()
                    local char = player.Character
                    if char and self == char:FindFirstChildOfClass("Humanoid") then
                        return -- Блокируем
                    end
                end)
                local char = player.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and rawequal(self, hum) then
                        return -- Не передаём вызов дальше
                    end
                end
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
        namecallHooked = true
    end)
end

-- ── 3. Heartbeat — восстанавливаем HP каждый кадр как резерв ─────────────────────
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

-- ── Инициализация ─────────────────────────────────────────────────────────────────
hookNamecall()

local function onCharacter(char)
    task.wait(0.3)
    attachHeartbeat(char)
    if GodmodeMod.Enabled then
        setForceField(char, true)
    end
end

if player.Character then task.spawn(onCharacter, player.Character) end
player.CharacterAdded:Connect(onCharacter)

-- ── Реакция на включение/выключение тоггла ────────────────────────────────────────
local origEnabled = GodmodeMod.Enabled
setmetatable(GodmodeMod, {
    __newindex = function(t, k, v)
        rawset(t, k, v)
        if k == "Enabled" then
            pcall(function()
                local char = player.Character
                setForceField(char, v)
                if not v then
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        pcall(function()
                            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                        end)
                    end
                end
            end)
        end
    end
})

return GodmodeMod
