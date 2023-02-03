getgenv().autoCollectEnabled = true
getgenv().autoSellEnabled = true
getgenv().infiniteJumpEnabled = true
-------- Config -------------------

function walkSpeed(speed)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
end

function teleportTo(player)    
    local localPlayer = game.Players.LocalPlayer
    localPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame  
    wait()        
end

function infiniteJump()
    task.spawn(function()
        local character = game.Players.LocalPlayer.Character
        local humanoid = character:FindFirstChild("Humanoid")
        while true do
            if not infiniteJumpEnabled then break end
            if humanoid.Jump and humanoid.FloorMaterial == Enum.Material.Air then
                humanoid.JumpPower = 50
                humanoid:ChangeState("Jumping")
            end
            wait()
        end
    end)
end

function autoCollect()
    spawn(function() 
        while wait() do
            if not autoCollectEnabled then break end
            for tycoonIndex = 1, 8 do
                for i, item in pairs(workspace.Tycoons:FindFirstChild(tostring(tycoonIndex)).ItemDebris:GetChildren()) do
                    local args = {[1] = item}
                    game:GetService("ReplicatedStorage").RF.CollectItem:InvokeServer(unpack(args))
                end
            end
        end
    end)
end


function autoSell()
    spawn(function()
        local character = game.Players.LocalPlayer.Character
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        while wait() do
            if not autoSellEnabled then break end
            for tycoonIndex = 1, 8 do
                for i,v in pairs(game:GetService("Workspace").Tycoons[tycoonIndex].SellPad:GetChildren()) do
                    firetouchinterest(humanoidRootPart,  v, 0)
                    firetouchinterest(humanoidRootPart,  v, 1)
                end
            end
        end
    end)
end

----------- Functions ------------------

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Feed The Noob Tycoon Exploit By Balgo", HidePremium = false, SaveConfig = true, ConfigFolder = "SpeedRunSimulator", IntroText = "Balgo Security"})

local Auto = Window:MakeTab({
	Name = "Auto",
	Icon = "rbxassetid://259820115",
	PremiumOnly = false
})


Auto:AddToggle({
	Name = "Auto Collect",
	Callback = function(value)
		autoCollectEnabled = value
        autoCollect()
  	end    
})

Auto:AddToggle({
	Name = "Auto Sell",
	Callback = function(value)
		autoSellEnabled = value
        autoSell()
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
	Min = 16,
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
------------- UI ----------------
