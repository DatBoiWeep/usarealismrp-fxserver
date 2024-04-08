local orderTargetPlayerId = 2
local newOrderItems = {}

for name, info in pairs(CONFIG.RESTAURANTS) do
    target.addPoint("mainMenu-" .. name, "Register", "fas fa-hamburger", info.REGISTER.COORDS, 1, function() end, {
        {
            name = 'newOrder',
            label = 'New Order',
            onSelect = function(a, b, entityHandle)
                -- duty check
                if not isClockedIn(info.JOB_NAME) then
                    exports.globals:notify("Must be clocked in")
                    return
                end
                -- reset new order state
                resetNewOrderState()
                -- get ID of player order is for
                orderTargetPlayerId = lib.inputDialog('Target Person SSN', {'SSN'})
                if not orderTargetPlayerId then return end
                orderTargetPlayerId = orderTargetPlayerId[1]
                -- select items to add to order
                TriggerEvent('nh-context:createMenu', info.REGISTER.MENU)
            end
        },
        {
            name = 'retrieveVehicle',
            label = 'Retrieve Delivery Vehicle',
            onSelect = function(a, b, entityHandle)
                if not isClockedIn(info.JOB_NAME) then
                    exports.globals:notify("Must be clocked in")
                    return
                end
                RequestModel(GetHashKey(info.JOB_VEHICLE.MODEL))
                while not HasModelLoaded(GetHashKey(info.JOB_VEHICLE.MODEL)) do
                    Wait(1)
                end
                local deliveryVehicle = CreateVehicle(GetHashKey(info.JOB_VEHICLE.MODEL), info.JOB_VEHICLE.SPAWN.X, info.JOB_VEHICLE.SPAWN.Y, info.JOB_VEHICLE.SPAWN.Z, (info.JOB_VEHICLE.SPAWN.HEADING or 32.7), true)
                SetVehicleLivery(deliveryVehicle, info.JOB_VEHICLE.LIVERY_NUM)
                local plate = GetVehicleNumberPlateText(deliveryVehicle)
                TriggerServerEvent("garage:giveKeyWithPlate", false, plate)
                TriggerServerEvent("fuel:setFuelAmount", plate, 100)
                TriggerEvent("usa:notify", "Retrieved", "^3INFO: ^0Delivery vehicle retrieved!")
            end
        },
        {
            name = 'toggleClockIn',
            label = 'Clock in/out',
            onSelect = function(a, b, entityHandle)
                TriggerServerEvent("bs:toggleDuty", info.JOB_NAME)
            end
        },
    })
end

for name, info in pairs(CONFIG.RESTAURANTS) do
    target.addPoint("ordersMenu-" .. name, "Orders", "fas fa-hamburger", info.COOKING.COORDS, 1, function() end, {
        {
            name = 'viewOrders',
            label = 'View Orders',
            onSelect = function(a, b, entityHandle)
                local currentOrders = TriggerServerCallback {
                    eventName = "bs:getOrders",
                    args = {
                        name
                    }
                }
                local ordersMenu = {
                    {
                        header = "Select an order to make:"
                    }
                }
                for number, items in pairs(currentOrders) do
                    local orderContentsStr = ""
                    for i = 1, #items do
                        orderContentsStr = orderContentsStr .. "(" .. items[i].quantity .. ") " .. items[i].itemName .. ", "
                    end
                    table.insert(ordersMenu, {
                        header = "Order #" .. number,
                        context = orderContentsStr,
                        event = "bs:prepareMeal",
                        args = {
                            number,
                            name
                        }
                    })
                end
                TriggerEvent('nh-context:createMenu', ordersMenu)
            end
        },
    })
end

for name, info in pairs(CONFIG.RESTAURANTS) do
    target.addPoint("counterMenu-" .. name, "Counter", "fas fa-hamburger", info.COUNTER.COORDS, 1, function() end, {
        {
            name = 'claimOrder',
            label = 'Claim Order',
            onSelect = function(a, b, entityHandle)
                if isClockedIn(info.JOB_NAME) then
                    local orderNumber = lib.inputDialog('Retrieve Order', {'Number'})
                    if not orderNumber then return end
                    orderNumber = orderNumber[1]
                    TriggerServerEvent("bs:claimOrder", orderNumber, name)
                else
                    TriggerServerEvent("bs:claimOrder", false, name)
                end
            end
        },
    })
end

function resetNewOrderState()
    orderTargetPlayerId = nil
    newOrderItems = {}
end

function isClockedIn(job)
    local charInfo = TriggerServerCallback {
        eventName = "usa-characters:getCharInfo",
        args = {}
    }
    return charInfo.job == job
end

RegisterNetEvent("bs:addOrderItem", function(itemName, restuarantName)
    -- get quantity
    local quantity = lib.inputDialog('Quantity of ' .. itemName, {'Quantity'})
    if not quantity then return end
    quantity = quantity[1]
    -- add to order
    table.insert(newOrderItems, { itemName = itemName, quantity = quantity })
    -- re open new order menu
    TriggerEvent('nh-context:createMenu', CONFIG.RESTAURANTS[restuarantName].REGISTER.MENU)
end)

RegisterNetEvent("bs:registerNewOrder", function(restuarantName)
    TriggerServerEvent("bs:registerNewOrder", orderTargetPlayerId, newOrderItems, restuarantName)
end)

RegisterNetEvent("bs:prepareMeal", function(number, restuarantName)
    local currentOrders = TriggerServerCallback {
        eventName = "bs:getOrders",
        args = {
            restuarantName
        }
    }
    local orderItems = currentOrders[number]
    local minutesToCook = 0
    for i = 1, #orderItems do
        minutesToCook = minutesToCook + (1.0 * orderItems[i].quantity)
    end
    minutesToCook = math.min(minutesToCook, 10) -- cap at 10 mins for now
    print("total cook time: " .. minutesToCook)
    if lib.progressBar({
        duration = minutesToCook * 60 * 1000,
        label = 'Preparing',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = "friends@",
            clip = "pickupwait",
            flag = 11
        },
    }) then
        TriggerServerEvent("bs:mealPrepared", number, restuarantName)
    end
end)

RegisterNetEvent("bs:toggleUniform", function(putOn, jobName) -- todo: diff uniforms for diff jobs
    if putOn then
        local OUTFIT = getOutfitFromJobName(jobName)
        local me = PlayerPedId()
        if IsPedModel(me,"mp_f_freemode_01") then
            SetPedComponentVariation(me, 3, OUTFIT.FEMALE.ARMS.COMPONENT, OUTFIT.FEMALE.ARMS.TEXTURE, 0) -- arms/hands
            SetPedComponentVariation(me, 11, OUTFIT.FEMALE.TORSO.COMPONENT, OUTFIT.FEMALE.TORSO.TEXTURE, 2) -- torso
            SetPedComponentVariation(me, 8, 7, 0, 2) -- torso 1
            SetPedComponentVariation(me, 9, 0, 0, 2) -- remove vest
            --SetPedComponentVariation(me, 7, 34,1, 2) -- ties
            SetPedComponentVariation(me, 4, 31, 2, 2) -- legs
            --SetPedComponentVariation(me, 6, 58, 1, 2) -- feet
            --SetPedPropIndex(me, 0, 1, math.random(1, 7), true) -- add headet on head (need to find right prop)
        elseif IsPedModel(me,"mp_m_freemode_01") then -- male
            SetPedComponentVariation(me, 3, OUTFIT.MALE.ARMS.COMPONENT, OUTFIT.MALE.ARMS.TEXTURE, 0) -- arms/hands
            SetPedComponentVariation(me, 11, OUTFIT.MALE.TORSO.COMPONENT, OUTFIT.MALE.TORSO.TEXTURE, 2) -- torso
            SetPedComponentVariation(me, 8, 21, 4, 2) -- accessories
            SetPedComponentVariation(me, 9, 0, 0, 2) -- remove vest
            --SetPedComponentVariation(me, 7, 9,11, 2) -- ties
            SetPedComponentVariation(me, 4, 28, 1, 2) -- legs
            --SetPedComponentVariation(me, 6, 10, 0, 0) -- feet
            --SetPedPropIndex(me, 0, 0, math.random(1, 7), true) -- add headet on head(need to find right prop)
        end
    else
        TriggerServerEvent("usa:loadPlayerComponents")
    end
end)

RegisterClientCallback {
    eventName = "bs:confirmOrder",
    eventCallback = function(price)
        local input = lib.inputDialog("Confirm order for $" .. exports.globals:comma_value(price) .. "?", {
            {type = "checkbox", label = "Yes, place order"}
        })
        if not input then return end
        return input[1]
    end
}

function getOutfitFromJobName(jobName)
    for name, info in pairs(CONFIG.RESTAURANTS) do
        if info.JOB_NAME == jobName then
            return info.OUTFIT
        end
    end
    return nil
end