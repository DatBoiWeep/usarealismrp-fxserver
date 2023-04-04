PublicSharedResourceConfig = {
    -- 🚗 The format and length used for vehicle plates (maximum 8 characters)
    -- 📣 N = number, L = letter, S = space, X = number or letter
    -- 📣 Example: NNNLLL could output "547EXW", XXXX XXX could output "8XA5 12E"
    PlateFormat = "NNLLLNNN",

    -- 🏢 Base dealership job details
    DealershipJob = {
        -- 📦 Stash weight capacity
        StashWeightCapacity = 1000,

        -- 📦 Stash slot count
        StashSlotCount = 50,

        -- ✅ Job role permissions for specific actions
        RoleRequirements = {
            OpenManagementMenu = VEHICLESHOP_JOB_ROLES.EMPLOYEE,
            ManageStock = VEHICLESHOP_JOB_ROLES.BOSS,
            ManageEmployees = VEHICLESHOP_JOB_ROLES.BOSS,
            ManageSettings = VEHICLESHOP_JOB_ROLES.BOSS,
            ManageVault = VEHICLESHOP_JOB_ROLES.BOSS,
            OpenStash = VEHICLESHOP_JOB_ROLES.EMPLOYEE,
            ManageShowroom = VEHICLESHOP_JOB_ROLES.EMPLOYEE,
            ManageOrders = VEHICLESHOP_JOB_ROLES.EMPLOYEE,
        },
    },

    -- 🏢 Automatic thumbnail generation in-game (mostly for imports)
    ThumbnailGenerator = {
        -- ⚙️ Whether or not to enable the thumbnail generator (customizable in public/client/thumbnail.lua)
        Enabled = true,
        -- 🚗 Vehicle position
        VehiclePosition = vector4(405.32, -968.45, -99.0, 180.29),
        -- Screenshot dependency
        ScreenshotDependency = "screenshot-basic",
    },

    -- 🚗 Whether or not to enable the test drive feature (customizable in public/client/api.lua)
    EnableTestDrive = true,

    -- ‍💨 Poof (disappear) test drive vehicle if it's not returned within the configured time
    PoofTestDriveVehicle = false,

    -- ⚙️ Kill engine and make test drive vehicle undriveable if it's not returned within the configured time
    KillTestDriveVehicleEngine = true,

    -- 💲 Charge the player if they don't return the test drive vehicle within the configured time
    ChargePlayerForTestDriveVehicle = true,

    -- 💲 Amount to charge the player if they don't return the test drive vehicle within the configured time
    ChargePlayerForTestDriveVehicleAmount = 1000,

    -- ⌛ Time in seconds before a test drive vehicle is poofed (if PoofTestDriveVehicle is true)
    TestDriveVehiclePoofTime = 60 * 5, -- 5 minutes

    -- 👮 Permission level for shop creator menu (see https://docs.cdev.shop/fivem/cdev-library under framework page)
    ShopCreatorPermissionLevel = PERMISSION_HIGH,

    -- ⌨️ Default controls for the shop creator menu (see https://docs.fivem.net/docs/game-references/controls)
    CreatorControls = {
        CONFIRM_ANY_ACTION = 38, -- E
        CANCEL_ANY_ACTION = 200, -- ESC
        GENERAL_SAVE = 201, -- Enter
        GENERAL_TOGGLE = 37, -- TAB
        GENERAL_ALTERNATE = 19, -- L. ALT
        INCREASE = 15, -- Scroll UP
        DECREASE = 14, -- Scroll DOWN
    },

    -- ⌨️ Default controls for drawtext shops if using any (see https://docs.fivem.net/docs/game-references/controls)
    DrawtextShopControls = {
        BROWSE_STOCK = 38, -- E
        MANAGEMENT = 38, -- E
    },

    -- 🔑 Give keys to dealership employee first instead of the customer when selling a vehicle
    GiveKeysToEmployeeFirst = false,

    -- 🧑 Allow shop owners to toggle free shop mode (no employee required to purchase vehicles)
    AllowFreeShop = true,

    -- 🚗 If test drive is enabled, whether or not free shops should have test drives
    EnableFreeShopTestDrive = false,

    -- 💲 Charge shop owners for ordering vehicles
    ChargeShopOwnersForOrder = true,

    -- 🧑 Enable automatic free shop (enable free shop automatically when there are no employees online, that also means free shop will only activate under that circumstance)
    -- 📣 AllowFreeShop must be true for this to work
    -- 📣 The individual free shop shop setting will be invisible if this is enabled
    EnableAutomaticFreeShop = false,

    -- 💲 Percentage Limit for how much margin dealerships can have for profit (-1 = Unlimited)
    ResaleMarginLimit = -1,
}
