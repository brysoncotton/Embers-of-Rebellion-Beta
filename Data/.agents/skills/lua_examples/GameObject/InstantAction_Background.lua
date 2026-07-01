--***************************************************--
--*********** Main Menu Space Script ****************--
--***************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("eawx-util/StoryUtil")
require("eawx-util/UnitUtil")
require("eawx-util/MissionUtil")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	Define_State("State_Init", State_Init)

end

function State_Init(message)
	if message == OnEnter then

		local asteroid_list = Find_All_Objects_Of_Type("ASTEROID FIELD MAP1")
		for i,asteroid in pairs(asteroid_list) do
			Hide_Object(asteroid, 1)
		end

		if Get_Game_Mode() ~= "Space" then
			ScriptExit()
		end

		low_orbit_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "low-orbit")

		if TestValid(Find_First_Object("LOWORBIT_CORUSCANT")) then
			StoryUtil.ShowScreenText("Current Background: Barren", 10, nil, {r = 244, g = 244, b = 0})
			Find_First_Object("LOWORBIT_CORUSCANT").Despawn()
			low_orbit_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "low-orbit")
			MissionUtil.SpawnUnitSpace("LOWORBIT_BARREN", low_orbit_marker, Find_Player("Neutral"), 1)
			ScriptExit()
		end

		if TestValid(Find_First_Object("LOWORBIT_BARREN")) then
			StoryUtil.ShowScreenText("Current Background: Blue Ecumenopolis", 10, nil, {r = 244, g = 244, b = 0})
			Find_First_Object("LOWORBIT_BARREN").Despawn()
			low_orbit_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "low-orbit")
			MissionUtil.SpawnUnitSpace("LOWORBIT_BLUEECUMENOPOLIS", low_orbit_marker, Find_Player("Neutral"), 1)
			ScriptExit()
		end


		low_orbit_blueecumenopolis_marker = Find_First_Object("LOWORBIT_BLUEECUMENOPOLIS")
		if TestValid(Find_First_Object("LOWORBIT_BLUEECUMENOPOLIS")) then
			StoryUtil.ShowScreenText("Current Background: Continental", 10, nil, {r = 244, g = 244, b = 0})
			Find_First_Object("LOWORBIT_BLUEECUMENOPOLIS").Despawn()
			low_orbit_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "low-orbit")
			MissionUtil.SpawnUnitSpace("LOWORBIT_CONTINENTAL_ONE", low_orbit_marker, Find_Player("Neutral"), 1)
			ScriptExit()
		end

		low_orbit_continental_one_marker = Find_First_Object("LOWORBIT_CONTINENTAL_ONE")
		if TestValid(Find_First_Object("LOWORBIT_CONTINENTAL_ONE")) then
			StoryUtil.ShowScreenText("Current Background: Da Soocha V", 10, nil, {r = 244, g = 244, b = 0})
			Find_First_Object("LOWORBIT_CONTINENTAL_ONE").Despawn()
			low_orbit_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "low-orbit")
			MissionUtil.SpawnUnitSpace("LOWORBIT_DASOOCHA", low_orbit_marker, Find_Player("Neutral"), 1)
			ScriptExit()
		end

		low_orbit_dasoocha_marker = Find_First_Object("LOWORBIT_DASOOCHA")
		if TestValid(Find_First_Object("LOWORBIT_DASOOCHA")) then
			StoryUtil.ShowScreenText("Current Background: Desert", 10, nil, {r = 244, g = 244, b = 0})
			Find_First_Object("LOWORBIT_DASOOCHA").Despawn()
			low_orbit_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "low-orbit")
			MissionUtil.SpawnUnitSpace("LOWORBIT_DESERTONE", low_orbit_marker, Find_Player("Neutral"), 1)
			ScriptExit()
		end

		low_orbit_desertone_marker = Find_First_Object("LOWORBIT_DESERTONE")
		if TestValid(Find_First_Object("LOWORBIT_DESERTONE")) then
			StoryUtil.ShowScreenText("Current Background: Arctic", 10, nil, {r = 244, g = 244, b = 0})
			Find_First_Object("LOWORBIT_DESERTONE").Despawn()
			low_orbit_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "low-orbit")
			MissionUtil.SpawnUnitSpace("LOWORBIT_ICE", low_orbit_marker, Find_Player("Neutral"), 1)
			ScriptExit()
		end

		low_orbit_ice_marker = Find_First_Object("LOWORBIT_ICE")
		if TestValid(Find_First_Object("LOWORBIT_ICE")) then
			StoryUtil.ShowScreenText("Current Background: Island", 10, nil, {r = 244, g = 244, b = 0})
			Find_First_Object("LOWORBIT_ICE").Despawn()
			low_orbit_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "low-orbit")
			MissionUtil.SpawnUnitSpace("LOWORBIT_ISLANDSONE", low_orbit_marker, Find_Player("Neutral"), 1)
			ScriptExit()
		end

		low_orbit_islandsone_marker = Find_First_Object("LOWORBIT_ISLANDSONE")
		if TestValid(Find_First_Object("LOWORBIT_ISLANDSONE")) then
			StoryUtil.ShowScreenText("Current Background: Mountain", 10, nil, {r = 244, g = 244, b = 0})
			Find_First_Object("LOWORBIT_ISLANDSONE").Despawn()
			low_orbit_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "low-orbit")
			MissionUtil.SpawnUnitSpace("LOWORBIT_MOUNTAINSONE", low_orbit_marker, Find_Player("Neutral"), 1)
			ScriptExit()
		end

		low_orbit_mountainsone_marker = Find_First_Object("LOWORBIT_MOUNTAINSONE")
		if TestValid(Find_First_Object("LOWORBIT_MOUNTAINSONE")) then
			StoryUtil.ShowScreenText("Current Background: Orange Crater", 10, nil, {r = 244, g = 244, b = 0})
			Find_First_Object("LOWORBIT_MOUNTAINSONE").Despawn()
			low_orbit_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "low-orbit")
			MissionUtil.SpawnUnitSpace("LOWORBIT_ORANGECRATERS", low_orbit_marker, Find_Player("Neutral"), 1)
			ScriptExit()
		end

		low_orbit_orangecrater_marker = Find_First_Object("LOWORBIT_ORANGECRATERS")
		if TestValid(Find_First_Object("LOWORBIT_ORANGECRATERS")) then
			StoryUtil.ShowScreenText("Current Background: Volcanic", 10, nil, {r = 244, g = 244, b = 0})
			Find_First_Object("LOWORBIT_ORANGECRATERS").Despawn()
			low_orbit_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "low-orbit")
			MissionUtil.SpawnUnitSpace("LOWORBIT_VOLCANIC", low_orbit_marker, Find_Player("Neutral"), 1)
			ScriptExit()
		end

		low_orbit_volcanic_marker = Find_First_Object("LOWORBIT_VOLCANIC")
		if TestValid(Find_First_Object("LOWORBIT_VOLCANIC")) then
			StoryUtil.ShowScreenText("Current Background: Asteroid Field", 10, nil, {r = 244, g = 244, b = 0})
			Find_First_Object("LOWORBIT_VOLCANIC").Despawn()
			local asteroid_list = Find_All_Objects_Of_Type("ASTEROID FIELD MAP1")
			for i,asteroid in pairs(asteroid_list) do
				Hide_Object(asteroid, 0)
			end
			ScriptExit()
		end

		low_orbit_asteroid_marker = Find_First_Object("ASTEROID FIELD MAP3")
		if TestValid(Find_First_Object("ASTEROID FIELD MAP3")) then
			StoryUtil.ShowScreenText("Current Background: None", 10, nil, {r = 244, g = 244, b = 0})
			local asteroid_list = Find_All_Objects_Of_Type("ASTEROID FIELD MAP1")
			for i,asteroid in pairs(asteroid_list) do
				Hide_Object(asteroid, 1)
			end
			ScriptExit()
		end

		StoryUtil.ShowScreenText("Current Background: Coruscant", 10, nil, {r = 244, g = 244, b = 0})
		low_orbit_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "low-orbit")
		MissionUtil.SpawnUnitSpace("LOWORBIT_CORUSCANT", low_orbit_marker, Find_Player("Neutral"), 1)
		ScriptExit()
	end
end
