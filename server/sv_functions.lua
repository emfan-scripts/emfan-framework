



-- QBCore
if Framework == 'qb-core' then
    QBCore = exports['qb-core']:GetCoreObject()
    emfan.createCallback = QBCore.Functions.CreateCallback
    emfan.getPlayer = QBCore.Functions.GetPlayer
    emfan.getPlayers = QBCore.Functions.GetPlayers

-- ESX
elseif Framework == 'esx' then 
    ESX = exports['es_extended']:getSharedObject()
    emfan.createCallback = ESX.RegisterServerCallback
    emfan.getPlayer = ESX.GetPlayerFromId
    emfan.getPlayers = ESX.GetPlayers
    --emfan.getPlayers = ESX.GetExtendedPlayers()
end

-- FUNCTIONS

function emfan.notify(source, text, notifyType, length)
    if Framework == 'qb-core' then
        TriggerClientEvent('QBCore:Notify', source, text, notifyType, time)
    elseif Framework == 'esx' then
        local Player = ESX.GetPlayerFromId(source)
        Player.showNotification(text, notifyType, time)
    end
end

function emfan.addMoney(source, account, amount)
    if Framework == 'qb-core' then
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.AddMoney(account, amount)
    elseif Framework == 'esx' then
        local Player = ESX.GetPlayerFromId(source)
        ESX.addMoney(account, amount)
    end
end

function emfan.removeMoney(source, account, amount)
    if Framework == 'qb-core' then
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.RemoveMoney(account, amount)
    elseif Framework == 'esx' then
        local Player = ESX.GetPlayerFromId(source)
        Player.removeMoney(account, amount)
    end
end

function emfan.getMoney(source, account)
    if Framework == 'qb-core' then
        local Player = QBCore.Functions.GetPlayer(source)
        return Player.Functions.GetMoney(account)
    elseif Framework == 'esx' then
        local Player = ESX.GetPlayerFromId(source)
        return Player.getMoney(account)
    end
end

function emfan.getJob(source)
    if Framework == 'qb-core' then
        return QBCore.Functions.GetPlayer(source).PlayerData.job.name
    elseif Framework == 'esx' then
<<<<<<< HEAD
        local Player = ESX.GetPlayerFromId(source)
        return Player.job.name
=======
        return ESX.GetPlayerFromId(source).PlayerData.job.name
>>>>>>> eeba89a8ad9ba8e09515a82de12c0c8e3d30bfb6
    end
end

function emfan.addJobMoney(job, amount)
    if Framework == 'qb-core' then
        exports['qb-management']:AddMoney(job, amount)
    elseif Framework == 'esx' then
        job = "society_" .. job
        local preMoney = MySQL.Sync.fetchScalar('SELECT money FROM addon_account_data WHERE account_name = ?', {job})
        MySQL.Async.execute('UPDATE addon_account_data SET money = ? WHERE account_name = ?', {amount+preMoney, job})
    end
end

function emfan.removeJobMoney(job, amount)
    if Framework == 'qb-core' then
        exports['qb-management']:RemoveMoney(job, amount)
    elseif Framework == 'esx' then
        job = "society_" .. job
        local preMoney = MySQL.Sync.fetchScalar('SELECT money FROM addon_account_data WHERE account_name = ?', {job})
        MySQL.Async.execute('UPDATE addon_account_data SET money = ? WHERE account_name = ?', {amount-preMoney, job})
    end
end

function emfan.getJobMoney(job)
    if Framework == 'qb-core' then
        return exports['qb-management']:GetAccount(job)
    elseif Framework == 'esx' then
        job = "society_" .. job
        return MySQL.Sync.fetchScalar('SELECT money FROM addon_account_data WHERE account_name = ?', {job})
    end
end

function emfan.getCid(source)
    if Framework == 'qb-core' then
        return QBCore.Functions.GetPlayer(source).PlayerData.citizenid
    elseif Framework == 'esx' then
        return GetPlayerIdentifier(source)
    end
end

function emfan.getAllVehicles()
    if Framework == 'qb-core' then
        return QBCore.Shared.Vehicles
    elseif Framework == 'esx' then
        return getServerVehicles()
    end
end

function getServerVehicles()
    local result = MySQL.Sync.fetchAll('SELECT * FROM vehicles', {})
    local allVehicles = {}
    for k, v in pairs(result) do
        allVehicles[v.model] = v
    end
    return allVehicles
end



-- CALLBACKS
CreateThread(function()
    Wait(1000)
    emfan.createCallback('emfan-framework:cb:getAllVehicles', function(source, cb)
        cb(getServerVehicles())
    end)

    emfan.createCallback('emfan-framework:cb:getAllJobs', function(source, cb)
        local allJobs = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})
    end)
end)