local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Ensure necessary objects exist
local countdownEvent = ReplicatedStorage:FindFirstChild("CountdownEvent") or Instance.new("RemoteEvent")
countdownEvent.Name = "CountdownEvent"
countdownEvent.Parent = ReplicatedStorage

local raceStartedFlag = ReplicatedStorage:FindFirstChild("RaceStartedFlag") or Instance.new("BoolValue")
raceStartedFlag.Name = "RaceStartedFlag"
raceStartedFlag.Parent = ReplicatedStorage
raceStartedFlag.Value = false

local raceStartTime = ReplicatedStorage:FindFirstChild("RaceStartTime") or Instance.new("NumberValue")
raceStartTime.Name = "RaceStartTime"
raceStartTime.Parent = ReplicatedStorage
raceStartTime.Value = 0

-- Function to freeze/unfreeze players
local function setPlayerMovement(player, canMove)
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = canMove and 16 or 0 -- Default walk speed is 16
			humanoid.JumpPower = canMove and 50 or 0 -- Default jump power is 50
		end
	end
end

local function startCountdown()
	-- Freeze all players
	for _, player in pairs(Players:GetPlayers()) do
		setPlayerMovement(player, false)
	end

	-- Start countdown
	for i = 3, 1, -1 do
		countdownEvent:FireAllClients(tostring(i))
		wait(1)
	end

	countdownEvent:FireAllClients("GO!")
	wait(1)
	countdownEvent:FireAllClients("Hide")

	-- Start race and unfreeze players
	raceStartTime.Value = tick() -- Set race start time
	print("Race started at:", raceStartTime.Value) -- Debugging

	for _, player in pairs(Players:GetPlayers()) do
		setPlayerMovement(player, true)
	end

	raceStartedFlag.Value = true
end

-- Start countdown when at least 2 players join
Players.PlayerAdded:Connect(function()
	if #Players:GetPlayers() >= 2 and not raceStartedFlag.Value then
		wait(2)
		startCountdown()
	end
end)

-- Reset race flag when the race ends (ensure a new race can start)
game:BindToClose(function()
	raceStartedFlag.Value = false
	raceStartTime.Value = 0
end)
