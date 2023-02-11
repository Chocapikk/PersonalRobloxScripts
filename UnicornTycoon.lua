-- Game ID: 11397035899

getgenv().autoCollectEnabled = true
getgenv().autoHeartDepositEnabled = true
getgenv().autoMergeEnabled = true
getgenv().autoBuyUnicornsEnabled = true
getgenv().autoRatePurchaseEnabled = true
getgenv().infiniteJumpEnabled = true

-------------------- Config ----------------------

function walkSpeed(speed)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
end

function teleportTo(player)    
    local localPlayer = game.Players.LocalPlayer
    localPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame  
    wait()        
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
local Window = OrionLib:MakeWindow({Name = "Unicorn Tycoon Exploit by Balgo", HidePremium = false, SaveConfig = true, ConfigFolder = "SpeedRunSimulator", IntroText = "Balgo Security"})
local Auto = Window:MakeTab({
	Name = "Auto",
	Icon = "rbxassetid://259820115",
	PremiumOnly = false
})

Auto:AddToggle({
	Name = "Auto Collect",
	Callback = function(Value)
        autoCollectEnabled = Value
        autoCollect()
  	end    
})

Auto:AddToggle({
	Name = "Auto Heart Deposit",
	Callback = function(Value)
		autoHeartDepositEnabled = Value
        autoHeartDeposit()
  	end    
})

Auto:AddToggle({
	Name = "Auto Merge",
	Callback = function(Value)
		autoMergeEnabled = Value
        autoMerge()
  	end    
})

Auto:AddToggle({
	Name = "Auto Buy Unicorns",
	Callback = function(Value)
		autoBuyUnicornsEnabled = Value
  	end    
})

Auto:AddSlider({
	Name = "Buy Unicorns",
	Min = 1,
	Max = 600,
	Default = 1,
	Color = Color3.fromRGB(51, 204, 51),
	Increment = 1,
	ValueName = "Unicorns",
	Callback = function(Value)
		autoBuyUnicorns(Value)
	end    
})

Auto:AddToggle({
	Name = "Auto Rate Purchase",
	Callback = function(Value)
		autoRatePurchaseEnabled = Value
        autoRatePurchase()
  	end    
})

local Misc = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://259820115",
	PremiumOnly = false
})

Misc:AddToggle({
	Name = "Infinite Jump",
	Callback = function()
		infiniteJumpEnabled = not infiniteJumpEnabled
        infiniteJump()
  	end    
})

Misc:AddSlider({
	Name = "Walk Speed",
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

local TeleportTo = Window:MakeTab({
	Name = "Teleport Player",
	Icon = "rbxassetid://259820115",
	PremiumOnly = false
})

TeleportTo:AddSection({
    Name = "Teleport To A Player"
})

for i, player in ipairs(game.Players:GetPlayers()) do
    TeleportTo:AddButton({
        Name = player.Name,
        Callback = function()
            teleportTo(player)
        end
    })
end

-------------------- UI ----------------------
