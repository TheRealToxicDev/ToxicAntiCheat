AddEventHandler('toxicanticheat:getSharedObject', function(cb)
    cb(TOX)
end)

function getSharedObject()
    return TOX
end

RegisterNetEvent('toxicanticheat:triggerClientCallback')
AddEventHandler('toxicanticheat:triggerClientCallback', function(name, requestId, ...)
    TOX.TriggerClientCallback(name, function(...)
        TriggerServerEvent('toxicanticheat:clientCallback', requestId, ...)
    end, ...)
end)

RegisterNetEvent('toxicanticheat:triggerClientEvent')
AddEventHandler('toxicanticheat:triggerClientEvent', function(name, ...)
    TOX.TriggerClientEvent(name, ...)
end)