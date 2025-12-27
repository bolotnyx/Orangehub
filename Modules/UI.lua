-- Очистка старого UI перед запуском
if game.CoreGui:FindFirstChild("OrangeHub_V4") then 
    game.CoreGui["OrangeHub_V4"]:Destroy() 
end

local LP = game.Players.LocalPlayer
_G.KillAura = false -- Глобальный переключатель

-- ==========================================
-- ЛОГИКА KILL AURA (ВСТРОЕННАЯ)
-- ==========================================
local enemies = {"Wolf", "Bear", "Cultist", "Mammoth", "Bunny", "Alpha"}
local blacklist = {"Mammoth Tusk", "wolf spawner", "wolf respawner", "wolf head", "bunny burrow"}

task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.KillAura and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            if tool then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= LP.Character then
                        local name = obj.Name
                        local isEnemy = false
                        
                        -- Проверка имен
                        for _, enName in ipairs(enemies) do
                            if name:find(enName) then
                                isEnemy = true
                                for _, bName in ipairs(blacklist) do
                                    if name:find(bName) then isEnemy = false break end
                                end
                                break
                            end
                        end

                        if isEnemy then
                            local tRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                            if tRoot then
                                local dist = (LP.Character.HumanoidRootPart.Position - tRoot.Position).Magnitude
                                if dist <= 25 then -- Радиус как в Moondate
                                    -- Поворот
                                    LP.Character.HumanoidRootPart.CFrame = CFrame.new(LP.Character.HumanoidRootPart.Position, Vector3.new(tRoot.Position.X, LP.Character.HumanoidRootPart.Position.Y, tRoot.Position.Z))
                                    -- Атака
                                    tool:Activate()
                                    -- Нанесение урона (TouchInterest)
                                    local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
                                    if handle then
                                        firetouchinterest(tRoot, handle, 0)
                                        firetouchinterest(tRoot, handle, 1)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ==========================================
-- ВИЗУАЛЬНАЯ ЧАСТЬ UI
-- ==========================================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "OrangeHub_V4"
gui.ResetOnSpawn = false

local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 27)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Accent = Instance.new("Frame", Main)
Accent.Size = UDim2.new(1, 0, 0, 3)
Accent.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
Accent.ZIndex = 5
Instance.new("UICorner", Accent)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(33, 33, 35)
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "ORANGE HUB"
Title.TextColor3 = Color3.fromRGB(255, 165, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

local TabHolder = Instance.new("Frame", Sidebar)
TabHolder.Size = UDim2.new(1, -10, 1, -80)
TabHolder.Position = UDim2.new(0, 5, 0, 70)
TabHolder.BackgroundTransparency = 1
Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 5)

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -160, 1, -70)
Container.Position = UDim2.new(0, 150, 0, 55)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 10)

local function createToggle(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)

    local bg = Instance.new("Frame", btn)
    bg.Size = UDim2.new(0, 34, 0, 18)
    bg.Position = UDim2.new(1, -45, 0.5, -9)
    bg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", bg)
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = UDim2.new(0, 3, 0.5, -6)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local enabled = false
    btn.MouseButton1Down:Connect(function()
        enabled = not enabled
        dot:TweenPosition(enabled and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6), "Out", "Sine", 0.15, true)
        bg.BackgroundColor3 = enabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(60, 60, 60)
        callback(enabled)
    end)
end

local function showTab(name)
    for _, v in ipairs(Container:GetChildren()) do 
        if v:IsA("TextButton") then v:Destroy() end 
    end
    
    if name == "Player" then
        createToggle("Speed Hack", function(v) LP.Character.Humanoid.WalkSpeed = v and 100 or 16 end)
    elseif name == "Combat" then
        createToggle("KillAura", function(v)
            _G.KillAura = v
        end)
        createToggle("ESP Monsters", function(v)
            if _G.Modules and _G.Modules["ESP"] then _G.Modules["ESP"].Enabled = v end
        end)
    end
end

local function addSidebarButton(name)
    local t = Instance.new("TextButton", TabHolder)
    t.Size = UDim2.new(1, 0, 0, 40)
    t.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    t.Text = name
    t.TextColor3 = Color3.new(1, 1, 1)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 14
    Instance.new("UICorner", t)
    t.MouseButton1Click:Connect(function() showTab(name) end)
end

addSidebarButton("Player")
addSidebarButton("Combat")
showTab("Combat") -- Сразу открываем боевую вкладку

local Collapse = Instance.new("TextButton", Main)
Collapse.Size = UDim2.new(0, 26, 0, 26)
Collapse.Position = UDim2.new(1, -32, 0, 8)
Collapse.Text = "—"
Collapse.TextColor3 = Color3.new(1, 1, 1)
Collapse.BackgroundColor3 = Color3.fromRGB(45, 45, 47)
Instance.new("UICorner", Collapse)

local OpenBtn = Instance.new("TextButton", gui)
OpenBtn.Size = UDim2.new(0, 55, 0, 55)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -27)
OpenBtn.Text = "🍊"
OpenBtn.TextSize = 40
OpenBtn.BackgroundTransparency = 1
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true

Collapse.MouseButton1Click:Connect(function() Main.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true OpenBtn.Visible = false end)

return gui
