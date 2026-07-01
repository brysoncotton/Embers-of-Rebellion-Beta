require("PGBase")
require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
require("eawx-util/StoryUtil")

---@class TacticalCrewHandler
TacticalCrewHandler = class()

function TacticalCrewHandler:new()
    self.boarded_units = {}

    self.ship_crews = 0

    crossplot:subscribe("CREW_COST", self.remove_crew, self)
    crossplot:subscribe("CREW_GAIN", self.add_crew, self)
    crossplot:subscribe("CREW_BATTLE_ENDED", self.battle_end, self)
    crossplot:subscribe("UPDATE_CREWS", self.set_initial_crews, self)
end

function TacticalCrewHandler:remove_crew(amount)

    self.ship_crews = self.ship_crews - amount

    if amount > 0 then
        StoryUtil.ShowScreenText("Ship crews: "..self.ship_crews.." (-"..tostring(amount)..")", 10)
    end    
end

function TacticalCrewHandler:add_crew(amount)

    self.ship_crews = self.ship_crews + amount

    if amount > 0 then
        StoryUtil.ShowScreenText("Ship crews: "..self.ship_crews.." (+"..tostring(amount)..")", 10)
    end    
end

function TacticalCrewHandler:battle_end()
    
    crossplot:publish("TACTICAL_CREW_UPDATE", self.ship_crews)
  
end

function TacticalCrewHandler:set_initial_crews(ship_crews)
    
    self.ship_crews = ship_crews
  
end

return TacticalCrewHandler