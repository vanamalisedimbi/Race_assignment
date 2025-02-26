local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RaceTimerModule = {}
local raceStartTime = nil

-- Ensure "RaceStartTime" exists in ReplicatedStorage
local raceStartTimeValue = ReplicatedStorage:FindFirstChild("RaceStartTime")
if not raceStartTimeValue then
	raceStartTimeValue = Instance.new("NumberValue")
	raceStartTimeValue.Name = "RaceStartTime"
	raceStartTimeValue.Parent = ReplicatedStorage
end

-- Function to start the timer
local function startRaceTimer()
	raceStartTime = tick()
	task.wait(0.1)  -- Ensure replication across clients
	raceStartTimeValue.Value = raceStartTime
	print("Race started! Timer set to:", raceStartTime)
end

-- Listen for race start flag
local raceStartedFlag = ReplicatedStorage:FindFirstChild("RaceStartedFlag")
if raceStartedFlag then
	raceStartedFlag.Changed:Connect(function()
		if raceStartedFlag.Value then
			startRaceTimer()
		end
	end)
end

function RaceTimerModule.getRaceStartTime()
	return raceStartTime
end

return RaceTimerModule
