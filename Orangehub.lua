repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
repeat task.wait() until LP.Character

local Modules = {}
local base = "https://raw.githubusercontent.com/USERNAME/OrangeHub/main/Modules/"

for _,m in ipairs({"UI","Combat","ESP","Player"}) do
	Modules[m] = loadstring(game:HttpGet(base..m..".lua"))()
end

print("OrangeHub initialized")
