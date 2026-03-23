-- [[ ORANGE HUB V4 - PREMIUM UI ]]
local LP = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

if game.CoreGui:FindFirstChild("OrangeHub_V4") then
    game.CoreGui.OrangeHub_V4:Destroy()
end

-- ============================
--  ЦВЕТА
-- ============================
local C = {
    BG         = Color3.fromRGB(12, 12, 16),
    Sidebar    = Color3.fromRGB(18, 18, 24),
    Card       = Color3.fromRGB(26, 26, 34),
    CardHover  = Color3.fromRGB(36, 36, 46),
    CardActive = Color3.fromRGB(22, 40, 28),
    Accent     = Color3.fromRGB(255, 145, 0),
    AccentDim  = Color3.fromRGB(160, 80, 0),
    AccentGlow = Color3.fromRGB(255, 185, 60),
    Green      = Color3.fromRGB(50, 210, 100),
    Red        = Color3.fromRGB(220, 55, 55),
    Text       = Color3.fromRGB(235, 235, 240),
    TextDim    = Color3.fromRGB(110, 110, 130),
    White      = Color3.fromRGB(255, 255, 255),
    Divider    = Color3.fromRGB(38, 38, 50),
    Border     = Color3.fromRGB(55, 55, 72),
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
NotifHolder.Size = UDim2.new(0, 290, 1, 0)
NotifHolder.Position = UDim2.new(1, -300, 0, 0)
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

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 62)
    card.BackgroundColor3 = C.Card
    card.BackgroundTransparency = 1
    card.LayoutOrder = notifCount
    card.ClipsDescendants = true
    card.Position = UDim2.new(0, 16, 0, 0)
    card.Parent = NotifHolder
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Border
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = card

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 0.7, 0)
    accentBar.Position = UDim2.new(0, 0, 0.15, 0)
    accentBar.BackgroundColor3 = color
    accentBar.BorderSizePixel = 0
    accentBar.Parent = card
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0.5, 0)

    local ico = Instance.new("TextLabel")
    ico.Size = UDim2.new(0, 28, 1, 0)
    ico.Position = UDim2.new(0, 12, 0, 0)
    ico.BackgroundTransparency = 1
    ico.Text = isGood and "✓" or "✗"
    ico.TextColor3 = color
    ico.Font = Enum.Font.GothamBold
    ico.TextSize = 16
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

    TweenService:Create(card, TWEEN_MED, {
        BackgroundTransparency = 0,
        Position = UDim2.new(0, 0, 0, 0),
    }):Play()

    task.delay(3.5, function()
        TweenService:Create(card, TWEEN_MED, {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 16, 0, 0),
        }):Play()
        task.wait(0.32)
        card:Destroy()
    end)
end

-- ============================
--  ГЛАВНОЕ ОКНО
-- ============================
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 580, 0, 0)
Main.Position = UDim2.new(0.5, -290, 0.5, -205)
Main.BackgroundColor3 = C.BG
Main.BorderSizePixel = 0
Main.ClipsDescendants = false
Main.Parent = gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = C.Border
MainStroke.Thickness = 1
MainStroke.Transparency = 0.35
MainStroke.Parent = Main

TweenService:Create(Main, TWEEN_SLOW, {Size = UDim2.new(0, 580, 0, 410)}):Play()

-- Тень
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 90, 1, 90)
shadow.Position = UDim2.new(0, -45, 0, -35)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6015897843"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.25
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.ZIndex = -1
shadow.Parent = Main

-- ============================
--  HEADER
-- ============================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundColor3 = C.Sidebar
Header.BorderSizePixel = 0
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local HeaderFill = Instance.new("Frame")
HeaderFill.Size = UDim2.new(1, 0, 0.5, 0)
HeaderFill.Position = UDim2.new(0, 0, 0.5, 0)
HeaderFill.BackgroundColor3 = C.Sidebar
HeaderFill.BorderSizePixel = 0
HeaderFill.Parent = Header

-- Градиентный разделитель под хедером
local HeaderDivider = Instance.new("Frame")
HeaderDivider.Size = UDim2.new(1, 0, 0, 1)
HeaderDivider.Position = UDim2.new(0, 0, 1, -1)
HeaderDivider.BackgroundColor3 = C.Accent
HeaderDivider.BorderSizePixel = 0
HeaderDivider.Parent = Header

local DivGrad = Instance.new("UIGradient")
DivGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(0,0,0)),
    ColorSequenceKeypoint.new(0.25, C.Accent),
    ColorSequenceKeypoint.new(0.6,  C.AccentGlow),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(0,0,0)),
})
DivGrad.Parent = HeaderDivider

-- Логотип в квадрате с градиентом
local LogoBG = Instance.new("Frame")
LogoBG.Size = UDim2.new(0, 34, 0, 34)
LogoBG.Position = UDim2.new(0, 12, 0.5, -17)
LogoBG.BackgroundColor3 = C.Accent
LogoBG.BorderSizePixel = 0
LogoBG.Parent = Header
Instance.new("UICorner", LogoBG).CornerRadius = UDim.new(0, 8)

local LogoGrad = Instance.new("UIGradient")
LogoGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.AccentGlow),
    ColorSequenceKeypoint.new(1, C.Accent),
})
LogoGrad.Rotation = 135
LogoGrad.Parent = LogoBG

local HeaderLogo = Instance.new("TextLabel")
HeaderLogo.Size = UDim2.new(1, 0, 1, 0)
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.Text = "🍊"
HeaderLogo.TextSize = 18
HeaderLogo.Font = Enum.Font.GothamBold
HeaderLogo.Parent = LogoBG

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(0, 180, 0, 24)
HeaderTitle.Position = UDim2.new(0, 54, 0, 5)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "ORANGE HUB"
HeaderTitle.TextColor3 = C.Text
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextSize = 17
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = Header

local TitleGrad = Instance.new("UIGradient")
TitleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   C.AccentGlow),
    ColorSequenceKeypoint.new(0.45, C.Accent),
    ColorSequenceKeypoint.new(1,   C.Text),
})
TitleGrad.Parent = HeaderTitle

local HeaderVersion = Instance.new("TextLabel")
HeaderVersion.Size = UDim2.new(0, 160, 0, 16)
HeaderVersion.Position = UDim2.new(0, 54, 0, 28)
HeaderVersion.BackgroundTransparency = 1
HeaderVersion.Text = "v4.0  ·  ADVANCED"
HeaderVersion.TextColor3 = C.TextDim
HeaderVersion.Font = Enum.Font.Gotham
HeaderVersion.TextSize = 11
HeaderVersion.TextXAlignment = Enum.TextXAlignment.Left
HeaderVersion.Parent = Header

-- Кнопка закрыть
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = C.White
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TWEEN_FAST, {BackgroundColor3 = Color3.fromRGB(240, 60, 60)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TWEEN_FAST, {BackgroundColor3 = Color3.fromRGB(180, 40, 40)}):Play()
end)

-- Кнопка свернуть
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -70, 0.5, -14)
MinBtn.BackgroundColor3 = C.Card
MinBtn.Text = "—"
MinBtn.TextColor3 = C.TextDim
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 13
MinBtn.BorderSizePixel = 0
MinBtn.AutoButtonColor = false
MinBtn.Parent = Header
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local MinStroke = Instance.new("UIStroke")
MinStroke.Color = C.Border
MinStroke.Thickness = 1
MinStroke.Parent = MinBtn

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
            dragging  = true
            dragStart = inp.Position
            startPos  = Main.Position
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local d = inp.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
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
Sidebar.Size = UDim2.new(0, 150, 1, -52)
Sidebar.Position = UDim2.new(0, 0, 0, 52)
Sidebar.BackgroundColor3 = C.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

-- Правая граница сайдбара
local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(1, -1, 0, 0)
SidebarLine.BackgroundColor3 = C.Divider
SidebarLine.BorderSizePixel = 0
SidebarLine.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 3)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Parent = Sidebar

local SidebarPad = Instance.new("UIPadding")
SidebarPad.PaddingTop   = UDim.new(0, 12)
SidebarPad.PaddingLeft  = UDim.new(0, 10)
SidebarPad.PaddingRight = UDim.new(0, 10)
SidebarPad.Parent = Sidebar

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
ContentFrame.Size = UDim2.new(1, -160, 1, -60)
ContentFrame.Position = UDim2.new(0, 158, 0, 56)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = Main

-- ============================
--  ВКЛАДКИ - ОПРЕДЕЛЕНИЕ
-- ============================
local tabDefs = {
    { name = "Player", icon = "👤", order = 1 },
    { name = "Combat", icon = "⚔️",  order = 2 },
    { name = "Visual", icon = "👁",  order = 3 },
    { name = "Misc",   icon = "⚙️",  order = 4 },
}

-- ============================
--  СТРАНИЦА ВКЛАДКИ
-- ============================
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
    pad.PaddingBottom = UDim.new(0, 12)
    pad.PaddingRight  = UDim.new(0, 12)
    pad.Parent = page

    return page
end

-- ============================
--  ПОСТРОИТЕЛИ ЭЛЕМЕНТОВ
-- ============================
local function sectionLabel(parent, text, order)
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1, 0, 0, 26)
    wrap.BackgroundTransparency = 1
    wrap.LayoutOrder = order or 0
    wrap.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -8, 1, 0)
    lbl.Position = UDim2.new(0, 4, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text:upper()
    lbl.TextColor3 = C.Accent
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = wrap

    -- Линия после заголовка
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, -1)
    line.BackgroundColor3 = C.Divider
    line.BorderSizePixel = 0
    line.Parent = wrap

    local lineGrad = Instance.new("UIGradient")
    lineGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.Accent),
        ColorSequenceKeypoint.new(0.4, C.Divider),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0)),
    })
    lineGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    lineGrad.Parent = line
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
    card.Size = UDim2.new(1, 0, 0, 50)
    card.BackgroundColor3 = state and C.CardActive or C.Card
    card.BorderSizePixel = 0
    card.Text = ""
    card.LayoutOrder = order or 0
    card.AutoButtonColor = false
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local cStroke = Instance.new("UIStroke")
    cStroke.Color = C.Border
    cStroke.Thickness = 1
    cStroke.Transparency = 0.55
    cStroke.Parent = card

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 36, 1, 0)
    iconLbl.Position = UDim2.new(0, 8, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextSize = 18
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Parent = card

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -108, 1, 0)
    nameLbl.Position = UDim2.new(0, 46, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = C.Text
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 13
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = card

    -- Pill
    local pill = Instance.new("Frame")
    pill.Size = UDim2.new(0, 44, 0, 24)
    pill.Position = UDim2.new(1, -54, 0.5, -12)
    pill.BackgroundColor3 = state and C.Green or C.CardHover
    pill.BorderSizePixel = 0
    pill.Parent = card
    Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 12)

    local pillStroke = Instance.new("UIStroke")
    pillStroke.Color = state and C.Green or C.Border
    pillStroke.Thickness = 1
    pillStroke.Transparency = 0.5
    pillStroke.Parent = pill

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = state
        and UDim2.new(1, -21, 0.5, -9)
        or  UDim2.new(0, 3, 0.5, -9)
    circle.BackgroundColor3 = C.White
    circle.BorderSizePixel = 0
    circle.Parent = pill
    Instance.new("UICorner", circle).CornerRadius = UDim.new(0.5, 0)

    local function updateVisual(on)
        TweenService:Create(pill, TWEEN_FAST, {
            BackgroundColor3 = on and C.Green or C.CardHover
        }):Play()
        TweenService:Create(pillStroke, TWEEN_FAST, {
            Color = on and C.Green or C.Border
        }):Play()
        TweenService:Create(circle, TWEEN_FAST, {
            Position = on
                and UDim2.new(1, -21, 0.5, -9)
                or  UDim2.new(0, 3, 0.5, -9)
        }):Play()
        TweenService:Create(card, TWEEN_FAST, {
            BackgroundColor3 = on and C.CardActive or C.Card
        }):Play()
        TweenService:Create(cStroke, TWEEN_FAST, {
            Color = on and C.Green or C.Border,
            Transparency = on and 0.6 or 0.55
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
    card.Size = UDim2.new(1, 0, 0, 66)
    card.BackgroundColor3 = C.Card
    card.BorderSizePixel = 0
    card.LayoutOrder = order or 0
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local cStroke = Instance.new("UIStroke")
    cStroke.Color = C.Border
    cStroke.Thickness = 1
    cStroke.Transparency = 0.55
    cStroke.Parent = card

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 36, 0, 34)
    iconLbl.Position = UDim2.new(0, 8, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextSize = 18
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Parent = card

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -110, 0, 24)
    nameLbl.Position = UDim2.new(0, 46, 0, 6)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = C.Text
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 13
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = card

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 56, 0, 24)
    valLbl.Position = UDim2.new(1, -62, 0, 6)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(defaultVal)
    valLbl.TextColor3 = C.Accent
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 13
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = card

    -- Трек
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -22, 0, 6)
    track.Position = UDim2.new(0, 11, 0, 46)
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

    -- Градиент на заполнении
    local fillGrad = Instance.new("UIGradient")
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.Accent),
        ColorSequenceKeypoint.new(1, C.AccentGlow),
    })
    fillGrad.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(initRatio, -7, 0.5, -7)
    knob.BackgroundColor3 = C.White
    knob.BorderSizePixel = 0
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0.5, 0)

    local knobStroke = Instance.new("UIStroke")
    knobStroke.Color = C.Accent
    knobStroke.Thickness = 2
    knobStroke.Parent = knob

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

local function makeButton(parent, name, icon, order, onClick)
    local card = Instance.new("TextButton")
    card.Size = UDim2.new(1, 0, 0, 46)
    card.BackgroundColor3 = C.Card
    card.BorderSizePixel = 0
    card.Text = ""
    card.LayoutOrder = order or 0
    card.AutoButtonColor = false
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local cStroke = Instance.new("UIStroke")
    cStroke.Color = C.Border
    cStroke.Thickness = 1
    cStroke.Transparency = 0.55
    cStroke.Parent = card

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 36, 1, 0)
    iconLbl.Position = UDim2.new(0, 8, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextSize = 18
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Parent = card

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -70, 1, 0)
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
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "›"
    arrow.TextColor3 = C.AccentDim
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 22
    arrow.Parent = card

    card.MouseEnter:Connect(function()
        TweenService:Create(card, TWEEN_FAST, {BackgroundColor3 = C.CardHover}):Play()
        TweenService:Create(cStroke, TWEEN_FAST, {Color = C.Accent, Transparency = 0.6}):Play()
        TweenService:Create(arrow, TWEEN_FAST, {TextColor3 = C.Accent}):Play()
    end)
    card.MouseLeave:Connect(function()
        TweenService:Create(card, TWEEN_FAST, {BackgroundColor3 = C.Card}):Play()
        TweenService:Create(cStroke, TWEEN_FAST, {Color = C.Border, Transparency = 0.55}):Play()
        TweenService:Create(arrow, TWEEN_FAST, {TextColor3 = C.AccentDim}):Play()
    end)
    card.MouseButton1Click:Connect(function()
        TweenService:Create(card, TWEEN_FAST, {BackgroundColor3 = Color3.fromRGB(255, 145, 0)}):Play()
        task.delay(0.15, function()
            TweenService:Create(card, TWEEN_FAST, {BackgroundColor3 = C.CardHover}):Play()
        end)
        if onClick then onClick() end
    end)

    return card
end

-- ============================
--  СОЗДАЁМ СТРАНИЦЫ
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
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
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
    infoCard.Size = UDim2.new(1, 0, 0, 72)
    infoCard.BackgroundColor3 = C.Card
    infoCard.BorderSizePixel = 0
    infoCard.LayoutOrder = 8
    infoCard.Parent = p
    Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 8)

    local infoStroke = Instance.new("UIStroke")
    infoStroke.Color = C.Border
    infoStroke.Thickness = 1
    infoStroke.Transparency = 0.55
    infoStroke.Parent = infoCard

    local infoText = Instance.new("TextLabel")
    infoText.Size = UDim2.new(1, -16, 1, 0)
    infoText.Position = UDim2.new(0, 10, 0, 0)
    infoText.BackgroundTransparency = 1
    infoText.Text = "🍊  Orange Hub V4\nИгра: 99 Nights in the Forest\nRShift — скрыть / показать GUI"
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
local tabIndicators = {}
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
            BackgroundColor3       = active and C.Accent or Color3.fromRGB(0,0,0),
            BackgroundTransparency = active and 0.88 or 1,
        }):Play()
        local lbl = btn:FindFirstChild("TabLabel")
        local ico = btn:FindFirstChild("TabIcon")
        if lbl then
            TweenService:Create(lbl, TWEEN_FAST, {
                TextColor3 = active and C.Text or C.TextDim
            }):Play()
        end
        if ico then
            TweenService:Create(ico, TWEEN_FAST, {
                TextColor3 = active and C.Accent or C.TextDim
            }):Play()
        end
        local ind = tabIndicators[tName]
        if ind then
            TweenService:Create(ind, TWEEN_FAST, {
                BackgroundTransparency = active and 0 or 1
            }):Play()
        end
    end
end

for _, td in ipairs(tabDefs) do
    local btn = Instance.new("TextButton")
    btn.Name = td.name
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = C.Accent
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.LayoutOrder = td.order
    btn.AutoButtonColor = false
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    -- Левая полоса-индикатор
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 0.55, 0)
    indicator.Position = UDim2.new(0, 0, 0.225, 0)
    indicator.BackgroundColor3 = C.Accent
    indicator.BorderSizePixel = 0
    indicator.BackgroundTransparency = 1
    indicator.Parent = btn
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0.5, 0)
    tabIndicators[td.name] = indicator

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Name = "TabIcon"
    iconLbl.Size = UDim2.new(0, 24, 1, 0)
    iconLbl.Position = UDim2.new(0, 12, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = td.icon
    iconLbl.TextSize = 15
    iconLbl.TextColor3 = C.TextDim
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Parent = btn

    local lbl = Instance.new("TextLabel")
    lbl.Name = "TabLabel"
    lbl.Size = UDim2.new(1, -42, 1, 0)
    lbl.Position = UDim2.new(0, 40, 0, 0)
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
            TweenService:Create(btn, TWEEN_FAST, {BackgroundTransparency = 0.93}):Play()
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
--  ЛОГИКА КНОПОК ХЕДЕРА
-- ============================
local minimized = false

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetH = minimized and 52 or 410
    TweenService:Create(Main, TWEEN_MED, {Size = UDim2.new(0, 580, 0, targetH)}):Play()
    task.delay(0.05, function()
        Sidebar.Visible      = not minimized
        ContentFrame.Visible = not minimized
    end)
    MinBtn.Text = minimized and "□" or "—"
end)

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(Main, TWEEN_MED, {Size = UDim2.new(0, 580, 0, 0)}):Play()
    task.delay(0.3, function()
        Main.Visible = false
        Main.Size = UDim2.new(0, 580, 0, 410)
    end)
end)

-- ============================
--  ГОРЯЧАЯ КЛАВИША (RSHIFT)
-- ============================
UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        if Main.Visible then
            TweenService:Create(Main, TWEEN_MED, {Size = UDim2.new(0, 580, 0, 0)}):Play()
            task.delay(0.3, function()
                Main.Visible = false
                Main.Size = UDim2.new(0, 580, 0, 410)
            end)
        else
            Main.Visible = true
            Main.Size = UDim2.new(0, 580, 0, 0)
            TweenService:Create(Main, TWEEN_SLOW, {Size = UDim2.new(0, 580, 0, 410)}):Play()
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
