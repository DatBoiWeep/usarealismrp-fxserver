Config = {}
Config.Framework = 'Standalone' -- 'QB', 'ESX' or 'Standalone'.
Config.LoadIsland = false -- Set to false if you already have a different script loading Cayo Perico Island.
Config.LasersAlpha = 255 -- Set Alpha to 255 if you want lasers to be visible without using a smoke grenade (WEAPON_SMOKEGRENADE).
Config.C4Item = 'Sticky Bomb' -- Item name for C4 used on doors.If you are on QBCore make sure to add the item on QBShared.Items
Config.RemoveC4 = true -- Remove C4 after use?.
Config.PantherItem = 'panther' -- There's no sell location, make sure to add it to your own pawnshop script. If you don't have one: https://forum.cfx.re/search?q=pawnshop%20%23development%3Areleases
Config.MinCops = 0 -- Min Cops online to start the heist.
Config.Cooldown = 8 * 60 -- minutes

Config.Rewards = {
	['Office'] = math.random(10000, 50000), -- Cash you receive from the office safe.
	['Cash'] = math.random(20000, 60000), -- Cash you receive from the basement money pile.
	['Safe'] = math.random(40000, 125000) -- Cash you receive from the basement safe after minigame.
}

Config.Lang = {
	['jump'] = 'Press ~r~[E]~w~ to jump',
	['exit'] = 'Press ~r~[E]~w~ to exit',
	['startheist'] = 'Press ~r~[E]~w~ to start heist',
	['hack'] = 'Press ~r~[E]~w~ to hack',
	['grab'] = 'Press ~r~[E]~w~ to grab',
	['break'] = 'Press ~r~[E]~w~ to break',
	['crack'] = 'Press ~r~[E]~w~ to crack',
	['door'] = 'Press ~r~[E]~w~ to open',
	['c4'] = 'You need a sticky bomb!',
	['missing_item'] = "You don't have the correct item",
	['moneyreward'] = 'You stole $',
	['cops'] = 'Not enough cops online',
	['CopAlert'] = 'Security Alarm triggered at Cayo Perico Mansion'
}

Config.GuardWeapons = {
	"WEAPON_PISTOL",
	"WEAPON_SMG",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_HEAVYPISTOL"
}

Config.Cartel = { -- The bad guys
	[1] = {
		pos = {5008.5419921875, -5729.5219726562, 15.842425346375, 230.67},
		ped = 'g_m_y_mexgoon_03',
		weapon = 'WEAPON_PISTOL',
		armour = 100
	},
	[2] = {
		pos = {4997.7836914062, -5742.2490234375, 14.840622901917, 62.35},
		ped = 'g_m_y_mexgang_01',
		weapon = 'WEAPON_PISTOL',
		armour = 100
	},
	[3] = {
		pos = {4991.265625, -5765.1962890625, 16.279245376587, 209.67},
		ped = 'g_m_m_mexboss_02',
		weapon = 'WEAPON_PISTOL',
		armour = 100
	},
	[4] = {
		pos = {5030.4907226562, -5747.5151367188, 16.278430938721, 95.03},
		ped = 'g_m_y_mexgoon_02',
		weapon = 'WEAPON_PISTOL',
		armour = 100
	},
	[5] = {
		pos = {5012.5341796875, -5743.7470703125, 19.880350112915, 317.67},
		ped = 'g_m_y_mexgoon_01',
		weapon = 'WEAPON_PISTOL',
		armour = 100
	},
	[6] = {
		pos = {4990.46875, -5724.1943359375, 19.880205154419, 204.67},
		ped = 'g_m_y_mexgang_01',
		weapon = 'WEAPON_PISTOL',
		armour = 100
	},
	[7] = {
		pos = {4995.1323242188, -5761.8486328125, 19.880205154419, 31.81},
		ped = 'a_m_y_mexthug_01',
		weapon = 'WEAPON_PISTOL',
		armour = 100
	},
	[8] = {
		pos = {4994.0908203125, -5761.291015625, 19.880229949951, 291.67},
		ped = 'g_m_m_mexboss_02',
		weapon = 'WEAPON_PISTOL',
		armour = 100
	},
}

local moreGuardCoords = {
	{4995.7392578125, -5762.7045898438, 19.880214691162},
	{5002.0463867188, -5747.9711914063, 19.880252838135},
	{5014.9790039063, -5745.3681640625, 19.880342483521},
	{5016.123046875, -5757.0727539063, 19.880004882813},
	{5009.5986328125, -5778.8125, 17.677640914917},
	{5015.4223632813, -5766.6591796875, 16.277658462524},
	{4987.396484375, -5777.0717773438, 17.076391220093},
	{4986.5258789063, -5770.1977539063, 15.892503738403},
	{4989.4077148438, -5737.1123046875, 14.840600967407},
	{5022.8881835938, -5734.6313476563, 17.679229736328},
	{4985.75390625, -5719.8916015625, 19.880228042603},
	{5016.1420898438, -5718.1655273438, 20.077457427979},
	{5038.9663085938, -5722.5541992188, 17.077449798584},
	{4996.9091796875, -5707.0322265625, 20.079755783081},
	{4995.505859375, -5733.7329101563, 19.880205154419},
}

for i = 1, #moreGuardCoords do
	Config.Cartel[i + 8] = {
		pos = moreGuardCoords[i],
		ped = 'g_m_m_mexboss_02',
		armour = 100
	}
	Config.Cartel[i + 8].weapon = Config.GuardWeapons[math.random(#Config.GuardWeapons)]
end

Config.Doors = {
    [1] = {
        Model       = 3687954027,
        Coordinates = vector3(5006.242, -5750.411, 29.04091),
		Text		= {5005.833, -5750.85, 28.73159},
        Locked      = true,
    },
	[2] = {
        Model       = 2934028332,
        Coordinates = vector3(5006.602, -5734.467, 15.93675),
		Text		= {5006.578, -5733.536, 15.93675},
        Locked      = true,
    },
	[3] = {
        Model       = 2934028332,
        Coordinates = vector3(4992.827, -5756.658, 15.98839),
		Text		= {4992.102, -5756.666, 15.98839},
        Locked      = true,
    },
	[4] = {
        Model       = 2236181096,
        Coordinates = vector3(4998.083, -5743.132, 14.94133),
		Text		= {4998.083, -5742.508, 14.94133},
        Locked      = true,
    },
	[5] = {
        Model       = 3664155221,
        Coordinates = vector3(5007.62, -5753.608, 15.57295),
		Text		= {5008.25, -5753.608, 15.57295},
        Locked      = true,
    },
	[6] = {
        Model       = -1360938964,
        Coordinates = vector3(5002.29, -5746.74, 14.94),
		Text		= {5002.29, -5746.74, 14.94},
        Locked      = true,
    },
}