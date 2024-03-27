local newOrders = {}
local preparedOrders = {}

RegisterServerEvent("bs:toggleDuty", function(jobName)
    local char = exports["usa-characters"]:GetCharacter(source)
    local businessName = ""
    if jobName == "burgershot" then
        businessName = "Burgershot"
    elseif jobName == "catcafe" then
        businessName = "Cat Cafe"
    elseif jobName == "tacofarmer" then
        businessName = "Taco Farmer"
    end
    -- check if added as employee
    if not isAnEmployee(businessName, char.get("_id")) then
        TriggerClientEvent("usa:notify", source, "You don't work here! Talk to the owners to apply.")
        return
    end
    -- toggle clock on if so
    if char.get("job") ~= jobName then
        char.set("job", jobName)
        TriggerClientEvent("usa:notify", source, "You have clocked in!")
        TriggerClientEvent("bs:toggleUniform", source, true, jobName)
    else
        char.set("job", "civ")
        TriggerClientEvent("usa:notify", source, "You have clocked out!")
        TriggerClientEvent("bs:toggleUniform", source, false, jobName)
    end
end)

RegisterServerEvent("bs:registerNewOrder", function(orderNumber, orderDetails, restuarantName)
    local src = source
    -- target customer ID check
    if not GetPlayerName(orderNumber) then
        TriggerClientEvent("usa:notify", src, "Invalid customer SSN", "^3INFO: ^0Target customer SSN not valid, try again")
        return
    end
    -- check for sufficient money and take from customer
    local orderTotal = 0
    for i = 1, #orderDetails do
        orderTotal = orderTotal + CONFIG.RESTAURANTS[restuarantName].ITEMS[orderDetails[i].itemName].PRICE * orderDetails[i].quantity
    end
    local acceptedOrder = TriggerClientCallback {
        eventName = "bs:confirmOrder",
        source = tonumber(orderNumber),
        args = {orderTotal}
    }
    if not acceptedOrder then
        TriggerClientEvent("usa:notify", src, "Person denied order")
        return
    end
    local customer = exports["usa-characters"]:GetCharacter(tonumber(orderNumber))
    if customer.get("bank") < orderTotal then
        TriggerClientEvent("usa:notify", src, "Insufficent funds", "^3INFO: ^0Not enough money! Need: $" .. exports.globals:comma_value(orderTotal))
        return
    end
    customer.removeBank(orderTotal, restuarantName)
    -- give money to business
    TriggerEvent("properties-og:depositCash", CONFIG.RESTAURANTS[restuarantName].PROPERTY_NAME, orderTotal)
    -- record new order
    orderDetails.restaurant = restuarantName
    newOrders[tostring(orderNumber)] = orderDetails
    local orderContentsStr = ""
    for i = 1, #orderDetails do
        orderContentsStr = orderContentsStr .. "(" .. orderDetails[i].quantity .. ") " .. orderDetails[i].itemName .. ", "
    end
    exports.globals:notifyPlayersWithJob(CONFIG.RESTAURANTS[restuarantName].JOB_NAME, "^3INFO: ^0New order! (#" .. orderNumber ..") " .. orderContentsStr)
end)

RegisterServerEvent("bs:mealPrepared", function(orderNumber, restaurantName)
    local orderDetails = newOrders[tostring(orderNumber)]
    local orderTotal = 0
    for i = 1, #orderDetails do
        orderTotal = orderTotal + CONFIG.RESTAURANTS[restaurantName].ITEMS[orderDetails[i].itemName].PRICE
    end
    -- put on counter
    preparedOrders[tostring(orderNumber)] = newOrders[tostring(orderNumber)]
    -- remove from current orders
    newOrders[tostring(orderNumber)] = nil
    -- notify customer order is ready
    TriggerClientEvent("usa:notify", orderNumber, "Order ready!", "^3INFO: ^0Your order is ready! Pick it up from the counter or wait for your delivery.")
end)

RegisterServerEvent("bs:claimOrder", function(desiredOrderNumber, restaurantName)
    local orderNumber = tostring(source)
    if desiredOrderNumber then
        orderNumber = desiredOrderNumber
    end
    if newOrders[orderNumber] then
        TriggerClientEvent("usa:notify", source, "Not ready", "^3INFO: ^0Your order is still being prepared")
        return
    end
    if not preparedOrders[orderNumber] and not newOrders[orderNumber] then
        TriggerClientEvent("usa:notify", source, "No order", "^3INFO: ^0You have not ordered anything")
        return
    end
    if preparedOrders[orderNumber] then
        -- drop order items for pickup
        local items = preparedOrders[orderNumber]
        if not isOrderFromRestaurant(items, restaurantName) then
            TriggerClientEvent("usa:notify", source, "No order", "^3INFO: ^0You have not ordered anything from this restaurant")
            return
        end
        for i = 1, #items do
            local itemToDrop = exports.usa_rp2:getItem(items[i].itemName)
            itemToDrop.quantity = tonumber(items[i].quantity)
            itemToDrop.coords = GetEntityCoords(GetPlayerPed(source))
            itemToDrop.playerMade = true
            TriggerEvent("interaction:addDroppedItem", itemToDrop)
        end
        -- remove order
        preparedOrders[orderNumber] = nil
    end
end)

RegisterServerCallback {
    eventName = "bs:getOrders",
    eventCallback = function(src, restuarantName)
        local ret = {}
        for number, info in pairs(newOrders) do
            if info.restaurant == restuarantName then
                ret[number] = info
            end
        end
        return ret
    end
}

function isAnEmployee(businessName, identifier)
    local ownedProperties = exports["usa-properties-og"]:GetOwnedProperties(identifier, true)
    for i = 1, #ownedProperties do
        if ownedProperties[i].name:lower() == businessName:lower() then
            return true
        end
    end
    return false
end

function isOrderFromRestaurant(items, restaurantName)
    --[[
    for i = 1, #items do
        if items[i].restaurant == restaurantName then
            return true
        end
    
    return false
    --]]
    return items.restaurant == restaurantName
end