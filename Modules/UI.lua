-- Minimal UI.lua with collapse button
local gui = Instance.new("ScreenGui")
gui.Name = "OrangeHubGUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- Main frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,300,0,200)
frame.Position = UDim2.new(0.5,-150,0.5,-100)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "🍊 OrangeHub"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,165,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Collapse button
local collapse = Instance.new("TextButton", frame)
collapse.Size = UDim2.new(0,30,0,30)
collapse.Position = UDim2.new(1,-35,0,0)
collapse.Text = "—"
collapse.BackgroundColor3 = Color3.fromRGB(35,35,35)
collapse.TextColor3 = Color3.new(1,1,1)
collapse.Font = Enum.Font.GothamBold
collapse.TextSize = 18
Instance.new("UICorner", collapse)

local collapsed = false
local originalSize = frame.Size

collapse.MouseButton1Click:Connect(function()
	collapsed = not collapsed
	if collapsed then
		frame.Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset, 0, 30)
		collapse.Text = "+"
	else
		frame.Size = originalSize
		collapse.Text = "—"
	end
end)

print("UI module loaded (with collapse)")
return gui
