local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

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

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Vexis H | Forsaken",
    LoadingTitle = "Vexis H (.gg/YVyfVYGR23)",
    LoadingSubtitle = "Welcome - " .. player.Name,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "VexisH",
        FileName = "ForsakenVH"
    },
    Discord = {
        Enabled = true,
        Invite = "yourdiscordcode",
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
    Title = "Welcome to Vexis H!",
    Content = "Thanks for using our script. Join our Discord community!"
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
    Name = "Copy Discord Server",
    Callback = function()
        setclipboard("https://discord.gg/YVyfVYGR23")
    end,
})

local generatorHighlight = false
local killerHighlight = false
local survivorHighlight = false
local toolHighlight = false

local excludeNames = {
    ["RedFlag"] = true,
    ["BlueFlag"] = true
}

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

local GenTab = Window:CreateTab("Bypass", "gallery-vertical-end")

local Toggle = GenTab:CreateToggle({
    Name = "Bypass Done Generator Button",
    CurrentValue = false,
    Flag = "ToggleButton",
    Callback = function(Value)
        button.Visible = Value
    end,
})

local player = game.Players.LocalPlayer
local playerName = player.Name
local survivorsFolder = workspace:WaitForChild("Players"):WaitForChild("Survivors")

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = cloneref(game:GetService("CoreGui"))

local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 220, 0, 50)
button.Position = UDim2.new(0.5, -110, 0.5, -25)
button.Text = "Done Generator"
button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 18
button.Font = Enum.Font.GothamBold
button.BorderSizePixel = 0
button.AutoButtonColor = false
button.Active = true
button.Draggable = true

local corner = Instance.new("UICorner")
corner.Parent = button
corner.CornerRadius = UDim.new(0, 10)

local padding = Instance.new("UIPadding")
padding.Parent = button
padding.PaddingTop = UDim.new(0, 8)
padding.PaddingBottom = UDim.new(0, 8)
padding.PaddingLeft = UDim.new(0, 12)
padding.PaddingRight = UDim.new(0, 12)

button.Visible = true

local cooldown = false 

local function getNearestGenerator()
    local playerModel = nil
    for _, model in pairs(survivorsFolder:GetChildren()) do
        if model:IsA("Model") and model:GetAttribute("Username") == playerName then
            playerModel = model
            break
        end
    end

    if not playerModel then
        warn("Player model not found in Survivors folder!")
        return
    end

    local rootPart = playerModel:WaitForChild("HumanoidRootPart")
    local closestGen = nil
    local shortestDist = math.huge

    local map = workspace:WaitForChild("Map"):WaitForChild("Ingame"):WaitForChild("Map")

    for _, obj in pairs(map:GetChildren()) do
        if obj:IsA("Model") and obj.Name == "Generator" then
            local primaryPart = obj.PrimaryPart or obj:FindFirstChild("PrimaryPart")
            if primaryPart then
                local dist = (primaryPart.Position - rootPart.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closestGen = obj
                end
            end
        end
    end

    return closestGen
end

button.MouseButton1Click:Connect(function()
    if cooldown then return end

    cooldown = true 
    button.Text = "Cooldown"
    button.TextColor3 = Color3.fromRGB(255, 0, 0)
    button.TextSize = 18

    local nearestGen = getNearestGenerator()
    if nearestGen then
        local remotes = nearestGen:WaitForChild("Remotes")

        remotes:WaitForChild("RE"):FireServer()
        task.wait(0.05)
        remotes:WaitForChild("RF"):InvokeServer("leave")

    else
        warn("No generator found!")
    end

    task.wait(1)

    button.Text = "Done Generator"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 18
    cooldown = false 
end)

local NoClipTab = Window:CreateTab("NoClip", "annoyed")

NoClipTab:CreateToggle({
    Name = "Show NoClip Button",
    CurrentValue = buttonVisible,
    Callback = function(value)
        buttonVisible = value
        screenGui.Enabled = buttonVisible
    end
})

NoClipTab:CreateToggle({
    Name = "Make Button Movable",
    CurrentValue = buttonMovable,
    Callback = function(value)
        buttonMovable = value
        button.Draggable = value
    end
})

NoClipTab:CreateToggle({
    Name = "Enable NoClip",
    CurrentValue = running,
    Callback = function(value)
        running = value
        button.Text = running and "NoClip: ON" or "NoClip: OFF"
        button.BackgroundColor3 = running and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(30, 30, 30)
        
        if running then
            char = player.Character or player.CharacterAdded:Wait()
            coroutine.wrap(NoClipLoop)()
        end
    end
})

NoClipTab:CreateLabel("Press 'F' to toggle NoClip (when button is visible)")

button.MouseButton1Click:Connect(ToggleNoClip)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F and buttonVisible then
        ToggleNoClip()
    end
end)

player.CharacterAdded:Connect(function(newChar)
    char = newChar
    if running then
        coroutine.wrap(NoClipLoop)()
    end
end)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local running = false
local buttonVisible = false
local buttonMovable = false
local dragging = false
local dragInput, dragStart, startPos

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NoClipButtonUI"
screenGui.Parent = game.CoreGui
screenGui.Enabled = false

local button = Instance.new("TextButton")
button.Name = "NoClipToggleButton"
button.Parent = screenGui
button.Size = UDim2.new(0, 100, 0, 40)
button.Position = UDim2.new(0.85, 0, 0.8, 0)
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "NoClip: OFF"
button.Font = Enum.Font.GothamBold
button.TextSize = 14
button.BorderSizePixel = 1
button.BorderColor3 = Color3.fromRGB(60, 60, 60)
button.AutoButtonColor = true
button.ZIndex = 10
button.Active = true
button.Draggable = false

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = button

local function updateInput(input)
    local delta = input.Position - dragStart
    button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and buttonMovable then
        dragging = true
        dragStart = input.Position
        startPos = button.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging and buttonMovable then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging and buttonMovable then
        updateInput(input)
    end
end)

local function NoClipLoop()
    if not char then return end
    
    while running and char and char:FindFirstChild("Humanoid") do
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
        game:GetService("RunService").Stepped:Wait()
    end
end

local function ToggleNoClip()
    running = not running
    button.Text = running and "NoClip: ON" or "NoClip: OFF"
    button.BackgroundColor3 = running and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(30, 30, 30)
    
    if running then
        char = player.Character or player.CharacterAdded:Wait()
        coroutine.wrap(NoClipLoop)()
    end
end

-- Aimbot Specifct Character
-- Ensure Rayfield loads properly
-- Initialize variables
local player = game.Players.LocalPlayer
local VirtualInputManager = game:GetService('VirtualInputManager')
local aimbotLoops = {}

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
    Coolkid = {} 
}

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


local AimbotTab = Window:CreateTab("AimbotTab", "target")

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
    Name = "1x1 Aim",
    CurrentValue = false,
    Callback = createAimbot("OneByOne", 100, true)
})

AimbotTab:CreateToggle({
    Name = "C00lkid Aim",
    CurrentValue = false,
    Callback = coolkidAimbot
})

GenTab:CreateToggle({
    Name = "1x1 Popup Solver",
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

task.wait(1) 
Rayfield:Notify({
    Title = "Aimbot is  Ready",
    Content = "I think everything is loaded?",
    Duration = 6.5,
    Image = "rbxassetid://99937635381008"
})
