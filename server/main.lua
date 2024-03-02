RegisterNetEvent('lnd-courier:sellpackage')
AddEventHandler('lnd-courier:sellpackage',function ()
    if exports.ox_inventory:CanCarryItem(source, 'money') then
        exports.ox_inventory:AddItem(source, 'money', Config.AmountSell)
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