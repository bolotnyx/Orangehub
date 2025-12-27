local ESPModule = {
    Enabled = false
}

-- Игнорируем технический мусор
local ignoreList = {"ProximityAttachment", "TouchInterest", "Attachment", "Model", "Part"}

local function createESP(item)
    -- Если это техническая деталь из списка игнора - выходим
    if table.find(ignoreList, item.Name) then return end
    if item:FindFirstChild("ESP_Highlight") then return end

    -- Определяем цвет
    local espColor = Color3.fromRGB(255, 165, 0) -- По умолчанию оранжевый (ресурсы)
    
    -- Если это монстр (Wolf, Bunny и т.д.) - делаем красным
    if item:FindFirstChildOfClass("Humanoid") or item.Name:find("Wolf") or item.Name:find("Bunny") then
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

    -- Текст (Billboard)
    local b = Instance.new("BillboardGui")
    b.Name = "ESP_Billboard"
    b.Size = UDim2.new(0, 80, 0, 20)
    b.AlwaysOnTop = true
    b.StudsOffset = Vector3.new(0, 3, 0) -- Поднимаем надпись выше
    
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

-- Функция сканирования
local function scan()
    if not ESPModule.Enabled then return end
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        -- Подсвечиваем всё, что имеет осмысленное название и не в игноре
        if obj:IsA("Model") or obj:IsA("BasePart") then
            -- Проверяем, не пустая ли это модель и нет ли её в игноре
            if obj.Name:len() > 3 and not table.find(ignoreList, obj.Name) then
                -- Подсвечиваем только то, что является либо мобом, либо ресурсом (Журнал, Ягода, Wolf и т.д.)
                local n = obj.Name
                if n:find("Wolf") or n:find("Bunny") or n:find("Журнал") or n:find("Ягода") or n:find("руда") or n:find("Alpha") then
                    createESP(obj)
                end
            end
        end
    end
end

-- Цикл
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
