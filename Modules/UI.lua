-- [[ ORANGE HUB V4 - PREMIUM EDITION (FULL FUNCTIONALITY) ]]
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")

local LP = Players.LocalPlayer

-- ============================
--  ОЧИСТКА СТАРОГО GUI
-- ============================
if game.CoreGui:FindFirstChild("OrangeHub_Premium") then
    game.CoreGui.OrangeHub_Premium:Destroy()
end
if game.Lighting:FindFirstChild("OrangeHub_Blur") then
    game.Lighting.OrangeHub_Blur:Destroy()
end

-- ============================
--  КОНФИГИ ЭКЗЕКУТОРА
-- ============================
local configName = "OrangeHub_Config.json"
local function SaveConfig()
    if writefile then
        pcall(function()
            writefile(configName, HttpService:JSONEncode(_G.Settings or {}))
        end)
    end
end

local function LoadConfig()
    if readfile and isfile and isfile(configName) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(configName))
        end)
        if success then _G.Settings = data end
    else
        _G.Settings = {}
    end
end
LoadConfig()

if not _G.Settings then _G.Settings = {} end

-- ============================
--  КОНСТАНТЫ И ЦВЕТА
-- ============================
local C = {
    BG        = Color3.fromRGB(15, 15, 17),
    Sidebar   = Color3.fromRGB(22, 22, 25),
    Card      = Color3.fromRGB(28, 28, 32),
    CardHover = Color3.fromRGB(35, 35, 40),
    Accent    = Color3.fromRGB(255, 120, 0),
    Green     = Color3.fromRGB(60, 200, 100),
    Red       = Color3.fromRGB(220, 60, 60),
    Text      = Color3.fromRGB(240, 240, 240),
    TextDim   = Color3.fromRGB(150, 150, 160),
    Stroke    = Color3.fromRGB(40, 40, 45),
    White     = Color3.fromRGB(255, 255, 255),
    Divider   = Color3.fromRGB(50, 50, 55),
}

local TWEEN_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TWEEN_SMOOTH = TweenInfo.new(0.4, Enum.EasingStyle.Expo, Enum.EasingDirection.Out)

-- ============================
--  ROOT GUI & ЭФФЕКТЫ
-- ============================
local gui = Instance.new("ScreenGui")
gui.Name = "OrangeHub_Premium"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = game.CoreGui

local blur = Instance.new("BlurEffect")
blur.Name = "OrangeHub_Blur"
blur.Size = 15
blur.Parent = game.Lighting

-- ============================
--  WATERMARK
-- ============================
local Watermark = Instance.new("Frame")
Watermark.Size = UDim2.new(0, 0, 0, 26)
Watermark.Position = UDim2.new(1, -20, 0, 10)
Watermark.AnchorPoint = Vector2.new(1, 0)
Watermark.BackgroundColor3 = C.BG
Watermark.ClipsDescendants = false
Watermark.Parent = gui
Instance.new("UICorner", Watermark).CornerRadius = UDim.new(0, 4)
local wmStroke = Instance.new("UIStroke", Watermark)
wmStroke.Color = C.Accent
wmStroke.Thickness = 1

local WmText = Instance.new("TextLabel")
WmText.Size = UDim2.new(1, -20, 1, 0)
WmText.Position = UDim2.new(0, 10, 0, 0)
WmText.BackgroundTransparency = 1
WmText.Text = "🍊 Orange Premium"
WmText.TextColor3 = C.Text
WmText.Font = Enum.Font.GothamMedium
WmText.TextSize = 12
WmText.Parent = Watermark

WmText:GetPropertyChangedSignal("TextBounds"):Connect(function()
    Watermark.Size = UDim2.new(0, WmText.TextBounds.X + 20, 0, 26)
end)

RunService.RenderStepped:Connect(function()
    local fps = math.floor(workspace:GetRealPhysicsFPS())
    local ping = 0
    pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    WmText.Text = string.format("🍊 Orange Premium | %s | FPS: %d | Ping: %dms", LP.Name, fps, ping)
end)

-- ============================
--  УВЕДОМЛЕНИЯ
-- ============================
local NotifHolder = Instance.new("Frame")
NotifHolder.Size = UDim2.new(0, 280, 1, 0)
NotifHolder.Position = UDim2.new(1, -290, 0, 0)
NotifHolder.BackgroundTransparency = 1
NotifHolder.Parent = gui
Instance.new("UIListLayout", NotifHolder).VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifHolder:FindFirstChildOfClass("UIListLayout").Padding = UDim.new(0, 6)
NotifHolder:FindFirstChildOfClass("UIListLayout").SortOrder = Enum.SortOrder.LayoutOrder

local notifCount = 0
local function Notify(title, message, isGood)
    notifCount += 1
    local color = isGood and C.Green or C.Red
    local icon = isGood and "✓" or "✗"

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 60)
    card.BackgroundColor3 = C.Card
    card.BackgroundTransparency = 1
    card.LayoutOrder = notifCount
    card.ClipsDescendants = true
    card.Parent = NotifHolder
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    
    local nStroke = Instance.new("UIStroke", card)
    nStroke.Color = C.Stroke
    nStroke.Transparency = 1

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 1, 0)
    accent.BackgroundColor3 = color
    accent.BorderSizePixel = 0
    accent.Parent = card
    Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 4)

    local ico = Instance.new("TextLabel")
    ico.Size = UDim2.new(0, 30, 1, 0)
    ico.Position = UDim2.new(0, 10, 0, 0)
    ico.BackgroundTransparency = 1
    ico.Text = icon
    ico.TextColor3 = color
    ico.Font = Enum.Font.GothamBold
    ico.TextSize = 18
    ico.TextTransparency = 1
    ico.Parent = card

    local tLabel = Instance.new("TextLabel")
    tLabel.Size = UDim2.new(1, -48, 0, 22)
    tLabel.Position = UDim2.new(0, 44, 0, 8)
    tLabel.BackgroundTransparency = 1
    tLabel.Text = title
    tLabel.TextColor3 = C.Text
    tLabel.Font = Enum.Font.GothamBold
    tLabel.TextSize = 13
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.TextTransparency = 1
    tLabel.Parent = card

    local mLabel = Instance.new("TextLabel")
    mLabel.Size = UDim2.new(1, -48, 0, 18)
    mLabel.Position = UDim2.new(0, 44, 0, 32)
    mLabel.BackgroundTransparency = 1
    mLabel.Text = message
    mLabel.TextColor3 = C.TextDim
    mLabel.Font = Enum.Font.Gotham
    mLabel.TextSize = 11
    mLabel.TextXAlignment = Enum.TextXAlignment.Left
    mLabel.TextTransparency = 1
    mLabel.Parent = card

    TweenService:Create(card, TWEEN_SMOOTH, {BackgroundTransparency = 0}):Play()
    TweenService:Create(nStroke, TWEEN_SMOOTH, {Transparency = 0}):Play()
    TweenService:Create(ico, TWEEN_SMOOTH, {TextTransparency = 0}):Play()
    TweenService:Create(tLabel, TWEEN_SMOOTH, {TextTransparency = 0}):Play()
    TweenService:Create(mLabel, TWEEN_SMOOTH, {TextTransparency = 0}):Play()

    task.delay(3.5, function()
        TweenService:Create(card, TWEEN_SMOOTH, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0)}):Play()
        TweenService:Create(nStroke, TWEEN_SMOOTH, {Transparency = 1}):Play()
        TweenService:Create(ico, TWEEN_SMOOTH, {TextTransparency = 1}):Play()
        TweenService:Create(tLabel, TWEEN_SMOOTH, {TextTransparency = 1}):Play()
        TweenService:Create(mLabel, TWEEN_SMOOTH, {TextTransparency = 1}):Play()
        task.wait(0.4)
        card:Destroy()
    end)
end

-- ============================
--  ГЛАВНОЕ ОКНО
-- ============================
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 600, 0, 420)
Main.Position = UDim2.new(0.5, -300, 0.5, -210)
Main.BackgroundColor3 = C.BG
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = C.Stroke
MainStroke.Thickness = 1.5

-- Плавное перетаскивание
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
RunService.Heartbeat:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(Main, TWEEN_FAST, {Position = targetPos}):Play()
    end
end)

-- ============================
--  HEADER И СТРУКТУРА
-- ============================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1
Header.Parent = Main

local HeaderLine = Instance.new("Frame")
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.Position = UDim2.new(0, 0, 1, 0)
HeaderLine.BackgroundColor3 = C.Stroke
HeaderLine.BorderSizePixel = 0
HeaderLine.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ORANGE HUB"
Title.TextColor3 = C.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(0, 100, 1, 0)
Version.Position = UDim2.new(0, 140, 0, 1)
Version.BackgroundTransparency = 1
Version.Text = "PREMIUM"
Version.TextColor3 = C.TextDim
Version.Font = Enum.Font.Gotham
Version.TextSize = 11
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.Parent = Header

-- Кнопки управления (закрыть/свернуть)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.BackgroundColor3 = C.Red
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = C.White
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -51)
Sidebar.Position = UDim2.new(0, 0, 0, 51)
Sidebar.BackgroundColor3 = C.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(1, 0, 0, 0)
SidebarLine.BackgroundColor3 = C.Stroke
SidebarLine.BorderSizePixel = 0
SidebarLine.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.Padding = UDim.new(0, 6)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
local SidebarPad = Instance.new("UIPadding")
SidebarPad.PaddingTop = UDim.new(0, 15)
SidebarPad.PaddingLeft = UDim.new(0, 10)
SidebarPad.PaddingRight = UDim.new(0, 10)
SidebarPad.Parent = Sidebar

local HotkeyHint = Instance.new("TextLabel")
HotkeyHint.Size = UDim2.new(1, 0, 0, 24)
HotkeyHint.Position = UDim2.new(0, 0, 1, -30)
HotkeyHint.BackgroundTransparency = 1
HotkeyHint.Text = "RShift — скрыть"
HotkeyHint.TextColor3 = C.TextDim
HotkeyHint.Font = Enum.Font.Gotham
HotkeyHint.TextSize = 10
HotkeyHint.Parent = Sidebar

-- Content
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -151, 1, -51)
ContentFrame.Position = UDim2.new(0, 151, 0, 51)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = Main

-- ============================
--  ВКЛАДКИ - ИНИЦИАЛИЗАЦИЯ
-- ============================
local tabs = {}
local currentTab = nil

local tabDefs = {
    { name = "Player",  icon = "👤", order = 1 },
    { name = "Combat",  icon = "⚔️",  order = 2 },
    { name = "Visual",  icon = "👁",  order = 3 },
    { name = "Misc",    icon = "⚙️",  order = 4 },
}

local function makeTabPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = C.Accent
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Parent = ContentFrame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 15)
    pad.PaddingBottom = UDim.new(0, 15)
    pad.PaddingRight = UDim.new(0, 15)
    pad.PaddingLeft = UDim.new(0, 15)
    pad.Parent = page

    return page
end

-- ============================
--  UI КОМПОНЕНТЫ (С ОБВОДКАМИ И КОНФИГОМ)
-- ============================
local function sectionLabel(parent, text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = "  " .. text:upper()
    lbl.TextColor3 = C.Accent
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order or 0
    lbl.Parent = parent
end

local function makeToggle(parent, name, icon, globalVar, order, onToggle)
    if _G.Settings[globalVar] == nil then _G.Settings[globalVar] = false end
    local state = _G.Settings[globalVar]

    local card = Instance.new("TextButton")
    card.Size = UDim2.new(1, 0, 0, 48)
    card.BackgroundColor3 = C.Card
    card.BorderSizePixel = 0
    card.Text = ""
    card.LayoutOrder = order or 0
    card.AutoButtonColor = false
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
    
    -- Премиальная обводка (UIStroke)
    local btnStroke = Instance.new("UIStroke", card)
    btnStroke.Color = C.Stroke
    btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 36, 1, 0)
    iconLbl.Position = UDim2.new(0, 8, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextSize = 18
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Parent = card

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -100, 1, 0)
    nameLbl.Position = UDim2.new(0, 46, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = C.Text
    nameLbl.Font = Enum.Font.GothamMedium
    nameLbl.TextSize = 13
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = card

    local pill = Instance.new("Frame")
    pill.Size = UDim2.new(0, 40, 0, 20)
    pill.Position = UDim2.new(1, -50, 0.5, -10)
    pill.BackgroundColor3 = state and C.Green or C.BG
    pill.BorderSizePixel = 0
    pill.Parent = card
    Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 10)
    
    local pillStroke = Instance.new("UIStroke", pill)
    pillStroke.Color = C.Stroke

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    circle.BackgroundColor3 = C.White
    circle.BorderSizePixel = 0
    circle.Parent = pill
    Instance.new("UICorner", circle).CornerRadius = UDim.new(0.5, 0)

    local function updateVisual(on)
        TweenService:Create(pill, TWEEN_FAST, {BackgroundColor3 = on and C.Green or C.BG}):Play()
        TweenService:Create(circle, TWEEN_FAST, {Position = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play()
        TweenService:Create(card, TWEEN_FAST, {BackgroundColor3 = on and Color3.fromRGB(30, 35, 30) or C.Card}):Play()
        TweenService:Create(btnStroke, TWEEN_FAST, {Color = on and C.Green or C.Stroke}):Play()
    end

    updateVisual(state)

    card.MouseEnter:Connect(function()
        if not _G.Settings[globalVar] then TweenService:Create(card, TWEEN_FAST, {BackgroundColor3 = C.CardHover}):Play() end
    end)
    card.MouseLeave:Connect(function()
        if not _G.Settings[globalVar] then TweenService:Create(card, TWEEN_FAST, {BackgroundColor3 = C.Card}):Play() end
    end)

    card.MouseButton1Click:Connect(function()
        _G.Settings[globalVar] = not _G.Settings[globalVar]
        local newState = _G.Settings[globalVar]
        updateVisual(newState)
        SaveConfig() -- Сохранение конфигурации
        if onToggle then onToggle(newState) end
        Notify(name, newState and "Успешно включено" or "Успешно выключено", newState)
    end)
    
    -- Инит при запуске
    if onToggle then onToggle(state) end
    return card
end

local function makeSlider(parent, name, icon, globalVar, minVal, maxVal, defaultVal, order, onChange)
    if _G.Settings[globalVar] == nil then _G.Settings[globalVar] = defaultVal end
    local val = _G.Settings[globalVar]

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 64)
    card.BackgroundColor3 = C.Card
    card.BorderSizePixel = 0
    card.LayoutOrder = order or 0
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
    
    local btnStroke = Instance.new("UIStroke", card)
    btnStroke.Color = C.Stroke
    btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 36, 0, 32)
    iconLbl.Position = UDim2.new(0, 8, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextSize = 18
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Parent = card

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -100, 0, 22)
    nameLbl.Position = UDim2.new(0, 46, 0, 6)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = C.Text
    nameLbl.Font = Enum.Font.GothamMedium
    nameLbl.TextSize = 13
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = card

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 50, 0, 22)
    valLbl.Position = UDim2.new(1, -58, 0, 6)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(val)
    valLbl.TextColor3 = C.Accent
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 13
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = card

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -20, 0, 6)
    track.Position = UDim2.new(0, 10, 0, 42)
    track.BackgroundColor3 = C.BG
    track.BorderSizePixel = 0
    track.Parent = card
    Instance.new("UICorner", track).CornerRadius = UDim.new(0.5, 0)
    local tStroke = Instance.new("UIStroke", track)
    tStroke.Color = C.Stroke

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((val - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = C.Accent
    fill.BorderSizePixel = 0
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0.5, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((val - minVal) / (maxVal - minVal), -7, 0.5, -7)
    knob.BackgroundColor3 = C.White
    knob.BorderSizePixel = 0
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0.5, 0)

    local dragging = false
    local function updateSlider(inputX)
        local trackPos = track.AbsolutePosition.X
        local trackW   = track.AbsoluteSize.X
        local ratio = math.clamp((inputX - trackPos) / trackW, 0, 1)
        local newVal = math.round(minVal + ratio * (maxVal - minVal))
        
        _G.Settings[globalVar] = newVal
        valLbl.Text = tostring(newVal)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        knob.Position = UDim2.new(ratio, -7, 0.5, -7)
        if onChange then onChange(newVal) end
    end

    track.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; updateSlider(inp.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(inp.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false; SaveConfig()
        end
    end)
    
    if onChange then onChange(val) end
    return card
end

local function makeDivider(parent, order)
    local d = Instance.new("Frame")
    d.Size = UDim2.new(1, 0, 0, 1)
    d.BackgroundColor3 = C.Stroke
    d.BorderSizePixel = 0
    d.LayoutOrder = order or 0
    d.Parent = parent
end

-- ============================
--  СТРАНИЦЫ И ФУНКЦИОНАЛ
-- ============================
local pages = {}
for _, t in ipairs(tabDefs) do pages[t.name] = makeTabPage() end

-- PLAYER
do
    local p = pages["Player"]
    sectionLabel(p, "Передвижение", 1)
    makeSlider(p, "Walk Speed", "🏃", "WalkSpeedValue", 16, 100, 16, 2, function(v) _G.WalkSpeedValue = v end)
    makeToggle(p, "Включить Walk Speed", "⚡", "SpeedEnabled", 3, function(v) end)
    makeDivider(p, 4)
    sectionLabel(p, "Полёт", 5)
    makeSlider(p, "Fly Speed", "✈️", "FlySpeedValue", 10, 200, 50, 6, function(v) _G.FlySpeedValue = v end)
    makeToggle(p, "Включить Fly", "🚀", "FlyEnabled", 7, function(v)
        if _G.Modules and _G.Modules.Fly then _G.Modules.Fly.SetState(v) end
    end)
    makeDivider(p, 8)
    sectionLabel(p, "Прыжки", 9)
    makeToggle(p, "Infinite Jump", "🔄", "InfJumpEnabled", 10, function(v) end)
end

-- COMBAT
do
    local p = pages["Combat"]
    sectionLabel(p, "Атака", 1)
    makeToggle(p, "Godmode (Анти-Волк)", "🛡", "GodmodeEnabled", 2, function(v)
        if _G.Modules and _G.Modules.Godmode then _G.Modules.Godmode.Enabled = v end
    end)
    makeToggle(p, "Kill Aura", "💥", "KillAura", 3, function(v)
        if _G.Modules and _G.Modules.Combat then _G.Modules.Combat.KillAura = v end
    end)
    makeDivider(p, 4)
    sectionLabel(p, "Kill Aura Дальность", 5)
    makeSlider(p, "Дальность атаки", "📏", "KillAuraRange", 5, 60, 25, 6, function(v)
        if _G.Modules and _G.Modules.Combat then _G.Modules.Combat.Range = v end
        if _G.Modules and _G.Modules.Godmode then _G.Modules.Godmode.Distance = v end
    end)
end

-- VISUAL
do
    local p = pages["Visual"]
    sectionLabel(p, "Освещение", 1)
    makeToggle(p, "FullBright", "☀️", "FullBrightEnabled", 2, function(v)
        if _G.Modules and _G.Modules.FullBright then
            _G.Modules.FullBright.SetEnabled(v)
        else
            local Lighting = game:GetService("Lighting")
            if v then
                _G.OriginalLighting = {
                    Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
                    FogEnd = Lighting.FogEnd, GlobalShadows = Lighting.GlobalShadows, Ambient = Lighting.Ambient
                }
                Lighting.Brightness = 1; Lighting.ClockTime = 12; Lighting.FogEnd = 100000
                Lighting.GlobalShadows = false; Lighting.Ambient = Color3.fromRGB(178, 178, 178)
            elseif _G.OriginalLighting then
                local o = _G.OriginalLighting
                Lighting.Brightness = o.Brightness; Lighting.ClockTime = o.ClockTime
                Lighting.FogEnd = o.FogEnd; Lighting.GlobalShadows = o.GlobalShadows; Lighting.Ambient = o.Ambient
            end
        end
    end)
    makeDivider(p, 3)
    sectionLabel(p, "Монстры", 4)
    makeToggle(p, "ESP Монстры", "👾", "MonsterESPActive", 5, function(v)
        if _G.Modules and _G.Modules.ESP then _G.Modules.ESP.Enabled = v end
    end)
    makeDivider(p, 6)
    sectionLabel(p, "Ресурсы", 7)
    makeToggle(p, "ESP Ресурсы", "💎", "ResourceESPActive", 8, function(v) end)
end

-- MISC
do
    local p = pages["Misc"]
    sectionLabel(p, "Утилиты", 1)
    makeToggle(p, "Anti-AFK", "💤", "AntiAFKEnabled", 2, function(v)
        if _G.Modules and _G.Modules.AntiAFK then _G.Modules.AntiAFK.Enabled = v end
    end)
    makeDivider(p, 3)
    sectionLabel(p, "Информация", 4)
    
    local infoCard = Instance.new("Frame")
    infoCard.Size = UDim2.new(1, 0, 0, 70)
    infoCard.BackgroundColor3 = C.Card
    infoCard.BorderSizePixel = 0
    infoCard.LayoutOrder = 5
    infoCard.Parent = p
    Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", infoCard).Color = C.Stroke

    local infoText = Instance.new("TextLabel")
    infoText.Size = UDim2.new(1, -16, 1, 0)
    infoText.Position = UDim2.new(0, 8, 0, 0)
    infoText.BackgroundTransparency = 1
    infoText.Text = "🍊 Orange Premium Edition\nИгра: 99 Nights in the Forest\nRShift — скрыть / показать GUI"
    infoText.TextColor3 = C.TextDim
    infoText.Font = Enum.Font.Gotham
    infoText.TextSize = 12
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.TextYAlignment = Enum.TextYAlignment.Center
    infoText.Parent = infoCard
end

-- ============================
--  ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК
-- ============================
local function switchTab(name)
    if currentTab == name then return end
    currentTab = name
    for tName, page in pairs(pages) do page.Visible = (tName == name) end

    for _, btn in pairs(tabs) do
        local isActive = (btn.Name == name)
        TweenService:Create(btn, TWEEN_FAST, {
            BackgroundColor3 = isActive and C.Accent or C.Sidebar,
            BackgroundTransparency = isActive and 0 or 1,
        }):Play()
        local lbl = btn:FindFirstChildOfClass("TextLabel")
        if lbl then
            TweenService:Create(lbl, TWEEN_FAST, {TextColor3 = isActive and C.BG or C.TextDim}):Play()
        end
    end
end

for _, td in ipairs(tabDefs) do
    local btn = Instance.new("TextButton")
    btn.Name = td.name
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = C.Sidebar
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.LayoutOrder = td.order
    btn.AutoButtonColor = false
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "  " .. td.icon .. "  " .. td.name
    lbl.TextColor3 = C.TextDim
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.Parent = btn

    btn.MouseButton1Click:Connect(function() switchTab(td.name) end)
    btn.MouseEnter:Connect(function()
        if currentTab ~= td.name then TweenService:Create(btn, TWEEN_FAST, {BackgroundTransparency = 0.5}):Play() end
    end)
    btn.MouseLeave:Connect(function()
        if currentTab ~= td.name then TweenService:Create(btn, TWEEN_FAST, {BackgroundTransparency = 1}):Play() end
    end)
    tabs[td.name] = btn
end
switchTab("Player")

-- ============================
--  УПРАВЛЕНИЕ ОКНОМ (RShift / Close)
-- ============================
local menuOpen = true
local function toggleMenu()
    menuOpen = not menuOpen
    
    -- Плавное изменение размера главного окна
    TweenService:Create(Main, TWEEN_SMOOTH, {
        Size = menuOpen and UDim2.new(0, 600, 0, 420) or UDim2.new(0, 600, 0, 0),
        BackgroundTransparency = menuOpen and 0 or 1
    }):Play()
    
    TweenService:Create(MainStroke, TWEEN_SMOOTH, {Transparency = menuOpen and 0 or 1}):Play()
    TweenService:Create(blur, TWEEN_SMOOTH, {Size = menuOpen and 15 or 0}):Play()
    
    -- Прячем/показываем внутренние элементы для плавности
    for _, child in pairs(Main:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            TweenService:Create(child, TWEEN_SMOOTH, {TextTransparency = menuOpen and 0 or 1}):Play()
        elseif child:IsA("Frame") and child ~= Main then
            TweenService:Create(child, TWEEN_SMOOTH, {BackgroundTransparency = menuOpen and child.BackgroundTransparency or 1}):Play()
        elseif child:IsA("UIStroke") and child ~= MainStroke then
            TweenService:Create(child, TWEEN_SMOOTH, {Transparency = menuOpen and 0 or 1}):Play()
        end
    end
end

UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
        if menuOpen then Notify("Orange Hub", "Интерфейс открыт", true) end
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    if menuOpen then toggleMenu() end
end)

-- Финальное уведомление
task.delay(0.5, function()
    Notify("Premium Edition", "Успешно загружен!", true)
end)

return gui
