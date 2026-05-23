local baseUrl = "https://raw.githubusercontent.com/edelta19/PrisonLife_Undetected/main/"
local files = {
    "UI_Setup.lua",
    "GhostMode.lua",
    "MouseTeleport.lua",
    "TeleportMenu.lua",
    "CollisionLogic.lua",
    "StealthFly.lua"
}

for _, fileName in ipairs(files) do
    local fileUrl = baseUrl .. fileName
    local success, result = pcall(function()
        return loadstring(game:HttpGet(fileUrl))()
    end)
    
    if not success then
        warn("Failed to load module: " .. fileName .. " | Error: " .. tostring(result))
    end
end
