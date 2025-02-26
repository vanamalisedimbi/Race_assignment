local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local gamePlaceId = game.PlaceId  -- Gets the current game’s Place ID
local raceStartedFlag = ReplicatedStorage:FindFirstChild("RaceStartedFlag")

-- Function to handle new players trying to join
local function onPlayerAdded(player)
	if raceStartedFlag and raceStartedFlag.Value == true then
		-- Instead of kicking, teleport them to a different instance
		local success, errorMessage = pcall(function()
			TeleportService:Teleport(gamePlaceId, player)
		end)

		if not success then
			player:Kick("The race has started. Please rejoin.")
		end
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
