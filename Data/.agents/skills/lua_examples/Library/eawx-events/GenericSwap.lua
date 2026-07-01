require("deepcore/std/class")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")
require("eawx-util/UnitUtil")

---@class GenericSwap
GenericSwap = class()

function GenericSwap:new(event_name, player, from_list, to_list)
    --Logger:trace("entering GenericSwap:new")
 
    self.ForPlayer = Find_Player(player)

    self.Story_Tag = event_name

    self.From_List = from_list
    self.To_List = to_list

    crossplot:subscribe(self.Story_Tag, self.activate, self)
    
end

function GenericSwap:activate()
    --Logger:trace("entering GenericSwap:activate")
    for i, fromUnit in pairs(self.From_List) do
        local toUnit = self.To_List[i]		
		UnitUtil.ReplaceAtLocation(fromUnit, toUnit)
    end
end

return GenericSwap
