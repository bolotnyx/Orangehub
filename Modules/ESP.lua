local ESPModule = {
    Enabled = false,
    ItemsEnabled = false,
    NPCEnabled = false
}

-- Названия из твоей игры (замени на актуальные, если нужно)
local teleportTargets = {"Stick", "Stone", "Mushroom", "Wood", "Berry"} -- Пример предметов
local AimbotTargets = {"Monster", "Zombie", "Bear"} -- Пример NPC

local function createItemESP(item)
    if not item:IsA("BasePart") and not item:IsA("Model") then return end
    
    -- Billboard (Текст)
    if not item:FindFirstChild("ESP_Billboard") then
        local billboard = Instance.new("BillboardGui", item)
        billboard.Name = "ESP_Billboard"
        billboard.Size = UDim2.new(0, 50, 0, 20)
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 2, 0)

        local label = Instance.new("TextLabel", billboard)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = item.Name
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 165, 0) -- Оранжевый
        label.TextStrokeTransparency = 0
        label.TextScaled = true
    end

    -- Highlight (Подсветка)
    if not item:FindFirstChild("ESP_Highlight") then
        local highlight = Instance.new("Highlight", item)
        highlight.Name = "ESP_Highlight"
        highlight.FillColor = Color3.fromRGB(255, 165, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
end

-- Функция очистки
local function clearESP(item)
    if item:FindFirstChild("ESP_Billboard") then item.ESP_Billboard:Destroy() end
    if item:FindFirstChild("ESP_Highlight") then item.ESP_Highlight:Destroy() end
end

-- Основной цикл переключения
task.spawn(function()
    while task.wait(1) do
        if ESPModule.Enabled then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if table.find(teleportTargets, obj.Name) or table.find(AimbotTargets, obj.Name) then
                    createItemESP(obj)
                end
            end
        else
            for _, obj in ipairs(workspace:GetDescendants()) do
                clearESP(obj)
            end
        end
    end
end)

return ESPModule
