-- Load Fluent UI Library
local Fluent = loadstring(game:HttpGet("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau", true))()

-- Initialize UI
local UI = Fluent:CreateWindow({
    Title = "Saturn Hub",
    SubTitle = "discord.gg/6UaRDjBY42",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift
})

-- Make UI available globally for theme changes
local Options = Fluent.Options

-- Create tabs
local Tabs = {
    Info = UI:AddTab({Title = "Info", Icon = "info"}),
    ESP = UI:AddTab({Title = "ESP", Icon = "eye"}),
    Teleport = UI:AddTab({Title = "Teleport", Icon = "map-pin"}),
    Bring = UI:AddTab({Title = "Bring Items", Icon = "package"}),
    Hitbox = UI:AddTab({Title = "Hitbox", Icon = "box"}),
    Misc = UI:AddTab({Title = "Misc", Icon = "settings"})
}

-- Info tab content
Tabs.Info:AddParagraph({
    Title = "Welcome",
    Content = "Hey this Saturn Hub by JScript Team, Thanks for using our script by the way and Joining our discord server for news and upcoming script :] "
})

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- Optimized ESP System
local ESP = {
    Enabled = false,
    Objects = {},
    Tracers = {},
    Settings = {
        Players = false,
        Fairy = false,
        Wolf = false,
        Bunny = false,
        Cultist = false,
        CrossBow = false,
        PeltTrader = false,
        NameColor = Color3.fromRGB(255, 255, 255),
        NameSize = 16,
        HPBarSize = Vector2.new(60, 6)
    }
}

-- Item ESP System
local ItemESP = {
    Enabled = true,
    Items = {},
    Color = Color3.fromRGB(255, 255, 0),
    Toggles = {
        Berry = false,
        Log = false,
        Chest = false,
        Toolbox = false,
        Coal = false,
        Carrot = false,
        Flashlight = false,
        Radio = false,
        ["Sheet Metal"] = false,
        Bolt = false,
        Chair = false,
        Fan = false,
        ["Good Sack"] = false,
        ["Good Axe"] = false,
        ["Raw Meat"] = false,
        ["Cooked Meat"] = false,
        Stone = false,
        Nails = false,
        Scrap = false,
        ["Wooden Plank"] = false
    }
}

-- Create ESP object
local function CreateESPObject(model)
    if ESP.Objects[model] then return end
    
    local head = model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("BasePart")
    if not head then return end
    
    ESP.Objects[model] = {
        Model = model,
        Head = head,
        Name = Drawing.new("Text"),
        HPBar = Drawing.new("Square"),
        HPBack = Drawing.new("Square"),
        LastUpdate = 0
    }
    
    local obj = ESP.Objects[model]
    
    -- Configure drawings
    obj.Name.Size = ESP.Settings.NameSize
    obj.Name.Center = true
    obj.Name.Outline = true
    obj.Name.Color = ESP.Settings.NameColor
    obj.Name.Visible = false
    
    obj.HPBack.Color = Color3.fromRGB(0, 0, 0)
    obj.HPBack.Thickness = 1
    obj.HPBack.Filled = true
    obj.HPBack.Transparency = 0.7
    obj.HPBack.Visible = false
    
    obj.HPBar.Color = Color3.fromRGB(0, 255, 0)
    obj.HPBar.Thickness = 1
    obj.HPBar.Filled = true
    obj.HPBar.Transparency = 0.9
    obj.HPBar.Visible = false
end

-- Remove ESP object
local function RemoveESPObject(model)
    if not ESP.Objects[model] then return end
    
    ESP.Objects[model].Name:Remove()
    ESP.Objects[model].HPBar:Remove()
    ESP.Objects[model].HPBack:Remove()
    
    ESP.Objects[model] = nil
end

-- Clear all tracers
local function ClearTracers()
    for _, tracer in pairs(ESP.Tracers) do
        tracer:Remove()
    end
    ESP.Tracers = {}
end

-- Main ESP update function (optimized)
local function UpdateESP()
    if not ESP.Enabled then return end
    
    ClearTracers()
    
    local currentTime = tick()
    local screenMid = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
    
    for model, data in pairs(ESP.Objects) do
        -- Only update this object every 0.1 seconds to reduce CPU usage
        if currentTime - data.LastUpdate > 0.1 then
            data.LastUpdate = currentTime
            
            if not model.Parent or not data.Head:IsDescendantOf(Workspace) then
                RemoveESPObject(model)
                continue
            end
            
            local isPlayer = Players:GetPlayerFromCharacter(model)
            local visible = false
            local labelText = ""
            
            if isPlayer and ESP.Settings.Players then
                local distVal = math.floor((Camera.CFrame.Position - data.Head.Position).Magnitude)
                labelText = model.Name .. " {" .. distVal .. "m}"
                visible = true
            elseif not isPlayer then
                local name = model.Name:lower()
                local distVal = math.floor((Camera.CFrame.Position - data.Head.Position).Magnitude)
                
                if ESP.Settings.Fairy and name:find("fairy") then
                    labelText = "🧚 Fairy {" .. distVal .. "m}"
                    visible = true
                elseif ESP.Settings.Wolf and (name:find("wolf") or name:find("alpha")) then
                    labelText = "🐺 Wolf {" .. distVal .. "m}"
                    visible = true
                elseif ESP.Settings.Bunny and name:find("bunny") then
                    labelText = "🐰 Bunny {" .. distVal .. "m}"
                    visible = true
                elseif ESP.Settings.Cultist and name:find("cultist") and not name:find("cross") then
                    labelText = "👺 Cultist {" .. distVal .. "m}"
                    visible = true
                elseif ESP.Settings.CrossBow and name:find("cross") then
                    labelText = "🏹 CrossBow Cultist {" .. distVal .. "m}"
                    visible = true
                elseif ESP.Settings.PeltTrader and name:find("pelt") then
                    labelText = "🛒 Pelt Trader {" .. distVal .. "m}"
                    visible = true
                end
            end
            
            if visible then
                local headPos, onScreen = Camera:WorldToViewportPoint(data.Head.Position)
                if onScreen then
                    -- Update name
                    data.Name.Text = labelText
                    data.Name.Position = Vector2.new(headPos.X, headPos.Y - 25)
                    data.Name.Color = ESP.Settings.NameColor
                    data.Name.Size = ESP.Settings.NameSize
                    data.Name.Visible = true
                    
                    -- Update health bar
                    local humanoid = model:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local hpPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                        local barWidth = ESP.Settings.HPBarSize.X
                        local barHeight = ESP.Settings.HPBarSize.Y
                        local barX = headPos.X - (barWidth / 2)
                        local barY = headPos.Y - 7
                        
                        data.HPBack.Size = Vector2.new(barWidth, barHeight)
                        data.HPBack.Position = Vector2.new(barX, barY)
                        data.HPBack.Visible = true
                        
                        data.HPBar.Size = Vector2.new(barWidth * hpPercent, barHeight)
                        data.HPBar.Position = Vector2.new(barX, barY)
                        data.HPBar.Color = Color3.new(1 - hpPercent, hpPercent, 0)
                        data.HPBar.Visible = true
                    else
                        data.HPBar.Visible = false
                        data.HPBack.Visible = false
                    end
                    
                    -- Add tracer
                    local tracer = Drawing.new("Line")
                    tracer.From = screenMid - Vector2.new(0, 10)
                    tracer.To = Vector2.new(headPos.X, headPos.Y)
                    tracer.Color = Color3.fromRGB(255, 0, 0)
                    tracer.Thickness = 1
                    tracer.Visible = true
                    table.insert(ESP.Tracers, tracer)
                else
                    data.Name.Visible = false
                    data.HPBar.Visible = false
                    data.HPBack.Visible = false
                end
            else
                data.Name.Visible = false
                data.HPBar.Visible = false
                data.HPBack.Visible = false
            end
        end
    end
end

-- Optimized scanner for new models
local function ScanForModels()
    while true do
        for _, model in pairs(Workspace:GetDescendants()) do
            if model:IsA("Model") and not ESP.Objects[model] and model:FindFirstChild("Head") then
                if Players:GetPlayerFromCharacter(model) or model:IsDescendantOf(Workspace.Characters) then
                    CreateESPObject(model)
                end
            end
        end
        task.wait(2) -- Reduced from 1 second to 2 seconds to reduce CPU usage
    end
end

-- Initialize ESP system
task.spawn(ScanForModels)
RunService.RenderStepped:Connect(UpdateESP)

-- Player counter system
local PlayerCounter = {
    Enabled = false,
    Text = Drawing.new("Text"),
    Lines = {},
    MaxLines = 50
}

-- Configure player counter
PlayerCounter.Text.Center = true
PlayerCounter.Text.Outline = true
PlayerCounter.Text.Size = 40
PlayerCounter.Text.Color = Color3.fromRGB(255, 0, 0)
PlayerCounter.Text.Font = 4
PlayerCounter.Text.Visible = false

-- Initialize player lines
for i = 1, PlayerCounter.MaxLines do
    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = Color3.fromRGB(255, 0, 0)
    line.Thickness = 2
    PlayerCounter.Lines[i] = line
end

-- Update player counter
local function UpdatePlayerCounter()
    if not PlayerCounter.Enabled then
        PlayerCounter.Text.Visible = false
        for _, line in pairs(PlayerCounter.Lines) do
            line.Visible = false
        end
        return
    end
    
    local visibleCount = 0
    local viewportSize = Camera.ViewportSize
    local startLinePos = Vector2.new(viewportSize.X / 2, 50)
    local visiblePlayers = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen and screenPos.Z > 0 then
                    visibleCount += 1
                    table.insert(visiblePlayers, {
                        player = player,
                        pos = Vector2.new(screenPos.X, screenPos.Y)
                    })
                end
            end
        end
    end
    
    PlayerCounter.Text.Text = tostring(visibleCount)
    PlayerCounter.Text.Position = Vector2.new(viewportSize.X / 2, 8)
    PlayerCounter.Text.Visible = true
    
    for i = 1, PlayerCounter.MaxLines do
        PlayerCounter.Lines[i].Visible = false
    end
    
    if visibleCount > 0 then
        for i, info in pairs(visiblePlayers) do
            if i > PlayerCounter.MaxLines then break end
            local line = PlayerCounter.Lines[i]
            line.From = startLinePos
            line.To = info.pos
            line.Visible = true
        end
    end
end

RunService.RenderStepped:Connect(UpdatePlayerCounter)

-- Item ESP system
local ItemESPObjects = {}

local function CreateItemESP(item)
    if ItemESPObjects[item] then return end
    
    local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
    if not part then return end
    
    ItemESPObjects[item] = {
        Part = part,
        Text = Drawing.new("Text"),
        LastUpdate = 0
    }
    
    local obj = ItemESPObjects[item]
    obj.Text.Size = 14
    obj.Text.Center = true
    obj.Text.Outline = true
    obj.Text.Font = 2
    obj.Text.Color = ItemESP.Color
    obj.Text.Visible = false
end

local function RemoveItemESP(item)
    if not ItemESPObjects[item] then return end
    ItemESPObjects[item].Text:Remove()
    ItemESPObjects[item] = nil
end

local function UpdateItemESP()
    if not ItemESP.Enabled then
        for _, esp in pairs(ItemESPObjects) do
            esp.Text.Visible = false
        end
        return
    end
    
    local currentTime = tick()
    
    -- Update existing items
    for item, esp in pairs(ItemESPObjects) do
        if currentTime - esp.LastUpdate > 0.2 then -- Only update every 0.2 seconds
            esp.LastUpdate = currentTime
            
            if not item:IsDescendantOf(Workspace) then
                RemoveItemESP(item)
                continue
            end
            
            local name = item.Name
            if ItemESP.Toggles[name] then
                local pos, visible = Camera:WorldToViewportPoint(esp.Part.Position)
                if visible then
                    local distance = (Camera.CFrame.Position - esp.Part.Position).Magnitude
                    esp.Text.Text = string.format("%s [%.0fm]", name, distance)
                    esp.Text.Position = Vector2.new(pos.X, pos.Y)
                    esp.Text.Color = ItemESP.Color
                    esp.Text.Visible = true
                else
                    esp.Text.Visible = false
                end
            else
                esp.Text.Visible = false
            end
        end
    end
    
    -- Scan for new items (less frequently)
    if currentTime % 2 < 0.1 then -- Only scan every 2 seconds
        local itemsFolder = Workspace:FindFirstChild("Items")
        if itemsFolder then
            for _, item in ipairs(itemsFolder:GetChildren()) do
                if not ItemESPObjects[item] then
                    CreateItemESP(item)
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(UpdateItemESP)

-- ESP Tab
Tabs.ESP:AddToggle("PlayerESP", {
    Title = "Player ESP",
    Default = false,
    Callback = function(value)
        ESP.Settings.Players = value
        PlayerCounter.Enabled = value
        ESP.Enabled = value or ESP.Settings.Fairy or ESP.Settings.Wolf or ESP.Settings.Bunny or 
                        ESP.Settings.Cultist or ESP.Settings.CrossBow or ESP.Settings.PeltTrader
    end
})

Tabs.ESP:AddToggle("FairyESP", {
    Title = "Fairy ESP",
    Default = false,
    Callback = function(value)
        ESP.Settings.Fairy = value
        ESP.Enabled = value or ESP.Settings.Players or ESP.Settings.Wolf or ESP.Settings.Bunny or 
                        ESP.Settings.Cultist or ESP.Settings.CrossBow or ESP.Settings.PeltTrader
    end
})

Tabs.ESP:AddToggle("WolfESP", {
    Title = "Wolf ESP",
    Default = false,
    Callback = function(value)
        ESP.Settings.Wolf = value
        ESP.Enabled = value or ESP.Settings.Players or ESP.Settings.Fairy or ESP.Settings.Bunny or 
                        ESP.Settings.Cultist or ESP.Settings.CrossBow or ESP.Settings.PeltTrader
    end
})

Tabs.ESP:AddToggle("BunnyESP", {
    Title = "Bunny ESP",
    Default = false,
    Callback = function(value)
        ESP.Settings.Bunny = value
        ESP.Enabled = value or ESP.Settings.Players or ESP.Settings.Fairy or ESP.Settings.Wolf or 
                        ESP.Settings.Cultist or ESP.Settings.CrossBow or ESP.Settings.PeltTrader
    end
})

Tabs.ESP:AddToggle("CultistESP", {
    Title = "Cultist ESP",
    Default = false,
    Callback = function(value)
        ESP.Settings.Cultist = value
        ESP.Settings.CrossBow = value
        ESP.Enabled = value or ESP.Settings.Players or ESP.Settings.Fairy or ESP.Settings.Wolf or 
                        ESP.Settings.Bunny or ESP.Settings.PeltTrader
    end
})

Tabs.ESP:AddToggle("PeltTraderESP", {
    Title = "Pelt Trader ESP",
    Default = false,
    Callback = function(value)
        ESP.Settings.PeltTrader = value
        ESP.Enabled = value or ESP.Settings.Players or ESP.Settings.Fairy or ESP.Settings.Wolf or 
                        ESP.Settings.Bunny or ESP.Settings.Cultist or ESP.Settings.CrossBow
    end
})

Tabs.ESP:AddToggle("ItemESP", {
    Title = "Item ESP",
    Default = true,
    Callback = function(value)
        ItemESP.Enabled = value
    end
})

Tabs.ESP:AddColorpicker("ItemESPColor", {
    Title = "Item ESP Color",
    Default = Color3.fromRGB(255, 255, 0),
    Callback = function(value)
        ItemESP.Color = value
    end
})

-- Food items toggle
local foodItems = {"Berry", "Carrot", "Raw Meat", "Cooked Meat"}
Tabs.ESP:AddToggle("FoodESP", {
    Title = "Food ESP",
    Default = false,
    Callback = function(value)
        for _, item in ipairs(foodItems) do
            ItemESP.Toggles[item] = value
        end
    end
})

-- Revolver toggle
Tabs.ESP:AddToggle("RevolverESP", {
    Title = "Revolver + Ammo ESP",
    Default = false,
    Callback = function(value)
        ItemESP.Toggles["Revolver"] = value
        ItemESP.Toggles["Revolver Ammo"] = value
    end
})

-- Individual item toggles
for itemName, _ in pairs(ItemESP.Toggles) do
    if not table.find(foodItems, itemName) and itemName ~= "Revolver" and itemName ~= "Revolver Ammo" then
        Tabs.ESP:AddToggle(itemName .. "ESP", {
            Title = itemName,
            Default = false,
            Callback = function(value)
                ItemESP.Toggles[itemName] = value
            end
        })
    end
end

-- Speed hack
local SpeedHack = {
    Enabled = false,
    Value = 28
}

local function UpdateSpeed()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = SpeedHack.Enabled and SpeedHack.Value or 16
        end
    end
end

Tabs.Misc:AddToggle("SpeedHack", {
    Title = "Speed Hack",
    Default = false,
    Callback = function(value)
        SpeedHack.Enabled = value
        UpdateSpeed()
    end
})

Tabs.Misc:AddSlider("SpeedValue", {
    Title = "Speed Value",
    Description = "Set your movement speed",
    Default = 28,
    Min = 16,
    Max = 600,
    Rounding = 0,
    Callback = function(value)
        SpeedHack.Value = value
        if SpeedHack.Enabled then
            UpdateSpeed()
        end
    end
})

-- FPS and Ping display
local Performance = {
    ShowFPS = true,
    ShowPing = true,
    FPSText = Drawing.new("Text"),
    PingText = Drawing.new("Text")
}

-- Configure performance displays
Performance.FPSText.Size = 16
Performance.FPSText.Position = Vector2.new(Camera.ViewportSize.X - 100, 10)
Performance.FPSText.Color = Color3.fromRGB(0, 255, 0)
Performance.FPSText.Center = false
Performance.FPSText.Outline = true
Performance.FPSText.Visible = Performance.ShowFPS

Performance.PingText.Size = 16
Performance.PingText.Position = Vector2.new(Camera.ViewportSize.X - 100, 30)
Performance.PingText.Color = Color3.fromRGB(0, 255, 0)
Performance.PingText.Center = false
Performance.PingText.Outline = true
Performance.PingText.Visible = Performance.ShowPing

local fpsCounter = 0
local lastUpdate = tick()

RunService.RenderStepped:Connect(function()
    fpsCounter += 1
    
    if tick() - lastUpdate >= 1 then
        -- Update FPS
        if Performance.ShowFPS then
            Performance.FPSText.Text = "FPS: " .. fpsCounter
            Performance.FPSText.Visible = true
        else
            Performance.FPSText.Visible = false
        end
        
        -- Update Ping
        if Performance.ShowPing then
            local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            Performance.PingText.Text = "Ping: " .. ping .. "ms"
            
            -- Color based on ping
            if ping <= 60 then
                Performance.PingText.Color = Color3.fromRGB(0, 255, 0)
            elseif ping <= 120 then
                Performance.PingText.Color = Color3.fromRGB(255, 165, 0)
            else
                Performance.PingText.Color = Color3.fromRGB(255, 0, 0)
            end
            
            Performance.PingText.Visible = true
        else
            Performance.PingText.Visible = false
        end
        
        fpsCounter = 0
        lastUpdate = tick()
    end
end)

Tabs.Misc:AddToggle("ShowFPS", {
    Title = "Show FPS",
    Default = true,
    Callback = function(value)
        Performance.ShowFPS = value
        Performance.FPSText.Visible = value
    end
})

Tabs.Misc:AddToggle("ShowPing", {
    Title = "Show Ping",
    Default = true,
    Callback = function(value)
        Performance.ShowPing = value
        Performance.PingText.Visible = value
    end
})

-- FPS Boost
Tabs.Misc:AddButton({
    Title = "FPS Boost",
    Description = "Reduces graphics quality for better performance",
    Callback = function()
        pcall(function()
            -- Lower rendering quality
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            
            -- Disable lighting effects
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 0
            lighting.FogEnd = 100
            lighting.GlobalShadows = false
            lighting.EnvironmentDiffuseScale = 0
            lighting.EnvironmentSpecularScale = 0
            lighting.ClockTime = 14
            lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            
            -- Terrain settings
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            
            -- Disable all effects
            for _, obj in ipairs(lighting:GetDescendants()) do
                if obj:IsA("PostEffect") then
                    obj.Enabled = false
                end
            end
            
            -- Remove textures and particles
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
            
            -- Remove shadows on parts
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
        end)
        Fluent:Notify({
            Title = "FPS Boost",
            Content = "Graphics settings optimized for performance",
            Duration = 3
        })
    end
})

-- Teleport functions
Tabs.Teleport:AddButton({
    Title = "Teleport to Camp",
    Description = "Teleports you to the camp location",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(
                13.287363052368164, 3.999999761581421, 0.36212217807769775,
                0.6022269129753113, -2.275036159460342e-08, 0.7983249425888062,
                6.430457055728311e-09, 1, 2.364672191390582e-08,
                -0.7983249425888062, -9.1070981866892e-09, 0.6022269129753113
            )
            Fluent:Notify({
                Title = "Teleport",
                Content = "Teleported to camp",
                Duration = 2
            })
        end
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Trader",
    Description = "Teleports you to the trader location",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(-37.08, 3.98, -16.33)
            Fluent:Notify({
                Title = "Teleport",
                Content = "Teleported to trader",
                Duration = 2
            })
        end
    end
})

-- Bring items functions
local function BringItemsByName(name)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local count = 0
    for _, item in ipairs(Workspace.Items:GetChildren()) do
        if item.Name:lower():find(name:lower()) then
            local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
            if part then
                part.CFrame = root.CFrame + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
                count += 1
            end
        end
    end
    
    if count > 0 then
        Fluent:Notify({
            Title = "Bring Items",
            Content = string.format("Brought %d %s items", count, name),
            Duration = 2
        })
    end
end

Tabs.Bring:AddButton({
    Title = "Bring Everything",
    Description = "Brings all items to your location",
    Callback = function()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local count = 0
        for _, item in ipairs(Workspace.Items:GetChildren()) do
            local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
            if part then
                part.CFrame = root.CFrame + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
                count += 1
            end
        end
        
        Fluent:Notify({
            Title = "Bring Items",
            Content = string.format("Brought %d items to you", count),
            Duration = 2
        })
    end
})

-- Auto Cook Meat
local campfirePos = Vector3.new(1.87, 4.33, -3.67)
Tabs.Bring:AddButton({
    Title = "Auto Cook Meat",
    Description = "Brings all meat to the campfire",
    Callback = function()
        local count = 0
        for _, item in pairs(Workspace.Items:GetChildren()) do
            if (item:IsA("Model") or item:IsA("BasePart")) and item.Name:lower():find("meat") then
                local part = item:FindFirstChildWhichIsA("BasePart") or item
                if part then
                    part.CFrame = CFrame.new(campfirePos + Vector3.new(math.random(-2,2), 0.5, math.random(-2,2)))
                    count += 1
                end
            end
        end
        
        Fluent:Notify({
            Title = "Auto Cook",
            Content = string.format("Brought %d meat to campfire", count),
            Duration = 2
        })
    end
})

-- Individual bring buttons
local bringItems = {
    "Logs",
    "Coal",
    "Flashlight",
    "Nails",
    "Fan",
    "Ammo",
    "Sheet Metal",
    "Fuel Canister",
    "Tyre",
    "Bandage",
    "Revolver"
}

for _, item in ipairs(bringItems) do
    Tabs.Bring:AddButton({
        Title = "Bring " .. item,
        Description = "Brings all " .. item:lower() .. " to your location",
        Callback = function()
            BringItemsByName(item)
        end
    })
end

-- Bring Lost Child
Tabs.Bring:AddButton({
    Title = "Bring Lost Child",
    Description = "Brings the lost child to your location",
    Callback = function()
        for _, model in ipairs(Workspace:GetDescendants()) do
            if model:IsA("Model") and model.Name:lower():find("lost") and model:FindFirstChild("HumanoidRootPart") then
                model:PivotTo(LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0))
                Fluent:Notify({
                    Title = "Bring NPC",
                    Content = "Brought lost child to you",
                    Duration = 2
                })
                break
            end
        end
    end
})

-- Hitbox system
local Hitbox = {
    Settings = {
        Wolf = false,
        Bunny = false,
        Cultist = false,
        Show = false,
        Size = 10
    }
}

local function UpdateHitboxForModel(model)
    local root = model:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local name = model.Name:lower()
    local shouldResize =
        (Hitbox.Settings.Wolf and (name:find("wolf") or name:find("alpha"))) or
        (Hitbox.Settings.Bunny and name:find("bunny")) or
        (Hitbox.Settings.Cultist and (name:find("cultist") or name:find("cross")))
    
    if shouldResize then
        root.Size = Vector3.new(Hitbox.Settings.Size, Hitbox.Settings.Size, Hitbox.Settings.Size)
        root.Transparency = Hitbox.Settings.Show and 0.5 or 1
        root.Color = Color3.fromRGB(255, 255, 255)
        root.Material = Enum.Material.Neon
        root.CanCollide = false
    end
end

-- Optimized hitbox scanner (runs every 3 seconds)
task.spawn(function()
    while true do
        for _, model in ipairs(Workspace:GetDescendants()) do
            if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
                UpdateHitboxForModel(model)
            end
        end
        task.wait(3) -- Reduced frequency from 2 to 3 seconds
    end
end)

-- Hitbox UI
Tabs.Hitbox:AddToggle("WolfHitbox", {
    Title = "Expand Wolf Hitbox",
    Default = false,
    Callback = function(value)
        Hitbox.Settings.Wolf = value
    end
})

Tabs.Hitbox:AddToggle("BunnyHitbox", {
    Title = "Expand Bunny Hitbox",
    Default = false,
    Callback = function(value)
        Hitbox.Settings.Bunny = value
    end
})

Tabs.Hitbox:AddToggle("CultistHitbox", {
    Title = "Expand Cultist Hitbox",
    Default = false,
    Callback = function(value)
        Hitbox.Settings.Cultist = value
    end
})

Tabs.Hitbox:AddSlider("HitboxSize", {
    Title = "Hitbox Size",
    Description = "Set the size of expanded hitboxes",
    Default = 10,
    Min = 2,
    Max = 30,
    Rounding = 0,
    Callback = function(value)
        Hitbox.Settings.Size = value
    end
})

Tabs.Hitbox:AddToggle("ShowHitbox", {
    Title = "Show Hitbox",
    Description = "Makes hitboxes visible",
    Default = false,
    Callback = function(value)
        Hitbox.Settings.Show = value
    end
})

-- Load the UI
UI:SelectTab(1)
Fluent:Notify({
    Title = "Script Loaded",
    Content = "99 Nights in Forest script activated!",
    Duration = 5
})