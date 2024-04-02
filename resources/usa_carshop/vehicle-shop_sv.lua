--# by: minipunch
--# for: USA REALISM RP
--# simple vehicle shop script to preview and purchase a vehicle

-- PERFORM FIRST TIME DB CHECK --
exports["globals"]:PerformDBCheck("vehicle-shop", "vehicles", nil)
exports["globals"]:PerformDBCheck("vehicle-shop", "test-drive-strikes", nil)

local price, vehicleName, hash, plate
local MAX_PLAYER_VEHICLES = 500

local testDrivers = {}
local stolenVehicles = {}
local lastStolenPlate = nil
local warnMinutes = 3 -- minutes until warning
local finalMinutes = 5 -- minutes until 911/seize

local vehicleShopItems = {
	["vehicles"] = {
		["Suvs"] = {
			{make = "Albany", model = "Cavalcade", price = 80000, hash = -789894171, storage_capacity = 280.0},
			{make = "Benefactor", model = "Dubsta", price = 85000, hash = 1177543287, storage_capacity = 260.0},
			{make = "Benefactor", model = "Dubsta 2", price = 90000, hash = -394074634, storage_capacity = 260.0},
			{make = "Benefactor", model = "Streiter", price = 75000, hash = "streiter", storage_capacity = 230.0},
			{make = "Bravado", model = "Gresley", price = 70000, hash = -1543762099, storage_capacity = 230.0},
			{make = "Benefactor", model = "XLS", price = 80000, hash = "xls", storage_capacity = 280.0},
			{make = "Canis", model = "Seminole", price = 65000, hash = 1221512915, storage_capacity = 230.0},
			{make = "Declasse", model = "Granger", price = 65000, hash = -1775728740, storage_capacity = 260.0},
			{make = "Declasse", model = "Granger 3600LX", price = 82000, hash = "granger2_USA", storage_capacity = 280.0},
			{make = "Dundreary", model = "Landstalker", price = 63000, hash = 1269098716, storage_capacity = 280.0},
			{make = "Emperor", model = "Habenaro", price = 62000, hash = "habanero", storage_capacity = 230.0},
			{make = "Enus", model = "Huntley", price = 103000, hash = 486987393, storage_capacity = 230.0},
			{make = "Enus", model = "Jubilee", price = 270000, hash = "jubilee_USA", storage_capacity = 230.0},
			{make = "Gallivanter", model = "Baller", price = 68000, hash = 634118882, storage_capacity = 230.0},
			{make = "Gallivanter", model = "Baller LE", price = 130000, hash = 1878062887, storage_capacity = 280.0},
			{make = "Gallivanter", model = "Baller ST", price = 135000, hash = "baller7_USA", storage_capacity = 280.0},
			{make = "Karin", model = "BeeJay XL", price = 83000, hash = "bjxl", storage_capacity = 260.0},
			{make = "Mammoth", model = "Patriot", price = 74000, hash = -808457413, storage_capacity = 260.0},
			{make = "Mammoth", model = "Patriot Mil-Spec", price = 300000, hash = "patriot3_USA", storage_capacity = 280.0},
			{make = "Obey", model = "Rocoto", price = 66000, hash = 2136773105, storage_capacity = 260.0},
			{make = "Pfister", model = "Astron", price = 216000, hash = "astron_USA", storage_capacity = 230.0},
			{make = "Phatom", model = "FQ2", price = 62000, hash = -1137532101, storage_capacity = 230.0},
			{make = "Ubermacht", model = "Rebla GTS", price = 185000, hash = "rebla", storage_capacity = 230.0},
		},
		["Coupes"] = {
			{make = "Albany", model = "Alpha", price = 160000, hash = 767087018, storage_capacity = 160.0},
			{make = "Annis", model = "ZR350", price = 130000, hash = "zr350", storage_capacity = 160.0},
			{make = "Annis", model = "Euros", price = 170000, hash = "euros", storage_capacity = 160.0},
			{make = "Annis", model = "Remus", price = 125000, hash = "remus", storage_capacity = 160.0},
			{make = "Benefactor", model = "Schwartzer", price = 180000, hash = "schwarzer", storage_capacity = 160.0},
			{make = "Benefactor", model = "Schlagen GT", price = 450000, hash = "schlagen", storage_capacity = 130.0},
			{make = "Dewbauchee", model = "Exemplar", price = 195000, hash = -5153954, storage_capacity = 160.0},
			{make = "Dinka", model = "Jester 3", price = 215000, hash = "jester3", storage_capacity = 160.0},
			{make = "Dinka", model = "Jester RR", price = 220000, hash = "jester4", storage_capacity = 160.0},
			{make = "Dinka", model = "Kanjo SJ", price = 105000, hash = "kanjosj", storage_capacity = 160.0},
			{make = "Dinka", model = "Postlude", price = 80000, hash = "postlude", storage_capacity = 160.0},
			{make = "Dinka", model = "RT3000", price = 135000, hash = "rt3000", storage_capacity = 160.0},
			{make = "Enus", model = "Cognoscenti Cabrio", price = 180000, hash = 330661258, storage_capacity = 160.0},
			{make = "Enus", model = "Windsor Cabrio", price = 320000, hash = -1930048799, storage_capacity = 160.0},
			{make = "Karin", model = "Calico GTF", price = 136000, hash = "calico", storage_capacity = 160.0},
			{make = "Karin", model = "Futo GTX", price = 130000, hash = "futo2", storage_capacity = 160.0},
			{make = "Karin", model = "Previon", price = 140000, hash = "previon", storage_capacity = 160.0},
			{make = "Karin", model = "Sultan RS Classic", price = 145000, hash = "sultan3", storage_capacity = 160.0},
			{make = "Lampadati", model = "Felon", price = 155000, hash = -391594584, storage_capacity = 160.0},
			{make = "Lampadati", model = "Michelli GT", price = 110000, hash = "michelli", storage_capacity = 160.0},
			{make = "Miabatsu", model = "Penumbra", price = 105000, hash = "penumbra", storage_capacity = 160.0},
			{make = "Ocelot", model = "Pariah", price = 200000, hash = "pariah", storage_capacity = 160.0},
			{make = "Ocelot", model = "F620", price = 180000, hash = "f620", storage_capacity = 160.0},
			{make = "Pfister", model = "Comet", price = 165000, hash = -1045541610, storage_capacity = 130.0},
			{make = "Pfister", model = "Comet Retro Custom", price = 180000, hash = -2022483795, storage_capacity = 130.0},
			{make = "Pfister", model = "Comet SR", price = 200000, hash = "comet5", storage_capacity = 130.0},
			{make = "Pfister", model = "Comet Safari", price = 190000, hash = "comet4", storage_capacity = 160.0},
			{make = "Pfister", model = "Comet S2", price = 230000, hash = "comet6", storage_capacity = 160.0},
			{make = "Pfister", model = "Comet S2 Cabrio", price = 240000, hash = "comet7_USA", storage_capacity = 130.0},
			{make = "Ubermacht", model = "Cypher", price = 150000, hash = "cypher", storage_capacity = 160.0},
			{make = "Ubermacht", model = "Sentinel", price = 120000, hash = "sentinel2", storage_capacity = 160.0},
			{make = "Ubermacht", model = "Sentinel XS", price = 125000, hash = "sentinel", storage_capacity = 160.0},
			{make = "Ubermacht", model = "Sentinel Classic", price = 127000, hash = "sentinel3", storage_capacity = 160.0},
			{make = "Ubermacht", model = "Sentinel Classic Widebody", price = 135000, hash = "sentinel4", storage_capacity = 130.0},
			{make = "Ubermacht", model = "Zion", price = 105000, hash = "zion", storage_capacity = 160.0},
			{make = "Vulcan", model = "Warrener HKR", price = 122000, hash = "warrener2", storage_capacity = 160.0},
			--{make = "Annis", model = "Savestra", price = 27560, hash = "savestra", storage_capacity = 125.0} -- has machine guns
		},
		["Muscles"] = {
			--{make = "Albany", model = "Buccaneer", price = 68000, hash = "buccaneer", storage_capacity = 180.0},
			{make = "Albany", model = "Buccaneer Custom", price = 78000, hash = -1013450936, storage_capacity = 150.0},
			{make = "Albany", model = "Virgo", price = 62000, hash = -498054846, storage_capacity = 180.0},
			{make = "Albany", model = "Virgo Classic", price = 70000, hash = "virgo3", storage_capacity = 180.0},
			{make = "Albany", model = "Virgo Classic Custom", price = 75000, hash = "virgo2", storage_capacity = 150.0},
			{make = "Bravado", model = "Gauntlet", price = 140000, hash = -1800170043, storage_capacity = 180.0},
			{make = "Bravado", model = "Gauntlet Hellfire", price = 240000, hash = "gauntlet4", storage_capacity = 180.0},
			{make = "Bravado", model = "Gauntlet Classic", price = 195000, hash = "gauntlet3", storage_capacity = 180.0},
			{make = "Cheval", model = "Picador", price = 85000, hash = "picador", storage_capacity = 240.0},
			{make = "Declasse", model = "Impaler", price = 100000, hash = "impaler", storage_capacity = 180.0},
			{make = "Declasse", model = "Sabre GT", price = 78000, hash = -1685021548, storage_capacity = 180.0},
			{make = "Declasse", model = "Sabre Turbo Custom", price = 102000, hash = 223258115, storage_capacity = 160.0},
			{make = "Declasse", model = "Stallion", price = 76000, hash = 1923400478, storage_capacity = 180.0},
			{make = "Declasse", model = "Tahoma Coupe", price = 96000, hash = "tahoma", storage_capacity = 180.0},
			{make = "Declasse", model = "Tampa", price = 74000, hash = 972671128, storage_capacity = 180.0},
			{make = "Declasse", model = "Tampa Drift Sport", price = 250000, hash = GetHashKey("tampa2"), storage_capacity = 130.0},
			{make = "Declasse", model = "Tulip", price = 93000, hash = "tulip", storage_capacity = 180.0},
			{make = "Declasse", model = "Tulip M-100", price = 108000, hash = "tulip2", storage_capacity = 170.0},
			{make = "Declasse", model = "Vamos", price = 95000, hash = "vamos", storage_capacity = 180.0},
			{make = "Declasse", model = "Vigero", price = 72000, hash = -825837129, storage_capacity = 180.0},
			{make = "Declasse", model = "Vigero ZX", price = 245000, hash = "vigero2", storage_capacity = 180.0},
			--{make = "Declasse", model = "Voodoo", price = 28000, hash = "voodoo", storage_capacity = 180.0},
			{make = "Imponte", model = "Dukes", price = 78000, hash = 723973206, storage_capacity = 180.0},
			{make = "Imponte", model = "Nightshade", price = 150000, hash = -1943285540, storage_capacity = 170.0},
			{make = "Imponte", model = "Phoenix", price = 49000, hash = "phoenix", storage_capacity = 180.0},
			{make = "Imponte", model = "Ruiner", price = 38000, hash = -227741703, storage_capacity = 180.0},
			{make = "Imponte", model = "Ruiner ZZ-8", price = 94000, hash = "ruiner4", storage_capacity = 180.0},
			{make = "Schyster", model = "Deviant", price = 135000, hash = "deviant", storage_capacity = 180.0},
			{make = "Vapid", model = "Blade", price = 90000, hash = "blade", storage_capacity = 180.0},
			{make = "Vapid", model = "Chino Custom", price = 82000, hash = -1361687965, storage_capacity = 180.0},
			{make = "Vapid", model = "Clique", price = 85000, hash = "clique", storage_capacity = 150.0},
			{make = "Vapid", model = "Dominator", price = 135000, hash = 80636076, storage_capacity = 180.0},
			{make = "Vapid", model = "Dominator GTX", price = 248000, hash = "dominator3", storage_capacity = 180.0},
			{make = "Vapid", model = "Dominator ASP", price = 165000, hash = "dominator7", storage_capacity = 180.0},
			{make = "Vapid", model = "Dominator GTT", price = 175000, hash = "dominator8", storage_capacity = 180.0},
			{make = "Vapid", model = "Pißwasser Dominator", price = 140000, hash = -915704871, storage_capacity = 180.0},
			{make = "Vapid", model = "Ellie", price = 200000, hash = "ellie", storage_capacity = 180.0},
			{make = "Vapid", model = "Hotknife", price = 185000, hash = "hotknife", storage_capacity = 150.0},
			{make = "Willard", model = "Faction", price = 78000, hash = -2119578145, storage_capacity = 180.0},
			{make = "Willand", model = "Faction Custom", price = 86000, hash = -1790546981, storage_capacity = 180.0},
			{make = "Willand", model = "Faction Custom Donk", price = 105000, hash = -2039755226, storage_capacity = 150.0},
		},
		["Trucks"] = {
			{make = "Benefactor", model = "Dubsta 6x6", price = 350000, hash = -1237253773, storage_capacity = 280.0},
			{make = "Bravado", model = "Bison", price = 34000, hash = -16948145, storage_capacity = 340.0},
			{make = "Bravado", model = "Duneloader", price = 28000, hash =  "dloader", storage_capacity = 300.0},
			{make = "Bravado", model = "Rat-Truck", price = 76000, hash =  "ratloader2", storage_capacity = 280.0},
			{make = "Declasse", model = "Yosemite", price = 83000, hash = "yosemite", storage_capacity = 340.0},
			{make = "Vapid", model = "Bobcat XL", price = 36000, hash = 1069929536, storage_capacity = 340.0},
			{make = "Vapid", model = "Caracara", price = 250000, hash =  "caracara2", storage_capacity = 340.0},
			{make = "Vapid", model = "Contender", price = 160000, hash = 683047626, storage_capacity = 340.0},
			{make = "Karin", model = "Everon", price = 110000, hash =  "everon", storage_capacity = 260.0},
			{make = "Karin", model = "Hotring Everon", price = 480000, hash =  "everon2", storage_capacity = 120.0}, --Racetruck
			{make = "Karin", model = "Rebel", price = 38000, hash = "rebel", storage_capacity = 280.0},
			{make = "Karin", model = "Rebel 2", price = 28000, hash = -2045594037, storage_capacity = 280.0},
			{make = "Vapid", model = "Guardian", price = 280000, hash =  -2107990196, storage_capacity = 380.0},
			{make = "Vapid", model = "Riata", price = 140000, hash = "riata", storage_capacity = 280.0},
			{make = "Vapid", model = "Slam Van", price = 69000, hash = 729783779, storage_capacity = 280.0},
			{make = "Vapid", model = "Sandking", price = 78000, hash = -1189015600, storage_capacity = 340.0},
			{make = "Vapid", model = "Sandking 2", price = 90000, hash = 989381445, storage_capacity = 340.0},
		},
		["Compacts"] = {
			--{make = "Benefactor", model = "Panto", price = 24000, hash = -431692672, storage_capacity = 120.0},
			--{make = "Bollokan", model = "Prairie", price = 28000, hash = "prairie", storage_capacity = 160.0},
			{make = "Declasse", model = "Rhapsody", price = 27500, hash = 841808271, storage_capacity = 160.0},
			--{make = "Dinka", model = "Blista Compact", price = 27500, hash = "blista", storage_capacity = 160.0},
			{make = "Grotti", model = "Brioso", price = 29500, hash = "brioso", storage_capacity = 140.0},
			{make = "Grotti", model = "Brioso 300 Widebody", price = 35600, hash = "brioso3", storage_capacity = 140.0},
			{make = "Nagasaki", model = "Caddy", price = 5000, hash = -537896628, storage_capacity = 80.0},
			--{make = "Karin", model = "Dilettante", price = 25600, hash = "dilettante", storage_capacity = 160.0},
			--{make = "Karin", model = "Futo", price = 27500, hash = "futo", storage_capacity = 160.0},
			{make = "Rune", model = "Cheburek", price = 35600, hash = "cheburek", storage_capacity = 160.0},
			--{make = "Weeny", model = "Issi", price = 28900, hash = "issi", storage_capacity = 160.0},
			{make = "Weeny", model = "Issi Classic", price = 35000, hash = "issi3", storage_capacity = 160.0},
			{make = "Weeny", model = "Issi Rally", price = 69000, hash = "issi8", storage_capacity = 180.0},
		},
		["Offroads"] = {
			{make = "Annis", model = "Hellion", price = 85000, hash = "hellion", storage_capacity = 280.0},
			{make = "BF", model = "Weevil Custom", price = 210000, hash = "weevil2", storage_capacity = 120.0},
			{make = "BF", model = "Bifta", price = 42500, hash = -349601129, storage_capacity = 100.0},
			{make = "BF", model = "Injection", price = 50000, hash = 1126868326, storage_capacity = 120.0},
			{make = "Canis", model = "Kalahari", price = 59500, hash = 92612664, storage_capacity = 280.0},
			{make = "Canis", model = "Mesa", price = 54500, hash = 914654722, storage_capacity = 280.0},
			{make = "Canis", model = "Mesa 2", price = 66500, hash = -2064372143, storage_capacity = 280.0},
			{make = "Canis", model = "Kamacho", price = 180000, hash = "kamacho", storage_capacity = 340.0},
			{make = "Canis", model = "Bodhi", price = 53500, hash = "bodhi2", storage_capacity = 300.0},
			{make = "Coil", model = "Brawler", price = 115500, hash = -1479664699, storage_capacity = 120.0},
			{make = "Declasse", model = "Draugur", price = 210000, hash = "draugur", storage_capacity = 120.0},
			{make = "Declasse", model = "Rancher XL", price = 42550, hash = 1645267888, storage_capacity = 280.0},
			{make = "Declasse", model = "Yosemite Rancher", price = 105000, hash = "yosemite3", storage_capacity = 280.0},
			{make = "Dinka", model = "Winky", price = 65000, hash = 'winky', storage_capacity = 180.0},
			{make = "Dune", model = "Buggy", price = 32000, hash = -1661854193, storage_capacity = 100.0},
			{make = "Nagasaki", model = "Blazer", price = 30000, hash = -2128233223, storage_capacity = 30.0},
			{make = "Nagasaki", model = "Hot Rod Blazer", price = 35000, hash = "blazer3", storage_capacity = 30.0},
			{make = "Nagasaki", model = "Street Blazer", price = 50000, hash = "blazer4", storage_capacity = 30.0},
			{make = "Nagasaki", model = "Outlaw", price = 55000, hash = "outlaw", storage_capacity = 90.0},
			{make = "Vapid", model = "Trophy Truck", price = 360000, hash = 101905590, storage_capacity = 120.0},
			{make = "Vapid", model = "Trophy Truck 2", price = 400000, hash = -663299102, storage_capacity = 120.0},
		},
		["Motorcycles"] = {
			{make = "Dinka", model = "Akuma", price = 45000, hash = 1672195559, storage_capacity = 30.0},
			{make = "Dinka", model = "Double T", price = 75000, hash = "double", storage_capacity = 30.0},
			{make = "Dinka", model = "Enduro", price = 30500, hash = 1753414259, storage_capacity = 30.0},
			{make = "Dinka", model = "Thrust", price = 48000, hash = 1836027715, storage_capacity = 30.0},
			{make = "LCC", model = "Avarus", price = 49000, hash = "avarus", storage_capacity = 30.0},
			{make = "LCC", model = "Hexer", price = 50500, hash = 301427732, storage_capacity = 30.0},
			{make = "LCC", model = "Sanctus", price = 160000, hash = 1491277511, storage_capacity = 30.0},
			{make = "Maibatsu", model = "Manchez", price = 42000, hash = -1523428744, storage_capacity = 30.0},
			{make = "Maibatsu", model = "Sanchez", price = 34800, hash = -1453280962, storage_capacity = 30.0},
			{make = "Maibatsu", model = "Reever", price = 55000, hash = "Reever", storage_capacity = 30.0},
			{make = "Nagasaki", model = "Carbon RS", price = 79500, hash = 11251904, storage_capacity = 30.0},
			{make = "Nagasaki", model = "Chimera", price = 65000, hash = 6774487, storage_capacity = 30.0},
			{make = "Nagasaki", model = "Shinobi", price = 55000, hash = "Shinobi", storage_capacity = 30.0},
			{make = "Pegassi", model = "Bati 801", price = 70500, hash = -114291515, storage_capacity = 30.0},
			{make = "Pegassi", model = "Esskey", price = 38000, hash = 2035069708, storage_capacity = 30.0},
			{make = "Pegassi", model = "Faggio", price = 5000, hash = -1842748181, storage_capacity = 30.0},
			{make = "Pegassi", model = "Faggio Mod", price = 10000, hash = 55628203, storage_capacity = 30.0},
			{make = "Pegassi", model = "Faggio Sport", price = 7500, hash = -1289178744, storage_capacity = 30.0},
			{make = "Pegassi", model = "Vortex", price = 60000, hash = -609625092, storage_capacity = 30.0},
			{make = "Principe", model = "Lectro", price = 57500, hash = "lectro", storage_capacity = 30.0},
			{make = "Shitzu", model = "Defiler", price = 53500, hash = 822018448, storage_capacity = 30.0},
			{make = "Shitzu", model = "Hakuchou", price = 80000, hash = 1265391242, storage_capacity = 30.0},
			{make = "Shitzu", model = "Hakuchou Drag", price = 105000, hash = -255678177, storage_capacity = 30.0},
			{make = "Shitzu", model = "Vader", price = 49500, hash = -140902153, storage_capacity = 30.0},
			{make = "Western", model = "Bagger", price = 57000, hash = -2140431165, storage_capacity = 30.0},
			{make = "Western", model = "Daemon", price = 57500, hash = 2006142190, storage_capacity = 30.0},
			{make = "Western", model = "Daemon Custom", price = 61000, hash = -1404136503, storage_capacity = 30.0},
			{make = "Western", model = "Nightblade", price = 71000, hash = -1606187161, storage_capacity = 30.0},
			{make = "Western", model = "Manchez Scout C", price = 47000, hash = "manchez3", storage_capacity = 30.0},
			{make = "Western", model = "Powersurge", price = 60000, hash = "powersurge", storage_capacity = 35.0},
			{make = "Western", model = "Ratbike", price = 31000, hash = 1873600305, storage_capacity = 30.0},
			{make = "Western", model = "Sovereign", price = 58000, hash = 743478836, storage_capacity = 30.0},
			{make = "Western", model = "Wolfsbane", price = 55000, hash = -618617997, storage_capacity = 30.0},
			{make = "Western", model = "Zombie Bobber", price = 61500, hash = -1009268949, storage_capacity = 30.0},
			{make = "Western", model = "Zombie Chopper", price = 56000, hash = -570033273, storage_capacity = 30.0},
		},
		["Vans"] = {
			{make = "BF", model = "Surfer", price = 58000, hash = 699456151, storage_capacity = 340.0},
			{make = "BF", model = "Surfer Custom", price = 75000, hash = "surfer3", storage_capacity = 300.0},
			{make = "Bravado", model = "Youga Classic", price = 72000, hash = 1026149675, storage_capacity = 340.0},
			{make = "Bravado", model = "Youga Classic 4x4", price = 110000, hash = "youga3", storage_capacity = 340.0},
			{make = "Bravado", model = "Youga Classic Custom", price = 65000, hash = "youga4", storage_capacity = 320.0},
			--{make = "Bravado", model = "Rumpo Custom", price = 45432, hash = 1475773103, storage_capacity = 340.0}, bullet resistant
			{make = "Brute", model = "Camper", price = 58500, hash = 1876516712, storage_capacity = 380.0},
			{make = "Brute", model = "Taco Van", price = 50500, hash = 1951180813, storage_capacity = 380.0},
			--{make = "Declasse", model = "Burrito 1", price = 24900, hash = -1346687836, storage_capacity = 340.0},
			--{make = "Declasse", model = "Burrito 2", price = 24900, hash = -907477130, storage_capacity = 340.0},
			--{make = "Declasse", model = "Burrito 3", price = 24900, hash = -1743316013, storage_capacity = 340.0},
			--{make = "Declasse", model = "Burrito 4", price = 24900, hash = 893081117, storage_capacity = 340.0},
			--{make = "Declasse", model = "Burrito 5", price = 24900, hash = 1132262048, storage_capacity = 340.0},
			{make = "Declasse", model = "Moonbeam", price = 48500, hash = "moonbeam", storage_capacity = 340.0},
			{make = "Declasse", model = "Moonbeam Custom", price = 65500, hash = "moonbeam2", storage_capacity = 340.0},
			{make = "Vapid", model = "Speedo", price = 51500, hash = -810318068, storage_capacity = 340.0},
			{make = "Vapid", model = "Minivan", price = 35500, hash = -310465116, storage_capacity = 280.0},
			{make = "Vapid", model = "Minivan Custom", price = 72000, hash = -1126264336, storage_capacity = 240.0},
			{make = "Vapid", model = "Clown", price = 57500, hash = 728614474, storage_capacity = 300.0},
			{make = "Zirconium", model = "Journey", price = 41500, hash = "journey", storage_capacity = 350.0},
			{make = "Zirconium", model = "Journey II", price = 102000, hash = "journey2", storage_capacity = 380.0}
		},
		["Sports"] = {
			{make = "Annis", model = "300R", price = 250000, hash = "r300", storage_capacity = 160.0},
			{make = "Annis", model = "Elegy RH8", price = 310000, hash = -566387422, storage_capacity = 160.0},
			{make = "Annis", model = "Elegy Retro Custom", price = 320000, hash = 196747873, storage_capacity = 160.0},
			{make = "Benefactor", model = "Feltzer", price = 320500, hash = "feltzer2", storage_capacity = 160.0},
			{make = "Benefactor", model = "Schafter V12", price = 300000, hash = -1485523546, storage_capacity = 180.0},
			{make = "Benefactor", model = "Surano", price = 284500, hash = 384071873, storage_capacity = 120.0},
			{make = "Bravado", model = "Banshee 990R", price = 360000, hash = 633712403, storage_capacity = 120.0},
			{make = "Dewbauchee", model = "Seven-70", price = 375000, hash = -1757836725, storage_capacity = 160.0},
			{make = "Dewbauchee", model = "Specter", price = 365000, hash = 1886268224, storage_capacity = 160.0},
			{make = "Dewbauchee", model = "Massacro", price = 320500, hash = -142942670, storage_capacity = 160.0},
			{make = "Dewbauchee", model = "Rapid GT", price = 300500, hash = -1934452204, storage_capacity = 160.0},
			{make = "Dinka", model = "Jester", price = 334000, hash = -1297672541, storage_capacity = 160.0},
			{make = "Dinka", model = "Sugoi", price = 125000, hash = "sugoi", storage_capacity = 160.0},
			{make = "Enus", model = "Paragon", price = 350000, hash = "paragon", storage_capacity = 160.0},
			{make = "Emperor", model = "Vectre", price = 285000, hash = "vectre", storage_capacity = 160.0},
			{make = "Grotti", model = "Bestia GTS", price = 320500, hash = 1274868363, storage_capacity = 160.0},
			{make = "Hijak", model = "Ruston", price = 240000, hash = "ruston", storage_capacity = 120.0},
			{make = "Invetero", model = "Coquette", price = 235000, hash = 108773431, storage_capacity = 160.0},
			{make = "Invetero", model = "Coquette D10", price = 340000, hash = "coquette4", storage_capacity = 120.0},
			{make = "Karin", model = "Kuruma", price = 115000, hash = -1372848492, storage_capacity = 160.0},
			{make = "Karin", model = "Sultan", price = 95000, hash = 970598228, storage_capacity = 160.0},
			{make = "Karin", model = "Sultan RS", price = 125000, hash = -295689028, storage_capacity = 160.0},
			{make = "Lampadati", model = "Furore GT", price = 275000, hash = -1089039904, storage_capacity = 160.0},
			{make = "Lampadati", model = "Tropos Rallye", price = 210000, hash = "tropos", storage_capacity = 120.0},
			{make = "Obey", model = "8F Drafter", price = 220000, hash = "drafter", storage_capacity = 160.0},
			{make = "Obey", model = "9F", price = 465000, hash = 1032823388, storage_capacity = 160.0},
			{make = "Obey", model = "9F Cabrio", price = 478000, hash = -1461482751, storage_capacity = 160.0},
			{make = "Obey", model = "Omnis", price = 225500, hash = "omnis", storage_capacity = 160.0},
			{make = "Pfister", model = "Growler", price = 210000, hash = "growler", storage_capacity = 160.0},
			{make = "Toundra", model = "Panthere", price = 225000, hash = "panthere", storage_capacity = 160.0},
			{make = "Ubermacht", model = "Zion Cabrio", price = 70500, hash = -1193103848, storage_capacity = 160.0},
			{make = "Vapid", model = "Flash GT", price = 220000, hash = "flashgt", storage_capacity = 120.0},
			{make = "Vapid", model = "GB200", price = 205000, hash = "gb200", storage_capacity = 120.0},
		},
		["Supers"] = {
			{make = "Annis", model = "RE7B", price = 1700000, hash = -1232836011, storage_capacity = 120.0},
			{make = "Cheval", model = "Taipan", price = 1500000, hash = "taipan", storage_capacity = 120.0},
      		{make = "Benefactor", model = "Krieger", price = 1250000, hash = "krieger", storage_capacity = 120.0},
			{make = "Benefactor", model = "LM87", price = 2120000, hash = "lm87", storage_capacity = 120.0},
			{make = "Benefactor", model = "SM722", price = 1350000, hash = "sm722", storage_capacity = 120.0},
			{make = "Dewbauchee", model = "Champion", price = 950000, hash = "champion_USA", storage_capacity = 120.0},
			{make = "Dewbauchee", model = "Vagner", price = 1750000, hash = "vagner", storage_capacity = 120.0},
			{make = "Emperor", model = "ETR 1", price = 1020000, hash = "sheava", storage_capacity = 120.0},
			{make = "Grotti", model = "Carbonizzare", price = 750000, hash = 2072687711, storage_capacity = 120.0},
			{make = "Grotti", model = "Cheetah", price = 1220000, hash = -1311154784, storage_capacity = 120.0},
      		{make = "Grotti", model = "Furia", price = 1020000, hash = "furia", storage_capacity = 120.0},
			{make = "Grotti", model = "Itali GTO", price = 780000, hash = "italigto", storage_capacity = 120.0},
			{make = "Grotti", model = "Itali RSX", price = 1050000, hash = "italirsx", storage_capacity = 120.0},
			{make = "Grotti", model = "Turismo R", price = 1060000, hash = 408192225, storage_capacity = 120.0},
			{make = "Grotti", model = "Visione", price = 1400000, hash = "visione", storage_capacity = 120.0},
			{make = "Lampadati", model = "Corsita", price = 1150000, hash = "corsita", storage_capacity = 120.0},
			{make = "Lampadati", model = "Tigon", price = 1200000, hash = "tigon", storage_capacity = 120.0},
			{make = "Obey", model = "10F", price = 900000, hash = "tenf", storage_capacity = 120.0},
			{make = "Obey", model = "10F Widebody", price = 950000, hash = "tenf2", storage_capacity = 120.0},
			{make = "Ocelot", model = "Penetrator", price = 750000, hash = "penetrator", storage_capacity = 120.0},
			{make = "Ocelot", model = "XA-21", price = 1140000, hash = 917809321, storage_capacity = 120.0},
			{make = "Overflod", model = "Autarch", price = 1240000, hash = "autarch", storage_capacity = 120.0},
			{make = "Overflod", model = "Entity MT", price = 2400000, hash = "entity3", storage_capacity = 120.0},
			{make = "Overflod", model = "Entity XXR", price = 1900000, hash = "entity2", storage_capacity = 120.0},
			{make = "Overflod", model = "Tyrant", price = 1250000, hash = "tyrant", storage_capacity = 120.0},
			{make = "Overflod", model = "Zeno", price = 1150000, hash = "zeno_USA", storage_capacity = 120.0},
			{make = "Pfister", model = "811", price = 1280500, hash = -1829802492, storage_capacity = 120.0},
			{make = "Principe", model = "Deveste Eight", price = 1500000, hash = "deveste", storage_capacity = 120.0},
			{make = "Progen", model = "Emerus", price = 1350000, hash = "emerus", storage_capacity = 120.0},
			{make = "Progen", model = "GP1", price = 1240000, hash = 1234311532, storage_capacity = 120.0},
			{make = "Progen", model = "Itali GTB", price = 1180000, hash = -2048333973, storage_capacity = 120.0},
			{make = "Progen", model = "Itali GTB Custom", price = 1240000, hash = "italigtb2", storage_capacity = 120.0},
			{make = "Progen", model = "T20", price = 1080000, hash = 1663218586, storage_capacity = 120.0},
			{make = "Progen", model = "Tyrus", price = 1280000, hash = 2067820283, storage_capacity = 120.0},
			{make = "Pegassi", model = "Ignus", price = 1320000, hash = "ignus_USA", storage_capacity = 120.0},
			{make = "Pegassi", model = "Infernus", price = 760000, hash = 418536135, storage_capacity = 120.0},
			{make = "Pegassi", model = "Osiris", price = 950000, hash = 1987142870, storage_capacity = 120.0},
			{make = "Pegassi", model = "Reaper", price = 1000000, hash = 234062309, storage_capacity = 120.0},
			{make = "Pegassi", model = "Tempesta", price = 1010000, hash = 272929391, storage_capacity = 120.0},
			{make = "Pegassi", model = "Tezeract", price = 1400000, hash = "tezeract", storage_capacity = 120.0},
			{make = "Pegassi", model = "Torero XO", price = 1325000, hash = "torero2", storage_capacity = 120.0},
			{make = "Pegassi", model = "Vacca", price = 780000, hash = 338562499, storage_capacity = 120.0},
			{make = "Pegassi", model = "Zentorno", price = 1095000, hash = -1403128555, storage_capacity = 120.0},
			{make = "Pegassi", model = "Zorrusso", price = 1200000, hash = "zorrusso", storage_capacity = 120.0},
			{make = "Truffade", model = "Adder", price = 1900000, hash = -1216765807, storage_capacity = 120.0},
			{make = "Truffade", model = "Nero", price = 2100000, hash = 1034187331, storage_capacity = 120.0},
			{make = "Truffade", model = "Nero Custom", price = 2300000, hash = GetHashKey("nero2"), storage_capacity = 120.0},
      		{make = "Truffade", model = "Thrax", price = 2500000, hash = "thrax", storage_capacity = 120.0},
			{make = "Ubermacht", model = "SC1", price = 1080000, hash = "SC1", storage_capacity = 120.0},
			{make = "Vapid", model = "Bullet", price = 710000, hash = -1696146015, storage_capacity = 120.0},
			{make = "Vapid", model = "FMJ", price = 1220000, hash = 1426219628, storage_capacity = 120.0},
		},
		["Classic"] = {
			{make = "Albany", model = "Esperanto", price = 4000, hash = "vwe_esperanto1", storage_capacity = 160.0},
			{make = "Albany", model = "Hermes", price = 109500, hash = "hermes", storage_capacity = 160.0},
			{make = "Albany", model = "Manana", price = 69500, hash = -2124201592, storage_capacity = 160.0},
			{make = "Albany", model = "Roosevelt", price = 108000, hash = 117401876, storage_capacity = 280.0},
			{make = "Albany", model = "Roosevelt Valor", price = 122500, hash = -602287871, storage_capacity = 280.0},
			{make = "BF", model = "Weevil", price = 50000, hash = 'weevil', storage_capacity = 160.0},
			{make = "Classique", model = "Broadway", price = 78000, hash = 'broadway', storage_capacity = 180.0},
			{make = "Declasse", model = "Mamba", price = 100000, hash = -1660945322, storage_capacity = 160.0},
			--{make = "Declasse", model = "Tornado", price = 25000, hash = "tornado", storage_capacity = 180.0},
			{make = "Declasse", model = "Tornado 6", price = 65000, hash = -1558399629, storage_capacity = 180.0},
			{make = "Dewbauchee", model = "JB 700", price = 140000, hash = 1051415893, storage_capacity = 160.0},
			{make = "Dinka", model = "Blista Kanjo", price = 85000, hash = 'kanjo', storage_capacity = 160.0},
			{make = "Enus", model = "Stafford", price = 115000, hash = 'stafford', storage_capacity = 220.0},
			{make = "Grotti", model = "Cheetah Classic", price = 610000, hash = 223240013, storage_capacity = 120.0},
			{make = "Grotti", model = "GT500", price = 142000, hash = "gt500", storage_capacity = 160.0},
			{make = "Grotti", model = "Stinger", price = 115000, hash = 1545842587, storage_capacity = 160.0},
			{make = "Grotti", model = "Stinger GT", price = 125000, hash = -2098947590, storage_capacity = 160.0},
			{make = "Grotti", model = "Turismo Classic", price = 675000, hash = -982130927, storage_capacity = 120.0},
			{make = "Invetero", model = "Coquette Classic", price = 126000, hash = 1011753235, storage_capacity = 160.0},
			{make = "Invetero", model = "Coquette Blackfin", price = 120000, hash = 784565758, storage_capacity = 160.0},
			{make = "Karin", model = "190z", price = 97000, hash = "z190", storage_capacity = 160.0},
			{make = "Karin", model = "Boor", price = 78000, hash = 'boor', storage_capacity = 200.0},
			{make = "Karin", model = "Sultan Classic", price = 109000, hash = 'sultan2', storage_capacity = 220.0},
			{make = "Lampadati", model = "Casco", price = 109000, hash = 941800958, storage_capacity = 160.0},
			--{make = "Lampadati", model = "Pigalle", price = 21999, hash = "pigalle", storage_capacity = 160.0},
			{make = "Pegassi", model = "Infernus Classic", price = 755000, hash = -1405937764, storage_capacity = 120.0},
			{make = "Pegassi", model = "Monroe", price = 127500, hash = -433375717, storage_capacity = 120.0},
			{make = "Pegassi", model = "Torero", price = 770000, hash = 1504306544, storage_capacity = 120.0},
			{make = "Truffade", model = "Z-Type", price = 195000, hash = "ztype", storage_capacity = 160.0},
			{make = "Vapid", model = "Peyote", price = 79500, hash = 1830407356, storage_capacity = 160.0},
			{make = "Vulcar", model = "Fagaloa", price = 96500, hash = "fagaloa", storage_capacity = 220.0},
			{make = "Willard", model = "Eudora", price = 105000, hash = 'eudora', storage_capacity = 220.0},
			--{make = "Lampadati", model = "Viseris", price = 75000, hash = "viseris", storage_capacity = 180.0}
			--{make = "Ocelot", model = "Swinger", price = 73000, hash = "swinger", storage_capacity = 100.0}
		},
		["Sedans"] = {
			--{make = "Albany", model = "Emperor", price = 3050, hash = -1883002148, storage_capacity = 220.0},
			--{make = "Albany", model = "Emperor 2", price = 12076, hash = -685276541, storage_capacity = 220.0},
			{make = "Albany", model = "Washington", price = 35000, hash = 1777363799, storage_capacity = 220.0},
			{make = "Albany", model = "Primo", price = 49500, hash = "primo", storage_capacity = 220.0},
			{make = "Albany", model = "Primo Custom", price = 70000, hash = "primo2", storage_capacity = 220.0},
			{make = "Benefactor", model = "Glendale", price = 45000, hash = 75131841, storage_capacity = 220.0},
			{make = "Benefactor", model = "Schafter", price = 160000, hash = "schafter2", storage_capacity = 220.0},
			{make = "Benefactor", model = "Schafter 2", price = 180000, hash = -1255452397, storage_capacity = 220.0},
			{make = "Bravado", model = "Buffalo", price = 70000, hash = -304802106, storage_capacity = 220.0},
			{make = "Bravado", model = "Buffalo S", price = 90000, hash = 736902334, storage_capacity = 160.0},
			{make = "Bravado", model = "Buffalo STX", price = 240000, hash = "buffalo4_USA", storage_capacity = 220.0},
			{make = "Bravado", model = "Buffalo Special", price = 80000, hash = 237764926, storage_capacity = 220.0},
			{make = "Bravado", model = "Greenwood", price = 62000, hash = "greenwood", storage_capacity = 220.0},
			{make = "Cheval", model = "Fugitive", price = 55000, hash = "fugitive", storage_capacity = 220.0},
			--{make = "Dundreary", model = "Regina", price = 8937, hash = "regina", storage_capacity = 220.0},
			{make = "Enus", model = "Cognoscenti", price = 210000, hash = -2030171296, storage_capacity = 220.0},
			{make = "Enus", model = "Deity", price = 285000, hash = "deity_USA", storage_capacity = 220.0},
			{make = "Enus", model = "Super Diamond", price = 300000, hash = 1123216662, storage_capacity = 220.0},
			--{make = "Karin", model = "Intruder", price = 7490, hash = 886934177, storage_capacity = 220.0},
			{make = "Lampadati", model = "Cinquemila", price = 295000, hash = "cinquemila_USA", storage_capacity = 220.0},
			{make = "Lampadati", model = "Komoda", price = 285000, hash = "komoda", storage_capacity = 220.0},
			{make = "Obey", model = "Tailgater", price = 95000, hash = -1008861746, storage_capacity = 220.0},
			{make = "Obey", model = "Tailgater S", price = 190500, hash = "tailgater2", storage_capacity = 220.0},
			{make = "Ocelot", model = "Jackal", price = 82000, hash = -624529134, storage_capacity = 220.0},
			{make = "Ocelot", model = "Jugular", price = 225000, hash = "jugular", storage_capacity = 220.0},
			{make = "Pegassi", model = "Toros", price = 285000, hash = "toros", storage_capacity = 220.0},
			--{make = "Ubermacht", model = "Oracle", price = 32834, hash = "oracle", storage_capacity = 220.0},
			{make = "Ubermacht", model = "Revolter", price = 240000, hash = "revolter", storage_capacity = 220.0}, -- has miniguns in LSC (disabled)
			{make = "Ubermacht", model = "Rhinehart", price = 230000, hash = "rhinehart", storage_capacity = 220.0},
			--{make = "Vapid", model = "Stanier", price = 6484, hash = -1477580979, storage_capacity = 220.0},
			--{make = "Vulcar", model = "Ingot", price = 4876, hash = -1289722222, storage_capacity = 220.0},
			{make = "Vulcar", model = "Warrener", price = 65000, hash = 1373123368, storage_capacity = 220.0},
			--{make = "Zinconium", model = "Stratum", price = 5847, hash = 1723137093, storage_capacity = 220.0},
		},
		["Specials"] = {
			{make = "Brute", model = "Tour Bus", price = 80000, hash = 1941029835, storage_capacity = 400.0},
			{make = "Coach", model = "RV", price = 220000, hash = "coachrv", storage_capacity = 500.0},
			{make = "Declasse", model = "Burrito Lost", price = 87500, hash = -1745203402, storage_capacity = 340.0},
			{make = "Declasse", model = "Stallion Special", price = 62000, hash =  -401643538, storage_capacity = 180.0},
			{make = "Declasse", model = "Hotring Sabre", price = 620000, hash = "hotring", storage_capacity = 120.0},
			{make = "Dewbauchee", model = "Massacro Special", price = 310000, hash = -631760477, storage_capacity = 160.0},
			{make = "Dinka", model = "Jester Special", price = 580500, hash = -1106353882, storage_capacity = 160.0},
			--{make = "Dundreary", model = "Stretch", price = 85500, hash = -1961627517, storage_capacity = 340.0},
			{make = "Maibatsu", model = "Mule 3", price = 210000, hash = -2052737935, storage_capacity = 600.0},
			{make = "MTL", model = "Flatbed", price = 95000, hash = GetHashKey("flatbed"), storage_capacity = 200.0},
			--{make = "Dundreary", model = "Stretch", price = 25575, hash = -1961627517, storage_capacity = 300.0},
			{make = "MTL", model = "Pounder", price = 260000, hash = 2112052861, storage_capacity = 900.0},
			{make = "MTL", model = "Dune", price = 250000, hash = GetHashKey("rallytruck"), storage_capacity = 300.0},
			--{make = "Trailer", model = "Closed", price = 80000, hash = "ctrailer", storage_capacity = 400.0},
			--{make = "Trailer", model = "Open", price = 30000, hash = "cotrailer", storage_capacity = 340.0},
			{make = "Vapid", model = "Benson", price = 200000, hash = "benson", storage_capacity = 650.0},
			{make = "Vapid", model = "Slam Van Lost", price = 79500, hash = 833469436, storage_capacity = 300.0},
			{make = "Voodoo", model = "Caddy S", price = 20000, hash = "voodoo_caddys", storage_capacity = 60.0},
		},
		["Electric"] = {
			--{make = "Cheval", model = "Surge", price = 17453, hash = "surge", storage_capacity = 220.0},
			{make = "Coil", model = "Raider", price = 170000, hash = "raiden", storage_capacity = 220.0},
			--{make = "Coil", model = "Voltic", price = 260000, hash = "voltic", storage_capacity = 120.0},
			{make = "Coil", model = "Cyclone", price = 304000, hash = "cyclone", storage_capacity = 120.0},
			{make = "Hijak", model = "Khamelion", price = 244500, hash = 544021352, storage_capacity = 160.0},
			{make = "Obey", model = "I-Wagen", price = 215000, hash = "iwagen_USA", storage_capacity = 280.0},
			{make = "Obey", model = "Omnis e-GT", price = 320000, hash = "omnisegt", storage_capacity = 220.0},
			{make = "Ocelot", model = "Virtue", price = 950000, hash = "virtue", storage_capacity = 120.0},
			{make = "Pfister", model = "Neon", price = 270000, hash = "neon", storage_capacity = 220.0},
		},
		["Custom"] = {
			{make = "Declasse", model = "Silver-Star", price = 40000, hash = "silverstar", storage_capacity = 280.0},
			{make = "Declasse", model = "Silver-Star (Lowrider)", price = 80000, hash = "silverstar2", storage_capacity = 250.0},
			--
			{make = "Karin", model = "Ariant", price = 90000, hash = "ariant", storage_capacity = 220.0},
			{make = "Karin", model = "Asterope RS", price = 160000, hash = "asteropers", storage_capacity = 220.0},
			{make = "Karin", model = "Rebel Custom", price = 170000, hash = "rebeld", storage_capacity = 220.0},
			--
			{make = "Pegassi", model = "Monroe Custom", price = 627500, hash = "monroec", storage_capacity = 120.0},
			--
			{make = "Progen", model = "Proff (NOT ROAD LEGAL)", price = 280000, hash = "proff", storage_capacity = 60.0},
			--
			{make = "Ubermach", model = "Sentinel Custom (DRIFT)", price = 160000, hash = "sentineldm", storage_capacity = 160.0},
			--
			{make = "Vapid", model = "Sandstorm", price = 180000, hash = "sandstorm", storage_capacity = 340.0},
			{make = "Vapid", model = "Sandstorm XL", price = 200000, hash = "sandstormxl", storage_capacity = 360.0},
			{make = "Vapid", model = "Sandstorm EV", price = 190000, hash = "sandstormev", storage_capacity = 350.0},
			--
			{make = "Weeny", model = "Tamworth", price = 38000, hash = "tamworth", storage_capacity = 160.0},
		}
	}
}

local BIKES = {
	["BMX"] = { price = 250, hash = 1131912276},
	["Cruiser"] = { price = 300, hash = 448402357},
	["Fixster"] = { price = 350, hash = -836512833},
	["Scorcher"] = { price = 500, hash = -186537451},
	["TriBike"] = { price = 550, hash = 1127861609},
	["Low Rider Bike"] = { price = 3000, hash = GetHashKey("lowriderb")}
}

RegisterServerEvent("vehicle-shop:loadItems")
AddEventHandler("vehicle-shop:loadItems", function()
	TriggerClientEvent("vehicle-shop:loadItems", source, vehicleShopItems)
end)

-- TODO: Add Return Point for Vehicles

function addStrike(char)
	local done = false
	TriggerEvent("es:exposeDBFunctions", function(db)
        db.getDocumentById("test-drive-strikes", char.get("_id"), function(doc)
            if doc then
                local strikes = doc.strikes + 1
               	if strikes >= 3 then
               		local timestamp = os.time()
               		db.updateDocument("test-drive-strikes", char.get("_id"), {strikes = strikes, banned = timestamp}, function()
	            		done = true
	            	end)
               	else
	                db.updateDocument("test-drive-strikes", char.get("_id"), {strikes = strikes, banned = false}, function()
	            		done = true
	            	end)
               	end
            else
                db.createDocumentWithId("test-drive-strikes",{strikes = 1, banned = false},char.get("_id"), function(success)
	                if success then
	                	print("created doc for char "..char.get("_id"))
	                else
	                	print("error creating doc for char "..char.get("_id"))
	                end
            		done = true
                end)
            end
        end)
    end)
    while not done do
    	Wait(0)
    end
    return
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function getStrikes(char)
	local strikes = 0
	local done = false
	local bannedFor = false
	TriggerEvent("es:exposeDBFunctions", function(db)
        db.getDocumentById("test-drive-strikes", char.get("_id"), function(doc)
            if doc then
            	if doc.banned ~= false then
            		local now = os.time()
            		local banned_days = 30
            		if now - doc.banned > banned_days*86400 then
            			db.updateDocument("test-drive-strikes", char.get("_id"), {strikes = 0, banned = false}, function()
		            		done = true
		            	end)
            		else
            			bannedFor = round(banned_days - ((now - doc.banned) / 86400),0)
            			strikes = doc.strikes
            		end
            	else
            		strikes = doc.strikes
            	end
            end
            done = true
        end)
    end)
    while not done do
    	Wait(0)
    end
    return strikes, bannedFor
end

Citizen.CreateThread(function()
	while true do
        local lastCheck = GetGameTimer()
		while GetGameTimer() - lastCheck < 5000 do
		  Wait(1)
		end
		for k,v in pairs(stolenVehicles) do
			local ent = NetworkGetEntityFromNetworkId(v.netID)
			if not DoesEntityExist(ent) or GetEntityModel(ent) ~= v.hash then
				for i,source in ipairs(v.trackedBy) do
					TriggerClientEvent("vehShop:stopTrackStolenVeh", source)
					TriggerClientEvent("usa:notify", source, "Lost Tracker Connection! Vehicle might have been destroyed, lost or impounded", "^3INFO: ^0Lost Tracker Connection! Vehicle might have been destroyed, lost or impounded")
				end
				stolenVehicles[k] = nil
			else
				v.coords = GetEntityCoords(ent)
				for i,source in ipairs(v.trackedBy) do
					TriggerClientEvent("vehShop:trackStolenVeh", source, v.coords)
				end
			end
		end
	end
end)

TriggerEvent('es:addJobCommand', 'trackveh', {'sheriff', 'corrections'}, function(source, args, char)
	local plate = nil
	if args[2] ~= nil then
		plate = string.upper(args[2])
	else
		TriggerClientEvent("usa:notify", source, "No plate provided using last 911")
		plate = lastStolenPlate
	end
	if stolenVehicles[plate] ~= nil then
		TriggerClientEvent("vehShop:trackStolenVeh", source, stolenVehicles[plate].coords)
		table.insert(stolenVehicles[plate].trackedBy, source)
	else
		TriggerClientEvent("usa:notify", source, "Invalid Plate! Vehicle might be destroyed, lost or impounded!")
	end
end, {
	help = "Track a stolen vehicle.",
	params = {
		{ name = "Plate", help = "The plate of the tracker fitted vehicle, if not provided will use plate from last 911" }
	}
})

TriggerEvent('es:addJobCommand', 'endtrack', {'sheriff', 'corrections'}, function(source, args, char)
	TriggerClientEvent("vehShop:stopTrackStolenVeh", source)
	for k,v in pairs(stolenVehicles) do
		for i,s in ipairs(v.trackedBy) do
			if source == s then
				table.remove(v.trackedBy, i)
			end
		end
	end
end, {
	help = "Stops tracking a stolen vehicle.",
	params = {
	}
})

Citizen.CreateThread(function()
	while true do
		local lastCheck = GetGameTimer()
		while GetGameTimer() - lastCheck < 5000 do
			Wait(1)
		end
		for k,v in pairs(testDrivers) do
			local ent = NetworkGetEntityFromNetworkId(v.netID)
			local char = exports["usa-characters"]:GetCharacter(v.source)
			if v.netID ~= nil and (not DoesEntityExist(ent) or GetEntityModel(ent) ~= v.hash) then
				addStrike(char)
				local strikes, bannedFor = getStrikes(char)
				TriggerClientEvent("usa:notify", v.source, "Your loaned car was destroyed or lost! "..strikes.."/3 strikes!", "^3INFO: ^0Your loaned car was destroyed or lost! "..strikes.."/3 strikes!")
				TriggerClientEvent("vehShop:endTestDrive",v.source)
				testDrivers[k] = nil
			else
				local diff = GetGameTimer() - v.timestamp
				if diff > warnMinutes * 60 * 1000 and testDrivers[k].warned == false then
					testDrivers[k].warned = true
					TriggerClientEvent("usa:notify", v.source, "You have driven the car for " .. tostring(warnMinutes) .. " minutes, return to the dealership immediatly!", "^3INFO: ^0You have driven the car for " .. tostring(warnMinutes) .. " minutes, return to the dealership immediatly!")
				end
				if diff > finalMinutes * 60 * 1000 then
					exports.globals:getNumCops(function(numCops)
						if numCops > 3 then
							addStrike(char)
							local strikes, bannedFor = getStrikes(char)
							TriggerClientEvent("usa:notify", v.source, "You did not return to the dealership, the emergency services have been called! "..strikes.."/3 strikes!", "^3INFO: ^0You did not return to the dealership, the emergency services have been called! "..strikes.."/3 strikes!")
							lastStolenPlate = v.plate
							TriggerEvent("mdt:markTestDriveVehicleStolen", v.plate)
							TriggerEvent('911:StolenTestDriveVehicle', GetEntityCoords(ent), v.plate, char.getFullName())
							stolenVehicles[v.plate] = {netID = v.netID, coords = GetEntityCoords(ent), hash = GetEntityModel(ent), stolenAt = GetGameTimer(), trackedBy = {}}
						else
							addStrike(char)
							local strikes, bannedFor = getStrikes(char)
							TriggerClientEvent("usa:notify", v.source, "You did not return to the dealership, the vehicle has been taken back! "..strikes.."/3 strikes!", "^3INFO: ^0You did not return to the dealership, the vehicle has been taken back! "..strikes.."/3 strikes!")
							DeleteEntity(ent)
						end
						testDrivers[k] = nil
						TriggerClientEvent("vehShop:endTestDrive",v.source)
					end)
				end
			end
		end
	end
end)

AddEventHandler('playerDropped', function (reason)
	--player dropped remove from test drive if on one
	local usource = source
	for k,v in pairs(testDrivers) do
		if v.source == usource then
			local ent = NetworkGetEntityFromNetworkId(v.netID)
			DeleteEntity(ent)
			testDrivers[k] = nil
			break
		end
	end
end)

RegisterServerEvent("mini:checkPlayerTestDrive")
AddEventHandler("mini:checkPlayerTestDrive", function(vehicle,business)
	local usource = source
	local char = exports["usa-characters"]:GetCharacter(usource)
	local license = char.getItem("Driver's License")
	local ident = char.get("_id")
	local owner_name = char.getFullName()
	if license and license.status == "valid" then
		if testDrivers[ident] == nil then
			local strikes, bannedFor = getStrikes(char)
			if strikes < 3 then
				local plate = generate_random_number_plate()
				local hash = vehicle.hash
				local price = tonumber(GetVehiclePrice(vehicle))
				local vehicle_key = {
					name = "Key -- " .. plate,
					quantity = 1,
					type = "key",
					owner = owner_name,
					make = vehicle.make,
					model = vehicle.model,
					plate = plate
				}
				TriggerEvent("lock:addPlate", plate)
				TriggerEvent("mdt:addTestDriveVehicle", vehicle.make .. " " .. vehicle.model, business, owner_name, plate)
				TriggerClientEvent("vehShop:spawnPlayersVehicle", usource, hash, plate, true)
				testDrivers[ident] = { timestamp = GetGameTimer(), plate = plate, source = usource, netID = nil, hash = hash, warned = false}
				char.giveItem(vehicle_key, 1)
				TriggerClientEvent("usa:notify", usource, "You have " .. tostring(warnMinutes) .. " minutes to test drive the car! Don't run off with it or you'll be in big trouble!", "^3INFO: ^0You have " .. tostring(warnMinutes) .. " minutes to test drive the car! Don't run off with it or you'll be in big trouble!")
			else
				TriggerClientEvent("usa:notify", usource, "You have three strikes you are banned for ".. tostring(bannedFor) .." days from this dealership!")
			end
		else
			TriggerClientEvent("usa:notify", usource, "You already have a vehicle out for a test drive!")
		end
	else
		TriggerClientEvent("usa:notify", usource, "You do not hold a valid license!")
	end
end)

RegisterServerEvent("vehShop:spawnTestDriveCallback")
AddEventHandler("vehShop:spawnTestDriveCallback", function(plate,vehNetID)
	local char = exports["usa-characters"]:GetCharacter(source)
	local ident = char.get("_id")
	testDrivers[ident].netID = vehNetID
end)

RegisterServerEvent("vehShop:returnVehicle")
AddEventHandler("vehShop:returnVehicle", function(plate, model)
	local char = exports["usa-characters"]:GetCharacter(source)
	local ident = char.get("_id")

	if testDrivers[ident].plate == plate and testDrivers[ident].hash == model then
		local ent = NetworkGetEntityFromNetworkId(testDrivers[ident].netID)
		DeleteEntity(ent)
		testDrivers[ident] = nil
		TriggerClientEvent("vehShop:endTestDrive",source)
		char.removeItem("Key -- " .. plate, 1)
	end
end)

RegisterServerEvent("mini:checkVehicleMoney")
AddEventHandler("mini:checkVehicleMoney", function(vehicle, business)
	local usource = source
	local playerIdentifier = GetPlayerIdentifiers(usource)[1]
	local char = exports["usa-characters"]:GetCharacter(usource)
	local license = char.getItem("Driver's License")
	local vehicles = char.get("vehicles")
	local money = char.get("bank")
	local owner_name = char.getFullName()
	if license and license.status == "valid" then
		local strikes, bannedFor = getStrikes(char)
		if strikes < 3 then
			local hash = vehicle.hash
			local price = tonumber(GetVehiclePrice(vehicle))
			if price <= money then
				local plate = generate_random_number_plate()
				if vehicles then
					char.removeBank(price, "PDM Vehicle Purchase")
					local vehicle = {
						owner = owner_name,
						make = vehicle.make,
						model = vehicle.model,
						hash = hash,
						plate = plate,
						stored = false,
						price = price,
						inventory = exports["usa_vehinv"]:NewInventory(vehicle.storage_capacity),
						storage_capacity = vehicle.storage_capacity
					}

					local vehicle_key = {
						name = "Key -- " .. plate,
						quantity = 1,
						type = "key",
						owner = owner_name,
						make = vehicle.make,
						model = vehicle.model,
						plate = plate
					}

					table.insert(vehicles, vehicle.plate)
					char.set("vehicles", vehicles)
					char.giveItem(vehicle_key, 1)
					AddVehicleToDB(vehicle)

					TriggerEvent("lock:addPlate", vehicle.plate)
					TriggerClientEvent("usa:notify", usource, "Here are the keys! Thanks for your business!", "Purchased a " .. vehicle.make .. " " .. vehicle.model .. " for $" .. exports.globals:comma_value(vehicle.price))
					TriggerClientEvent("vehShop:spawnPlayersVehicle", usource, hash, plate)

					if business then
						exports["usa-businesses"]:GiveBusinessCashPercent(business, price)
					end
				end
			else
				TriggerClientEvent("usa:notify", usource, "Not enough money in bank to purchase!")
			end
		else
			TriggerClientEvent("usa:notify", usource, "You have three strikes you are banned for ".. tostring(bannedFor) .." days from this dealership!")
		end
	else
		TriggerClientEvent("usa:notify", usource, "Come back when you have a valid driver's license!")
	end
end)

RegisterServerEvent("vehShop:loadVehiclesToSell")
AddEventHandler("vehShop:loadVehiclesToSell", function()
	local usource = source
	local char = exports["usa-characters"]:GetCharacter(source)
	local vehicles = char.get("vehicles")
	local endpoint = "/vehicles/_design/vehicleFilters/_view/getVehiclesToSellWithPlates"
	local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
	PerformHttpRequest(url, function(err, responseText, headers)
		if responseText then
			local responseVehArray = {}
			local data = json.decode(responseText)
			if data.rows then
				for i = 1, #data.rows do
					local veh = {
						plate = data.rows[i].value[1], -- plate
						make = data.rows[i].value[2], -- make
						model = data.rows[i].value[3], -- model
						price = data.rows[i].value[4], -- price
						_rev = data.rows[i].value[5] -- _rev
					}
					table.insert(responseVehArray, veh)
				end
			end
			TriggerClientEvent("vehShop:displayVehiclesToSell", usource, responseVehArray)
		end
	end, "POST", json.encode({
		keys = vehicles
	}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end)

RegisterServerEvent("vehShop:sellVehicle")
AddEventHandler("vehShop:sellVehicle", function(toSellVehicle)
	local usource = source
	print("toSellVehicle: " .. toSellVehicle.model)
	local vehiclePrice = GetVehiclePrice(toSellVehicle)
	local char = exports["usa-characters"]:GetCharacter(usource)
	local ow_id = char.get("_id")
	local boostvehicle = MySQL.query.await('SELECT * FROM boosted_vehicles WHERE owner_id = ?', {ow_id})
	local c = false
	if not vehiclePrice then
		if toSellVehicle.price then
			print("vehicle price nil with toSellVehicle: " .. toSellVehicle.make .. " " .. toSellVehicle.model)
			TriggerClientEvent("chatMessage", usource, "", {}, "^3CAR DEALER: ^0We're not interested in it, sorry.")
		end
		return
	end
	-- check if MySQL data exists
	if not boostvehicle[1] then
		c = false
	else
		c = true
	end
	-- if value found in SQL data, then set price for VIN scratched vehicle
	if c then
		if toSellVehicle.plate == boostvehicle[1].plate then
			vehiclePrice = boostvehicle[1].price
		end
	end
	local char = exports["usa-characters"]:GetCharacter(usource)
	local vehicles = char.get("vehicles")
	for i = 1, #vehicles do
		if vehicles[i] == toSellVehicle.plate then
			table.remove(vehicles, i)
			char.set("vehicles", vehicles)
			break
		end
	end
	-- remove from DB / take money --
	RemoveVehicleFromDB(toSellVehicle, function(err, resp)
		char.giveMoney(math.ceil(vehiclePrice * .30))
		TriggerClientEvent("usa:notify", usource, "~y~SOLD:~w~ " .. toSellVehicle.make .. " " .. toSellVehicle.model .. "\n~y~PRICE: ~g~$" .. exports.globals:comma_value(.30 * toSellVehicle.price))
	end)
	if c then
		-- Deletes value in `boosted_vehicles` DB
		MySQL.execute("DELETE FROM boosted_vehicles WHERE plate = ?", {boostvehicle[1].plate})
	end
end)

function GetVehiclePrice(vehicle)
	if vehicle.model ~= "Bicycle" then
		for k, v in pairs(vehicleShopItems["vehicles"]) do
			for i = 1, #v do
				local name1 = vehicle.make .. " " .. vehicle.model
				local name2 = v[i].make .. " " .. v[i].model
				if name1 == name2 then
					return v[i].price
				end
			end
		end
	else -- bike
		return BIKES[vehicle.make].price
	end
end

function generate_random_number_plate()
	local charset = {
		numbers = {},
		letters = {}
	}
	-- QWERTYUIOPASDFGHJKLZXCVBNM1234567890
	for i = 48,  57 do table.insert(charset.numbers, string.char(i)) end -- add numbers 1 - 9
	for i = 65,  90 do table.insert(charset.letters, string.char(i)) end -- add capital letters
	local number_plate = ""
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	number_plate = number_plate .. charset.letters[math.random(#charset.letters)] -- letter
	number_plate = number_plate .. charset.letters[math.random(#charset.letters)] -- letter
	number_plate = number_plate .. charset.letters[math.random(#charset.letters)] -- letter
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	return number_plate
end

-- Insert new vehicle into DB --
function AddVehicleToDB(vehicle)
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
		couchdb.createDocumentWithId("vehicles", vehicle, vehicle.plate, function(success)
			if success then
				--print("* Vehicle created in DB!! *")
			else
				--print("* Error: vehicle was not created in DB!! *")
			end
		end)
	end)
end

-- Delete vehicle from DB --
function RemoveVehicleFromDB(vehicle, cb)
	PerformHttpRequest("http://127.0.0.1:5984/".."vehicles".."/".. vehicle.plate .."?rev=" .. vehicle._rev, function(err, rText, headers)
		RconPrint("\nerr = " .. err)
		RconPrint("\nrText = " .. rText)
		cb(err, rText)
	end, "DELETE", "", {["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
end

function GetVehicleByHashName(hashName)
	local hash = GetHashKey(hashName)
	for category, items in pairs(vehicleShopItems["vehicles"]) do
		for i = 1, #items do
			if type(items[i].hash) == "string" then
				if items[i].hash == hashName then
					return items[i]
				end
			elseif type(items[i].hash) == "number" then
				if items[i].hash == hash then
					return items[i]
				end
			end
		end
	end
	return nil
end

function GetVehicleByHashNumber(hashNum)
	for category, items in pairs(vehicleShopItems["vehicles"]) do
		for i = 1, #items do
			if type(items[i].hash) == "string" then
				if GetHashKey(items[i].hash) == hashNum then
					return items[i]
				end
			elseif type(items[i].hash) == "number" then
				if items[i].hash == hashNum then
					return items[i]
				end
			end
		end
	end
	return nil
end

exports("AddVehicleToDB", AddVehicleToDB)
exports("GetVehicleByHashName", GetVehicleByHashName)
exports("GetVehicleByHashNumber", GetVehicleByHashNumber)
exports("generate_random_number_plate", generate_random_number_plate)
