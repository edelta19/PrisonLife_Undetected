local baseUrl = "https://raw.githubusercontent.com/edelta19/PrisonLife_Undetected/main/"

local function fetchFile(fileName)
    local success, response = pcall(function()
        return game:HttpGet(baseUrl .. fileName)
    end)

    if not success then
        warn("HTTP FAILED:", fileName)
        warn(response)
        return nil
    end

    print("Fetched:", fileName)

    return response
end

local function safeLoad(fileName)
    print("Loading:", fileName)

    local content = fetchFile(fileName)

    if not content then
        return false
    end

    local func, parseError = loadstring(content)

    if not func then
        warn("LOADSTRING ERROR:", fileName)
        warn(parseError)
        return false
    end

    local success, runtimeError = pcall(func)

    if not success then
        warn("RUNTIME ERROR IN:", fileName)
        warn(runtimeError)
        return false
    end

    print("SUCCESS:", fileName)

    return true
end

safeLoad("UI_Setup.lua")

local files = {
    "GhostMode.lua",
    "MouseTeleport.lua",
    "TeleportMenu.lua",
    "CollisionLogic.lua",
    "StealthFly.lua"
}

for _, file in ipairs(files) do
    safeLoad(file)
end
