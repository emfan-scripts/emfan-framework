CreateThread(function()
    Wait(100)
emfan.createCallback('emfan-framework:cb:getAllVehicles', function(source, cb)
    local allVehicles = MySQL.Sync.fetchAll('SELECT * FROM vehicles', {})
    for k, v in pairs(allVehicles) do
        print("kv", k, v)
    end
    cb(allVehicles)
end)
end)