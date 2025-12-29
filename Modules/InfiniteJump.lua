-- [[ ORANGE HUB - INFINITE JUMP MODULE ]]
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer

UIS.JumpRequest:Connect(function()
    if _G.InfJumpEnabled then
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if hum then
            -- Принудительно размораживаем перед прыжком, если застрял
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

print("🚀 Infinite Jump Loaded")
return {Loaded = true}
