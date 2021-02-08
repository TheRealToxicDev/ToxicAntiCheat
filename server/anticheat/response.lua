local CheckIfClientResourceIsRunningTriggerd = false

TOX.RegisterServerEvent('toxicanticheat:stillAlive', function(source)
    if (TOX.StartedPlayers[tostring(source)] == nil) then
        TOX.StartedPlayers[tostring(source)] = {
            lastResponse = os.time(os.date("!*t")),
            numberOfTimesFailed = 0
        }
    end

    TOX.StartedPlayers[tostring(source)].lastResponse = os.time(os.date("!*t"))
end)

Citizen.CreateThread(function()
    Citizen.Wait(5000)

    if (not CheckIfClientResourceIsRunningTriggerd) then
        CheckIfClientResourceIsRunning()
        CheckIfClientResourceIsRunningTriggerd = true
    end
end)

RegisterServerEvent('es:firstJoinProper')
AddEventHandler('es:firstJoinProper', function()
    local _source = source

    if (TOX.StartedPlayers[tostring(_source)] == nil) then
        TOX.StartedPlayers[tostring(_source)] = {
            lastResponse = os.time(os.date("!*t")),
            numberOfTimesFailed = 0
        }
    end
end)

function CheckIfClientResourceIsRunning()
    CheckIfClientResourceIsRunningTriggerd = true

    for _, playerId in pairs(GetPlayers()) do
        if (TOX.StartedPlayers[tostring(playerId)] == nil) then
            TOX.StartedPlayers[tostring(playerId)] = {
                lastResponse = os.time(os.date("!*t")),
                numberOfTimesFailed = 0
            }
        end
    end

    if (TOX.StartedPlayers == nil) then
        TOX.StartedPlayers = {}
    end

    for playerId, data in pairs(TOX.StartedPlayers) do
        if (playerId ~= nil and tonumber(playerId) ~= 0) then
            local banned = false

            if (TOX.StartedPlayers[playerId].numberOfTimesFailed > 5) then
                TOX.BanPlayerWithReason(tonumber(playerId), _U('ban_type_client_files_blocked'))
                banned = true
            end

            if (not banned) then
                if ((TOX.StartedPlayers[playerId].lastResponse + 100) < os.time(os.date("!*t"))) then
                    TOX.StartedPlayers[playerId].numberOfTimesFailed = TOX.StartedPlayers[playerId].numberOfTimesFailed + 1
                end

                TOX.TriggerClientCallback(tonumber(playerId), 'toxicanticheat:stillAlive', function()
                    if (TOX.StartedPlayers[playerId] ~= nil) then
                        TOX.StartedPlayers[playerId].lastResponse = os.time(os.date("!*t"))

                        if (TOX.StartedPlayers[playerId].numberOfTimesFailed > 0) then
                            TOX.StartedPlayers[playerId].numberOfTimesFailed = TOX.StartedPlayers[playerId].numberOfTimesFailed - 1
                        end
                    end
                end)
            end
        end
    end

    SetTimeout(60000, CheckIfClientResourceIsRunning)
end

RegisterServerEvent('playerDropped')
AddEventHandler('playerDropped', function()
    local _source = source

    if (TOX.StartedPlayers ~= nil and TOX.StartedPlayers[tostring(_source)] ~= nil) then
        TOX.StartedPlayers[tostring(_source)] = nil
    end
end)