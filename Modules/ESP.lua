local ESPModule = {
    Enabled = false,
    Boxes = true,
    Names = true
}

local LP = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- Функция для отрисовки ESP на одном игроке
local function createESP(player)
    local box = Instance.new("Frame")
    local nameTag = Instance.new("TextLabel")
    local drawing = Instance.new("ScreenGui", game.CoreGui)
    drawing.Name = "ESP_" .. player.Name

    -- Настройка бокса
    box.BackgroundTransparency = 1
    box.BorderColor3 = Color3.fromRGB(255, 165, 0) -- Оранжевый стиль OrangeHub
    box.BorderSizePixel = 2
    box.Visible = false
    box.Parent = drawing

    -- Настройка ника
    nameTag.BackgroundTransparency = 1
    nameTag.TextColor3 = Color3.new(1, 1, 1)
    nameTag.Font = Enum.Font.GothamBold
    nameTag.TextSize = 12
    nameTag.Visible = false
    nameTag.Parent = drawing

    local connection
    connection = RunService.RenderStep:Connect(function()
        if not ESPModule.Enabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            box.Visible = false
            nameTag.Visible = false
            if not player.Parent then connection:Disconnect() drawing:Destroy() end
            return
        end

        local root = player.Character.HumanoidRootPart
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)

        if onScreen then
            -- Рассчитываем размер квадрата в зависимости от дистанции
            local size = (Camera.CFrame.Position - root.Position).Magnitude
            local scale = (1 / size) * 1000
            
            if ESPModule.Boxes then
                box.Visible = true
                box.Size = UDim2.new(0, scale * 1.5, 0, scale * 2)
                box.Position = UDim2.new(0, pos.X - box.Size.X.Offset / 2, 0, pos.Y - box.Size.Y.Offset / 2)
            else
                box.Visible = false
            end

            if ESPModule.Names then
                nameTag.Visible = true
                nameTag.Text = player.Name .. " [" .. math.floor(size) .. "m]"
                nameTag.Position = UDim2.new(0, pos.X, 0, pos.Y - (box.Size.Y.Offset / 2) - 15)
            else
                nameTag.Visible = false
            end
        else
            box.Visible = false
            nameTag.Visible = false
        end
    end)
end

-- Следим за новыми игроками
for _, p in ipairs(game.Players:GetPlayers()) do
    if p ~= LP then createESP(p) end
end
game.Players.PlayerAdded:Connect(function(p)
    if p ~= LP then createESP(p) end
end)

return ESPModule
