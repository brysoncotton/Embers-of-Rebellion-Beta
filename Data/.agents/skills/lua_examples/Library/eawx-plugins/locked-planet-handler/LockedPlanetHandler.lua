require("eawx-util/StoryUtil")
require("eawx-util/ChangeOwnerUtilities")
CONSTANTS = ModContentLoader.get("GameConstants")

---@class LockedPlanetHandler
LockedPlanetHandler = class()

function LockedPlanetHandler:new()
end

function LockedPlanetHandler:update()
	--attach particle to all locked planets
	local LockedPlanetNames = GlobalValue.Get("LOCKED_PLANETS")

	if LockedPlanetNames == nil then
		return
	end

	local LockedPlanetObjects = {}
	for _,LockedPlanetName in pairs(LockedPlanetNames) do
		local LockedPlanetObject = FindPlanet(LockedPlanetName)
		table.insert(LockedPlanetObjects,LockedPlanetObject)
	end

	for _,LockedPlanetObject in pairs(LockedPlanetObjects) do
		LockedPlanetObject.Attach_Particle_Effect("Locked_Planet")
	end

	--evaluate presence of interlopers for deadly locked planets
	local DeadlyLockedPlanetNames = GlobalValue.Get("DEADLY_LOCKED_PLANETS")

	if DeadlyLockedPlanetNames == nil then
		return
	end

	local DeadlyLockedPlanetObjects = {}
	for _,DeadlyLockedPlanetName in pairs(DeadlyLockedPlanetNames) do
		if DeadlyLockedPlanetName ~= "" then
			local DeadlyLockedPlanetObject = FindPlanet(DeadlyLockedPlanetName)
			table.insert(DeadlyLockedPlanetObjects,DeadlyLockedPlanetObject)
		end
	end

	CheckForInterlopers(DeadlyLockedPlanetObjects)
end

function CheckForInterlopers(locked_planet_objects)
	local locked_planets_w_interlopers = {}

	for i, faction_name in pairs(CONSTANTS.PLAYABLE_FACTIONS) do
		local faction_object = Find_Player(faction_name)
		for j, planet_object in pairs(locked_planet_objects) do
			if EvaluatePerception("Has_Friendly_Force", faction_object, planet_object) > 0 and planet_object.Get_Owner() ~= faction_object then
				table.insert(locked_planets_w_interlopers,{planet_object,faction_object})
			end
		end
	end

	if table.getn(locked_planets_w_interlopers) > 0 then
		KillInterlopers(locked_planets_w_interlopers)
	end
end

function KillInterlopers(planets_with_forces)
	local p_human = Find_Player("local")
	local human_notified = false

	for _,planet_force in pairs(planets_with_forces) do
		local planet_object = planet_force[1]
		local faction_object = planet_force[2]
		local planet_name = planet_object.Get_Type().Get_Name()
		local faction_name = faction_object.Get_Faction_Name()
		local faction_nice_name = faction_object.Get_Name()

		local allFactionUnitInstances = Find_All_Objects_Of_Type(faction_object) or {}
		for i, unitInstance in pairs(allFactionUnitInstances) do
			if TestValid(unitInstance) then
				local unitAction = determine_unit_action(unitInstance, unitInstance.Get_Planet_Location(), {planet_object})

				--if unitInstance meets conditions, kill unitInstanceRelevantObject
				if unitAction == 2 then
					local unitInstanceRelevantObject = get_relevant_object(unitInstance)
					if TestValid(unitInstanceRelevantObject) then
						--must publish death event to crossplot since GameScoring does not count Despawn() as a death
						local unitInstanceRelevantObjectType = unitInstanceRelevantObject.Get_Type()
						if unitInstanceRelevantObjectType.Is_Hero() and not unitInstanceRelevantObject.Is_Category("Structure") then
							crossplot:publish("GALACTIC_HERO_KILLED", unitInstanceRelevantObjectType.Get_Name(), faction_name, nil)
						end
						unitInstanceRelevantObject.Despawn()

						if faction_object == p_human and human_notified == false then
							StoryUtil.ShowScreenText("TEXT_LOCKED_PLANET_DESPAWN", 15, nil, {r = 255, g = 255, b = 100})
							human_notified = true
						end
					end
				end
			end
		end
	end
end
