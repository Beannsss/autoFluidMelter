local comp = require('component')
local sides = require("sides")
local math = require("math")

local saveTable = dofile("saveTable.lua")
local listOfFluids = saveTable.getTable()

local transposer = comp.transposer
local me = comp.me_interface
local bus = comp.me_exportbus
local timeToSleep = 2
local db = comp.database

function exportItem(item)
  bus.setExportConfiguration(sides.east, db.address, item.slot)
  for i = 2, 16 do
    if bus.exportIntoSlot(sides.east, i) then
      break
    end
  end
end

while true do
    local fluidsInNetwork = me.getFluidsInNetwork()
    for j, fluid2 in ipairs(listOfFluids) do
        local fluidFound = false
        for i, fluid in ipairs(fluidsInNetwork) do
            if fluid.name == fluid2.name then
                fluidFound = true
                if fluid.amount < fluid2.amtToKeep then
                   -- transposer.transferItem(sides.bottom, sides.east,
                     --   math.ceil((fluid2.amtToKeep - fluid.amount) / fluid2.amount), fluid2.slot)
                    exportItem(fluid2)
                    print("ADDING " .. (fluid2.amtToKeep - fluid.amount) .. ' mb of ' .. fluid2.name)
                    break
                end
            end
        end
        if not fluidFound then
            print(fluid2.name .. " NOT FOUND")
           -- transposer.transferItem(sides.bottom, sides.east, math.ceil(fluid2.amtToKeep / fluid2.amount), fluid2.slot)
            exportItem(fluid2)
            print("ADDING " .. fluid2.amtToKeep .. ' mb of ' .. fluid2.name)
        end
    end
    os.sleep(timeToSleep)
end