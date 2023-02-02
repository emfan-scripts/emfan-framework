Framework = Config.Framework

if Framework == 'qb-core' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Framework == 'esx' then 
    ESX = exports['es_extended']:getSharedObject()
end

function setupPlateNumber()
    local plate = emfan.getRandomStr(3) .. " " .. emfan.getRandomInt(2) .. emfan.getRandomStr(1)
    return plate
end

