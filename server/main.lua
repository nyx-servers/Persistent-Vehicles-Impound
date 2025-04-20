
RegisterNetEvent(config.prefix .. ":server:openMenu", function()
    local source = source

    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end

    local citizenid = Player.PlayerData.citizenid

    local vehicles = MySQL.Sync.fetchAll('SELECT * FROM `player_vehicles` WHERE `citizenid` = @citizenid', {
        ['@citizenid'] = citizenid
    })

    local retval = {}

    for k, v in pairs(vehicles) do
        local netId = exports['nyx2_persistent']:getNetID(v.plate) 
        if netId then
            if config.retrieveDamagedVehiclesOnly then
                local vehicle = NetworkGetEntityFromNetworkId(netId)
                if DoesEntityExist(vehicle) then
                    local vehicleHealth = GetVehicleEngineHealth(vehicle)
                    local vehicleDriveable = IsVehicleDriveable(vehicle, false)
                    if vehicleHealth < 100 or not vehicleDriveable then
                        retval[#retval + 1] = {
                            plate = v.plate,
                            model = v.vehicle,
                        }
                    end
                else
                    -- vehicle has despawned, assume it is damaged
                    retval[#retval + 1] = {
                        plate = v.plate,
                        model = v.vehicle,
                    }
                end
            else
                retval[#retval + 1] = {
                    plate = v.plate,
                    model = v.vehicle,
                }
            end
        end
    end

    if #retval == 0 then
        QBCore.Functions.Notify(source, 'You do not have any vehicles in the impound lot', 'error')
        return
    end

    TriggerClientEvent(config.prefix .. ":client:openMenu", source, retval)
end)

RegisterNetEvent(config.prefix .. ":server:retrieveVehicle", function(plate)
    TriggerEvent('nyx2_persistent:updateVehiclePosition', plate, config.createVehicleLocation)

    local netId = exports['nyx2_persistent']:getNetID(plate)

    local startedAt = os.time()

    while not netId do Wait(1000)
        if os.time() - startedAt > 60 then
            QBCore.Functions.Notify(source, 'Failed to retrieve vehicle from impound lot', 'error')
            return
        end

        netId = exports['nyx2_persistent']:getNetID(plate)
    end
    TriggerClientEvent(config.prefix .. ":client:repairVehicle", source, netId)
end)