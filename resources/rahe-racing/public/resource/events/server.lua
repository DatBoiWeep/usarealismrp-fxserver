--
-- Server-side event examples and functions which can be used if you need them for some custom development reasons.
--

-- Used to determine if a player can join a race. For example you can check for items/jobs here, if needed.
function isPlayerAllowedToJoinRace(playerId)
    -- Get the player's character data
    local char = exports["usa-characters"]:GetCharacter(playerId)

    -- Check if the player is on a job
    -- if char.get("job") ~= "civ" then
    --     notifyPlayer(playerId, "You are not allowed to join this race while on a job.", G_NOTIFICATION_TYPE_ERROR)
    --     return false
    -- end

    local vehicle = GetVehiclePedIsIn(GetPlayerPed(playerId), false)
	local licenseplate = GetVehicleNumberPlateText(vehicle)

    if not char.getItem(licenseplate) then
        notifyPlayer(playerId, "We can't have you race with a stolen vehicle. You'll attract cops!", G_NOTIFICATION_TYPE_ERROR)
        return false
    end
    
    return true
end

AddEventHandler('rahe-racing:server:playerJoinedRace', function(playerId)
    --print('rahe-racing:server:playerJoinedRace')
    --print(playerId)
end)

AddEventHandler('rahe-racing:server:newRaceCreated', function(startCoords, trackName, startTime, isCompetition)
    --print('rahe-racing:server:raceCreated')
    --print('startcoords: ', startCoords)
end)

AddEventHandler('rahe-racing:server:raceStarted', function(startCoords, participants)
    --print('rahe-racing:server:raceStarted')
    --print('startCoords: ', startCoords)
    --print('participants:')
    --print(DumpTable(participants))
    TriggerEvent('911:IllegalRacing', startCoords.x, startCoords.y, startCoords.z)
end)

AddEventHandler('rahe-racing:server:raceFinished', function(raceData)
    --print('rahe-racing:server:raceFinished')
    --print('raceData:')
    --print(DumpTable(raceData))
end)

function notifyPlayer(playerId, message, type)
    TriggerClientEvent('rahe-boosting:client:notify', playerId, message, type)
end