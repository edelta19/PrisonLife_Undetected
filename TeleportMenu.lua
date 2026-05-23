local context = _G.SecuritySystem
local player = context.player
local Players = context.Players
local gui = context.gui
local openTpBtn = context.openTpBtn

local tpMenu = Instance.new("Frame")
tpMenu.Size = UDim2.new(0, 280, 0, 320)
tpMenu.Position = UDim2.new(0.5, -140, 0.5, -160)
tpMenu.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
tpMenu.BackgroundTransparency = 0.15
tpMenu.Visible = false
tpMenu.Parent = gui

Instance.new("UICorner", tpMenu).CornerRadius = UDim.new(0, 10)
local tpStroke = Instance.new("UIStroke", tpMenu)
tpStroke.Color = Color3.fromRGB(70, 70, 70)
tpStroke.Thickness = 1
tpStroke.Transparency = 0.4

local tpTitle = Instance.new("TextLabel")
tpTitle.Size = UDim2.new(1, 0, 0, 40)
tpTitle.BackgroundTransparency = 1
tpTitle.Text = "Select Target"
tpTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
tpTitle.Font = Enum.Font.GothamBold
tpTitle.TextSize = 16
tpTitle.Parent = tpMenu

local closeTpBtn = Instance.new("TextButton")
closeTpBtn.Size = UDim2.new(0, 30, 0, 30)
closeTpBtn.Position = UDim2.new(1, -35, 0, 5)
closeTpBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
closeTpBtn.BackgroundTransparency = 0.2
closeTpBtn.Text = "X"
closeTpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeTpBtn.Font = Enum.Font.GothamBold
closeTpBtn.Parent = tpMenu
Instance.new("UICorner", closeTpBtn).CornerRadius = UDim.new(0, 6)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -50)
scrollFrame.Position = UDim2.new(0, 10, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 4
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = tpMenu

local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Padding = UDim.new(0, 5)
scrollLayout.Parent = scrollFrame

closeTpBtn.MouseButton1Click:Connect(function() tpMenu.Visible = false end)

local function teleportToPlayer(targetPlayer)
    local myChar = player.Character
    local targetChar = targetPlayer.Character
    if myChar and targetChar then
        local myHrp = myChar:FindFirstChild("HumanoidRootPart")
        local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
        if myHrp and targetHrp then
            myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 3, 4)
            tpMenu.Visible = false 
        end
    end
end

openTpBtn.MouseButton1Click:Connect(function()
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, -10, 0, 35)
            pBtn.BackgroundColor3 = Color3.fromRGB(30, 40, 55)
            pBtn.BackgroundTransparency = 0.2
            pBtn.Text = p.DisplayName
            pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            pBtn.Font = Enum.Font.GothamSemibold
            pBtn.TextSize = 13
            pBtn.Parent = scrollFrame
            Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 4)
            pBtn.MouseButton1Click:Connect(function() teleportToPlayer(p) end)
        end
    end
    tpMenu.Visible = not tpMenu.Visible
end)
