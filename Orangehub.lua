-- ORANGE HUB | WORKING HUB WITH BUTTONS AND CLOSE

pcall(function()
    game.CoreGui:FindFirstChild("OrangeHubUI"):Destroy()
end)

local gui = Instance.new("ScreenGui")
gui.Name = "OrangeHubUI"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

-- MAIN WINDOW
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 500, 0, 350)
main.Position = UDim2.new(0.5, -250, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(45,45,45)
title.Text = "🍊 ORANGE HUB"
title.TextColor3 = Color3.fromRGB(255,140,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BorderSizePixel = 0

-- CLOSE BUTTON
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0,40,0,40)
close.Position = UDim2.new(1,-45,0,0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(180,50,50)
close.TextColor3 = Color3.fromRGB(255,255,255)
close.Font = Enum.Font.GothamBold
close.TextSize = 16
close.BorderSizePixel = 0
Instance.new("UICorner", close).CornerRadius = UDim.new(0,8)
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- CONTENT PANEL
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-20,1,-60)
content.Position = UDim2.new(0,10,0,50)
content.BackgroundColor3 = Color3.fromRGB(22,22,22)
content.BorderSizePixel = 0
Instance.new("UICorner", content).CornerRadius = UDim.new(0,8)

-- BUTTON FUNCTION
local function createButton(parent, text, y)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0,200,0,40)
    btn.Position = UDim2.new(0,20,0,y)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    btn.MouseButton1Click:Connect(function()
        print(text .. " clicked")
    end)
end

-- CREATE BUTTONS
createButton(content, "Enable Module", 20)
createButton(content, "Auto Mode", 70)
createButton(content, "Speed Boost", 120)
createButton(content, "Anti AFK", 170)
