local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

local PlayerFuncs = {
    AutoLog = false,
    AutoTree = false,
    LogBagType = 5 -- Вместимость мешка
}

-- Функция нажатия клавиш
local function press(key)
    VIM:SendKeyEvent(true, Enum.KeyCode[key], false, game)
    task.wait(0.05)
    VIM:SendKeyEvent(false, Enum.KeyCode[key], false, game)
end

-- Логика сбора логов (твой рабочий метод)
task.spawn(function()
    while true do
        task.wait(1)
        if PlayerFuncs.AutoLog and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local log = nil
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "Log" then log = v; break end
            end
            
            if log then
                LP.Character:PivotTo(log:GetPivot() * CFrame.new(0, 2, 0))
                task.wait(0.5)
                for i=1, PlayerFuncs.LogBagType do
                    press("F") press("E") task.wait(0.1)
                end
                LP.Character:PivotTo(CFrame.new(0, 10, 0)) -- К костру
            end
        end
    end
end)

return PlayerFuncs
