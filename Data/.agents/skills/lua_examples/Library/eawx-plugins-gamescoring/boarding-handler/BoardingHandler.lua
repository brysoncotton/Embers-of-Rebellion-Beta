require("PGBase")
require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
require("eawx-util/StoryUtil")

---@class BoardingHandler
BoardingHandler = class()

function BoardingHandler:new()
    self.boarded_units = {}

    crossplot:subscribe("BOARDED_UNIT", self.save_unit, self)
    crossplot:subscribe("PROCESS_BOARDING", self.process_boarding, self)
end

function BoardingHandler:process_boarding()
    --self:finalize_boarded_unit_list()
    crossplot:publish("TACTICAL_BOARDED_UNITS", self.boarded_units)
    self:reset()
end

function BoardingHandler:save_unit(unit_type_name, owner_name)
    DebugMessage("Saving boarded unit type %s for %s", tostring(unit_type_name), tostring(owner_name))
    table.insert(self.boarded_units, {unit_type_name=unit_type_name, owner_name=owner_name})
end

function BoardingHandler:finalize_boarded_unit_list()
    DebugMessage("Finalizing boarded unit list")
    for index, boarded_unit_data in pairs(self.boarded_units) do
        local owner = Find_Player(boarded_unit_data.owner_name)
        local objects_of_type_for_owner = Find_All_Objects_Of_Type(boarded_unit_data.unit_type_name, owner)

        local first_object = objects_of_type_for_owner[1]
        if TestValid(first_object) then
            first_object.Despawn()
        else
            table.remove(self.boarded_units, index)
        end
    end
end

function BoardingHandler:reset()
    DebugMessage("reset")
    self.boarded_units = {}
end

return BoardingHandler