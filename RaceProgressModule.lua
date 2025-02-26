local RaceProgressModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LeaderboardUpdateEvent = ReplicatedStorage:FindFirstChild("LeaderboardUpdateEvent")

local playerProgress = {}
RaceProgressModule.placements = {}  
RaceProgressModule.requiredLaps = 1  

function RaceProgressModule.initPlayer(player, checkpoints)
	playerProgress[player] = {
		lastCheckpoint = 0,
		checkpointsHit = {},
		lapsCompleted = 0,
		startedRace = false,
		lastLapTime = 0,
		startTime = nil,  
		finishTime = nil  
	}
	for _, checkpoint in ipairs(checkpoints) do
		playerProgress[player].checkpointsHit[checkpoint.Name] = false
	end
end

function RaceProgressModule.updateCheckpoint(player, checkpointName, checkpointIndex)
	if playerProgress[player] then
		if not playerProgress[player].startedRace then
			playerProgress[player].startedRace = true
			playerProgress[player].startTime = tick()  
		end

		playerProgress[player].lastCheckpoint = checkpointIndex
		playerProgress[player].checkpointsHit[checkpointName] = true
	end
end

function RaceProgressModule.completeLap(player)
	if playerProgress[player] then
		playerProgress[player].lapsCompleted = playerProgress[player].lapsCompleted + 1
		print(player.Name .. " has completed " .. playerProgress[player].lapsCompleted .. " laps.")

		-- Check if player has finished required laps
		if playerProgress[player].lapsCompleted >= RaceProgressModule.requiredLaps then
			local finishTime = tick() - playerProgress[player].startTime
			playerProgress[player].finishTime = finishTime

			local position = #RaceProgressModule.placements + 1
			table.insert(RaceProgressModule.placements, {player = player, position = position, time = finishTime})

			print("🏁 " .. player.Name .. " finished at position #" .. position .. " with time: " .. finishTime .. "s")

			-- ✅ Fire event only to **finished players**
			local finishedPlayers = {}
			for _, entry in ipairs(RaceProgressModule.placements) do
				table.insert(finishedPlayers, {name = entry.player.Name, position = entry.position, time = entry.time})
			end

			for _, entry in ipairs(RaceProgressModule.placements) do
				LeaderboardUpdateEvent:FireClient(entry.player, finishedPlayers)
			end

			return true, position
		end

		-- Reset checkpoint progress for the next lap:
		playerProgress[player].lastCheckpoint = 0
		for checkpointName in pairs(playerProgress[player].checkpointsHit) do
			playerProgress[player].checkpointsHit[checkpointName] = false
		end
	end
	return false
end

function RaceProgressModule.getProgress(player)
	return playerProgress[player]
end

return RaceProgressModule
