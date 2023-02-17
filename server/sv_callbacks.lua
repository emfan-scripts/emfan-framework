

CreateThread(function()
    Wait(100)
    emfan.createCallback('emfan-framework:cb:getAllVehicles', function(source, cb)
        local allVehicles = MySQL.Sync.fetchAll('SELECT * FROM vehicles', {})
        cb(allVehicles)
    end)

    emfan.createCallback('emfan-framework:cb:getCid', function(source, cb)
        cb(emfan.getCid(source))
    end)

    emfan.createCallback('emfan-framework:cb:getMoney', function(source, cb)
        cb(emfan.getMoney(source))
    end)

    emfan.createCallback('emfan-framework:cb:getPlayerData', function(source, cb)
        cb(emfan.getPlayer(source))
    end)

    emfan.createCallback('emfan-framwork:cb:spawnVehicle', function(source, cb, model, coords, warp)
        local xPlayer = GetPlayerPed(source)
        model = type(model) == 'string' and joaat(model) or model
        if not coords then 
            coords = GetEntityCoords(xPlayer) 
        end
        local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, true)
        while not DoesEntityExist(vehicle) do Wait(10) end
        if warp then
            while GetVehiclePedIsIn(xPlayer) ~= vehicle do
                Wait(10)
                TaskWarpPedIntoVehicle(xPlayer, vehicle, -1)
            end
        end
        while NetworkGetEntityOwner(vehicle) ~= source do Wait(10) end
        cb(NetworkGetNetworkIdFromEntity(veh))
    end)
end)