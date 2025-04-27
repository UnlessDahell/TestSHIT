-- Services
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService('VirtualInputManager')

-- Player
local player = Players.LocalPlayer
local userId = player.UserId

-- ESP Handler Replacement
local function applyESP(object, fillColor, outlineColor)
    if object:FindFirstChildOfClass("Highlight") then return end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = fillColor
    highlight.OutlineColor = outlineColor
    highlight.Parent = object
end

-- Functions
local function getAccountAge()
    return player.AccountAge .. " days"
end

local function getGameName()
    local success, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    return (success and info and info.Name) or "Unknown"
end

-- Load Rayfield
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
        Invite = ".gg/YVyfVYGR23",
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

-- Main Tab
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

-- Variables for Highlights
local generatorHighlight = false
local killerHighlight = false
local survivorHighlight = false
local toolHighlight = false

local excludeNames = {
    ["RedFlag"] = true,
    ["BlueFlag"] = true
}

-- Vision Tab (ESP)
local VisionTab = Window:CreateTab("Vision", "eye")

VisionTab:CreateParagraph({
    Title = "Highlight Tips!",
    Content = "These toggles highlight objects. Don't act suspicious when using them!"
})

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

-- ESP Functions
local function highlightGenerators()
    local map = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Ingame") and Workspace.Map.Ingame:FindFirstChild("Map")
    if not map then return end
    for _, obj in ipairs(map:GetChildren()) do
        if obj:IsA("Model") and obj.Name == "Generator" then
            applyESP(obj, Color3.new(1, 1, 0), Color3.new(1, 1, 0.5))
        end
    end
end

local function highlightKillers()
    local killers = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
    if not killers then return end
    for _, obj in ipairs(killers:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            applyESP(obj, Color3.new(1, 0, 0), Color3.new(1, 0.5, 0.5))
        end
    end
end

local function highlightSurvivors()
    local survivors = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Survivors")
    if not survivors then return end
    for _, obj in ipairs(survivors:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            applyESP(obj, Color3.new(0, 1, 0), Color3.new(0.5, 1, 0.5))
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

-- Heartbeat Update Loop
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

-- Bypass Tab
local GenTab = Window:CreateTab("Bypass", "gallery-vertical-end")

GenTab:CreateParagraph({
    Title = "Bypass Gen Tips!",
    Content = "Generator bypass is strong, but use carefully or risk ban!"
})

-- Generator Done Button
local screenGui_GenBypass = Instance.new("ScreenGui")
screenGui_GenBypass.Parent = cloneref(game:GetService("CoreGui"))

local button_GenBypass = Instance.new("TextButton")
button_GenBypass.Parent = screenGui_GenBypass
button_GenBypass.Size = UDim2.new(0, 220, 0, 50)
button_GenBypass.Position = UDim2.new(0.5, -110, 0.5, -25)
button_GenBypass.Text = "Done Generator"
button_GenBypass.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
button_GenBypass.TextColor3 = Color3.fromRGB(255, 255, 255)
button_GenBypass.TextSize = 18
button_GenBypass.Font = Enum.Font.GothamBold
button_GenBypass.BorderSizePixel = 0
button_GenBypass.AutoButtonColor = false
button_GenBypass.Active = true
button_GenBypass.Draggable = true

local corner = Instance.new("UICorner")
corner.Parent = button_GenBypass
corner.CornerRadius = UDim.new(0, 10)

local padding = Instance.new("UIPadding")
padding.Parent = button_GenBypass
padding.PaddingTop = UDim.new(0, 8)
padding.PaddingBottom = UDim.new(0, 8)
padding.PaddingLeft = UDim.new(0, 12)
padding.PaddingRight = UDim.new(0, 12)

button_GenBypass.Visible = false -- Hide by default

local survivorsFolder = Workspace:WaitForChild("Players"):WaitForChild("Survivors")
local cooldown = false

local function getNearestGenerator()
    local playerModel = nil
    for _, model in pairs(survivorsFolder:GetChildren()) do
        if model:IsA("Model") and model:GetAttribute("Username") == player.Name then
            playerModel = model
            break
        end
    end

    if not playerModel then
        warn("Player model not found!")
        return
    end

    local rootPart = playerModel:WaitForChild("HumanoidRootPart")
    local closestGen = nil
    local shortestDist = math.huge

    local map = Workspace:WaitForChild("Map"):WaitForChild("Ingame"):WaitForChild("Map")

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

button_GenBypass.MouseButton1Click:Connect(function()
    if cooldown then return end
    cooldown = true
    button_GenBypass.Text = "Cooldown"
    button_GenBypass.TextColor3 = Color3.fromRGB(255, 0, 0)

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
    button_GenBypass.Text = "Done Generator"
    button_GenBypass.TextColor3 = Color3.fromRGB(255, 255, 255)
    cooldown = false
end)

GenTab:CreateToggle({
    Name = "Show Done Generator Button",
    CurrentValue = false,
    Callback = function(state)
        button_GenBypass.Visible = state
    end
})

-- Anti-Mod System
GenTab:CreateParagraph({
    Title = "Anti-Mod Tips!",
    Content = "Not a complete bypass. Stay safe if you see mods!"
})

GenTab:CreateButton({
    Name = "Enable Anti-Mod",
    Callback = function()
        local plrs = game:GetService("Players")
        local gid, minR = 33548380, 2

        local antiModScreenGui = Instance.new("ScreenGui")
        antiModScreenGui.Name = "ModNotifier"
        antiModScreenGui.Parent = cloneref(game:GetService("CoreGui"))

        local lbl = Instance.new("TextLabel")
        lbl.Parent = antiModScreenGui
        lbl.Size = UDim2.new(0, 200, 0, 50)
        lbl.Position = UDim2.new(1, -210, 0, 10)
        lbl.BackgroundTransparency = 0.5
        lbl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = Enum.Font.SourceSansBold
        lbl.TextWrapped = true
        lbl.TextScaled = true
        lbl.Visible = false

        local function updLbl()
            local mods = {}
            for _, p in pairs(plrs:GetPlayers()) do
                if p:IsInGroup(gid) and p:GetRankInGroup(gid) >= minR then
                    table.insert(mods, p.DisplayName)
                end
            end
            lbl.Visible = #mods > 0
            lbl.Text = #mods > 0 and "Mods In Game\n" .. table.concat(mods, "\n") or ""
        end

        plrs.PlayerAdded:Connect(function()
            task.wait(1)
            updLbl()
        end)
        plrs.PlayerRemoving:Connect(function()
            updLbl()
        end)

        updLbl()
    end
})

-- Popup Solver 1x1
GenTab:CreateParagraph({
    Title = "1x1 Popup Solver",
    Content = "Solves popups automatically! Stand still for 1-2 seconds after solving."
})

local aimbotLoops = {}

GenTab:CreateToggle({
    Name = "Enable Popup Solver",
    CurrentValue = false,
    Callback = function(state)
        if state then
            aimbotLoops["PopupSolver"] = RunService.Heartbeat:Connect(function()
                local tempUI = player:FindFirstChild("PlayerGui")
                if tempUI then
                    tempUI = tempUI:FindFirstChild("TemporaryUI")
                    if tempUI then
                        for _, popup in ipairs(tempUI:GetChildren()) do
                            if popup.Name == "1x1x1x1Popup" then
                                local centerX = popup.AbsolutePosition.X + (popup.AbsoluteSize.X / 2)
                                local centerY = popup.AbsolutePosition.Y + (popup.AbsoluteSize.Y / 2)
                                VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, player.PlayerGui, 1)
                                VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, player.PlayerGui, 1)
                                task.wait(0.2)
                            end
                        end
                    end
                end
            end)
        else
            if aimbotLoops["PopupSolver"] then
                aimbotLoops["PopupSolver"]:Disconnect()
                aimbotLoops["PopupSolver"] = nil
            end
        end
    end
})

-- NoClip Tab
local NoClipTab = Window:CreateTab("NoClip", "annoyed")

NoClipTab:CreateParagraph({
    Title = "NoClip Tips!",
    Content = "Don't stay inside walls too long or you might get kicked! Use wisely."
})

local running = false
local buttonVisible = false
local buttonMovable = false
local dragging = false
local dragInput, dragStart, startPos
local char = player.Character or player.CharacterAdded:Wait()

local screenGui_NoClip = Instance.new("ScreenGui")
screenGui_NoClip.Name = "NoClipButtonUI"
screenGui_NoClip.Parent = cloneref(game:GetService("CoreGui"))
screenGui_NoClip.Enabled = false

local button_NoClip = Instance.new("TextButton")
button_NoClip.Name = "NoClipToggleButton"
button_NoClip.Parent = screenGui_NoClip
button_NoClip.Size = UDim2.new(0, 100, 0, 40)
button_NoClip.Position = UDim2.new(0.85, 0, 0.8, 0)
button_NoClip.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button_NoClip.TextColor3 = Color3.fromRGB(255, 255, 255)
button_NoClip.Text = "NoClip: OFF"
button_NoClip.Font = Enum.Font.GothamBold
button_NoClip.TextSize = 14
button_NoClip.BorderSizePixel = 1
button_NoClip.BorderColor3 = Color3.fromRGB(60, 60, 60)
button_NoClip.AutoButtonColor = true
button_NoClip.ZIndex = 10
button_NoClip.Active = true
button_NoClip.Draggable = false

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = button_NoClip

local function updateInput(input)
    local delta = input.Position - dragStart
    button_NoClip.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

button_NoClip.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and buttonMovable then
        dragging = true
        dragStart = input.Position
        startPos = button_NoClip.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button_NoClip.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging and buttonMovable then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
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
        RunService.Stepped:Wait()
    end
end

local function ToggleNoClip()
    running = not running
    button_NoClip.Text = running and "NoClip: ON" or "NoClip: OFF"
    button_NoClip.BackgroundColor3 = running and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(30, 30, 30)
    
    if running then
        char = player.Character or player.CharacterAdded:Wait()
        coroutine.wrap(NoClipLoop)()
    end
end

NoClipTab:CreateToggle({
    Name = "Show NoClip Button",
    CurrentValue = buttonVisible,
    Callback = function(value)
        buttonVisible = value
        screenGui_NoClip.Enabled = buttonVisible
    end
})

NoClipTab:CreateToggle({
    Name = "Make Button Movable",
    CurrentValue = buttonMovable,
    Callback = function(value)
        buttonMovable = value
        button_NoClip.Draggable = value
    end
})

NoClipTab:CreateToggle({
    Name = "Enable NoClip",
    CurrentValue = running,
    Callback = function(value)
        running = value
        button_NoClip.Text = running and "NoClip: ON" or "NoClip: OFF"
        button_NoClip.BackgroundColor3 = running and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(30, 30, 30)
        
        if running then
            coroutine.wrap(NoClipLoop)()
        end
    end
})

NoClipTab:CreateLabel("Press 'F' to toggle NoClip (when button is visible)")

button_NoClip.MouseButton1Click:Connect(ToggleNoClip)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
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

-- === Aimbot Tab === --
local AimbotTab = Window:CreateTab("Aimbot", "target")

AimbotTab:CreateParagraph({
    Title = "Aimbot Tips!",
    Content = "Re-enable aimbot every new game round!"
})

local aimbotSounds = {
    Chance = {"rbxassetid://201858045", "rbxassetid://139012439429121"},
    Shedletsky = {"rbxassetid://12222225", "rbxassetid://83851356262523"},
    Guest1337 = {"rbxassetid://609342351"},
    JohnDoe = {"rbxassetid://109525294317144"},
    Jason = {"rbxassetid://112809109188560", "rbxassetid://102228729296384"},
    OneByOne = {"rbxassetid://79782181585087", "rbxassetid://128711903717226"},
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
            if aimbotLoops[characterName] then
                aimbotLoops[characterName]:Disconnect()
            end
            
            aimbotLoops[characterName] = player.Character:WaitForChild("HumanoidRootPart").ChildAdded:Connect(function(child)
                for _, soundId in pairs(aimbotSounds[characterName]) do
                    if child.Name == soundId then
                        local targetFolder = characterName == "OneByOne" and "Survivors" or "Killers"
                        local targets = Workspace.Players:FindFirstChild(targetFolder)
                        
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

                                if specialCondition and child.Name == "rbxassetid://79782181585087" then
                                    maxIterations = 220
                                end

                                while num <= maxIterations and player.Character and player.Character:FindFirstChild("HumanoidRootPart") do
                                    task.wait(0.01)
                                    num += 1
                                    Workspace.CurrentCamera.CFrame = CFrame.new(
                                        Workspace.CurrentCamera.CFrame.Position, 
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

local function coolkidAimbot(state)
    local network = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Network")
    if network and network:FindFirstChild("RemoteEvent") then
        network.RemoteEvent:FireServer("SetDevice", state and "Mobile" or "PC")
    else
        Rayfield:Notify({
            Title = "Error",
            Content = "Network event missing!",
            Duration = 5
        })
    end
end

-- Create Aimbot Toggles
AimbotTab:CreateToggle({Name = "Chance Aim", CurrentValue = false, Callback = createAimbot("Chance", 100)})
AimbotTab:CreateToggle({Name = "Shedletsky Aim", CurrentValue = false, Callback = createAimbot("Shedletsky", 100)})
AimbotTab:CreateToggle({Name = "Guest1337 Aim", CurrentValue = false, Callback = createAimbot("Guest1337", 100)})
AimbotTab:CreateToggle({Name = "John Doe Spike Aim", CurrentValue = false, Callback = createAimbot("JohnDoe", 330)})
AimbotTab:CreateToggle({Name = "Jason Aim (BUG)", CurrentValue = false, Callback = createAimbot("Jason", 70)})
AimbotTab:CreateToggle({Name = "1x1 Aim", CurrentValue = false, Callback = createAimbot("OneByOne", 100, true)})
AimbotTab:CreateToggle({Name = "C00lkid Aim", CurrentValue = false, Callback = coolkidAimbot})

-- Final Notification
task.wait(1)
Rayfield:Notify({
    Title = "Aimbot Ready!",
    Content = "Everything loaded. Good luck!",
    Duration = 6.5,
    Image = "rbxassetid://99937635381008"
})
