--Game ID: 11767933308

getgenv().addPowerEnabled = true
getgenv().autoClickEnabled = true
getgenv().infiniteJumpEnabled = true
getgenv().clickTpEnabled = true
getgenv().clickTpBypassEnabled = true
getgenv().noClipEnabled = true

--// Not Done //--

---------------- Config ----------------

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

function infiniteJump()
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if not infiniteJumpEnabled then return end
            game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end)
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

function addPower()
	task.spawn(function()
		local player = game:GetService("Players").LocalPlayer
		while wait(0.001) do
			if not addPowerEnabled then break end
			game:GetService("ReplicatedStorage").Knif.Knit.Services.PlayerService.RF.AddPlayerPower:InvokeServer(player)
		end
	end)
end

function autoClick()
	local VirtualInputManager = game:GetService("VirtualInputManager")
	local Mouse = game.Players.LocalPlayer:GetMouse()
    local Interval = 0.3
    local X, Y = 0, 0
    local Last = tick()
    while autoClickEnabled do
        VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y + 10, 0, true, game, 1)
        VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y + 10, 0, false, game, 1)
        wait(Interval)
    end
end

---------------- Functions ----------------

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local CustomTheme = {
    Main = Color3.fromRGB(131,58,180),
    Second = Color3.fromRGB(0,0,0),
    Stroke = Color3.fromRGB(0,249,31),
    Divider = Color3.fromRGB(0,249,31),
    Text = Color3.fromRGB(255,255,255),
    TextDark = Color3.fromRGB(109,130,124)
}
    
OrionLib.Themes["Custom"] = CustomTheme
OrionLib.SelectedTheme = "Custom"

local Window = OrionLib:MakeWindow({Name = "👊Smash & Grab Simulator Exploit by Balgo", HidePremium = false, SaveConfig = true, ConfigFolder = "SmashnGrabSim", IntroText = "❗️ Balgo Security"})
local Auto = Window:MakeTab({
	Name = "Auto",
	Icon = "rbxassetid://11560341824",
	PremiumOnly = false
})

Auto:AddToggle({
	Name = "Auto Win Power",
	Callback = function(Value)
        addPowerEnabled = Value
        addPower()
  	end    
})

Auto:AddBind({
	Name = "Auto Click",
	Default = Enum.KeyCode.E,
	Hold = false,
	Callback = function()
		autoClickEnabled = not autoClickEnabled
        autoClick()
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
	Name = "⚡️ Infinite Jump",
	Callback = function(Value)
		infiniteJumpEnabled = Value
        infiniteJump()
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
---------------- UI ----------------
