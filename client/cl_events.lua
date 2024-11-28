RegisterNetEvent('emfan-framework:client:callback', function(eventName, ...)
    if emfan.serverCallbacks[eventName] then
        emfan.serverCallbacks[eventName](...)
        emfan.serverCallbacks[eventName] = nil
    end
end)

RegisterNetEvent('emfan-framework:client:displayMetadata', function(metadata)
    exports['ox_inventory']:displayMetadata(metadata)
end)
