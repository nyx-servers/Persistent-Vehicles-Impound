QBCore = exports['qb-core']:GetCoreObject()

config = {}

config.debug = false

config.prefix = 'nyxpv-impound'

config.ped = {
    model = 's_m_y_cop_01',
    coords = vector4(0, 0, 0, 0), -- The coordinates of the ped. This will be set automatically when the script is started.
    heading = 0, -- The heading of the ped. This will be set automatically when the script is started.
    animDict = 'amb@prop_human_seat_chair@male@base', -- The animation dictionary of the ped. This will be set automatically when the script is started.
    animName = 'base', -- The animation name of the ped. This will be set automatically when the script is started.
}

config.retrieveDamagedVehiclesOnly = false -- If true, only damaged vehicles can be retrieved from the impound lot. If false, all vehicles can be retrieved.

config.createVehicleLocation = vector4(0, 0, 0, 0) -- The location where the vehicle will be created. This will be set automatically when the script is started.