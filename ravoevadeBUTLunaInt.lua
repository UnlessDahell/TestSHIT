local WorkspacePlayers = game:GetService("Workspace").Game.Players
local Players = game:GetService('Players')
local localplayer = Players.LocalPlayer
local GuiService = game:GetService("GuiService")
local Light = game:GetService("Lighting")

local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/main/source.lua", true))()

-- luna interface (my fav ui)
local Window = Luna:CreateWindow("Ravo Hub|Evade|", "Evade V2.6")

-- luna notifi
Luna:Notify("Ravo Hub", "Ravo Hub.", 4, "rbxassetid://4483345998")
game:GetService("ReplicatedStorage").Events.Respawn:FireServer()
wait(4)
Luna:Notify("Ravo Hub", "Enjoy!", 2, "rbxassetid://4483345998")

--functions and shit
getgenv().money = true
getgenv().revivedie = true
getgenv().autowistle = true
getgenv().autochat = true
getgenv().AutoDrink = true
getgenv().NoCameraShake = true
getgenv().Settings = {
    moneyfarm = false,
    afkfarm = false,
    NoCameraShake = false,
    Speed = 1450,
    Jump = 3,
    reviveTime = 3,
}

local FindAI = function()
    for _,v in pairs(WorkspacePlayers:GetChildren()) do
        if not Players:FindFirstChild(v.Name) then
            return v
        end
    end
end

local GetDownedPlr = function()
    for i,v in pairs(WorkspacePlayers:GetChildren()) do
        if v:GetAttribute("Downed") then
            return v
        end
    end
end

local revive = function()
    local downedplr = GetDownedPlr()
    if downedplr ~= nil and downedplr:FindFirstChild('HumanoidRootPart') then
        task.spawn(function()
            while task.wait() do
                if localplayer.Character then
                    workspace.Game.Settings:SetAttribute("ReviveTime", 2.2)
                    localplayer.Character:FindFirstChild('HumanoidRootPart').CFrame = CFrame.new(downedplr:FindFirstChild('HumanoidRootPart').Position.X, downedplr:FindFirstChild('HumanoidRootPart').Position.Y + 3, downedplr:FindFirstChild('HumanoidRootPart').Position.Z)
                    task.wait()
                    game:GetService("ReplicatedStorage").Events.Revive.RevivePlayer:FireServer(tostring(downedplr), false)
                    task.wait(4.5)
                    game:GetService("ReplicatedStorage").Events.Revive.RevivePlayer:FireServer(tostring(downedplr), true)
                    game:GetService("ReplicatedStorage").Events.Revive.RevivePlayer:FireServer(tostring(downedplr), true)
                    game:GetService("ReplicatedStorage").Events.Revive.RevivePlayer:FireServer(tostring(downedplr), true)
                    break
                end
            end
        end)
    end
end

task.spawn(function()
    while task.wait() do
        if Settings.AutoRespawn then
             if localplayer.Character and localplayer.Character:GetAttribute("Downed") then
                game:GetService("ReplicatedStorage").Events.Respawn:FireServer()
             end
        end

        if Settings.NoCameraShake then
            localplayer.PlayerScripts.CameraShake.Value = CFrame.new(0,0,0) * CFrame.new(0,0,0)
        end
        if Settings.moneyfarm then
            if localplayer.Character and localplayer.Character:GetAttribute("Downed") then
                game:GetService("ReplicatedStorage").Events.Respawn:FireServer()
                task.wait(3)
            else
                revive()
                task.wait(1)
            end
        end
        if Settings.moneyfarm == false and Settings.afkfarm and localplayer.Character:FindFirstChild('HumanoidRootPart') ~= nil then
            localplayer.Character:FindFirstChild('HumanoidRootPart').CFrame = CFrame.new(6007, 7005, 8005)
        end
    end
end)

function camerashake()
    while NoCameraShake == true do task.wait()
        localplayer.PlayerScripts.CameraShake.Value = CFrame.new(0,0,0) * CFrame.new(0,0,0)
    end
end

function autodrink()
    while AutoDrink == true do
        local ohString1 = "Cola"
        game:GetService("ReplicatedStorage").Events.UseUsable:FireServer(ohString1)
        wait(6)
    end
end

function SpamChat()
    while autochat == true do
        local ohString1 = "Ravo Hub on top"
        local ohString2 = "All"
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(ohString1, ohString2)
        wait(1)
    end
end

function autowistlefunction()
    while autowistle == true do
        local ohString1 = "Whistle"
        local ohBoolean2 = true
        game:GetService("Players").LocalPlayer.PlayerScripts.Events.KeybindUsed:Fire(ohString1, ohBoolean2)
        game:GetService("ReplicatedStorage").Events.Whistle:FireServer()
        wait(5)
    end
end

function god()
    while revivedie == true do
        game:GetService("ReplicatedStorage").Events.Respawn:FireServer()
        wait()
    end
end

function dofullbright()
    Light.Ambient = Color3.new(1, 1, 1)
    Light.ColorShift_Bottom = Color3.new(1, 1, 1)
    Light.ColorShift_Top = Color3.new(1, 1, 1)
    game.Lighting.FogEnd = 100000
    game.Lighting.FogStart = 0
    game.Lighting.ClockTime = 14
    game.Lighting.Brightness = 2
    game.Lighting.GlobalShadows = false
end

function freemoney()
    while money == true do
        local ohString1 = "Free money <font color=\"rgb(100,255,100)\">($99999)</font>"
        game:GetService("Players").LocalPlayer.PlayerGui.HUD.Messages.Use:Fire(ohString1)
        wait(5)
    end
end

Luna:Notify("Welcome To Ravo Hub", "Thanks for using Ravo Hub!", 5, "rbxassetid://4483345998")

function RandomEmote()
    Luna:Notify("Random Emoting...", "You pressed the Random Emote keybind", 5, "rbxassetid://4483345998")
end

-- tab
local MainTab = Window:CreateTab("Main features", "rbxassetid://4483345998")
local MiscTab = Window:CreateTab("Extra", "rbxassetid://4483345998")
local ESPTab = Window:CreateTab("Esp", "rbxassetid://4483345998")
local TeleportTab = Window:CreateTab("Teleport", "rbxassetid://4483345998")
local FunTab = Window:CreateTab("Fun", "rbxassetid://4483345998")
local CreditsTab = Window:CreateTab("Credits", "rbxassetid://4483345998")

-- main tab shit whatever
local MiscTab3 = MainTab:CreateSection("Auto Farms")

MainTab:CreateToggle("Money Farm", false, function(Value)
    Settings.moneyfarm = Value
end)

MainTab:CreateToggle("Afk Farm", false, function(Value)
    Settings.afkfarm = Value
end)

-- slide my worm
local MainTab3 = MainTab:CreateSection("Sliders")
local Misctab5 = MiscTab:CreateSection("Sliders")

local TargetWalkspeed
MainTab:CreateSlider("Speed", 0, 250, 0, function(Value)
    TargetWalkspeed = Value
end)

MainTab:CreateSlider("Hip height", -1.40, 100, -1.40, function(HipValue)
    game.Players.LocalPlayer.Character.Humanoid.HipHeight = HipValue
end)

MainTab:CreateSlider("Fov Slider", 1, 120, 70, function(Fov)
    local ohString1 = "FieldOfView"
    local ohNumber2 = Fov
    game:GetService("ReplicatedStorage").Events.UpdateSetting:FireServer(ohString1, ohNumber2)
end)

MainTab:CreateSlider("Jump Power", 0, 120, 3, function(Value)
    Settings.Jump = Value
end)

MiscTab:CreateSlider("Day & night Slider", 0, 24, 14, function(Time)
    game.Lighting.ClockTime = Time
end)

-- togg
local FunTab2 = FunTab:CreateSection("Toggles")
local MiscTab3 = MainTab:CreateSection("Toggles")

MainTab:CreateToggle("No Camera Shake", false, function(Value)
    NoCameraShake = Value
    camerashake()
end)

MainTab:CreateToggle("Auto Drink Cola (drinks everytime it runs out)", false, function(Value)
    AutoDrink = Value
    autodrink()
end)

FunTab:CreateToggle("Spam Chat", false, function(Value)
    autochat = Value
    SpamChat()
end)

FunTab:CreateToggle("fake money giver", false, function(Value)
    money = Value
    freemoney()
end)

MainTab:CreateToggle("auto respawn (you respawn when you get downed)", false, function(Value)
    Settings.AutoRespawn = Value
end)

FunTab:CreateToggle("Auto Wistle", false, function(Value)
    autowistle = Value
    autowistlefunction()
end)

-- butts
local FunTab3 = FunTab:CreateSection("Buttons")
local MiscTab2 = MiscTab:CreateSection("Buttons")

MiscTab:CreateButton("Chat Spy", function()
    enabled = true
    spyOnMyself = false
    public = false
    publicItalics = true
    privateProperties = {
        Color = Color3.fromRGB(0,255,255); 
        Font = Enum.Font.SourceSansBold;
        TextSize = 18;
    }
    local StarterGui = game:GetService("StarterGui")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local saymsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
    local getmsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering")
    local instance = (_G.chatSpyInstance or 0) + 1
    _G.chatSpyInstance = instance

    local function onChatted(p,msg)
        if _G.chatSpyInstance == instance then
            if p==player and msg:lower():sub(1,4)=="/spy" then
                enabled = not enabled
                wait(0.3)
                privateProperties.Text = "{SPY "..(enabled and "EN" or "DIS").."ABLED}"
                StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
            elseif enabled and (spyOnMyself==true or p~=player) then
                msg = msg:gsub("[\n\r]",''):gsub("\t",' '):gsub("[ ]+",' ')
                local hidden = true
                local conn = getmsg.OnClientEvent:Connect(function(packet,channel)
                    if packet.SpeakerUserId==p.UserId and packet.Message==msg:sub(#msg-#packet.Message+1) and (channel=="All" or (channel=="Team" and public==false and Players[packet.FromSpeaker].Team==player.Team)) then
                        hidden = false
                    end
                end)
                wait(1)
                conn:Disconnect()
                if hidden and enabled then
                    if public then
                        saymsg:FireServer((publicItalics and "/me " or '').."{SPY} [".. p.Name .."]: "..msg,"All")
                    else
                        privateProperties.Text = "{SPY} [".. p.Name .."]: "..msg
                        StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
                    end
                end
            end
        end
    end

    for _,p in ipairs(Players:GetPlayers()) do
        p.Chatted:Connect(function(msg) onChatted(p,msg) end)
    end
    Players.PlayerAdded:Connect(function(p)
        p.Chatted:Connect(function(msg) onChatted(p,msg) end)
    end)
    privateProperties.Text = "{SPY "..(enabled and "EN" or "DIS").."ABLED}"
    StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
    local chatFrame = player.PlayerGui.Chat.Frame
    chatFrame.ChatChannelParentFrame.Visible = true
    chatFrame.ChatBarParentFrame.Position = chatFrame.ChatChannelParentFrame.Position+UDim2.new(UDim.new(),chatFrame.ChatChannelParentFrame.Size.Y)
    Luna:Notify("Ravo Hub", "Pressed on the Chat Spy Button", 2, "rbxassetid://4483345998")
end)

ESPTab:CreateButton("Player Esp", function()
    local c = workspace.CurrentCamera
    local ps = game:GetService("Players")
    local lp = ps.LocalPlayer
    local rs = game:GetService("RunService")
    local function getdistancefc(part)
        return (part.Position - c.CFrame.Position).Magnitude
    end
    local function esp(p, cr)
        local h = cr:WaitForChild("Humanoid")
        local hrp = cr:WaitForChild("HumanoidRootPart")
        local text = Drawing.new("Text")
        text.Visible = false
        text.Center = true
        text.Outline = true
        text.Font = 2
        text.Color = Color3.fromRGB(255, 255, 255)
        text.Size = 17
        local c1
        local c2
        local c3
        local function dc()
            text.Visible = false
            text:Remove()
            if c1 then
                c1:Disconnect()
                c1 = nil
            end
            if c2 then
                c2:Disconnect()
                c2 = nil
            end
            if c3 then
                c3:Disconnect()
                c3 = nil
            end
        end
        c2 = cr.AncestryChanged:Connect(function(_, parent)
            if not parent then
                dc()
            end
        end)
        c3 = h.HealthChanged:Connect(function(v)
            if (v <= 0) or (h:GetState() == Enum.HumanoidStateType.Dead) then
                dc()
            end
        end)
        c1 = rs.RenderStepped:Connect(function()
            local hrp_pos, hrp_os = c:WorldToViewportPoint(hrp.Position)
            if hrp_os then
                text.Position = Vector2.new(hrp_pos.X, hrp_pos.Y)
                text.Text = p.Name .. " (" .. tostring(math.floor(getdistancefc(hrp))) .. " m)"
                text.Visible = true
            else
                text.Visible = false
            end
        end)
    end
    local function p_added(p)
        if p.Character then
            esp(p, p.Character)
        end
        p.CharacterAdded:Connect(function(cr)
            esp(p, cr)
        end)
    end
    for i, p in next, ps:GetPlayers() do
        if p ~= lp then
            p_added(p)
        end
    end
    ps.PlayerAdded:Connect(p_added)
    Luna:Notify("Ravo Hub", "Pressed on the Player Esp Button", 2, "rbxassetid://4483345998")
end)

MiscTab:CreateButton("Inf Jump", function()
    local InfiniteJumpEnabled = true
    game:GetService("UserInputService").JumpRequest:connect(function()
        if InfiniteJumpEnabled then
            game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
        end
    end)
    Luna:Notify("Ravo Hub", "Pressed on the Inf Jump Button", 2, "rbxassetid://4483345998")
end)

MiscTab:CreateButton("Q to Teleport", function()
    plr = game.Players.LocalPlayer 
    hum = plr.Character.HumanoidRootPart 
    mouse = plr:GetMouse()
    mouse.KeyDown:connect(function(key)
        if key == "q" then
        if mouse.Target then
            hum.CFrame = CFrame.new(mouse.Hit.x, mouse.Hit.y + 5, mouse.Hit.z)
            end
        end
    end)
    Luna:Notify("Ravo Hub", "Pressed on the Q To Teleport Button", 2, "rbxassetid://4483345998")
end)

MiscTab:CreateButton("Full Bright", function()
    dofullbright()
    Luna:Notify("Ravo Hub", "Pressed on the Full Bright Button", 2, "rbxassetid://4483345998")
end)

MiscTab:CreateButton("Return Too Main Menu", function()
    game:GetService("ReplicatedStorage").Events.ReturnToMenu:FireServer()
end)

MiscTab:CreateButton("Low Quality", function()
    local ohString1 = "LowQuality"
    local ohBoolean2 = true
    game:GetService("ReplicatedStorage").Events.UpdateSetting:FireServer(ohString1, ohBoolean2)
    Luna:Notify("Ravo Hub", "Pressed on the Low Quality Button", 2, "rbxassetid://4483345998")
end)

FunTab:CreateButton("Free cam (shift + P)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Robobo2022/script/main/Freecam.lua"))()
    Luna:Notify("Ravo Hub", "Pressed on the Free cam Button", 2, "rbxassetid://4483345998")
end)

TeleportTab:CreateButton("Main Game", function()
    local TeleportService = game:GetService('TeleportService')
    GameId = 9872472334
    TeleportService:Teleport(GameId, game.Players.LocalPlayer)
end)

TeleportTab:CreateButton("Casual", function()
    local TeleportService = game:GetService('TeleportService')
    GameId = 10662542523
    TeleportService:Teleport(GameId, game.Players.LocalPlayer)
end)

TeleportTab:CreateButton("Social Space", function()
    local TeleportService = game:GetService('TeleportService')
    GameId = 10324347967
    TeleportService:Teleport(GameId, game.Players.LocalPlayer)
end)

TeleportTab:CreateButton("Big Team", function()
    local TeleportService = game:GetService('TeleportService')
    GameId = 10324346056
    TeleportService:Teleport(GameId, game.Players.LocalPlayer)
end)

TeleportTab:CreateButton("Team DeathMatch", function()
    local TeleportService = game:GetService('TeleportService')
    GameId = 110539706691
    TeleportService:Teleport(GameId, game.Players.LocalPlayer)
end)

TeleportTab:CreateButton("Vc Only", function()
    local TeleportService = game:GetService('TeleportService')
    GameId = 10808838353
    TeleportService:Teleport(GameId, game.Players.LocalPlayer)
end)

local MiscTab2 = MiscTab:CreateSection("Item Giver")

MiscTab:CreateButton("Test Emote (Permanant)", function()
    game:GetService("ReplicatedStorage").Events.UI.Purchase:InvokeServer("Emotes", "Test")
end)

-- keyb
local MiscTab1 = MiscTab:CreateSection("KeyBinds")
local FunTab1 = FunTab:CreateSection("KeyBinds")

MiscTab:CreateKeybind("Drink Cola", Enum.KeyCode.H, function()
    local ohString1 = "Cola"
    game:GetService("ReplicatedStorage").Events.UseUsable:FireServer(ohString1)
end)

MiscTab:CreateKeybind("Rejoin Server", Enum.KeyCode.B, function()
    Luna:Notify("You Pressed the Rejoin Keybind.", "Rejoining in 5 seconds", 5, "rbxassetid://4483345998")
    wait(1)
    Luna:Notify("Ravo Hub", "Rejoining in 4 seconds", 5, "rbxassetid://4483345998")
    wait(1)
    Luna:Notify("Ravo Hub", "Rejoining in 3 seconds", 5, "rbxassetid://4483345998")
    wait(1)
    Luna:Notify("Ravo Hub", "Rejoining in 2 seconds", 5, "rbxassetid://4483345998")
    wait(1)
    Luna:Notify("Ravo Hub", "Rejoining in 1 seconds", 5, "rbxassetid://4483345998")
    wait(1)
    Luna:Notify("Ravo Hub", "Rejoining", 5, "rbxassetid://4483345998")
    local ts = game:GetService("TeleportService")
    local p = game:GetService("Players").LocalPlayer
    ts:Teleport(game.PlaceId, p)
end)

MiscTab:CreateKeybind("Random Vote", Enum.KeyCode.X, function()
    local RandomVote = math.random(3)
    local ohNumber1 = (RandomVote)
    game:GetService("ReplicatedStorage").Events.Vote:FireServer(ohNumber1)
    Luna:Notify("Ravo Hub", "Pressed on the Random Vote Keybind", 2, "rbxassetid://4483345998")
end)

MiscTab:CreateKeybind("Respawn", Enum.KeyCode.R, function()
    game:GetService("ReplicatedStorage").Events.Respawn:FireServer()
    Luna:Notify("Respawning...", "You pressed the respawn keybind", 5, "rbxassetid://4483345998")
end)

FunTab:CreateKeybind("Random Emote", Enum.KeyCode.Z, function()
    local number = math.random(4)
    local ohString1 = (number)
    game:GetService("ReplicatedStorage").Events.Emote:FireServer(ohString1)
    RandomEmote()
end)

-- esp togg
ESPTab:CreateToggle("Bots tracers", true, function(Value)
    getgenv().toggleespmpt = Value
end)

ESPTab:CreateColorpicker("Colour", Color3.fromRGB(255, 255, 255), function(Value)
    getgenv().mptespcolour = Value
end)

-- credits
CreditsTab:CreateLabel("Owner/Main Dev: Ravo")
CreditsTab:CreateLabel("Credits: Ravo")
CreditsTab:CreateLabel("Credits: Ravo")
CreditsTab:CreateLabel("Credits: Ravo")

-- esp func
local cam = workspace.CurrentCamera
local rs = game:GetService'RunService'

getgenv().toggleespmpt = true
function esp(plr)
   if game:GetService'Players':GetPlayerFromCharacter(plr) == nil then
    local rat = Drawing.new("Line")
        rs.RenderStepped:Connect(function()
            if plr:FindFirstChild'HumanoidRootPart' then
                local vector,screen = cam:WorldToViewportPoint(plr.HumanoidRootPart.Position)
                if screen then
                    rat.Visible = toggleespmpt
                    rat.From = Vector2.new(cam.ViewportSize.X / 2,cam.ViewportSize.Y / 1)
                    rat.To = Vector2.new(vector.X,vector.Y)
                    rat.Color = getgenv().mptespcolour
                    rat.Thickness = getgenv().mptespthickness
                    else
                        rat.Visible = false
                end
                else
                    pcall(function()
                    rat.Visible = false
                    end)
            end
                if not plr:FindFirstChild'HumanoidRootPart' or not plr:FindFirstChild'HumanoidRootPart':IsDescendantOf(game:GetService'Workspace') then
                    pcall(function()
                    rat:Remove()
                    end)
            end
        end)
   end
end

for i,v in pairs(game:GetService'Workspace'.Game.Players:GetChildren()) do
    esp(v)
end

game:GetService'Workspace'.Game.Players.ChildAdded:Connect(function(plr)
    esp(plr)
end)

local old
old = hookmetamethod(game,"__namecall",newcclosure(function(self,...)
    local Args = {...}
    local method = getnamecallmethod()
    if tostring(self) == 'Communicator' and method == "InvokeServer" and Args[1] == "update" then
        return Settings.Speed, Settings.Jump 
    end
    return old(self,...)
end))

setclipboard("https://discord.gg/pH9HjecHaw")

Luna:Notify("Join Discord", "Join the Discord Copied in your clip Board", 5, "rbxassetid://4483345998")

game:GetService("RunService").RenderStepped:Connect(function()
    pcall(function()
        if game.Players.LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
            game.Players.LocalPlayer.Character:TranslateBy(game.Players.LocalPlayer.Character.Humanoid.MoveDirection * TargetWalkspeed/100)
        end
    end)
end)
