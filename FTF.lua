local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Vexis H | Fuckass Test",
    LoadingTitle = "Vexis H | Nigga Teet Edition",
    LoadingSubtitle = "By Tester Who Live Under Rock",
    ConfigurationSaving = {
        Enabled = false,
    },
    Discord = {
        Enabled = true,
        Invite = "YVyfVYGR23",
        RememberJoins = true
    }
})

local MainTab = Window:CreateTab("Main", "construction")
local ESPTab = Window:CreateTab("ESP", "eye")
local ToolsTab = Window:CreateTab("Tools", "hammer")

local podstoggle = false
local pctoggle = false
local playertoggle = false
local bestpctoggle = false
local exitstoggle = false
local beastcamtoggle = false
local neverfailtoggle = false
local autointeracttoggle = false
local autoplaytoggle = false

ESPTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(Value)
        playertoggle = Value
        reloadESP()
    end,
})

ESPTab:CreateToggle({
    Name = "PC ESP",
    CurrentValue = false,
    Flag = "PCESP",
    Callback = function(Value)
        pctoggle = Value
        reloadESP()
    end,
})

ESPTab:CreateToggle({
    Name = "Best PC ESP",
    CurrentValue = false,
    Flag = "BestPCESP",
    Callback = function(Value)
        bestpctoggle = Value
        reloadESP()
    end,
})

ESPTab:CreateToggle({
    Name = "Pods ESP",
    CurrentValue = false,
    Flag = "PodsESP",
    Callback = function(Value)
        podstoggle = Value
        reloadESP()
    end,
})

ESPTab:CreateToggle({
    Name = "Exits ESP",
    CurrentValue = false,
    Flag = "ExitsESP",
    Callback = function(Value)
        exitstoggle = Value
        reloadESP()
    end,
})

-- Tools Section
ToolsTab:CreateToggle({
    Name = "Never Fail",
    CurrentValue = false,
    Flag = "NeverFail",
    Callback = function(Value)
        neverfailtoggle = Value
    end,
})

ToolsTab:CreateToggle({
    Name = "Auto Interact",
    CurrentValue = false,
    Flag = "AutoInteract",
    Callback = function(Value)
        autointeracttoggle = Value
    end,
})

ToolsTab:CreateToggle({
    Name = "Auto Play (Experimental)",
    CurrentValue = false,
    Flag = "AutoPlay",
    Callback = function(Value)
        autoplaytoggle = Value
    end,
})

ToolsTab:CreateToggle({
    Name = "Beast Cam",
    CurrentValue = false,
    Flag = "BeastCam",
    Callback = function(Value)
        beastcamtoggle = Value
        if Value then
            reloadBeastCam()
        else
            if ViewportFrame then
                ViewportFrame:ClearAllChildren()
                ViewportFrame.Visible = false
            end
        end
    end,
})

local ViewportFrame = Instance.new("ViewportFrame")
ViewportFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ViewportFrame.Position = UDim2.new(0, 5, 0.666000009, -5)
ViewportFrame.Size = UDim2.new(0.333, 0, 0.333, 0)
ViewportFrame.Ambient = Color3.fromRGB(147,147,147)
ViewportFrame.LightDirection = Vector3.new(0,1,0)
ViewportFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
ViewportFrame.BackgroundTransparency = 0.9
ViewportFrame.Visible = false
ViewportFrame.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

function reloadESP()
    spawn(function()
        local map = game.ReplicatedStorage.CurrentMap.Value
        if map ~= nil then
        local mapstuff = map:getChildren()
        for i=1,#mapstuff do
            if mapstuff[i].Name == "ComputerTable" then
                if mapstuff[i]:findFirstChild("Highlight") and not pctoggle then
                    mapstuff[i].Highlight:remove()
                end
                if pctoggle and not mapstuff[i]:findFirstChild("Highlight") then
                    local a = Instance.new("Highlight", mapstuff[i])
                    a.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    a.FillColor = Color3.fromRGB(13, 105, 172)
                    a.OutlineColor = Color3.fromRGB(20, 165, 270)
                    spawn(function()
                        repeat 
                            if bestpctoggle and mapstuff[i]:findFirstChild("Screen") then
                                if getBestPC()[1].pc ~= nil and mapstuff[i] == getBestPC()[1].pc then
                                    a.FillColor = mapstuff[i]:findFirstChild("Screen").Color
                                    a.OutlineColor = Color3.fromRGB(200, 0, 255)
                                else
                                    a.FillColor = mapstuff[i]:findFirstChild("Screen").Color
                                    a.OutlineColor = Color3.fromRGB(a.FillColor.R*400, a.FillColor.G*400, a.FillColor.B*400)
                                end
                            else
                                a.FillColor = mapstuff[i]:findFirstChild("Screen").Color
                                a.OutlineColor = Color3.fromRGB(a.FillColor.R*400, a.FillColor.G*400, a.FillColor.B*400)
                            end
                            wait(1)
                        until mapstuff[i] == nil or a == nil
                    end)
                end
            end
            if mapstuff[i].Name == "FreezePod" then
                if mapstuff[i]:findFirstChild("Highlight") and not podstoggle then
                    mapstuff[i].Highlight:remove()
                end
                if podstoggle and not mapstuff[i]:findFirstChild("Highlight") then
                    local a = Instance.new("Highlight", mapstuff[i])
                    a.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    a.FillColor = Color3.fromRGB(120,200,255)
                    a.OutlineColor = Color3.fromRGB(160,255,255)
                end
            end
            if mapstuff[i].Name == "ExitDoor" then
                if mapstuff[i]:findFirstChild("Highlight") and not exitstoggle then
                    mapstuff[i].Highlight:remove()
                end
                if exitstoggle and not mapstuff[i]:findFirstChild("Highlight") then
                    local a = Instance.new("Highlight", mapstuff[i])
                    a.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    a.FillColor = Color3.fromRGB(252, 255, 100)
                    a.OutlineColor = Color3.fromRGB(255,255,160)
                end
            end
            end
            end
    end)
    local player = game.Players:GetChildren()
    for i=1, #player do
        if player[i] ~= game.Players.LocalPlayer and player[i].Character ~= nil then
        local character = player[i].Character
        if character:findFirstChild("Highlight") and not playertoggle then
            character.Highlight:remove()
        end
        if playertoggle and not character:findFirstChild("Highlight") then
            local a = Instance.new("Highlight", character)
            a.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            a.FillColor = Color3.fromRGB(0,255,0)
            a.OutlineColor = Color3.fromRGB(127,255,127)
            spawn(function()
                repeat
                    wait(0.1)
                    if player[i] == getBeast() then
                        a.FillColor = Color3.fromRGB(255,0,0)
                        a.OutlineColor = Color3.fromRGB(255,127,127)
                    else
                        a.FillColor = Color3.fromRGB(0,255,0)
                        a.OutlineColor = Color3.fromRGB(127,255,127)
                    end
                until character == nil or a == nil
            end)
            end
            end
    end
end

function reloadBeastCam()
    ViewportFrame:ClearAllChildren()
    if beastcamtoggle and game.ReplicatedStorage.CurrentMap.Value ~= nil then
        local beast = getBeast()
        local cam = Instance.new("Camera", ScreenGui)
        cam.CameraType = Enum.CameraType.Scriptable
        cam.FieldOfView = 70
        local map = game.ReplicatedStorage.CurrentMap.Value
        local mapclone = map:clone()
        mapclone.Name = "map"
        local mcstuff = mapclone:getDescendants()
        for i=1,#mcstuff do
            if mcstuff[i].Name == "SingleDoor" or mcstuff[i].Name == "DoubleDoor" or mcstuff[i].ClassName == "Sound" or mcstuff[i].ClassName == "LocalScript" or mcstuff[i].ClassName == "Script" then
                mcstuff[i]:remove() 
            end
        end

        mapclone.Parent = ViewportFrame
        ViewportFrame.CurrentCamera = cam

        spawn(function()
            repeat
                wait()
                if not beastcamtoggle then
                    break
                end
                repeat
                    wait()
                until getBeast().Character ~= nil
                cam.CFrame = getBeast().Character.Head.CFrame
                wait()
            until cam == nil or mapclone == nil or beast ~= getBeast()
        end)

        spawn(function()
            local dummy = Instance.new("Folder", ViewportFrame)
            dummy.Name = "dummy"
            dummy.Parent = ViewportFrame
            local doors = Instance.new("Folder", ViewportFrame)
            doors.Name = "doors"
            doors.Parent = ViewportFrame

            repeat
                wait()
                if not beastcamtoggle then
                    break
                end
                local doorsstuff = map:GetChildren()
                for i=1,#doorsstuff do
                    if doorsstuff[i].Name == "SingleDoor" or doorsstuff[i].Name == "DoubleDoor" then
                        local a = doorsstuff[i]:clone()
                        a.Parent = doors
                    end
                end

                local players = game.Players:getChildren()
                for i=1,#players do
                    if players[i] ~= getBeast() then
                        if players[i].Character ~= nil then
                            players[i].Character.Archivable = true
                            local dummyclone = players[i].Character:clone()
                            local bodyparts = dummyclone:getDescendants()

                            for i=1,#bodyparts do
                                if bodyparts[i].ClassName == "Sound" or bodyparts[i].ClassName == "LocalScript" or bodyparts[i].ClassName == "Script" then
                                    bodyparts[i]:remove() 
                                end
                            end
                            
                            dummyclone.Parent = dummy
                        end
                    end
                end

                wait(0.3)
                dummy:ClearAllChildren()
                doors:ClearAllChildren()
            until cam == nil or mapclone == nil or beast ~= getBeast()
        end)
    end
end

function getBeast()
    local player = game.Players:GetChildren()
    for i=1, #player do
        local character = player[i].Character
        if player[i]:findFirstChild("TempPlayerStatsModule"):findFirstChild("IsBeast").Value == true or (character ~= nil and character:findFirstChild("BeastPowers")) then
            return player[i]
        end
    end
end

function getBestPC()
    local beast = getBeast()
    local pcs = {}

    local map = game.ReplicatedStorage.CurrentMap.Value
    if map ~= nil then
        local mapstuff = map:getChildren()
        for i=1,#mapstuff do
            if mapstuff[i].Name == "ComputerTable" then
                if mapstuff[i].Screen.BrickColor ~= BrickColor.new("Dark green") then
                    local magnitude = ((mapstuff[i].Screen.Position - beast.Character:findFirstChild("HumanoidRootPart").Position).magnitude)
                    table.insert(pcs, {magnitude=magnitude, pc=mapstuff[i]})
                end
            end
        end
    end

    table.sort(pcs, function(a, b) return a.magnitude > b.magnitude end)
    return pcs
end

function isPlayerTyping()
    local hum = game.Players.LocalPlayer.Character:findFirstChildOfClass("Humanoid")
    local anims = hum:GetPlayingAnimationTracks()
    for i=1,#anims do
        if anims[i].Name == "AnimTyping" then
            return true
        end
    end
    return false
end

-- Event connections
spawn(function()
    game.ReplicatedStorage.CurrentMap.Changed:Connect(function()
        wait(5)
        reloadESP()
        if beastcamtoggle then
            reloadBeastCam()    
        end
    end)
end)

spawn(function()
    game.ReplicatedStorage.IsGameActive.Changed:Connect(function()
        reloadESP()
        if beastcamtoggle then
            reloadBeastCam()    
        end
    end)
end)

spawn(function()
    game:GetService("Players").PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            reloadESP()
        end)
        player.CharacterRemoved:Connect(function(character)
            reloadESP()
        end)
    end)
end)

spawn(function()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt,false)
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        if getnamecallmethod() == 'FireServer' and args[1] == 'SetPlayerMinigameResult' and neverfailtoggle then
            args[2] = true
        end
        return old(self, unpack(args))
    end)
end)

spawn(function()
    game.Players.LocalPlayer.PlayerGui.ScreenGui.ActionBox:GetPropertyChangedSignal("Visible"):connect(function()
        if autointeracttoggle then
            game.ReplicatedStorage.RemoteEvent:FireServer("Input", "Action", true)
        end    
    end)
end)

spawn(function()
    while wait(3) do
        if autoplaytoggle then    
            local beast = getBeast()
            local map = game.ReplicatedStorage.CurrentMap.Value
            local mapstuff = map:getChildren()
            for i=1,#mapstuff do
                if mapstuff[i].Name == "SingleDoor" or mapstuff[i].Name == "DoubleDoor" then
                    local doorParts = mapstuff[i]:getDescendants()
                    for i=1,#doorParts do
                        if doorParts[i].ClassName == "Part" and doorParts[i].Name ~= "Frame" then
                            if not doorParts[i]:findFirstChild("PathfindingModifier") then
                                local a = Instance.new("PathfindingModifier", doorParts[i])
                                a.PassThrough = true
                            end
                            if doorParts[i].Name == "Frame" then
                                local a = Instance.new("PathfindingModifier", doorParts[i])
                                a.PassThrough = false
                                a.Label = "avoid"
                            end
                        end
                    end
                end
            end

            local pcs = getBestPC()
            local PathfindingService = game:GetService("PathfindingService")
            local Humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
            local Root = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
            local goal = nil
            local agentParams = {
                AgentRadius = 2.4,
                AgentHeight = 2,
                AgentCanJump = true,
                AgentWalkableClimb = 4,
                WaypointSpacing = 2,
                Costs = {
                    avoid = 10.0
                }
            }

            local beastNearby = ((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - beast.Character:findFirstChild("HumanoidRootPart").Position).magnitude < 50)
            for i, pc in ipairs(pcs) do
                if beastNearby then
                    print("beast nearby")
                end

                if isPlayerTyping() and not beastNearby then
                    break
                end
                
                goal = pc.pc["ComputerTrigger1"].Position
                local goalpc = pc.pc
                local path = PathfindingService:CreatePath(agentParams)

                path:ComputeAsync(Root.Position, goal)
                print(path.Status)
                if path.Status == Enum.PathStatus.Success then
                    local waypoints = path:GetWaypoints()
                    for i, waypoint in ipairs(waypoints) do
                        local ray = Ray.new(waypoints[i].Position, Vector3.new(0, 1, 0) * 3)
                        local part = workspace:FindPartOnRay(ray)
                        if part and part.CanCollide then
                            local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                            print("need to crouch :)")
                        end

                        Humanoid:MoveTo(waypoint.Position)
                        if waypoint.Action == Enum.PathWaypointAction.Jump then
                            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end

                        local a = Instance.new("Part", workspace)
                        a.Shape = Enum.PartType.Ball
                        a.Position = waypoint.Position
                        a.BrickColor = BrickColor.new("Pink")
                        a.Material = Enum.Material.Neon
                        a.Size = Vector3.new(2,2,2)
                        a.Anchored = true
                        a.CanCollide = false
                        local touch = false

                        spawn(function()
                            a.Touched:Connect(function(hit)
                                if hit.Parent:FindFirstChild("Humanoid") then
                                    if hit.Parent.Name == game.Players.LocalPlayer.Character.Name then
                                        touch = true
                                        a:remove()
                                    end
                                end
                            end)
                            wait(10)
                            a:remove()
                        end)
                        repeat
                            wait(0.05)
                        until touch
                    end
                    break
                end
            end
        end
    end
end)
