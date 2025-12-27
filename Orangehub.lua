repeat task.wait() until game:IsLoaded()
local Modules = {}
local base = "https://raw.githubusercontent.com/bolotnyx/OrangeHub/main/Modules/"

for _,m in ipairs({"UI","Combat","ESP","Player"}) do
	Modules[m] = loadstring(game:HttpGet(base..m..".lua"))()
end

print("🍊 OrangeHub initialized")
