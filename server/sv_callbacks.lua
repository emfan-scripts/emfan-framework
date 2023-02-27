

CreateThread(function()
    Wait(100)

    emfan.createCallback('emfan-framework:cb:getAllJobs', function(source, cb)
        local allJobs = MySQL.Sync.fetchAll('SELECT name FROM jobs', {})
        cb(allJobs)
    end)

    emfan.createCallback('emfan-framework:cb:getAllSettings', function(source, cb)
        local Player = ESX.GetPlayerFromId(source)
        local fetchJobs = MySQL.Sync.fetchAll('SELECT name from jobs', {})
        local fetchVehicles = MySQL.Sync.fetchAll('SELECT * from vehicles', {})

        local jobs = {}
        local vehicles = {}
        local identifier = ESX.GetPlayerFromId(source).identifier
        local count = 1
        identifier = string.gsub(identifier, 'license', "char" .. count)

        local playerGrab = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = ?', {identifier})
        playerGrab = playerGrab[1]
        local playerData = ESX.GetPlayerFromId(source)
        playerData.charinfo = {
            firstname = playerGrab.firstname,
            lastname = playerGrab.lastname,
            phone = playerGrab.phone_number,
            money = {
                cash = Player.getMoney('money'),
                bank = Player.getAccount('bank').money
            }
        }
        local playerMoney = {
            ['bank'] = Player.getAccount('bank').money,
            ['cash'] = Player.getMoney('money')
        }

        for k, v in pairs(fetchJobs) do
            jobs[v.name] = v.name
        end
        for k, v in pairs(fetchVehicles) do
            vehicles[v.model] = v
        end

        cb(jobs, vehicles, playerData, playerMoney)
    end)

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
        cb(NetworkGetNetworkIdFromEntity(veh), vehicle)
    end)
end)