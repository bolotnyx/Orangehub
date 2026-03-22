-- [[ ORANGE HUB V4 - GODMODE (ForceField) ]]
local Players = game:GetService("Players")
local player  = Players.LocalPlayer

local GodmodeMod = { Enabled = false }

local function removeForceField(char)
    local ff = char and char:FindFirstChildOfClass("ForceField")
    if ff then ff:Destroy() end
end

local function addForceField(char)
    if not char then return end
    removeForceField(char) -- убираем дубликат если был
    local ff = Instance.new("ForceField")
    ff.Visible = false
    ff.Parent = char
end

local function applyState(enabled)
    local char = player.Character
    if not char then return end
    if enabled then
        addForceField(char)
    else
        removeForceField(char)
    end
end

-- При смене персонажа восстанавливаем ForceField если godmode включён
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if GodmodeMod.Enabled then
        addForceField(char)
    end
end)

-- Обёртка над Enabled чтобы реагировать на изменение тоггла
local meta = getmetatable(GodmodeMod) or {}
setmetatable(GodmodeMod, {
    __newindex = function(t, k, v)
        rawset(t, k, v)
        if k == "Enabled" then
            applyState(v)
        end
    end
})

return GodmodeMod
