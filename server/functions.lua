TOX.RegisterServerCallback = function(name, cb)
    TOX.ServerCallbacks[name] = cb
end

TOX.RegisterServerEvent = function(name, cb)
    TOX.ServerEvents[name] = cb
end

TOX.TriggerClientCallback = function(source, name, cb, ...)
    local playerId = tostring(source)

    if (TOX.ClientCallbacks == nil) then
        TOX.ClientCallbacks = {}
    end

    if (TOX.ClientCallbacks[playerId] == nil) then
        TOX.ClientCallbacks[playerId] = {}
        TOX.ClientCallbacks[playerId]['CurrentRequestId'] = 0
    end

    TOX.ClientCallbacks[playerId][tostring(TOX.ClientCallbacks[playerId]['CurrentRequestId'])] = cb

    TriggerClientEvent('toxicanticheat:triggerClientCallback', source, name, TOX.ClientCallbacks[playerId]['CurrentRequestId'], ...)

    if (TOX.ClientCallbacks[playerId]['CurrentRequestId'] < 65535) then
        TOX.ClientCallbacks[playerId]['CurrentRequestId'] = TOX.ClientCallbacks[playerId]['CurrentRequestId'] + 1
    else
        TOX.ClientCallbacks[playerId]['CurrentRequestId'] = 0
    end
end

TOX.TriggerClientEvent = function(source, name, ...)
    TriggerClientEvent('toxicanticheat:triggerClientEvent', source, name, ...)
end

TOX.TriggerServerCallback = function(name, source, cb, ...)
    if (TOX.ServerCallbacks ~= nil and TOX.ServerCallbacks[name] ~= nil) then
        TOX.ServerCallbacks[name](source, cb, ...)
    else
        print('[ToxicAntiCheat] TriggerServerCallback => ' .. _('callback_not_found', name))
    end
end

TOX.TriggerServerEvent = function(name, source, ...)
    if (TOX.ServerEvents ~= nil and TOX.ServerEvents[name] ~= nil) then
        TOX.ServerEvents[name](source, ...)
    else
        print('[ToxicAntiCheat] TriggerServerEvent => ' .. _('trigger_not_found', name))
    end
end

RegisterServerEvent('toxicanticheat:clientCallback')
AddEventHandler('toxicanticheat:clientCallback', function(requestId, ...)
    local _source = source
    local playerId = tonumber(_source)

    if (TOX.ClientCallbacks ~= nil and TOX.ClientCallbacks[playerId] ~= nil and TOX.ClientCallbacks[playerId][requestId] ~= nil) then
        TOX.ClientCallbacks[playerId][tostring(requestId)](...)
        TOX.ClientCallbacks[playerId][tostring(requestId)] = nil
    end
end)