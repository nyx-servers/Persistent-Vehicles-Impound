CreateThread(function()
    RequestModel(config.ped.model)
    while not HasModelLoaded(config.ped.model) do
        Wait(100)
    end

    local ped = CreatePed(0, config.ped.model, config.ped.coords.x, config.ped.coords.y, config.ped.coords.z, config.ped.heading, false, true)

    SetModelAsNoLongerNeeded(GetHashKey(config.ped.model))

    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedDiesWhenInjured(ped, false)
    SetPedCanPlayAmbientAnims(ped, true)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityHeading(ped, config.ped.coords.w)
    PlaceObjectOnGroundProperly(ped)
    if config.ped.scenario then
        TaskStartScenarioInPlace(ped, config.ped.scenario, 0, true)
    end
    if config.ped.animDict and config.ped.animName then
        RequestAnimDict(config.ped.animDict)
        while not HasAnimDictLoaded(config.ped.animDict) do
            Wait(100)
        end
        TaskPlayAnim(ped, config.ped.animDict, config.ped.animName, 8.0, -8.0, -1, 1, 0, false, false, false, false, false)
    end

    exports['qb-target']:AddTargetEntity(ped, {
        options = {
            {
                type = "server",
                event = config.prefix .. ":server:openMenu",
                icon = "fas fa-car",
                label = "Impound Lot",
                canInteract = function()
                    return true
                end,
            },
        }
    })
end)

RegisterNetEvent(config.prefix .. ":client:openMenu", function(vehicles)
    local vehicleMenu = {
        id = 'impound-vehicles',
        title = 'Impound Lot',
        options = {},
    }

    for k, v in pairs(vehicles) do
        vehicleMenu.options[#vehicleMenu.options + 1] = {
            title = v.plate .. ' - ' .. v.model,
            description = 'Select to retrieve this vehicle from the impound lot...',
            icon = 'fas fa-car',
            onSelect = function()
                TriggerServerEvent(config.prefix .. ":server:retrieveVehicle", v.plate)
            end
        }
    end

    lib.registerContext(vehicleMenu)
    lib.showContext('impound-vehicles')
end)

RegisterNetEvent(config.prefix .. ":client:repairVehicle", function(netId)
    local vehicle = NetworkGetEntityFromNetworkId(netId)

    if DoesEntityExist(vehicle) then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true, false)
        SetEntityAsMissionEntity(vehicle, true, true)
    end
end)