-- [[ ORANGE HUB V4 - PREMIUM UI UPGRADE ]] local LP = game.Players.LocalPlayer local TweenService = game:GetService("TweenService")

if game.CoreGui:FindFirstChild("OrangeHub_V4") then game.CoreGui.OrangeHub_V4:Destroy() end

local gui = Instance.new("ScreenGui", game.CoreGui) gui.Name = "OrangeHub_V4"

-- === MAIN PANEL (GLASS + SHADOW EFFECT) === local Main = Instance.new("Frame", gui) Main.Size = UDim2.new(0, 540, 0, 380) Main.Position = UDim2.new(0.5, -270, 0.5, -190) Main.BackgroundColor3 = Color3.fromRGB(20, 20, 22) Main.BorderSizePixel = 0 Main.Active = true Main.Draggable = true Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", Main) Stroke.Color = Color3.fromRGB(255,140,0) Stroke.Thickness = 1.5 Stroke.Transparency = 0.4

-- === GRADIENT === local Grad = Instance.new("UIGradient", Main) Grad.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, Color3.fromRGB(255,140,0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255,80,0)) } Grad.Rotation = 90 Grad.Transparency = NumberSequence.new{ NumberSequenceKeypoint.new(0,0.9), NumberSequenceKeypoint.new(1,1) }

-- === SIDEBAR === local Sidebar = Instance.new("Frame", Main) Sidebar.Size = UDim2.new(0, 170, 1, 0) Sidebar.BackgroundColor3 = Color3.fromRGB(28, 28, 30) Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Sidebar) Title.Size = UDim2.new(1, 0, 0, 60) Title.Text = "ORANGE HUB" Title.TextColor3 = Color3.fromRGB(255, 170, 0) Title.Font = Enum.Font.GothamBlack Title.TextSize = 24 Title.BackgroundTransparency = 1

-- === BUTTON HOVER EFFECT FUNCTION === local function applyHover(btn) btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(60,60,65) }):Play() end) btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(45,45,48) }):Play() end) end

-- === CONTAINER === local Container = Instance.new("ScrollingFrame", Main) Container.Size = UDim2.new(1, -190, 1, -70) Container.Position = UDim2.new(0, 180, 0, 60) Container.BackgroundTransparency = 1 Container.BorderSizePixel = 0 Container.ScrollBarThickness = 3

local Layout = Instance.new("UIListLayout", Container) Layout.Padding = UDim.new(0, 12) Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- === INPUT === local function createInput(name, callback) local box = Instance.new("TextBox", Container) box.Size = UDim2.new(1, -10, 0, 50) box.BackgroundColor3 = Color3.fromRGB(40, 40, 42) box.PlaceholderText = "⚙ " .. name box.Text = "" box.TextColor3 = Color3.new(1, 1, 1) box.Font = Enum.Font.GothamBold box.TextSize = 14 Instance.new("UICorner", box).CornerRadius = UDim.new(0,10)

local stroke = Instance.new("UIStroke", box)
stroke.Transparency = 0.7

box.Focused:Connect(function()
    TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.2}):Play()
end)

box.FocusLost:Connect(function()
    TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
    local num = tonumber(box.Text)
    if num then callback(num) end
    box.Text = ""
end)

end

-- === TOGGLE (PREMIUM SWITCH STYLE) === local function createToggle(name, globalVar, callback) local holder = Instance.new("Frame", Container) holder.Size = UDim2.new(1, -10, 0, 50) holder.BackgroundColor3 = Color3.fromRGB(40,40,42) Instance.new("UICorner", holder).CornerRadius = UDim.new(0,10)

local label = Instance.new("TextLabel", holder)
label.Size = UDim2.new(0.7,0,1,0)
label.Text = name
label.TextColor3 = Color3.new(1,1,1)
label.Font = Enum.Font.GothamBold
label.TextSize = 14
label.BackgroundTransparency = 1

local toggle = Instance.new("Frame", holder)
toggle.Size = UDim2.new(0,50,0,24)
toggle.Position = UDim2.new(1,-60,0.5,-12)
toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)

local knob = Instance.new("Frame", toggle)
knob.Size = UDim2.new(0,22,0,22)
knob.Position = UDim2.new(0,1,0.5,-11)
knob.BackgroundColor3 = Color3.new(1,1,1)
Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

local state = _G[globalVar] or false

local function update()
    TweenService:Create(knob, TweenInfo.new(0.25), {
        Position = state and UDim2.new(1,-23,0.5,-11) or UDim2.new(0,1,0.5,-11)
    }):Play()

    TweenService:Create(toggle, TweenInfo.new(0.25), {
        BackgroundColor3 = state and Color3.fromRGB(255,140,0) or Color3.fromRGB(70,70,70)
    }):Play()
end

update()

holder.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        state = not state
        _G[globalVar] = state
        update()
        callback(state)
    end
end)

end

-- === TABS === local TabHolder = Instance.new("Frame", Sidebar) TabHolder.Size = UDim2.new(1, 0, 1, -80) TabHolder.Position = UDim2.new(0, 0, 0, 70) TabHolder.BackgroundTransparency = 1

local TabLayout = Instance.new("UIListLayout", TabHolder) TabLayout.Padding = UDim.new(0, 6)

local function showTab(name) for _, v in pairs(Container:GetChildren()) do if not v:IsA("UIListLayout") then v:Destroy() end end

if name == "Player" then
    createInput("Walk Speed", function(v) _G.WalkSpeedValue = v end)
    createToggle("Enable Walk Speed", "SpeedEnabled", function() end)

    createInput("Fly Speed", function(v) _G.FlySpeedValue = v end)
    createToggle("Enable Fly", "FlyEnabled", function(v)
        if _G.Modules and _G.Modules.Fly then _G.Modules.Fly.SetState(v) end
    end)

elseif name == "Combat" then
    createToggle("Godmode", "GodmodeEnabled", function() end)
    createToggle("ESP Monsters", "MonsterESPActive", function(v)
        if _G.Modules and _G.Modules.ESP then _G.Modules.ESP.Enabled = v end
    end)
end

end

local function addTabBtn(name) local t = Instance.new("TextButton", TabHolder) t.Size = UDim2.new(1, 0, 0, 45) t.Text = name t.Font = Enum.Font.GothamBold t.TextSize = 16 t.TextColor3 = Color3.new(1, 1, 1) t.BackgroundColor3 = Color3.fromRGB(35,35,38) Instance.new("UICorner", t).CornerRadius = UDim.new(0,8)

applyHover(t)

t.MouseButton1Click:Connect(function()
    showTab(name)
end)

end

addTabBtn("Player") addTabBtn("Combat") showTab("Player")

return gui
