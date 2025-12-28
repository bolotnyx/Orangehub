local FullBrightModule = {
    Enabled = false
}

local Lighting = game:GetService("Lighting")

-- Сохраняем стандартные настройки игры, чтобы вернуть их при выключении
local defaultAmbient = Lighting.Ambient
local defaultOutdoor = Lighting.OutdoorAmbient
local defaultBrightness = Lighting.Brightness

task.spawn(function()
    while task.wait(0.5) do
        if FullBrightModule.Enabled then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.Brightness = 2
        else
            -- Если выключили, возвращаем как было
            -- (Можно закомментировать, если хочешь, чтобы свет оставался)
            -- Lighting.Ambient = defaultAmbient
            -- Lighting.OutdoorAmbient = defaultOutdoor
            -- Lighting.Brightness = defaultBrightness
        end
    end
end)

return FullBrightModule
