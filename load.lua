local GITHUB_TOKEN = "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" 
local baseUrl = "https://raw.githubusercontent.com/edelta19/PrisonLife_Undetected/main/"

local function fetchPrivateFile(fileName)
    local content
    local success, err = pcall(function()
        content = game:HttpGet(baseUrl .. fileName, true, {
            ["Authorization"] = "token " .. GITHUB_TOKEN,
            ["Cache-Control"] = "no-cache"
        })
    end)
    
    if not success or not content or content:find("404: Not Found") then
        warn("CRITICAL: Failed to download private file: " .. fileName)
        return nil
    end
    return content
end

local function safeLoad(fileName)
    local content = fetchPrivateFile(fileName)
    if not content then return false end
    
    local func, parseError = loadstring(content)
    if not func then
        warn("SYNTAX ERROR in " .. fileName .. ": " .. tostring(parseError))
        return false
    end
    
    local runSuccess, runError = pcall(func)
    if not runSuccess then
        warn("RUNTIME ERROR in " .. fileName .. ": " .. tostring(runError))
        return false
    end
    
    return true
end

-- 1. Load Core UI First
if safeLoad("UI_Setup.lua") then
    -- 2. Wait until global table finishes preparing
    local timeout = 5
    local elapsed = 0
    while not (_G.SecuritySystem and _G.SecuritySystem.invisBtn) do
        task.wait(0.1)
        elapsed = elapsed + 0.1
        if elapsed >= timeout then
            warn("Loader timed out waiting for UI setup!")
            return
        end
    end

    -- 3. Load Features safely
    local features = {
        "GhostMode.lua",
        "MouseTeleport.lua",
        "TeleportMenu.lua",
        "CollisionLogic.lua",
        "StealthFly.lua"
    }

    for _, file in ipairs(features) do
        safeLoad(file)
    end
end
