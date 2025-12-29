-- [[ ORANGE HUB - PREMIER UI SYSTEM ]]
local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- ПРОВЕРКА НА ПОВТОРНЫЙ ЗАПУСК
if CoreGui:FindFirstChild("OrangeHubUI") then
    CoreGui:FindFirstChild("OrangeHubUI"):Destroy()
end

-- [[ НАСТРОЙКИ ТЕМЫ ]]
local Theme = {
    Main = Color3.fromRGB(255, 140, 0),    -- Яркий оранжевый
    Dark = Color3.fromRGB(15, 15, 15),     -- Фон меню
    LightDark = Color3.fromRGB(25, 25, 25), -- Фон кнопок
    Text = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(255, 165, 0)
}

-- [[ ОСНОВНЫЕ ОБЪЕКТЫ ]]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "OrangeHubUI"
ScreenGui.ResetOnSpawn = false

-- УВЕДОМЛЕНИЯ
local NotifContainer = Instance.new("Frame", ScreenGui)
NotifContainer.Size = UDim2.new(0, 250, 1, 0)
NotifContainer.Position = UDim2.new(1, -260, 0, 10)
NotifContainer.BackgroundTransparency = 1

local function Notify(title, text, duration)
    local f = Instance.new("Frame", NotifContainer)
    f.Size = UDim2.new(1, 0, 0, 60)
    f.BackgroundColor3 = Theme.Dark
    f.BackgroundTransparency = 0.2
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    
    local line = Instance.new("Frame", f)
    line.Size = UDim2.new(1, 0, 0, 3)
    line.Position = UDim2.new(0, 0, 1, -3)
    line.BackgroundColor3 = Theme.Main
    
    local tl = Instance.new("TextLabel", f)
    tl.Size = UDim2.new(1, -10, 1, 0)
    tl.Position = UDim2.new(0, 10, 0, 0)
    tl.Text = "🍊 " .. title:upper() .. "\n" .. text
    tl.TextColor3 = Theme.Text
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 13
    tl.BackgroundTransparency = 1
    tl.TextXAlignment = Enum.TextXAlignment.Left

    f.Position = UDim2.new(1.5, 0, 0, #NotifContainer:GetChildren() * 65)
    f:TweenPosition(UDim2.new(0, 0, 0, f.Position.Y.Offset), "Out", "Back", 0.4, true)
    
    line:TweenSize(UDim2.new(0, 0, 0, 3), "In", "Linear", duration or 3)
    task.delay(duration or 3, function()
        f:TweenPosition(UDim2.new(1.5, 0, 0, f.Position.Y.Offset), "In", "Quad", 0.4, true)
        task.wait(0.4)
        f:Destroy()
    end)
end

-- ГЛАВНОЕ ОКНО
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 550, 0, 400)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.BackgroundColor3 = Theme.Dark
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 10)

-- БОКОВАЯ ПАНЕЛЬ (КАТЕГОРИИ)
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 150, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
SideBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", SideBar)
Title.Text = "ORANGE HUB"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.TextColor3 = Theme.Main
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.BackgroundTransparency = 1

local CatList = Instance.new("UIListLayout", SideBar)
CatList.Padding = UDim.new(0, 5)

-- КОНТЕЙНЕР ДЛЯ СТРАНИЦ
local PageFolder = Instance.new("Folder", MainFrame)

local function CreateCategory(name, icon)
    local CatBtn = Instance.new("TextButton", SideBar)
    CatBtn.Size = UDim2.new(1, -10, 0, 35)
    CatBtn.BackgroundColor3 = Color3.new(1,1,1)
    CatBtn.BackgroundTransparency = 1
    CatBtn.Text = "  " .. icon .. "  " .. name
    CatBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    CatBtn.Font = Enum.Font.GothamBold
    CatBtn.TextSize = 14
    CatBtn.TextXAlignment = Enum.TextXAlignment.Left

    local Page = Instance.new("ScrollingFrame", PageFolder)
    Page.Size = UDim2.new(1, -160, 1, -20)
    Page.Position = UDim2.new(0, 160, 0, 10)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)

    CatBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(PageFolder:GetChildren()) do p.Visible = false end
        for _, b in pairs(SideBar:GetChildren()) do 
            if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150, 150, 150) end 
        end
        Page.Visible = true
        CatBtn.TextColor3 = Theme.Main
    end)

    return Page
end

-- ФУНКЦИЯ СОЗДАНИЯ КНОПОК
local function AddToggle(parent, text, globalVar, callback)
    local TFrame = Instance.new("TextButton", parent)
    TFrame.Size = UDim2.new(1, -10, 0, 45)
    TFrame.BackgroundColor3 = Theme.LightDark
    TFrame.Text = "      " .. text
    TFrame.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    TFrame.Font = Enum.Font.GothamBold
    TFrame.TextSize = 14
    TFrame.TextXAlignment = Enum.TextXAlignment.Left
    TFrame.AutoButtonColor = false
    Instance.new("UICorner", TFrame)

    local Indicator = Instance.new("Frame", TFrame)
    Indicator.Size = UDim2.new(0, 4, 1, -10)
    Indicator.Position = UDim2.new(0, 10, 0, 5)
    Indicator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", Indicator)

    TFrame.MouseButton1Click:Connect(function()
        _G[globalVar] = not _G[globalVar]
        local state = _G[globalVar]
        
        TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundColor3 = state and Theme.Main or Color3.fromRGB(50, 50, 50)}):Play()
        TweenService:Create(TFrame, TweenInfo.new(0.3), {TextColor3 = state and Color3.new(1,1,1) or Color3.new(0.8, 0.8, 0.8)}):Play()
        
        Notify(text, state and "Enabled" or "Disabled", 2)
        if callback then callback(state) end
    end)
end

-- [[ НАПОЛНЕНИЕ ]]
local CombatPage = CreateCategory("Combat", "⚔️")
local PlayerPage = CreateCategory("Player", "👤")
local VisualsPage = CreateCategory("Visuals", "👁️")

-- Кнопки
AddToggle(PlayerPage, "Speed Hack", "SpeedEnabled")
AddToggle(PlayerPage, "Infinite Jump", "InfJumpEnabled")
AddToggle(CombatPage, "Godmode", "GodmodeActive")
AddToggle(VisualsPage, "Monster ESP", "MonsterESPActive")

-- АВТО-ОТКРЫТИЕ ПЕРВОЙ СТРАНИЦЫ
PageFolder:GetChildren()[1].Visible = true

-- DRAG SYSTEM (Перетаскивание)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- ГОРЯЧАЯ КЛАВИША
UIS.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.RightControl then ScreenGui.Enabled = not ScreenGui.Enabled end
end)

Notify("Orange Hub", "Loaded! Press RightControl to toggle UI", 5)
