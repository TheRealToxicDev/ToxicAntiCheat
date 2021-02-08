--[[
    LOAD AND INITIALIZE THE BAN LIST IF PRESENT
]]

TOX.LoadBanList = function()
    local banlistContent = LoadResourceFile(GetCurrentResourceName(), 'data/banlist.json')

    if (not banlistContent) then
        local newBanlist = json.encode({})

        banlistContent = newBanlist

        SaveResourceFile(GetCurrentResourceName(), 'data/banlist.json', newBanlist, -1)
    end

    local banlist = json.decode(banlistContent)

    if (not banlist) then
        print('-------------------!' .. _('fatal_error') .. '!------------------\n')
        print(_('failed_to_load_banlist') .. '\n')
        print(_('failed_to_load_check') .. '\n')
        print('-------------------!' .. _('fatal_error') .. '!------------------\n')

        TOX.PlayerBans = {}
    else
        TOX.PlayerBans = banlist
    end

    TOX.BanListLoaded = true
end

--[[
    LOAD AND INITIALIZE THE CONFIGURATION
]]

TOX.LoadConfig = function()
    TOX.LoadVersion()

    TOX.Config = {
        UpdateIdentifiers = TOX.GetConfigVariable('toxicanticheat.updateidentifiers', 'boolean'),
        GodMode = TOX.GetConfigVariable('toxicanticheat.godmode', 'boolean'),
        Webhook = TOX.GetConfigVariable('toxicanticheat.webhook', 'string'),
        BypassEnabled = TOX.GetConfigVariable('toxicanticheat.bypassenabled', 'boolean'),
        VPNCheck = TOX.GetConfigVariable('toxicanticheat.VPNCheck', 'boolean', true),
        VPNKey = TOX.GetConfigVariable('toxicanticheat.VPNKey', 'string')
    }

    TOX.ConfigLoaded = true
end

--[[
    LOAD AND INITIALIZE THE CURRENT VERSION OF THE RESOURCE
]]

TOX.LoadVersion = function()
    local Current_Version = LoadResourceFile(GetCurrentResourceName(), 'version')

    if (not Current_Version) then
        TOX.Version = '0.0.0'
    else
        TOX.Version = Current_Version
    end
end

--[[
    LOAD AND INITIALIZE THE ADD BLACKLIST FUNCTION
]]

TOX.AddBlacklist = function(data)
    local banlistContent = LoadResourceFile(GetCurrentResourceName(), 'data/banlist.json')

    if (not banlistContent) then
        local newBanlist = json.encode({})

        banlistContent = newBanlist

        SaveResourceFile(GetCurrentResourceName(), 'data/banlist.json', newBanlist, -1)
    end

    local banlist = json.decode(banlistContent)

    if (not banlist) then
        print('-------------------!' .. _('fatal_error') .. '!------------------\n')
        print(_('failed_to_load_banlist') .. '\n')
        print(_('failed_to_load_check') .. '\n')
        print('-------------------!' .. _('fatal_error') .. '!------------------\n')
        return
    end

    if (data.identifiers ~= nil and #data.identifiers > 0) then
        table.insert(banlist, data)

        TOX.PlayerBans = banlist

        TOX.LogBanToDiscord(data)

        SaveResourceFile(GetCurrentResourceName(), 'data/banlist.json', json.encode(banlist, { indent = true }), -1)
    end
end

--[[
    LOAD AND INITIALIZE THE BAN PLAYER BY EVENT FUNCTION
]]

TOX.BanPlayerByEvent = function(playerId, event)
    if (playerId ~= nil and playerId > 0 and not TOX.IgnorePlayer(source)) then
        local bannedIdentifiers = GetPlayerIdentifiers(playerId)

        if (bannedIdentifiers == nil or #bannedIdentifiers <= 0) then
            DropPlayer(playerId, _('user_ban_reason', _('unknown')))
            return 
        end

        local playerBan = {
            name = GetPlayerName(playerId) or _('unknown'),
            reason = _('banlist_ban_reason', event),
            identifiers = bannedIdentifiers
        }

        TOX.AddBlacklist(playerBan)

        DropPlayer(playerId, _('user_ban_reason', playerBan.name))
    end
end

--[[
    BAN THE PLAYER WITHOUT A REASON PROVIDED (AVOIDS ERRORS)
]]

TOX.BanPlayerWithNoReason = function(playerId)
    if (playerId ~= nil and playerId > 0 and not TOX.IgnorePlayer(source)) then
        local bannedIdentifiers = GetPlayerIdentifiers(playerId)

        if (bannedIdentifiers == nil or #bannedIdentifiers <= 0) then
            DropPlayer(playerId, _('user_ban_reason', _('unknown')))
            return 
        end

        local playerBan = {
            name = GetPlayerName(playerId) or _('unknowm'),
            reason = '',
            identifiers = bannedIdentifiers
        }

        TOX.AddBlacklist(playerBan)

        DropPlayer(playerId, _('user_ban_reason', playerBan.name))
    end
end


TOX.BanPlayerWithReason = function(playerId, reason)
    if (playerId ~= nil and playerId > 0 and not TOX.IgnorePlayer(source)) then
        local bannedIdentifiers = GetPlayerIdentifiers(playerId)

        if (bannedIdentifiers == nil or #bannedIdentifiers <= 0) then
            DropPlayer(playerId, _('user_ban_reason', _('unknown')))
            return
        end

        local playerBan = {
            name = GetPlayerName(playerId) or _('unknown'),
            reason = reason,
            identifiers = bannedIdentifiers
        }

        TOX.AddBlacklist(playerBan)

        DropPlayer(playerId, _('user_ban_reason', playerBan.name))
    end
end

TOX.KickPlayerWithReason = function(playerId, reason)
    if (playerId ~= nil and playerId > 0 and not TOX.IgnorePlayer(source)) then
        DropPlayer(playerId, _('user_kick_reason', reason))
    end
end

TOX.PlayerConnecting = function(playerId, setCallback, deferrals)
    local vpnChecked = false

    deferrals.defer()
    deferrals.update(_U('checking'))

    Citizen.Wait(100)

    if (not TOX.BanListLoaded) then
        deferrals.done(_('banlist_not_loaded_kick_player'))
        return
    end

    if (TOX.IgnorePlayer(playerId)) then
        deferrals.done()
        return
    end

    local identifiers = GetPlayerIdentifiers(playerId)

    if (identifiers == nil or #identifiers <= 0) then
        DropPlayer(playerId, _('user_ban_reason', _('unknown')))
        return
    end

    for __, playerBan in pairs(TOX.PlayerBans) do
        if (TOX.TableContainsItem(identifiers, playerBan.identifiers, true)) then
            if (TOX.Config.UpdateIdentifiers) then
                TOX.CheckForNewIdentifiers(playerId, identifiers, playerBan.name, playerBan.reason)
            end

            deferrals.done(_('user_ban_reason', playerBan.name))
            return
        end
    end

    if (TOX.Config.VPNCheck) then
        if (TOX.IgnorePlayer(playerId)) then
            return
        end

        local playerIP = TOX.GetPlayerIP(playerId)

        if (playerIP == nil) then
            deferrals.done(_('ip_blocked'))
            return
        end

        while (not TOX.ConfigLoaded) do
            Citizen.Wait(10)
        end

        local ipInfo = {}

        if (TOX.CheckedIPs ~= nil and TOX.CheckedIPs[playerIP] ~= nil) then
            ipInfo = TOX.CheckedIPs[playerIP] or {}

            local blockIP =  ipInfo.block or 0

            if (blockIP == 1) then
                local ignoreIP = false

                if (TOX.WhitelistedIPsLoaded) then
                    for _, ip in pairs(TOX.WhitelistedIPs) do
                        if (ip == playerIP) then
                            ignoreIP = true
                        end
                    end
                end

                if (not ignoreIP) then
                    deferrals.done(_('ip_blocked'))
                    return
                end
            end

            vpnChecked = true
        else
            PerformHttpRequest('http://v2.api.iphub.info/ip/' .. playerIP, function(statusCode, response, headers)
                if (statusCode == 200) then
                    local rawData = response or '{}'
                    ipInfo = json.decode(rawData)

                    TOX.CheckedIPs[playerIP] = ipInfo

                    local blockIP =  ipInfo.block or 0

                    if (blockIP == 1) then
                        local ignoreIP = false

                        if (TOX.WhitelistedIPsLoaded) then
                            for _, ip in pairs(TOX.WhitelistedIPs) do
                                if (ip == playerIP) then
                                    ignoreIP = true
                                end
                            end
                        end

                        if (not ignoreIP) then
                            deferrals.done(_('ip_blocked'))
                            return
                        end
                    end
                end

                vpnChecked = true
            end, 'GET', '', {
                ['X-Key'] = TOX.Config.VPNKey
            })
        end
    end

    while not vpnChecked do
        Citizen.Wait(10)
    end

    deferrals.done()
end

TOX.CheckForNewIdentifiers = function(playerId, identifiers, name, reason)
    local newIdentifiers = {}

    for _, identifier in pairs(identifiers) do
        local identifierFound = false

        for _, playerBan in pairs(TOX.PlayerBans) do
            if (TOX.TableContainsItem({ identifier }, playerBan.identifiers, true)) then
                identifierFound = true
            end
        end

        if (not identifierFound) then
            table.insert(newIdentifiers, identifier)
        end
    end

    if (#newIdentifiers > 0) then
        local playerBan = {
            name = GetPlayerName(playerId) or _('unknown'),
            reason = _('new_identifiers_found', reason, name),
            identifiers = newIdentifiers
        }

        TOX.AddBlacklist(playerBan)
    end
end

TOX.LogBanToDiscord = function (data)
    if (TOX.Config.Webhook == nil or
        TOX.Config.Webhook == '') then
        return
    end

    local identifierString = ''

    for _, identifier in pairs(data.identifiers or {}) do
        identifierString = identifierString .. identifier

        if (_ ~= #data.identifiers) then
            identifierString = identifierString .. '\n '
        end
    end

    local discordInfo = {
        ["color"] = "15158332",
        ["type"] = "rich",
        ["title"] = _('discord_title'),
        ["description"] = _('discord_description', data.name, data.reason, identifierString),
        ["footer"] = {
            ["text"] = 'ToxicAntiCheat | ' .. TOX.Version
        }
    }

    PerformHttpRequest(TOX.Config.Webhook, function(err, text, headers) end, 'POST', json.encode({ username = 'ToxicAntiCheat', embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
end

Citizen.CreateThread(function()
    while not TOX.BanListLoaded do
        TOX.LoadBanList()

        Citizen.Wait(10)
    end

    while not TOX.ConfigLoaded do
        TOX.LoadConfig()

        Citizen.Wait(10)
    end

    while not TOX.WhitelistedIPsLoaded do
        TOX.LoadWhitelistedIPs()

        Citizen.Wait(10)
    end
end)

TOX.RegisterServerCallback('toxicanticheat:getServerConfig', function(source, cb)
    while not TOX.ConfigLoaded do
        Citizen.Wait(10)
    end

    if ((TOX.Config.GodMode or false) and TOX.IgnorePlayer(source)) then
        TOX.Config.GodMode = false
    end

    TOX.Config.HasBypass = TOX.IgnorePlayer(source)

    cb(TOX.Config)
end)

TOX.RegisterServerCallback('toxicanticheat:getRegisteredCommands', function(source, cb)
    cb(GetRegisteredCommands())
end)

TOX.RegisterServerEvent('toxicanticheat:banPlayer', function(source, type, item)
    local _type = type or 'default'
    local _item = item or 'none'

    _type = string.lower(_type)

    if (_type == 'default') then
        TOX.BanPlayerWithNoReason(source)
    elseif (_type == 'godmode') then
        TOX.BanPlayerWithReason(source, _U('ban_type_godmode'))
    elseif (_type == 'injection') then
        TOX.BanPlayerWithReason(source, _U('ban_type_injection'))
    elseif (_type == 'blacklisted_weapon') then
        TOX.BanPlayerWithReason(source, _U('ban_type_blacklisted_weapon', _item))
    elseif (_type == 'blacklisted_key') then
        TOX.BanPlayerWithReason(source, _U('ban_type_blacklisted_key', _item))
    elseif (_type == 'hash') then
        TOX.BanPlayerWithReason(source, _U('ban_type_hash'))
    elseif (_type == 'esx_shared') then
        TOX.BanPlayerWithReason(source, _U('ban_type_esx_shared'))
    elseif (_type == 'superjump') then
        TOX.BanPlayerWithReason(source, _U('ban_type_superjump'))
    elseif (_type == 'event') then
        TOX.BanPlayerByEvent(source, _item)
    end
end)

TOX.RegisterServerEvent('toxicanticheat:playerResourceStarted', function(source)
    if (TOX.StartedPlayers ~= nil and TOX.StartedPlayers[tostring(source)] ~= nil and TOX.StartedPlayers[tostring(source)]) then
        TOX.BanPlayerWithReason(source, _U('lua_executor_found'))
    end

    if (TOX.StartedPlayers[tostring(source)] == nil) then
        TOX.StartedPlayers[tostring(source)] = {
            lastResponse = os.time(os.date("!*t")),
            numberOfTimesFailed = 0
        }
    end
end)

TOX.RegisterServerEvent('toxicanticheat:logToConsole', function(source, message)
    print(message)
end)
