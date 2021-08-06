local comp = require("component")
local sides = require("sides")
local saveTable = dofile("saveTable.lua")
local table = require("table")
local shell = require("shell")

local args, ops = shell.parse(...)
local item = comp.transposer.getStackInSlot(sides.top, 2)
local db = comp.database
local fluids = saveTable.getTable()

for i = 1, 81 do
    if db.get(i) == nil then
       comp.transposer.store(sides.top, 2, db.address, i)
       local newFluid = {}
       newFluid.name = args[1]
       newFluid.amount = tonumber(args[2])
       newFluid.slot = i
       newFluid.amtToKeep = tonumber(args[3])
       table.insert(fluids, newFluid)
       saveTable.saveTable(fluids)
       comp.transposer.transferItem(sides.top, sides.west, 64, 2)
       break
   end
end

return saveTable.getTable()