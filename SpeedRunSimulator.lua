-- Game ID: 7047488135

getgenv().autoOrbsEnabled = true
getgenv().autoRebirthEnabled = true
getgenv().autoClickEnabled = true
getgenv().autoBuyEnabled = true
getgenv().autoUpgradeEnabled = true
getgenv().infiniteJumpEnabled = true
getgenv().setTradingEnabled = true


function getPlayers()
    for i, player in ipairs(game.Players:GetPlayers()) do
        table.insert(player, playerTable)
    end
    return playerTable
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

function autoOrbs()
    task.spawn(function()
        local character = game.Players.LocalPlayer.Character
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

        while wait() do
            if not autoOrbsEnabled then break end
            for i,v in pairs(game:GetService("Workspace").OrbSpawns:GetChildren()) do
                firetouchinterest(humanoidRootPart, v, 0)
            end
        end
    end)
end

function autoRebirth()
    task.spawn(function() 
        while wait() do
            if not autoRebirthEnabled then break end
            game:GetService("ReplicatedStorage").Remotes.Rebirth:FireServer()
        end
    end)
end


function autoClick()
    task.spawn(function()
        while wait() do
            if not autoClickEnabled then break end
            game:GetService("ReplicatedStorage").Remotes.AddSpeed:FireServer()
        end
    end)
end

function autoBuy(egg)
    task.spawn(function()
        while wait() do
            if not autoBuyEnabled then break end
            game:GetService("ReplicatedStorage").Remotes.CanBuyEgg:InvokeServer(egg)
        end
    end)
end

function autoUpgrade(egg)
    listEgg = {"", "D", "G", "E", "R"}
    while wait() do
        if not autoUpgradeEnabled then break end
        for i,v in pairs(listEgg) do
            newEgg = egg..v
            game:GetService("ReplicatedStorage").Remotes.UpgradePet:FireServer(newEgg)
        end
    end
end

function setTrading()
    local enabled = "Off"
    if setTradingEnabled then enabled = "On" end
    game:GetService("ReplicatedStorage").Remotes.EnableTrading:FireServer(enabled)
end


local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "First GUI Exploit for SpeedRun Simulator by Balgo", HidePremium = false, SaveConfig = true, ConfigFolder = "SpeedRunSimulator", IntroText = "Balgo Security"})

local Auto = Window:MakeTab({
	Name = "Auto",
	Icon = "rbxassetid://259820115",
	PremiumOnly = false
})


Auto:AddToggle({
	Name = "Enable Trading",
	Callback = function()
		setTradingEnabled = not setTradingEnabled
        setTrading()
  	end    
})

Auto:AddToggle({
	Name = "Auto Clicker",
	Callback = function()
		autoClickEnabled = not autoClickEnabled
        autoClick()
  	end    
})
Auto:AddToggle({
	Name = "Auto Rebirth",
	Callback = function()
		autoRebirthEnabled = not autoRebirthEnabled
        autoRebirth()
  	end    
})
Auto:AddToggle({
	Name = "Auto Collect Orbs (Only Synapse X)",
	Callback = function()
		autoOrbsEnabled = not autoOrbsEnabled
        autoOrbs()
  	end    
})
Auto:AddToggle({
	Name = "Auto Buy Eggs",
	Callback = function()
		autoBuyEnabled = not autoBuyEnabled
  	end    
})
Auto:AddDropdown({
	Name = "Buy Eggs",
	Default = "EggOne",
	Options = {"EggOne","EggTwo","EggThree", "EggFour", "EggFive", "EggSix", "EggSeven", "EggEight", "EggNine", "EggTen", "EggEleven"},
	Callback = function(value)
        autoBuy(value)
	end    
})

Auto:AddToggle({
	Name = "Auto Upgrade Eggs",
	Callback = function()
		autoUpgradeEnabled = not autoUpgradeEnabled
  	end    
})

Auto:AddDropdown({
	Name = "Auto Upgrade",
	Default = "Phoenix",
	Options = {'Baby Chick', 'Cat', 'Chicken', 'Cloud', 'Cow', 'Cupid', 'Detective', 'Dragon', 'Elf', 'Fire Bunny', 'Fire King', 'Giraffe', 'Gnome', 'Horse', 'Ice Bat', 'Ice King', 'Mummy', 'Officer', 'Pharaoh', 'Phoenix', 'Pig', 'Piggy', 'Plant', 'Professor', 'Santa', 'Satan', 'Scorpion', 'Skeleton', 'Troll', 'Vampire', 'Wizard', 'Yeti'},
	Callback = function(value)
        autoUpgrade(value)
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
