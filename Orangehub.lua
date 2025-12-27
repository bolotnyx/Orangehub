repeat task.wait() until game:IsLoaded()

local Modules = {}
local base = "https://raw.githubusercontent.com/bolotnyx/Orangehub/main/Modules/"

for _,m in ipairs({"UI","Combat","ESP","Player"}) do
	local ok, mod = pcall(function()
		return loadstring(game:HttpGet(base..m..".lua"))()
	end)
	if ok then
		Modules[m] = mod
		print("Loaded module:", m)
	else
		warn("Failed module:", m)
	end
end

print("🍊 OrangeHub initialized")
