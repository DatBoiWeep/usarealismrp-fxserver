-- Not used by the encrypted code. Gives you the opportunity to open the racing tablet server-side.
-- This can be used from any other server-side file by using 'exports['rahe-racing']:openRacingTablet(source)'.
function openRacingTablet(playerId)
    TriggerClientEvent('rahe-racing:client:openTablet', playerId)
end

-- Used by the encrypted code to send notifications to players.
function notifyPlayer(playerId, message)
    TriggerClientEvent('ox_lib:notify', playerId, {
        title = message,
        position = 'center-left',
        type = 'inform'
    })
end

-- Used by the encrypted code to determine if player is an admin (can verify tracks & delete all tracks).
function isPlayerAdmin(playerIdentifier, playerId)
    -- if svConfig.adminPrincipal and IsPlayerAceAllowed(playerId, 'racing.admin') then
    --     return true
    -- end

    -- for _, v in ipairs(svConfig.adminIdentifiers) do
    --     if v == playerIdentifier then
    --         return true
    --     end
    -- end

    local user = exports.essentialmode:getPlayerFromId(playerId)
    local ugroup = user.getGroup()
    local allowed = {"owner", "superadmin"}
    for i = 1, #allowed do
        if allowed[i] == ugroup then
            return true
        end
    end

    return false
end

-- Used by the encrypted code to determine the class of a vehicle.
function getVehicleClassFromHash(modelHash, vehicleId)
    for _, v in ipairs(supportedVehicles) do
        if GetHashKey(v.model) == modelHash then
            return v.class
        end
    end

    -- Returns 'C' class for a vehicle when a class wasn't found for it
    return 'C'
end

-- Used by the encrypted code to determine the name of a vehicle.
--
-- The following function is ONLY used when a vehicle doesn't return its name (is 'NULL') when using the 'GetDisplayNameFromVehicleModel' native.
-- That for example can happen when the 'gameName' and 'modelName' do not match in the vehicle meta files.
-- To circumvent the tablet displaying 'NULL' in that case, we additionally try to find a name for the vehicle from the 'supportedVehicles' list.
function getVehicleNameFromHash(modelHash)
    for _, v in ipairs(supportedVehicles) do
        if GetHashKey(v.model) == modelHash then
            return v.name
        end
    end

    -- Returns 'UNDEFINED' as the vehicle name when a name wasn't found for it
    return 'UNDEFINED'
end

function isPictureUrlValid(url)
    return url:match("https://i.imgur.com.........png") or url:match("https://i.imgur.com.........jpg")
end

-- -- Debug Stuff below
-- TriggerEvent('es:addCommand', "carclass", function(source, args, char)
--     local vehicle = GetVehiclePedIsIn(GetPlayerPed(source), false)
--     local model = GetEntityModel(vehicle)
--     local myClass = getVehicleClassFromHash(model)
--     notifyPlayer(source, "This vehicle is ".. model .. " and is a " .. myClass .. " class.")
-- end, { help = "Get Racing Items - TESTING PURPOSES" })

-- -- Testing Phase
-- TriggerEvent('es:addCommand', 'raceitems', function(source, args, char)
--     local char = exports["usa-characters"]:GetCharacter(source)
--     local itemOne = { name = "Racing Dongle", type = "misc",  quantity = 1,  legality = "legal",  weight = 1,  objectModel = "hei_prop_hst_usb_drive" }
--     local itemTwo = { name = "Tablet", type = "misc",  quantity = 1,  legality = "legal",  weight = 3,  objectModel = "imp_prop_impexp_tablet" }
--     char.giveItem(itemOne)
--     char.giveItem(itemTwo)
-- end, { help = "Get Racing Items - TESTING PURPOSES" })

-- A table of vehicles which is used by the encrypted code through 'getVehicleClassFromHash' and 'getVehicleNameFromHash' functions.
-- Feel free to add your own vehicles here. Most of the default cars are here, but modded cars have to be added yourself.
supportedVehicles = {
    -- Df Class:*
    { name = "Declasse Drift Tampa", model = "tampa2", class = "V"},
    -- CUSTOM- Df Class
    { name = "Mazda Miata", model = "na6", class = "Df" },
    { name = "Nissan 240SX", model = "rmod240sx", class = "Df" },
    { name = "Nissan 240SX (s14)", model = "silvia3", class = "Df" },
    { name = "Nissan S15", model = "s15yoshio", class = "Df" },
    { name = "Mitsubishi EVO IX", model = "evoix", class = "Df" },
    { name = "Toyota Chaser", model = "razerchaser", class = "Df" },
    { name = "1982 Datsun Bluebird 910 SSS", model = "datsun910", class = "Df" },
    { name = "1985 Toyota Sprinter Trueno GT Apex (AE86)", model = "ae86", class = "Df" },
    { name = "Chevorlet Corvette C6", model = "GODzC6FD", class = "Df" },
    { name = "Chevorlet Corvette C6 RC", model = "GODzC6FD_RC", class = "Df" },
    { name = "Ford Mustang", model = "bugfd", class = "Df" },
    -- Event Class:**
    { name = "Formula", model = "formula", class = "DD" },
    { name = "Formula", model = "formula2", class = "DD" },
    { name = "Benefactor BR8", model = "openwheel1", class = "DD" },
    { name = "Benefactor BR8", model = "openwheel2", class = "DD" },
    { name = "Bruiser", model = "bruiser", class = "DD" },
    { name = "Bruiser", model = "bruiser2", class = "DD" },
    { name = "Bruiser", model = "bruiser3", class = "DD" },
    { name = "Bruiser", model = "bruiser4", class = "DD" },
    { name = "Brutus", model = "brutus3", class = "DD" },
    { name = "Dominator", model = "dominator4", class = "DD" },
    { name = "Dominator", model = "dominator6", class = "DD" },
    { name = "Issi", model = "issi4", class = "DD" },
    { name = "Issi", model = "issi5", class = "DD" },
    { name = "Issi", model = "issi6", class = "DD" },
    { name = "Impaler", model = "impaler4", class = "DD" },
    { name = "Monster", model = "monster3", class = "DD" },
    { name = "Monster", model = "monster4", class = "DD" },
    { name = "Monster", model = "monster5", class = "DD" },
    { name = "Slamvan", model = "slamvan6", class = "DD" },
    { name = "Cerebus", model = "cerebus2", class = "DD" },
    { name = "Cerebus", model = "cerebus3", class = "DD" },
    { name = "BMW E36", model = "PV_bmwe36", class = "DD" },
    { name = "Bugatti La Voiture Noire", model = "PV_bugatti", class = "DD" },
    { name = "Bugatti Veyron", model = "PV_bugvr", class = "DD" },
    { name = "Rolls Royce Dawn", model = "PV_dawn", class = "DD" },
    { name = "Nissan GTR", model = "PV_gtr", class = "DD" },
    { name = "Jeep Wrangler", model = "PV_jeep", class = "DD" },
    { name = "Lamborghini Gallardo", model = "PV_lgss", class = "DD" },
    { name = "Range Rover", model = "PV_rover", class = "DD" },
    { name = "Lamborghini Sian", model = "PV_sianr", class = "DD" },
    { name = "Lamborghini Urus", model = "PV_urus", class = "DD" },
    -- X Class:**
    { name = "Truffade Adder", model = "adder", class = "X" },
    { name = "Truffade Nero", model = "nero", class = "X" },
    { name = "Truffade Nero (Custom)", model = "nero2", class = "X" },
    { name = "Truffade Thrax", model = "thrax", class = "X" },
    { name = "Benefactor LM87", model = "lm87", class = "X" },
    { name = "Overflod Entity MT", model = "entity3", class = "X" },
    -- CUSTOM- X Class:

    -- S Class:**
    { name = "Lampadati Tigon", model = "tigon", class = "S" },
    { name = "Pfister 811", model = "pfister811", class = "S" },
    { name = "Pegassi Vacca", model = "vacca", class = "S" },
    { name = "Progen T20", model = "t20", class = "S" },
    { name = "Pegassi Osiris", model = "osiris", class = "S" },
    { name = "Progen GP1", model = "gp1", class = "S" },
    { name = "Pegassi Reaper", model = "reaper", class = "S" },
    { name = "Pegassi Tempesta", model = "tempesta", class = "S" },
    { name = "Vapid FMJ", model = "FMJ", class = "S" },
    { name = "Progen Tyrus", model = "tyrus", class = "S" },
    { name = "Annis LE7B", model = "lE7B", class = "S" },
    { name = "Overflod Tyrant", model = "tyrant", class = "S" },
    { name = "Overflod Zeno", model = "zeno_USA", class = "S" },
    { name = "Pegassi Tezeract", model = "tezeract", class = "E" }, -- ELECTRIC
    { name = "Grotti Visione", model = "visione", class = "S" },
    { name = "Pegassi Zorrusso", model = "zorrusso", class = "S" },
    { name = "Dewbauchee Vagner", model = "vagner", class = "S" },
    { name = "Principe Deveste Eight", model = "deveste", class = "S" },
    { name = "Overflod Entity XXR", model = "entity2", class = "S" },
    { name = "Progen Emerus", model = "emerus", class = "S" },
    { name = "Benefactor Krieger", model = "krieger", class = "S" },
    { name = "Grotti Cheetah", model = "cheetah", class = "S" },
    { name = "Grotti Cheetah Classic", model = "cheetah2", class = "S" },
    { name = "Grotti Furia", model = "furia", class = "S" },
    { name = "Grotti Turismo Classic", model = "turismo2", class = "S" },
    { name = "Pegassi Infernus", model = "infernus", class = "S" },
    { name = "Pegassi Infernus Classic", model = "infernus2", class = "S" },
    { name = "Pegassi Torero", model = "torero", class = "S" },
    { name = "Pegassi Ignus", model = "ignus_USA", class = "S" },
    { name = "Dewbauchee Champion", model = "champion_USA", class = "S" },
    { name = "Benefactor Schlagen", model = "schlagen", class = "S" },
    { name = "Pegassi Zentorno", model = "zentorno", class = "S" },
    { name = "Grotti Itali GTB", model = "italigtb", class = "S" },
    { name = "Grotti Itali GTB Custom", model = "italigtb2", class = "S" },
    { name = "Grotti Itali GTO", model = "italigto", class = "S" },
    { name = "Ocelot XA-21", model = "xa21", class = "S" },
    { name = "Ubermacht SC1", model = "sc1", class = "S" },
    { name = "Ocelot Penetrator", model = "penetrator", class = "S" },
    { name = "Grotti Turismo R", model = "turismor", class = "S" },
    { name = "Obey 9F", model = "ninef", class = "S" },
    { name = "Obey 9F Cabrio", model = "ninef2", class = "S" },
    { name = "Pfister Comet SR", model = "comet5", class = "S" },
    { name = "Pfister Comet S2", model = "comet6", class = "S" },
    { name = "Pfister Comet S2 Cabrio", model = "comet7_USA", class = "S" },
    { name = "Pfister Growler", model = "growler", class = "S" },
    { name = "Lampadati Corsita", model = "corsito", class = "S" },
    { name = "Benefactor SM722", model = "sm722", class = "S" },
    { name = "Obey 10F", model = "tenf", class = "S" },
    { name = "Obey 10F Widebody", model = "tenf2", class = "S" },
    { name = "Pegassi Torero XO", model = "torero2", class = "S" },
    { name = "Karin Hotring Everon", model = "everon2", class = "S" },
    -- CUSTOM- S Class:
    { name = "Pegassi Monroe Custom", model = "monroec", class = "S" },
    -- A Class:**
    { name = "Sultan RS", model = "sultanrs", class = "A" },
    { name = "Annis Elegy Retro", model = "elegy", class = "A" },
    { name = "Bravado Banshee 900R", model = "banshee2", class = "A" },
    { name = "Schyster Deviant", model = "deviant", class = "A" },
    { name = "Pegassi Toros", model = "toros", class = "A" },
    { name = "Ubermacht Cypher", model = "cypher", class = "A" },
    { name = "Primo ARD", model = "primoard", class = "A" },
    { name = "Emperor SHEAVA", model = "sheava", class = "A" },
    { name = "Overflod Autarch", model = "autarch", class = "A" },
    { name = "Bravado Banshee", model = "banshee", class = "A" },
    { name = "Invetero Coquette", model = "coquette", class = "A" },
    { name = "Invetero Coquette D10", model = "coquette4", class = "A" },
    { name = "Albany Alpha", model = "alpha", class = "A" },
    { name = "Grotti Bestia GTS", model = "bestiagts", class = "A" },
    { name = "Grotti Carbonizzare", model = "carbonizzare", class = "A" },
    { name = "Pfister Comet", model = "comet2", class = "A" },
    { name = "Pfister Comet Retro", model = "comet3", class = "A" },
    { name = "Dinka Jester Retro", model = "jester3", class = "A" },
    { name = "Dinka Jester RR", model = "jester4", class = "A" },
    { name = "Annis Elegy RH8", model = "elegy2", class = "A" },
    { name = "Benefactor Feltzer", model = "feltzer2", class = "A" },
    { name = "Lampadati Furore GT", model = "furoregt", class = "A" },
    { name = "Dinka Jester", model = "jester", class = "A" },
    { name = "Ocelot Jugular", model = "jugular", class = "A" },
    { name = "Emperor Vectre", model = "vectre", class = "A" },
    { name = "Vapid Bullet", model = "bullet", class = "A" },
    { name = "Dewbauchee Massacro", model = "massacro", class = "A" },
    { name = "Ocelot Pariah", model = "pariah", class = "A" },
    { name = "Maibatsu Penumbra", model = "penumbra", class = "A" },
    { name = "Dewbauchee Rapid GT", model = "rapidgt", class = "A" },
    { name = "Dewbauchee Rapid GT Cabrio", model = "rapidgt2", class = "A" },
    { name = "Hijak Ruston", model = "ruston", class = "A" },
    { name = "Benefactor Schwartzer", model = "schwarzer", class = "A" },
    { name = "Dewbauchee Seven-70", model = "seven70", class = "A" },
    { name = "Dewbauchee Specter", model = "specter", class = "A" },
    { name = "Dewbauchee Specter Custom", model = "specter2", class = "A" },
    { name = "Benefactor Surano", model = "surano", class = "A" },
    { name = "Karin 190z", model = "z190", class = "A" },
    { name = "Enus Cognoscenti Cabrio", model = "cogcabrio", class = "A" },
    { name = "Ocelot F620", model = "f620", class = "A" },
    { name = "Lampadati Felon GT", model = "felon2", class = "A" },
    { name = "Obey Tailgater A", model = "tailgater2", class = "B" },
    { name = "Ubermacht Zion", model = "zion", class = "A" },
    { name = "Ubermacht Zion Cabrio", model = "zion2", class = "A" },
    { name = "Enus Paragon", model = "paragon", class = "A" },
    { name = "Enus Windsor", model = "windsor", class = "A" },
    { name = "Grotti Brioso R/A", model = "brioso", class = "A" },
    { name = "Coil Voltic", model = "voltic", class = "E" }, -- ELECTRIC
    { name = "Vapid Dominator", model = "dominator", class = "A" },
    { name = "Vapid Dominator GTX", model = "dominator3", class = "A" },
    { name = "Vapid Dominator ASP", model = "dominator7", class = "A" },
    { name = "Vapid Dominator GTT", model = "dominator8", class = "A" },
    { name = "Bravado Gauntlet", model = "gauntlet", class = "A" },
    { name = "Bravado Gauntlet Hellfire", model = "gauntlet4", class = "A" },
    { name = "Declasse Vigero ZX", model = "vigero2", class = "A" },
    { name = "Enus Stafford", model = "stafford", class = "A" },
    { name = "Vapid Blade", model = "blade", class = "A" },
    { name = "Imponte Dukes", model = "dukes", class = "A" },
    { name = "Declasse Vamos", model = "vamos", class = "A" },
    { name = "Vapid Ellie", model = "ellie", class = "A" },
    { name = "Imponte Ruiner", model = "ruiner", class = "A" },
    { name = "Declasse Sabre Turbo", model = "sabregt", class = "A" },
    { name = "Vapid Slamvan", model = "slamvan", class = "A" },
    { name = "Vapid Slamvan Custom", model = "slamvan3", class = "A" },
    { name = "Declasse Tampa", model = "tampa", class = "A" },
    { name = "Declasse Yosemite", model = "yosemite", class = "A" },
    { name = "Ubermacht Sentinel SG4", model = "sentinelsg4", class = "A" },
    { name = "Ocelot Locust", model = "locust", class = "A" },
    { name = "Ocelot Lynx", model = "lynx", class = "A" },
    { name = "Maibatsu Penumbra FF", model = "penumbra2", class = "A" },
    { name = "Obey 8F Drafter", model = "drafter", class = "A" },
    { name = "Toundra Panthere", model = "panthere", class = "A" },
    { name = "Annis 300R", model = "r300", class = "A" },
    { name = "Declasse Tahoma Coupe", model = "tahoma", class = "A" },
    { name = "Declasse Tulip M-100", model = "tulip2", class = "A" },
    { name = "Declasse Hotring Sabre", model = "hotring", class = "A" },
    -- CUSTOM- A Class:
    { name = "Karin Rebel Custom", model = "rebeld", class = "A" },
    -- B Class:**
    { name = "Imponte Beater Dukes", model = "dukes3", class = "B" },
    { name = "Pegassi Monroe", model = "monroe", class = "B" },
    { name = "Dinka RT3000", model = "rt3000", class = "B" },
    { name = "Dinka Kanjo", model = "kanjo", class = "B" },
    { name = "Karin Previon", model = "previon", class = "B" },
    { name = "Karin Calico GTF", model = "calico", class = "B" },
    { name = "Annis ZR350", model = "zr350", class = "B" },
    { name = "Annis Euros", model = "euros", class = "B" },
    { name = "Lampadati Komoda", model = "komoda", class = "B" },
    { name = "Dinka Blista", model = "blista", class = "B" },
    { name = "Dinka Sugoi", model = "sugoi", class = "B" },
    { name = "Bollokon Prairie", model = "prairie", class = "B" },
    { name = "Annis Savestra", model = "savestra", class = "B" },
    { name = "Ubermacht Sentinel", model = "sentinel", class = "B" },
    { name = "Ubermacht Sentinel XS", model = "sentinel2", class = "B" },
    { name = "Ubermacht Zion Classic", model = "zion3", class = "B" },
    { name = "Bravado Buffalo", model = "buffalo", class = "B" },
    { name = "Bravado Buffalo S", model = "buffalo2", class = "B" },
    { name = "Bravado Buffalo STX", model = "buffalo4_USA", class = "B" },
    { name = "Enus Windsor Drop", model = "windsor2", class = "B" },
    { name = "Enus Jubilee", model = "jubilee_USA", class = "B" },
    { name = "Enus Deity", model = "deity_USA", class = "B" },
    { name = "Shyster Fusilade", model = "fusilade", class = "B" },
    { name = "Karin Futo", model = "futo", class = "B" },
    { name = "Karin Kuruma", model = "kuruma", class = "B" },
    { name = "Karin Sultan MKIII", model = "sultan", class = "B" },
    { name = "Karin Sultan MKII", model = "sultan2", class = "B" },
    { name = "Karin Sultan RS Classic", model = "sultan3", class = "B" },
    { name = "Ubermacht Revolter", model = "revolter", class = "B" },
    { name = "Ubermacht Schafter", model = "schafter2", class = "B" },
    { name = "Ubermacht Schafter V12", model = "schafter3", class = "B" },
    { name = "Ubermacht Schafter V12 LWB", model = "schafter4", class = "B" },
    { name = "Ubermacht Sentinel Classic", model = "sentinel3", class = "B" },
    { name = "Enus Cognoscenti", model = "cognoscenti", class = "B" },
    { name = "Enus Cognoscenti 55", model = "cog55", class = "B" },
    { name = "Cheval Fugitive", model = "fugitive", class = "B" },
    { name = "Karin Intruder", model = "intruder", class = "B" },
    { name = "Declasse Premier", model = "premier", class = "B" },
    { name = "Zirconium Stratum", model = "stratum", class = "B" },
    { name = "Enus Super Diamond", model = "superd", class = "B" },
    { name = "Obey Tailgater", model = "tailgater", class = "B" },
    { name = "Dewbauchee Exemplar", model = "exemplar", class = "B" },
    { name = "Ocelot Jackal", model = "jackal", class = "B" },
    { name = "Ubermacht Oracle", model = "oracle", class = "B" },
    { name = "Ubermacht Oracle XS", model = "oracle2", class = "B" },
    { name = "Lampadati Felon", model = "felon", class = "B" },
    { name = "Lampadati Cinquemila", model = "cinquemila_USA", class = "B" },
    { name = "Pfister Astron", model = "astron_USA", class = "B" },
    { name = "Obey I-Wagen", model = "iwagen_USA", class = "E" }, -- ELECTRIC
    { name = "Coil Raiden", model = "raiden", class = "E" }, -- ELECTRIC
    { name = "Pfister Neon", model = "neon", class = "E" }, -- ELECTRIC
    { name = "Coil Cyclone", model = "cyclone", class = "E" }, -- ELECTRIC
    { name = "Cheval Surge", model = "surge", class = "E" }, -- ELECTRIC
    { name = "Ubermacht Rebla", model = "rebla", class = "B" },
    { name = "Gallivanter Baller LE", model = "baller3", class = "B" },
    { name = "Gallivanter Baller ST", model = "baller7_USA", class = "B" },
    { name = "Benefactor Dubsta Mandem", model = "dubsta2", class = "B" },
    { name = "Benefactor Dubsta", model = "dubsta", class = "B" },
    { name = "Bravado Gresley", model = "gresley", class = "B" },
    { name = "Enus Huntley S", model = "huntley", class = "B" },
    { name = "Obey Rocoto", model = "rocoto", class = "B" },
    { name = "Benefactor Serrano", model = "serrano", class = "B" },
    { name = "Benefactor XLS", model = "xls", class = "B" },
    { name = "Vapid Scuffvan Custom", model = "minivan2", class = "B" },
    { name = "Obey Omnis e-GT", model = "omnisegt", class = "B" },
    { name = "Rhinehart", model = "rhinehart", class = "B" },
    { name = "Imponte Ruiner ZZ-8", model = "ruiner4", class = "B" },
    { name = "Ubermacht Sentinel Classic Widebody", model = "sentinel4", class = "B" },
    { name = "Declasse Draugur", model = "draugur", class = "B" },
    { name = "BF Weevil Custom", model = "weevil2", class = "B" },
    { name = "Weeny Issi Sport", model = "issi7", class = "B" },
    { name = "Vapid Flash GT", model = "flashgt", class = "B" },
    { name = "Obey Omnis", model = "omnis", class = "B" },
    { name = "Lampadati Tropos Rallye", model = "tropos", class = "B" },
    { name = "Vapid GB200", model = "gb200", class = "B" },
    { name = "Lampadati Michelli GT", model = "michelli", class = "B" },
    { name = "Nagasaki Outlaw", model = "outlaw", class = "B" },
    { name = "Karin Everon", model = "everon", class = "B" },
    { name = "Annis Hellion", model = "hellion", class = "B" },
    { name = "Vapid Trophy Truck", model = "trophytruck", class = "B" },
    { name = "Vapid Desert Raid", model = "trophytruck2", class = "B" },
    { name = "Vapid Slamvan", model = "slamvan2", class = "B" },
    { name = "RUNE Cheburek", model = "cheburek", class = "B" },
    { name = "Albany Buccaneer", model = "buccaneer", class = "B" },
    { name = "Albany Buccaneer Custom", model = "buccaneer2", class = "B" },
    { name = "Vapid Clique", model = "clique", class = "B" },
    { name = "Willard Faction", model = "faction", class = "B" },
    { name = "Willard Faction Custom", model = "faction2", class = "B" },
    { name = "Declasse Impaler", model = "impaler", class = "B" },
    { name = "Imponte Nightshade", model = "nightshade", class = "B" },
    { name = "Imponte Phoenix", model = "phoenix", class = "B" },
    { name = "Cheval Picador", model = "picador", class = "B" },
    { name = "Bravado Rat-Truck", model = "ratloader2", class = "B" },
    { name = "Declasse Sabre Turbo Custom", model = "sabregt2", class = "B" },
    { name = "Declasse Stallion", model = "stalion", class = "B" },
    { name = "Declasse Tulip", model = "tulip", class = "B" },
    { name = "Declasse Vigero", model = "vigero", class = "B" },
    { name = "Albany Virgo", model = "virgo", class = "B" },
    { name = "Benefactor Stirling GT", model = "feltzer3", class = "B" },
    { name = "Lampadati Casco", model = "casco", class = "B" },
    { name = "Invetero Coquette Classic", model = "coquette2", class = "B" },
    { name = "Invetero Coquette Blackfin", model = "coquette3", class = "B" },
    { name = "Grotti GT500", model = "gt500", class = "B" },
    { name = "Declasse Mamba", model = "mamba", class = "B" },
    { name = "Grotti Stinger", model = "stinger", class = "B" },
    { name = "Grotti Stinger GT", model = "stingergt", class = "B" },
    { name = "Ocelot Swinger", model = "swinger", class = "B" },
    { name = "Lampadati Viseris", model = "viseris", class = "B" },
    { name = "Dewbauchee Rapid GT Classic", model = "rapidgt3", class = "B" },
    { name = "Bravado Gauntlet Classic", model = "gauntlet3", class = "B" },
    { name = "Bravado Gauntlet Classic Custom", model = "gauntlet5", class = "B" },
    { name = "Coil Savanna", model = "savanna", class = "B" },
    { name = "Albany VSTR", model = "vstr", class = "B" },
    { name = "Lampadati Novak", model = "novak", class = "B" },
    { name = "BF Club", model = "club", class = "B" },
    { name = "Vapid Retinue", model = "retinue", class = "B" },
    { name = "Vapid Retinue MkII", model = "retinue2", class = "B" },
    { name = "Maxwell Vagrant", model = "vagrant", class = "B" },
    { name = "Weeny Issi Sport", model = "issi8", class = "B" },
    -- CUSTOM- B Class:
    { name = "Voodoo Caddy S", model = "voodoo_caddys", class = "B" },
    { name = "Dababy Car", model = "dababy", class = "B" },
    { name = "Progen Proff", model = "proff", class = "B" },
    { name = "Karin Ariant", model = "ariant", class = "B"},
    { name = "Karin Asteropers", model = "asteropers", class = "B"},
    { name = "Albany Esperanto", model = "vwe_esperanto1", class = "B"},
    -- C Class:**
    { name = "Declasse Yosemite Rancher", model = "yosemite3", class = "C" },
    { name = "Dinka Blista Compact", model = "blista2", class = "C" },
    { name = "Karin Asterope", model = "asterope", class = "C" },
    { name = "Vulcar Ingot", model = "ingot", class = "C" },
    { name = "Albany Primo", model = "primo", class = "C" },
    { name = "Albany Primo Custom", model = "primo2", class = "C" },
    { name = "Vapid Stanier", model = "stanier", class = "C" },
    { name = "Vapid Taxi", model = "taxi", class = "C" },
    { name = "Dundreary Stretch", model = "stretch", class = "C" },
    { name = "Vulcar Warrener", model = "warrener", class = "C" },
    { name = "Albany Washington", model = "washington", class = "C" },
    { name = "Weeny Issi", model = "issi2", class = "C" },
    { name = "Benefactor Panto", model = "panto", class = "C" },
    { name = "Declasse Rhapsody", model = "rhapsody", class = "C" },
    { name = "Annis Remus", model = "remus", class = "C" },
    { name = "Gallivanter Baller", model = "baller", class = "C" },
    { name = "Gallivanter Baller", model = "baller2", class = "C" },
    { name = "Karin BeeJay XL", model = "bjxl", class = "C" },
    { name = "Albany Cavalcade", model = "cavalcade", class = "C" },
    { name = "Albany Cavalcade", model = "cavalcade2", class = "C" },
    { name = "Fathom FQ-2", model = "fq2", class = "C" },
    { name = "Declasse Granger", model = "granger", class = "C" },
    { name = "Declasse Granger 3600LX", model = "granger2_USA", class = "C" },
    { name = "Emperor Habanero", model = "habanero", class = "C" },
    { name = "Dundreary Landstalker", model = "landstalker", class = "C" },
    { name = "Mammoth Patriot", model = "patriot", class = "C" },
    { name = "Mammoth Patriot WCR", model = "patriot2", class = "C" },
    { name = "Mammoth Patriot Mil-Spec", model = "patriot3_USA", class = "C" },
    { name = "Vapid Radius", model = "radi", class = "C" },
    { name = "Canis Seminole", model = "seminole", class = "C" },
    { name = "Canis Seminole Frontier", model = "seminole2", class = "C" },
    { name = "Bravado Youga", model = "youga", class = "C" },
    { name = "Grotti Brioso 300 Widebody", model = "brioso3", class = "C" },
    { name = "Dinka Kanjo SJ", model = "kanjosj", class = "C" },
    { name = "Dinka Postlude", model = "postlude", class = "C" },
    { name = "Bravado Greenwood", model = "greenwood", class = "C" },
    { name = "MTL Dune", model = "rallytruck", class = "C" },
    { name = "Vapid Caracara", model = "caracara2", class = "C" },
    { name = "Vapid Contender", model = "contender", class = "C" },
    { name = "Bravado Rumpo Custom", model = "rumpo3", class = "C" },
    { name = "Benefactor Streiter", model = "streiter", class = "C" },
    { name = "Canis Mesa", model = "mesa", class = "C" },
    { name = "Canis Mesa Lifted", model = "mesa3", class = "C" },
    { name = "Pfister Comet Safari", model = "comet4", class = "C" },
    { name = "BF Bifta", model = "bifta", class = "C" },
    { name = "Nagasaki Street Blazer", model = "blazer4", class = "C" },
    { name = "Coil Brawler", model = "brawler", class = "C" },
    { name = "Benefactor Dubsta 6x6", model = "dubsta3", class = "C" },
    { name = "BF Dune Buggy", model = "dune", class = "C" },
    { name = "BF Injection", model = "bfinjection", class = "C" },
    { name = "Canis Kamacho", model = "kamacho", class = "C" },
    { name = "Karin Rebel", model = "rebel", class = "C" },
    { name = "Karin Rebel", model = "rebel2", class = "C" },
    { name = "Vapid Guardian", model = "guardian", class = "C" },
    { name = "Bravado Bison", model = "bison", class = "C" },
    { name = "Vapid Bobcat XL", model = "bobcatxl", class = "C" },
    { name = "Vapid Riata", model = "riata", class = "C" },
    { name = "Benefactor Glendale", model = "glendale", class = "C" },
    { name = "Vulcar Fagaloa", model = "fagaloa", class = "C" },
    { name = "Weeny Issi Classic", model = "issi3", class = "C" },
    { name = "Willard Faction Donk", model = "faction3", class = "C" },
    { name = "Vapid Chino", model = "chino", class = "C" },
    { name = "Vapid Chino Custom", model = "chino2", class = "C" },
    { name = "Vapid Hotknife", model = "hotknife", class = "C" },
    { name = "Albany Roosevelt", model = "btype", class = "C" },
    { name = "Albany Roosevelt Valor", model = "btype3", class = "C" },
    { name = "Truffade Z-Type", model = "ztype", class = "C" },
    { name = "Declasse Moonbeam", model = "moonbeam", class = "C" },
    { name = "Declasse Moonbeam Custom", model = "moonbeam2", class = "C" },
    { name = "Bravado Rat-Loader", model = "ratloader", class = "C" },
    { name = "Dewbauchee JB 700", model = "jb7002", class = "C" },
    { name = "Vulcar Nebula Turbo", model = "nebula", class = "C" },
    { name = "Imponte Deluxo", model = "deluxo2", class = "C" },
    { name = "Benefactor Glendale Custom", model = "glendale2", class = "C" },
    { name = "Dundreary Landstalker XL", model = "landstlkr2", class = "C" },
    { name = "Coil Brawler HOA", model = "hoabrawler", class = "C" },
    { name = "Canis Freecrawler", model = "freecrawler", class = "C" },
    { name = "Karin Boor", model = "boor", class = "C" },
    { name = "Classique Broadway", model = "broadway", class = "C" },
    { name = "Bravado", model = "eudora", class = "C" },
    -- CUSTOM- C Class:
    { name = "Weeny Tamworth", model = "tamworth", class = "C" },
    -- D Class:**
    { name = "Bravado Youga Classic 4x4", model = "youga3", class = "D" },
    { name = "Bravado Youga Custom", model = "youga4_USA", class = "D" },
    { name = "Albany Manana Custom", model = "manana2", class = "D" },
    { name = "Declasse Asea", model = "asea", class = "D" },
    { name = "Declasse Silverstar", model = "silverstar", class = "D" },
    { name = "Declasse Silverstar 2", model = "silverstar2", class = "D" },
    { name = "Declasse Emperor", model = "emperor", class = "D" },
    { name = "Declasse Emperor", model = "emeperor2", class = "D" },
    { name = "Dundreary Regina", model = "regina", class = "D" },
    { name = "Vapid Minivan", model = "minivan", class = "D" },
    { name = "Bravado Paradise", model = "paradise", class = "D" },
    { name = "Brute Pony", model = "pony", class = "D" },
    { name = "Bravado Rumpo News", model = "rumpo", class = "D" },
    { name = "Bravado Rumpo HerrKutz", model = "rumpo2", class = "D" },
    { name = "Vapid Speedo", model = "speedo", class = "D" },
    { name = "Brute Camper", model = "camper", class = "D" },
    { name = "Declasse Burrito", model = "burrito3", class = "D" },
    { name = "Canis Kalahari", model = "kalahari", class = "D" },
    { name = "Karin Dilettante", model = "dilettante", class = "E" }, -- ELECTRIC
    { name = "Karin Dilettante Patrol", model = "dilettante2", class = "E" }, -- ELECTRIC
    { name = "Nagasaki Blazer", model = "blazer", class = "D" },
    { name = "Nagasaki Lifeguard", model = "blazer2", class = "D" },
    { name = "Canis Bodhi", model = "bodhi2", class = "D" },
    { name = "Declasse Rancher XL", model = "rancherxl", class = "D" },
    { name = "Bravado Duneloader", model = "dloader", class = "D" },
    { name = "Vapid Sadler", model = "sadler", class = "D" },
    { name = "Vapid Sandking", model = "sandking2", class = "D" },
    { name = "Vapid Sandking XL", model = "sandking", class = "D" },
    { name = "BF Surfer", model = "surfer", class = "D" },
    { name = "BF Surfer Kona", model = "surfer2", class = "D" },
    { name = "BF Surfer Custom", model = "surfer3", class = "D" },
    { name = "Albany Hermes", model = "hermes", class = "D" },
    { name = "Albany Virgo Custom", model = "virgo2", class = "D" },
    { name = "Albany Virgo Classic", model = "virgo3", class = "D" },
    { name = "Declasse Voodoo", model = "voodoo2", class = "D" },
    { name = "Declasse Voodoo Custom", model = "voodoo", class = "D" },
    { name = "Albany Manana", model = "manana", class = "D" },
    { name = "Vapid Peyote", model = "peyote", class = "D" },
    { name = "Declasse Tornado", model = "tornado", class = "D" },
    { name = "Declasse Tornado Cabrio", model = "tornado2", class = "D" },
    { name = "Declasse Tornado", model = "tornado3", class = "D" },
    { name = "Declasse Tornado Custom", model = "tornado5", class = "D" },
    { name = "Lampadati Pigalle", model = "pigalle", class = "D" },
    { name = "Zirconium Journey", model = "journey", class = "D" },
    { name = "Zirconium Journey II", model = "journey2", class = "D" },
    { name = "Bravado Youga Classic", model = "youga2", class = "D" },
    { name = "BF Weevil", model = "weevil", class = "D" },
    { name = "Chillybin", model = "chillybin", class = "D" },
    { name = "Chariot Romero Hearse", model = "romero", class = "D" },
    { name = "Weeny Dynasty", model = "dynasty", class = "D" },
    { name = "Vapid Hustler", model = "hustler", class = "D" },
    -- CUSTOM- D Class:
}

RegisterServerCallback {
	eventName = 'rahe-racing:hasItem',
	eventCallback = function(source)
		local char = exports["usa-characters"]:GetCharacter(source)
        local reqItem = char.getItem("Tablet")
        if reqItem then
            return true
        end
        return false
	end
}
