emfan = {}
emfan.serverCallbacks = {}
Framework = Config.Framework

if Framework == 'qb-core' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Framework == 'esx' then 
    ESX = exports['es_extended']:getSharedObject()
end

    
function emfan.addItem(source, item, amount, metadata)
    if Framework == 'qb-core' then
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.AddItem(item, amount, false, metadata)
    elseif Framework == 'esx' then
        local Player = ESX.GetPlayerFromId(source)
        Player.addInventoryItem(item, amount, metadata)
    end
end

function emfan.addJobMoney(job, amount)
    if Framework == 'qb-core' then
        exports['qb-management']:AddMoney(job, amount)
    elseif Framework == 'esx' then
        job = "society_" .. job
        local preMoney = MySQL.Sync.fetchScalar('SELECT money FROM addon_account_data WHERE account_name = ?', {job})
        MySQL.Async.execute('UPDATE addon_account_data SET money = ? WHERE account_name = ?', {preMoney+amount, job})
    end
end

function emfan.addMoney(source, account, amount, note)
    if Framework == 'qb-core' then
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.AddMoney(account, amount)
    elseif Framework == 'esx' then
        local Player = ESX.GetPlayerFromId(source)
        Player.addAccountMoney(account, amount, note)
    end
end

function emfan.callback(eventName, source, cb, ...) 
    if not emfan.serverCallbacks[eventName] then return end
    emfan.serverCallbacks[eventName](source, cb, ...)
end

function emfan.createCallback(eventName, cb)
    emfan.serverCallbacks[eventName] = cb
end

function emfan.createUseableItem(item, ...)
    if Framework == 'qb-core' then
        QBCore.Functions.CreateUseableItem(item, ...)
    elseif Framework == 'esx' then
        ESX.RegisterUsableItem(item, ...    )
    end
end

function emfan.getCid(source)
    if Framework == 'qb-core' then
        return QBCore.Functions.GetPlayer(source).PlayerData.citizenid
    elseif Framework == 'esx' then
        local Player = ESX.GetPlayerFromId(source)
        return Player.identifier
    end
end

function emfan.getAllJobs()
    if Framework == 'qb-core' then
        return QBCore.Shared.Jobs
    elseif Framework == 'esx' then
        return MySQL.Sync.fetchAll('SELECT * FROM jobs', {})
    end
end

function emfan.getAllVehicles()
    if Framework == 'qb-core' then
        print("HFKHDKJ SYNS")
        return QBCore.Shared.Vehicles
    elseif Framework == 'esx' then
        return getAllVehicles()
    end
end

function emfan.getJob(source)
    if Framework == 'qb-core' then
        return QBCore.Functions.GetPlayer(source).PlayerData.job.name
    elseif Framework == 'esx' then
        local Player = ESX.GetPlayerFromId(source)
        return Player.job.name
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

function emfan.getMoney(source, account)
    if Framework == 'qb-core' then
        local Player = QBCore.Functions.GetPlayer(source)
        return Player.Functions.GetMoney(account)
    elseif Framework == 'esx' then
        local Player = ESX.GetPlayerFromId(source)
        return Player.getMoney(account)
    end
end

function emfan.getPlayer(src)
    if Framework == 'qb-core' then
        return QBCore.Functions.GetPlayer(src)
    elseif Framework == 'esx' then
        local identifier = ESX.GetPlayerFromId(src).identifier
        local count = 1
        identifier = string.gsub(identifier, 'license', "char" .. count)
        local playerGrab = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = ?', {identifier})
        playerGrab = playerGrab[1]
        local PlayerData = ESX.GetPlayerFromId(src)
        PlayerData.charinfo = {
            firstname = playerGrab.firstname,
            lastname = playerGrab.lastname,
            phone = playerGrab.phone_number,
            money = {
                cash = PlayerData.accounts.money,
                bank = PlayerData.accounts.bank
            }
        }
        return PlayerData
    end
end

function emfan.getPlayers()
    if Framework == 'qb-core' then
        return QBCore.Functions.GetPlayers()
    elseif Framework == 'esx' then
        return ESX.GetPlayers
        --emfan.getPlayers = ESX.GetExtendedPlayers()
    end
end

function emfan.hasItem(source, item)
    if Framework == 'qb-core' then
        local Player = QBCore.Functions.GetPlayer(source)
        return Player.Functions.GetItemByName(item)
    elseif Framework == 'esx' then
        return exports.ox_inventory:Search(source, 'slots', item)
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

function emfan.removeItem(source, item, amount, slot)
    if Framework == 'qb-core' then
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.RemoveItem(item, amount, slot)
    elseif Framework == 'esx' then
        local Player = ESX.GetPlayerFromId(source)
        Player.removeInventoryItem(item, amount)
    end
end

function emfan.removeJobMoney(job, amount)
    if Framework == 'qb-core' then
        exports['qb-management']:RemoveMoney(job, amount)
    elseif Framework == 'esx' then
        job = "society_" .. job
        local preMoney = MySQL.Sync.fetchScalar('SELECT money FROM addon_account_data WHERE account_name = ?', {job})
        MySQL.Async.execute('UPDATE addon_account_data SET money = ? WHERE account_name = ?', {preMoney-amount, job})
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



function getBankMoney(source, cb)
    local Player = emfan.getPlayer(source)
    return Player.getAccount("bank").money
end

function getAllVehicles()
    local result = MySQL.Sync.fetchAll('SELECT * FROM vehicles', {})
    local allVehicles = {}
    for k, v in pairs(result) do
        allVehicles[v.model] = v
    end
    return allVehicles
end