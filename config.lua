Config = {}

Config.Debug = false
Config.UseOxInventory = true -- false para usar qb-inventory
Config.UseOxTarget = true -- false para usar qb-target
Config.UseOxLib = true -- false para usar qb-notify

Config.Currency = {
    symbol = "$",
    position = "left" -- 'left' o 'right'
}

Config.Language = {
    ['es'] = {
        ['shop_name'] = "Tienda",
        ['no_stock'] = "No hay suficiente stock",
        ['no_money'] = "No tienes suficiente dinero",
        ['purchase_success'] = "Compra realizada con éxito",
        ['stock_added'] = "Stock añadido correctamente",
        ['stock_removed'] = "Stock eliminado correctamente",
        ['invalid_amount'] = "Cantidad inválida",
        ['no_permission'] = "No tienes permiso"
    },
    ['en'] = {
        ['shop_name'] = "Shop",
        ['no_stock'] = "Not enough stock",
        ['no_money'] = "Not enough money",
        ['purchase_success'] = "Purchase successful",
        ['stock_added'] = "Stock added successfully",
        ['stock_removed'] = "Stock removed successfully",
        ['invalid_amount'] = "Invalid amount",
        ['no_permission'] = "No permission"
    }
}

Config.Shops = {
    ['247_1'] = {
        label = "24/7 Shop",
        coords = vector4(25.7, -1347.3, 29.49, 271.32),
        ped = {
            model = "mp_m_shopkeep_01",
            coords = vector4(24.5, -1347.3, 28.49, 271.32)
        },
        job = "247", -- Trabajo requerido para gestionar
        inventory = {
            ["water"] = {
                name = "water",
                price = 10,
                stock = 100,
                max_stock = 200,
                image = "nui://core_inventory/html/img/water.png"
            },
            ["sandwich"] = {
                name = "sandwich",
                price = 15,
                stock = 100,
                max_stock = 200,
                image = "nui://core_inventory/html/img/sandwich.png"
            },
        }
    },
    -- Puedes agregar más tiendas aquí
}

Config.Jobs = {
    ['247'] = {
        label = "24/7 Employee",
        grades = {
            ['0'] = {
                label = "Trainee",
                permissions = {
                    'view_stock',
                }
            },
            ['1'] = {
                label = "Employee",
                permissions = {
                    'view_stock',
                    'add_stock',
                }
            },
            ['2'] = {
                label = "Manager",
                permissions = {
                    'view_stock',
                    'add_stock',
                    'remove_stock',
                    'manage_employees'
                }
            },
        }
    }
}

Config.Commands = {
    ['addstock'] = {
        permission = 'add_stock',
        help = '/addstock [item] [amount]'
    },
    ['removestock'] = {
        permission = 'remove_stock',
        help = '/removestock [item] [amount]'
    },
    ['checkstock'] = {
        permission = 'view_stock',
        help = '/checkstock [item]'
    }
}