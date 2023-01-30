RegisterNetEvent('emfan-framework:server:callback', function(eventName, ...)
    local src = source
    emfan.callback(eventName, src, function(...)
        TriggerClientEvent('emfan-framework:client:callback', src, eventName, ...)
    end, ...)
end)