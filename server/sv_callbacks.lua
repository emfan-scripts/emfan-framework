emfan.createCallback('emfan-framework:esx:getBankMoney', function(source, cb)
    local Player = emfan.getPlayer(source)
    cb(Player.getAccount("bank").money)
end)

emfan.createCallback('emfan-framework:cb:getAllVehicles', function(source, cb)
    cb(getServerVehicles())
end)

emfan.createCallback('emfan-framework:cb:getAllJobs', function(source, cb)
    local allJobs = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})
end)