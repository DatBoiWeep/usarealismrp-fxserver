svConfig = {
    -- This is for weepers to check if there is anything wrong with Boosting.
    debugMode = true,

    -- The currency settings which are used to display money amount in the tablet's HTML.
    -- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/toLocaleString
    -- The first variable (currencyLocale) defines how the number is formatted. For example in 'en-US': '$60,890.00', 'et': '60 890,00 $'
    -- The second variable (currency) defines the symbol which is used - €/$ or whatever you wish.
    currencyLocale = 'en-us',
    currency = 'USD',

    -- Time between boosting contract loop executions. If the default value (15) is used, then every 15 minutes (4 times per hour), contracts will be
    -- generated for the players who are queued. The chances of receiving a contract in that loop execution are defined in vehicle class configs, the
    -- 'generationPercentage' value. For example, if the 'D' class has a generationPercentage value of 70, then every 15 minutes there is a 70% chance
    -- that you will receive a D class boosting contract.
    minutesBetweenGenerations = 15,

    -- The amount of contracts that player will be given when he opens the tablet for the very first time (to get him started).
    initialContractAmount = 7,

    -- The amount of online police required for people to get important (A / S class) contracts. This will be applied to classes which have the 'isImportant' as true.
    requiredPoliceAmount = 2,

    --  Define the principal which will be given the ACE permission to use the in-game admin panel. If you don't wish to use this, set it to false.
    -- In order for this to work, make sure you allow ox_lib to grant permissions (https://overextended.dev/ox_lib) ('You'll also need to grant ace permissions to the resource.')
    adminPrincipal = false,

    -- A comma separated list of player identifiers (strings) that are allowed to access the admin panel (in addition to those allowed by ACE permissions).
    -- Examples for different frameworks:
    --
    -- QB: adminIdentifiers = {'RKDJ2732', 'MNSU0922'},
    -- ESX: adminIdentifiers = {'char1:17beaa0fce04fd5d7e8571a6a1b51f172e7c4457', 'char1:17beaa0fce04fd5d7e8571a6a1b51f172e7c4457'},
    adminIdentifiers = {},

    -- If the player should be penalized during delivery for having an engine whose health is below 80%.
    penalizeForDamagedEngine = true,

    -- The amount in dollars that's the maximum penalty for having a damaged engine when dropping off.
    maximumEngineDamagePenalty = 750,

    -- If the vehicle were in the center of the indicated area, it would be found instantly. To prevent this, an offset is used. This value determines
    -- the min/max offset of the x and y axis (randomly generated between 0 and this value) from the vehicle spawn point (in meters).
    -- Related client-side config values: vehicleCreationDistance, vehicleAreaRadius
    vehicleAreaMaximumOffset = 145.0,

    -- An option to enable / disable VIN scratching. If disabled, then the player will get an error message when trying to VIN scratch a vehicle.
    vinScratchingEnabled = true,

    -- Determine whether experience should be distributed among group members when performing a contract with a group.
    -- Set to 'true' for experience to be shared among group members.
    -- Set to 'false' for experience to be given only to the contract owner.
    splitExperienceInGroups = true,

    -- If all group members must enter the red pick up area at least once to get any kind of rewards (money, crypto, XP) in the end.
    -- This can be used to prevent abuse situations where people are group boosting and some of the members are just AFKing along to get XP.
    groupActivityCheck = true,

    -- If this is defined, the user will be shown an 'Upload' button in the profile picture upload section.
    -- When pressed, the user will be redirected to this website in their browser to upload their content.
    recommendedUploadWebsite = 'https://upload.rahe.dev',

    -- A list of image hosts will be allowed to use as a profile picture. The player won't be allowed to use a provider which isn't in this list.
    -- If you have a 'recommendedUploadWebsite' defined in the previous option, then that will automatically be added into here.
    --
    -- We do NOT recommend using Imgur or Discord as allowed hosts!
    -- They rate-limit and/or change URLs causing your images to stop working sooner or later, even if they may seem fine at first.
    allowedImageHosts = {
        'media.rahe.dev',
        'r2.fivemanage.com'
    },

    -- A list of conditions for different vehicle classes
    -- The list must be ordered by their 'xpRequired' value (high -> low)

    -- Class parameters explained:
    -- @class: the main identifier, used for displaying and getting a vehicles class
    -- @xpRequired: experience required for a player to receive a contract of this class
    -- @generationPercentage: the probability of a player getting this class when a generation occurs (0-100%)
    -- @timeBetweenGenerations: the time in minutes that has to be passed since the last generation of this class
    -- @isImportant: if a class is important, then it needs police presence for it to be generated (svConfig.requiredPoliceAmount) and has a GPS tracker.
    -- @gpsHacksRequired: if the class is marked is important, then it will have a GPS tracker which has to be hacked this many times.
    -- @gpsHackMinTime: the minimum amount of time the player has to complete the GPS hacking mini game.
    -- @gpsHackMaxTime: the maximum amount of time the player has to complete the GPS hacking mini game.
    -- @maxContractsOfType: how many contracts of this type can be available at once
    -- @maxContactsPerSession: how many contracts of this type can one player receive per restart
    -- @priceMin: the minimum crypto price needed to accept the contract
    -- @priceMax: the maximum crypto price needed to accept the contract
    -- @minScratchPrice = the minimum crypto price needed to VIN scratch (take it yourself) the vehicle
    -- @maxScratchPrice = the maximum crypto price needed to VIN scratch (take it yourself) vehicle
    -- @rewardCashMin: the minimum cash reward
    -- @rewardCashMax: the maximum cash reward
    -- @rewardCryptoMin: the minimum crypto reward
    -- @rewardCryptoMax: the maximum crypto reward
    -- @experiencePerJob: amount of experience points received when the contract is successful
    -- @bonusExperienceMultiplier: the multiplier by which 'experiencePerJob' will be multiplied with when 'bonusExperienceMinimumMembers' is reached. Used only when 'splitExperienceInGroups' is true.
    -- @bonusExperienceMinimumMembers: the minimum number of members required within a group for the bonus 'bonusExperienceMultiplier' to take effect. Used only when 'splitExperienceInGroups' is true.
    -- @tuningChance: the probability of the vehicle being tuned (0-100%)
    -- @riskChances: the probability of different risks on the vehicle
        -- @doorsLocked: the probability that vehicle doors are locked
        -- @advancedLockChance: the probability that vehicle doors are locked with an advanced lock (must use a better lock pick than the bad one)
        -- @advancedSystemChance: the probability that vehicle doors are locked with an high-tech system (must use a hacking device)
        -- @npcChance: the probability (percentage 0-100) that killer NPCs will spawn when you try to hack the vehicle.
            -- npcChance can only be higher than 0 on classes that have isImportant = true. This is because isImportant boosts use different spawns that
            -- have npc spawn locations built in (shared.lua advancedVehicleCoords). DO NOT use this variable on lower, non-important boosts.

    vehicleClasses = {
        [1] = {
            class = "S",
            xpRequired = 2500,
            generationPercentage = 1,
            timeBetweenGenerations = 120,
            isImportant = true,
            gpsHacksRequired = 20,
            gpsHackMinTime = 20,
            gpsHackMaxTime = 25,
            maxContractsOfType = 1,
            maxContractsPerSession = 3,
            priceMin = 1750,
            priceMax = 2150,
            minScratchPrice = 12150,
            maxScratchPrice = 21000,
            rewardCashMin = 50000,
            rewardCashMax = 95000,
            rewardCryptoMin = 1000,
            rewardCryptoMax = 1400,
            experiencePerJob = 27,
            bonusExperienceMultiplier = 4,
            bonusExperienceMinimumMembers = 4,
            tuningChance = 65,
            riskChances = {
                doorsLocked = 100,
                advancedLockChance = 0,
                advancedSystemChance = 100,
                npcChance = 100
            }
        },
        [2] = {
            class = "A",
            xpRequired = 1000,
            generationPercentage = 30,
            timeBetweenGenerations = 30,
            isImportant = true,
            gpsHacksRequired = 10,
            gpsHackMinTime = 25,
            gpsHackMaxTime = 30,
            maxContractsOfType = 4,
            maxContractsPerSession = 10,
            priceMin = 250,
            priceMax = 450,
            minScratchPrice = 2500,
            maxScratchPrice = 4500,
            rewardCashMin = 27500,
            rewardCashMax = 51000,
            rewardCryptoMin = 500,
            rewardCryptoMax = 700,
            experiencePerJob = 19,
            bonusExperienceMultiplier = 4,
            bonusExperienceMinimumMembers = 4,
            tuningChance = 45,
            riskChances = {
                doorsLocked = 100,
                advancedLockChance = 0,
                advancedSystemChance = 100,
                npcChance = 75
            }
        },
        [3] = {
            class = "B",
            xpRequired = 100,
            generationPercentage = 40,
            timeBetweenGenerations = 0,
            isImportant = false,
            maxContractsOfType = 1,
            maxContractsPerSession = 0,
            priceMin = 40,
            priceMax = 60,
            minScratchPrice = 400,
            maxScratchPrice = 600,
            rewardCashMin = 3000,
            rewardCashMax = 4000,
            rewardCryptoMin = 60,
            rewardCryptoMax = 90,
            experiencePerJob = 12,
            bonusExperienceMultiplier = 4,
            bonusExperienceMinimumMembers = 3,
            tuningChance = 25,
            riskChances = {
                doorsLocked = 100,
                advancedLockChance = 50,
                advancedSystemChance = 0,
                npcChance = 0
            }
        },
        [4] = {
            class = "C",
            xpRequired = 10,
            generationPercentage = 50,
            timeBetweenGenerations = 0,
            isImportant = false,
            maxContractsOfType = 2,
            maxContractsPerSession = 0,
            priceMin = 3,
            priceMax = 6,
            minScratchPrice = 30,
            maxScratchPrice = 60,
            rewardCashMin = 1750,
            rewardCashMax = 3100,
            rewardCryptoMin = 9,
            rewardCryptoMax = 18,
            experiencePerJob = 3,
            bonusExperienceMultiplier = 3,
            bonusExperienceMinimumMembers = 2,
            tuningChance = 25,
            riskChances = {
                doorsLocked = 100,
                advancedLockChance = 0,
                advancedSystemChance = 0,
                npcChance = 0
            }
        },
        [5] = {
            xpRequired = 0,
            class = "D",
            generationPercentage = 70,
            timeBetweenGenerations = 0,
            isImportant = false,
            maxContractsOfType = 3,
            maxContractsPerSession = 0,
            priceMin = 0,
            priceMax = 0,
            minScratchPrice = 20,
            maxScratchPrice = 40,
            rewardCashMin = 1250,
            rewardCashMax = 1950,
            rewardCryptoMin = 1,
            rewardCryptoMax = 2,
            experiencePerJob = 1,
            bonusExperienceMultiplier = 2,
            bonusExperienceMinimumMembers = 2,
            tuningChance = 25,
            riskChances = {
                doorsLocked = 25,
                advancedLockChance = 0,
                advancedSystemChance = 0,
                npcChance = 0
            }
        }
    },

    storeItems = {
        ['nospacka'] = {
            cashRequired = 6000,
            cryptoRequired = 25,
            availablePerRestart = math.random(2,5),
            isSoldOut = false,
            title = "Nitrous oxide (Stage 1)",
            description = "When you need that extra bit of boost.",
            iconFile = 'nitrous-oxide.png',
            receiveItemIds = {
                [1] = 'NOS Bottle (Stage 1)',
            }
        },
        ['nospackb'] = {
            cashRequired = 13000,
            cryptoRequired = 75,
            availablePerRestart = math.random(1,3),
            isSoldOut = false,
            title = "Nitrous oxide (Stage 1 & 2)",
            description = "When you need that extra bit of boost.",
            iconFile = 'nitrous-oxide.png',
            receiveItemIds = {
                [1] = 'NOS Bottle (Stage 1)',
                [2] = 'NOS Bottle (Stage 2)',
            }
        },
        ['lockpick'] = {
            cashRequired = 150 * math.random(3,6),
            cryptoRequired = math.random(2,5),
            availablePerRestart = math.random(5,10),
            isSoldOut = false,
            title = "Lockpick",
            description = "A low-quality lockpick which will get the job done.",
            iconFile = 'lockpick.png',
            receiveItemIds = {
                [1] = 'Lockpick'
            }
        },
        ['repairkit'] = {
            cashRequired = 1500,
            cryptoRequired = 20,
            availablePerRestart = math.random(3,7),
            isSoldOut = false,
            title = "Repair kit (LW)",
            description = "Will get your car moving when you break down. Light Weight Edition",
            iconFile = 'repair-kit.png',
            receiveItemIds = {
                [1] = 'Repair Kit'
            }
        },
        ['hotwiringkit'] = {
            cashRequired = 450 * math.random(2,4), -- Blackmarket price multiplied by a rand number BECAUSE INFLATION MY BOYS
            cryptoRequired = math.random(2,5),
            availablePerRestart = math.random(7,15),
            isSoldOut = false,
            title = "Hotwiring Kit",
            description = "Get a fancy kit to help you hotwire a vehicle that you're going to 'borrow'.",
            iconFile = 'hotwiring-kit.png',
            receiveItemIds = {
                [1] = 'Hotwiring Kit'
            }
        },
        ['racingdongle'] = {
            cashRequired = 1500,
            cryptoRequired = 0,
            availablePerRestart = 75,
            isSoldOut = false,
            title = "Racing Dongle",
            description = "Prepare yourself to enter the racing world",
            iconFile = 'racingtablet.png',
            receiveItemIds = {
                [1] = 'Racing Dongle'
            }
        },
        ['laptop'] = {
            cashRequired = 5750,
            cryptoRequired = 30,
            availablePerRestart = math.random(5,10),
            isSoldOut = true,
            title = "Bank Laptop",
            description = "Time for a world of hacker man himself.",
            iconFile = 'laptop.png',
            receiveItemIds = {
                [1] = 'Bank Laptop'
            }
        }
    }
}

-- Feel free to add your own vehicles here. Most of the default cars are here, modded cars have to be added!
supportedVehicles = {
    -- S CLASS
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
    { name = "Ocelot Virtue", model = "virtue", class = "S" },
    -- Custom S Class
    { name = "Pegassi Monroe Custom", model = "monroec", class = "S" },
    -- A CLASS
    { name = "Sultan RS", model = "sultanrs", class = "A" },
    { name = "Annis Elegy Retro", model = "elegy", class = "A" },
    { name = "Bravado Banshee 900R", model = "banshee2", class = "A" },
    { name = "Schyster Deviant", model = "deviant", class = "A" },
    { name = "Pegassi Toros", model = "toros", class = "A" },
    { name = "Ubermacht Cypher", model = "cypher", class = "A" },
    { name = "Primo ARD", model = "primoard", class = "A" },
    { name = "Emperor SHEAVA", model = "sheava", class = "A" },
    { name = "Overflod Autarch", model = "autarch", class = "A" },
    { name = "Obey 8F Drafter", model = "drafter", class = "A" },
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
    { name = "Vapid Dominator", model = "dominator", class = "A" },
    { name = "Vapid Dominator GTX", model = "dominator3", class = "A" },
    { name = "Vapid Dominator ASP", model = "dominator7", class = "A" },
    { name = "Vapid Dominator GTT", model = "dominator8", class = "A" },
    { name = "Bravado Gauntlet", model = "gauntlet", class = "A" },
    { name = "Bravado Gauntlet Hellfire", model = "gauntlet4", class = "A" },
    { name = "Declasse Vigero ZX", model = "vigero2", class = "A" },
    { name = "Toundra Panthere", model = "panthere", class = "A" },
    { name = "Annis 300R", model = "r300", class = "A" },
    { name = "Declasse Tahoma Coupe", model = "tahoma", class = "A" },
    { name = "Declasse Tulip M-100", model = "tulip2", class = "A" },
    -- Custom A Class
    { name = "Bravado Buffalo Hellhound", model = "vwe_buffalo3", class = "A" },
    { name = "Bravado Gresley Hellhound", model = "vwe_gresley1", class = "A" },
    { name = "Karin Rebel Custom", model = "rebeld", class = "A" },
    -- B CLASS
    { name = "Declasse Hotring Sabre", model = "hotring", class = "B" },
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
    { name = "Weeny Issi Sport", model = "issi8", class = "B" },
    -- Custom B Class
    { name = "Annis Euros R", model = "vwe_euros1", class = "B" },
    { name = "Annis Hellion XL", model = "vwe_hellion1", class = "B" },
    { name = "Annis Savestra RE", model = "vwe_savestra1", class = "B" },
    { name = "Voodoo Caddy S", model = "voodoo_caddys", class = "B" },
    { name = "Dababy Car", model = "dababy", class = "B" }, 
    { name = "Progen Proff", model = "proff", class = "B" },
    { name = "Karin Ariant", model = "ariant", class = "B"},
    { name = "Karin Asterope RS", model = "asteropers", class = "B"},
    { name = "Albany Esperanto", model = "vwe_esperanto1", class = "B"},
    -- C CLASS
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
    { name = "Karin Boor", model = "boor", class = "C" },
    { name = "Classique Broadway", model = "broadway", class = "C" },
    { name = "Bravado", model = "eudora", class = "C" },
    -- Custom C Class
    { name = "Weeny Tamworth", model = "tamworth", class = "C" },
    -- D CLASS
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
    -- Vintage D Class
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
    -- Custom D Class
    
}

if svConfig.debugMode then
    print("DEBUG MODE - ENABLED")
end
