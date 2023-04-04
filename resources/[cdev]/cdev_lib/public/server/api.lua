clib_API = {}

-- 🌎 Webhook URL for sending logs to Discord (only if DiscordLogs is true in config)
clib_API.DiscordWebhookURL = ""

-- 📣 Event that is triggered on the server when a player spawns
RegisterNetEvent(clib_Config.getFrameworkConfig().ServerPlayerLoadEvent, function(sourceId)
    TriggerEvent("cdev_lib:api:playerLoaded", clib_Config.isESX and sourceId or source)
end)

-- 📣 Event that is triggered on the server when the player job is updated
RegisterNetEvent(clib_Config.getFrameworkConfig().ServerPlayerJobUpdateEvent, function(source, job)
    if clib_Config.isQBCore then
        TriggerEvent("cdev_lib:api:jobUpdate", source, job.name, job.grade.level)
    elseif clib_Config.isESX then
        TriggerEvent("cdev_lib:api:jobUpdate", source, job.name, job.grade)
    else
        -- 🔧 If using custom, implement your own code here
        local player = GetPlayer(source)
        if not player then
            return
        end
        player.set("job", job.name)
    end
end)

-- 🧍 Methods for handling character data on the server
clib_API.Character = {
    -- 🆔 Return the unique identifier for the character belonging to the player with the given source
    GetCharacterIdentifierFromSource = function(source)
        if clib_Config.isQBCore then
            return clib.frameworks.QBCore.Functions.GetPlayer(source).PlayerData.citizenid
        elseif clib_Config.isESX then
            return clib.frameworks.ESX.GetPlayerFromId(source).identifier
        else
            -- 🔧 If using custom, implement your own code here
            local player = GetPlayer(source)
            if not player then
                return
            end
            return player.get("_id")
        end
    end,
    -- 🆔 Return the source of the player with the given character identifier
    GetCharacterSourceFromIdentifier = function(citizenId)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayerByCitizenId(citizenId)
            return player and player.PlayerData.source or nil
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromIdentifier(citizenId)
            return player and player.source or nil
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,
    -- 🔑 Return the license attributed for the player with the given source
    GetPlayerLicenseFromSource = function(source)
        if clib_Config.isQBCore then
            return clib.frameworks.QBCore.Functions.GetPlayer(source).PlayerData.license
        elseif clib_Config.isESX then
            return clib.frameworks.ESX.GetPlayerFromId(source).license
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,
    -- 📝 Return the name of the character belonging to the player with the given source
    GetCharacterNameFromSource = function(source)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            return player and (player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname) or
                "Unknown"
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            return player and player.name or "Unknown"
        else
            -- 🔧 If using custom, implement your own code here
            local player = GetPlayer(source)
            if not player then
                return
            end
            local name = player.get("name")
            return name.first, name.last
        end
    end,
    -- 👔 Set the job of the character belonging to the player with the given source
    SetCharacterJobForSource = function(source, job, grade)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            player.Functions.SetJob(job, grade)
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            player.setJob(job, grade)
        else
            -- 🔧 If using custom, implement your own code here
            local player = GetPlayer(source)
            if not player then
                return
            end
            player.set("job", job.name)
        end
    end,
    -- 👔 Clear job (make unemployed) for the character belonging to the player with the given source
    ClearCharacterJobForSource = function(source)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            player.Functions.SetJob("unemployed", 0)
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            player.setJob("unemployed", 0)
        else
            -- 🔧 If using custom, implement your own code here
            local player = GetPlayer(source)
            if not player then
                return
            end
            player.set("job", "civ")
        end
    end,
    -- 👔 Return the job and grade of the character belonging to the player with the given source
    GetCharacterJobFromSource = function(source)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            return player.PlayerData.job.name, player.PlayerData.job.grade.level
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            return player.job.name, player.job.grade
        else
            -- 🔧 If using custom, implement your own code here
            local player = GetPlayer(source)
            if not player then
                return
            end
            return player.get("job", job.name)
        end
    end,
    -- 💸 Return the cash of the character belonging to the player with the given source
    GetCharacterCashFromSource = function(source)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            return player.PlayerData.money.cash
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            return player.getMoney()
        else
            -- 🔧 If using custom, implement your own code here
            return GetPlayer(source).get("money")
        end
    end,
    -- 💸 Add cash to the character belonging to the player with the given source
    AddCharacterCashForSource = function(source, amount)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            player.Functions.AddMoney("cash", amount)
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            player.addMoney(amount)
        else
            -- 🔧 If using custom, implement your own code here
            GetPlayer(source).giveMoney(amount)
        end
    end,
    -- 💸 Remove cash from the character belonging to the player with the given source
    RemoveCharacterCashFromSource = function(source, amount)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            player.Functions.RemoveMoney("cash", amount)
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            player.removeMoney(amount)
        else
            -- 🔧 If using custom, implement your own code here
            GetPlayer(source).removeMoney(amount)
        end
    end,
    -- 💸 Add bank money to the character belonging to the player with the given source
    AddCharacterBankForSource = function(source, amount)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            player.Functions.AddMoney("bank", amount)
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            player.addAccountMoney("bank", amount)
        else
            -- 🔧 If using custom, implement your own code here
            GetPlayer(source).giveBank(amount)
        end
    end,
    -- 💸 Remove bank money from the character belonging to the player with the given source
    RemoveCharacterBankFromSource = function(source, amount)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            player.Functions.RemoveMoney("bank", amount)
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            player.removeAccountMoney("bank", amount)
        else
            -- 🔧 If using custom, implement your own code here
            GetPlayer(source).removeBank(amount)
        end
    end,
    -- 💸 Return the bank money of the character belonging to the player with the given source
    GetCharacterBankFromSource = function(source)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            return player.Functions.GetMoney("bank")
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            return player.getAccount("bank").round
        else
            -- 🔧 If using custom, implement your own code here
            GetPlayer(source).get("bank")
        end
    end,
}

-- 👔 Methods for handling jobs
clib_API.Jobs = {
    -- 📝 Used to register a new job to the framework
    -- ⚙️ properties is a table containing the following properties:
    --  - name: The name of the job
    --  - label: The label of the job
    --  - defaultDuty: Whether the job is on duty by default
    --  - offDutyPay: Whether the job receives pay when off duty
    --  - grades: A table containing the grades of the job
    --    - Each grade is a table with a string key (grade number) containing the following properties:
    --      - name: The label of the grade
    --      - payment: The payment of the grade
    ---@alias GradeTable { [string]: { name: string, payment: number } }
    ---@param properties { name: string, label: string, defaultDuty: boolean, offDutyPay: boolean, grades: GradeTable }
    RegisterJob = function(properties)
        if not properties.grades then
            properties.grades = {}
        end

        if clib.config.isQBCore then
            clib.frameworks.QBCore.Functions.AddJob(properties.name, {
                label = properties.label,
                defaultDuty = properties.defaultDuty,
                offDutyPay = properties.offDutyPay,
                grades = properties.grades,
            })
        elseif clib.config.isESX then
            local timeout = GetGameTimer()

            while table.length(ESX.GetJobs()) == 0 and timeout < timeout + 10000 do
                Wait(0)
            end

            for job, _ in pairs(ESX.GetJobs()) do
                if job == properties.name then
                    return
                end
            end

            clib_DB.Insert("INSERT INTO jobs(name, label) VALUES(?, ?)", { properties.name, properties.label })

            for level, grade in pairs(properties.grades) do
                clib_DB.Insert("INSERT INTO job_grades(job_name, grade, name, label, salary, skin_male, skin_female) VALUES(?, ?, ?, ?, ?, ?, ?)"
                    ,
                    { properties.name, level, grade.name, grade.name:gsub("^%l", string.upper), grade.payment, "{}",
                        "{}"
                    })
            end

            clib.frameworks.ESX.RefreshJobs()
        else
            -- 🔧 If using custom, implement your own code here
        end
    end
}

-- 👮 Methods for handling permissions
clib_API.Permission = {
    -- ✅ Check if the player with the given source has the given permission level (see yourframework_config.lua)
    HasPermissionLevel = function(source, level)
        if level == PERMISSION_NONE then
            return true
        end

        if clib.config.isQBCore then
            local perms = clib.frameworks.QBCore.Functions.GetPermission(source)

            for perm, _ in pairs(perms) do
                local permLevel = clib.config.getFrameworkConfig().PermissionLevel[perm]

                if permLevel and permLevel >= level then
                    return true
                end
            end
        elseif clib.config.isESX then
            local perms = clib.frameworks.ESX.GetPlayerFromId(source).getGroup()
            local permLevel = clib.config.getFrameworkConfig().PermissionLevel[perms]

            if permLevel and permLevel >= level then
                return true
            end
        else
            -- 🔧 If using custom, implement your own code here
            return true
        end
    end,
    -- ✅ Check if the player with the given source has the given permission name
    HasPermissionName = function(source, name)
        if clib.config.isQBCore then
            local perms = clib.frameworks.QBCore.Functions.GetPermission(source)

            for perm, _ in pairs(perms) do
                if perm == name then
                    return true
                end
            end
        elseif clib.config.isESX then
            local perms = clib.frameworks.ESX.GetPlayerFromId(source).getGroup()

            if perms == name then
                return true
            end
        else
            -- 🔧 If using custom, implement your own code here
            return true
        end
    end,
}

-- 📦 Database queries
clib_API.Queries = {
    CreateSettingsTable = function()
        clib_DB.Query([[
            CREATE TABLE IF NOT EXISTS `cdev_dynamic_settings` (
              `name` varchar(100) NOT NULL,
              `value` varchar(255) NOT NULL,
              PRIMARY KEY (`name`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
        ]])
    end,
    FetchSettingsTable = function()
        return clib_DB.Query("SELECT * FROM cdev_dynamic_settings")
    end,
    UpsertDynamicSetting = function(key, value)
        clib_DB.Update("INSERT INTO cdev_dynamic_settings(name, value) VALUES(?, ?) ON DUPLICATE KEY UPDATE value = ?",
            {
                key,
                value,
                value,
            })
    end,
}

function GetPlayer(usource)
    local char = exports["usa-characters"]:GetCharacter(usource)
    if char then
        return char
    else
        return
    end
end