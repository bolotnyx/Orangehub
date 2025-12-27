local ESPModule = {
    Enabled = false
}

-- ПОЛНЫЙ СПИСОК ИСКЛЮЧЕНИЙ (то, что НЕ подсвечиваем)
local ignoreList = {
    "ProximityAttachment", "TouchInterest", "Attachment", "Model", "Part",
    "wolf spawner", "wolf respawner", "wolf head", "bunny burrow", "Burrow",
    "Wolf Spawn", "Alpha Wolf Spawn", "Bear Spawn", "Any Wolf Spawn", 
    "Wolf Spawn No Respawn", "Alpha Wolf Spawn No Respawn", "Bear Spawn No Respawn"
}

local function createESP(item)
    -- Проверка по списку исключений
    local nameLower = item.Name:lower()
    for _, ignore in ipairs(ignoreList) do
        if nameLower == ignore:lower() or nameLower:find(ignore:lower()) then 
            return 
        end
    end
    
    if item:FindFirstChild("ESP_Highlight") then return end

    local espColor = Color3.fromRGB(255, 165, 0) -- Оранжевый (Ресурсы)
    
    -- КАТЕГОРИЯ: ВРАГИ (Красный цвет)
    local isEnemy = item.Name:find("Wolf") or 
                    item.Name:find("Bunny") or 
                    item.Name:find("Cultist") or 
                    item.Name:find("Bear") or 
                    item.Name:find("Alpha") or
                    item.Name:find("Культист") or
                    item.Name:find("Медведь") or
                    item:FindFirstChildOfClass("Humanoid")

    if isEnemy then
        espColor = Color3.fromRGB(255, 50, 50)
    end

    -- Подсветка (Highlight)
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
    b.Size = UDim2.new(0, 100, 0, 25)
    b.AlwaysOnTop = true
    b.StudsOffset = Vector3.new(0, 3.5, 0)
    
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
            
            -- Проверяем, является ли объект важным (Враг или Ресурс)
            local isTarget = n:find("Wolf") or n:find("Bunny") or n:find("Cultist") or 
                             n:find("Bear") or n:find("Культист") or n:find("Медведь") or
                             n:find("Журнал") or n:find("Ягода") or n:find("руда")

            if isTarget then
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
            -- Удаление при выключении
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name == "ESP_Highlight" or obj.Name == "ESP_Billboard" then
                    obj:Destroy()
                end
            end
        end
    end
end)

return ESPModule
