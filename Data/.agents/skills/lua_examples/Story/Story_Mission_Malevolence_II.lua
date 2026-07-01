
--*****************************************************--
--*** Hunt for the Malevolence: Mission Malevolence ***--
--*****************************************************--

require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("TRCommands")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents =
	{
		Battle_Start = Begin_Battle,
		Trigger_Showdown_Malevolence = State_Showdown_Malevolence,
		Trigger_Malevolence_Escaped = State_Malevolence_Escaped,
		Trigger_Malevolence_Defeated = State_Malevolence_Defeated,
		Trigger_Escort_Fleet_Defeated = State_Escort_Fleet_Defeated,
		Trigger_Malevolence_Died = State_Malevolence_Died,
		Trigger_Act_II_Active = State_Act_II_Active,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")
	p_pdf = Find_Player("Sector_Forces")

	act_1_active = false
	act_2_active = false

	current_cinematic_thread_id = nil

	cinematic_two = false
	cinematic_three = false

	cinematic_two_skipped = false
	cinematic_three_skipped = false

	coward_gamble = false
	malevolence_disabled = false

	malevolence_present = false
	malevolence_escaped = false
	generic_battle = false

	escape_chance = 15
end
function Begin_Battle(message)
	if message == OnEnter then
		if p_republic.Is_Human() then

			MissionUtil.Set_To_Allies(p_cis, p_invaders)
			MissionUtil.Set_To_Allies(p_invaders, p_republic)

			attacker_marker = Find_First_Object("Attacker Entry Position")
			defender_marker = Find_First_Object("Defending Forces Position")
			player_grievous = Find_First_Object("Grievous_Malevolence_Hunt_Campaign")

			if TestValid(player_grievous) then
				act_1_active = true
				malevolence_present = true
				Story_Event("PLAYER_REP")
				Story_Event("VALID_GRIEVOUS")
			elseif not TestValid(player_grievous) then
				malevolence_present = false
				generic_battle = true -- If the Malevolence isn't there, this ain't the battle you are looking for
			end
		end
	end
end


function State_Showdown_Malevolence(message)
	if message == OnEnter then
		if p_republic.Is_Human() then
			player_grievous.Set_Cannot_Be_Killed(true)
			Add_Objective("TEXT_MISSION_MISSION_MALEVOLENCE_OBJECTIVE_REP_01", false)
			Add_Objective("TEXT_MISSION_MISSION_MALEVOLENCE_OBJECTIVE_REP_02", false)
			if (GlobalValue.Get("HfM_Battle_Counter") == 1) then
				escape_chance = 99
				GlobalValue.Set("HfM_Battle_Counter", 2)
			elseif (GlobalValue.Get("HfM_Battle_Counter") == 2) then
				escape_chance = 50
				GlobalValue.Set("HfM_Battle_Counter", 3)
			elseif (GlobalValue.Get("HfM_Battle_Counter") == 3) then
				escape_chance = 33
				GlobalValue.Set("HfM_Battle_Counter", 4)
			elseif (GlobalValue.Get("HfM_Battle_Counter") == 4) then
				escape_chance = 25
				GlobalValue.Set("HfM_Battle_Counter", 5)
			elseif (GlobalValue.Get("HfM_Battle_Counter") == 5) then
				escape_chance = 0
			end
		end
	end
end

function State_Malevolence_Escaped(message)
	if message == OnEnter then
		Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Hyperspace_Away(false)
		Story_Event("ALLOW_STUFF")
		Sleep(3.0)
		Story_Event("COWARD")
		--Find_Player("Rebel").Retreat()
	end
end

function State_Malevolence_Defeated(message)
	if message == OnEnter then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_Rep")
	end
end

function State_Escort_Fleet_Defeated(message)
	if message == OnEnter then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
	end
end

function State_Malevolence_Died(message)
	if message == OnEnter then
		malevolence_marker = Create_Position(0, 0, 0)
		player_grievous = Spawn_Unit(Find_Object_Type("Grievous_Malevolence_Hunt_Campaign"), malevolence_marker, p_cis)
		player_grievous = Find_Nearest(malevolence_marker, p_cis, true)
		player_grievous.Take_Damage(26000)
	end
end

function State_Act_II_Active(message)
	if message == OnEnter then
		act_2_active = true
	end
end


function Story_Handle_Esc()
	if p_republic.Is_Human() then
		if cinematic_two then
			if not cinematic_two_skipped then
				cinematic_two_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Change_Owner(p_invaders)
				Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Suspend_Locomotor(true)
				Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Prevent_All_Fire(true)

				MissionUtil.Set_To_Enemies(p_cis, p_republic)

				Story_Event("CLEAN_UP")
				Add_Objective("TEXT_MISSION_MISSION_MALEVOLENCE_OBJECTIVE_REP_03", false)

				MissionUtil.CinematicSkippingCleanUp(attacker_marker)
				MissionUtil.CinematicEnvironmentOff()

				cinematic_two = false

				Fade_Screen_In(0.5)
			end
		end
		if cinematic_three then
			if not cinematic_three_skipped then
				cinematic_three_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				act_2_active = false
				player_grievous.Set_Cannot_Be_Killed(false)
				player_grievous.Take_Damage(100000)

				Story_Event("SUBJUGATOR_SABOTAGE")

				MissionUtil.CinematicEnvironmentOff()
				StoryUtil.DeclareVictory(p_republic, false)
			end
		end
	end
end
function Story_Mode_Service()
	if p_republic.Is_Human() then
		if act_1_active then
			if not coward_gamble then
				if Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Get_Hull() <= 0.85 and not TestValid(Find_First_Object("Interdiction_Mine")) and not malevolence_disabled then
					coward_gamble = true
					retreat_chance = GameRandom.Free_Random(1, 100)
					if retreat_chance <= escape_chance then
						Story_Event("MALEVOLENCE_ESCAPED")
					end
				end
			end
			if not malevolence_disabled then
				if Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Get_Hull() <= 0.10 then
					Story_Event("MALEVOLENCE_DEFEATED")
					malevolence_disabled = true
				end
			end
			if not malevolence_died and not coward_gamble then
				if not TestValid(Find_First_Object("Grievous_Malevolence_Hunt_Campaign")) then
					malevolence_died = true
					Story_Event("MALEVOLENCE_DIED")
				end
			end
			cis_is_retreating = EvaluatePerception("Enemy_Retreating", p_republic)
			if (cis_is_retreating ~= 0) then
				if TestValid(Find_First_Object("Grievous_Malevolence_Hunt_Campaign")) then
					Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Hyperspace_Away(false)
					Sleep(1)
					Story_Event("COWARD")
				end
			end
			republic_list_01 = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
			if (table.getn(republic_list_01) == 0) then
				StoryUtil.DeclareVictory(p_cis, false)
			end
		end
		if act_2_active then
			cis_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Capital | Frigate | SpaceStructure | SuperCapital")
			if (table.getn(cis_list) == 0) then
				Story_Event("ESCORT_FLEET_DEFEATED")
			end
			republic_list_02 = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
			if (table.getn(republic_list_02) == 0) then
				StoryUtil.DeclareVictory(p_cis, false)
			end
		end
		if generic_battle then
			if TestValid(Find_First_Object("Grievous_Malevolence_Hunt_Campaign")) and not malevolence_present then
				act_1_active = true
				Story_Event("PLAYER_REP")
				Story_Event("VALID_GRIEVOUS")
				generic_battle = false
				malevolence_present = true
			end
		end
	end
end


function Start_Cinematic_Midtro_Rep()
	act_1_active = false
	cinematic_two = true

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()
	Fade_On()

	SFXManager.Allow_Localized_SFXEvents(false)

	hero_list_01 = Find_All_Objects_Of_Type("SpaceHero")
	for h, hero01 in pairs(hero_list_01) do
		if TestValid(hero01) then
			hero01.Make_Invulnerable(true)
		end
	end

	MissionUtil.PlayGenericSpeech("Mission_Malevolence_01")
	MissionUtil.PlayGenericMusic("Silence_Theme")
	Sleep(1.0)

	Letter_Box_In(1.0)
	Fade_Screen_In(2.0)

	Set_Cinematic_Camera_Key(player_grievous, 2800, 200, 155, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_grievous, 0, 0, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(attacker_marker, 20, 350, 12, 45, 1, 0, 1, 0)
	Sleep(15.0)

	MissionUtil.Set_To_Allies(p_cis, p_republic)

	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Change_Owner(p_invaders)
	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Suspend_Locomotor(true)
	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Prevent_All_Fire(true)
	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Prevent_Opportunity_Fire(true)

	Set_Cinematic_Camera_Key(player_grievous, 3000, -5000, -5000, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_grievous, 0, 0, 0, 0, player_grievous, 1, 0)
	Transition_Cinematic_Camera_Key(player_grievous, 20, -3000, -1000, 300, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(player_grievous, 20, 0, 0, 0, 0, player_grievous, 1, 0)
	Sleep(15.0)

	Set_Cinematic_Camera_Key(attacker_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(attacker_marker, 0, 0, 0, 0, player_grievous, 1, 0)
	Transition_Cinematic_Camera_Key(player_grievous, 20, -2500, 500, 500, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(player_grievous, 20, 0, 0, 0, 0, player_grievous, 1, 0)
	Sleep(20.0)

	if not cinematic_two_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Midtro_Rep")
	end
end
function End_Cinematic_Midtro_Rep()
	if TestValid(Find_First_Object("Yularen_Resolute")) then
		Point_Camera_At(Find_First_Object("Yularen_Resolute"))
	end
	Add_Objective("TEXT_MISSION_MISSION_MALEVOLENCE_OBJECTIVE_REP_03", false)

	MissionUtil.EndCinematicCamera(player_grievous, 3.0)
	MissionUtil.CinematicEnvironmentOff()

	hero_list_02 = Find_All_Objects_Of_Type("SpaceHero")
	for h, hero02 in pairs(hero_list_02) do
		if TestValid(hero02) then
			hero02.Make_Invulnerable(false)
		end
	end

	MissionUtil.Set_To_Enemies(p_cis, p_republic)

	Sleep(10.0)

	MissionUtil.CinematicEnvironmentOff()

	cinematic_two = false

	Story_Event("CLEAN_UP")
end

function Start_Cinematic_Outro_Rep()
	Story_Event("SUBJUGATOR_SABOTAGE")

	act_2_active = false
	cinematic_three = true

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()
	Fade_On()

	SFXManager.Allow_Localized_SFXEvents(false)

	player_anakin = Spawn_Unit(Find_Object_Type("Twilight_Mission"), attacker_marker, p_republic)
	player_anakin = Find_Nearest(attacker_marker, p_republic, true)
	player_anakin.Teleport_And_Face(attacker_marker)
	player_anakin.Move_To(player_grievous)

	MissionUtil.PlayGenericSpeech("Mission_Malevolence_02")
	MissionUtil.PlayGenericMusic("Silence_Theme")
	Sleep(1.0)

	player_anakin.Play_Animation("Undeploy", false)

	Set_Cinematic_Camera_Key(attacker_marker, 800, 200, 155, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(attacker_marker, 0, 0, 0, 0, player_anakin, 1, 0)
	Transition_Cinematic_Camera_Key(attacker_marker, 10, 100, 100, -100, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(attacker_marker, 10, 0, 0, 0, 0, player_grievous, 1, 0)

	Letter_Box_In(1.0)
	Fade_Screen_In(2.0)
	Sleep(7.0)

	player_anakin.Play_Animation("Deploy", false)

	Set_Cinematic_Camera_Key(player_anakin, 0, -50, -700, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_anakin, 0, 0, 0, 0, player_anakin, 1, 0)
	Sleep(6.0)

	Fade_Screen_Out(4.0)
	Sleep(5.0)

	player_grievous.Set_Cannot_Be_Killed(false)
	player_grievous.Take_Damage(100000)

	MissionUtil.CinematicEnvironmentOff()
	StoryUtil.DeclareVictory(p_republic, false)
end
