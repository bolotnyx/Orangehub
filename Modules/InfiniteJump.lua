local InfiniteJump = {}
InfiniteJump.Enabled = false

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- Храним connection, чтобы отключать
local jumpConnection = nil

-- Функция, которая срабатывает на JumpRequest
local function onJump()
    if not InfiniteJump.Enabled then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        -- Принудительно ставим состояние прыжка
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

-- Устанавливаем состояние: true = включить, false = выключить
function InfiniteJump.SetState(state)
    InfiniteJump.Enabled = state

    if state then
        -- Если включаем и connection ещё нет
        if not jumpConnection then
            jumpConnection = UIS.JumpRequest:Connect(onJump)
        end
    else
        -- Если выключаем и connection есть
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
    end
end

-- Авто-подключение для текущего состояния
if InfiniteJump.Enabled and not jumpConnection then
    jumpConnection = UIS.JumpRequest:Connect(onJump)
end

return InfiniteJump
