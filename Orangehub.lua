-- [[ ORANGE HUB V4 - FINAL CORE ]]
repeat task.wait() until game:IsLoaded()

if _G.OrangeHubLoaded then return end
_G.OrangeHubLoaded = true

local BASE_URL = "https://raw.githubusercontent.com/bolotnyx/Orangehub/main/Modules/"
_G.Modules = {}

local function Load(name)
    -- Уникальная ссылка для обхода кэша GitHub
    local url = BASE_URL .. name .. ".lua?nocache=" .. tostring(os.clock())
    local s, res = pcall(function() return game:HttpGet(url) end)
    if s and res and not res:find("404") then
        local f, err = loadstring(res)
        if f then
            _G.Modules[name] = f()
            print("✅ " .. name .. " loaded")
        else
            warn("❌ Error in " .. name .. ": " .. err)
        end
    end
end

-- Важен порядок: UI всегда последний
Load("Player")
Load("Fly")
Load("InfiniteJump")
Load("ESP")
Load("UI") 
