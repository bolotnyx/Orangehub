local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService = cloneref(game:GetService("RunService"))

-- ============================
--  ЗАГРУЗКА WINDUI
-- ============================
local WindUI

do
	local ok, result = pcall(function()
		return require("./src/Init")
	end)

	if ok then
		WindUI = result
	else
		if RunService:IsStudio() then
			WindUI = require(cloneref(ReplicatedStorage:WaitForChild("WindUI"):WaitForChild("Init")))
		else
			WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
		end
	end
end

-- ============================
--  ГЛАВНОЕ ОКНО
-- ============================
local Window = WindUI:CreateWindow({
	Title = "ORANGE HUB  |  v4.0 · ADVANCED",
	Folder = "OrangeHub_V4",
	Icon = "solar:pallete-2-bold", -- Заменили лого на подходящую иконку
	NewElements = true,

	OpenButton = {
		Title = "Open Orange Hub", 
		CornerRadius = UDim.new(1, 0), 
		StrokeThickness = 3, 
		Enabled = true, 
		Draggable = true,
		OnlyMobile = false,
		Scale = 0.5,
		Color = ColorSequence.new(
			Color3.fromRGB(255, 140, 0), -- Оранжевый из твоего UI
			Color3.fromRGB(180, 90, 0)
		),
	},
	Topbar = {
		Height = 44,
		ButtonsType = "Mac",
	},
})

-- Устанавливаем бинд на скрытие (как в твоем оригинале)
Window:SetToggleKey(Enum.KeyCode.RightShift)

-- ============================
--  ВКЛАДКИ
-- ============================
local Tabs = {
	Player = Window:Tab({ Title = "Player", Icon = "solar:user-bold" }),
	Combat = Window:Tab({ Title = "Combat", Icon = "solar:sword-bold" }),
	Visual = Window:Tab({ Title = "Visual", Icon = "solar:eye-bold" }),
	Misc = Window:Tab({ Title = "Misc", Icon = "solar:settings-bold" }),
}

-- ============================
--  ВКЛАДКА: PLAYER
-- ============================
Tabs.Player:Section({ Title = "Передвижение" })

Tabs.Player:Slider({
	Title = "Walk Speed",
	Step = 1,
	Value = {
		Min = 16,
		Max = 100,
		Default = 16,
	},
	Callback = function(value)
		_G.WalkSpeedValue = value
	end,
})

Tabs.Player:Toggle({
	Title = "Включить Walk Speed",
	Callback = function(v)
		_G.SpeedEnabled = v
		-- Логика в WalkSpeed.lua
	end,
})

Tabs.Player:Section({ Title = "Полёт" })

Tabs.Player:Slider({
	Title = "Fly Speed",
	Step = 1,
	Value = {
		Min = 10,
		Max = 200,
		Default = 50,
	},
	Callback = function(value)
		_G.FlySpeedValue = value
	end,
})

Tabs.Player:Toggle({
	Title = "Включить Fly",
	Callback = function(v)
		_G.FlyEnabled = v
		if _G.Modules and _G.Modules.Fly then _G.Modules.Fly.SetState(v) end
	end,
})

Tabs.Player:Section({ Title = "Прыжки" })

Tabs.Player:Toggle({
	Title = "Infinite Jump",
	Callback = function(v)
		_G.InfJumpEnabled = v
		-- Логика в InfiniteJump.lua
	end,
})

-- ============================
--  ВКЛАДКА: COMBAT
-- ============================
Tabs.Combat:Section({ Title = "Атака" })

Tabs.Combat:Toggle({
	Title = "Godmode (Анти-Волк)",
	Callback = function(v)
		_G.GodmodeEnabled = v
		if _G.Modules and _G.Modules.Godmode then
			_G.Modules.Godmode.Enabled = v
		end
	end,
})

Tabs.Combat:Toggle({
	Title = "Kill Aura",
	Callback = function(v)
		_G.KillAura = v
		if _G.Modules and _G.Modules.Combat then
			_G.Modules.Combat.KillAura = v
		end
	end,
})

Tabs.Combat:Section({ Title = "Kill Aura Дальность" })

Tabs.Combat:Slider({
	Title = "Дальность атаки",
	Step = 1,
	Value = {
		Min = 5,
		Max = 60,
		Default = 25,
	},
	Callback = function(v)
		_G.KillAuraRange = v
		if _G.Modules and _G.Modules.Combat then
			_G.Modules.Combat.Range = v
		end
		if _G.Modules and _G.Modules.Godmode then
			_G.Modules.Godmode.Distance = v
		end
	end,
})

-- ============================
--  ВКЛАДКА: VISUAL
-- ============================
Tabs.Visual:Section({ Title = "Освещение" })

Tabs.Visual:Toggle({
	Title = "FullBright",
	Callback = function(v)
		_G.FullBrightEnabled = v
		if _G.Modules and _G.Modules.FullBright then
			_G.Modules.FullBright.SetEnabled(v)
		else
			local Lighting = game:GetService("Lighting")
			if v then
				_G.OriginalLighting = {
					Brightness = Lighting.Brightness,
					ClockTime = Lighting.ClockTime,
					FogEnd = Lighting.FogEnd,
					GlobalShadows = Lighting.GlobalShadows,
					Ambient = Lighting.Ambient
				}
				Lighting.Brightness = 1
				Lighting.ClockTime = 12
				Lighting.FogEnd = 100000
				Lighting.GlobalShadows = false
				Lighting.Ambient = Color3.fromRGB(178, 178, 178)
			elseif _G.OriginalLighting then
				local o = _G.OriginalLighting
				Lighting.Brightness = o.Brightness
				Lighting.ClockTime = o.ClockTime
				Lighting.FogEnd = o.FogEnd
				Lighting.GlobalShadows = o.GlobalShadows
				Lighting.Ambient = o.Ambient
			end
		end
	end,
})

Tabs.Visual:Section({ Title = "Монстры" })

Tabs.Visual:Toggle({
	Title = "ESP Монстры",
	Callback = function(v)
		_G.MonsterESPActive = v
		if _G.Modules and _G.Modules.ESP then _G.Modules.ESP.Enabled = v end
	end,
})

Tabs.Visual:Section({ Title = "Ресурсы" })

Tabs.Visual:Toggle({
	Title = "ESP Ресурсы",
	Callback = function(v)
		_G.ResourceESPActive = v
		WindUI:Notify({
			Title = "ESP Ресурсы",
			Content = v and "Включён" or "Выключён",
			Duration = 3,
		})
	end,
})

-- ============================
--  ВКЛАДКА: MISC
-- ============================
Tabs.Misc:Section({ Title = "Утилиты" })

Tabs.Misc:Toggle({
	Title = "Anti-AFK",
	Callback = function(v)
		_G.AntiAFKEnabled = v
		if _G.Modules and _G.Modules.AntiAFK then
			_G.Modules.AntiAFK.Enabled = v
		end
	end,
})

Tabs.Misc:Section({ Title = "Информация" })

Tabs.Misc:Paragraph({
	Title = "Orange Hub V4",
	Desc = "Игра: 99 Nights in the Forest\nХоткей: RShift — скрыть / показать GUI",
	Image = "solar:info-circle-bold",
})

-- ============================
--  ФИНАЛЬНОЕ УВЕДОМЛЕНИЕ
-- ============================
WindUI:Notify({
	Title = "Orange Hub V4",
	Content = "Успешно загружен!",
	Icon = "solar:check-circle-bold",
	Duration = 3.5,
})
