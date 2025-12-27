local gui = Instance.new("ScreenGui")
gui.Name = "OrangeHubGUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- ГЛАВНЫЙ ФРЕЙМ (МЕНЮ)
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0,400,0,300)
mainFrame.Position = UDim2.new(0.5,-200,0.5,-150)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.Active = true
mainFrame.Draggable = true -- Можно двигать
Instance.new("UICorner", mainFrame)

-- КНОПКА ОТКРЫТИЯ (АПЕЛЬСИН)
-- Она живет отдельно от mainFrame, чтобы не исчезать вместе с ним
local openBtn = Instance.new("TextButton", gui)
openBtn.Name = "OpenBtn"
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0, 20, 0.5, -25) -- Слева на экране
openBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
openBtn.Text = "🍊"
openBtn.TextSize = 30
openBtn.Visible = false -- Скрыта по умолчанию
openBtn.Active = true
openBtn.Draggable = true
Instance.new("UICorner", openBtn).CornerRadius = BoxRadius.new(1, 0) -- Делаем круглой

-- Заголовок
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "🍊 OrangeHub"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,165,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- КНОПКА СВЕРНУТЬ (—)
local collapseBtn = Instance.new("TextButton", mainFrame)
collapseBtn.Size = UDim2.new(0,30,0,30)
collapseBtn.Position = UDim2.new(1,-35,0,2)
collapseBtn.Text = "—"
collapseBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
collapseBtn.TextColor3 = Color3.new(1,1,1)
collapseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", collapseBtn)

-- ЛОГИКА СВОРАЧИВАНИЯ
collapseBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	openBtn.Visible = true -- Показываем кнопку-апельсин
end)

openBtn.MouseButton1Click:Connect(function()
	openBtn.Visible = false -- Прячем апельсин
	mainFrame.Visible = true -- Показываем меню
end)

-- ПАНЕЛИ
local sidePanel = Instance.new("Frame", mainFrame)
sidePanel.Size = UDim2.new(0,100,1,-40)
sidePanel.Position = UDim2.new(0,0,0,40)
sidePanel.BackgroundTransparency = 1

local centerPanel = Instance.new("Frame", mainFrame)
centerPanel.Size = UDim2.new(1,-110,1,-50)
centerPanel.Position = UDim2.new(0,105,0,45)
centerPanel.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", centerPanel)

-- Очистка вкладок
local function clearCenter()
	for _,v in ipairs(centerPanel:GetChildren()) do
		if not v:IsA("UICorner") then v:Destroy() end
	end
end

-- Создание кнопок функций
local function createMenuButton(name, pos, callback)
	local btn = Instance.new("TextButton", centerPanel)
	btn.Size = UDim2.new(1,-10,0,35)
	btn.Position = pos
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	Instance.new("UICorner", btn)
	
	local enabled = false
	btn.MouseButton1Click:Connect(function()
		enabled = not enabled
		btn.BackgroundColor3 = enabled and Color3.fromRGB(255,165,0) or Color3.fromRGB(50,50,50)
		callback(enabled)
	end)
end

-- ВКЛАДКИ
local tabs = {"Combat","Player","ESP"}
for i, name in ipairs(tabs) do
	local tabBtn = Instance.new("TextButton", sidePanel)
	tabBtn.Size = UDim2.new(1,-10,0,40)
	tabBtn.Position = UDim2.new(0,5,0,(i-1)*45)
	tabBtn.Text = name
	tabBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
	tabBtn.TextColor3 = Color3.new(1,1,1)
	tabBtn.Font = Enum.Font.GothamBold
	Instance.new("UICorner", tabBtn)
	
	tabBtn.MouseButton1Click:Connect(function()
		clearCenter()
		if name == "Combat" then
			createMenuButton("KillAura", UDim2.new(0,5,0,10), function(v)
				if _G.Modules["Combat"] then _G.Modules["Combat"].KillAura = v end
			end)
		elseif name == "Player" then
			createMenuButton("Auto Tree Farm", UDim2.new(0,5,0,10), function(v)
				if _G.Modules["Player"] then _G.Modules["Player"].AutoTree = v end
			end)
			createMenuButton("Auto Log Farm", UDim2.new(0,5,0,55), function(v)
				if _G.Modules["Player"] then _G.Modules["Player"].AutoLog = v end
			end)
		elseif name == "ESP" then
			createMenuButton("Toggle ESP", UDim2.new(0,5,0,10), function(v)
				if _G.Modules["ESP"] then _G.Modules["ESP"].Enabled = v end
			end)
		end
	end)
end

print("🍊 OrangeHub UI Loaded - Use 🍊 button to restore")
return gui
