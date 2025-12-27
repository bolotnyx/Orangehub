local ESPModule = {
    Enabled = false
}

-- Функция проверки: является ли объект чем-то важным?
local function isImportant(obj)
    -- Если имя уже в списке известных
    local targets = {"Berry", "Stick", "Stone", "Mushroom", "Wood", "Monster", "Chest"}
    if table.find(targets, obj.Name) then return true end

    -- Умная проверка: если в объекте есть ClickDetector или ProximityPrompt (значит можно нажать)
    if obj:FindFirstChildWhichIsA("ClickDetector") or obj:FindFirstChildWhichIsA("ProximityPrompt") then
        return true
    end
    
    -- Если это модель и у неё есть имя, отличное от "Model" или "Part"
    if obj:IsA("Model") and obj.Name ~= "Model" and obj.Name ~= "Workspace" then
        -- Игнорируем игрока
        if game.Players:GetPlayerFromCharacter(obj) then return false end
        return true
    end

    return false
end

local function createESP(item)
    if item:FindFirstChild("ESP_Highlight") then return end

    local h = Instance.new("Highlight")
    h.Name = "ESP_Highlight"
    h.FillColor = Color3.fromRGB(255, 165, 0)
    h.OutlineColor = Color3.new(1, 1, 1)
    h.FillTransparency = 0.4
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = item

    local b = Instance.new("BillboardGui")
    b.Name = "ESP_Billboard"
    b.Size = UDim2.new(0, 100, 0, 30)
    b.AlwaysOnTop = true
    b.StudsOffset = Vector3.new(0, 3, 0)
    
    local l = Instance.new("TextLabel", b)
    l.Size = UDim2.new(1, 0, 1, 0)
    l.Text = item.Name
    l.TextColor3 = Color3.new(1, 1, 1)
    l.BackgroundTransparency = 1
    l.TextScaled = true
    l.Font = Enum.Font.GothamBold
    
    b.Parent = item
end

-- Цикл сканирования мира
task.spawn(function()
    while task.wait(3) do -- Раз в 3 секунды, чтобы не лагало на телефоне
        if ESPModule.Enabled then
            for _, obj in ipairs(workspace:GetChildren()) do
                -- Проверяем объекты в корне workspace
                if isImportant(obj) then
                    createESP(obj)
                end
            end
        else
            -- Удаляем всё при выключении
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name == "ESP_Highlight" or obj.Name == "ESP_Billboard" then
                    obj:Destroy()
                end
            end
        end
    end
end)

return ESPModule
