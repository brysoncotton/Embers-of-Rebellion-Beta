
--*****************************************************--
--************** Rimward: Gunning Gunray **************--
--*****************************************************--

require("PGStoryMode")
require("PGBase")
require("PGSpawnUnits")
require("eawx-util/ChangeOwnerUtilities")
require("eawx-util/StoryUtil")
require("deepcore/crossplot/crossplot")
require("deepcore/std/class")
require("deepcore/std/Observable")
require("eawx-util/GalacticUtil")
require("eawx-util/MissionUtil")

function Definitions()
	ServiceRate = 2.0

	DebugMessage("%s -- In Definitions", tostring(Script))

	Define_State("State_Init", State_Init)
	Define_State("State_Set_Up", State_Set_Up)
	Define_State("State_Tranquility_Disabled", State_Tranquility_Disabled)

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_hostile = Find_Player("Hostile")

	boarding_range = 225
	tranquility_disabled = false
	tactical_set_up_done = false
end

function State_Init(message)
	if message == OnEnter then
		if Get_Game_Mode() == "Space" then
			Set_Next_State("State_Set_Up")
		end
	elseif message == OnUpdate then
		if Get_Game_Mode() == "Galactic" then
			local current_planet = Object.Get_Planet_Location()

			if TestValid(current_planet) then
				local plot = Get_Story_Plot("Conquests\\CloneWarsRimward\\Story_Sandbox_Rimward_CIS.XML")

				local event = plot.Get_Event("CIS_Rimward_Campaign_Act_III_Dialog")
				event.Set_Dialog("DIALOG_RIMWARD_CAMPAIGN_CIS")
				event.Clear_Dialog_Text()
				event.Add_Dialog_Text("TEXT_INTERVENTION_HUNT", Find_Object_Type("Venator_Tranquility"))
				event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", current_planet)
			end
			if not TestValid(current_planet) then
				local plot = Get_Story_Plot("Conquests\\CloneWarsRimward\\Story_Sandbox_Rimward_CIS.XML")

				local event = plot.Get_Event("CIS_Rimward_Campaign_Act_III_Dialog")
				event.Set_Dialog("DIALOG_RIMWARD_CAMPAIGN_CIS")
				event.Clear_Dialog_Text()
				event.Add_Dialog_Text("TEXT_INTERVENTION_HUNT", Find_Object_Type("Venator_Tranquility"))
				event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION_UNAVAILABLE")
			end
		end
		if Get_Game_Mode() == "Land" then
			ScriptExit()
		end
	end
end

function State_Set_Up(message)
	if message == OnEnter then
		if not tactical_set_up_done then
			Register_Death_Event(Object, State_Gunray_Destroyed)
			StoryUtil.ShowScreenText("TEXT_MISSION_GUNNING_GUNRAY_SPEECH_01", 10)

			Add_Objective("TEXT_MISSION_GUNNING_GUNRAY_OBJECTIVE_CIS_01", true)
			Add_Objective("TEXT_MISSION_GUNNING_GUNRAY_OBJECTIVE_CIS_02", true)
			Add_Objective("TEXT_MISSION_GUNNING_GUNRAY_OBJECTIVE_CIS_03", false)

			p_hostile.Make_Ally(p_cis)
			p_cis.Make_Ally(p_hostile)

			Add_Radar_Blip(Object, "Gunray_blip")
			Object.Highlight(true)
			tactical_set_up_done = true
		end
	elseif message == OnUpdate then
		if Object.Get_Hull() <= 0.5 then
			Set_Next_State("State_Tranquility_Disabled")
		end
	end
end

function State_Tranquility_Disabled(message)
	if message == OnEnter then
		if not tranquility_disabled then
			p_republic.Make_Ally(p_hostile)
			p_hostile.Make_Ally(p_republic)

			Object.Prevent_Opportunity_Fire(true)
			Object.Prevent_All_Fire(true)
			Object.Prevent_AI_Usage(true)
			Object.Make_Invulnerable(true)
			Object.Change_Owner(p_hostile)

			Register_Prox(Object, State_Commence_Boarding, boarding_range, p_cis)
			MissionUtil.SetObjectiveComplete("TEXT_MISSION_GUNNING_GUNRAY_OBJECTIVE_CIS_03")
			Add_Objective("TEXT_MISSION_GUNNING_GUNRAY_OBJECTIVE_CIS_04", false)
			StoryUtil.ShowScreenText("TEXT_MISSION_GUNNING_GUNRAY_SPEECH_02", 12)
			tranquility_disabled = true
		end
	end
end

function State_Commence_Boarding(self_obj, trigger_obj)
	if trigger_obj.Is_Category("Frigate | Capital | SpaceHero") then
		if trigger_obj.Get_Owner() == p_cis then
			StoryUtil.ShowScreenText("TEXT_MISSION_GUNNING_GUNRAY_SPEECH_04", 12)

			StoryUtil.TriggerScriptedBattle("VENATOR_VENTRESS", "FLORRUM", "LAND", "REBEL", "EMPIRE", false)
			MissionUtil.SetObjectiveComplete("TEXT_MISSION_GUNNING_GUNRAY_OBJECTIVE_CIS_04")
			Object.Hyperspace_Away(true)

			self_obj.Cancel_Event_Object_In_Range(State_Commence_Boarding)
		end
	end
end

function State_Gunray_Destroyed()
	StoryUtil.ShowScreenText("TEXT_MISSION_GUNNING_GUNRAY_SPEECH_03", 10)
	MissionUtil.SetObjectiveFailed("TEXT_MISSION_GUNNING_GUNRAY_OBJECTIVE_CIS_03")
	MissionUtil.SetObjectiveFailed("TEXT_MISSION_GUNNING_GUNRAY_OBJECTIVE_CIS_04")
	crossplot:publish("CIS_REDUCE_SUPPORT", Find_Player("Trade_Federation"))
	ScriptExit()
end