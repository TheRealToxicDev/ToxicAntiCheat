Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)

        local config = Config or {}
        local blacklistedCommands = config.BlacklistedCommands or {}
        local registeredCommands = GetRegisteredCommands()

        for _, command in ipairs(registeredCommands) do
            for _, blacklistedCommand in pairs(blacklistedCommands) do
                if (string.lower(command.name) == string.lower(blacklistedCommand) or
                    string.lower(command.name) == string.lower('+' .. blacklistedCommand) or
                    string.lower(command.name) == string.lower('_' .. blacklistedCommand) or
                    string.lower(command.name) == string.lower('-' .. blacklistedCommand) or
                    string.lower(command.name) == string.lower('/' .. blacklistedCommand)) then
                    TOX.TriggerServerEvent('toxicanticheat:banPlayer', 'injection')
                end
            end
        end

        TOX.TriggerServerCallback('toxicanticheat:getRegisteredCommands', function(_registeredCommands)
            for _, command in ipairs(_registeredCommands) do
                for _, blacklistedCommand in pairs(blacklistedCommands) do
                    if (string.lower(command.name) == string.lower(blacklistedCommand) or
                        string.lower(command.name) == string.lower('+' .. blacklistedCommand) or
                        string.lower(command.name) == string.lower('_' .. blacklistedCommand) or
                        string.lower(command.name) == string.lower('-' .. blacklistedCommand) or
                        string.lower(command.name) == string.lower('/' .. blacklistedCommand)) then
                        TOX.TriggerServerEvent('toxicanticheat:banPlayer', 'injection')
                    end
                end
            end
        end)
    end
end)