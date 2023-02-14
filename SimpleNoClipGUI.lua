local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart

local function isDescendantOfTerrain(part)
    local terrain = game.Workspace.Terrain
    return terrain and terrain:IsAncestorOf(part)
end

local noClipEnabled = false

local switch = Instance.new("BoolValue")
switch.Name = "NoClipEnabled"
switch.Parent = player

switch:GetPropertyChangedSignal("Value"):Connect(function()
    noClipEnabled = switch.Value
end)

local gui = Instance.new("ScreenGui")
gui.Name = "NoClipGui"
gui.Parent = game.CoreGui

local button = Instance.new("TextButton")
button.Name = "NoClipButton"
button.Text = "NoClip: OFF"
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.9, -25)
button.BackgroundTransparency = 0
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
button.BorderColor3 = Color3.new(0, 0, 0)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSans
button.TextSize = 24
button.TextWrapped = true
button.ClipsDescendants = true
button.AutoButtonColor = false
button.Parent = gui

button.MouseButton1Click:Connect(function()
    switch.Value = not switch.Value
    button.Text = "NoClip: " .. (switch.Value and "ON" or "OFF")
    button.BackgroundColor3 = switch.Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

game:GetService("RunService").Stepped:Connect(function()
    if noClipEnabled then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and not isDescendantOfTerrain(part) then
                part.CanCollide = false
            end
        end
    end
end)
