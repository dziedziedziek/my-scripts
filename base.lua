print("test")

getgenv().PotatoHubAutoLoad = true

local function queue(code)
    if syn and syn.queue_on_teleport then
        syn.queue_on_teleport(code)
    elseif queue_on_teleport then
        queue_on_teleport(code)
    elseif fluxus and fluxus.queue_on_teleport then
        fluxus.queue_on_teleport(code)
    else
        warn("Executor nie wspiera auto execute po teleport")
    end
end

if getgenv().PotatoHubAutoLoad then
    game.Players.LocalPlayer.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Started then
            task.wait(2) -- ważne dla Xeno

            queue([[
                loadstring(https://raw.githubusercontent.com/dziedziedziek/my-scripts/refs/heads/main/base.lua"))()
            ]])
        end
    end)
end

-- SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PotatoHub"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 420, 0, 300)
main.Position = UDim2.new(0.5, -210, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(10,10,10)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255,200,0)
stroke.Thickness = 2

-- GRADIENT
local gradient = Instance.new("UIGradient", main)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20,20,20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60,50,0))
}

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = "🥔 Potato Hub"
title.TextColor3 = Color3.fromRGB(255,220,0)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = main

-- CONTAINER
local container = Instance.new("Frame")
container.Size = UDim2.new(1,-20,1,-60)
container.Position = UDim2.new(0,10,0,55)
container.BackgroundTransparency = 1
container.Parent = main

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,10)

-- AUTO JOIN SYSTEM
local AutoJoinEnabled = false
local PLACE_ID = game.PlaceId

local function AutoJoin()
    local servers = {}

    pcall(function()
        local url = "https://games.roblox.com/v1/games/"..PLACE_ID.."/servers/Public?sortOrder=Asc&limit=100"
        local response = game:HttpGet(url)
        local data = HttpService:JSONDecode(response)

        if data and data.data then
            for _,v in pairs(data.data) do
                if v.playing < v.maxPlayers then
                    table.insert(servers, v.id)
                end
            end
        end
    end)

    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(
            PLACE_ID,
            servers[math.random(1,#servers)],
            player
        )
    end
end

-- TOGGLE BUTTON
function createToggle(text, callback)
    local state = false

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,45)
    btn.BackgroundColor3 = Color3.fromRGB(15,15,15)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Parent = container

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(255,200,0)

    -- HOVER
    btn.MouseEnter:Connect(function()
        btn:TweenSize(UDim2.new(1,0,0,50),"Out","Quad",0.15,true)
    end)

    btn.MouseLeave:Connect(function()
        btn:TweenSize(UDim2.new(1,0,0,45),"Out","Quad",0.15,true)
    end)

    btn.MouseButton1Click:Connect(function()
        state = not state

        if state then
            btn.BackgroundColor3 = Color3.fromRGB(255,200,0)
            btn.TextColor3 = Color3.fromRGB(0,0,0)
        else
            btn.BackgroundColor3 = Color3.fromRGB(15,15,15)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
        end

        callback(state)
    end)
end

-- AUTO JOIN TOGGLE
createToggle("Auto Server Hop", function(state)
    AutoJoinEnabled = state

    if state then
        task.spawn(function()
            while AutoJoinEnabled do
                AutoJoin()
                task.wait(5)
            end
        end)
    end
end)

-- SHINE
local shine = Instance.new("Frame")
shine.Size = UDim2.new(0,120,1,0)
shine.BackgroundTransparency = 0.85
shine.BackgroundColor3 = Color3.fromRGB(255,255,100)
shine.BorderSizePixel = 0
shine.Parent = main

local shineGradient = Instance.new("UIGradient", shine)
shineGradient.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0,1),
    NumberSequenceKeypoint.new(0.5,0.4),
    NumberSequenceKeypoint.new(1,1)
}

while true do
    shine.Position = UDim2.new(-0.3,0,0,0)
    shine:TweenPosition(UDim2.new(1.3,0,0,0),"Out","Linear",2,true)
    task.wait(3)
end
