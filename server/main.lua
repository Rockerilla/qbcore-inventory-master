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
        TriggerClientEvent('QBCore:Notify', src, 'No hay suficiente stock', 'error')
        return
    end

    local totalPrice = item.price * amount
    if Player.PlayerData.money.cash < totalPrice then
        TriggerClientEvent('QBCore:Notify', src, 'No tienes suficiente dinero', 'error')
        return
    end

    if Config.UseOxInventory then
        exports.ox_inventory:AddItem(src, itemName, amount)
    else
        Player.Functions.AddItem(itemName, amount)
    end

    Player.Functions.RemoveMoney('cash', totalPrice)
    Config.Shops[shopId].inventory[itemName].stock = Config.Shops[shopId].inventory[itemName].stock - amount

    TriggerClientEvent('QBCore:Notify', src, 'Compra realizada con éxito', 'success')
end)

-- Comandos del servidor
QBCore.Commands.Add('addstock', Config.Commands['addstock'].help, {{name = 'item', help = 'Nombre del item'}, {name = 'amount', help = 'Cantidad'}}, true, function(source, args)
    if not HasPermission(source, 'add_stock') then
        TriggerClientEvent('QBCore:Notify', source, 'No tienes permiso', 'error')
        return
    end

    local itemName = args[1]
    local amount = tonumber(args[2])
    
    if not amount or amount <= 0 then
        TriggerClientEvent('QBCore:Notify', source, 'Cantidad inválida', 'error')
        return
    end

    for _, shop in pairs(Config.Shops) do
        if shop.inventory[itemName] then
            local newStock = shop.inventory[itemName].stock + amount
            if newStock <= shop.inventory[itemName].max_stock then
                shop.inventory[itemName].stock = newStock
                TriggerClientEvent('QBCore:Notify', source, 'Stock actualizado', 'success')
            else
                TriggerClientEvent('QBCore:Notify', source, 'Excede el stock máximo', 'error')
            end
            return
        end
    end

    TriggerClientEvent('QBCore:Notify', source, 'Item no encontrado', 'error')
end)

-- Inicialización del servidor
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    print('24/7 Shop System iniciado correctamente')
end)