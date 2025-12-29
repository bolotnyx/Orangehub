-- InfiniteJump.lua
local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local Humanoid = Player.Character and Player.Character:WaitForChild("Humanoid")

local InfJumpEnabled = false

-- Функция для включения/выключения инфинит джампа
local function toggleInfiniteJump(state)
    InfJumpEnabled = state
end

-- Подключение к событию прыжка
UIS.JumpRequest:Connect(function()
    if InfJumpEnabled and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        Humanoid:Move(Vector3.new(0, 50, 0))  -- Этот код активирует прыжок
    end
end)

-- Возвращаем функцию для управления инфинит джампом
return {
    SetState = toggleInfiniteJump,
    GetState = function() return InfJumpEnabled end
}
