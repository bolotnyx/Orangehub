local FullBrightModule = {
    Enabled = false
}

local Lighting = game:GetService("Lighting")

-- Сохраняем оригинальные настройки, чтобы можно было выключить
local origAmbient = Lighting.Ambient
local origBrightness = Lighting.Brightness
local origShadows = Lighting.GlobalShadows

task.spawn(function()
    while true do
        if FullBrightModule.Enabled then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false -- Убираем тени
            Lighting.ClockTime = 12 -- Всегда полдень
        else
            -- Если нужно, можно раскомментировать строки ниже для возврата к норме:
            -- Lighting.GlobalShadows = origShadows
        end
        task.wait(0.2) -- Частая проверка
    end
end)

return FullBrightModule
