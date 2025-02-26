local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local racetrackFolder = Workspace:WaitForChild("RaceTrack")
local trackModel = racetrackFolder:WaitForChild("Track")

local powerUpTemplate = ReplicatedStorage:WaitForChild("PowerUp")
local powerDownTemplate = ReplicatedStorage:WaitForChild("PowerDown")

local spawnInterval = 10  -- Spawn every 10 seconds (adjustable)

-- Function to get a random "Road" part from any track segment
local function getRandomRoadPart()
	local trackSegments = trackModel:GetChildren()
	local roadParts = {}

	for _, segment in ipairs(trackSegments) do
		if segment:IsA("Model") then
			local road = segment:FindFirstChild("Road")
			if road and road:IsA("BasePart") then
				table.insert(roadParts, road)
			end
		end
	end

	if #roadParts > 0 then
		return roadParts[math.random(1, #roadParts)]
	else
		warn("No Road parts found in track!")
		return nil
	end
end

-- Function to spawn a PowerUp or PowerDown
local function spawnPowerObject(template)
	local roadPart = getRandomRoadPart()
	if roadPart then
		local powerObject = template:Clone()
		local randomOffset = Vector3.new(math.random(-5, 5), 2, math.random(-5, 5)) -- Small offset for variation
		powerObject.Position = roadPart.Position + randomOffset
		powerObject.Parent = Workspace
		print("Spawned " .. powerObject.Name .. " at", powerObject.Position)
	end
end

-- Spawn loop for PowerUps and PowerDowns
while true do
	task.wait(spawnInterval)
	spawnPowerObject(powerUpTemplate)
	task.wait(spawnInterval / 2)  -- Slight offset to prevent simultaneous spawning at the exact same time
	spawnPowerObject(powerDownTemplate)
end
