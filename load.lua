local url = "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/"
local modules = {"UI_Setup.lua", "GhostMode.lua", "MouseTeleport.lua", "TeleportMenu.lua", "CollisionLogic.lua", "StealthFly.lua"}
for _, file in ipairs(modules) do loadstring(game:HttpGet(url .. file))() end
