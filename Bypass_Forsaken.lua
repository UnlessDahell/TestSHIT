local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer
local userId = player.UserId

local function getAccountAge()
    return player.AccountAge .. " days"
end

local function getGameName()
    local success, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    return (success and info and info.Name) or "Unknown"
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Vexis Hub | Script Hub",
    LoadingTitle = "Vexis Hub | .gg/YVyfVYGR23",
    LoadingSubtitle = "Welcome back, " .. player.Name,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "VexisHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = true,
        Invite = "YVyfVYGR23",
        RememberJoins = true
    },
    KeySystem = false,
    Theme = {
        TextColor = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(0, 0, 0),
        Topbar = Color3.fromRGB(10, 10, 10),
        Shadow = Color3.fromRGB(10, 10, 10),

        NotificationBackground = Color3.fromRGB(20, 20, 20),
        NotificationActionsBackground = Color3.fromRGB(255, 145, 0),

        TabBackground = Color3.fromRGB(30, 30, 30),
        TabStroke = Color3.fromRGB(40, 40, 40),
        TabBackgroundSelected = Color3.fromRGB(255, 145, 0),
        TabTextColor = Color3.fromRGB(255, 255, 255),
        SelectedTabTextColor = Color3.fromRGB(0, 0, 0),

        ElementBackground = Color3.fromRGB(20, 20, 20),
        ElementBackgroundHover = Color3.fromRGB(30, 30, 30),
        SecondaryElementBackground = Color3.fromRGB(15, 15, 15),
        ElementStroke = Color3.fromRGB(50, 50, 50),
        SecondaryElementStroke = Color3.fromRGB(40, 40, 40),
        
        SliderBackground = Color3.fromRGB(255, 145, 0),
        SliderProgress = Color3.fromRGB(255, 145, 0),
        SliderStroke = Color3.fromRGB(255, 180, 60),

        ToggleBackground = Color3.fromRGB(25, 25, 25),
        ToggleEnabled = Color3.fromRGB(255, 145, 0),
        ToggleDisabled = Color3.fromRGB(100, 100, 100),
        ToggleEnabledStroke = Color3.fromRGB(255, 180, 60),
        ToggleDisabledStroke = Color3.fromRGB(125, 125, 125),
        ToggleEnabledOuterStroke = Color3.fromRGB(255, 145, 0),
        ToggleDisabledOuterStroke = Color3.fromRGB(65, 65, 65),

        DropdownSelected = Color3.fromRGB(40, 40, 40),
        DropdownUnselected = Color3.fromRGB(30, 30, 30),

        InputBackground = Color3.fromRGB(25, 25, 25),
        InputStroke = Color3.fromRGB(255, 145, 0),
        PlaceholderColor = Color3.fromRGB(200, 200, 200)
    }
})

local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateParagraph({
    Title = "Welcome To Vexis H",
    Content = "We’re so happy you’re using our script! Feel free to join our community and help us grow ♥️"
})

MainTab:CreateParagraph({
    Title = "Your Info",
    Content = string.format(
        "Username: %s\nUserId: %s\nAccount Age: %s\nGame: %s",
        player.Name,
        userId,
        getAccountAge(),
        getGameName()
    )
})

MainTab:CreateButton({
    Name = "Copy Discord (.gg/YVyfVYGR23)",
    Callback = function()
        setclipboard("https://discord.gg/YVyfVYGR23")
    end,
})

local VisionTab = Window:CreateTab("Vision","eye")

VisionTab:CreateToggle({
    Name = "Highlight Generators",
    CurrentValue = false,
    Flag = "GenESP",
    Callback = function(Value)
        generatorHighlight = Value
    end,
})

VisionTab:CreateToggle({
    Name = "Highlight Killers",
    CurrentValue = false,
    Flag = "KillerESP",
    Callback = function(Value)
        killerHighlight = Value
    end,
})

VisionTab:CreateToggle({
    Name = "Highlight Survivors",
    CurrentValue = false,
    Flag = "SurvivorESP",
    Callback = function(Value)
        survivorHighlight = Value
    end,
})

VisionTab:CreateToggle({
    Name = "Highlight Tools",
    CurrentValue = false,
    Flag = "ToolESP",
    Callback = function(Value)
        toolHighlight = Value
        if toolHighlight then
            scanTools()
        else
            removeAllToolHighlights()
        end
    end,
})

local function highlightGenerators()
    local map = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Ingame") and Workspace.Map.Ingame:FindFirstChild("Map")
    if not map then return end
    for _, obj in ipairs(map:GetChildren()) do
        if obj:IsA("Model") and obj.Name == "Generator" then
            ESPHandler.applyESP(obj, Color3.new(1, 1, 0), Color3.new(1, 1, 0.5))
        end
    end
end

local function highlightKillers()
    local killers = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
    if not killers then return end
    for _, obj in ipairs(killers:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            ESPHandler.applyESP(obj, Color3.new(1, 0, 0), Color3.new(1, 0.5, 0.5))
        end
    end
end

local function highlightSurvivors()
    local survivors = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Survivors")
    if not survivors then return end
    for _, obj in ipairs(survivors:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            ESPHandler.applyESP(obj, Color3.new(0, 1, 0), Color3.new(0.5, 1, 0.5))
        end
    end
end

local function highlightTool(tool)
    if not tool:IsA("Tool") then return end
    if excludeNames[tool.Name] then return end
    if not toolHighlight then return end
    local parent = tool.Parent
    if not parent then return end
    if parent:FindFirstChild("Highlight_" .. tool.Name) then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "Highlight_" .. tool.Name
    highlight.Parent = parent
    highlight.Adornee = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
    highlight.FillColor = Color3.new(1, 1, 1)
    highlight.OutlineColor = Color3.new(1, 1, 1)
end

local function removeAllToolHighlights()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Highlight") and obj.Name:match("^Highlight_") then
            obj:Destroy()
        end
    end
end

local function scanTools()
    for _, tool in pairs(Workspace:GetChildren()) do
        highlightTool(tool)
    end
end

RunService.Heartbeat:Connect(function()
    if generatorHighlight then
        highlightGenerators()
    end
    if killerHighlight then
        highlightKillers()
    end
    if survivorHighlight then
        highlightSurvivors()
    end
end)

Workspace.ChildAdded:Connect(function(child)
    if toolHighlight then
        highlightTool(child)
    end
end)

-- Initialize variables
local player = game.Players.LocalPlayer
local VirtualInputManager = game:GetService('VirtualInputManager')
local aimbotLoops = {}

-- Sound IDs for detection
local aimbotSounds = {
    Chance = {
        "rbxassetid://201858045",
        "rbxassetid://139012439429121"
    },
    Shedletsky = {
        "rbxassetid://12222225",
        "rbxassetid://83851356262523"
    },
    Guest1337 = {
        "rbxassetid://609342351"
    },
    JohnDoe = {
        "rbxassetid://109525294317144"
    },
    Jason = {
        "rbxassetid://112809109188560",
        "rbxassetid://102228729296384"
    },
    OneByOne = {
        "rbxassetid://79782181585087",
        "rbxassetid://128711903717226"
    },
    Coolkid = {} -- Special case for mobile aim assist
}

-- Create main window with explicit settings
local Window = Rayfield:CreateWindow({
    Name = "Vexis Aimbot Hub",
    LoadingTitle = "Character-Specific Aimbots",
    LoadingSubtitle = "by Apple",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "AimbotConfig"
    },
    Discord = {
        Enabled = true,
        Invite = "fGFV3r9yKC",
        RememberJoins = true
    },
    KeySystem = false -- Disable key system for easier testing
})

-- Wait for window to fully initialize
task.wait(1)

-- Universal aimbot function
local function createAimbot(characterName, maxIterations, specialCondition)
    return function(state)
        if not player.Character then
            Rayfield:Notify({
                Title = "Error",
                Content = "Character not found!",
                Duration = 5
            })
            return
        end

        if player.Character.Name ~= characterName and state then
            Rayfield:Notify({
                Title = "Wrong Character",
                Content = "This aimbot only works with "..characterName,
                Duration = 5
            })
            return 
        end

        if state then
            -- Disconnect existing loop if any
            if aimbotLoops[characterName] then
                aimbotLoops[characterName]:Disconnect()
            end
            
            aimbotLoops[characterName] = player.Character:WaitForChild("HumanoidRootPart").ChildAdded:Connect(function(child)
                for _, soundId in pairs(aimbotSounds[characterName]) do
                    if child.Name == soundId then
                        local targetFolder = characterName == "OneByOne" and "Survivors" or "Killers"
                        local targets = game.Workspace.Players:FindFirstChild(targetFolder)
                        
                        if targets then
                            local nearestTarget = nil
                            local shortestDistance = math.huge
                            
                            for _, target in pairs(targets:GetChildren()) do
                                if target:IsA("Model") and target:FindFirstChild("HumanoidRootPart") then
                                    local distance = (target.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                                    if distance < shortestDistance then
                                        shortestDistance = distance
                                        nearestTarget = target
                                    end
                                end
                            end
                            
                            if nearestTarget then
                                local targetHRP = nearestTarget.HumanoidRootPart
                                local playerHRP = player.Character.HumanoidRootPart
                                local num = 1
                                
                                -- Special condition for 1x1x1x1 extended duration
                                if specialCondition and child.Name == "rbxassetid://79782181585087" then
                                    maxIterations = 220
                                end
                                
                                while num <= maxIterations and player.Character and player.Character:FindFirstChild("HumanoidRootPart") do
                                    task.wait(0.01)
                                    num = num + 1
                                    workspace.CurrentCamera.CFrame = CFrame.new(
                                        workspace.CurrentCamera.CFrame.Position, 
                                        targetHRP.Position
                                    )
                                    playerHRP.CFrame = CFrame.lookAt(
                                        playerHRP.Position, 
                                        Vector3.new(targetHRP.Position.X, targetHRP.Position.Y, targetHRP.Position.Z))
                                end
                            end
                        end
                    end
                end
            end)
        else
            if aimbotLoops[characterName] then
                aimbotLoops[characterName]:Disconnect()
                aimbotLoops[characterName] = nil
            end
        end
    end
end

-- Special case for Coolkid (mobile aim assist)
local function coolkidAimbot(state)
    local network = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
    if network then
        network = network:FindFirstChild("Network")
        if network then
            network = network:FindFirstChild("RemoteEvent")
            if network then
                network:FireServer("SetDevice", state and "Mobile" or "PC")
                return
            end
        end
    end
    Rayfield:Notify({
        Title = "Error",
        Content = "Could not find network event",
        Duration = 5
    })
end

-- Create main tab (renamed to AimbotTab)
local AimbotTab = Window:CreateTab("AimbotTab", "target") -- Using "target" as icon

-- Add all aimbots to the main AimbotTab
AimbotTab:CreateToggle({
    Name = "Chance Aim",
    CurrentValue = false,
    Callback = createAimbot("Chance", 100)
})

AimbotTab:CreateToggle({
    Name = "Shedletsky Aim",
    CurrentValue = false,
    Callback = createAimbot("Shedletsky", 100)
})

AimbotTab:CreateToggle({
    Name = "Guest1337 Aim",
    CurrentValue = false,
    Callback = createAimbot("Guest1337", 100)
})

AimbotTab:CreateToggle({
    Name = "John Doe Spike Aim",
    CurrentValue = false,
    Callback = createAimbot("JohnDoe", 330)
})

AimbotTab:CreateToggle({
    Name = "Jason Aim (BUG)",
    CurrentValue = false,
    Callback = createAimbot("Jason", 70)
})

AimbotTab:CreateToggle({
    Name = "1x1x1x1 Aim",
    CurrentValue = false,
    Callback = createAimbot("OneByOne", 100, true)
})

AimbotTab:CreateToggle({
    Name = "C00lkid Aim",
    CurrentValue = false,
    Callback = coolkidAimbot
})

-- Popup solver (for 1x1x1x1)
AimbotTab:CreateToggle({
    Name = "Instant Pop-Up Solver",
    CurrentValue = false,
    Callback = function(state)
        if state then
            local popupSolver = game:GetService("RunService").Heartbeat:Connect(function()
                local tempUI = player:FindFirstChild("PlayerGui")
                if tempUI then
                    tempUI = tempUI:FindFirstChild("TemporaryUI")
                    if tempUI then
                        local popups = tempUI:GetChildren()
                        for _, popup in ipairs(popups) do
                            if popup.Name == "1x1x1x1Popup" then
                                local centerX = popup.AbsolutePosition.X + (popup.AbsoluteSize.X / 2)
                                local centerY = popup.AbsolutePosition.Y + (popup.AbsoluteSize.Y / 2)
                                VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, player.PlayerGui, 1)
                                VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, player.PlayerGui, 1)
                            end
                        end
                    end
                end
            end)
            aimbotLoops["PopupSolver"] = popupSolver
        else
            if aimbotLoops["PopupSolver"] then
                aimbotLoops["PopupSolver"]:Disconnect()
                aimbotLoops["PopupSolver"] = nil
            end
        end
    end
})

-- Add a section label
AimbotTab:CreateSection("Character Specific Aimbots")

-- Initialization complete notification
task.wait(1) -- Ensure everything is loaded
Rayfield:Notify({
    Title = "Aimbot Hub Ready",
    Content = "All features loaded successfully!",
    Duration = 6.5,
    Image = "rbxassetid://99937635381008"
})

local GenTab = Window:CreateTab("Bypass", "gallery-vertical-end")

local Toggle = GenTab:CreateToggle({
    Name = "Bypass Done Generator Button",
    CurrentValue = false,
    Flag = "ToggleButton",
    Callback = function(Value)
        button.Visible = Value
    end,
})

