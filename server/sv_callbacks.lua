emfan.createCallback('emfan-framework:esx:getBankMoney', function(source, cb)
    local Player = emfan.getPlayer(source)
    cb(Player.getAccount("bank").money)
end)