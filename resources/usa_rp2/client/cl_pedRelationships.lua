AddRelationshipGroup('Player')
AddRelationshipGroup('CayoPericoGuards')

RegisterNetEvent("character:loaded", function(char)
    SetPedRelationshipGroupHash(PlayerPedId(), GetHashKey("Player"))
    SetRelationshipBetweenGroups(0, GetHashKey("CayoPericoGuards"), GetHashKey("CayoPericoGuards"))
	SetRelationshipBetweenGroups(5, GetHashKey("CayoPericoGuards"), GetHashKey("Player"))
	SetRelationshipBetweenGroups(5, GetHashKey("Player"), GetHashKey("CayoPericoGuards"))
end)