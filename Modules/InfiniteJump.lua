-- InfiniteJump.lua
local InfiniteJumpEnabled = false
local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local Humanoid = Player.Character and Player.Character:WaitForChild("Humanoid")

-- Функция для включения и выключения Infinite Jump
local function toggleInfiniteJump(state)
    InfiniteJumpEnabled = state
end

-- Подключение к событию прыжка
UIS.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        Humanoid:Move(Vector3.new(0, 50, 0))  -- Этот код активирует прыжок
    end
end)

-- Возвращаем функции для управления состоянием Infinite Jump
return {
    SetState = toggleInfiniteJump,
    GetState = function() return InfiniteJumpEnabled end
}
