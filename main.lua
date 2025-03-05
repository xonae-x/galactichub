local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Pentagon Client",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Pentagon Client",
    LoadingSubtitle = "By Milk",
    Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes
 
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
 
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "PentagonClient"
    },
 
    Discord = {
       Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
       Invite = "eKHSfEjq8G", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
       RememberJoins = false -- Set this to false to make them join the discord every time they load it up
    },
 
    KeySystem = true, -- Set this to true to use our key system
    KeySettings = {
       Title = "Pentagon Client",
       Subtitle = "Key System",
       Note = "Key = sigma", -- Use this to tell the user how to get a key
       FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"cyads1823AHbd18Aa"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })

 local Tab = Window:CreateTab("Main")
 local Section = Tab:CreateSection("ESP")

 local ESPEnabled = false

local function highlightButtons()
    for _, button in pairs(workspace:GetDescendants()) do
        if button:IsA("BasePart") and button.Name:lower():find("button") then
            if not button:FindFirstChildOfClass("Highlight") then
                local highlight = Instance.new("Highlight")
                highlight.Parent = button
                highlight.FillTransparency = 1 -- Makes the inside invisible
                highlight.OutlineColor = Color3.fromRGB(138, 43, 226) -- Purple outline
                highlight.OutlineTransparency = 0 -- Fully visible outline
            end
        end
    end
end

-- Toggle System Implementation
local Toggle = Tab:CreateToggle({
    Name = "ESP Toggle",
    CurrentValue = false,
    Flag = "Toggle1", -- Unique identifier for saving settings
    Callback = function(Value)
        ESPEnabled = Value
        if ESPEnabled then
            highlightButtons() -- Run once when enabled
        else
            -- Remove highlights when disabled
            for _, button in pairs(workspace:GetDescendants()) do
                if button:IsA("BasePart") and button.Name:lower():find("button") then
                    local highlight = button:FindFirstChildOfClass("Highlight")
                    if highlight then
                        highlight:Destroy()
                    end
                end
            end
        end
    end,
})


local Tab = Window:CreateTab("Players")
local Section = Tab:CreateSection("Fly")
 local Players = game:GetService("Players")
 local RunService = game:GetService("RunService")
 local UserInputService = game:GetService("UserInputService")
 
 local player = Players.LocalPlayer
 local character = player.Character or player.CharacterAdded:Wait()
 local hrp = character:WaitForChild("HumanoidRootPart")
 
 local FlyEnabled = false
 local FlightSpeed = 10
 local flying = false
 local bodyVelocity, bodyGyro
 
 -- Function to start/stop flying
 local function toggleFly(state)
     FlyEnabled = state
     if FlyEnabled then
         if not flying then
             flying = true
             bodyVelocity = Instance.new("BodyVelocity")
             bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
             bodyVelocity.Velocity = Vector3.new(0, 0, 0)
             bodyVelocity.Parent = hrp
 
             bodyGyro = Instance.new("BodyGyro")
             bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
             bodyGyro.CFrame = hrp.CFrame
             bodyGyro.Parent = hrp
 
             -- Flight movement update loop
             RunService.RenderStepped:Connect(function()
                 if not FlyEnabled then return end
                 local camera = workspace.CurrentCamera
                 local direction = Vector3.zero
                 local moveVector = Vector3.zero
 
                 -- WASD Movement
                 if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                     moveVector = moveVector + camera.CFrame.LookVector
                 end
                 if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                     moveVector = moveVector - camera.CFrame.LookVector
                 end
                 if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                     moveVector = moveVector - camera.CFrame.RightVector
                 end
                 if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                     moveVector = moveVector + camera.CFrame.RightVector
                 end
                 
                 -- Normalize movement & apply speed
                 if moveVector.Magnitude > 0 then
                     moveVector = moveVector.Unit * FlightSpeed
                 end
 
                 bodyVelocity.Velocity = moveVector
                 bodyGyro.CFrame = camera.CFrame
             end)
         end
     else
         if flying then
             flying = false
             if bodyVelocity then bodyVelocity:Destroy() end
             if bodyGyro then bodyGyro:Destroy() end
         end
     end
 end
 
 -- Fly Toggle
 local Toggle = Tab:CreateToggle({
     Name = "Fly",
     CurrentValue = false,
     Flag = "FlyToggle1",
     Callback = function(Value)
         toggleFly(Value)
     end,
 })
 
 -- Flight Speed Slider
 local Slider = Tab:CreateSlider({
     Name = "Flight Speed",
     Range = {0, 100},
     Increment = 10,
     Suffix = " Flight Speed",
     CurrentValue = 10,
     Flag = "FlightSlider1",
     Callback = function(Value)
         FlightSpeed = Value
     end,
 })
 
 
 local Section = Tab:CreateSection("Player Adjustments")

 local Players = game:GetService("Players")
 local player = Players.LocalPlayer
 
 local Slider = Tab:CreateSlider({
     Name = "Walkspeed",
     Range = {0, 100},
     Increment = 10,
     Suffix = " Walkspeed",
     CurrentValue = 10,
     Flag = "WalkspeedSlider1",
     Callback = function(Value)
         if player.Character and player.Character:FindFirstChild("Humanoid") then
             player.Character.Humanoid.WalkSpeed = Value
         end
     end,
 })
 

 local Slider = Tab:CreateSlider({
    Name = "Jump Height",
    Range = {0, 50}, -- Adjust as needed
    Increment = 5,
    Suffix = " Jump Height",
    CurrentValue = 10,
    Flag = "JumpHeightSlider1",
    Callback = function(Value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.UseJumpPower = false -- Switch to JumpHeight system
            player.Character.Humanoid.JumpHeight = Value
        end
    end,
})
