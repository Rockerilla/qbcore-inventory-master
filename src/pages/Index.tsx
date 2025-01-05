import { useState } from "react";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Plus, Minus, ShoppingCart } from "lucide-react";

const Index = () => {
  const [selectedCategory, setSelectedCategory] = useState("all");
  const [cart, setCart] = useState<Array<{id: number, name: string, quantity: number, price: number}>>([]);

  const categories = [
    "CATEGORY 1",
    "CATEGORY 2",
    "CATEGORY 3",
    "CATEGORY 4",
    "CATEGORY 5",
    "ALL"
  ];

  const items = [
    { id: 1, name: "Lemon Juice", description: "Lemon juice with GPS...", price: 10, image: "🍸" },
    { id: 2, name: "Hamburger", description: "A delicious hamburger...", price: 10, image: "🍔" },
    { id: 3, name: "Coffee PEPS", description: "Michael Jackson Coffee...", price: 10, image: "☕" },
    { id: 4, name: "Tomato", description: "A fresh tomato, great for your receipts...", price: 5, image: "🌭" },
    { id: 5, name: "Chocolate Dunet", description: "Pop Donut...", price: 10, image: "🍩" },
    { id: 6, name: "Snack", description: "Salty Snack...", price: 10, image: "🍿" },
    { id: 7, name: "Ice-Cream", description: "Nutella Ice-cream Enjoy it..", price: 10, image: "🍦" },
    { id: 8, name: "Blueberry Juice", description: "Blue Juice with GPS...", price: 10, image: "🍷" },
    { id: 9, name: "Popcorn", description: "Eat popcorn with Movie...", price: 10, image: "🍿" },
    { id: 10, name: "Wine", description: "Russian Wine ID...", price: 10, image: "🍷" },
    { id: 11, name: "Hell Juice", description: "Fucking Hell Juice...", price: 10, image: "🍸" },
    { id: 12, name: "Potato", description: "A delicious Potato With Sus...", price: 10, image: "🍟" },
    { id: 13, name: "Cake", description: "A delicious Cake With Cream...", price: 10, image: "🧁" },
  ];

  const addToCart = (item: typeof items[0]) => {
    setCart(prev => {
      const existing = prev.find(i => i.id === item.id);
      if (existing) {
        return prev.map(i => 
          i.id === item.id ? {...i, quantity: i.quantity + 1} : i
        );
      }
      return [...prev, { ...item, quantity: 1 }];
    });
  };

  const updateQuantity = (id: number, delta: number) => {
    setCart(prev => prev.map(item => {
      if (item.id === id) {
        const newQuantity = Math.max(0, item.quantity + delta);
        return newQuantity === 0 ? null : {...item, quantity: newQuantity};
      }
      return item;
    }).filter(Boolean) as typeof cart);
  };

  const clearCart = () => setCart([]);

  const total = cart.reduce((sum, item) => sum + item.price * item.quantity, 0);

  return (
    <div className="min-h-screen bg-[#121212] text-white p-4">
      <div className="max-w-[1400px] mx-auto grid grid-cols-12 gap-6">
        {/* Shopping Cart */}
        <div className="col-span-12 md:col-span-3">
          <Card className="bg-[#1a1a1a] border-[#333] text-white h-full">
            <div className="p-4">
              <div className="flex items-center gap-2 mb-6">
                <ShoppingCart className="w-6 h-6" />
                <h1 className="text-2xl font-bold">24/7 SHOP</h1>
              </div>
              <p className="text-sm text-gray-400 mb-6">
                Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint.
              </p>
              <ScrollArea className="h-[400px] pr-4">
                {cart.map((item) => (
                  <div key={item.id} className="flex items-center justify-between mb-4 bg-[#252525] p-3 rounded">
                    <div className="flex items-center gap-2">
                      <div className="flex items-center gap-2">
                        <Button
                          variant="ghost"
                          size="sm"
                          onClick={() => updateQuantity(item.id, -1)}
                          className="h-8 w-8 p-0"
                        >
                          <Minus className="h-4 w-4" />
                        </Button>
                        <span>{item.quantity}</span>
                        <Button
                          variant="ghost"
                          size="sm"
                          onClick={() => updateQuantity(item.id, 1)}
                          className="h-8 w-8 p-0"
                        >
                          <Plus className="h-4 w-4" />
                        </Button>
                      </div>
                      <span>{item.name}</span>
                    </div>
                    <span>${item.price * item.quantity}</span>
                  </div>
                ))}
              </ScrollArea>
              <div className="mt-6 border-t border-[#333] pt-4">
                <div className="flex justify-between mb-4">
                  <span>TOTAL</span>
                  <span className="text-green-500">${total}</span>
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <Button className="w-full bg-green-600 hover:bg-green-700">
                    PAY
                  </Button>
                  <Button
                    variant="outline"
                    className="w-full border-[#333] text-white hover:bg-[#333]"
                    onClick={clearCart}
                  >
                    CLEAR
                  </Button>
                </div>
              </div>
            </div>
          </Card>
        </div>

        {/* Main Content */}
        <div className="col-span-12 md:col-span-9">
          <div className="mb-6 flex gap-4 overflow-x-auto pb-2">
            {categories.map((category) => (
              <Button
                key={category}
                variant={selectedCategory === category.toLowerCase() ? "default" : "outline"}
                className={`border-[#333] ${
                  selectedCategory === category.toLowerCase()
                    ? "bg-green-600 hover:bg-green-700"
                    : "hover:bg-[#333]"
                }`}
                onClick={() => setSelectedCategory(category.toLowerCase())}
              >
                {category}
              </Button>
            ))}
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {items.map((item) => (
              <Card
                key={item.id}
                className="bg-[#1a1a1a] border-[#333] text-white cursor-pointer hover:bg-[#252525] transition-colors"
                onClick={() => addToCart(item)}
              >
                <div className="p-4">
                  <div className="flex justify-between items-start mb-2">
                    <div>
                      <h3 className="font-bold">{item.name}</h3>
                      <p className="text-sm text-gray-400">{item.description}</p>
                    </div>
                    <div className="text-4xl">{item.image}</div>
                  </div>
                  <Button className="w-full mt-4 bg-green-600 hover:bg-green-700">
                    ${item.price}
                  </Button>
                </div>
              </Card>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default Index;