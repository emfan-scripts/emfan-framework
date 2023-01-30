emfan = {}

if Config.Framework == 'qb-core' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'esx' then 
    ESX = exports['es_extended']:getSharedObject()
end

local PlayerData = {}
local allVehicles = {}

CreateThread(function()
    Wait(150)
    emfan.callback('emfan-framework:cb:getPlayerData', function(data)
        PlayerData = data
    end)

    emfan.callback('emfan-framework:cb:getAllVehicles', function(data)
        allVehicles = data
    end)
end)

CreateThread(function()
    Wait(100)
    

    function emfan.callback(eventName, cb, ...)
        emfan.clientCallbacks[eventName] = cb
        TriggerServerEvent('emfan-framework:server:callback', eventName, ...)
    end

    function emfan.notify(message, notifyType, time)
        if Framework == 'qb-core' then
            return QBCore.Functions.Notify(message, notifyType, time)
        elseif Framwork == 'esx' then
            return ESX.ShowNotification(message, "primary", time)
        end
    end

    function emfan.getPlayer()
        if Framework == 'qb-core' then
            return QBCore.Functions.GetPlayerData()
        elseif Framework == 'esx' then
            return PlayerData
        end
    end

    function emfan.getCid()
        if Framework == 'qb-core' then
            return QBCore.Functions.GetPlayerData().citizenid
        elseif Framework == 'esx' then
            emfan.callback('emfan-framework:cb:getCid', function(citizenid)
                return citizenid
            end)
        end
    end

    function emfan.getAllJobs()
        if Framework == 'qb-core' then
            return QBCore.Shared.Jobs
        elseif Framwork == 'esx' then
            return emfan.callback('emfan-framework:cb:getAllJobs')
        end
    end

    function emfan.getJob()
        if Framework == 'qb-core' then
            return QBCore.Functions.GetPlayerData().job.name
        elseif Framework == 'esx' then
            local Player = ESX.GetPlayerData()
            return Player.job.name
        end
    end

    function emfan.getIsBoss()
        if Framework == 'qb-core' then
            return QBCore.Functions.GetPlayerData().job.isboss
        elseif Framework == 'esx' then
            local Player = ESX.GetPlayerData()
            return Player.job.name
        end
    end

    function emfan.getAllVehicles()
        if Framework == 'qb-core' then
            return QBCore.Shared.Vehicles
        elseif Framework == 'esx' then
            print("HELLOO")
            for k, v in pairs(allVehicles) do
                print("k2", k, v)
            end
            return allVehicles
        end
    end

    function emfan.getMoney(account)
        if Framework == 'qb-core' then
            return QBCore.Functions.GetPlayerData().money[account]
        elseif Framework == 'esx' then
            return ESX.GetPlayerData().money[account]
        end
    end

    function emfan.WaitForLogin()
        if Framework == 'qb-core' then
            while not LocalPlayer.state.isLoggedIn do Wait(100) end
        elseif Framwork == 'esx' then
            while not ESX.PlayerLoaded do Wait(100) end
        end
    end

    function emfan.loadAnimation(anim)
        while not HasAnimDictLoaded(anim) do
            RequestAnimDict(anim)
            Wait(100)
        end
    end

    function emfan.loadModel(model)
        local hash = GetHashKey(model)
        while not HasModelLoaded(model) do 
            RequestModel(model)
            Wait(100)
        end
    end

    function emfan.getVehicleProperties(vehicle)
        if Framework == 'qb-core' then
            return QBCore.Functions.GetVehicleProperties(vehicle)
        elseif Framework == 'esx' then
            return ESX.Game.GetVehicleProperties(vehicle)
        end
    end

    function emfan.setVehicleProperties(vehicle, properties)
        if Framework == 'qb-core' then
            return QBCore.Functions.SetVehicleProperties(vehicle, properties)
        elseif Framework == 'esx' then
            return ESX.Game.SetVehicleProperties(vehicle, properties)
        end
    end

    function emfan.getClosestPlayer()
        if Framework == 'qb-core' then
            return QBCore.Functions.GetClosestPlayer()
        elseif Framework == 'esx' then
            return ESX.Game.GetClosestPlayer()
        end
    end

    function emfan.getClosestVehicle(coords)
        if Framework == 'qb-core' then
            return QBCore.Functions.GetClosestVehicle(coords)
        elseif Framework == 'esx' then
            return ESX.Game.GetClosestVehicle(coords)
        end
    end
end)