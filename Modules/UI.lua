-- [[ ORANGE HUB V4 - IMPROVED ]]
local LP = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

if game.CoreGui:FindFirstChild("OrangeHub_V4") then
    game.CoreGui.OrangeHub_V4:Destroy()
end

-- ============================
--  КОНСТАНТЫ / ЦВЕТА
-- ============================
local C = {
    BG        = Color3.fromRGB(18, 18, 20),
    Sidebar   = Color3.fromRGB(26, 26, 29),
    Card      = Color3.fromRGB(34, 34, 38),
    CardHover = Color3.fromRGB(42, 42, 48),
    Accent    = Color3.fromRGB(255, 140, 0),
    AccentDim = Color3.fromRGB(180, 90, 0),
    Green     = Color3.fromRGB(60, 200, 100),
    Red       = Color3.fromRGB(220, 60, 60),
    Text      = Color3.fromRGB(230, 230, 230),
    TextDim   = Color3.fromRGB(140, 140, 150),
    White     = Color3.fromRGB(255, 255, 255),
    Divider   = Color3.fromRGB(50, 50, 55),
}

local TWEEN_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_MED  = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_SLOW = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- ============================
--  ROOT GUI
-- ============================
local gui = Instance.new("ScreenGui")
gui.Name = "OrangeHub_V4"
gui.DisplayOrder = 100
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = game.CoreGui

-- ============================
--  УВЕДОМЛЕНИЯ
-- ============================
local NotifHolder = Instance.new("Frame")
NotifHolder.Size = UDim2.new(0, 280, 1, 0)
NotifHolder.Position = UDim2.new(1, -290, 0, 0)
NotifHolder.BackgroundTransparency = 1
NotifHolder.Parent = gui

local notifLayout = Instance.new("UIListLayout")
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.Padding = UDim.new(0, 6)
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.Parent = NotifHolder

local notifCount = 0
local function Notify(title, message, isGood)
    notifCount += 1
    local color = isGood and C.Green or C.Red
    local icon  = isGood and "✓" or "✗"

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 60)
    card.BackgroundColor3 = C.Card
    card.BackgroundTransparency = 1
    card.LayoutOrder = notifCount
    card.ClipsDescendants = true
    card.Parent = NotifHolder
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    -- Левая цветная полоса
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
    mLabel.Parent = card

    -- Появление + слайд слева
    card.Position = UDim2.new(0, 20, 0, 0)
    TweenService:Create(card, TWEEN_MED, {BackgroundTransparency = 0, Position = UDim2.new(0, 0, 0, 0)}):Play()

    task.delay(3.5, function()
        TweenService:Create(card, TWEEN_MED, {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
        }):Play()
        task.wait(0.3)
        card:Destroy()
    end)
end

-- ============================
--  ГЛАВНОЕ ОКНО
-- ============================
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 560, 0, 0)   -- стартует с 0 для анимации
Main.Position = UDim2.new(0.5, -280, 0.5, -200)
Main.BackgroundColor3 = C.BG
Main.BorderSizePixel = 0
Main.ClipsDescendants = false
Main.Parent = gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Анимация появления
TweenService:Create(Main, TWEEN_SLOW, {Size = UDim2.new(0, 560, 0, 400)}):Play()

-- Тень
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.Position = UDim2.new(0, -20, 0, -20)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6015897843"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.ZIndex = -1
shadow.Parent = Main

-- ============================
--  HEADER (drag-зона)
-- ============================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = C.Sidebar
Header.BorderSizePixel = 0
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

-- Заполняем нижнюю часть хедера (убираем нижнее скругление)
local HeaderFill = Instance.new("Frame")
HeaderFill.Size = UDim2.new(1, 0, 0.5, 0)
HeaderFill.Position = UDim2.new(0, 0, 0.5, 0)
HeaderFill.BackgroundColor3 = C.Sidebar
HeaderFill.BorderSizePixel = 0
HeaderFill.Parent = Header

local HeaderLogo = Instance.new("TextLabel")
HeaderLogo.Size = UDim2.new(0, 40, 1, 0)
HeaderLogo.Position = UDim2.new(0, 10, 0, 0)
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.Text = "🍊"
HeaderLogo.TextSize = 22
HeaderLogo.Font = Enum.Font.GothamBold
HeaderLogo.Parent = Header

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(0, 160, 0, 26)
HeaderTitle.Position = UDim2.new(0, 44, 0, 4)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "ORANGE HUB"
HeaderTitle.TextColor3 = C.Accent
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextSize = 18
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = Header

local HeaderVersion = Instance.new("TextLabel")
HeaderVersion.Size = UDim2.new(0, 120, 0, 16)
HeaderVersion.Position = UDim2.new(0, 44, 0, 28)
HeaderVersion.BackgroundTransparency = 1
HeaderVersion.Text = "v4.0 · ADVANCED"
HeaderVersion.TextColor3 = C.TextDim
HeaderVersion.Font = Enum.Font.Gotham
HeaderVersion.TextSize = 11
HeaderVersion.TextXAlignment = Enum.TextXAlignment.Left
HeaderVersion.Parent = Header

-- Кнопка закрыть
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = C.White
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TWEEN_FAST, {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TWEEN_FAST, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
end)

-- Кнопка свернуть
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -68, 0, 10)
MinBtn.BackgroundColor3 = C.Card
MinBtn.Text = "—"
MinBtn.TextColor3 = C.TextDim
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 13
MinBtn.BorderSizePixel = 0
MinBtn.AutoButtonColor = false
MinBtn.Parent = Header
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

MinBtn.MouseEnter:Connect(function()
    TweenService:Create(MinBtn, TWEEN_FAST, {BackgroundColor3 = C.CardHover}):Play()
end)
MinBtn.MouseLeave:Connect(function()
    TweenService:Create(MinBtn, TWEEN_FAST, {BackgroundColor3 = C.Card}):Play()
end)

-- ============================
--  DRAG (только через хедер)
-- ============================
do
    local dragging, dragStart, startPos = false, nil, nil

    Header.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = inp.Position
            startPos = Main.Position
        end
    end)

    UIS.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = inp.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- ============================
--  SIDEBAR
-- ============================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, -48)
Sidebar.Position = UDim2.new(0, 0, 0, 48)
Sidebar.BackgroundColor3 = C.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

-- Перекрываем верхнее скругление сайдбара
local SidebarTop = Instance.new("Frame")
SidebarTop.Size = UDim2.new(1, 0, 0, 6)
SidebarTop.BackgroundColor3 = C.Sidebar
SidebarTop.BorderSizePixel = 0
SidebarTop.ZIndex = 2
SidebarTop.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 4)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Parent = Sidebar

local SidebarPad = Instance.new("UIPadding")
SidebarPad.PaddingTop = UDim.new(0, 10)
SidebarPad.PaddingLeft = UDim.new(0, 8)
SidebarPad.PaddingRight = UDim.new(0, 8)
SidebarPad.Parent = Sidebar

-- Подсказка по хоткею внизу
local HotkeyHint = Instance.new("TextLabel")
HotkeyHint.Size = UDim2.new(1, 0, 0, 24)
HotkeyHint.Position = UDim2.new(0, 0, 1, -28)
HotkeyHint.BackgroundTransparency = 1
HotkeyHint.Text = "RShift — скрыть"
HotkeyHint.TextColor3 = C.TextDim
HotkeyHint.Font = Enum.Font.Gotham
HotkeyHint.TextSize = 10
HotkeyHint.Parent = Sidebar

-- ============================
--  КОНТЕНТ
-- ============================
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -148, 1, -56)
ContentFrame.Position = UDim2.new(0, 148, 0, 52)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = Main

-- ============================
--  СТРАНИЦЫ
-- ============================
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
    page.ScrollBarThickness = 3
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
    pad.PaddingTop    = UDim.new(0, 6)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.PaddingRight  = UDim.new(0, 12)
    pad.Parent = page

    return page
end

-- ============================
--  ПОСТРОИТЕЛИ ЭЛЕМЕНТОВ
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

local function makeDivider(parent, order)
    local d = Instance.new("Frame")
    d.Size = UDim2.new(1, 0, 0, 1)
    d.BackgroundColor3 = C.Divider
    d.BorderSizePixel = 0
    d.LayoutOrder = order or 0
    d.Parent = parent
end

local function makeToggle(parent, name, icon, globalVar, order, onToggle)
    local state = _G[globalVar] or false

    local card = Instance.new("TextButton")
    card.Size = UDim2.new(1, 0, 0, 48)
    card.BackgroundColor3 = state and Color3.fromRGB(30, 50, 35) or C.Card
    card.BorderSizePixel = 0
    card.Text = ""
    card.LayoutOrder = order or 0
    card.AutoButtonColor = false
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

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
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 13
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = card

    -- Pill (переключатель)
    local pill = Instance.new("Frame")
    pill.Size = UDim2.new(0, 42, 0, 22)
    pill.Position = UDim2.new(1, -52, 0.5, -11)
    pill.BackgroundColor3 = state and C.Green or C.CardHover
    pill.BorderSizePixel = 0
    pill.Parent = card
    Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 11)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = state
        and UDim2.new(1, -19, 0.5, -8)
        or  UDim2.new(0, 3, 0.5, -8)
    circle.BackgroundColor3 = C.White
    circle.BorderSizePixel = 0
    circle.Parent = pill
    Instance.new("UICorner", circle).CornerRadius = UDim.new(0.5, 0)

    local function updateVisual(on)
        TweenService:Create(pill, TWEEN_FAST, {
            BackgroundColor3 = on and C.Green or C.CardHover
        }):Play()
        TweenService:Create(circle, TWEEN_FAST, {
            Position = on
                and UDim2.new(1, -19, 0.5, -8)
                or  UDim2.new(0, 3, 0.5, -8)
        }):Play()
        TweenService:Create(card, TWEEN_FAST, {
            BackgroundColor3 = on and Color3.fromRGB(30, 50, 35) or C.Card
        }):Play()
    end

    card.MouseEnter:Connect(function()
        if not (_G[globalVar] or false) then
            TweenService:Create(card, TWEEN_FAST, {BackgroundColor3 = C.CardHover}):Play()
        end
    end)
    card.MouseLeave:Connect(function()
        if not (_G[globalVar] or false) then
            TweenService:Create(card, TWEEN_FAST, {BackgroundColor3 = C.Card}):Play()
        end
    end)

    card.MouseButton1Click:Connect(function()
        _G[globalVar] = not (_G[globalVar] or false)
        local newState = _G[globalVar]
        updateVisual(newState)
        if onToggle then onToggle(newState) end
        Notify(name, newState and "Включено" or "Выключено", newState)
    end)

    return card
end

local function makeSlider(parent, name, icon, globalVar, minVal, maxVal, defaultVal, order, onChange)
    _G[globalVar] = _G[globalVar] or defaultVal

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 64)
    card.BackgroundColor3 = C.Card
    card.BorderSizePixel = 0
    card.LayoutOrder = order or 0
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

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
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 13
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = card

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 50, 0, 22)
    valLbl.Position = UDim2.new(1, -58, 0, 6)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(defaultVal)
    valLbl.TextColor3 = C.Accent
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 13
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = card

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -20, 0, 6)
    track.Position = UDim2.new(0, 10, 0, 44)
    track.BackgroundColor3 = C.Divider
    track.BorderSizePixel = 0
    track.Parent = card
    Instance.new("UICorner", track).CornerRadius = UDim.new(0.5, 0)

    local initRatio = (defaultVal - minVal) / (maxVal - minVal)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(initRatio, 0, 1, 0)
    fill.BackgroundColor3 = C.Accent
    fill.BorderSizePixel = 0
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0.5, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(initRatio, -7, 0.5, -7)
    knob.BackgroundColor3 = C.White
    knob.BorderSizePixel = 0
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0.5, 0)

    local dragging = false

    local function updateSlider(inputX)
        local ratio = math.clamp((inputX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local val = math.round(minVal + ratio * (maxVal - minVal))
        _G[globalVar] = val
        valLbl.Text = tostring(val)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        knob.Position = UDim2.new(ratio, -7, 0.5, -7)
        if onChange then onChange(val) end
    end

    track.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(inp.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if dragging and (
            inp.UserInputType == Enum.UserInputType.MouseMovement
            or inp.UserInputType == Enum.UserInputType.Touch
        ) then
            updateSlider(inp.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return card
end

-- Новый элемент: кнопка действия
local function makeButton(parent, name, icon, order, onClick)
    local card = Instance.new("TextButton")
    card.Size = UDim2.new(1, 0, 0, 44)
    card.BackgroundColor3 = C.Card
    card.BorderSizePixel = 0
    card.Text = ""
    card.LayoutOrder = order or 0
    card.AutoButtonColor = false
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 36, 1, 0)
    iconLbl.Position = UDim2.new(0, 8, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextSize = 18
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Parent = card

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -60, 1, 0)
    nameLbl.Position = UDim2.new(0, 46, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = C.Text
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 13
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = card

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 24, 1, 0)
    arrow.Position = UDim2.new(1, -28, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "›"
    arrow.TextColor3 = C.AccentDim
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 20
    arrow.Parent = card

    card.MouseEnter:Connect(function()
        TweenService:Create(card, TWEEN_FAST, {BackgroundColor3 = C.CardHover}):Play()
        TweenService:Create(arrow, TWEEN_FAST, {TextColor3 = C.Accent}):Play()
    end)
    card.MouseLeave:Connect(function()
        TweenService:Create(card, TWEEN_FAST, {BackgroundColor3 = C.Card}):Play()
        TweenService:Create(arrow, TWEEN_FAST, {TextColor3 = C.AccentDim}):Play()
    end)
    card.MouseButton1Click:Connect(function()
        TweenService:Create(card, TWEEN_FAST, {BackgroundColor3 = C.AccentDim}):Play()
        task.delay(0.15, function()
            TweenService:Create(card, TWEEN_FAST, {BackgroundColor3 = C.CardHover}):Play()
        end)
        if onClick then onClick() end
    end)

    return card
end

-- ============================
--  СТРАНИЦЫ ВКЛАДОК
-- ============================
local pages = {}
for _, t in ipairs(tabDefs) do
    pages[t.name] = makeTabPage()
end

-- ============================
--  PLAYER
-- ============================
do
    local p = pages["Player"]
    sectionLabel(p, "Передвижение", 1)
    makeSlider(p, "Walk Speed", "🏃", "WalkSpeedValue", 16, 100, 16, 2, function(v)
        _G.WalkSpeedValue = v
    end)
    makeToggle(p, "Включить Walk Speed", "⚡", "SpeedEnabled", 3, function(v)
        -- логика в WalkSpeed.lua
    end)
    makeDivider(p, 4)
    sectionLabel(p, "Полёт", 5)
    makeSlider(p, "Fly Speed", "✈️", "FlySpeedValue", 10, 200, 50, 6, function(v)
        _G.FlySpeedValue = v
    end)
    makeToggle(p, "Включить Fly", "🚀", "FlyEnabled", 7, function(v)
        if _G.Modules and _G.Modules.Fly then
            _G.Modules.Fly.SetState(v)
        end
    end)
    makeDivider(p, 8)
    sectionLabel(p, "Прыжки", 9)
    makeToggle(p, "Infinite Jump", "🔄", "InfJumpEnabled", 10, function(v)
        -- логика в InfiniteJump.lua
    end)
end

-- ============================
--  COMBAT
-- ============================
do
    local p = pages["Combat"]
    sectionLabel(p, "Атака", 1)
    makeToggle(p, "Godmode (Анти-Волк)", "🛡", "GodmodeEnabled", 2, function(v)
        if _G.Modules and _G.Modules.Godmode then
            _G.Modules.Godmode.Enabled = v
        end
    end)
    makeToggle(p, "Kill Aura", "💥", "KillAura", 3, function(v)
        _G.KillAura = v
        if _G.Modules and _G.Modules.Combat then
            _G.Modules.Combat.KillAura = v
        end
    end)
    makeDivider(p, 4)
    sectionLabel(p, "Kill Aura Дальность", 5)
    makeSlider(p, "Дальность атаки", "📏", "KillAuraRange", 5, 60, 25, 6, function(v)
        _G.KillAuraRange = v
        if _G.Modules and _G.Modules.Combat then
            _G.Modules.Combat.Range = v
        end
        if _G.Modules and _G.Modules.Godmode then
            _G.Modules.Godmode.Distance = v
        end
    end)
end

-- ============================
--  VISUAL
-- ============================
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
                    Brightness    = Lighting.Brightness,
                    ClockTime     = Lighting.ClockTime,
                    FogEnd        = Lighting.FogEnd,
                    GlobalShadows = Lighting.GlobalShadows,
                    Ambient       = Lighting.Ambient,
                }
                Lighting.Brightness    = 1
                Lighting.ClockTime     = 12
                Lighting.FogEnd        = 100000
                Lighting.GlobalShadows = false
                Lighting.Ambient       = Color3.fromRGB(178, 178, 178)
            elseif _G.OriginalLighting then
                local o = _G.OriginalLighting
                Lighting.Brightness    = o.Brightness
                Lighting.ClockTime     = o.ClockTime
                Lighting.FogEnd        = o.FogEnd
                Lighting.GlobalShadows = o.GlobalShadows
                Lighting.Ambient       = o.Ambient
            end
        end
    end)
    makeDivider(p, 3)
    sectionLabel(p, "Монстры", 4)
    makeToggle(p, "ESP Монстры", "👾", "MonsterESPActive", 5, function(v)
        if _G.Modules and _G.Modules.ESP then
            _G.Modules.ESP.Enabled = v
        end
    end)
    makeDivider(p, 6)
    sectionLabel(p, "Ресурсы", 7)
    makeToggle(p, "ESP Ресурсы", "💎", "ResourceESPActive", 8, function(v)
        Notify("ESP Ресурсы", v and "Включён" or "Выключён", v)
    end)
end

-- ============================
--  MISC
-- ============================
do
    local p = pages["Misc"]
    sectionLabel(p, "Утилиты", 1)
    makeToggle(p, "Anti-AFK", "💤", "AntiAFKEnabled", 2, function(v)
        if _G.Modules and _G.Modules.AntiAFK then
            _G.Modules.AntiAFK.Enabled = v
        end
    end)

    makeDivider(p, 3)
    sectionLabel(p, "Действия", 4)
    makeButton(p, "Teleport to Spawn", "🏠", 5, function()
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
            if spawn then
                hrp.CFrame = spawn.CFrame + Vector3.new(0, 3, 0)
                Notify("Teleport", "Возрождение выполнено", true)
            else
                Notify("Teleport", "SpawnLocation не найден", false)
            end
        end
    end)

    makeDivider(p, 6)
    sectionLabel(p, "Информация", 7)

    local infoCard = Instance.new("Frame")
    infoCard.Size = UDim2.new(1, 0, 0, 70)
    infoCard.BackgroundColor3 = C.Card
    infoCard.BorderSizePixel = 0
    infoCard.LayoutOrder = 8
    infoCard.Parent = p
    Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 8)

    local infoText = Instance.new("TextLabel")
    infoText.Size = UDim2.new(1, -16, 1, 0)
    infoText.Position = UDim2.new(0, 8, 0, 0)
    infoText.BackgroundTransparency = 1
    infoText.Text = "🍊 Orange Hub V4\nИгра: 99 Nights in the Forest\nRShift — скрыть / показать GUI"
    infoText.TextColor3 = C.TextDim
    infoText.Font = Enum.Font.Gotham
    infoText.TextSize = 12
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.TextYAlignment = Enum.TextYAlignment.Center
    infoText.Parent = infoCard
end

-- ============================
--  ТАБ-КНОПКИ
-- ============================
local tabs = {}
local currentTab = nil

local function switchTab(name)
    if currentTab == name then return end
    currentTab = name

    for tName, page in pairs(pages) do
        page.Visible = (tName == name)
    end

    for tName, btn in pairs(tabs) do
        local active = (tName == name)
        TweenService:Create(btn, TWEEN_FAST, {
            BackgroundColor3     = active and C.Accent or Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = active and 0 or 1,
        }):Play()
        local lbl = btn:FindFirstChildOfClass("TextLabel")
        if lbl then
            TweenService:Create(lbl, TWEEN_FAST, {
                TextColor3 = active and C.BG or C.TextDim
            }):Play()
        end
    end
end

for _, td in ipairs(tabDefs) do
    local btn = Instance.new("TextButton")
    btn.Name = td.name
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.LayoutOrder = td.order
    btn.AutoButtonColor = false
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

    -- Иконка отдельно для правильного выравнивания
    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 28, 1, 0)
    iconLbl.Position = UDim2.new(0, 8, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = td.icon
    iconLbl.TextSize = 16
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.TextColor3 = C.TextDim
    iconLbl.Parent = btn

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -40, 1, 0)
    lbl.Position = UDim2.new(0, 38, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = td.name
    lbl.TextColor3 = C.TextDim
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = btn

    btn.MouseButton1Click:Connect(function() switchTab(td.name) end)
    btn.MouseEnter:Connect(function()
        if currentTab ~= td.name then
            TweenService:Create(btn, TWEEN_FAST, {BackgroundTransparency = 0.85}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if currentTab ~= td.name then
            TweenService:Create(btn, TWEEN_FAST, {BackgroundTransparency = 1}):Play()
        end
    end)

    tabs[td.name] = btn
end

switchTab("Player")

-- ============================
--  КНОПКИ ХЕДЕРА
-- ============================
local minimized = false

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetH = minimized and 48 or 400
    TweenService:Create(Main, TWEEN_MED, {Size = UDim2.new(0, 560, 0, targetH)}):Play()
    task.delay(0.05, function()
        Sidebar.Visible = not minimized
        ContentFrame.Visible = not minimized
    end)
    MinBtn.Text = minimized and "□" or "—"
end)

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(Main, TWEEN_MED, {Size = UDim2.new(0, 560, 0, 0)}):Play()
    task.delay(0.3, function()
        Main.Visible = false
        Main.Size = UDim2.new(0, 560, 0, 400)
    end)
end)

-- ============================
--  ГОРЯЧАЯ КЛАВИША (RSHIFT)
-- ============================
UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        if Main.Visible then
            TweenService:Create(Main, TWEEN_MED, {Size = UDim2.new(0, 560, 0, 0)}):Play()
            task.delay(0.3, function()
                Main.Visible = false
                Main.Size = UDim2.new(0, 560, 0, 400)
            end)
        else
            Main.Visible = true
            Main.Size = UDim2.new(0, 560, 0, 0)
            TweenService:Create(Main, TWEEN_SLOW, {Size = UDim2.new(0, 560, 0, 400)}):Play()
            Notify("Orange Hub", "GUI открыт", true)
        end
    end
end)

-- ============================
--  ФИНАЛЬНОЕ УВЕДОМЛЕНИЕ
-- ============================
task.delay(0.6, function()
    Notify("Orange Hub V4", "Успешно загружен!", true)
end)

return gui
