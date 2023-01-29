emfan = {}

if Config.Framework == 'qb-core' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'esx' then 
    ESX = exports['es_extended']:getSharedObject()
end

CreateThread(function()
    Wait(1000)
    function emfan.callback(eventName, cb, ...)
        emfan.clientCallbacks[eventName] = cb
        TriggerServerEvent('emfan-framework:server:callback', eventName, ...)
        
    end

    function emfan.notify()
        if Framework == 'qb-core' then
            return QBCore.Functions.Notify
        elseif Framwork == 'esx' then
            return ESX.ShowNotification
        end
    end

    function emfan.getPlayer()
        if Framework == 'qb-core' then
            return QBCore.Functions.GetPlayerData
        elseif Framwork == 'esx' then
            local data = ESX.GetPlayerData()
            emfan.callback('emfan-framework:esx:getBankMoney', function(amount)
                local cash = data.money
                data.money = {}
                data.money.cash = cash
                data.money.bank = amount
                return data
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

    function emfan.getAllVehicles()
        if Framework == 'qb-core' then
            return QBCore.Shared.Vehicles
        elseif Framwork == 'esx' then
            emfan.callback('emfan-framework:cb:getAllVehicles', function(allVehicles)
                return allVehicles
            end)
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

end)