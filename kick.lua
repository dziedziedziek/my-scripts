local Players = game:GetService("Players")

-- Funkcja wykrywająca czat
local function onPlayerAdded(player)
	player.Chatted:Connect(function(message)
		if message:lower() == ".k" then
			-- wyrzuca gracza który napisał .k
			player:Kick("Unknown Error.")
		end
	end)
end

-- dla nowych graczy
Players.PlayerAdded:Connect(onPlayerAdded)

-- dla tych co już są na serwerze
for _, player in pairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end