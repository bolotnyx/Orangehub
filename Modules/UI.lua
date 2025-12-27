local UI = {}

function UI.Init(MainFrame, Container)
    -- Внутренняя функция создания кнопок
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
        btn.MouseButton1Click:Connect(function()
            enabled = not enabled
            dot:TweenPosition(enabled and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6), "Out", "Sine", 0.15, true)
            bg.BackgroundColor3 = enabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(60, 60, 60)
            if callback then callback(enabled) end
        end)
    end

    -- Определение вкладок
    UI.Tabs = {
        ["Player"] = function()
            createToggle("Speed Hack", function(v) 
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v and 100 or 16 
            end)
            createToggle("Fly", function(v) 
                if _G.Modules["Fly"] then _G.Modules["Fly"].Enabled = v end 
            end)
            createToggle("Anti-AFK", function(v) 
                if _G.Modules["AntiAFK"] then _G.Modules["AntiAFK"].Enabled = v end 
            end)
        end,
        ["Combat"] = function()
            createToggle("KillAura", function(v) 
                if _G.Modules["Combat"] then _G.Modules["Combat"].KillAura = v end 
            end)
            createToggle("ESP Monsters", function(v) 
                if _G.Modules["ESP"] then _G.Modules["ESP"].Enabled = v end 
            end)
        end
    }
end

return UI
