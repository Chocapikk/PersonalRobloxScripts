-- Game ID: 11397035899

getgenv().autoCollectEnabled = true
getgenv().autoHeartDepositEnabled = true
getgenv().autoMergeEnabled = true
getgenv().autoBuyUnicornsEnabled = true
getgenv().autoRatePurchaseEnabled = true
getgenv().infiniteJumpEnabled = true
getgenv().clickTpEnabled = true
getgenv().BuyUnicornsAmount = 1

-------------------- Config ----------------------

function walkSpeed(speed)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
end

function teleportTo(player)    
    local localPlayer = game.Players.LocalPlayer
    localPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame  
    wait()        
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

function autoRatePurchase()
    spawn(function()
        while wait(0.001) do
            if not autoRatePurchaseEnabled then return end
            game:GetService("ReplicatedStorage").Knit.Services.TycoonService.RF.RequestRatePurchase:InvokeServer()
        end
    end)
end

function autoCollect()
    spawn(function()
        local character = game.Players.LocalPlayer.Character
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local tycoons = game:GetService("Workspace").Tycoons

        while wait(0.001) do
            if not autoCollect then break end
            for i = 1, 8 do
                local tycoonName = "Tycoon_" .. tostring(i)
                local tycoon = tycoons[tycoonName]
                if tycoon then
                    local units = tycoon:FindFirstChild("Units")
                    if units then
                        for j, unit in pairs(units:GetChildren()) do
                            firetouchinterest(humanoidRootPart, unit, 0)
                        end
                    end
                end
            end
        end
    end)
end

function autoHeartDeposit()
    spawn(function()
        while wait(0.001) do
            if not autoHeartDepositEnabled then break end
            game:GetService("ReplicatedStorage").Knit.Services.TycoonService.RF.DepositUnits:InvokeServer()
        end
    end)
end

function autoMerge()
    spawn(function()
        while wait(0.001) do
            if not autoMergeEnabled then break end
            game:GetService("ReplicatedStorage").Knit.Services.TycoonService.RF.RequestMerge:InvokeServer()
        end
    end)
end

function autoBuyUnicorns(quantity)
    spawn(function()
        while wait(0.001) do
            if not autoBuyUnicornsEnabled then break end
            game:GetService("ReplicatedStorage").Knit.Services.TycoonService.RF.RequestNodePurchase:InvokeServer(quantity)
        end
    end)
end

-------------------- Functions ----------------------

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

local Window = OrionLib:MakeWindow({Name = "🦄 Unicorn Tycoon Exploit by Balgo", HidePremium = false, SaveConfig = true, ConfigFolder = "UnicornTycoon", IntroText = "❗️ Balgo Security"})
local Auto = Window:MakeTab({
	Name = "Auto",
	Icon = "rbxassetid://11560341824",
	PremiumOnly = false
})

Auto:AddToggle({
	Name = "🚗 Auto Collect",
	Callback = function(Value)
        autoCollectEnabled = Value
        autoCollect()
  	end    
})

Auto:AddToggle({
	Name = "❤️ Auto Heart Deposit",
	Callback = function(Value)
		autoHeartDepositEnabled = Value
        autoHeartDeposit()
  	end    
})

Auto:AddToggle({
	Name = "🔀 Auto Merge",
	Callback = function(Value)
		autoMergeEnabled = Value
        autoMerge()
  	end    
})

Auto:AddToggle({
	Name = "🦄 Auto Buy Unicorns",
	Callback = function(Value)
		autoBuyUnicornsEnabled = Value
        autoBuyUnicorns(BuyUnicornsAmount)
  	end    
})

Auto:AddSlider({
	Name = "🦄 Buy Unicorns",
	Min = 1,
	Max = 600,
	Default = 1,
	Color = Color3.fromRGB(51, 204, 51),
	Increment = 1,
	ValueName = "Unicorns",
	Callback = function(Value)
		BuyUnicornsAmount = Value
	end    
})

Auto:AddToggle({
	Name = "⭐️ Auto Rate Purchase",
	Callback = function(Value)
		autoRatePurchaseEnabled = Value
        autoRatePurchase()
  	end    
})

local Misc = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://11560341824",
	PremiumOnly = false
})

Misc:AddToggle({
	Name = "🖱️ Control Click TP",
	Callback = function()
        clickTpEnabled = not clickTpEnabled
        game:GetService("UserInputService").InputBegan:Connect(teleportLocalPlayer)
  	end    
})

Misc:AddToggle({
	Name = "⚡️ Infinite Jump",
	Callback = function()
		infiniteJumpEnabled = not infiniteJumpEnabled
        infiniteJump()
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

-------------------- UI ----------------------
