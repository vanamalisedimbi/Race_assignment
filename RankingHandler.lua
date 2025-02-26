local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent to update leaderboard
local leaderboardEvent = Instance.new("RemoteEvent")
leaderboardEvent.Name = "UpdateLeaderboardEvent"
leaderboardEvent.Parent = ReplicatedStorage

local RaceProgressModule = require(game.ServerScriptService:WaitForChild("RaceProgressModule"))

-- Function to update player ranks based on their last checkpoint & lap count
local function getSortedPlayerPositions()
	local ranking = {}

	for _, player in pairs(Players:GetPlayers()) do
		local data = RaceProgressModule.getProgress(player)
		if data then
			table.insert(ranking, { player = player, laps = data.lapsCompleted, checkpoint = data.lastCheckpoint })
		end
	end

	-- Sort players: Higher laps first, then higher checkpoint number
	table.sort(ranking, function(a, b)
		if a.laps ~= b.laps then
			return a.laps > b.laps  -- Higher laps are ranked higher
		end
		return a.checkpoint > b.checkpoint  -- If same laps, higher checkpoint wins
	end)

	return ranking
end

-- Update the leaderboard every second
while true do
	local ranking = getSortedPlayerPositions()
	leaderboardEvent:FireAllClients(ranking)
	wait(1)  -- Adjust update frequency if needed
end
