emfan = {}
emfan.serverCallbacks = {}

if Config.Framework == 'qb-core' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'esx' then 
    ESX = exports['es_extended']:getSharedObject()
end

local PlayerData = {}
local PlayerMoney = {}
local allVehicles = {}
local allJobs = {}
local allJobLabels = {}

CreateThread(function()
    emfan.waitForLogin()
    Wait(100)
    if Framework == 'esx' then
        emfan.callback('emfan-framework:cb:getAllSettings', function(jobs, vehicles, playerdata, playerMoney, jobLabels)
            allJobs = jobs
            allVehicles = vehicles
            PlayerData = playerdata
            PlayerMoney = playerMoney
            allJobLabels = jobLabels
        end)
    end
end)
    
function emfan.callback(eventName, cb, ...)
    emfan.serverCallbacks[eventName] = cb
    TriggerServerEvent('emfan-framework:server:callback', eventName, ...)
end

function emfan.getAllJobLabels()
    if Framework == 'qb-core' then
        local allJobs = QBCore.Shared.Jobs
        local jobLabels = {}
        for k, v in pairs(allJobs) do
            jobLabels[k] = v.label
        end
        return jobLabels
    elseif Framework == 'esx' then
        return allJobLabels
    end
end

function emfan.getAllJobs()
    if Framework == 'qb-core' then
        return QBCore.Shared.Jobs
    elseif Framework == 'esx' then
        return allJobs
    end
end

function emfan.getAllVehicleCategories()
    if Framework == 'qb-core' then
        allVehicles = QBCore.Shared.Vehicles
    end
    local allCategories = {}
    for _, v in pairs(allVehicles) do
        local alreadyAdded = false
        for _, value in pairs(allCategories) do
            if value == v.category then
                alreadyAdded = true
            end
        end
        if alreadyAdded == false then
            allCategories[#allCategories+1] = v.category
        end
    end
    return allCategories
end

function emfan.getAllVehicles()
    if Framework == 'qb-core' then
        return QBCore.Shared.Vehicles
    elseif Framework == 'esx' then 
        return allVehicles
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

function emfan.getIsBoss()
    if Framework == 'qb-core' then
        return QBCore.Functions.GetPlayerData().job.isboss
    elseif Framework == 'esx' then
        local Player = ESX.GetPlayerData()
        return Player.job.name
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

function emfan.getMoney(account)
    if Framework == 'qb-core' then
        return QBCore.Functions.GetPlayerData().money[account]
    elseif Framework == 'esx' then
        return PlayerMoney[account]
    end
end

function emfan.getPlayer()
    if Framework == 'qb-core' then
        return QBCore.Functions.GetPlayerData()
    elseif Framework == 'esx' then
        return PlayerData
    end
end

function emfan.getVehicleModel(vehicle)
    return GetEntityArchetypeName(vehicle)
end

function emfan.getVehicleProperties(vehicle)
    if Framework == 'qb-core' then
        return QBCore.Functions.GetVehicleProperties(vehicle)
    elseif Framework == 'esx' then
        return ESX.Game.GetVehicleProperties(vehicle)
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

function emfan.notify(message, notifyType, time)
    if Framework == 'qb-core' then
        return QBCore.Functions.Notify(message, notifyType, time)
    elseif Framework == 'esx' then
        return ESX.ShowNotification(message, true, false, time)
    end
end

function emfan.progressbar(name, label, duration, useWhileDead, canCancel, controlDisables, animation, prop, propTwo, onFinish, onCancel)
    if GetResourceState('progressbar') ~= 'started' then
        print("You need the progressbar resource to be able to use progressbars")
    end
    exports['progressbar']:Progress({
        name = name,
        duration = duration,
        label = label,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        controlDisables = controlDisables,
        animation = animation,
        prop = prop,
        propTwo = propTwo,
    }, function(cancelled)
        if not cancelled then
            if onFinish then 
                onFinish()
            end
        else
            if onCancel then
                onCancel()
            end
        end
    end)
end

function emfan.setVehicleOwner(plate, vehicle)
    if Framework == 'qb-core' then
        if Config.VehicleKeySystem == 'default' or Config.VehicleKeySystem == 'emfan' or Config.VehicleKeySystem == false then
            TriggerEvent('vehiclekeys:client:SetOwner', plate, vehicle)
        elseif Config.VehicleKeySystem == 'nerv' then
            TriggerServerEvent('nerv-vehiclekey:server:needKey', plate, vehicle)
        elseif Config.VehicleKeySystem == 'cd_garage' then
            TriggerEvent('cd_garage:AddKeys', exports['cd_garage']:GetPlate(vehicle))
        end
    elseif Framework == 'esx' then
    -- Add emfan-vehiclekeys when its done for ESX
    end
end

function emfan.setVehicleProperties(vehicle, properties)
    if Framework == 'qb-core' then
        return QBCore.Functions.SetVehicleProperties(vehicle, properties)
    elseif Framework == 'esx' then
        return ESX.Game.SetVehicleProperties(vehicle, properties)
    end
end

function emfan.spawnVehicle(model, coords, warp)
    emfan.callback('emfan-framwork:cb:spawnVehicle', function(netId)
        return netId
    end, model, coords, warp)
end

function emfan.waitForLogin()
    if Framework == 'qb-core' then
        while not LocalPlayer.state.isLoggedIn do Wait(100) end
        Wait(1000)
        return
    elseif Framework == 'esx' then
        local orgPos, secondPos, confirmedPos = GetEntityCoords(PlayerPedId())
        local playerLoaded = false
        while not playerLoaded do 
            Wait(100)
            local xPlayer = PlayerPedId()
            secondPos = GetEntityCoords(xPlayer)
            if orgPos ~= secondPos then
                Wait(1000)
                secondPos = GetEntityCoords(xPlayer)
                Wait(1000)
                confirmedPos = GetEntityCoords(xPlayer)
                if secondPos ~= confirmedPos then
                    playerLoaded = true
                else
                    Wait(100)
                    orgPos = secondPos
                end
            end
        end
        Wait(1000)
        return
    end
end
