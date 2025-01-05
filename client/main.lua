local QBCore = exports['qb-core']:GetCoreObject()
local currentShop = nil
local isLoggedIn = false
local shopPeds = {}

-- Funciones de utilidad
local function ShowNotification(msg, type)
    if Config.UseOxLib then
        lib.notify({
            title = '24/7 Shop',
            description = msg,
            type = type
        })
    else
        QBCore.Functions.Notify(msg, type)
    end
end

-- Inicialización de NPCs
local function SpawnShopPeds()
    for k, v in pairs(Config.Shops) do
        local model = GetHashKey(v.ped.model)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end
        
        local ped = CreatePed(4, model, v.ped.coords.x, v.ped.coords.y, v.ped.coords.z - 1.0, v.ped.coords.w, false, true)
        SetEntityHeading(ped, v.ped.coords.w)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        shopPeds[k] = ped
    end
end

-- Inicialización de targets
local function InitializeTargets()
    for k, v in pairs(Config.Shops) do
        if Config.UseOxTarget then
            exports.ox_target:addBoxZone({
                coords = v.coords,
                size = vector3(2, 2, 2),
                rotation = v.coords.w,
                debug = Config.Debug,
                options = {
                    {
                        name = 'shop_' .. k,
                        icon = 'fas fa-shop',
                        label = 'Abrir Tienda',
                        onSelect = function()
                            currentShop = k
                            SetNuiFocus(true, true)
                            SendNUIMessage({
                                action = "open",
                                shop = v
                            })
                        end
                    }
                }
            })
        else
            exports['qb-target']:AddBoxZone('shop_' .. k, v.coords, 2, 2, {
                name = 'shop_' .. k,
                heading = v.coords.w,
                debugPoly = Config.Debug,
            }, {
                options = {
                    {
                        type = "client",
                        icon = 'fas fa-shop',
                        label = 'Abrir Tienda',
                        action = function()
                            currentShop = k
                            SetNuiFocus(true, true)
                            SendNUIMessage({
                                action = "open",
                                shop = v
                            })
                        end
                    }
                }
            })
        end
    end
end

-- Eventos NUI
RegisterNUICallback('closeMenu', function()
    SetNuiFocus(false, false)
    currentShop = nil
end)

RegisterNUICallback('buyItem', function(data, cb)
    if not currentShop then return end
    
    TriggerServerEvent('qb-shops:server:buyItem', currentShop, data.item, data.amount)
    cb('ok')
end)

-- Eventos del cliente
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    SpawnShopPeds()
    InitializeTargets()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    for _, ped in pairs(shopPeds) do
        DeletePed(ped)
    end
    shopPeds = {}
end)

-- Comandos
RegisterCommand('checkstock', function(source, args)
    if not args[1] then return ShowNotification('Especifica un item', 'error') end
    TriggerServerEvent('qb-shops:server:checkStock', args[1])
end)

-- Inicialización
CreateThread(function()
    if isLoggedIn then
        SpawnShopPeds()
        InitializeTargets()
    end
end)