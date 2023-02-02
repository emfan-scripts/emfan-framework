

CreateThread(function()
    Wait(100)
    emfan.createCallback('emfan-framework:cb:getAllVehicles', function(source, cb)
        local allVehicles = MySQL.Sync.fetchAll('SELECT * FROM vehicles', {})
        cb(allVehicles)
    end)

    emfan.createCallback('emfan-framework:cb:getPlayerData', function(source, cb)
        cb(emfan.getPlayer(source))
    end)

    emfan.createCallback('emfan-framework:cb:getCid', function(source, cb)
        cb(emfan.getCid(source))
    end)

    emfan.createCallback('emfan-framework:cb:getMoney', function(source, cb)
        cb(emfan.getMoney(source))
    end)
end)