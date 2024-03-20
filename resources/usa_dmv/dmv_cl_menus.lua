local vein = exports.vein -- Store it in local variable for performance reasons

local windowX, windowY
local isWindowOpened = false

local oldPlate = ""
local newPlate = ""

local disabledHotkeys = false

RegisterNetEvent("dmv:openCustomPlateMenu")
AddEventHandler("dmv:openCustomPlateMenu", function()
    isWindowOpened = true
    oldPlate = ""
    newPlate = ""
end)

local function drawLabel(text)
	vein:setNextWidgetWidth(labelWidth)
	vein:label(text)
end

Citizen.CreateThread(function()
    while true do
        if isWindowOpened then

            if not disabledHotkeys then
                disabledHotkeys = true
                TriggerEvent("hotkeys:enable", false)
            end

            vein:beginWindow(windowX, windowY) -- Mandatory

            vein:beginRow()
                drawLabel('Custom Vehicle License Plate')
            vein:endRow()

            vein:beginRow()
                drawLabel('Old Plate #')

                _, oldPlate = vein:textEdit(oldPlate, 'Old Plate', 8)
            vein:endRow()

            vein:beginRow()
                drawLabel('New Plate #')

                _, newPlate = vein:textEdit(newPlate, 'New Plate', 8)
            vein:endRow()

            if vein:button('Submit') then -- Draw button and check if it were pressed
                TriggerServerEvent("dmv:orderCustomPlate", oldPlate, newPlate)
            end

            if vein:button('Close') then -- Draw button and check if it were pressed
                isWindowOpened = false
            end

            windowX, windowY = vein:endWindow() -- Mandatory
        else
            if disabledHotkeys then
                disabledHotkeys = false
                TriggerEvent("hotkeys:enable", true)
            end
        end
        Wait(0)
    end
end)