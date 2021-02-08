TOX.LoadSecurityTokens = function()
    local tokenContent = LoadResourceFile(GetCurrentResourceName(), 'data/token.json')

    if (not tokenContent) then
        local newTokenList = json.encode({})

        tokenContent = newTokenList

        SaveResourceFile(GetCurrentResourceName(), 'data/token.json', newTokenList, -1)
    end

    local storedTokens = json.decode(tokenContent)

    if (not storedTokens) then
        print('-------------------!' .. _('fatal_error') .. '!------------------\n')
        print(_('failed_to_load_tokenlist') .. '\n')
        print(_('failed_to_load_check') .. '\n')
        print('-------------------!' .. _('fatal_error') .. '!------------------\n')

        TOX.SecurityTokens = {}
    else
        TOX.SecurityTokens = storedTokens
    end

    TOX.SecurityTokensLoaded = true
end

TOX.SaveSecurityTokens = function()
    SaveResourceFile(GetCurrentResourceName(), 'data/token.json', json.encode(TOX.SecurityTokens or {}, { indent = true }), -1)
end

TOX.GetSteamIdentifier = function(source)
    if (source == nil) then
        return ''
    end

    local playerId = tonumber(source)

    if (playerId <= 0) then
        return ''
    end

    local identifiers, steamIdentifier = GetPlayerIdentifiers(source)

    for _, identifier in pairs(identifiers) do
        if (string.match(string.lower(identifier), 'steam:')) then
            steamIdentifier = identifier
        end
    end

    return steamIdentifier
end

TOX.GetClientSecurityToken = function(source, resource)
    if (TOX.SecurityTokens ~= nil and TOX.SecurityTokens[tostring(source)] ~= nil) then
        local steamIdentifier = TOX.GetSteamIdentifier(source)

        for _, resourceToken in pairs(TOX.SecurityTokens[tostring(source)]) do
            if (resourceToken.name == resource and resourceToken.steam == steamIdentifier) then
                return resourceToken
            elseif (resourceToken.name == resource) then
                table.remove(TOX.SecurityTokens[tostring(source)], _)
            end
        end
    end

    return nil
end

TOX.GenerateSecurityToken = function(source, resource)
    local currentToken = TOX.GetClientSecurityToken(source, resource)

    if (currentToken == nil) then
        local newResourceToken = {
            name = resource,
            token = TOX.RandomString(Config.TokenLength),
            time = os.time(),
            steam = TOX.GetSteamIdentifier(source),
            shared = false
        }

        if (TOX.SecurityTokens == nil) then
            TOX.SecurityTokens = {}
        end

        if (TOX.SecurityTokens[tostring(source)] == nil) then
            TOX.SecurityTokens[tostring(source)] = {}
        end

        table.insert(TOX.SecurityTokens[tostring(source)], newResourceToken)

        TOX.SaveSecurityTokens()

        return newResourceToken
    end

    return nil
end

TOX.GetCurrentSecurityToken = function(source, resource)
    local currentToken = TOX.GetClientSecurityToken(source, resource)

    if (currentToken == nil) then
        local newToken = TOX.GenerateSecurityToken(source, resource)

        if (not newToken.shared) then
            TOX.TriggerClientEvent(source, 'toxicanticheat:storeSecurityToken', newToken)
        end

        if (newToken == nil) then
            TOX.KickPlayerWithReason(source, _U('kick_type_security_token'))
            return nil
        else
            return newToken
        end
    end

    return currentToken
end

TOX.ValidateToken = function(source, resource, token)
    local currentToken = TOX.GetCurrentSecurityToken(source, resource)

    if (currentToken == nil and token == nil) then
        return true
    elseif(currentToken ~= nil and not currentToken.shared and token == nil) then
        return true
    elseif(currentToken ~= nil and currentToken.token == token) then
        return true
    end

    return false
end

TOX.ValidateOrKick = function(source, resource, token)
    if (not TOX.ValidateToken(source, resource, token)) then
        TOX.KickPlayerWithReason(_U('kick_type_security_mismatch'))
        return false
    end

    return true
end

TOX.RegisterServerEvent('toxicanticheat:storeSecurityToken', function(source, resource)
    if (TOX.SecurityTokens ~= nil and TOX.SecurityTokens[tostring(source)] ~= nil) then
        local steamIdentifier = TOX.GetSteamIdentifier(source)

        for _, resourceToken in pairs(TOX.SecurityTokens[tostring(source)]) do
            if (resourceToken.name == resource and resourceToken.steam == steamIdentifier) then
                resourceToken.shared = true
                TOX.SecurityTokens[tostring(source)][_].shared = true
            elseif (resourceToken.name == resource) then
                table.remove(TOX.SecurityTokens[tostring(source)], _)
            end
        end

        TOX.SaveSecurityTokens()
    end
end)