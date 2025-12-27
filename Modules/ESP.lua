local ESPModule = {
    Enabled = false
}

-- Игнорируем технические объекты и спавнеры
local ignoreList = {
    "ProximityAttachment", "TouchInterest", "Attachment", "Model", "Part",
    "wolf spawner", "wolf respawner", "wolf head", "bunny burrow", "Burrow"
}

local function createESP(item)
    -- Проверка на игнор-лист (учитываем регистр и пробелы)
    local nameLower = item.Name:lower()
    for _, ignore in ipairs(ignoreList) do
        if nameLower:find(ignore:lower()) then return end
    end
    
    if item:FindFirstChild("ESP_Highlight") then return end

    -- Определяем цвет
    local espColor = Color3.fromRGB(255, 165, 0) -- Оранжевый (Ресурсы)
    
    -- Определяем врагов (Красный)
    local isEnemy = item.Name:find("Wolf") or 
                    item.Name:find("Bunny") or 
                    item.Name:find("Cultist") or 
                    item.Name:find("Bear") or 
                    item.Name:find("Alpha") or
                    item:FindFirstChildOfClass("Humanoid")

    if isEnemy then
        espColor = Color3.fromRGB(255, 50, 50)
    end

    -- Подсветка
    local h = Instance.new("Highlight")
    h.Name = "ESP_Highlight"
    h.FillColor = espColor
    h.OutlineColor = Color3.new(1, 1, 1)
    h.FillTransparency = 0.5
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = item

    -- Текст
    local b = Instance.new("BillboardGui")
    b.Name = "ESP_Billboard"
    b.Size = UDim2.new(0, 80, 0, 20)
    b.AlwaysOnTop = true
    b.StudsOffset = Vector3.new(0, 3, 0)
    
    local l = Instance.new("TextLabel", b)
    l.Size = UDim2.new(1, 0, 1, 0)
    l.Text = item.Name
    l.TextColor3 = Color3.new(1, 1, 1)
    l.BackgroundTransparency = 1
    l.TextScaled = true
    l.Font = Enum.Font.GothamBold
    l.TextStrokeTransparency = 0.5
    l.Parent = b
    
    b.Parent = item
end

local function scan()
    if not ESPModule.Enabled then return end
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local n = obj.Name
            -- Важные объекты: монстры, ресурсы на русском и новые цели
            local isImportant = n:find("Wolf") or n:find("Bunny") or n:find("Журнал") or 
                                n:find("Ягода") or n:find("руда") or n:find("Alpha") or
                                n:find("Cultist") or n:find("Bear") or n:find("Медведь")

            if isImportant then
                createESP(obj)
            end
        end
    end
end

task.spawn(function()
    while task.wait(3) do
        if ESPModule.Enabled then
            scan()
        else
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name == "ESP_Highlight" or obj.Name == "ESP_Billboard" then
                    obj:Destroy()
                end
            end
        end
    end
end)

return ESPModule
