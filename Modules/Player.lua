local PlayerModule = {
    AutoTree = false,
    AutoLog = false
}

local LP = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

-- Функция клика
local function click()
    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    task.wait(0.1)
    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

-- Цикл работы
task.spawn(function()
    while true do
        task.wait(0.3)
        
        -- Логика авто-рубки деревьев
        if PlayerModule.AutoTree and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            for _, trunk in pairs(workspace:GetDescendants()) do
                if trunk.Name == "Trunk" and trunk.Parent and trunk.Parent.Name == "Small Tree" then
                    if not PlayerModule.AutoTree then break end
                    
                    -- Телепорт к дереву
                    LP.Character:PivotTo(trunk.CFrame * CFrame.new(0, 2, 0))
                    
                    -- Рубим дерево
                    while PlayerModule.AutoTree and trunk.Parent and trunk.Parent.Name == "Small Tree" do
                        click()
                        task.wait(0.3)
                    end
                end
            end
        end
    end
end)

print("🍊 [OrangeHub]: Player Module Logic Loaded")
return PlayerModule
