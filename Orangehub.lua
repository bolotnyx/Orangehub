-- ORANGE HUB | TEST
print("🍊 ORANGE HUB LOADED!")

-- Простое окно
local gui = Instance.new("ScreenGui")
gui.Name = "OrangeHubUI"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,400,0,250)
frame.Position = UDim2.new(0.5,-200,0.5,-125)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = gui

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,50)
title.BackgroundColor3 = Color3.fromRGB(50,50,50)
title.Text = "🍊 ORANGE HUB LOADED!"
title.TextColor3 = Color3.fromRGB(255,140,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BorderSizePixel = 0
