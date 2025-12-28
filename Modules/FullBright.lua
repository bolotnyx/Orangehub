local FullBrightModule = {
    Enabled = false
}

local Lighting = game:GetService("Lighting")

-- Запускаем бесконечный цикл в отдельном потоке
task.spawn(function()
    while true do
        if FullBrightModule.Enabled then
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.GlobalShadows = false
            Lighting.ClockTime = 14 -- Всегда солнечный день
        end
        task.wait(0.5) -- Проверяем дважды в секунду, чтобы игра не вернула темноту
    end
end)

return FullBrightModule
