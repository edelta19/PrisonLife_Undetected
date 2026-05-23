local context = _G.SecuritySystem
local player = context.player
local invisBtn = context.invisBtn

local isInvisible = false
local originalTransparencies = {}

invisBtn.MouseButton1Click:Connect(function()
    local character = player.Character
    -- SAFELY CHECK: If character or root part is missing, don't break
    if not character or not character:FindFirstChild("HumanoidRootPart") then 
        warn("Character not fully loaded yet!")
        return 
    end

    isInvisible = not isInvisible

    if isInvisible then
        invisBtn.Text = "Ghost Mode (Invis): ON"
        invisBtn.BackgroundColor3 = Color3.fromRGB(30, 80, 40)
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                if not originalTransparencies[part] then
                    originalTransparencies[part] = part.Transparency
                end
                if part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 1
                end
            end
        end
    else
        invisBtn.Text = "Ghost Mode (Invis): OFF"
        invisBtn.BackgroundColor3 = Color3.fromRGB(8, 15, 25)
        
        for _, part in pairs(character:GetDescendants()) do
            if originalTransparencies[part] then
                part.Transparency = originalTransparencies[part]
            end
        end
    end
end)
