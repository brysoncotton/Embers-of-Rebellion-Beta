-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Bothawui_Intimidation.lua#1 $
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
-- (C) Petroglyph Games, Inc.
--
--
--  *****           **                          *                   *
--  *   **          *                           *                   *
--  *    *          *                           *                   *
--  *    *          *     *                 *   *          *        *
--  *   *     *** ******  * **  ****      ***   * *      * *****    * ***
--  *  **    *  *   *     **   *   **   **  *   *  *    * **   **   **   *
--  ***     *****   *     *   *     *  *    *   *  *   **  *    *   *    *
--  *       *       *     *   *     *  *    *   *   *  *   *    *   *    *
--  *       *       *     *   *     *  *    *   *   * **   *   *    *    *
--  *       **       *    *   **   *   **   *   *    **    *  *     *   *
-- **        ****     **  *    ****     *****   *    **    ***      *   *
--                                          *        *     *
--                                          *        *     *
--                                          *       *      *
--                                      *  *        *      *
--                                      ****       *       *
-- 
--/////////////////////////////////////////////////////////////////////////////////////////////////
-- C O N F I D E N T I A L   S O U R C E   C O D E -- D O   N O T   D I S T R I B U T E
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Bothawui_Intimidation.lua $
--
--    Original Author: Jeff Stewart
--
--            $Author: Brian_Hayes $
--
--            $Change: 637819 $
--
--          $DateTime: 2017/03/22 10:16:16 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")
require("PGStoryMode")

--
-- Definitions -- This function is called once when the script is first created.
-- 
function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))
	
	StoryModeEvents = 
	{
		Bothawui_Intimidation_Mission_Begin = State_Bothawui_Intimidation_Kidnapping_Mission_Begin,
		Bothawui_Intimidation_Player_Loses_Remove_Movie = State_Bothawui_Intimidation_Player_Loses_Remove_Movie,
		Bothawui_Intimidation_FAIL_OBJECTIVE_Tyber_Must_Survive = State_Bothawui_Intimidation_FAIL_OBJECTIVE_Tyber_Must_Survive,

		
	}
	
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	empire = Find_Player("Empire")
	hutts = Find_Player("Hutts")
	hostile = Find_Player("Hostile")
	
	camera_offset = 135
	
	flag_polo_has_fled = false
	

	

end

function State_Bothawui_Intimidation_Kidnapping_Mission_Begin(message)
	if message == OnEnter then
		mission_started = true
		JoeMessage("#####################################Starting Bothawui_Intimidation mission")
		--MessageBox("#####################################Starting Bothawui_Intimidation mission")
		
		-- define mission hero here --
		hero = Find_First_Object("TYBER_ZANN")
		if not TestValid(hero) then	
			hero = Find_First_Object("URAI_FEN")
		end

		
		if not TestValid(hero) then
			MessageBox("Bothawui_Intimidation mission cannot find the hero...aborting...tell Joe G immediately!")
			ScriptExit()
		end
		
		Create_Thread("Thread_DeathMonitor_Hero", hero)
		
		rebel_list = Find_All_Objects_Of_Type(rebel)
		empire_list = Find_All_Objects_Of_Type(empire)
		hutt_list = Find_All_Objects_Of_Type(hutts)
		

		
		senator_polo_list = Find_All_Objects_With_Hint("polo")
		senator_polo = senator_polo_list[1]
		
		
		if not TestValid(senator_polo) then
			MessageBox("Bothawui_Intimidation mission cannot find the senator_polo...aborting...tell Joe G immediately!")
			ScriptExit()
		end
		
		defending_faction = senator_polo.Get_Owner()
		Create_Thread("Thread_Cleanup_Faction_Stuff", defending_faction)
		
		senator_polo.Set_Cannot_Be_Killed(true)
		senator_polo.Make_Invulnerable(true)
		senator_polo.Prevent_Opportunity_Fire(true)
		senator_polo.Suspend_Locomotor(true)
		Add_Radar_Blip(senator_polo, "senator_polo_blip")
		senator_polo.Highlight(true)
		
		Register_Prox(senator_polo,PROX_Senator_Polo,125,underworld)
		
		
		
		pointguards_list = Find_All_Objects_With_Hint("pointguard")
		for i,unit in pairs(pointguards_list) do
			if TestValid(unit) then
				
				unit.Guard_Target(unit.Get_Position())
				unit.Prevent_AI_Usage(true)
			end
		end
		
		
		
		-- make only minor tweaks to the script below... --
		--current_cinematic_thread = Create_Thread("Intro_Cinematic")
		Create_Thread("End_Camera")
		
		polos_house = Find_Hint("SENATOR_POLOS_PALACE", "polos-house")
		Create_Thread("Thread_DeathMonitor_Palace", polos_house)

	end
end

function Thread_Cleanup_Faction_Stuff(defender_faction)
	--MessageBox("Thread_Cleanup_Faction_Stuff HIT!")

	bothan_resistor_list = Find_All_Objects_Of_Type("BOTHAN_RESISTORS")
	
	
	if TestValid(polos_house) then
		polos_house.Change_Owner(defender_faction)
		--polos_house.Set_Cannot_Be_Killed(true)
		--Add_Radar_Blip(polos_house, "senator_polo_blip")
	end
	
	for i,bothan_resistor in pairs(bothan_resistor_list) do
		bothan_resistor.Change_Owner(defender_faction)
	end
	
end





function Thread_DeathMonitor_Hero(local_hero)
	while TestValid(local_hero) do
		Sleep(3)
	end
	--hero klled end misisonin loss
	Story_Event("Bothawui_Intimidation_Player_Loses_AI_NOTIFICATION")
end

function State_Bothawui_Intimidation_FAIL_OBJECTIVE_Tyber_Must_Survive(message)
	if message == OnEnter then
		--lose dialog is over..determine who actually won.
			rebel_list = Find_All_Objects_Of_Type(rebel)
			empire_list = Find_All_Objects_Of_Type(empire)
			hutt_list = Find_All_Objects_Of_Type(hutts)
			
			if TestValid(rebel_list[1]) then
				Story_Event("VICTORY_REBEL")
			end
			
			if TestValid(empire_list[1]) then
				Story_Event("VICTORY_EMPIRE")
			end
			
			if TestValid(hutt_list[1]) then
				Story_Event("VICTORY_HUTTS")
			end
			
	end
end









function PROX_Senator_Polo(prox_obj, trigger_obj)
	--if trigger_obj.Get_Type().Get_Name() == "TYBER_ZANN" then -- make this a faction based trigger xxxx
	if trigger_obj.Get_Owner() == underworld then
		if not trigger_obj.Is_Ability_Active("STEALTH") then
			prox_obj.Cancel_Event_Object_In_Range(PROX_Senator_Polo)
			
			if flag_polo_has_fled == false then
				Create_Thread("Thread_Senator_Polo_Flees")
				flag_polo_has_fled = true
			end
		end

	end
end

function Thread_Senator_Polo_Flees()
	--player is near senator polo...make him run into his house
	senator_polo.Suspend_Locomotor(false)
	polo_flee = Find_Hint("MARKER_GENERIC_RED", "polo-flee")
	BlockOnCommand(senator_polo.Move_To(polo_flee))
	
	polo_hide_spot = Find_Hint("MARKER_GENERIC_RED", "polo-hide-spot")
	senator_polo.Teleport(polo_hide_spot)
	senator_polo.Suspend_Locomotor(true)
	senator_polo.Hide(true)
	--Add_Radar_Blip(senator_polo, "senator_polo_blip")
	Remove_Radar_Blip("senator_polo_blip")
	senator_polo.Highlight(false)
	--MessageBox("Senator polo is now hiding...destroy his house to make him come out and play")
	
	Story_Event("Bothawui_Intimidation_Senator_Is_Hiding_AI_NOTIFICATION")
	polos_house.Set_Cannot_Be_Killed(false)
	
	Add_Radar_Blip(polos_house, "polos_house_blip")
	polos_house.Highlight(true, 50)
	
	
end

function Thread_DeathMonitor_Palace(local_polos_house)

	while (true) do
		local senator_polos_house_health = local_polos_house.Get_Hull()
		
		if senator_polos_house_health < 0.99 then
			if flag_polo_has_fled == false then
				Create_Thread("Thread_Senator_Polo_Flees")
				flag_polo_has_fled = true
			end
			break
		end
		
		Sleep(1)
	end
	
	while TestValid(local_polos_house) do
		Sleep(3)
	end
	--hero klled end misisonin loss
	Story_Event("Bothawui_Intimidation_Palace_Is_Destroyed_AI_NOTIFICATION")
	
	senator_polo.Hide(false)
	senator_polo.Suspend_Locomotor(false)
	senator_polo.Make_Invulnerable(false)
	senator_polo.Teleport(polo_flee)
	flag_find_nearest = Find_Hint("MARKER_GENERIC_RED", "flag-find-nearest")
	
	closest_unit = Find_Nearest(flag_find_nearest, defending_faction, true)
	--senator polo needs to run somewhere here
	
	senator_polo.Move_To(flag_find_nearest)
	
	Add_Radar_Blip(senator_polo, "senator_polo_blip")
	--Remove_Radar_Blip("senator_polo_blip")
	senator_polo.Highlight(true)
	
	
	--Register_Prox(senator_polo,PROX_Senator_Polo_vs_Tyber,100,underworld)
	Create_Thread("Thread_Senator_Damage_Monitor")
end

function PROX_Senator_Polo_vs_Tyber(prox_obj, trigger_obj)
	if trigger_obj.Get_Type().Get_Name() == "TYBER_ZANN" then 
	--if trigger_obj.Get_Owner() == underworld then
		prox_obj.Cancel_Event_Object_In_Range(PROX_Senator_Polo_vs_Tyber)
		
		--Create_Thread("Thread_Senator_Polo_Flees")
		
		
		

		

	end
end

function Thread_Senator_Damage_Monitor()
	while (true) do
	
			local senator_polo_health = senator_polo.Get_Hull()
			
			if senator_polo_health <= 0.25 then
			
				rebel_list = Find_All_Objects_Of_Type(rebel)
				empire_list = Find_All_Objects_Of_Type(empire)
				hutt_list = Find_All_Objects_Of_Type(hutts)
				
				--make shaaks neutral to map owner
				if TestValid(rebel_list[1]) then
					rebel.Make_Ally(underworld)
					underworld.Make_Ally(rebel)
				end
				
				if TestValid(empire_list[1]) then
					empire.Make_Ally(underworld)
					underworld.Make_Ally(empire)
				end
				
				if TestValid(hutt_list[1]) then
					hutts.Make_Ally(underworld)
					underworld.Make_Ally(hutts)
				end
				
				Suspend_AI(1)
				Lock_Controls(1)
			
				Story_Event("Bothawui_Intimidation_Player_Wins_AI_NOTIFICATION")
				break
			
			end
	
	
	
	
		Sleep(3)
		
	end
end



-- ************************************************************************
-- ***********************INTRO CINEMATIC FUNCTION*************************
-- ************************************************************************
-- make only minor tweaks to the script below... --
function Story_Handle_Esc()
	if current_cinematic_thread ~= nil then
		Thread.Kill(current_cinematic_thread)
		current_cinematic_thread = nil
		Create_Thread("End_Camera")
	end
end


function Intro_Cinematic ()	
	Suspend_AI(1)
	
	

	if not TestValid(hero) then	
		MessageBox("Bothawui_Intimidation opening cine cannot find any heroes...aborting mission")
		ScriptExit()
	end
	
	Point_Camera_At(hero)
	
	
	
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Letter_Box_In(0)	
	Fade_Screen_In(2)
	
	Transition_Cinematic_Camera_Key(hero, 0, 50, 25, 45, 1, 1, 1, 0)
	Transition_Cinematic_Target_Key(hero, 0, 0, 0, 7, 0, urai, 0, 0)
	--Sleep(7)
	
	Transition_Cinematic_Camera_Key(hero, 5, 50, 25, 135, 1, 1, 1, 0)
	
	Sleep(4.5)
	
	while camera_offset > 0 do
		camera_offset = camera_offset + 90
		Transition_Cinematic_Camera_Key(hero, 5, 50, 25, camera_offset, 1, 1, 1, 0)
		
		if camera_offset == 315 then
			camera_offset = -45
		end
		
		Sleep(4.5)
	end
	
	current_cinematic_thread = nil
	Create_Thread("End_Camera")
end

function End_Camera()
	Point_Camera_At(hero)
	
	-- 9/19/06 JAC - We need this even if we're not doing a cinematic intro
	-- otherwise the Master Volume will be stuck at 0
	Start_Cinematic_Camera()
	End_Cinematic_Camera()
	Letter_Box_Out(0) 
	
	Lock_Controls(0)
	Fade_Screen_In(1)
	
	Suspend_AI(0)
	Story_Event("Bothawui_Intimidation_Mission_Start_AI_NOTIFICATION")
end

-- ##########################################################################################
function JoeMessage(...)
	--JoeMessage("current current_spawn_times  is %d", current_spawn_times)
	_CustomScriptMessage("JoeLog.txt", string.format(unpack(arg)))
end