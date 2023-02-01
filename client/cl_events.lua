RegisterNetEvent('emfan-framework:client:callback', function(eventName, ...)
    if emfan.serverCallbacks[eventName] then
        emfan.serverCallbacks[eventName](...)
        emfan.serverCallbacks[eventName] = nil
    end
end)