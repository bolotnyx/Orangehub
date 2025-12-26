-- ORANGE HUB | КРУТОЙ ИНТЕРФЕЙС С БОКОВОЙ ПАНЕЛЬЮ ДЛЯ 99 NIGHTS IN THE FOREST 🍊

pcall(function()
    if game.CoreGui:FindFirstChild("OrangeHubUI") then
        game.CoreGui:FindFirstChild("OrangeHubUI"):Destroy()
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "OrangeHubUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- Основное окно (компактный размер)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 600, 0, 450)
main.Position = UDim2.new(0.5, -300, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Заголовок
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "🍊 ORANGE HUB | 99 NIGHTS"
title.TextColor3 = Color3.fromRGB(255, 140, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BorderSizePixel = 0
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

-- Кнопка закрытия
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 40, 0, 40)
close.Position = UDim2.new(1, -45, 0, 0)
close.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.BorderSizePixel = 0
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Кнопка сворачивания
local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.new(0, 40, 0, 40)
minimize.Position = UDim2.new(1, -90, 0, 0)
minimize.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimize.Text = "−"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 24
minimize.BorderSizePixel = 0
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 8)

local minimized = false
local fullSize = main.Size
local minSize = UDim2.new(0, 600, 0, 40)

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        main.Size = minSize
        sidebar.Visible = false
        contentArea.Visible = false
        minimize.Text = "+"
        title.Text = "🍊 ORANGE HUB (свёрнуто)"
    else
        main.Size = fullSize
        sidebar.Visible = true
        contentArea.Visible = true
        minimize.Text = "−"
        title.Text = "🍊 ORANGE HUB | 99 NIGHTS"
    end
end)

-- Боковая панель (sidebar)
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 130, 1, -50)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
sidebar.BorderSizePixel = 0
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 12)

-- Основная область контента
local contentArea = Instance.new("Frame", main)
contentArea.Size = UDim2.new(1, -140, 1, -50)
contentArea.Position = UDim2.new(0, 130, 0, 40)
contentArea.BackgroundTransparency = 1

-- Категории
local categories = {
    {name = "⚔️ Бой", key = "Combat"},
    {name = "🌲 Фарм", key = "Farming"},
    {name = "👁️ Визуал", key = "Visual"},
    {name = "🏃 Игрок", key = "Player"},
    {name = "⚙️ Разное", key = "Misc"}
}

local categoryFrames = {}
local currentCategory = nil

for i, cat in ipairs(categories) do
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(1, -10, 0, 50)
    btn.Position = UDim2.new(0, 5, 0, (i-1)*55 + 10)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = cat.name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local frame = Instance.new("ScrollingFrame", contentArea)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.ScrollBarThickness = 6
    frame.Visible = false
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    categoryFrames[cat.key] = {frame = frame, btn = btn}

    btn.MouseButton1Click:Connect(function()
        if currentCategory then
            categoryFrames[currentCategory].frame.Visible = false
            categoryFrames[currentCategory].btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
        frame.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)  -- Активная категория оранжевая
        currentCategory = cat.key
    end)
end

-- Функция создания toggle-кнопки (с цветом вкл/выкл)
local function createToggle(parent, text, yPos, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 400, 0, 45)
    btn.Position = UDim2.new(0.5, -200, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = text .. " [ВЫКЛ]"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            btn.BackgroundColor3 = Color3.fromRGB(0, 140, 0)  -- Зелёный когда включено
            btn.Text = text .. " [ВКЛ]"
        else
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.Text = text .. " [ВЫКЛ]"
        end
        callback(enabled)
    end)

    parent.CanvasSize = UDim2.new(0, 0, 0, yPos + 60)
    return btn
end

-- Переменные функций (оставляем из предыдущих версий)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local godModeEnabled = false
local killAuraEnabled = false
local deerAuraEnabled = false
local treeAuraEnabled = false
local bringLogsEnabled = false
local espEnabled = false
local speedEnabled = false

-- (Функции God Mode, Kill Aura, Deer Aura, Tree Aura, Bring Logs, ESP, Speed — копируй из последней рабочей версии, только Bring Logs теперь безопасный телепорт без глюков)

-- Пример Bring Logs (без табличек и револьвера)
local function setBringLogs(state)
    bringLogsEnabled = state
    if bringLogsEnabled then
        spawn(function()
            while bringLogsEnabled do
                pcall(function()
                    local head = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
                    if head then
                        for _, item in pairs(workspace:GetDescendants()) do
                            if item:IsA("BasePart") and (item.Name:find("Log") or item.Name:find("Wood")) and not item.Name:find("Revolver") then
                                item.CanCollide = false
                                item.Anchored = false
                                item.CFrame = head.CFrame * CFrame.new(0, 3, 0)
                            end
                        end
                    end
                end)
                task.wait(0.4)
            end
        end)
    end
end

-- Создание кнопок по категориям
-- Бой
createToggle(categoryFrames.Combat.frame, "God Mode", 20, function(state) godModeEnabled = state -- добавить toggleGodMode(state) end)
createToggle(categoryFrames.Combat.frame, "Kill Aura", 80, function(state) -- toggleKillAura(state) end)
createToggle(categoryFrames.Combat.frame, "Deer Aura", 140, function(state) -- toggleDeerAura(state) end)

-- Фарм
createToggle(categoryFrames.Farming.frame, "Tree Aura", 20, function(state) -- toggleTreeAura(state) end)
createToggle(categoryFrames.Farming.frame, "Bring Logs", 80, function(state) setBringLogs(state) end)
-- createToggle(categoryFrames.Farming.frame, "Auto Grind Logs", 140, ...)

-- Визуал
createToggle(categoryFrames.Visual.frame, "Monster ESP", 20, function(state) -- toggleESP(state) end)

-- Игрок
createToggle(categoryFrames.Player.frame, "Speed Hack", 20, function(state) speedEnabled = state -- toggleSpeed(state) end)

-- Разное
createToggle(categoryFrames.Misc.frame, "Anti-AFK", 20, function(state) if state then enableAntiAFK() end end)

-- По умолчанию открываем первую категорию
categoryFrames.Combat.btn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
categoryFrames.Combat.frame.Visible = true
currentCategory = "Combat"

-- Respawn fix и остальные функции подключи как раньше
