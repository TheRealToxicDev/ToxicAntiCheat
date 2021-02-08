TOX                         = {}
TOX.StartedPlayers          = {}
TOX.ServerCallbacks         = {}
TOX.ServerEvents            = {}
TOX.ClientCallbacks         = {}
TOX.ClientEvents            = {}
TOX.PlayerBans              = {}
TOX.BanListLoaded           = false
TOX.Config                  = {}
TOX.ConfigLoaded            = false
TOX.SecurityTokens          = {}
TOX.SecurityTokensLoaded    = false
TOX.WhitelistedIPs          = {}
TOX.WhitelistedIPsLoaded    = false
TOX.CheckedIPs              = {}
TOX.Version                 = '0.0.0'

AddEventHandler('toxicanticheat:getSharedObject', function(cb)
    cb(TOX)
end)

function getSharedObject()
    return TOX
end

RegisterServerEvent('toxicanticheat:triggerServerCallback')
AddEventHandler('toxicanticheat:triggerServerCallback', function(name, requestId, token, ...)
    local _source = source

    if (TOX.ValidateOrKick(_source, GetCurrentResourceName(), token)) then
        TOX.TriggerServerCallback(name, _source, function(...)
            TriggerClientEvent('toxicanticheat:serverCallback', _source, requestId, ...)
        end, ...)
    end
end)

RegisterServerEvent('toxicanticheat:triggerServerEvent')
AddEventHandler('toxicanticheat:triggerServerEvent', function(name, token, ...)
    local _source = source

    if (TOX.ValidateOrKick(_source, GetCurrentResourceName(), token)) then
        TOX.TriggerServerEvent(name, _source, ...)
    end
end)

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
    TOX.PlayerConnecting(source, setCallback, deferrals)
end)

TOX.GetConfigVariable = function(name, _type, _default)
    _type = _type or 'string'
    _default = _default or ''

    local value = GetConvar(name, _default) or _default

    if (string.lower(_type) == 'string') then
        return tostring(value)
    end

    if (string.lower(_type) == 'boolean' or
        string.lower(_type) == 'bool') then
        return (string.lower(value) == 'true' or value == true or tostring(value) == '1' or tonumber(value) == 1)
    end

    return value
end