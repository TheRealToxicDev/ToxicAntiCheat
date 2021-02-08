TOX                     = {}
TOX.CurrentRequestId    = 0
TOX.ServerCallbacks     = {}
TOX.ClientCallbacks     = {}
TOX.ClientEvents        = {}
TOX.Config              = {}
TOX.SecurityTokens      = {}

TOX.RegisterClientCallback = function(name, cb)
    TOX.ClientCallbacks[name] = cb
end

TOX.RegisterClientEvent = function(name, cb)
    TOX.ClientEvents[name] = cb
end

TOX.TriggerServerCallback = function(name, cb, ...)
    TOX.ServerCallbacks[TOX.CurrentRequestId] = cb

    local token = TOX.GetResourceToken(GetCurrentResourceName())

    TriggerServerEvent('toxicanticheat:triggerServerCallback', name, TOX.CurrentRequestId, token, ...)

    if (TOX.CurrentRequestId < 65535) then
        TOX.CurrentRequestId = TOX.CurrentRequestId + 1
    else
        TOX.CurrentRequestId = 0
    end
end

TOX.TriggerServerEvent = function(name, ...)
    local token = TOX.GetResourceToken(GetCurrentResourceName())

    TriggerServerEvent('toxicanticheat:triggerServerEvent', name, token, ...)
end

TOX.TriggerClientCallback = function(name, cb, ...)
    if (TOX.ClientCallbacks ~= nil and TOX.ClientCallbacks[name] ~= nil) then
        TOX.ClientCallbacks[name](cb, ...)
    end
end

TOX.TriggerClientEvent = function(name, ...)
    if (TOX.ClientEvents ~= nil and TOX.ClientEvents[name] ~= nil) then
        TOX.ClientEvents[name](...)
    end
end

TOX.ShowNotification = function(msg)
    AddTextEntry('TOXNotification', msg)
	SetNotificationTextEntry('TOXNotification')
	DrawNotification(false, true)
end

TOX.RequestAndDelete = function(object, deTOXh)
    if (DoesEntityExist(object)) then
        NetworkRequestControlOfEntity(object)

        while not NetworkHasControlOfEntity(object) do
            Citizen.Wait(0)
        end

        if (deTOXh) then
            DeTOXhEntity(object, 0, false)
        end

        SetEntityCollision(object, false, false)
        SetEntityAlpha(object, 0.0, true)
        SetEntityAsMissionEntity(object, true, true)
        SetEntityAsNoLongerNeeded(object)
        DeleteEntity(object)
    end
end

RegisterNetEvent('toxicanticheat:serverCallback')
AddEventHandler('toxicanticheat:serverCallback', function(requestId, ...)
	if (TOX.ServerCallbacks ~= nil and TOX.ServerCallbacks[requestId] ~= nil) then
		TOX.ServerCallbacks[requestId](...)
        TOX.ServerCallbacks[requestId] = nil
	end
end)