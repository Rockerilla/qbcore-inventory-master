import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Package2, Settings, Database, Command } from "lucide-react";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

const Index = () => {
  const [selectedInventory, setSelectedInventory] = useState("qb");
  const [searchTerm, setSearchTerm] = useState("");

  const items = [
    { id: 1, name: "weapon_pistol", label: "Pistol", stock: 50 },
    { id: 2, name: "water", label: "Water", stock: 100 },
    { id: 3, name: "bread", label: "Bread", stock: 75 },
  ];

  const adminCommands = [
    { command: "/giveitem", description: "Give item to player" },
    { command: "/setstock", description: "Set item stock" },
    { command: "/additem", description: "Add new item" },
  ];

  const filteredItems = items.filter((item) =>
    item.name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="container mx-auto p-4 space-y-6">
      <h1 className="text-4xl font-bold text-center mb-8 text-gradient-primary">
        QBCore Management System
      </h1>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {/* Inventory Selection */}
        <Card className="col-span-1">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Database className="h-5 w-5" />
              Inventory System
            </CardTitle>
          </CardHeader>
          <CardContent>
            <Select value={selectedInventory} onValueChange={setSelectedInventory}>
              <SelectTrigger>
                <SelectValue placeholder="Select inventory" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="qb">QB-Inventory</SelectItem>
                <SelectItem value="ox">ox-Inventory</SelectItem>
                <SelectItem value="qs">qs-Inventory</SelectItem>
              </SelectContent>
            </Select>
          </CardContent>
        </Card>

        {/* Items Management */}
        <Card className="col-span-1 lg:col-span-2">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Package2 className="h-5 w-5" />
              Items & Stock
            </CardTitle>
          </CardHeader>
          <CardContent>
            <Input
              placeholder="Search items..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="mb-4"
            />
            <ScrollArea className="h-[200px] rounded-md border p-4">
              <div className="space-y-4">
                {filteredItems.map((item) => (
                  <div
                    key={item.id}
                    className="flex items-center justify-between bg-secondary/50 p-3 rounded-lg"
                  >
                    <div>
                      <h3 className="font-medium">{item.label}</h3>
                      <p className="text-sm text-muted-foreground">{item.name}</p>
                    </div>
                    <div className="flex items-center gap-4">
                      <span className="text-sm">Stock: {item.stock}</span>
                      <button className="p-2 hover:bg-secondary rounded">
                        <Settings className="h-4 w-4" />
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            </ScrollArea>
          </CardContent>
        </Card>

        {/* Admin Commands */}
        <Card className="col-span-1 lg:col-span-3">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Command className="h-5 w-5" />
              Admin Commands
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {adminCommands.map((cmd, index) => (
                <div
                  key={index}
                  className="bg-secondary/50 p-4 rounded-lg space-y-2"
                >
                  <h3 className="font-mono text-sm font-medium">{cmd.command}</h3>
                  <p className="text-sm text-muted-foreground">
                    {cmd.description}
                  </p>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default Index;