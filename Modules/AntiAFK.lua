local AntiAFKModule = {
    Enabled = false
}

local VirtualUser = game:GetService("VirtualUser")
local Player = game.Players.LocalPlayer

-- Подключаемся к событию бездействия (Idled)
Player.Idled:Connect(function()
    if AntiAFKModule.Enabled then
        -- Имитируем нажатие кнопки мыши, чтобы сбросить таймер AFK
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        warn("🍊 [Orange Hub]: Anti-AFK сработал, таймер сброшен!")
    end
end)

return AntiAFKModule
