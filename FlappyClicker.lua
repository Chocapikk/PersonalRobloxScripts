-- Game ID: 11620947043

getgenv().autoClickEnabled = true
getgenv().autoBuyEggsEnabled = true
getgenv().autoBuyTrailsEnabled = true
getgenv().autoBuyLandsEnabled = true
getgenv().autoRebirthEnabled = true
getgenv().clickTpEnabled = true
-------------------- Config ----------------------

function walkSpeed(speed)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
end

function teleportTo(player)    
    local localPlayer = game.Players.LocalPlayer
    localPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame  
    wait()        
end

function teleportLocalPlayerBypass(speed)
    if speed == 0 then clickTpBypassEnabled = false return end
    clickTpBypassEnabled = true

    local bodyVelocityEnabled = true
    local UserInputService = game:GetService("UserInputService")
    local localPlayer = game.Players.LocalPlayer
    local mouse = localPlayer:GetMouse()
    local TweenService = game:GetService("TweenService")

    function toPosition(position)
        local character = localPlayer.Character
        if character then
            local humanoidRootPart = character.HumanoidRootPart
            local distance = (humanoidRootPart.Position - mouse.Hit.p).magnitude
            local tweenSpeed = distance / speed
            local tweenInfo = TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear)
            local tweenProperties = {CFrame = CFrame.new(position)}
            TweenService:Create(humanoidRootPart, tweenInfo, tweenProperties):Play()
            if bodyVelocityEnabled then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Parent = humanoidRootPart
                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                wait(tweenSpeed)
                bodyVelocity:Destroy()
            end
        end
    end
    UserInputService.InputBegan:Connect(function(input)
        if clickTpBypassEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            local position = mouse.Hit.p
            toPosition(position)
        end
    end)    
end

function teleportLocalPlayer(input)
    local Player = game.Players.LocalPlayer
    local Mouse = Player:GetMouse()
    local UIS = game:GetService("UserInputService")
    if clickTpEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
       local Char = Player.Character
       if Char then
          Char:MoveTo(Mouse.Hit.p)
       end
    end
 end

function noClip()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart

    local function isDescendantOfTerrain(part)
        local terrain = game.Workspace.Terrain
        return terrain and terrain:IsAncestorOf(part)
    end

    game:GetService("RunService").Stepped:Connect(function()
        if noClipEnabled then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") and not isDescendantOfTerrain(part) then
                    part.CanCollide = false
                end
            end
        end
    end)
end 

function getEggs()
    local result = {"Disable"}
    for i,v in pairs(game:GetService("Workspace").Prompts.PetPrompts:GetChildren()) do
        table.insert(result, tostring(v.Name))
   end
   return result 
end

function getTrails()
    local result = {"Disable"}
    for i,v in pairs(game:GetService("Workspace").Prompts.TrailPrompts:GetChildren()) do
        table.insert(result, tostring(v.Name))
   end
   return result 
end

function getLands()
    local result = {"Disable"}
    for i,v in pairs(game:GetService("ReplicatedStorage").Zones:GetChildren()) do
        table.insert(result, tostring(v.Name))
   end
   return result 
end

function autoClick()
    task.spawn(function()
        while wait(0.001) do
            if not autoClickEnabled then break end
            game:GetService("ReplicatedStorage").Remotes.Click:FireServer()
        end
    end)
end

function autoBuyEggs(egg)
    task.spawn(function()
        while wait(0.001) do
            if not autoBuyEggsEnabled then break end
            game:GetService("ReplicatedStorage").Remotes.Hatcher.HatchPet:InvokeServer(egg, 1, {})
        end
    end)
end

function autoBuyTrails(trail)
    task.spawn(function()
        while wait(0.001) do
            if not autoBuyTrailsEnabled then break end
            game:GetService("ReplicatedStorage").Remotes.Chest.OpenTrail:InvokeServer(trail, 1, {})
        end
    end)
end

function autoBuyLands(land)
    task.spawn(function()
        local lands = getLands()
        if not autoBuyLandsEnabled then return end
        for i, land in pairs(lands) do
            game:GetService("ReplicatedStorage").Remotes.Zones.BuyZone:FireServer(land)
        end
    end)
end 

function autoRebirth()
    task.spawn(function()
        while wait(0.001) do
            if not autoRebirthEnabled then break end
            game:GetService("ReplicatedStorage").Remotes.Rebirth:FireServer()
        end
    end)
end

function teleportToLand(land)
    game:GetService("ReplicatedStorage").Remotes.Zones.Teleport:FireServer(land)
end

function submitCodes()
    local code = {"CREPTIEZ", "Release"}
    task.spawn(function()
        for i,v in pairs(codes) do
            game:GetService("ReplicatedStorage").Modules.Shared.TwitterCodeModule.EnterCode:InvokeServer(v)
        end
    end)
end

local settings = require(game:GetService("ReplicatedStorage").Modules.Client.Settings)

function setTrading(state)
    settings.Trading.CurrentState = state
end

function setCoinAnimation(state)
    if state then state = "Off" else state = "On" end
    settings.CoinAnimation.CurrentState = state 
end

function setSoundEffects()
    game:GetService("ReplicatedStorage").Modules.Client.Settings.SoundEffects:Fire()
end
-------------------- Functions ----------------------

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local CustomTheme = {
    Main = Color3.fromRGB(196,192,56),
    Second = Color3.fromRGB(0,0,0),
    Stroke = Color3.fromRGB(0,247,255),
    Divider = Color3.fromRGB(0,249,31),
    Text = Color3.fromRGB(255,255,255),
    TextDark = Color3.fromRGB(109,130,124)
}
    
OrionLib.Themes["Custom"] = CustomTheme
OrionLib.SelectedTheme = "Custom"

local Window = OrionLib:MakeWindow({
    Name = "🏆 Flappy Clicker Exploit by Balgo", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "FlappyClicker", 
    IntroText = "❗️ Balgo Security"
})

local Auto = Window:MakeTab({
	Name = "Auto",
	Icon = "rbxassetid://11560341824",
	PremiumOnly = false
})

Auto:AddToggle({
	Name = "🖱️ Auto Click",
	Callback = function(Value)
        autoClickEnabled = Value
        autoClick()
  	end    
})

Auto:AddToggle({
	Name = "✨ Auto Rebirth",
	Callback = function(Value)
        autoRebirthEnabled = Value
        autoRebirth()
  	end    
})

Auto:AddToggle({
	Name = "🗺️ Auto Buy Lands",
	Callback = function(Value)
        autoBuyLandsEnabled = Value
        autoBuyLands()
  	end    
})

Auto:AddDropdown({
    Name = "🐱 Auto Buy Eggs",
    Options = getEggs(),
    Callback = function(egg)
        if egg == "Disable" then
            autoBuyEggsEnabled = false
            return
        end
        autoBuyEggs(egg)
    end
})

Auto:AddDropdown({
    Name = "🌠 Auto Buy Trails",
    Options = getTrails(),
    Callback = function(trail)
        if trail == "Disable" then
            autoBuyTrailsEnabled = false
            return
        end
        autoBuyTrails(trail)
    end
})

Auto:AddDropdown({
    Name = "🗺️ Teleport To Land",
    Options = getLands(),
    Callback = function(land)
        teleportToLand(land)
    end
})

Auto:AddButton({
    Name = "🎁 Auto Redeem Codes",
    Callback = function()
        submitCodes()
    end
})

local Misc = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://11560341824",
	PremiumOnly = false
})

Misc:AddSlider({
	Name = "🖱️ Control Click TP Bypass",
	Min = 0,
	Max = 350,
	Default = 0,
	Color = Color3.fromRGB(51, 204, 51),
	Increment = 50,
	ValueName = "Speed (0 To Disable)",
	Callback = function(speed)
		teleportLocalPlayerBypass(speed)
	end    
})

Misc:AddSlider({
	Name = "👣 Walk Speed",
	Min = 32,
	Max = 600,
	Default = 32,
	Color = Color3.fromRGB(51, 204, 51),
	Increment = 1,
	ValueName = "Walk Speed",
	Callback = function(Value)
		walkSpeed(Value)
	end    
})

Misc:AddToggle({
	Name = "🖱️ Control Click TP",
	Callback = function(Value)
        clickTpEnabled = Value
        game:GetService("UserInputService").InputBegan:Connect(teleportLocalPlayer)
  	end    
})

Misc:AddToggle({
	Name = "👻 NoClip",
	Callback = function(Value)
		noClipEnabled = Value
        noClip()
  	end    
})

Misc:AddSection({
    Name = "🌌 Teleport To A Player"
})

local playerMap = {}
local playerDropdown = Misc:AddDropdown({
    Name = "👥 Select a player",
    Options = {},
    Callback = function(selectedPlayer)
        local player = playerMap[selectedPlayer]
        if player then
            teleportTo(player)
        end
    end
})

Misc:AddButton({
    Name = "🔄 Refresh Players",
    Callback = function()
        playerMap = {}
        local playerOptions = {}
        for i, player in ipairs(game.Players:GetPlayers()) do
            table.insert(playerOptions, player.Name)
            playerMap[player.Name] = player
        end
        playerDropdown:Refresh(playerOptions, true)
    end
})

local Settings = Window:MakeTab({
	Name = "Settings",
	Icon = "rbxassetid://7059346373",
	PremiumOnly = false
})

Settings:AddDropdown({
    Name = "⚖️ Set Trading State",
    Options = {"All", "Friends", "Off"},
    Callback = function(state)
        setTrading(state)
    end
})

Settings:AddToggle({
    Name = "💰 Disable Coin Animation",
    Callback = function(state)
        setCoinAnimation(state)
    end
})

Settings:AddButton({
    Name = "🔇 Disable Sound Effects",
    Callback = function()
        setSoundEffects()
    end
})

-------------------- UI ----------------------
