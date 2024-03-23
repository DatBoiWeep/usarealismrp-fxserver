local lightPoleModels = {
    [GetHashKey("prop_traffic_01b")] = true,
    [GetHashKey("prop_traffic_01a")] = true,
    [GetHashKey("prop_traffic_01d")] = true,
    [729253480] = true, -- street light
    [-1063472968] = true, -- street light
}

local lastFreeze = GetGameTimer()

CreateThread(function()
    while true do
        if GetGameTimer() - lastFreeze > 3500 then
            lastFreeze = GetGameTimer()
            freezeNearbyTrafficLights()
        end
        Wait(1)
    end
end)

function freezeNearbyTrafficLights()
    local objectPool = GetGamePool('CObject')
    for i = 1, #objectPool do
        if isATrafficLight(objectPool[i]) then
            FreezeEntityPosition(objectPool[i], true)
        end
    end
end

function isATrafficLight(obj)
    return lightPoleModels[GetEntityModel(obj)]
end