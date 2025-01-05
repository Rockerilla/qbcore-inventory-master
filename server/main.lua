local QBCore = exports['qb-core']:GetCoreObject()

-- Funciones de utilidad
local function HasPermission(source, permission)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local job = Player.PlayerData.job
    if not Config.Jobs[job.name] then return false end
    
    local grade = Config.Jobs[job.name].grades[tostring(job.grade.level)]
    if not grade then return false end
    
    return grade.permissions[permission]
end

local function GetLocalizedText(key)
    local lang = 'en' -- Puedes hacer esto configurable
    return Config.Language[lang][key] or key
end

-- Eventos del servidor
RegisterNetEvent('qb-shops:server:buyItem', function(shopId, itemName, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local shop = Config.Shops[shopId]
    if not shop then return end

    local item = shop.inventory[itemName]
    if not item then return end

    if item.stock < amount then
        TriggerClientEvent('QBCore:Notify', src, GetLocalizedText('no_stock'), 'error')
        return
    end

    local totalPrice = item.price * amount
    if Player.PlayerData.money.cash < totalPrice then
        TriggerClientEvent('QBCore:Notify', src, GetLocalizedText('no_money'), 'error')
        return
    end

    if Config.UseOxInventory then
        exports.ox_inventory:AddItem(src, itemName, amount)
    else
        Player.Functions.AddItem(itemName, amount)
    end

    Player.Functions.RemoveMoney('cash', totalPrice)
    Config.Shops[shopId].inventory[itemName].stock = Config.Shops[shopId].inventory[itemName].stock - amount

    TriggerClientEvent('QBCore:Notify', src, GetLocalizedText('purchase_success'), 'success')
end)

-- Comandos del servidor
QBCore.Commands.Add('addstock', Config.Commands['addstock'].help, {{name = 'item', help = 'Nombre del item'}, {name = 'amount', help = 'Cantidad'}}, true, function(source, args)
    if not HasPermission(source, 'add_stock') then
        TriggerClientEvent('QBCore:Notify', source, GetLocalizedText('no_permission'), 'error')
        return
    end

    local itemName = args[1]
    local amount = tonumber(args[2])
    
    if not amount or amount <= 0 then
        TriggerClientEvent('QBCore:Notify', source, GetLocalizedText('invalid_amount'), 'error')
        return
    end

    for _, shop in pairs(Config.Shops) do
        if shop.inventory[itemName] then
            local newStock = shop.inventory[itemName].stock + amount
            if newStock <= shop.inventory[itemName].max_stock then
                shop.inventory[itemName].stock = newStock
                TriggerClientEvent('QBCore:Notify', source, GetLocalizedText('stock_added'), 'success')
            else
                TriggerClientEvent('QBCore:Notify', source, GetLocalizedText('max_stock_reached'), 'error')
            end
            return
        end
    end

    TriggerClientEvent('QBCore:Notify', source, GetLocalizedText('item_not_found'), 'error')
end)

-- Inicialización del servidor
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    print('24/7 Shop System iniciado correctamente')
end)