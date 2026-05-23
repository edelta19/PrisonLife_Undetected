local context = _G.SecuritySystem
local player = context.player
local RunService = context.RunService
local colBtn = context.colBtn

local function analyzeIfFloor(part)
    if part:IsA("Terrain") then return true end
    local lowerName = string.lower(part.Name)
    local floorKeywords = {"floor", "ground", "grass", "street", "road", "baseplate", "sidewalk", "path", "pavement"}
    for _, word in ipairs(floorKeywords) do
        if string.find(lowerName, word) then return true end
    end
    local matString = tostring(part.Material)
    local safeMaterials = {"Grass", "Asphalt", "Pavement", "Cobblestone", "Sand", "Ground", "Mud"}
    for _, mat in ipairs(safeMaterials) do
        if string.find(matString, mat) then return true end
    end
    if part.Size.Y <= 4 and part.Size.X >= 15 and part.Size.Z >= 15 then
        local upVectorMatch = math.abs(part.CFrame.UpVector:Dot(Vector3.new(0, 1, 0)))
        if upVectorMatch > 0.9 then return true end
    end
    return false
end

local wallsAreSolid = true
local modifiedWalls = {}
local floorParts = {}
local oneWayConnection = nil

colBtn.MouseButton1Click:Connect(function()
    if wallsAreSolid then
        wallsAreSolid = false
        colBtn.Text = "Restore Collisions"
        colBtn.BackgroundColor3 = Color3.fromRGB(30, 80, 40)
        for _, object in pairs(workspace:GetDescendants()) do
            if object:IsA("BasePart") then
                if analyzeIfFloor(object) then
                    table.insert(floorParts, object)
                elseif object.CanCollide then
                    object.CanCollide = false
                    table.insert(modifiedWalls, object)
                end
            end
        end
        
        oneWayConnection = RunService.Heartbeat:Connect(function()
            local character = player.Character
            if not character then return end
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local feetY = hrp.Position.Y - 3
            for _, floorPart in ipairs(floorParts) do
                if not floorPart:IsA("Terrain") then
                    local floorTopY = floorPart.Position.Y + (floorPart.Size.Y / 2)
                    if feetY >= (floorTopY - 0.5) then
                        floorPart.CanCollide = true
                    else
                        floorPart.CanCollide = false
                    end
                end
            end
        end)
    else
        wallsAreSolid = true
        colBtn.Text = "Disable Wall Collisions"
        colBtn.BackgroundColor3 = Color3.fromRGB(8, 15, 25)
        if oneWayConnection then
            oneWayConnection:Disconnect()
            oneWayConnection = nil
        end
        for _, wall in ipairs(modifiedWalls) do
            if wall and wall.Parent then wall.CanCollide = true end
        end
        for _, floor in ipairs(floorParts) do
            if floor and floor.Parent and not floor:IsA("Terrain") then floor.CanCollide = true end
        end
        table.clear(modifiedWalls)
        table.clear(floorParts)
    end
end)
