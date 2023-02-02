getgenv().autoOrbsEnabled = true
getgenv().autoRebirthEnabled = true
getgenv().autoClickEnabled = true
getgenv().autoBuyEnabled = true
getgenv().infiniteJumpEnabled = true


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

function autoBuy()
    task.spawn(function()
        while wait() do
            if not autoBuyEnabled then break end
            game:GetService("ReplicatedStorage").Remotes.CanBuyEgg:InvokeServer("EggFive")
        end
    end)
end

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "First GUI Exploit for SpeedRun Simulator by Balgo", HidePremium = false, SaveConfig = true, ConfigFolder = "SpeedRunSimulator", })

local Auto = Window:MakeTab({
	Name = "Auto",
	Icon = "rbxassetid://259820115",
	PremiumOnly = false
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
        autoBuy()
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
