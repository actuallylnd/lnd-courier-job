ESX = nil
ESX = exports["es_extended"]:getSharedObject()

local function generateNewToken()
    return math.random(100000, 999999)
end

local serverToken = generateNewToken()

RegisterNetEvent('lnd-courier:sellpackage', Config.AmountSell)
AddEventHandler('lnd-courier:sellpackage', function(receivedToken)

    receivedToken = serverToken
    local src = source

    if exports.ox_inventory:CanCarryItem(source, 'money') then
        exports.ox_inventory:AddItem(source, 'money', Config.AmountSell)
    end

        if serverToken == receivedToken then
            twitterWood("Authorization for: " .. GetPlayerName(src))
            serverToken = generateNewToken()
        else
            twitterWood("No Authorization for:" .. GetPlayerName(src))
            serverToken = generateNewToken()
            DropPlayer(src, 'Invalid token')
        end
        twitterWood("A new token has been generated: " .. serverToken)
end)



RegisterNetEvent('lnd-courier:cartake')
AddEventHandler('lnd-courier:cartake', function ()
    exports.ox_inventory:RemoveItem(source, 'money', Config.CarTake, false)
end)

RegisterNetEvent('lnd-courier:moneyrefund')
AddEventHandler('lnd-courier:moneyrefund', function ()

    receivedToken = serverToken
    local src = source

    if exports.ox_inventory:CanCarryItem(source, 'money') then
        exports.ox_inventory:AddItem(source, 'money', Config.AmountSell)
    end

        if serverToken == receivedToken then
            twitterWood("Authorization for: " .. GetPlayerName(src))
            serverToken = generateNewToken()
        else
            twitterWood("No Authorization for:" .. GetPlayerName(src))
            serverToken = generateNewToken()
            DropPlayer(src, 'Invalid token')
        end
        twitterWood("A new token has been generated: " .. serverToken)
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
