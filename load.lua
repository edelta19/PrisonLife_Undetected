local baseUrl = "https://raw.githubusercontent.com/edelta19/PrisonLife_Undetected/main/"

-- Step 1: Force UI_Setup to load and initialize first
local uiSuccess, uiError = pcall(function()
    return loadstring(game:HttpGet(baseUrl .. "UI_Setup.lua"))()
end)

if not uiSuccess then
    warn("CRITICAL: Failed to load UI_Setup.lua | " .. tostring(uiError))
    return
end

-- Step 2: Explicitly wait until the environment registration completes safely
local timeout = 5
local elapsed = 0
while not (_G.SecuritySystem and _G.SecuritySystem.invisBtn and _G.SecuritySystem.flyBtn) do
    task.wait(0.1)
    elapsed = elapsed + 0.1
    if elapsed >= timeout then
        warn("CRITICAL: Context initialization timed out!")
        return
    end
end

-- Step 3: Load the remaining feature scripts safely now that elements exist
local featureFiles = {
    "GhostMode.lua",
    "MouseTeleport.lua",
    "TeleportMenu.lua",
    "CollisionLogic.lua",
    "StealthFly.lua"
}

for _, fileName in ipairs(featureFiles) do
    local fileUrl = baseUrl .. fileName
    local success, result = pcall(function()
        return loadstring(game:HttpGet(fileUrl))()
    end)
    
    if not success then
        warn("Failed to load module: " .. fileName .. " | Error: " .. tostring(result))
    end
end
