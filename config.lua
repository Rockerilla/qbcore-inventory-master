Config = {}

Config.Debug = false
Config.UseOxInventory = true -- false para usar qb-inventory
Config.UseOxTarget = true -- false para usar qb-target
Config.UseOxLib = true -- false para usar qb-notify

Config.Shops = {
    ['247_1'] = {
        label = "24/7 Shop",
        coords = vector4(25.7, -1347.3, 29.49, 271.32),
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