--**************************************************************************************************
--*    _______ __                                                                                  *
--*   |_     _|  |--.----.---.-.--.--.--.-----.-----.                                              *
--*     |   | |     |   _|  _  |  |  |  |     |__ --|                                              *
--*     |___| |__|__|__| |___._|________|__|__|_____|                                              *
--*    ______                                                                                      *
--*   |   __ \.-----.--.--.-----.-----.-----.-----.                                                *
--*   |      <|  -__|  |  |  -__|     |  _  |  -__|                                                *
--*   |___|__||_____|\___/|_____|__|__|___  |_____|                                                *
--*                                   |_____|                                                      *
--*                                                                                                *
--*                                                                                                *
--*       File:              BlockadeAttrition.lua                                                 *
--*       File Created:      Thursday, 15th October 2020 08:26                                     *
--*       Author:            [TR] evilbobthebob                                                    *
--*       Last Modified:     Sunday, 23rd February 2020 10:22                                      *
--*       Modified By:       [TR] evilbobthebob                                                    *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************
require("eawx-util/ChangeOwnerUtilities")

---@class BlockadeAttrition
require("deepcore/std/class")

BlockadeAttrition = class()

---@param human_player PlayerObject
function BlockadeAttrition:new(human_player, planets)
	self.human_player = human_player
	self.planets = planets
	
	self.blockade_attrition_unit_killed = Observable()
end

---@param planet Planet
function BlockadeAttrition:attrition(planet)
	--Logger:trace("entering BlockadeAttrition:update")
    local planet_object = planet:get_game_object()
	local owner = planet:get_owner()
	
	if owner == Find_Player("Neutral") then
		return
	end
	
    local blockaded_with_weapon = EvaluatePerception("Blockaded_With_GTS_Weapon", owner, planet_object)

	if blockaded_with_weapon > 0 then
		DebugMessage("%s -- Planet %s has a ground-to-space weapon", tostring(Script), tostring(planet_object))
		
		local orbiting_units_per_faction = {}
		local orbiting_units_to_destroy = {}
		insert_all_enemy_units_on_planet(orbiting_units_per_faction, owner, planet_object)
		
		for _, faction_unit_table in pairs(orbiting_units_per_faction) do
			for i, unit in pairs(faction_unit_table) do
				if not (unit.Is_Category("SuperCapital") or unit.Is_Category("SpaceHero") or unit.Is_Category("InfantryHero") or unit.Is_Category("VehicleHero") or unit.Is_Category("NonCombatHero") or unit.Has_Property("GTSImmune")) then
					table.insert(orbiting_units_to_destroy, unit)
				end
			end
			
			if table.getn(orbiting_units_to_destroy) == 0 then
				break
			end
			
			DebugMessage("%s -- Planet %s has %s enemy units in orbit", tostring(Script), tostring(planet_object), tostring(table.getn(orbiting_units_to_destroy)))
			local unit_to_kill = orbiting_units_to_destroy[GameRandom(1, table.getn(orbiting_units_to_destroy))]

			--no gunship squadron blockade cheese
			local relevant_unit_to_kill = get_relevant_object(unit_to_kill)
			
			if not TestValid(relevant_unit_to_kill) then
				return
			end
	
			self.blockade_attrition_unit_killed:notify(planet, relevant_unit_to_kill, relevant_unit_to_kill.Get_Owner().Get_Faction_Name())
			
			DebugMessage("%s -- Killing unit %s at %s", tostring(Script), tostring(relevant_unit_to_kill), tostring(planet_object))
			relevant_unit_to_kill.Despawn()
			planet:get_game_object().Attach_Particle_Effect("Galactic_GtS_Attrition_Explosion") 
		end
	end
end