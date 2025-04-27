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

local GenTab = Window:CreateTab("Bypass", "gallery-vertical-end")

local Toggle = GenTab:CreateToggle({
    Name = "Bypass Done Generator Button",
    CurrentValue = false,
    Flag = "ToggleButton",
    Callback = function(Value)
        button.Visible = Value
    end,
})

