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
