ESX = nil
ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('lnd-courier:sellpackage', Config.AmountSell)
AddEventHandler('lnd-courier:sellpackage', function(totality)
    local src = source
    local player = ESX.GetPlayerFromId(src)

    if player and exports.ox_inventory:CanCarryItem(source, 'money') then
        if totality > Config.AmountSell then
            twitterWood(player.name .. ' made more money than is implemented in config ' .. totality ' $')
        else
            --[[YOU CAN DELETE ELSE IF U WANT ]]
            exports.ox_inventory:AddItem(source, 'money', Config.AmountSell)
            twitterWood(player.name .. ' made as much money as implemented in config ' .. Config.AmountSell ..' $')
        end
    end
end)


RegisterNetEvent('lnd-courier:cartake')
AddEventHandler('lnd-courier:cartake', function ()
    exports.ox_inventory:RemoveItem(source, 'money', Config.CarTake, false)
end)

RegisterNetEvent('lnd-courier:moneyrefund')
AddEventHandler('lnd-courier:moneyrefund', function ()
    if exports.ox_inventory:CanCarryItem(source, 'money') then
        exports.ox_inventory:AddItem(source, 'money',Config.CarRefund)
    end
end)


twitter = {
    ['twittericon'] = 'https://discord.com/api/webhooks/1213634329293496430/Tof9U8FD7Vz9wnI4UG5xTZ2laEHege6Na3nbQQRYEQ4gQwhq0gNMyg8lWLr59ZwXIfb4', --[[DISCORD WEBHOOK LINK]]
    ['name'] = 'Courier',
    ['image'] = 'https://cdn.discordapp.com/attachments/1166695681679966298/1213641460725977109/wodka.png?ex=65f636b0&is=65e3c1b0&hm=e9e474c56317879ce63482dae28065b04a2aa72ba5b74b55062ed7f044967e24&'
}

function twitterWood(name, message)
    local data = {
        {
            ["color"] = '3553600',
            ["title"] = "**".. name .."**",
            ["description"] = message,
        }
    }
    PerformHttpRequest(twitter['twittericon'], function(err, text, headers) end, 'POST', json.encode({username = twitter['name'], embeds = data, avatar_url = twitter['image']}), { ['Content-Type'] = 'application/json' })
end
