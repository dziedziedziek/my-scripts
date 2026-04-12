-- Tworzenie GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Button1 = Instance.new("TextButton")
local Button2 = Instance.new("TextButton")
local Button3 = Instance.new("TextButton")
local Button4 = Instance.new("TextButton")

-- Parent
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local SpeedValue = 30 -- ile speeda 30 (steal speed best) 59 (normal speed best)
local Enabled = false

RunService.Heartbeat:Connect(function()
    if not Enabled then return end

    local char = player.Character
    if not char then return end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if humanoid.MoveDirection.Magnitude > 0 then
        humanoid.WalkSpeed = SpeedValue
    end
end)

-- 🚀 Infinity Jump Aman TPBack + Hold + Anti-Kick
--shit code but it working so dont touch
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local humanoid
local boosting = true
local boostForce = 25   -- Naik wajar, aman anti-kick
local boostFrames = 2   -- BodyVelocity hidup beberapa frame
local boostCooldown = 0.12 -- Delay antar boost
local lastBoost = 0

-- Fungsi apply BodyVelocity sementara
local function applyBoost(root)
    if not root or boosting then return end
    local now = tick()
    if now - lastBoost < boostCooldown then return end
    lastBoost = now
    boosting = true

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(0, math.huge, 0)
    bv.P = 1250
    bv.Velocity = Vector3.new(root.Velocity.X, boostForce, root.Velocity.Z)
    bv.Parent = root

    local frameCount = 0
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if frameCount < boostFrames then
            frameCount += 1
            bv.Velocity = bv.Velocity + Vector3.new(0, 0.01, 0) -- Anti-TPBack kecil
        else
            bv:Destroy()
            conn:Disconnect()
            boosting = false
        end
    end)
end

-- Loop tiap 0.1 detik untuk hold jump
RunService.Heartbeat:Connect(function()
    if humanoid and humanoid.Health > 0 then
        local root = humanoid.Parent:FindFirstChild("HumanoidRootPart")
        if root and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            applyBoost(root)
        end
    end
end)

-- Hook saat karakter spawn
local function onSpawn(char)
    humanoid = char:WaitForChild("Humanoid", 5)
end

-- test keybind
player.CharacterAdded:Connect(onSpawn)
if player.Character then
    onSpawn(player.Character)
end
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.R then
        player:Kick("Succes! Wyjebalo cie z gry przez ukochany skrypt <3")
    end
end)

-- Frame (okno)
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 300, 0, 350) -- bylo 200
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Active = true
Frame.Draggable = true -- 🔥 można ruszać

-- Przyciski
local function setupButton(btn, text, posY)
    btn.Parent = Frame
    btn.Size = UDim2.new(0, 260, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1,1,1)
end

setupButton(Button1, "Speed", 20)
setupButton(Button2, "Infinity jump", 70)
setupButton(Button3, "Logaj <3 (R)", 120)
setupButton(Button4, "Esp potem", 170)

--------------------------------------------------
-- 📍 TU DODAJESZ LOGIKĘ
--------------------------------------------------

Button1.MouseButton1Click:Connect(function()
    print("Kliknięto Button 1")
    Enabled = not Enabled
    print("Speed:", Enabled and "ON" or "OFF")
    -- 🔽 TU wrzucasz swoje 1000 linijek
    -- np:
    -- require(script.ModuleScript)
    -- albo:
    -- loadstring(game:HttpGet("twoj_link"))()

end)


Button2.MouseButton1Click:Connect(function()
    boosting = not boosting
    print("Infinity Jump:", boosting)
end)

Button3.MouseButton1Click:Connect(function()
    print("W sukcesie wyjebalo cie z gry")
    player:Kick("Succes! Wyjebalo cie z gry przez ukochany skrypt <3")
end)

Button4.MouseButton1Click:Connect(function()
    print("to nic nie robi")
end)
