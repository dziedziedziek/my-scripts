local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

------------------------------------------------
-- ❌ DISABLE RESET BUTTON
------------------------------------------------
task.spawn(function()
	while true do
		pcall(function()
			StarterGui:SetCore("ResetButtonCallback", false)
		end)
		task.wait(1)
	end
end)

------------------------------------------------
-- 🔊 SOUND SYSTEM
------------------------------------------------
local function playSound(id, volume, pitch)
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://" .. id
	s.Volume = volume or 1
	s.PlaybackSpeed = pitch or 1
	s.Parent = SoundService
	s:Play()
	game:GetService("Debris"):AddItem(s, 5)
end

------------------------------------------------
-- 🌑 BLINDNESS (99%)
------------------------------------------------
local function addBlindness()
	local gui = Instance.new("ScreenGui")
	gui.Name = "Blindness"
	gui.Parent = game:GetService("CoreGui")

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,0,1,0)
	frame.BackgroundColor3 = Color3.new(0,0,0)
	frame.BackgroundTransparency = 0.01 -- 99% dark
	frame.BorderSizePixel = 0
	frame.Parent = gui
end

------------------------------------------------
-- 🎥 CAMERA EFFECTS
------------------------------------------------
local function cameraShake()
	task.spawn(function()
		while true do
			camera.CFrame = camera.CFrame * CFrame.new(
				math.random(-1,1)*0.1,
				math.random(-1,1)*0.1,
				0
			)
			task.wait(0.05)
		end
	end)
end

local function cameraRoll()
	task.spawn(function()
		while true do
			camera.CFrame = camera.CFrame * CFrame.Angles(0,0,math.rad(math.random(-2,2)))
			task.wait(0.1)
		end
	end)
end

local function resetCameraSmooth()
	local tween = TweenService:Create(
		camera,
		TweenInfo.new(2),
		{CFrame = camera.CFrame}
	)
	tween:Play()
end

------------------------------------------------
-- 🧱 JAIL SYSTEM
------------------------------------------------
local function createJail(character)
	local hrp = character:WaitForChild("HumanoidRootPart")
	local humanoid = character:WaitForChild("Humanoid")

	-- ragdoll
	humanoid.PlatformStand = true
	humanoid:ChangeState(Enum.HumanoidStateType.Physics)

	local size = Vector3.new(12,12,12)

	local function wall(sizeVec, offset)
		local p = Instance.new("Part")
		p.Size = sizeVec
		p.Anchored = true
		p.CanCollide = true
		p.Material = Enum.Material.Metal
		p.Transparency = 0.3
		p.Parent = workspace

		RunService.RenderStepped:Connect(function()
			if hrp then
				p.CFrame = hrp.CFrame * offset
			end
		end)
	end

	-- walls
	wall(Vector3.new(1,size.Y,size.Z), CFrame.new( size.X/2,0,0))
	wall(Vector3.new(1,size.Y,size.Z), CFrame.new(-size.X/2,0,0))
	wall(Vector3.new(size.X,size.Y,1), CFrame.new(0,0, size.Z/2))
	wall(Vector3.new(size.X,size.Y,1), CFrame.new(0,0,-size.Z/2))
	wall(Vector3.new(size.X,1,size.Z), CFrame.new(0,size.Y/2,0))

------------------------------------------------
-- 🌈 RAINBOW BLOCKS (5/s)
------------------------------------------------
	task.spawn(function()
		while character.Parent do
			for i = 1, 5 do
				local block = Instance.new("Part")
				block.Size = Vector3.new(4,1,4)
				block.Anchored = false
				block.Material = Enum.Material.Neon
				block.Color = Color3.fromHSV(math.random(),1,1)

				if hrp then
					block.Position = hrp.Position + Vector3.new(
						math.random(-6,6),
						25,
						math.random(-6,6)
					)
				end

				block.Parent = workspace
				game:GetService("Debris"):AddItem(block, 4)
			end
			task.wait(1)
		end
	end)

------------------------------------------------
-- 🎧 SOUND EFFECTS LOOP
------------------------------------------------
	task.spawn(function()
		while character.Parent do
			playSound(9120386436, 0.5, 1) -- ambient horror
			task.wait(4)

			playSound(1843529632, 0.8, 1.2) -- hit
			task.wait(3)

			playSound(9118823100, 0.4, 0.8) -- glitch
			task.wait(5)
		end
	end)

------------------------------------------------
-- 🎥 EFFECTS START
------------------------------------------------
	cameraShake()
	cameraRoll()

------------------------------------------------
-- 🌑 BLINDNESS
------------------------------------------------
	addBlindness()

------------------------------------------------
-- 💀 DEATH RESET EFFECT
------------------------------------------------
	humanoid.Died:Connect(function()
		resetCameraSmooth()
		playSound(9118823100, 1, 0.6)
	end)
end

------------------------------------------------
-- 🔁 SPAWN
------------------------------------------------
player.CharacterAdded:Connect(function(char)
	task.wait(1)
	createJail(char)
end)

if player.Character then
	createJail(player.Character)
end
