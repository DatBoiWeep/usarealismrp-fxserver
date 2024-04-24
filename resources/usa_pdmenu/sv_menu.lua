local LEO_VEHICLES = {"polstanierp","polbuffalop","polbuffalop2", "polscoutp", "polalamop2", "polstalkerp" ,"polcarap", "poldmntp", "polvigerop","fbi2", "umcaval", "bcat", "pbus", "policet", "police4", "pbike"}

local JOB_VEHICLES = {
	["sheriff"] = LEO_VEHICLES,
	["corrections"] = LEO_VEHICLES,
	["ems"] = {"sandbulance", "firetruk", "bfdsuv", "ecara", "lguard2", "blazer"},
	["doctor"] = {"bfdsuv"}
}

RegisterServerEvent("pdmenu:checkWhitelistForGarage")
AddEventHandler("pdmenu:checkWhitelistForGarage", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local user_job = char.get("job")
	if user_job == "sheriff" or user_job == "corrections" or user_job == "ems" or user_job == "doctor" then
		TriggerClientEvent('pdmenu:openGarageMenu', source, JOB_VEHICLES[user_job], user_job)
	else
		TriggerClientEvent("usa:notify", source, "~y~You are not on duty!.")
	end
end)

RegisterServerEvent("pdmenu:checkWhitelistForCustomization")
AddEventHandler("pdmenu:checkWhitelistForCustomization", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local user_job = char.get("job")
	if user_job == "sheriff" or user_job == "corrections" or user_job == "ems" or user_job == "doctor" then
		TriggerClientEvent('pdmenu:openCustomizationMenu', source)
	else
		TriggerClientEvent("usa:notify", source, "~y~You are not on duty!.")
	end
end)
