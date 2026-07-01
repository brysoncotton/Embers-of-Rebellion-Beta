--*****************************************************************************
--*    _______ __
--*   |_     _|  |--.----.---.-.--.--.--.-----.-----.
--*     |   | |     |   _|  _  |  |  |  |     |__ --|
--*     |___| |__|__|__| |___._|________|__|__|_____|
--*    ______
--*   |   __ \.-----.--.--.-----.-----.-----.-----.
--*   |      <|  -__|  |  |  -__|     |  _  |  -__|
--*   |___|__||_____|\___/|_____|__|__|___  |_____|
--*                                   |_____|
--*
--*   @Author:              [EaWX]Pox
--*   @Date:                2020-12-23
--*   @Project:             Empire at War Expanded
--*   @Filename:            GalacticEvents.lua
--*   @License:             MIT
--*****************************************************************************

require("deepcore/std/class")
require("deepcore/std/Observable")
require("deepcore/crossplot/crossplot")

---@class PlanetOwnerChangedEvent : Observable
PlanetOwnerChangedEvent = class(Observable)

function PlanetOwnerChangedEvent:new(planets)
    self.planets = planets
    crossplot:subscribe("PLANET_OWNER_CHANGED", self.planet_owner_changed, self)
end

function PlanetOwnerChangedEvent:planet_owner_changed(planet_name, new_owner_name, old_owner_name)
    if not planet_name then
        return
    end

    local planet = self.planets[planet_name]
    self:notify(planet, new_owner_name, old_owner_name)
end

---@class ProductionStartedEvent : Observable
ProductionStartedEvent = class(Observable)

function ProductionStartedEvent:new(planets)
    ---@private
    ---@type Planet[]
    self.planets = planets
    crossplot:subscribe("PRODUCTION_STARTED", self.production_started, self)
end

function ProductionStartedEvent:production_started(planet_name, object_type_name)
    local planet = self.planets[planet_name]
    self:notify(planet, object_type_name)
end

---@class ProductionFinishedEvent : Observable
ProductionFinishedEvent = class(Observable)

function ProductionFinishedEvent:new(planets)
    self.planets = planets
    crossplot:subscribe("PRODUCTION_FINISHED", self.production_finished, self)
end

function ProductionFinishedEvent:production_finished(planet_name, object_type_name)
    local planet = self.planets[planet_name]
    self:notify(planet, object_type_name)
end

---@class ProductionCanceledEvent : Observable
ProductionCanceledEvent = class(Observable)

function ProductionCanceledEvent:new(planets)
    ---@private
    ---@type Planet[]
    self.planets = planets
    crossplot:subscribe("PRODUCTION_CANCELED", self.production_canceled, self)
end

function ProductionCanceledEvent:production_canceled(planet_name, object_type_name)
    local planet = self.planets[planet_name]
    self:notify(planet, object_type_name)
end

---@class GalacticHeroKilledEvent : Observable
GalacticHeroKilledEvent = class(Observable)

function GalacticHeroKilledEvent:new()
    crossplot:subscribe("GALACTIC_HERO_KILLED", self.galactic_hero_killed, self)
end

function GalacticHeroKilledEvent:galactic_hero_killed(hero_name, owner_name, killer_name)
    self:notify(hero_name, owner_name, killer_name)
end

---@class GalacticLimitedUnitKilledEvent : Observable
GalacticLimitedUnitKilledEvent = class(Observable)

function GalacticLimitedUnitKilledEvent:new()
    crossplot:subscribe("LIMITED_UNIT_KILLED", self.galactic_limited_unit_killed, self)
end

function GalacticLimitedUnitKilledEvent:galactic_limited_unit_killed(short_name, owner_name, killer_name)
    self:notify(short_name, owner_name, killer_name)
end

---@class GalacticHeroNeutralizedEvent : Observable
GalacticHeroNeutralizedEvent = class(Observable)

function GalacticHeroNeutralizedEvent:new()
    crossplot:subscribe("GALACTIC_HERO_NEUTRALIZED", self.galactic_hero_neutralized, self)
end

function GalacticHeroNeutralizedEvent:galactic_hero_neutralized(hero_name, killer_name)
    self:notify(hero_name, killer_name)
end

---@class GalacticSSDKilledEvent : Observable
GalacticSSDKilledEvent = class(Observable)

function GalacticSSDKilledEvent:new()
    crossplot:subscribe("GALACTIC_SSD_KILLED", self.galactic_ssd_killed, self)
end

function GalacticSSDKilledEvent:galactic_ssd_killed(short_name, owner_name, killer_name)
    self:notify(short_name, owner_name, killer_name)
end

---@class GalacticSSDDamagedEvent : Observable
GalacticSSDDamagedEvent = class(Observable)

function GalacticSSDDamagedEvent:new()
    crossplot:subscribe("SSD_PARTICIPATED_IN_TACTICAL_BATTLE", self.galactic_ssd_damaged, self)
end

function GalacticSSDDamagedEvent:galactic_ssd_damaged(short_name, old_health, object_name, owner_name)
	local proceed = false

	local objects = Find_All_Objects_Of_Type(object_name)
	if table.getn(objects) > 0 then
		local p_owner = Find_Player(owner_name)
		for _,object in pairs(objects) do
			if object.Get_Owner() == p_owner then
				proceed = true
			end
		end
	end

	if proceed == false then
		return
	end

	local globalval = object_name.."_"..owner_name
	local new_health = GlobalValue.Get(globalval)

	if new_health < old_health and new_health > 0 then
		self:notify(short_name, new_health)
	end
end

---@class GalacticSSDRepairedEvent : Observable
GalacticSSDRepairedEvent = class(Observable)

function GalacticSSDRepairedEvent:new()
    crossplot:subscribe("GALACTIC_SSD_REPAIRED", self.galactic_ssd_repaired, self)
end

function GalacticSSDRepairedEvent:galactic_ssd_repaired(short_name, new_health, heal_fee)
    self:notify(short_name, new_health, heal_fee)
end

---@class TacticalBattleEndedEvent : Observable
TacticalBattleEndedEvent = class(Observable)

function TacticalBattleEndedEvent:new()
    crossplot:subscribe("GAME_MODE_ENDING", self.battle_ended, self)
end

function TacticalBattleEndedEvent:battle_ended(mode_name)
    self:notify(mode_name)
end

---@class GalacticStarbaseLevelChangeEvent : Observable
GalacticStarbaseLevelChangeEvent = class(Observable)

function GalacticStarbaseLevelChangeEvent:new()
    crossplot:subscribe("STARBASE_LEVEL_CHANGED", self.galactic_starbase_change, self)
end

function GalacticStarbaseLevelChangeEvent:galactic_starbase_change(owner_name, planet, old_type, new_type, killer_name)
    self:notify(owner_name, planet, old_type, new_type, killer_name)
end