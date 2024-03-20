
local PROCESSING = false
local locations = {
	dutyPed = {
		x = -69.9295,
		y = 6251.2900,
		z = 30.1001,
		heading = 70.0,
		model = "s_m_y_busboy_01"
	},
	chickenCircle = {
		x = -65.0576,
		y = 6235.5122,
		z = 30.1098,
	},
	slaughterCircle = {
		x = -85.6049,
		y = 6233.5327,
		z = 30.1011,
	},
	pluckCircle = {
		x = -81.3244,
		y = 6222.3501,
		z = 30.1003,
	},
	harvestCircle = {
		x = -102.2478,
		y = 6208.6016,
		z = 30.0350,
	},
	depositCircle = {
		x = -108.3727,
		y = 6197.9922,
		z = 30.0351,
	}
}

function DrawSpecialText(m_text)
	ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end

-- S P A W N  J O B  P E D S
Citizen.CreateThread(function()
	local hash = GetHashKey(locations.dutyPed.model)
	RequestModel(hash)
	while not HasModelLoaded(hash) do
		Citizen.Wait(100)
	end

	local ped = CreatePed(4, hash, locations.dutyPed.x, locations.dutyPed.y, locations.dutyPed.z, locations.dutyPed.heading, false, true)

	SetEntityCanBeDamaged(ped,false)
	SetPedCanRagdollFromPlayerImpact(ped,false)
	TaskSetBlockingOfNonTemporaryEvents(ped,true)
	SetPedFleeAttributes(ped,0,0)
	SetPedCombatAttributes(ped,17,1)
	SetPedRandomComponentVariation(ped, true)
	TaskStartScenarioInPlace(ped, "WORLD_HUMAN_GUARD_STAND_ARMY", 0, true)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		DrawMarker(27, locations.dutyPed.x, locations.dutyPed.y, locations.dutyPed.z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 200, 180, 0, 90, 0, 0, 2, 0, 0, 0, 0)
		DrawMarker(23, locations.chickenCircle.x, locations.chickenCircle.y, locations.chickenCircle.z, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 1.0, 200, 180, 0, 92, 0, 0, 2, 0, 0, 0, 0)
		DrawMarker(23, locations.slaughterCircle.x, locations.slaughterCircle.y, locations.slaughterCircle.z, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 1.0, 200, 180, 0, 92, 0, 0, 2, 0, 0, 0, 0)
		DrawMarker(23, locations.pluckCircle.x, locations.pluckCircle.y, locations.pluckCircle.z, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 1.0, 200, 180, 0, 92, 0, 0, 2, 0, 0, 0, 0)
		DrawMarker(23, locations.harvestCircle.x, locations.harvestCircle.y, locations.harvestCircle.z, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 1.0, 200, 180, 0, 92, 0, 0, 2, 0, 0, 0, 0)
		DrawMarker(23, locations.depositCircle.x, locations.depositCircle.y, locations.depositCircle.z, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 1.0, 200, 180, 0, 92, 0, 0, 2, 0, 0, 0, 0)

		local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
		if GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, locations.dutyPed.x, locations.dutyPed.y, locations.dutyPed.z, true) < 2 then
			if not PROCESSING then
				DrawSpecialText("Press ~g~E~w~ to clock in/out for Cluckin' Bell!")
				if IsControlJustPressed(1,38) then
					TriggerServerEvent("chickenJob:toggleDuty")
				end
			end
		elseif GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, locations.chickenCircle.x, locations.chickenCircle.y, locations.chickenCircle.z, true) < 3 then
			if not PROCESSING then
				DrawSpecialText("Press ~g~E~w~ to grab a chicken")
				if IsControlJustPressed(1,38) then
					TriggerServerEvent("chickenJob:getChicken")
					Wait(5000)
				end
			end
		elseif GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, locations.slaughterCircle.x, locations.slaughterCircle.y, locations.slaughterCircle.z, true) < 3 then
			if not PROCESSING then
				DrawSpecialText("Press ~g~E~w~ to slaughter a chicken")
				if IsControlJustPressed(1,38) then
					TriggerServerEvent("chickenJob:killChicken")
					Wait(2000)
				end
			end
		elseif GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, locations.pluckCircle.x, locations.pluckCircle.y, locations.pluckCircle.z, true) < 3 then
			if not PROCESSING then
				DrawSpecialText("Press ~g~E~w~ to start plucking feathers")
				if IsControlJustPressed(1,38) then
					TriggerServerEvent("chickenJob:pluckChicken")
					Wait(2000)
				end
			end
		elseif GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, locations.harvestCircle.x, locations.harvestCircle.y, locations.harvestCircle.z, true) < 4 then
			if not PROCESSING then
				DrawSpecialText("Press ~g~E~w~ to cut the meat from the bones")
				if IsControlJustPressed(1,38) then
					TriggerServerEvent("chickenJob:chopChicken")
					Wait(2000)
				end
			end
		elseif GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, locations.depositCircle.x, locations.depositCircle.y, locations.depositCircle.z, true) < 3 then
			if not PROCESSING then
				DrawSpecialText("Press ~g~E~w~ to drop the meat in a bin")
				if IsControlJustPressed(1,38) then
					TriggerServerEvent("chickenJob:depositChickenMeat")
					Wait(2000)
				end
			end
		else	-- if player is not in range of any circle but they are processing something, kill the task
			if PROCESSING then
				TriggerServerEvent("chickenJob:killTask")
				TriggerEvent("chickenJob:endProcessingAnimation")
				TriggerEvent("usa:notify", "You went ~y~out of range~w~.")
			end
		end
	end
end)

RegisterNetEvent("chickenJob:startProcessingAnimation")
AddEventHandler("chickenJob:startProcessingAnimation", function()
	PROCESSING = true

	Citizen.CreateThread(function()
		RequestAnimDict("timetable@jimmy@ig_1@idle_a")
		while not HasAnimDictLoaded("timetable@jimmy@ig_1@idle_a") do
			Citizen.Wait(100)
		end
		local animDict = "timetable@jimmy@ig_1@idle_a"
        local animName = "hydrotropic_bud_or_something"
		TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 8.0, -8.0, -1, 49, 0.0, false, false, false)
	end)

end)

RegisterNetEvent("chickenJob:endProcessingAnimation")
AddEventHandler("chickenJob:endProcessingAnimation", function()
	ClearPedTasks(GetPlayerPed(-1))
	PROCESSING = false
end)

RegisterNetEvent("chickenJob:spawnChicken")
AddEventHandler("chickenJob:spawnChicken", function(alive)
	Citizen.CreateThread(function()
		local hash = 1794449327 -- hen hash
		RequestModel(hash)
		while not HasModelLoaded(hash) do
			Citizen.Wait(100)
		end
		local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
		local ped = CreatePed(29, hash, playerCoords.x + math.random(0,1), playerCoords.y + math.random(0,1), playerCoords.z - 0.9, math.random(0,360), true, true)
		TaskWanderStandard(ped, 10.0, 10)
		local itemToRemove = "Chicken"
		if not alive then
			SetEntityHealth(ped, 0)
			itemToRemove = "Chicken carcass"
		end
		TriggerServerEvent("chickenJob:spawnChicken", itemToRemove) -- removes chicken
	end)
end)
