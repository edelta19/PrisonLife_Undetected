local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()

if PlayerGui:FindFirstChild("AdminPanelUI") then
    PlayerGui.AdminPanelUI:Destroy()
end

-- ==========================================
-- 1. BUILD THE UI (Glassmorphism Design)
-- ==========================================
local gui = Instance.new("ScreenGui")
gui.Name = "AdminPanelUI"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 470, 0, 350) 
main.Position = UDim2.new(0.5, -235, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.Active = true 
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(70, 70, 70)
stroke.Thickness = 1
stroke.Transparency = 0.4
stroke.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Security System Panel"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = main

local timeLabel = Instance.new("TextLabel")
timeLabel.Size = UDim2.new(1, 0, 0, 15)
timeLabel.Position = UDim2.new(0, 0, 0, 0)
timeLabel.BackgroundTransparency = 1
timeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
timeLabel.Font = Enum.Font.Gotham
timeLabel.TextSize = 10
timeLabel.Parent = main

task.spawn(function()
    while task.wait(1) do
        timeLabel.Text = os.date("%I:%M %p, %A, %B %d, %Y")
    end
end)

local resizeHandle = Instance.new("TextButton")
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.Position = UDim2.new(1, -20, 1, -20)
resizeHandle.BackgroundTransparency = 1
resizeHandle.Text = "↘"
resizeHandle.TextColor3 = Color3.fromRGB(150, 150, 150)
resizeHandle.Font = Enum.Font.GothamBold
resizeHandle.TextSize = 18
resizeHandle.Parent = main

local bottomBar = Instance.new("Frame")
bottomBar.Size = UDim2.new(1, -30, 0, 35)
bottomBar.Position = UDim2.new(0, 15, 1, -45)
bottomBar.BackgroundColor3 = Color3.fromRGB(80, 90, 110)
bottomBar.BackgroundTransparency = 0.3
bottomBar.BorderSizePixel = 0
bottomBar.Parent = main

local bottomCorner = Instance.new("UICorner")
bottomCorner.CornerRadius = UDim.new(0, 8)
bottomCorner.Parent = bottomBar

local icons = {"⌃", "⌘", "↻", "⌂", "◷", "☰", "⚙"}
local iconLayout = Instance.new("UIListLayout")
iconLayout.FillDirection = Enum.FillDirection.Horizontal
iconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
iconLayout.VerticalAlignment = Enum.VerticalAlignment.Center
iconLayout.Padding = UDim.new(0, 20)
iconLayout.Parent = bottomBar

for _, v in ipairs(icons) do
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 40, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = v
    icon.TextColor3 = Color3.new(1, 1, 1)
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 22
    icon.Parent = bottomBar
end

-- Dragging Logic
local dragging, dragInput, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Resizing Logic
local resizing = false
local resizeStart, startSize
resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        resizeStart = input.Position
        startSize = main.AbsoluteSize
    end
end)
UIS.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - resizeStart
        local newWidth = math.max(350, startSize.X + delta.X)
        local newHeight = math.max(250, startSize.Y + delta.Y)
        main.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)

-- Buttons Container
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -40, 1, -110)
buttonContainer.Position = UDim2.new(0, 20, 0, 55)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = main

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = buttonContainer
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.VerticalAlignment = Enum.VerticalAlignment.Center

local function createStyledButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 250, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(8, 15, 25)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.LayoutOrder = order
    btn.AutoButtonColor = true
    btn.Parent = buttonContainer

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(70, 70, 70)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.5
    btnStroke.Parent = btn

    return btn
end

local flyBtn = createStyledButton("Stealth Fly: OFF [ F ]", 1)
local colBtn = createStyledButton("Disable Wall Collisions", 2)
local openTpBtn = createStyledButton("Player Teleport Menu", 3)
local mouseTpBtn = createStyledButton("Mouse Click-Teleport: OFF", 4)
local invisBtn = createStyledButton("Ghost Mode (Invis): OFF", 5)

-- Share variables with other files seamlessly
_G.SecuritySystem = {
    UIS = UIS,
    Players = Players,
    RunService = RunService,
    player = player,
    mouse = mouse,
    gui = gui,
    main = main,
    flyBtn = flyBtn,
    colBtn = colBtn,
    openTpBtn = openTpBtn,
    mouseTpBtn = mouseTpBtn,
    invisBtn = invisBtn
}
