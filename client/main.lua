local hasSpawnedVehicle = false
local deliveryZoneId = nil
local spawnedPed = nil
local isCourier = false
local deliveryCount = 0
local isInGarage = false


ESX = nil
ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

AddEventHandler('onClientResourceStart', function(ressourceName)
    if(GetCurrentResourceName() ~= ressourceName) then
        return
    end 
    print("" ..ressourceName.." start")
end)



courierblip = AddBlipForCoord(Config.HQBlip)
SetBlipSprite(courierblip, 478)
SetBlipColour(courierblip, 3)
SetBlipScale(courierblip, 0.8)
SetBlipDisplay(courierblip,3)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString("Courier")
EndTextCommandSetBlipName(courierblip)




exports.ox_target:addBoxZone({
    coords = vec3(-438.0395, -2795.9155, 7.2959),
    size = vec3(2,2,2),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'kurier',
            event = '',
            icon = 'fa-solid fa-cube',
            label = 'Start Job',
            onSelect = function()
                if not hasStartedJob then
                    hasStartedJob = true
                    isCourier = true
                    lib.notify({
                        title = Config.Notifcation,
                        description = Config.notifys.courierstart,
                        type = 'success',
                    })
                    Delivering()
                    Garage()
                else
                    lib.notify({
                        title = Config.Notifcation,
                        description = Config.notifys.courierstart2,
                        type = 'error',
                    })
                end
            end
        },
        {
            name = 'ubranie',
            event = '',
            icon = 'fa-solid fa-cube',
            label = 'Take Clothes',
            onSelect = function ()
                if isCourier then
                    lib.progressCircle({
                        duration = 5000,
                        position = 'middle',
                        useWhileDead = false,
                        canCancel = false,
                        disable = {
                            move = true,
                        },
                        anim = {
                            dict = 'anim@mp_yacht@shower@male@',
                            clip = 'male_shower_towel_dry_to_get_dressed'
                        },
                    })     
                    lib.notify({
                        title = Config.Notifcation,
                        description = Config.notifys.clothes,
                        type = 'success',
                        SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2),
                        SetPedComponentVariation(GetPlayerPed(-1), 4, 15, 0, 2),
                        SetPedComponentVariation(GetPlayerPed(-1), 6, 8, 0, 2),
                        SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2),
                        SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2),
                        SetPedComponentVariation(GetPlayerPed(-1), 11, 1, 0, 2)
                    })
                else
                    lib.notify({
                        title = Config.Notifcation,
                        description = Config.notifys.clothes2,
                        type = 'error',
                    })
                end
            end
        },
        {
            name = 'pobierzauto',
            event = '',
            icon = 'fa-solid fa-cube',
            label = 'Take Vehicle',
            onSelect = function ()
                if not isCourier then
                    return
                    lib.notify({
                        title = Config.Notifcation,
                        description = Config.notifys.errorrental,
                        type = 'error',
                    })
                end
                if not hasSpawnedVehicle then
                    TriggerServerEvent('lnd-courier:cartake')
                    SpawnVeh()
                        lib.notify({
                            title = Config.Notifcation,
                            description = Config.notifys.succesrental,
                            type = 'success',
                        })
                        hasSpawnedVehicle = true
                else
                    lib.notify({
                        title = Config.Notifcation,
                        description = Config.notifys.ucanpickone,
                        type = 'error',
                    })
                end
            end
        },
        {
            name = 'zakoncz',
            event = '',
            icon = 'fa-solid fa-cube',
            label = 'End Job',
            onSelect = function()
                if isCourier then
                lib.notify({
                    title = Config.Notifcation,
                    description = Config.notifys.courierstop,
                    type = 'success',
                    CourierEndJob(),
                })
                hasStartedJob = false
            else
                lib.notify({
                    title = Config.Notifcation,
                    description = Config.notifys.courierror,
                    type = 'error',
                })
                end
            end
        }
    }
})


function SpawnVeh()
    ESX.Game.SpawnVehicle('BOXVILLE4', vec3(-445.476929, -2790.421875, 5.993408), 45.354328, function(vehicle)

        exports.ox_target:addLocalEntity(vehicle, {
            {
                name = 'cartrunk',
                icon = 'fa-solid fa-cube',
                label = 'Take package',
                onSelect = function ()

                    if not takespackage then
                        takespackage = true
                        SetVehicleDoorOpen(vehicle, 2, false, false)
                        SetVehicleDoorOpen(vehicle, 3, false, false)

                        lib.progressCircle({
                            duration = 5000,
                            position = 'middle',
                            useWhileDead = false,
                            canCancel = false,
                            disable = {
                                move = true,
                            },
                            anim = {
                                dict = 'missexile3',
                                clip = 'ex03_dingy_search_case_base_michael',
                            },

                            Citizen.SetTimeout(6000, function()
                                --0.05, 0.1, -0.3, 300.0, 250.0, 20.0
                                entity = CreateObject(getRandomPackageProp(), GetEntityCoords(PlayerPedId()), true, false, false)
                                AttachEntityToEntity(entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.05, 0.1, -0.3, 300.0, 250.0, 20.0, true, true, false, true, 1, true)

                                 lib.requestAnimDict('anim@heists@box_carry@')
                                 TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
                                function deleteprop()
                                        if DoesEntityExist(entity) then
                                            DetachEntity(entity, true, true)
                                            DeleteEntity(entity)
                                        end
                                    end
                            end),

                        })
                        Citizen.SetTimeout(2000, function()
                            SetVehicleDoorShut(vehicle, 2, false)
                            SetVehicleDoorShut(vehicle, 3, false)
                            end)
                        
                        if takespackage then
                                lib.notify({
                                    title = Config.Notifcation,
                                    description = 'You take one package',
                                    type = 'success',
                                    })
                    end
                    takespackage = true
                    end
                end
            }})
    end)
end

function deleteVeh()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if DoesEntityExist(vehicle) then
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
    end
end

function Garage()
    while true do
        Citizen.Wait(0)

        if not isCourier then
            return
        end
        

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        local markerCoords = vector3(-455.221985, -2798.663818, 4.5)
        local distanceToMarker = #(playerCoords - markerCoords)
        local markerVisibleDistance = 18.0

        if distanceToMarker < markerVisibleDistance then
            DrawMarker(
                27, markerCoords.x, markerCoords.y, 5.1,
                0, 0, 0, 0, 0, 0,
                6.5, 6.5, 6.5,
                255, 255, 255, 150, 0, 0, 0, 0, 0, 0
            )

            if distanceToMarker < 4.0 and not isInGarage then
                lib.showTextUI('[E] - Return Vehicle')

                if IsControlJustReleased(0, 38) then
                    isInGarage = true

                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    local modelHash = GetEntityModel(vehicle)
    
                    if modelHash == GetHashKey('BOXVILLE4') then
                        deleteVeh()
                        isInGarage = false
                        hasSpawnedVehicle = false
                        if not moneyRefundTriggered then
                            TriggerServerEvent('lnd-courier:moneyrefund')
                            moneyRefundTriggered = true
                            lib.notify({
                                title = Config.Notifcation,
                                description = Config.notifys.carrefund,
                                type = 'success',
                            })
                            CourierEndJob()
                        end
                    else
                        lib.notify({
                            title = Config.Notifcation,
                            description = Config.notifys.carmodelerror,
                            type = 'error',
                        })
                    end
                    lib.hideTextUI()
                end
            else
                isInGarage = false
                moneyRefundTriggered = false
            end
        end
    end
end

function Delivering()
    if not isCourier then
       Wait(10)
         RemoveBlip(blip)
        return
    end

    function getRandomDeliveryLocation()
        local randomIndex = math.random(1, #Config.deliveries)
        return Config.deliveries[randomIndex]
    end
    
    local deliveriesBlips = {}

    function getRandomPackageProp()
        local randomIndexProp =  math.random(1, #Config.RandomPackageProp)
        return Config.RandomPackageProp[randomIndexProp]
    end

    for i = 1, 1 do -- Change if u want more blips in  one time [[ parameter two ]] .
        
        if not isCourier then
            return
        end

        local randomDeliveryLocation = getRandomDeliveryLocation()
        
        local blip = AddBlipForCoord(randomDeliveryLocation.x, randomDeliveryLocation.y, randomDeliveryLocation.z)
        SetBlipSprite(blip, 286)
        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, 36)
        SetBlipColour(blip, 36)
        SetBlipScale(blip, 0.7)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Delivery Point")
        EndTextCommandSetBlipName(blip)
        
        table.insert(deliveriesBlips, blip)


        function NumberOfDeliveries()
            deliveryZoneId = deliveryZoneId
            deliveryCount = deliveryCount +1
            lib.notify({
                title = Config.Notifcation,
                description = 'You have delivered ' .. deliveryCount .. '  package to 5',
                type = 'success',
            })
            if deliveryCount == Config.deliverycount then
                lib.notify({
                    title = Config.Notifcation,
                    description = Config.notifys.basepoint,
                    type = 'success',
                })
                SemiClear()
            end
        end

        function SemiClear()
            deliveryZoneId = deliveryZoneId
        
            for _, blip in ipairs(deliveriesBlips) do
                RemoveBlip(blip)
                exports.ox_target:removeZone(deliveryZoneId)
            end
            deliveryCount = 0
            deliveriesBlips = {}
        end


            if deliveryZoneId then
                exports.ox_target:removeZone(deliveryZoneId)
            end

            deliveryZoneId = exports.ox_target:addBoxZone({
            coords = randomDeliveryLocation,
            size = vec3(2,2,2),
            rotation = 45,
            debug = drawZones,
            options = {
                {
                    name = 'paczka',
                    event = '',
                    icon = 'fa-solid fa-cube',
                    label = 'Deliver the Package',
                    onSelect = function ()
                        if not takespackage then
                            lib.notify({
                                title = Config.Notifcation,
                                description = 'Go to vehicle and take package',
                                type = 'error',
                            })
                        end
                        if takespackage then
                        RemoveBlip(blip)
                        Citizen.CreateThread(function()
                            Wait(100)
                            spawnPed()
                        end)
                        Delivering()
                        NumberOfDeliveries()
                            lib.progressCircle({
                                duration = 5000,
                                position = 'middle',
                                useWhileDead = false,
                                canCancel = false,
                                disable = {
                                    move = true,
                                },
                                anim = {
                                    dict = 'mp_common',
                                    clip = 'givetake1_a'
                                },
                                --[[prop = {
                                    model = getRandomPackageProp(),
                                    pos = vec3(0.2, 0, -0.02),
                                    rot = vec3(0.0, 0.0, -1.5),
                                    bone = 28422
                                },--]]
                                havebox = false,
                                ClearPedTasksImmediately(PlayerPedId()),
                                Citizen.SetTimeout(5000, function ()
                                    deleteprop()
                                end)
                            })
                            if not cancled then
                                TriggerServerEvent('lnd-courier:sellpackage',Config.AmountSell, totality)
                            end
                    end
                    takespackage = false
                end
                },
        }})

function spawnPed()

    if not isCourier then
        return
    end
    
    local modelName = "a_m_m_afriamer_01"
    local modelHash = GetHashKey(modelName)

    RequestModel(modelHash)

    while not HasModelLoaded(modelHash) do
        Wait(10)
    end

    local playerPed = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerPed)
    local spawnDistance = 1.0  -- distance between player & ped require dont change

    local pedCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, spawnDistance, 0.0)

    spawnedPed = CreatePed(1, modelHash, pedCoords.x, pedCoords.y, pedCoords.z, 0, true, true)

    if spawnedPed ~= 0 then
        TaskTurnPedToFaceEntity(spawnedPed, playerPed, -1)
        SetEntityAsMissionEntity(spawnedPed, true, true)
    else
    end

    function deletePed()
        local countdownStartTime = GetGameTimer()
        local countdownDuration = 8000

        while GetGameTimer() - countdownStartTime < countdownDuration do
            local playerDistance = Vdist2(playerCoords.x, playerCoords.y, playerCoords.z, GetEntityCoords(playerPed))
            
            -- Adjust the distance check as needed
            if playerDistance > spawnDistance * spawnDistance then
                break  -- Exit the loop if player is too far away
            end

            Wait(100)
        end

        if spawnedPed ~= nil and DoesEntityExist(spawnedPed) then
            DeletePed(spawnedPed)
        end
    end
    deletePed()  --DONT CHANGE
end


function CourierEndJob()
    isCourier = false
    hasStartedJob = false
    hasSpawnedVehicle = false
    takespackage = false
    deliveryZoneId = deliveryZoneId
    deliveryCount = 0
    
    for _, blip in ipairs(deliveriesBlips) do
        RemoveBlip(blip)
        exports.ox_target:removeZone(deliveryZoneId)
            end
        end
    end
end
