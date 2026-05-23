local context = _G.SecuritySystem
local player = context.player
local invisBtn = context.invisBtn

local isInvisible = false
local originalTransparencies = {}

invisBtn.MouseButton1Click:Connect(function()
    -- ALWAYS get the live character model when clicked
    local character = player.Character or player.CharacterAdded:Wait()
    if not character then 
        warn("Ghost Mode: Character model missing!")
        return 
    end

    local hrp = character:WaitForChild("HumanoidRootPart", 3)
    if not hrp then
        warn("Ghost Mode: HumanoidRootPart missing!")
        return
    end

    isInvisible = not isInvisible

    if isInvisible then
        invisBtn.Text = "Ghost Mode (Invis): ON"
        invisBtn.BackgroundColor3 = Color3.fromRGB(30, 80, 40)
        
        for _, part in pairs(character:GetDescendants()) do
            if part and (part:IsA("BasePart") or part:IsA("Decal")) then
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
            if part and originalTransparencies[part] then
                part.Transparency = originalTransparencies[part]
            end
        end
        table.clear(originalTransparencies)
    end
end)
