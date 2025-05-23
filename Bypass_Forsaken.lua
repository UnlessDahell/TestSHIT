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
    Name = "Vexis Hub | Forsaken",
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

local player = game.Players.LocalPlayer
local VirtualInputManager = game:GetService('VirtualInputManager')
local aimbotLoops = {}

-- sond id for detect
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
    Coolkid = {} -- in case for mibile user
}

-- aimbot
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
            -- diccon loop if it exist
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

-- special case for C00lkid (mobile aim assist)
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

-- abottab
local AimbotTab = Window:CreateTab("Aimbot", "crosshair") -- Using "target" as icon

-- all toggles
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

-- popup solver 1x1
AimbotTab:CreateToggle({
    Name = "1x1 PopUp Solver",
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

task.wait(1) -- for sure everything is loaded
Rayfield:Notify({
    Title = "Aimbot Ready",
    Content = "All features loaded successfully!",
    Duration = 6.5,
    Image = "rbxassetid://99937635381008"
})

-- Bypass Tab
local GenTab = Window:CreateTab("Bypass", "gallery-vertical-end")

local Button = GenTab:CreateButton({
   Name = "Bypass Generater GUI",
   Callback = function()
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
   end,
})

local Button2 = GenTab:CreateButton({
   Name = "Anti-Mod",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Gazer-Ha/Forsakontol/refs/heads/main/Anti%20Moderator"))()
   end,
})

local VisionTab = Window:CreateTab("Vision","eye")

local Button = VisionTab:CreateButton({
   Name = "Highlights Button",
   Callback = function()
   local Players = game.Workspace.Players
local RunService = game:GetService("RunService")

local function createOutlineESP(model, outlineColor, fillColor)
    local highlight = Instance.new("Highlight")
    highlight.Parent = model
    highlight.Adornee = model
    highlight.FillTransparency = 0.75
    highlight.FillColor = fillColor
    highlight.OutlineColor = outlineColor
    highlight.OutlineTransparency = 0 
end

local function createOutlineESPForGroup(group, outlineColor, fillColor)
    if group then
        for _, obj in pairs(group:GetChildren()) do
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            if humanoid and obj:FindFirstChild("HumanoidRootPart") then
                createOutlineESP(obj, outlineColor, fillColor)
            end
        end
    end
end

local function highlightGenerators()
    local generatorsFolder = workspace:FindFirstChild("Map") and 
                             workspace.Map:FindFirstChild("Ingame") and 
                             workspace.Map.Ingame:FindFirstChild("Map")

    if generatorsFolder then
        for _, obj in pairs(generatorsFolder:GetChildren()) do
            if obj:IsA("Model") and obj.Name == "Generator" then
                createOutlineESP(obj, Color3.new(1, 1, 0), Color3.new(1, 1, 0.5))
            end
        end
    end
end

local function highlightTools()
    for _, tool in pairs(workspace:GetDescendants()) do
        if tool:IsA("Tool") and tool:FindFirstChildWhichIsA("BasePart") then
            createOutlineESP(tool, Color3.new(1, 1, 1), Color3.new(1, 1, 1)) -- White outline and fill
        end
    end
end

local function updateESP()
    while true do
        for _, obj in pairs(Players:GetChildren()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
                for _, highlight in pairs(obj:GetChildren()) do
                    if highlight:IsA("Highlight") then
                        highlight:Destroy()
                    end
                end
            end
        end

        local killersGroup = Players:FindFirstChild("Killers")
        if killersGroup then
            createOutlineESPForGroup(killersGroup, Color3.new(1, 0, 0), Color3.new(1, 0.5, 0.5))
        end

        local survivorsGroup = Players:FindFirstChild("Survivors")
        if survivorsGroup then
            createOutlineESPForGroup(survivorsGroup, Color3.new(0, 1, 0), Color3.new(0.5, 1, 0.5))
        end

        highlightGenerators()
        highlightTools()

        wait(2) 
    end
end

updateESP()
   end,
})
