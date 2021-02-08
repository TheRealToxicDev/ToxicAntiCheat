TOX.ServerConfigLoaded = false

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    TOX.TriggerServerEvent('toxicanticheat:playerResourceStarted')
end)

Citizen.CreateThread(function()
    TOX.LaodServerConfig()

    Citizen.Wait(1000)

    while not TOX.ServerConfigLoaded do
        Citizen.Wait(1000)

        TOX.LaodServerConfig()
    end

    return
end)

TOX.LaodServerConfig = function()
    if (not TOX.ServerConfigLoaded) then
        TOX.TriggerServerCallback('toxicanticheat:getServerConfig', function(config)
            TOX.Config = config
            TOX.Config.BlacklistedWeapons = {}
            TOX.Config.BlacklistedVehicles = {}
            TOX.Config.HasBypass = TOX.Config.HasBypass or false

            for _, blacklistedWeapon in pairs(Config.BlacklistedWeapons) do
                TOX.Config.BlacklistedWeapons[blacklistedWeapon] = GetHashKey(blacklistedWeapon)
            end

            for _, blacklistedVehicle in pairs(Config.BlacklistedVehicles) do
                TOX.Config.BlacklistedVehicles[blacklistedVehicle] = GetHashKey(blacklistedVehicle)
            end

            TOX.ServerConfigLoaded = true
        end)
    end
end