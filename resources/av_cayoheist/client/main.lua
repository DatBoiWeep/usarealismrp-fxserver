local PlayerJob, busy = nil, false
data = {}
objetos = {}
guardias = {}
zones = {
	-- Don't change anything from here or it will break the whole script
	[1] = {coords = {5003.48, -5746.54, 14.84}, text = Config.Lang['hack'], dist = 1.5, event = 'av_cayoheist:keypad', info = 'keypad'}, -- Keypad.
	[2] = {coords = {4998.48, -5751.81, 14.84}, text = Config.Lang['grab'], dist = 1.5, event = 'av_cayoheist:takemoney', info = 'dinero'}, -- Money.
	[3] = {coords = {5006.69, -5756.25, 15.48}, text = Config.Lang['break'], dist = 1.0, event = 'av_cayoheist:stand', info = 'robado'}, -- Panther.
	[4] = {coords = {5010.36, -5757.16, 15.48}, text = Config.Lang['crack'], dist = 1.0, event = 'av_cayoheist:safe', info = 'safe'}, -- Basement safe.
}

RegisterNetEvent('av_cayoheist:notify')
AddEventHandler('av_cayoheist:notify', function(msg)
	TriggerEvent('notificacion','inform',msg)
--	SetNotificationTextEntry('STRING')
--	AddTextComponentString(msg)
--	DrawNotification(0,1)
end)

CreateThread(function()
	if Config.Framework == 'ESX' then
		ESX = nil
		while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
		while ESX.GetPlayerData().job == nil do
			Citizen.Wait(10)
		end
		PlayerJob = ESX.GetPlayerData().job.name
	elseif Config.Framework == 'QB' then
		QBCore = exports['qb-core']:GetCoreObject()
	else
		-- Your Framework checks
	end
	local result = TriggerServerCallback {
        eventName = 'av_cayoheist:inicio',
        args = {}
    }
	exports["bt-polyzone"]:AddBoxZone("CayoSotano", vector3(4998.08, -5742.95, 14.84), 37.6, 35.2, {
		name="CayoSotano",
		heading=57,
		debugPoly=false,
		minZ=12.00,
		maxZ=16.82
	})
	data = result
	if data['iniciado'] then 
		TriggerEvent('av_cayoheist:startloop')
	end
	while true do
		if #(GetEntityCoords(PlayerPedId()) - vector3(5010.54, -5758.55, 28.85)) < 300 then
			TriggerServerEvent('av_cayoheist:getDoors')
			break
		end
		Citizen.Wait(15000)
	end
	while true do
		local w = 500
		local coords = GetEntityCoords(PlayerPedId())
		if #(coords - vector3(5033.13, -5683.57, 19.88)) < 3 then
			w = 4
			DrawText3D(5033.13, -5683.57, 19.88, Config.Lang['jump'])
			if IsControlJustPressed(0,38) then
				local hasGrapplingHook = TriggerServerCallback {
					eventName = 'av_cayoheist:hasItem',
					args = {"Grappling Hook", false}
				}
				if hasGrapplingHook then
					cutscene(1)
				else 
					exports.globals:notify("Need grappling hook!")
				end
			end
		end
		if #(coords - vector3(4991.68, -5714.97, 19.91)) < 3 then
			w = 4
			DrawText3D(4991.68, -5714.97, 19.91, Config.Lang['exit'])
			if IsControlJustPressed(0,38) then
				cutscene(2)
			end
		end
		if #(coords - vector3(5010.54, -5758.55, 28.85)) < 1.5 then
			w = 4
			if not busy and not data['iniciado'] then
				DrawText3D(5010.54, -5758.55, 28.85, Config.Lang['startheist'])
				if IsControlJustPressed(0,38) then
					-- prevent 2 people starting at same time:
					local begin = GetGameTimer()
					local randomDelay = math.random(0, 2000)
					while GetGameTimer() - begin < randomDelay do
						Wait(1)
					end
					local isBusy = TriggerServerCallback {
						eventName = "av_cayoheist:isZoneBusy",
						args = { "startheist" }
					}
					if not isBusy then
						TriggerServerEvent("av_cayoheist:setZoneBusy", "startheist", true)
						-- og author stuff:
						local Cops = TriggerServerCallback {
								eventName = 'av_cayoheist:getCops',
								args = {}
							}
						if Cops >= Config.MinCops then
							TriggerServerEvent('av_cayoheist:Start',data['z'])
							busy = true
							CreateThread(function()
								local ped = PlayerPedId()
								local begin = GetGameTimer()
								while GetGameTimer() - begin < 10 do
									Wait(1)
								end
								SetEntityCoords(ped, 5010.7036132813, -5758.0209960938, 27.945422744751)
								SetEntityHeading(ped, 160.0)
								Wait(5000)
								SetEntityHeading(ped, 160.0)
							end)
							Office()
							while securityToken == nil do
								Wait(1)
							end
							TriggerServerEvent('av_cayoheist:rewards',data['z'],'Office', securityToken)
							busy = false
							TriggerEvent('av_cayoheist:npc')
							TriggerServerEvent("av_cayoheist:setZoneBusy", "startheist", false)
						else
							TriggerEvent('av_cayoheist:notify', Config.Lang['cops'])
						end
					else
						exports.globals:notify("Someone else is already doing it!")
					end
				end
			end
		end
		for i = 1, 5 do
			if #(coords - Config.Doors[i]['Coordinates']) < 1.5 and not busy then
				if Config.Doors[i]['Locked'] then	
					w = 4
					DrawText3D(Config.Doors[i]['Text'][1], Config.Doors[i]['Text'][2], Config.Doors[i]['Text'][3], Config.Lang['door'])
					if IsControlJustPressed(0,38) then
						busy = true

						local c4 = TriggerServerCallback {
							eventName = 'av_cayoheist:hasItem',
							args = {Config.C4Item, true} -- item name , remove? 
						}
						if c4 then
							C4Anim(i)
							if Config.C4Item then
								TriggerServerEvent('av_cayoheist:removeC4')
							end
						else
							exports.globals:notify(Config.Lang['c4'])
						end
						busy = false
					end
				end
			end
		end
		Citizen.Wait(w)
	end
end)

RegisterNetEvent('av_cayoheist:startloop')
AddEventHandler('av_cayoheist:startloop', function()
	if #(GetEntityCoords(PlayerPedId()) - vector3(5003.48, -5746.54, 14.84)) > 500 then return end
	while data['iniciado'] do -- Only render 3DText for ppl inside CayoPerico
		local w = 500
		for i = 1, #zones do
			if #(GetEntityCoords(PlayerPedId()) - vector3(zones[i]['coords'][1], zones[i]['coords'][2], zones[i]['coords'][3])) < zones[i]['dist'] then
				w = 4
				local d = zones[i]['info']
				if not busy and not data[d] then
					DrawText3D(zones[i]['coords'][1], zones[i]['coords'][2], zones[i]['coords'][3], zones[i]['text'])
					if IsControlJustPressed(0,38) then
						local begin = GetGameTimer()
						local randomDelay = math.random(0, 2000)
						while GetGameTimer() - begin < randomDelay do
							Wait(1)
						end
						local isBusy = TriggerServerCallback {
								eventName = "av_cayoheist:isZoneBusy",
								args = { i }
							}
						if not isBusy then
							TriggerServerEvent("av_cayoheist:setZoneBusy", i, true)
							busy = true
							TriggerEvent(zones[i]['event'])
						else
							exports.globals:notify("Someone already doing it!")
						end
					end
				end
			end
		end
		Citizen.Wait(w)
	end
end)

RegisterNetEvent('bt-polyzone:enter')
AddEventHandler('bt-polyzone:enter', function(name)
    if name == "CayoSotano" then
		ClearAreaOfObjects(5003.36, -5745.51, 15.50, 50.0, 0)
		if data['robado'] then
			objetos['stand'] = CreateObject(`h4_prop_h4_glass_disp_01b`, 5006.43, -5756.78, 14.48, false, false, false)
			SetEntityHeading(objetos['stand'], 332.08)
		end
		if data['lasers'] then
			LasersInit()
		end	
	end
end)

RegisterNetEvent('bt-polyzone:exit')
AddEventHandler('bt-polyzone:exit', function(name)
	if name == "CayoSotano" then
		lasers = false
    end
end)

RegisterNetEvent('av_cayoheist:keypad')
AddEventHandler('av_cayoheist:keypad', function()
	keypad('enter')
	exports["av_decrypt"]:decrypt(
	function()
		keypad('success')
		TriggerServerEvent('av_cayoheist:SyncSV','lasers',false)
		Citizen.Wait(50)
		busy = false
		TriggerServerEvent("av_cayoheist:setZoneBusy", 1, false)
	end,
	function()
		keypad('fail')
		busy = false
		TriggerServerEvent("av_cayoheist:setZoneBusy", 1, false)
	end)
end)

RegisterNetEvent('av_cayoheist:takemoney')
AddEventHandler('av_cayoheist:takemoney', function()
	money()
	while securityToken == nil do
		Wait(1)
	end
	TriggerServerEvent('av_cayoheist:rewards',data['z'],'Cash', securityToken)
	busy = false
	TriggerServerEvent("av_cayoheist:setZoneBusy", 2, false)
end)

RegisterNetEvent('av_cayoheist:stand')
AddEventHandler('av_cayoheist:stand', function()
	Stand()
	while securityToken == nil do
		Wait(1)
	end
	TriggerServerEvent('av_cayoheist:rewards',data['z'],'Panther', securityToken)
	busy = false
	TriggerServerEvent("av_cayoheist:setZoneBusy", 3, false)
end)

RegisterNetEvent('av_cayoheist:safe')
AddEventHandler('av_cayoheist:safe', function()
	local result = BasementSafe()
	if result then
		while securityToken == nil do
			Wait(1)
		end
		TriggerServerEvent('av_cayoheist:rewards',data['z'],'Safe', securityToken)
	end
	busy = false
	TriggerServerEvent("av_cayoheist:setZoneBusy", 4, false)
end)

RegisterNetEvent('av_cayoheist:npc')
AddEventHandler('av_cayoheist:npc', function()
	local x = 0
	for i=1, #Config.Cartel do
		local guardia = Config.Cartel[i]
		RequestModel(GetHashKey(guardia.ped))
		while not HasModelLoaded(GetHashKey(guardia.ped)) do
			Wait(1)
		end
		guardias[x] = CreatePed(4, GetHashKey(guardia.ped), guardia.pos[1], guardia.pos[2], guardia.pos[3], guardia.pos[4], false, true)
		NetworkRegisterEntityAsNetworked(guardias[x])
		SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(guardias[x]), true)
		SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(guardias[x]), true)
		SetPedCanSwitchWeapon(guardias[x], true)
		SetPedArmour(guardias[x], guardia.armour)
		SetPedAccuracy(guardias[x], math.random(70,90))
		SetEntityInvincible(guardias[x], false)
		SetEntityVisible(guardias[x], true)
		SetEntityAsMissionEntity(guardias[x])
		GiveWeaponToPed(guardias[x], GetHashKey(guardia.weapon), 255, false, false)
		SetPedDropsWeaponsWhenDead(guardias[x], false)
		SetPedFleeAttributes(guardias[x], 0, false)	
		SetPedRelationshipGroupHash(guardias[x], GetHashKey("CayoPericoGuards"))	
		TaskGuardCurrentPosition(guardias[x], 5.0, 5.0, 1)
		x = x + 1
	end
end)

RegisterNetEvent('av_cayoheist:copAlert')
AddEventHandler('av_cayoheist:copAlert', function()
	if PlayerJob == 'police' then
		TriggerEvent('av_cayoheist:notify', Config.Lang['CopAlert'])
		blipRobbery = AddBlipForCoord(4998.08, -5742.95, 14.84)
		SetBlipSprite(blipRobbery, 161)
		SetBlipScale(blipRobbery, 2.0)
		SetBlipColour(blipRobbery, 3)
		PulseBlip(blipRobbery)
		Wait(60000)
		RemoveBlip(blipRobbery)
	end
end)

-- ESX Event for job update
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerJob = job.name
end)

-- QB Core Event for job update / player loaded
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo.name
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    CreateThread(function()
        Wait(1000)
        QBCore.Functions.GetPlayerData(function(PlayerData)
            PlayerJob = PlayerData.job
        end)
    end)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
		if guardias then
			for i=1, #guardias do
				if DoesEntityExist(guardias[i]) then
					DeleteEntity(guardias[i])
				end
			end
		end
		if objetos['stand'] then
			DeleteObject(objetos['stand'])
		end
		if objetos['money'] then
			DeleteObject(objetos['money'])
		end
		if objetos['figuraObj'] then
			DeleteObject(objetos['figuraObj'])
		end
		if objetos['cajafuerte'] then
			DeleteObject(objetos['cajafuerte'])
		end
		ClearAreaOfObjects(5003.36, -5745.51, 15.50, 500.0, 0)
    end
end)

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end