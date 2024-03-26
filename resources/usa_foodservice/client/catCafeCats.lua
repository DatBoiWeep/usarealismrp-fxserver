local config_cl = {
    Gatos = {
        ['cat1'] = {['coords'] = vector4(-573.9, -1056.29, 22.43, 115.15),['sitting'] = true},
        ['cat2'] = {['coords'] = vector4(-574.16, -1053.91, 22.34, 146.09),['sitting'] = true},
        ['cat3'] = {['coords'] = vector4(-576.37, -1054.71, 22.43, 143.33),['sitting'] = true},
        ['cat4'] = {['coords'] = vector4(-584.91, -1052.77, 22.35, 232.57),['sitting'] = true},
        -- ['cat5'] = {['coords'] = vector4(-582.36, -1054.65, 22.43, 255.45),['sitting'] = false},
        ['cat6'] = {['coords'] = vector4(-582.18, -1056.0, 22.43, 306.29),['sitting'] = true},
        ['cat7'] = {['coords'] = vector4(-575.52, -1063.21, 22.34, 44.51),['sitting'] = true},
        ['cat8'] = {['coords'] = vector4(-581.82, -1066.43, 22.34, 287.58),['sitting'] = true},
        -- ['cat9'] = {['coords'] = vector4(-583.49, -1069.39, 22.99, 293.01) ,['sitting'] = false},
        ['cat10'] = {['coords'] = vector4(-584.27, -1065.85, 22.34, 181.7),['sitting'] = true},  
        -- ['cat11'] = {['coords'] = vector4(-581.1, -1063.61, 22.79, 219.69),['sitting'] = false},
        ['cat12'] = {['coords'] = vector4(-572.98, -1057.41, 24.5, 88.18),['sitting'] = true},
        ['cat13'] = {['coords'] = vector4(-584.21350097656, -1062.8348388672, 23.374368667603, 149.8043), ['sitting'] = true},
        ['cat14'] = {['coords'] = vector4(-583.2716, -1049.61, 22.30939, 258.2928), ['sitting'] = true},
        ['cat15'] = {['coords'] = vector4(-580.1404, -1064.758, 22.01193, 61.71033), ['sitting'] = true},
        -- ['cat16'] = {['coords'] = vector4(-583.2541, -1069.39, 22.21083, 279.8207), ['sitting'] = true},
    },
    debugMode = false
}

local spawned = false
local cats = {}

CreateThread(function()
    while true do
        Wait(500)
        local plyPed = PlayerPedId()
        local coord = GetEntityCoords(plyPed)
        local catcafe = vector3(-579.46893310547, -1058.4190673828, 22.344200134277)
        if Vdist(coord.x, coord.y, coord.z, catcafe.x, catcafe.y, catcafe.z) < 30.0 then
            if not spawned then
                spawnCats()
                spawned = true
                if config_cl.debugMode then
                    print("Cats are spawning")
                end
            end
        else
            if spawned then
                deleteCats()
                spawned = false
                if config_cl.debugMode then
                    print("Cats are despawning")
                end
            end
        end
    end
end)

function spawnCats()
    local hash = GetHashKey('a_c_cat_01')
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(10)
    end
    for key, value in pairs(config_cl.Gatos) do
        local pedCoords = vector3(value.coords.x, value.coords.y, value.coords.z - 1.0)
        local pedHeading = value.coords.w
        local ped = CreatePed(28, hash, pedCoords, pedHeading, false, true)
        SetPedCanBeTargetted(ped, false)
        SetEntityAsMissionEntity(ped, true, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        if value.sitting then
            DoRequestAnimSet('creatures@cat@amb@world_cat_sleeping_ground@idle_a')
            TaskPlayAnim(ped, 'creatures@cat@amb@world_cat_sleeping_ground@idle_a', 'idle_a', 8.0, -8, -1, 1, 0, false, false, false)
        else
            TaskWanderStandard(ped, 10.0, 0)
        end
        cats[key] = ped
    end
    SetModelAsNoLongerNeeded(hash)
end

function deleteCats()
    for key, ped in pairs(cats) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
        cats[key] = nil
    end
end

function DoRequestAnimSet(anim)
	RequestAnimDict(anim)
	while not HasAnimDictLoaded(anim) do
		Citizen.Wait(1)
	end
end