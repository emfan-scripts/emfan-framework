
if Config.Framework == 'qb-core' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'esx' then 
    ESX = exports['es_extended']:getSharedObject()
end

function emfan.callback()
    if Framework == 'qb-core' then
        return QBCore.Functions.TriggerCallback
    elseif Framework == 'esx' then
        return ESX.TriggerServerCallback
    end
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

-- function emfan.()
--     if Framework == 'qb-core' then

--     elseif Framwork == 'esx' then

--     end
-- end

function emfan.WaitForLogin()
    if Framework == 'qb-core' then
        while not LocalPlayer.state.isLoggedIn do Wait(100) end
    elseif Framwork == 'esx' then
        while not ESX.PlayerLoaded do Wait(100) end
    end
end
