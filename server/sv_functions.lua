
if Framework == 'qb-core' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Framework == 'esx' then 
    ESX = exports['es_extended']:getSharedObject()
end

function emfan.createCallback()
    if Framework == 'qb-core' then
        return QBCore.Functions.CreateCallback
    elseif Framework == 'esx' then
        return ESX.RegisterServerCallback
    end
end

function emfan.getPlayer()
    if Framework == 'qb-core' then
        return QBCore.Functions.GetPlayer
    elseif Framework == 'esx' then
        return ESX.GetPlayerFromId
    end
end

function emfan.getPlayers()
    if Framework == 'qb-core' then
        return QBCore.Functions.GetPlayers
    elseif Framework == 'esx' then
        return ESX.GetPlayers
        --emfan.getPlayers = ESX.GetExtendedPlayers()
    end
end

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
        return ESX.GetPlayerFromId(source)job.name
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

-- function emfan.()
--     if Framework == 'qb-core' then

--     elseif Framework == 'esx' then

--     end
-- end
