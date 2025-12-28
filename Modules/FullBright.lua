-- FullBright Module
local FullBright = {}

if not _G.FullBrightExecuted then
    _G.FullBrightExecuted = true
    _G.FullBrightEnabled = false

    local Lighting = game:GetService("Lighting")

    -- Сохраняем оригинальные значения один раз
    _G.FullBrightOriginalSettings = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        GlobalShadows = Lighting.GlobalShadows,
        Ambient = Lighting.Ambient
    }

    function FullBright.SetEnabled(state)
        _G.FullBrightEnabled = state
        if state then
            -- Включаем FullBright
            Lighting.Brightness = 1
            Lighting.ClockTime = 12
            Lighting.FogEnd = 100000 -- очень далеко
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(178,178,178)
        else
            -- Возвращаем оригинальные значения
            local orig = _G.FullBrightOriginalSettings
            Lighting.Brightness = orig.Brightness
            Lighting.ClockTime = orig.ClockTime
            Lighting.FogEnd = orig.FogEnd
            Lighting.GlobalShadows = orig.GlobalShadows
            Lighting.Ambient = orig.Ambient
        end
    end
end

return FullBright
