local context = _G.SecuritySystem
local player = context.player
local UIS = context.UIS
local RunService = context.RunService
local flyBtn = context.flyBtn

local flying = false
local MAX_SPEED = 35 
local MAX_HEIGHT = 40 
local ACCELERATION_SMOOTHING = 0.1 

local bodyVelocity
local bodyGyro
local currentVelocity = Vector3.zero

local function toggleFly()
    flying = not flying
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoidRootPart or not humanoid then return end

    if flying then
        flyBtn.Text = "Stealth Fly: ON [ F ]"
        flyBtn.BackgroundColor3 = Color3.fromRGB(30, 80, 40) 
        
        humanid:ChangeState(Enum.HumanoidStateType.Freefall)
        currentVelocity = Vector3.zero
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.zero
        bodyVelocity.Parent = humanoidRootPart

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.CFrame = humanoidRootPart.CFrame
        bodyGyro.Parent = humanoidRootPart
    else
        flyBtn.Text = "Stealth Fly: OFF [ F ]"
        flyBtn.BackgroundColor3 = Color3.fromRGB(8, 15, 25)
        
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

flyBtn.MouseButton1Click:Connect(toggleFly)

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
end)

RunService.RenderStepped:Connect(function()
    if not flying then return end
    if not bodyVelocity or not bodyGyro then return end
    
    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local camera = workspace.CurrentCamera
    local direction = Vector3.zero

    if UIS:IsKeyDown(Enum.KeyCode.W) then direction += camera.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then direction -= camera.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then direction -= camera.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then direction += camera.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.new(0, 1, 0) end
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then direction -= Vector3.new(0, 1, 0) end

    if direction.Magnitude > 0 then direction = direction.Unit end

    local rayOrigin = hrp.Position
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local rayDown = workspace:Raycast(rayOrigin, Vector3.new(0, -MAX_HEIGHT - 5, 0), raycastParams)
    local rayUp = workspace:Raycast(rayOrigin, Vector3.new(0, 1000, 0), raycastParams)
    
    if not rayDown and not rayUp and direction.Y > 0 then
        direction = Vector3.new(direction.X, 0, direction.Z)
        if direction.Magnitude > 0 then direction = direction.Unit end
    end

    local targetVelocity = direction * MAX_SPEED
    currentVelocity = currentVelocity:Lerp(targetVelocity, ACCELERATION_SMOOTHING)

    bodyVelocity.Velocity = currentVelocity
    bodyGyro.CFrame = camera.CFrame
end)
