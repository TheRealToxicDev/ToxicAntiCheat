TOX.RegisterClientEvent('toxicanticheat:storeSecurityToken', function(newToken)
    if (TOX.SecurityTokens == nil) then
        TOX.SecurityTokens = {}
    end

    TOX.SecurityTokens[newToken.name] = newToken

    TOX.TriggerServerEvent('toxicanticheat:storeSecurityToken', newToken.name)
end)

TOX.GetResourceToken = function(resource)
    if (resource ~= nil) then
        local securityTokens = TOX.SecurityTokens or {}
        local resourceToken = securityTokens[resource] or {}
        local token = resourceToken.token or nil

        return token
    end

    return nil
end