Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        if (not TOX.Config.HasBypass) then
            local config = TOX.Config or {}
            local blacklistedWeapons = config.BlacklistedWeapons or {}
            local playerPed = GetPlayerPed(-1)

            for blacklistedWeaponName, blacklistedWeaponHash in pairs(blacklistedWeapons) do
                Citizen.Wait(10)

                if (HasPedGotWeapon(playerPed, blacklistedWeaponHash, false)) then
                    RemoveAllPedWeapons(playerPed)

                    Citizen.Wait(250)

                    TOX.TriggerServerEvent('toxicanticheat:banPlayer', 'blacklisted_weapon', blacklistedWeaponName)
                end
            end
        end
    end
end)