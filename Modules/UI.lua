-- Modules/UI.lua
local gui = Instance.new("ScreenGui")
gui.Name = "OrangeHubGUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- Главный фрейм
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0,400,0,300)
mainFrame.Position = UDim2.new(0.5,-200,0.5,-150)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame)

-- Заголовок
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "🍊 OrangeHub"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,165,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Сворачивание
local collapse = Instance.new("TextButton", mainFrame)
collapse.Size = UDim2.new(0,30,0,30)
collapse.Position = UDim2.new(1,-35,0,0)
collapse.Text = "—"
collapse.BackgroundColor3 = Color3.fromRGB(35,35,35)
collapse.TextColor3 = Color3.new(1,1,1)
collapse.Font = Enum.Font.GothamBold
collapse.TextSize = 18
collapse.ZIndex = 10
Instance.new("UICorner", collapse)

local collapsed = false
collapse.MouseButton1Click:Connect(function()
	collapsed = not collapsed
	mainFrame.Visible = not collapsed
end)

-- Правая панель вкладок
local rightPanel = Instance.new("Frame", mainFrame)
rightPanel.Size = UDim2.new(0,100,1,0)
rightPanel.Position = UDim2.new(1,-100,0,0)
rightPanel.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner", rightPanel)

-- Центральная панель
local centerPanel = Instance.new("Frame", mainFrame)
centerPanel.Size = UDim2.new(1,-100,1,0)
centerPanel.Position = UDim2.new(0,0,0,0)
centerPanel.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", centerPanel)

-- Вкладки
local tabs = {"Combat","Player","ESP"}
local buttons = {}

local function clearCenter()
	for _,v in ipairs(centerPanel:GetChildren()) do
		v:Destroy()
	end
end

local function createTabButton(name, position)
	local btn = Instance.new("TextButton", rightPanel)
	btn.Size = UDim2.new(1,0,0,40)
	btn.Position = position
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	Instance.new("UICorner", btn)
	buttons[name] = btn
	return btn
end

for i,name in ipairs(tabs) do
	local btn = createTabButton(name, UDim2.new(0,0,0,(i-1)*50))
	btn.MouseButton1Click:Connect(function()
		clearCenter()
		if name == "Combat" then
			local killBtn = Instance.new("TextButton", centerPanel)
			killBtn.Size = UDim2.new(0,150,0,30)
			killBtn.Position = UDim2.new(0.5,-75,0,50)
			killBtn.Text = "KillAura"
			killBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
			killBtn.TextColor3 = Color3.fromRGB(255,255,255)
			killBtn.Font = Enum.Font.GothamBold
			killBtn.TextSize = 14
			Instance.new("UICorner", killBtn)
			killBtn.MouseButton1Click:Connect(function()
				local combat = _G.Modules and _G.Modules["Combat"]
				if combat then
					combat.KillAura = not combat.KillAura
				end
			end)
		elseif name == "Player" then
			local speedBtn = Instance.new("TextButton", centerPanel)
			speedBtn.Size = UDim2.new(0,150,0,30)
			speedBtn.Position = UDim2.new(0.5,-75,0,50)
			speedBtn.Text = "Speed x2"
			speedBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
			speedBtn.TextColor3 = Color3.fromRGB(255,255,255)
			speedBtn.Font = Enum.Font.GothamBold
			speedBtn.TextSize = 14
			Instance.new("UICorner", speedBtn)
			speedBtn.MouseButton1Click:Connect(function()
				local player = _G.Modules and _G.Modules["Player"]
				if player and player.Humanoid then
					player.Humanoid.WalkSpeed = 50
				end
			end)
		elseif name == "ESP" then
			local espBtn = Instance.new("TextButton", centerPanel)
			espBtn.Size = UDim2.new(0,150,0,30)
			espBtn.Position = UDim2.new(0.5,-75,0,50)
			espBtn.Text = "Toggle ESP"
			espBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
			espBtn.TextColor3 = Color3.fromRGB(255,255,255)
			espBtn.Font = Enum.Font.GothamBold
			espBtn.TextSize = 14
			Instance.new("UICorner", espBtn)
			espBtn.MouseButton1Click:Connect(function()
				local esp = _G.Modules and _G.Modules["ESP"]
				if esp then
					esp.Enabled = not esp.Enabled
				end
			end)
		end
	end)
end

print("UI module loaded")
return gui
