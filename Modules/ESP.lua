local ESPModule = {
    Enabled = false
}

-- Твой уточненный список имен
local targets = {
    "log", "Log", "CrashingUFOs", "Berry", "Stick", "Stone", "Mushroom", 
    "Flint", "Apple", "Rock", "Chest", "Box"
}

local function createESP(item)
    -- Не создаем дубликаты
    if item:FindFirstChild("ESP_Highlight") then return end

    -- Определяем, что подсвечивать (модель или деталь)
    local adornee = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")) or item
    if not adornee then return end

    -- Подсветка (Highlight)
    local h = Instance.new("Highlight")
    h.Name = "ESP_Highlight"
    h.FillColor = Color3.fromRGB(255, 165, 0)
    h.OutlineColor = Color3.new(1, 1, 1)
    h.FillTransparency = 0.4
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = item

    -- Надпись (Billboard)
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
    l.Parent = b
    
    b.Parent = item
end

-- Функция сканирования
local function scan()
    if not ESPModule.Enabled then return end

    -- Используем GetDescendants, чтобы найти предметы в глубоких папках
    for _, obj in ipairs(workspace:GetDescendants()) do
        -- 1. Проверка по списку имен (для логов, костров и т.д.)
        if table.find(targets, obj.Name) then
            createESP(obj)
        end

        -- 2. Проверка на мобов (если это модель с ХП и не игрок)
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            if not game.Players:GetPlayerFromCharacter(obj) then
                createESP(obj)
            end
        end
        
        -- 3. Проверка на кликабельные предметы (на всякий случай)
        if obj:FindFirstChildWhichIsA("ProximityPrompt") or obj:FindFirstChildWhichIsA("ClickDetector") then
            createESP(obj)
        end
    end
end

-- Цикл работы
task.spawn(function()
    while task.wait(3) do
        if ESPModule.Enabled then
            scan()
        else
            -- Чистим всё при выключении
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name == "ESP_Highlight" or obj.Name == "ESP_Billboard" then
                    obj:Destroy()
                end
            end
        end
    end
end)

return ESPModule
