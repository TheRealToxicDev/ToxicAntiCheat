TOX.Commands = {}

TOX.IsConsole = function(playerId)
    return (playerId == nil or playerId <= 0 or tostring(playerId) == '0')
end

RegisterCommand('anticheat', function(source, args, raw)
    if (not TOX.PlayerAllowed(source)) then
        TOX.Print(false, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('not_allowed', '%{red}/anticheat%{reset}'))
        return
    end

    local isConsole = TOX.IsConsole(source)

    if (args == nil or string.lower(type(args)) ~= 'table' or #args <= 0 or string.lower(tostring(args[1])) == 'help') then
        TOX.Commands['help'].func(isConsole, {})
        return
    end

    local command = string.lower(tostring(args[1]))

    for key, data in pairs(TOX.Commands) do
        if (string.lower(key) == command) then
            local param = args[2] or nil
            data.func(isConsole, param)
            return
        end
    end

    TOX.Print(isConsole, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('command') .. ' %{red}/anticheat ' .. command .. ' %{white}' .. _('command_not_found'))
end)

TOX.Commands['reload'] = {
    description = _('command_reload'),
    func = function(isConsole)
        TOX.LoadBanList()
        TOX.Print(isConsole, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('banlist_reloaded'))
    end
}

TOX.Commands['ip-reload'] = {
    description = _('ips_command_reload'),
    func = function(isConsole)
        TOX.LoadWhitelistedIPs()
        TOX.Print(isConsole, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('ips_reloaded'))
    end
}

TOX.Commands['ip-add'] = {
    description = _('ips_command_add'),
    func = function(isConsole, ip)
        if (TOX.AddIPToWhitelist(ip)) then
            TOX.Print(isConsole, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('ip_added', ip))
        else
            TOX.Print(isConsole, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('ip_invalid', ip))
        end
    end
}

TOX.Commands['total'] = {
    description = _('command_total'),
    func = function(isConsole)
        TOX.Print(isConsole, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('total_bans', #TOX.PlayerBans))
    end
}

TOX.Commands['help'] = {
    description = _('command_help'),
    func = function(isConsole)
        local string = '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('available_commands') .. '\n %{black}--------------------------------------------------------------\n'

        for command, data in pairs(TOX.Commands) do
            string = string .. '%{red}/anticheat ' .. command .. ' %{black}| %{white}' .. data.description .. '\n'
        end

        string = string .. '%{black}--------------------------------------------------------------%{reset}'

        TOX.Print(isConsole, string)
    end
}

TOX.Print = function(isConsole, string)
    if (isConsole) then
        TOX.PrintToConsole(string)
    else
        TOX.PrintToUser(string)
    end
end

TOX.PlayerAllowed = function(playerId)
    local isConsole = TOX.IsConsole(playerId)

    if (isConsole) then
        return isConsole
    end

    if (IsPlayerAceAllowed(playerId, 'toxicanticheat.commands')) then
        return true
    end

    return false
end

TOX.IgnorePlayer = function(playerId)
    local isConsole = TOX.IsConsole(playerId)

    if (isConsole) then
        return isConsole
    end

    if (not TOX.Config.BypassEnabled) then
        return false
    end

    if (IsPlayerAceAllowed(playerId, 'toxicanticheat.bypass')) then
        return true
    end

    return false
end