require("deepcore/std/class")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")

---@class CISGrievousShipEvent
CISGrievousShipEvent = class()

function CISGrievousShipEvent:new(gc, present)
    self.is_complete = false
    self.is_active = false
    self.plot = Get_Story_Plot("Conquests\\Events\\EventLogRepository.XML")

    self.CIS_Player = Find_Player("Rebel")

    self.production_finished_event = gc.Events.GalacticProductionFinished
    self.production_finished_event:attach_listener(self.on_production_finished, self)
end

function CISGrievousShipEvent:on_production_finished(planet, object_type_name)
    --Logger:trace("entering CISGrievousShipEvent:on_production_finished")
    if object_type_name == "GRIEVOUS_UPGRADE_MUNIFICENT_TO_RECUSANT" then
		self.CIS_Player.Lock_Tech(Find_Object_Type("Grievous_Upgrade_Munificent_To_Providence"))
	elseif object_type_name == "GRIEVOUS_UPGRADE_MUNIFICENT_TO_PROVIDENCE" then
		self.CIS_Player.Lock_Tech(Find_Object_Type("Grievous_Upgrade_Munificent_To_Recusant"))		
	elseif object_type_name == "GRIEVOUS_UPGRADE_RECUSANT_TO_MALEVOLENCE" then
		self.CIS_Player.Lock_Tech(Find_Object_Type("Grievous_Upgrade_Providence_To_Malevolence"))		
	elseif object_type_name == "GRIEVOUS_UPGRADE_PROVIDENCE_TO_MALEVOLENCE" then
		self.CIS_Player.Lock_Tech(Find_Object_Type("Grievous_Upgrade_Recusant_To_Malevolence"))
    end
end

return CISGrievousShipEvent
