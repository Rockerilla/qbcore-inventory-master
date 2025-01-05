let currentShop = null;
let isEmployee = false;

window.addEventListener('message', function(event) {
    if (event.data.action === "open") {
        currentShop = event.data.shop;
        document.querySelector('.shop-title').textContent = currentShop.label;
        loadItems();
        document.querySelector('.container').style.display = 'flex';
    }
});

function loadItems() {
    const itemsContainer = document.querySelector('.items-grid');
    itemsContainer.innerHTML = '';

    Object.values(currentShop.inventory).forEach(item => {
        const itemElement = createItemElement(item);
        itemsContainer.appendChild(itemElement);
    });

    if (isEmployee) {
        loadEmployeeSection();
    }
}

function createItemElement(item) {
    const div = document.createElement('div');
    div.className = 'relative flex flex-col items-center p-4 bg-[#1a1a1a] rounded-lg cursor-pointer hover:bg-[#252525] transition-colors';
    
    div.innerHTML = `
        <img src="${item.image}" alt="${item.name}" class="w-24 h-24 object-contain mb-2">
        <h3 class="font-bold">${item.name}</h3>
        <p class="text-sm text-gray-400">Stock: ${item.stock}/${item.max_stock}</p>
        <button onclick="buyItem('${item.name}')" class="w-full mt-4 bg-green-600 hover:bg-green-700 text-white py-2 px-4 rounded">
            ${Config.Currency.position === 'left' ? Config.Currency.symbol : ''}${item.price}${Config.Currency.position === 'right' ? Config.Currency.symbol : ''}
        </button>
    `;

    return div;
}

function loadEmployeeSection() {
    const employeeSection = document.createElement('div');
    employeeSection.className = 'employee-section';
    employeeSection.innerHTML = `
        <h2>Gestión de Tienda</h2>
        <div class="stock-management">
            ${Object.values(currentShop.inventory).map(item => `
                <div class="stock-item">
                    <span>${item.name}</span>
                    <div class="stock-controls">
                        <button onclick="updateStock('${item.name}', -1)" class="bg-red-600 hover:bg-red-700 text-white py-1 px-2 rounded">-</button>
                        <span>${item.stock}</span>
                        <button onclick="updateStock('${item.name}', 1)" class="bg-green-600 hover:bg-green-700 text-white py-1 px-2 rounded">+</button>
                    </div>
                </div>
            `).join('')}
        </div>
    `;

    document.querySelector('.container').appendChild(employeeSection);
}

function buyItem(itemName) {
    if (!currentShop) return;
    
    fetch(`https://${GetParentResourceName()}/buyItem`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            item: itemName,
            amount: 1
        })
    });
}

function updateStock(itemName, amount) {
    fetch(`https://${GetParentResourceName()}/updateStock`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            item: itemName,
            amount: amount
        })
    });
}

document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        fetch(`https://${GetParentResourceName()}/closeMenu`, {
            method: 'POST'
        });
        document.querySelector('.container').style.display = 'none';
    }
});