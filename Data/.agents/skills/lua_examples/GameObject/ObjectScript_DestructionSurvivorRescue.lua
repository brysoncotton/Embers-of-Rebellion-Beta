require("PGStateMachine")
require("PGStoryMode")
require("PGBase")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")

function Definitions()
	Define_State("State_Init", State_Init)

	ServiceRate = 1
end

function State_Init(message)
	if Get_Game_Mode() ~= "Space" or TestValid(Find_First_Object("SCRIPTED_BATTLE_MARKER")) or TestValid(Find_First_Object("PROP_STARFORGE_SUN")) then
		ScriptExit()
	end

	if message == OnEnter then
		Object.Set_Cannot_Be_Killed(true)
		Object.Set_Selectable(false)

		local escape_vector = nil
		if TestValid(Find_First_Object("Map_Corner")) then
			escape_vector = Find_First_Object("Map_Corner")
		elseif TestValid(Find_First_Object("Attacker Entry Position")) then
			escape_vector = Find_First_Object("Attacker Entry Position")
		end

		if escape_vector ~= nil then
			Object.Move_To(escape_vector)
		end

		survivor_speech = nil
		survivor_holo = nil

		local object_name = Object.Get_Type().Get_Name()
		local SurvivorTable = require("DestructionSurvivorLibrary")
		for survivor_object_name, survivor_data in pairs(SurvivorTable) do
			if survivor_object_name == object_name then
				survivor_speech = survivor_data.survivor_speech
				survivor_holo = survivor_data.survivor_holo
				break
			end
		end

		time_mark = GetCurrentTime()
		stage_index = 0

	elseif message == OnUpdate then
		if (stage_index == 0) and (GetCurrentTime() >= time_mark + 1) then
			StoryUtil.Multimedia(survivor_speech, 20, nil, survivor_holo, 0)
			stage_index = 1
		end

		if (stage_index == 1) and (GetCurrentTime() >= time_mark + 9) then
			Object.Hyperspace_Away(true)
			stage_index = 2
		end

		if (stage_index == 2) and (GetCurrentTime() >= time_mark + 12) then
			Object.Despawn()
			ScriptExit()
		end
	end
end
