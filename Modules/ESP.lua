local ESP = { Enabled = false }

local function applyESP(obj, color)
    if not obj:FindFirstChild("OrangeHighlight") then
        local h = Instance.new("Highlight")
        h.Name = "OrangeHighlight"
        h.FillColor = color
        h.OutlineColor = Color3.new(1,1,1)
        h.FillTransparency = 0.5
        h.Parent = obj
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    if not ESP.Enabled then 
        -- Удаляем ESP, если выключено
        for _, v in ipairs(workspace:GetDescendants()) do
            if v.Name == "OrangeHighlight" then v:Destroy() end
        end
        return 
    end

    for _, v in ipairs(workspace:GetChildren()) do
        -- Подсветка Волков/Врагов (Красный)
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name ~= LP.Name then
            applyESP(v, Color3.new(1, 0, 0))
        -- Подсветка Брёвен (Оранжевый)
        elseif v.Name == "Log" then
            applyESP(v, Color3.new(1, 0.5, 0))
        end
    end
end)

return ESP
