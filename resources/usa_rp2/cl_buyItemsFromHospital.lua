local FIRST_AID_KIT_FEE = 80
local WHEELCHAIR_FEE = 200

local BUY_KEY = 38

local MAX_DRAW_3D_TEXT_DISTANCE = 3

local HOSPITAL_ITEM_PURCHASE_LOCATIONS = {
    {name = "paleto", x = -254.8669, y = 6334.6440, z = 32.4272},
    {name = "pillbox", x = 312.41775512695,y = -592.96716308594, z = 43.283985137939}, 
    {name = "mt. zenoah", x = -497.9, y = -335.9, z = 34.5},
    {name = "davis", x = 307.4, y = -1433.8, z = 29.9},
    {name = "viceroy modeical", x = -811.6181640625, y = -1236.4844970703, z = 7.3374252319336},
    {name = "sandy", x = 1829.2332, y = 3673.7722, z = 34.2749},
    {name = "Pop's Pills - Store E1", x = -1226.7778320313, y = -1476.1014404297, z = 4.3738870620728},
    {name = "Pop's Pills - Store B1", x = -1254.5871582031, y = -1435.6522216797, z = 4.373884677887},
    {name = "Pop's Pills - Store D1", x = -1197.6026611328, y = -1459.0732421875, z = 4.3738880157471}
}

local nearbyHospitalBuySpots = {}

local function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
end

Citizen.CreateThread(function()
    while true do
        local me = GetPlayerPed(-1)
        local mycoords = GetEntityCoords(me)
        for i = 1, #HOSPITAL_ITEM_PURCHASE_LOCATIONS do
            local h = HOSPITAL_ITEM_PURCHASE_LOCATIONS[i]
            if Vdist(h.x, h.y, h.z, mycoords.x, mycoords.y, mycoords.z) < MAX_DRAW_3D_TEXT_DISTANCE then
                nearbyHospitalBuySpots[i] = true
            else
                nearbyHospitalBuySpots[i] = nil
            end
        end
        Wait(1000) 
    end
end)

Citizen.CreateThread(function()
    while true do
        -- draw 3d text for nearby locations:
        for i, isNearby in pairs(nearbyHospitalBuySpots) do
            local h = HOSPITAL_ITEM_PURCHASE_LOCATIONS[i]
            DrawText3D(h.x, h.y, h.z, '[E] - First Aid Kit ($' .. FIRST_AID_KIT_FEE .. ') | [Hold E] - Wheel Chair ($' .. WHEELCHAIR_FEE .. ')')
            -- listen to keypress events:
            if IsControlJustPressed(0, BUY_KEY) then
                local me = GetPlayerPed(-1)
                local mycoords = GetEntityCoords(me)
                if Vdist(h.x, h.y, h.z, mycoords.x, mycoords.y, mycoords.z) < 1.5 then
                    Wait(500)
                    if IsControlPressed(0, BUY_KEY) then
                        TriggerServerEvent("hospital:buyWheelchair")
                        Wait(1000)
                    else
                        TriggerServerEvent("hospital:buyFirstAidKit")
                    end
                end
            end
        end
        Wait(2)
    end
end)