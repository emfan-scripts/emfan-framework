RegisterNetEvent('emfan-framework:client:callback', function(eventName, ...)
    if emfan.clientCallbacks[eventName] then
        emfan.clientCallbacks[eventName](...)
        emfan.clientCallbacks[eventName] = nil
    end
end)