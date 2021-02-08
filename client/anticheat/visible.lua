Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local playedPed = GetPlayerPed(-1)

        if (not IsEntityVisible(playedPed)) then
            TOX.TriggerServerEvent('toxicanticheat:banPlayer', 'visible')
        end

        if (IsPedSittingInAnyVehicle(playedPed) and IsVehicleVisible(GetVehiclePedIsIn(playedPed, 1))) then
            TOX.TriggerServerEvent('toxicanticheat:banPlayer', 'invisiblevehicle')
        end
    end
end)