local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local raceStartedFlag = ReplicatedStorage:FindFirstChild("RaceStartedFlag")

if raceStartedFlag then
	-- Wait until raceStartedFlag is true
	raceStartedFlag:GetPropertyChangedSignal("Value"):Wait()

	if raceStartedFlag.Value == true then
		print("🏁 Race started! Checking for unoccupied cars in 10 seconds...")
		task.wait(20) -- Wait 10 seconds before checking

		for i = 1, 4 do
			local car = Workspace:FindFirstChild("car" .. i)
			if car then
				local vehicleSeat = car:FindFirstChildOfClass("VehicleSeat")
				if vehicleSeat then
					local occupant = vehicleSeat.Occupant

					-- If no occupant or not a Humanoid, remove the car
					if not occupant or not occupant:IsA("Humanoid") then
						car:Destroy()
					else
						print(".. car.Name .. " is occupied, keeping it.")
					end
				else
					print( .. car.Name .. " has no VehicleSeat!")
				end
			else
				print( .. i .. " not found in Workspace.")
			end
		end
		print(" Car cleanup complete!")
	end
else
	warn("RaceStartedFlag not found in ReplicatedStorage!")
end
