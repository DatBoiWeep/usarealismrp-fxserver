_VERSION = '4.1.4'

---------------------------------------------------------------------------
-- Variable Declarations --
---------------------------------------------------------------------------

-- Server
Users = {}
commands = {}
settings = {}
-- some of these default settings are now unused (since it was moved into the characters attribute)
settings.defaultSettings = {
	['pvpEnabled'] = true,
	['permissionDenied'] = false,
	['debugInformation'] = false,
	['startingCash'] = 5000,
	['startingBank'] = 0,
	['startingJob'] = "civ",
	['startingModel'] = "a_m_y_skater_01",
	['startingInventory'] = {},
	['startingWeapons'] = {},
	['startingVehicles'] = {},
	['startingInsurance'] = {},
	['startingLicenses'] = {},
	['enableRankDecorators'] = false,
	['moneyIcon'] = "$",
	['nativeMoneySystem'] = false,
	['commandDelimeter'] = '/'
}
settings.sessionSettings = {}
commandSuggestions = {}
local justJoined = {}

---------------------------------------------------------------------------
-- Function Definitions --
---------------------------------------------------------------------------

function getCommands()
	return commandSuggestions
end

function CanGroupTarget(group, target)
	if (group == nil or target == nil) then return false end
	return groups[group]:canTarget(target)
end

function addCommand(command, callback, suggestion)
	commands[command] = {}
	commands[command].perm = 0
	commands[command].group = "user"
	commands[command].job = "everyone"
	commands[command].cmd = callback

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end
		suggestion.job = "everyone"
		suggestion.group = "user"

		commandSuggestions[command] = suggestion
	end

	debugMsg("Command added: " .. command)
end

function addJobCommand(command, job, callback, suggestion)
	commands[command] = {}
	commands[command].perm = 0
	commands[command].group = "user"
	commands[command].job = job
	commands[command].cmd = callback

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end
		suggestion.job = job
		suggestion.group = "user"

		commandSuggestions[command] = suggestion
	end

	debugMsg("Job command added: " .. command .. ", requires job level: " .. table.concat(job, ", "))
end

function addGroupCommand(command, group, callback, suggestion)
	commands[command] = {}
	commands[command].perm = math.maxinteger
	commands[command].group = group
	commands[command].job = { "everyone" }
	commands[command].cmd = callback

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end
		suggestion.job = "everyone"
		suggestion.group = group

		commandSuggestions[command] = suggestion
	end

	debugMsg("Group command added: " .. command .. ", requires group: " .. group)
end

---------------------------------------------------------------------------
-- Event Handlers --
---------------------------------------------------------------------------

AddEventHandler('playerDropped', function()
	print("player " .. GetPlayerName(source) .. " (#" .. source .. ") dropped from the server!")
	-- update anticheese (per MrFrz's change) --
	TriggerEvent("anticheese:playerDropped", source)
	-- drop player --
	if Users[source] then
		-- log --
		TriggerEvent("chat:sendToLogFile", source, "dropped from the server! Timestamp: " .. os.date('%m-%d-%Y %H:%M:%S', os.time()))
		-- Trigger event / save player data --
		TriggerEvent("es:playerDropped", Users[source])
		Users[source] = nil
		print("removed player from essentialmode player object collection")
	else
		print("Users[source] did not exist!")
	end
end)

RegisterServerEvent('es:firstJoinProper')
AddEventHandler('es:firstJoinProper', function()
	registerUser(GetPlayerIdentifiers(source)[1], tonumber(source))
	justJoined[source] = true

	if(settings.defaultSettings.pvpEnabled)then
		TriggerClientEvent("es:enablePvp", source)
	end
end)

AddEventHandler('es:setSessionSetting', function(k, v)
	settings.sessionSettings[k] = v
end)

AddEventHandler('es:getSessionSetting', function(k, cb)
	cb(settings.sessionSettings[k])
end)

RegisterServerEvent('playerSpawn')
AddEventHandler('playerSpawn', function()
	if(justJoined[source])then
		TriggerEvent("es:firstSpawn", source, Users[source])
		justJoined[source] = nil
	end
end)

AddEventHandler("es:setDefaultSettings", function(tbl)
	for k,v in pairs(tbl) do
		if(settings.defaultSettings[k] ~= nil)then
			settings.defaultSettings[k] = v
		end
	end

	debugMsg("Default settings edited.")
end)

AddEventHandler('chatMessageLocation', function(source, n, message, location)
	if(startswith(message, settings.defaultSettings.commandDelimeter))then
		local command_args = stringsplit(message, " ")

		command_args[1] = string.gsub(command_args[1], settings.defaultSettings.commandDelimeter, "")
		command_args[1] = command_args[1]:lower()

		local command = commands[command_args[1]]
		if command then
			CancelEvent()
			if command.perm > 0 then
				if(Users[source].getPermissions() >= command.perm or groups[Users[source].getGroup()]:canTarget(command.group)) then
					command.cmd(source, command_args, Users[source], location)
				else
					TriggerClientEvent('chatMessage', source, "", {255, 50, 50}, "That command is for " .. command.group .. " and up only!");
				end
			elseif command.job ~= "everyone" then
				local character = exports["usa-characters"]:GetCharacter(source)
				local charJob = character.get("job")
				local allowed = 0;
				for k,v in pairs(command.job) do
					if charJob == v then
						command.cmd(source, command_args, character, location)
						return
					end
				end
				TriggerClientEvent('chatMessage', source, "", {255, 50, 50}, "That command is for " .. tostring(table.concat(command.job, ", ")) .. " only!");
			else
				local character = exports["usa-characters"]:GetCharacter(source)
				command.cmd(source, command_args, character, location)
			end
		else
			TriggerClientEvent("es:tryClientCommand", source, command_args)
		end
	end
end)

AddEventHandler('es:addCommand', function(command, callback, suggestion)
	addCommand(command, callback, suggestion)
end)

AddEventHandler('es:addJobCommand', function(command, job, callback, suggestion)
	addJobCommand(command, job, callback, suggestion)
end)

AddEventHandler('es:addGroupCommand', function(command, perm, callback, suggestion)
	addGroupCommand(command, perm, callback, suggestion)
end)
