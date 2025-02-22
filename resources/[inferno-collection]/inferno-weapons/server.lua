-- Inferno Collection Weapons Version 1.3 Beta
--
-- Copyright (c) 2019-2020, Christopher M, Inferno Collection. All rights reserved.
--
-- This project is licensed under the following:
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to use, copy, modify, and merge the software, under the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. THE SOFTWARE MAY NOT BE SOLD.
--

--
--		Nothing past this point needs to be edited, all the settings for the resource are found ABOVE this line.
--		Do not make changes below this line unless you know what you are doing!
--

-- Master Flashlight storage variable
local Flashlights = {}

-- Remove flashlights of players who are no longer in server
AddEventHandler("playerDropped", function ()
    if Flashlights[source] then Flashlights[source] = nil end

    TriggerClientEvent("Weapons:Client:Return", -1, Flashlights)
end)

-- Toggle client flashlight status
RegisterServerEvent("Weapons:Server:Toggle")
AddEventHandler("Weapons:Server:Toggle", function(bool, flashlight, weapon)
    if bool then
        Flashlights[source] = {flashlight, weapon}
    else
        Flashlights[source] = nil
    end

    TriggerClientEvent("Weapons:Client:Return", -1, Flashlights)
end)

RegisterServerCallback {
    eventName = "inferno-weapons:fetchCrosshairSetting",
    eventCallback = function(source)
        local waiting = true
        local enabled = false
        TriggerEvent('es:exposeDBFunctions', function(db)
            db.getDocumentById("crosshair-settings", GetPlayerIdentifiers(source)[1], function(doc)
                if doc then
                    enabled = doc.enabled
                end
                waiting = false
            end)
        end)
        while waiting do
            Wait(1)
        end
        return enabled
    end
}

TriggerEvent('es:addCommand', 'crosshair', function(src, args, char)
    local id = GetPlayerIdentifiers(src)[1]
    TriggerEvent('es:exposeDBFunctions', function(db)
        db.getDocumentById("crosshair-settings", id, function(doc)
            if doc then
                doc.enabled = not doc.enabled
                db.updateDocument("crosshair-settings", id, {enabled = doc.enabled}, function() end)
                TriggerClientEvent("inferno-weapons:toggleCrosshair", src, doc.enabled)
            else
                db.createDocumentWithId("crosshair-settings", {enabled = true}, id, function() end)
                TriggerClientEvent("inferno-weapons:toggleCrosshair", src, true)
            end
        end)
    end)
end, {
	help = "Enable or disable crosshair"
})

exports["globals"]:PerformDBCheck("inferno-weapons", "crosshair-settings", nil)