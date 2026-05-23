local context = _G.SecuritySystem
local player = context.player
local mouse = context.mouse
local mouseTpBtn = context.mouseTpBtn

local mouseTpActive = false

mouseTpBtn.MouseButton1Click:Connect(function()
    mouseTpActive = not mouseTpActive
    if mouseTpActive then
        mouseTpBtn.Text = "Mouse Click-Teleport: ON"
        mouseTpBtn.BackgroundColor3 = Color3.fromRGB(30, 80, 40) 
    else
        mouseTpBtn.Text = "Mouse Click-Teleport: OFF"
        mouseTpBtn.BackgroundColor3 = Color3.fromRGB(8, 15, 25) 
    end
end)

mouse.Button1Down:Connect(function()
    if not mouseTpActive then return end 
    
    local targetPart = mouse.Target
    if targetPart and targetPart.Parent then
        local humanoid = targetPart.Parent:FindFirstChild("Humanoid")
        local targetHrp = targetPart.Parent:FindFirstChild("HumanoidRootPart")
        
        if humanoid and targetHrp and targetPart.Parent ~= player.Character then
            local myChar = player.Character
            if myChar then
                local myHrp = myChar:FindFirstChild("HumanoidRootPart")
                if myHrp then
                    myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 3, 4)
                end
            end
        end
    end
end)
