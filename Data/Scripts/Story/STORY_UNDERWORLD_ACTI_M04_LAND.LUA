-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_ActI_M04_LAND.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_ActI_M04_LAND.lua $
--
--    Original Author: Jeff_Stewart
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

require("JGS_FunctionLib") -- added library of commonly used functions
require("PGSpawnUnits")
require("PGStoryMode")

function Definitions()
	--MessageBox("Defined")
	StoryModeEvents = 
	{
		Underworld_A01M04_Begin = State_Underworld_A01M04_Begin,
		Mission_4_Chatter_Dialog_00_Speech_Done = State_Mission_4_Chatter_Dialog_00_Speech_Done,
		Mission_4_Chatter_Dialog_01_Speech_Done = State_Mission_4_Chatter_Dialog_01_Speech_Done,
		Mission_4_Chatter_Dialog_02_Speech_Done = State_Mission_4_Chatter_Dialog_02_Speech_Done,
		Mission_4_Chatter_Dialog_03_Speech_Done = State_Mission_4_Chatter_Dialog_03_Speech_Done,
		Mission_4_Chatter_Dialog_04_Speech_Done = State_Mission_4_Chatter_Dialog_04_Speech_Done,
		Mission_4_Chatter_Dialog_05_Speech_Done = State_Mission_4_Chatter_Dialog_05_Speech_Done,
		Mission_4_Chatter_Dialog_06_Speech_Done = State_Mission_4_Chatter_Dialog_06_Speech_Done,
		Mission_4_Chatter_Dialog_07_Speech_Done = State_Mission_4_Chatter_Dialog_07_Speech_Done,
		Mission_4_Chatter_Dialog_08_Speech_Done = State_Mission_4_Chatter_Dialog_08_Speech_Done,
		Mission_4_Chatter_Dialog_09_Speech_Done = State_Mission_4_Chatter_Dialog_09_Speech_Done,
		Mission_4_Chatter_Dialog_10_Speech_Done = State_Mission_4_Chatter_Dialog_10_Speech_Done,
		Mission_4_Chatter_Dialog_11_Speech_Done = State_Mission_4_Chatter_Dialog_11_Speech_Done,
		Mission_4_Chatter_Dialog_12_Speech_Done = State_Mission_4_Chatter_Dialog_12_Speech_Done,
		Mission_4_Chatter_Dialog_13_Speech_Done = State_Mission_4_Chatter_Dialog_13_Speech_Done,
		Mission_4_Chatter_Dialog_14_Speech_Done = State_Mission_4_Chatter_Dialog_14_Speech_Done,
		Mission_4_Chatter_Dialog_15_Speech_Done = State_Mission_4_Chatter_Dialog_15_Speech_Done,
		Mission_4_Chatter_Dialog_16_Speech_Done = State_Mission_4_Chatter_Dialog_16_Speech_Done,
		Mission_4_Chatter_Dialog_17_Speech_Done = State_Mission_4_Chatter_Dialog_17_Speech_Done,
		Mission_4_Chatter_Dialog_18_Speech_Done = State_Mission_4_Chatter_Dialog_18_Speech_Done,
		Mission_4_Chatter_Dialog_19_Speech_Done = State_Mission_4_Chatter_Dialog_19_Speech_Done,
		Mission_4_Chatter_Dialog_20_Speech_Done = State_Mission_4_Chatter_Dialog_20_Speech_Done,
		Mission_4_Chatter_Dialog_21_Speech_Done = State_Mission_4_Chatter_Dialog_21_Speech_Done,
		Mission_4_Chatter_Dialog_22_Speech_Done = State_Mission_4_Chatter_Dialog_22_Speech_Done,
		Mission_4_Chatter_Dialog_23_Speech_Done = State_Mission_4_Chatter_Dialog_23_Speech_Done,
		Mission_4_Chatter_Dialog_24_Speech_Done = State_Mission_4_Chatter_Dialog_24_Speech_Done,
		Mission_4_Chatter_Dialog_25_Speech_Done = State_Mission_4_Chatter_Dialog_25_Speech_Done,
		Mission_4_Chatter_Dialog_26_Speech_Done = State_Mission_4_Chatter_Dialog_26_Speech_Done,
		Mission_4_Chatter_Dialog_27_Speech_Done = State_Mission_4_Chatter_Dialog_27_Speech_Done,
		Mission_4_Chatter_Dialog_28_Speech_Done = State_Mission_4_Chatter_Dialog_28_Speech_Done,
		Mission_4_Chatter_Dialog_29_Speech_Done = State_Mission_4_Chatter_Dialog_29_Speech_Done,
		Mission_4_Chatter_Dialog_30_Speech_Done = State_Mission_4_Chatter_Dialog_30_Speech_Done,
		Mission_4_Chatter_Dialog_31_Speech_Done = State_Mission_4_Chatter_Dialog_31_Speech_Done,
		Mission_4_Chatter_Dialog_32_Speech_Done = State_Mission_4_Chatter_Dialog_32_Speech_Done,
		Mission_4_Chatter_Dialog_33_Speech_Done = State_Mission_4_Chatter_Dialog_33_Speech_Done,
		Mission_4_Chatter_Dialog_34_Speech_Done = State_Mission_4_Chatter_Dialog_34_Speech_Done,
		Mission_4_Chatter_Dialog_35_Speech_Done = State_Mission_4_Chatter_Dialog_35_Speech_Done,
		Mission_4_Chatter_Dialog_36_Speech_Done = State_Mission_4_Chatter_Dialog_36_Speech_Done,
		Mission_4_Chatter_Dialog_37_Speech_Done = State_Mission_4_Chatter_Dialog_37_Speech_Done,
		Mission_4_Chatter_Dialog_38_Speech_Done = State_Mission_4_Chatter_Dialog_38_Speech_Done,
		Mission_4_Chatter_Dialog_39_Speech_Done = State_Mission_4_Chatter_Dialog_39_Speech_Done,
		Mission_4_Chatter_Dialog_40_Speech_Done = State_Mission_4_Chatter_Dialog_40_Speech_Done,
		Mission_4_Chatter_Dialog_41_Speech_Done = State_Mission_4_Chatter_Dialog_41_Speech_Done,
		Mission_4_Chatter_Dialog_42_Speech_Done = State_Mission_4_Chatter_Dialog_42_Speech_Done,
		Mission_4_Chatter_Dialog_43_Speech_Done = State_Mission_4_Chatter_Dialog_43_Speech_Done,
		Mission_4_Chatter_Dialog_44_Speech_Done = State_Mission_4_Chatter_Dialog_44_Speech_Done,
		Mission_4_Chatter_Dialog_45_Speech_Done = State_Mission_4_Chatter_Dialog_45_Speech_Done,
		Mission_4_Chatter_Dialog_46_Speech_Done = State_Mission_4_Chatter_Dialog_46_Speech_Done,
		Mission_4_Chatter_Dialog_47_Speech_Done = State_Mission_4_Chatter_Dialog_47_Speech_Done,
		Mission_4_Chatter_Dialog_48_Speech_Done = State_Mission_4_Chatter_Dialog_48_Speech_Done,
		Mission_4_Chatter_Dialog_49_Speech_Done = State_Mission_4_Chatter_Dialog_49_Speech_Done,
		Mission_4_Chatter_Dialog_50_Speech_Done = State_Mission_4_Chatter_Dialog_50_Speech_Done,
		Mission_4_Chatter_Dialog_51_Speech_Done = State_Mission_4_Chatter_Dialog_51_Speech_Done,
		Mission_4_Chatter_Dialog_52_Speech_Done = State_Mission_4_Chatter_Dialog_52_Speech_Done,
		Mission_4_Chatter_Dialog_53_Speech_Done = State_Mission_4_Chatter_Dialog_53_Speech_Done,
		Mission_4_Chatter_Dialog_54_Speech_Done = State_Mission_4_Chatter_Dialog_54_Speech_Done,
		Mission_4_Chatter_Dialog_55_Speech_Done = State_Mission_4_Chatter_Dialog_55_Speech_Done,
		Mission_4_Chatter_Dialog_56_Speech_Done = State_Mission_4_Chatter_Dialog_56_Speech_Done,
		Mission_4_Chatter_Dialog_57_Speech_Done = State_Mission_4_Chatter_Dialog_57_Speech_Done,
		Mission_4_Chatter_Dialog_58_Speech_Done = State_Mission_4_Chatter_Dialog_58_Speech_Done,
		Mission_4_Chatter_Dialog_59_Speech_Done = State_Mission_4_Chatter_Dialog_59_Speech_Done,
		Mission_4_Chatter_Dialog_60_Speech_Done = State_Mission_4_Chatter_Dialog_60_Speech_Done,
		Mission_4_Chatter_Dialog_61_Speech_Done = State_Mission_4_Chatter_Dialog_61_Speech_Done,
		Mission_4_Chatter_Dialog_62_Speech_Done = State_Mission_4_Chatter_Dialog_62_Speech_Done,
		Mission_4_Chatter_Dialog_63_Speech_Done = State_Mission_4_Chatter_Dialog_63_Speech_Done,
		Mission_4_Chatter_Dialog_64_Speech_Done = State_Mission_4_Chatter_Dialog_64_Speech_Done,
		Mission_4_Chatter_Dialog_65_Speech_Done = State_Mission_4_Chatter_Dialog_65_Speech_Done
	}
end


function State_Underworld_A01M04_Begin(message)
		if message == OnEnter then
			--- begin xml kickback vars
			State_Mission_4_Chatter_Dialog_00_Done = false
			State_Mission_4_Chatter_Dialog_01_Done = false
			State_Mission_4_Chatter_Dialog_02_Done = false
			State_Mission_4_Chatter_Dialog_03_Done = false
			State_Mission_4_Chatter_Dialog_04_Done = false
			State_Mission_4_Chatter_Dialog_05_Done = false
			State_Mission_4_Chatter_Dialog_06_Done = false
			State_Mission_4_Chatter_Dialog_07_Done = false
			State_Mission_4_Chatter_Dialog_08_Done = false
			State_Mission_4_Chatter_Dialog_09_Done = false
			State_Mission_4_Chatter_Dialog_10_Done = false
			State_Mission_4_Chatter_Dialog_11_Done = false
			State_Mission_4_Chatter_Dialog_12_Done = false
			State_Mission_4_Chatter_Dialog_13_Done = false
			State_Mission_4_Chatter_Dialog_14_Done = false
			State_Mission_4_Chatter_Dialog_15_Done = false
			State_Mission_4_Chatter_Dialog_16_Done = false
			State_Mission_4_Chatter_Dialog_17_Done = false
			State_Mission_4_Chatter_Dialog_18_Done = false
			State_Mission_4_Chatter_Dialog_19_Done = false
			State_Mission_4_Chatter_Dialog_20_Done = false
			State_Mission_4_Chatter_Dialog_21_Done = false
			State_Mission_4_Chatter_Dialog_22_Done = false
			State_Mission_4_Chatter_Dialog_23_Done = false
			State_Mission_4_Chatter_Dialog_24_Done = false
			State_Mission_4_Chatter_Dialog_25_Done = false
			State_Mission_4_Chatter_Dialog_26_Done = false
			State_Mission_4_Chatter_Dialog_27_Done = false
			State_Mission_4_Chatter_Dialog_28_Done = false
			State_Mission_4_Chatter_Dialog_29_Done = false
			State_Mission_4_Chatter_Dialog_30_Done = false
			State_Mission_4_Chatter_Dialog_31_Done = false
			State_Mission_4_Chatter_Dialog_32_Done = false
			State_Mission_4_Chatter_Dialog_33_Done = false
			State_Mission_4_Chatter_Dialog_34_Done = false
			State_Mission_4_Chatter_Dialog_35_Done = false
			State_Mission_4_Chatter_Dialog_36_Done = false
			State_Mission_4_Chatter_Dialog_37_Done = false
			State_Mission_4_Chatter_Dialog_38_Done = false
			State_Mission_4_Chatter_Dialog_39_Done = false
			State_Mission_4_Chatter_Dialog_40_Done = false
			State_Mission_4_Chatter_Dialog_41_Done = false
			State_Mission_4_Chatter_Dialog_42_Done = false
			State_Mission_4_Chatter_Dialog_43_Done = false
			State_Mission_4_Chatter_Dialog_44_Done = false
			State_Mission_4_Chatter_Dialog_45_Done = false
			State_Mission_4_Chatter_Dialog_46_Done = false
			State_Mission_4_Chatter_Dialog_47_Done = false
			State_Mission_4_Chatter_Dialog_48_Done = false
			State_Mission_4_Chatter_Dialog_49_Done = false
			State_Mission_4_Chatter_Dialog_50_Done = false
			State_Mission_4_Chatter_Dialog_51_Done = false
			State_Mission_4_Chatter_Dialog_52_Done = false
			State_Mission_4_Chatter_Dialog_53_Done = false
			State_Mission_4_Chatter_Dialog_54_Done = false
			State_Mission_4_Chatter_Dialog_55_Done = false
			State_Mission_4_Chatter_Dialog_56_Done = false
			State_Mission_4_Chatter_Dialog_57_Done = false
			State_Mission_4_Chatter_Dialog_58_Done = false
			State_Mission_4_Chatter_Dialog_59_Done = false
			State_Mission_4_Chatter_Dialog_60_Done = false
			State_Mission_4_Chatter_Dialog_61_Done = false
			State_Mission_4_Chatter_Dialog_62_Done = false
			State_Mission_4_Chatter_Dialog_63_Done = false
			State_Mission_4_Chatter_Dialog_64_Done = false
			State_Mission_4_Chatter_Dialog_65_Done = false
		
			--- end xml kickback vars
			--MessageBox("Started")
			neutral_player = Find_Player("Neutral")
			empire_player = Find_Player("Empire")
			pirate_player = Find_Player("Pirates")
			hostile_player = Find_Player("Hostile")
			underworld_player = Find_Player("Underworld")
			
			PadsCaptured = 0
			
			firstdroid = Find_Hint("UM02_DROID_CRATE", "firstdroid")
			Register_Death_Event(firstdroid, Seen_Droids)
			
			outsidehatch1 = Find_Hint("GENERIC_MARKER_LAND", "outsidehatch1")
			outsidehatch2 = Find_Hint("GENERIC_MARKER_LAND", "outsidehatch2")
			-- end cinematic stuff
			
			troops1 = Find_Hint("STORY_TRIGGER_ZONE", "troops1")
			troops2 = Find_Hint("STORY_TRIGGER_ZONE", "troops2")
			troops3 = Find_Hint("STORY_TRIGGER_ZONE", "troops3")
			
			doorguard1 = Find_Hint("STORY_TRIGGER_ZONE", "doorguard1")
			doorguard2 = Find_Hint("STORY_TRIGGER_ZONE", "doorguard2")
			doorguard3 = Find_Hint("STORY_TRIGGER_ZONE", "doorguard3")
			doorguard4 = Find_Hint("STORY_TRIGGER_ZONE", "doorguard4")
			
			endjabbaspawn = Find_Hint("STORY_TRIGGER_ZONE", "endjabbaspawn")
			endtyberspawn = Find_Hint("STORY_TRIGGER_ZONE", "endtyberspawn")
			enduraispawn = Find_Hint("STORY_TRIGGER_ZONE", "enduraispawn")
			endbosskspawn = Find_Hint("STORY_TRIGGER_ZONE", "endbosskspawn")
			endcamstart = Find_Hint("STORY_TRIGGER_ZONE", "endcamstart")
			deadguys1 = Find_Hint("STORY_TRIGGER_ZONE", "deadguys1")
			deadguys2 = Find_Hint("STORY_TRIGGER_ZONE", "deadguys2")
			deadguys3 = Find_Hint("STORY_TRIGGER_ZONE", "deadguys3")
			deadguys4 = Find_Hint("STORY_TRIGGER_ZONE", "deadguys4")
			deadguys5 = Find_Hint("STORY_TRIGGER_ZONE", "deadguys5")
			deadguys6 = Find_Hint("STORY_TRIGGER_ZONE", "deadguys6")
			wreck1 = Find_Hint("STORY_TRIGGER_ZONE", "wreck1")
			wreck2 = Find_Hint("STORY_TRIGGER_ZONE", "wreck2")
			wreck3 = Find_Hint("STORY_TRIGGER_ZONE", "wreck3")
			
			-- mid cinematic stuff

			bossktalk = Find_Hint("STORY_TRIGGER_ZONE", "bossktalk")
			tybertalk = Find_Hint("STORY_TRIGGER_ZONE", "tybertalk")
			uraitalk = Find_Hint("STORY_TRIGGER_ZONE", "uraitalk")
			jabbaguard1 = Find_Hint("STORY_TRIGGER_ZONE", "jabbaguard1")
			jabbaguard2 = Find_Hint("STORY_TRIGGER_ZONE", "jabbaguard2")
			jg1spot = Find_Hint("STORY_TRIGGER_ZONE", "jabbaguard1goto")
			jg2spot = Find_Hint("STORY_TRIGGER_ZONE", "jabbaguard2goto")
			jabbacam = Find_Hint("STORY_TRIGGER_ZONE", "jabbacam")
			jabbadoor = Find_Hint("UM02_MAGNETICALLY_SEALED_DOORWAY", "door1")
			jabbaspot = Find_Hint("STORY_TRIGGER_ZONE", "jabbadoor")
			jabbaspawn = Find_Hint("STORY_TRIGGER_ZONE", "jabbaspawn")
			uraispot = Find_Hint("GENERIC_MARKER_LAND", "factorycontrols")
			uraimove = Find_Hint("STORY_TRIGGER_ZONE", "uraimove")
			station = Find_Hint("DROID_INTERFACE_STATION", "station")
			bossk_spawn = Find_Hint("STORY_TRIGGER_ZONE", "spawnbossk")
			bossk_goto = Find_Hint("STORY_TRIGGER_ZONE", "bosskgoto")
			midcine_tyber = Find_Hint("STORY_TRIGGER_ZONE", "midcine-tyber")
	
			pad1 = Find_Hint("REINFORCEMENT_POINT", "pad1")
			pad2 = Find_Hint("REINFORCEMENT_POINT", "pad2")
			pad3 = Find_Hint("REINFORCEMENT_POINT", "pad3")
			pad4 = Find_Hint("REINFORCEMENT_POINT", "pad4")

			console1 = Find_Hint("UM02_INTERFACE_NODE", "console1")
			Register_Death_Event(console1, HatchOne)
			door1 = Find_Hint("GENERIC_MARKER_LAND", "door1")
			
			console2 = Find_Hint("UM02_INTERFACE_NODE", "console2")
			Register_Death_Event(console2, HatchTwo)
			door2 = Find_Hint("GENERIC_MARKER_LAND", "door2")
			
			spawn = Find_Hint("GENERIC_MARKER_LAND", "genericspawn")
			
			--tyber_zann = Find_Nearest(pad1,"TYBER_ZANN")
			--Register_Death_Event(tyber_zann, Tyber_Destroyed)
			urai_fen = Find_Nearest(pad1,"URAI_FEN")
			Register_Death_Event(urai_fen, Urai_Destroyed)
			
			-- Register prox events for battle chatter and game events
			chatter1 = Find_Hint("GENERIC_MARKER_LAND","chatterbadfeeling")
			Register_Prox(chatter1, Prox_Chatter_BadFeeling, 75, underworld_player)
			
			startdroidsa=Find_Hint("GENERIC_MARKER_LAND","startdestroyerdroidsa")
			Register_Prox(startdroidsa, Prox_StartDestroyers_A, 100, underworld_player)

			startdroidsb=Find_Hint("GENERIC_MARKER_LAND","startdestroyerdroidsb")
			Register_Prox(startdroidsb, Prox_StartDestroyers_B, 100, underworld_player)

			seescontrols=Find_Hint("GENERIC_MARKER_LAND","seencontrols")
			Register_Prox(seescontrols, Prox_HintAtControls, 135, underworld_player)

			gotcontrols=Find_Hint("GENERIC_MARKER_LAND","factorycontrols")
			Register_Prox(gotcontrols, Prox_UseControls, 75, underworld_player)
			Register_Prox(gotcontrols, Prox_UseControls_Wrong, 60, underworld_player)
			
			droidworksloc=Find_Hint("GENERIC_MARKER_LAND","droidworksloc")
			Register_Prox(droidworksloc, Prox_CapturedDroidWorks, 75, underworld_player)
			
			droidworks=Find_Hint("U_GROUND_DROID_WORKS","droidworks")
			Register_Death_Event(droidworks, DroidWorks_Destroyed)

			-- set up some global mission state flags
			
			MissionPartOneStarted = false
			MissionPartTwoStarted = false
			MissionPartTwoSetup = true
			
			PadOneCaptured = false
			PadTwoCaptured = false
			PadThreeCaptured = false
			PadFourCaptured = false
			
			VictoryCondition_DroidWorks = false
			VictoryCondition_LandingPads = false
			
			DefeatCondition_TyberDead = false
			DefeatCondition_UraiDead = false
			DefeatCondition_DroidWorksDead = false
			DefeatCondition_BosskDead = false
			
			VictoryStarted = false
			DefeatStarted = false
			
			current_cine_id = nil
			CINE_Intro_Active = false
			CINE_Mid_Active = false
			CINE_End_Active = false
			
			underworld_player.Disable_Bombing_Run(false)
			
			-- finds all conveyor belts and deactivates them
			conv_list = Find_All_Objects_Of_Type("UM02_CONVEYOR")
			for k, unit in pairs(conv_list) do
				if TestValid(unit) then
					unit.Play_Animation("idle", true, 1)
				end
			end
			
			Create_Thread("Main")
			current_cine_id = Create_Thread("CINE_Start_Mission")
			Allow_Localized_SFX(true)
			
		elseif message == OnUpdate then
		elseif message == OnExit then 
			--Do Nothing
		end
end

function Main()
	while true do
			--Do Nothing
			if MissionPartTwoStarted then
				if MissionPartTwoSetup then
					MissionPartTwoSetup = false
					Mid_Mission_Setup()
				end
				
				if VictoryCondition_DroidWorks and VictoryCondition_LandingPads then
					if not VictoryStarted then
						VictoryStarted = true
						if not DefeatStarted then
							current_cine_id = Create_Thread("EndMissionVictory")
						end
					end
				end
			end
			if DefeatCondition_TyberDead or DefeatCondition_UraiDead or DefeatCondition_DroidWorksDead or DefeatCondition_BosskDead then
				if not DefeatStarted then
					DefeatStarted = true
					Create_Thread("EndMissionDefeat")
				end
			end
		Sleep(.5)
	end
end
			
function FalseVictory()
	if not VictoryStarted then
		VictoryStarted = true
		if not DefeatStarted then
			current_cine_id = Create_Thread("EndMissionVictory")
		end
	end
end


function HatchOne()
	InsideHatchOne = false
	Register_Prox(door1, Prox_InsideHatchOneA, 85, underworld_player)
	Create_Thread("CloseHatchOne")
end

function CloseHatchOne()
	while InsideHatchOne == true do
		InsideHatchOne = false
		Sleep(2)
	end
	door1.Cancel_Event_Object_In_Range(Prox_InsideHatchOneA)
	Register_Prox(door1, Prox_InsideHatchOneB, 70, empire_player)
	anim1 = Create_Generic_Object("UM05_MOVING_DOOR", door1.Get_Position(), neutral_player)
	anim1.Teleport_And_Face(door1)
	anim1.Play_Animation("Cinematic",false,3)
	Sleep(2)
	anim1.Despawn()
	lock_anim1 = Create_Generic_Object("UM02_KILLABLE_DOOR", spawn.Get_Position(), underworld_player)
	lock_anim1.Teleport_And_Face(spawn)
	lock_anim1.Teleport_And_Face(door1)
	lock_anim1.Set_Selectable(false)
	door1.Cancel_Event_Object_In_Range(Prox_InsideHatchOneB)
end
function Prox_InsideHatchOneA(self_obj, trigger_obj)
	if trigger_obj.Get_Owner() == underworld_player then 
		InsideHatchOne = true
	end
end
function Prox_InsideHatchOneB(self_obj, trigger_obj)
	if trigger_obj.Get_Owner() == empire_player then 
		trigger_obj.Take_Damage(50000)
	end
end

function HatchTwo()
	InsideHatchTwo = false
	Register_Prox(door2, Prox_InsideHatchTwoA, 85, underworld_player)
	Create_Thread("CloseHatchTwo")
end

function CloseHatchTwo()
	while InsideHatchTwo == true do
		InsideHatchTwo = false
		Sleep(2)
	end
	door2.Cancel_Event_Object_In_Range(Prox_InsideHatchTwoA)
	Register_Prox(door2, Prox_InsideHatchTwoB, 70, empire_player)
	anim2 = Create_Generic_Object("UM05_MOVING_DOOR", door2.Get_Position(), neutral_player)
	anim2.Teleport_And_Face(door2)
	anim2.Play_Animation("Cinematic",false,3)
	Sleep(2)
	anim2.Despawn()
	lock_anim2 = Create_Generic_Object("UM02_KILLABLE_DOOR", spawn.Get_Position(), underworld_player)
	lock_anim2.Teleport_And_Face(spawn)
	lock_anim2.Teleport_And_Face(door2)
	lock_anim2.Set_Selectable(false)
	door2.Cancel_Event_Object_In_Range(Prox_InsideHatchTwoB)
end
function Prox_InsideHatchTwoA(self_obj, trigger_obj)
	if trigger_obj.Get_Owner() == underworld_player then 
		InsideHatchTwo = true
	end
end
function Prox_InsideHatchTwoB(self_obj, trigger_obj)
	if trigger_obj.Get_Owner() == empire_player then 
		trigger_obj.Take_Damage(50000)
	end
end

-- delay a short time and then start the game
function CINE_Start_Mission()
	Cancel_Fast_Forward()
	CINE_Intro_Active = true
	Suspend_AI(1)
	Lock_Controls(1)
	Fade_Screen_Out(0)
	Letter_Box_In(0)
	Start_Cinematic_Camera()	
	
	tyber_zann = Find_Nearest(pad1,"TYBER_ZANN_PASSENGER")
	Register_Death_Event(tyber_zann, Tyber_Destroyed)
	tyberstart = Find_Hint("STORY_TRIGGER_ZONE","tyber")
	tyber_zann.Teleport_And_Face(tyberstart)
	
	intro_landing = Find_Hint("STORY_TRIGGER_ZONE_00","introland")
	-- Create_Cinematic_Transport(object_type_name, player_id, transport_pos, zangle, phase_mode, anim_delta, idle_time, persist,hint)
	transport = Create_Cinematic_Transport("Underworld_Hero_Shuttle_Landing", underworld_player.Get_ID(), intro_landing, -45, 1, 1.05, 3, 0)
	transport.Attach_Particle_Effect("TRANSPORT_LANDING_DUST_VOLCANIC")
	
	--Set_Cinematic_Camera_Key(target_pos, xoffset_dist, yoffset_pitch, zoffset_yaw, angles?, attach_object, use_object_rotation, cinematic_animation)
	Set_Cinematic_Camera_Key(tyber_zann, 200, 15, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(tyber_zann, 0, 0, 0, 0, 0, 0, 0)
	
	Sleep(1)
	
	Transition_Cinematic_Camera_Key(tyber_zann, 5, 150, 10, 20, 1, 0, 0, 0)
	
	Fade_Screen_In(1)
	Sleep(6)

	Story_Event("CHATTER_49")
	Set_Cinematic_Camera_Key(tyber_zann, 53, 21, -28, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(tyber_zann, 0, 0, 16, 0, 0, 0, 0)
	--MessageBox("Insert Game Intro Cinematic Here")

	while not State_Mission_4_Chatter_Dialog_49_Done do Sleep(.5) end

	if TestValid(transport) then
		transport.Despawn()
	end
	Story_Event("CHATTER_50")
	Set_Cinematic_Camera_Key(urai_fen, 53, 18, 135, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(urai_fen, 0, 0, 17, 0, 0, 0, 0)
	
	while not State_Mission_4_Chatter_Dialog_50_Done do Sleep(.5) end

	Story_Event("CHATTER_51")
	Set_Cinematic_Camera_Key(tyber_zann, 53, 21, -28, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(tyber_zann, 0, 0, 16, 0, 0, 0, 0)
	while not State_Mission_4_Chatter_Dialog_51_Done do Sleep(.5) end
	
	Story_Event("CHATTER_52")
	Set_Cinematic_Camera_Key(urai_fen, 53, 18, 135, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(urai_fen, 0, 0, 17, 0, 0, 0, 0)
	while not State_Mission_4_Chatter_Dialog_52_Done do Sleep(.5) end
	
	Story_Event("CHATTER_53")
	Set_Cinematic_Camera_Key(tyber_zann, 53, 21, -28, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(tyber_zann, 0, 0, 16, 0, 0, 0, 0)
	while not State_Mission_4_Chatter_Dialog_53_Done do Sleep(.5) end
	
	Story_Event("CHATTER_54")
	Set_Cinematic_Camera_Key(urai_fen, 53, 18, 135, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(urai_fen, 0, 0, 17, 0, 0, 0, 0)
	while not State_Mission_4_Chatter_Dialog_54_Done do Sleep(.5) end
	
	Fade_Screen_Out(1)
	Sleep(1)
	
	Create_Thread("IntroCineCleanup")
end

function Story_Handle_Esc()
	if CINE_Intro_Active then 
		CINE_Intro_Active = false
		Thread.Kill(current_cine_id)
		Create_Thread("IntroCineCleanup")
	end
	--if CINE_Mid_Active then 
	--	CINE_Mid_Active = false
	--	Thread.Kill(current_cine_id)
	--	Create_Thread("MidCineCleanup")
	--end
	--if CINE_End_Active then 
	--	CINE_End_Active = false
	--	Thread.Kill(current_cine_id)
	--	Create_Thread("EndCineCleanup")
	--end
end

function IntroCineCleanup()
	if TestValid(transport) then
		transport.Despawn()
	end
	
	CINE_Intro_Active = false
	
	--Stop_All_Music()
	Stop_All_Speech()
	Remove_All_Text()
	Lock_Controls(0)
	End_Cinematic_Camera()
	Letter_Box_Out(0)	
	Suspend_AI(0)
	Fade_Screen_In(1)
	Sleep(1)

	MissionPartOneStarted = true
	Story_Event("UM04_INTROCINE_DONE")
	current_cine_id = nil
	Set_Hint_At_Object(gotcontrols)
	
end

function MidCineCleanup()
	if TestValid(jabbadoor) then
		jabbadoor.Despawn()
	end
	if TestValid(jabba) then
		jabba.Despawn()
	end
	if TestValid(jguard1a) then
		jguard1a.Despawn()
	end
	if TestValid(jguard1b) then
		jguard1b.Despawn()
	end
	if TestValid(jguard2a) then
		jguard2a.Despawn()
	end
	if TestValid(jguard2b) then
		jguard2b.Despawn()
	end
	if TestValid(cineguys1) then
		cineguys1.Despawn()
	end
	if TestValid(cineguys2) then
		cineguys2.Despawn()
	end
	if TestValid(cineguys3) then
		cineguys3.Despawn()
	end
	if TestValid(bossk) then
		bossk.Teleport_And_Face(bossktalk)
	else
		bossk = Create_Generic_Object("BOSSK", bossktalk.Get_Position(), underworld_player)
	end
	if TestValid(urai_fen) then
		urai_fen.Teleport_And_Face(uraitalk)
	end
	if TestValid(tyber_zann) then
		tyber_zann.Teleport_And_Face(tybertalk)
	end
	
	bossk.Prevent_All_Fire(false)
	urai_fen.Prevent_All_Fire(false)
	urai_fen.Make_Invulnerable(false)
	tyber_zann.Prevent_All_Fire(false)
	
	Point_Camera_At(tyber_zann)
	
	guys1 = Create_Generic_Object("HUTT_POD_WALKER", troops1.Get_Position(), pirate_player)
	guys2 = Create_Generic_Object("HUTT_POD_WALKER", troops2.Get_Position(), pirate_player)
	guys3 = Create_Generic_Object("HUTT_POD_WALKER", troops3.Get_Position(), pirate_player)
	Create_Thread("Hunt_Underworld", {guys1, guys2, guys3})
	jguard1a = Create_Generic_Object("PIRATE_SOLDIER_NONSQUAD", jabbaguard1.Get_Position(), pirate_player)
	jguard1b = Create_Generic_Object("PIRATE_SOLDIER_NONSQUAD", jabbaguard1.Get_Position(), pirate_player)
	jguard2a = Create_Generic_Object("PIRATE_SOLDIER_NONSQUAD", jabbaguard2.Get_Position(), pirate_player)
	jguard2b = Create_Generic_Object("PIRATE_SOLDIER_NONSQUAD", jabbaguard2.Get_Position(), pirate_player)
	Create_Thread("Hunt_Underworld", {jguard1a, jguard2a, jguard1b, jguard2b})
	
	Stop_All_Music()
	Stop_All_Speech()
	Remove_All_Text()
	End_Cinematic_Camera()
	Letter_Box_Out(.5)	
	Lock_Controls(0)
	Suspend_AI(0)
	Fade_Screen_In(1)
	Sleep(1)
	
	MissionPartTwoStarted = true
	Story_Event("UM04_MIDCINE_DONE")
	Story_Event("UM04_HINT_BOSSK")
	current_cine_id = nil
	
	Register_Death_Event(bossk, Bossk_Destroyed)
end

function EndCineCleanup()
	Fade_Screen_Out(1)
	Sleep(1)

	if TestValid(jabba) then
		jabba.Despawn()
	end
	if TestValid(detritus1) then
		detritus1.Despawn()
	end
	if TestValid(detritus2) then
		detritus2.Despawn()
	end
	if TestValid(detritus3) then
		detritus3.Despawn()
	end
	if TestValid(detritus4) then
		detritus4.Despawn()
	end
	if TestValid(detritus5) then
		detritus5.Despawn()
	end
	if TestValid(detritus6) then
		detritus6.Despawn()
	end
	if TestValid(wreckage1) then
		wreckage1.Despawn()
	end
	if TestValid(wreckage2) then
		wreckage2.Despawn()
	end
	if TestValid(wreckage3) then
		wreckage3.Despawn()
	end
	Letter_Box_Out(1)	
	Sleep(1)
	Stop_All_Music()
	Stop_All_Speech()
	Remove_All_Text()
	End_Cinematic_Camera()
	Letter_Box_Out(0)	
	current_cine_id = nil
	
	Fade_Screen_In(1)
	Story_Event("UM04_ENDMISSION_VICTORY")
end

function Tyber_Destroyed()
	DefeatCondition_TyberDead = true
	Story_Event("UM04_TYBERDEAD")
end

function Urai_Destroyed()
	DefeatCondition_UraiDead = true
	Story_Event("UM04_URAIDEAD")
end

function DroidWorks_Destroyed()
	DefeatCondition_DroidWorksDead = true
	Story_Event("UM04_DROIDWORKSDEAD")
end

function Bossk_Destroyed()
	DefeatCondition_BosskDead = true
	Story_Event("UM04_BOSSKDEAD")
end

-- triggered when tyber exits the landing pad, to set the mood
function Prox_Chatter_BadFeeling(self_obj, trigger_obj)
	if MissionPartOneStarted then 
		-- CHATTER -- Tyber Zann: "I've got a bad feeling about this."
		if not trigger_obj then
			DebugMessage("Warning: prox received a nil trigger_obj .")
			return
		end
		tyber_distance=self_obj.Get_Distance(tyber_zann)
		if tyber_distance < 200 then 
			Story_Event("CHATTER_25")
			self_obj.Cancel_Event_Object_In_Range(Prox_Chatter_BadFeeling)
		end
	end
end

function Seen_Droids()
	Create_Thread("Talk_About_Droids")
end

function Talk_About_Droids()
	Story_Event("CHATTER_55")
	while not State_Mission_4_Chatter_Dialog_55_Done do Sleep(.5) end
	Story_Event("CHATTER_56")
	while not State_Mission_4_Chatter_Dialog_56_Done do Sleep(.5) end
	Story_Event("CHATTER_57")
	while not State_Mission_4_Chatter_Dialog_57_Done do Sleep(.5) end
	Story_Event("CHATTER_58")
	while not State_Mission_4_Chatter_Dialog_58_Done do Sleep(.5) end
	Story_Event("CHATTER_59")
	while not State_Mission_4_Chatter_Dialog_59_Done do Sleep(.5) end
	Story_Event("CHATTER_60")
	while not State_Mission_4_Chatter_Dialog_60_Done do Sleep(.5) end
	Story_Event("CHATTER_61")
end


-- triggered when the player gets close to the droid pens, which will then begin spawning droids
function Prox_StartDestroyers_A(self_obj, trigger_obj)
	if MissionPartOneStarted then 
		-- Begin producing destroyer droids
		if not trigger_obj then
			DebugMessage("Warning: prox received a nil trigger_obj .")
			return
		end
	
		droid1 = Find_Hint("GENERIC_MARKER_LAND","ddroid1")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",droid1.Get_Position(),pirate_player)
		droid2 = Find_Hint("GENERIC_MARKER_LAND","ddroid2")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",droid2.Get_Position(),pirate_player)
		droid3 = Find_Hint("GENERIC_MARKER_LAND","ddroid3")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",droid3.Get_Position(),pirate_player)
		droid4 = Find_Hint("GENERIC_MARKER_LAND","ddroid4")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",droid4.Get_Position(),pirate_player)
		droid5 = Find_Hint("GENERIC_MARKER_LAND","ddroid5")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",droid5.Get_Position(),pirate_player)
		droid6 = Find_Hint("GENERIC_MARKER_LAND","ddroid6")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",droid6.Get_Position(),pirate_player)
		droid7 = Find_Hint("GENERIC_MARKER_LAND","ddroid7")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",droid7.Get_Position(),pirate_player)
		droid8 = Find_Hint("GENERIC_MARKER_LAND","ddroid8")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",droid8.Get_Position(),pirate_player)
	
		self_obj.Cancel_Event_Object_In_Range(Prox_StartDestroyers_A)
		Create_Thread("StartMissionObjective")
	end
end

-- triggered when the player gets close to the droid pens, which will then begin spawning droids
function Prox_StartDestroyers_B(self_obj, trigger_obj)
	if MissionPartOneStarted then 
		-- Begin producing destroyer droids
		if not trigger_obj then
			DebugMessage("Warning: prox received a nil trigger_obj .")
			return
		end
		--Story_Event("CHATTER_26")
		--while not State_Mission_4_Chatter_Dialog_26_Done do Sleep(.5) end
		Story_Event("CHATTER_22")
	
		edroid1 = Find_Hint("GENERIC_MARKER_LAND","edroid1")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",edroid1.Get_Position(),pirate_player)
		edroid2 = Find_Hint("GENERIC_MARKER_LAND","edroid2")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",edroid2.Get_Position(),pirate_player)
		edroid3 = Find_Hint("GENERIC_MARKER_LAND","edroid3")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",edroid3.Get_Position(),pirate_player)
		edroid4 = Find_Hint("GENERIC_MARKER_LAND","edroid4")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",edroid4.Get_Position(),pirate_player)
		edroid5 = Find_Hint("GENERIC_MARKER_LAND","edroid5")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",edroid5.Get_Position(),pirate_player)
	
		self_obj.Cancel_Event_Object_In_Range(Prox_StartDestroyers_B)
	end
end

-- delay a short time and then display the mission objective
function StartMissionObjective()
	Sleep(2)
	Story_Event("UM04_HINT_CONTROLS")
	Story_Event("CHATTER_22")
end

-- triggered when player gets close to the droid controls for part one of the mission
function Prox_HintAtControls(self_obj, trigger_obj)
	if MissionPartOneStarted then 
		-- CHATTER -- Tyber Zann: "There are the controls!"
		if not trigger_obj then
			DebugMessage("Warning: prox received a nil trigger_obj .")
			return
		end
		Story_Event("CHATTER_23")
		self_obj.Cancel_Event_Object_In_Range(Prox_HintAtControls)
	end
end

-- triggered when the player gets urai at the controls, triggering part two
function Prox_UseControls(self_obj, trigger_obj)
	if MissionPartOneStarted then 
		if not trigger_obj then
			DebugMessage("Warning: prox received a nil trigger_obj .")
			return
		end
		urai_distance=self_obj.Get_Distance(urai_fen)
		if urai_distance < 60 then 
			self_obj.Cancel_Event_Object_In_Range(Prox_UseControls)
			self_obj.Cancel_Event_Object_In_Range(Prox_UseControls_Wrong)
			Story_Event("CHATTER_45")
			Remove_Hint_At_Object(gotcontrols)
			Create_Thread("UraiUsesControls")	
		end
	end
end

function UraiUsesControls()

	urai_fen.Set_Selectable(false)
	urai_fen.Make_Invulnerable(true)
	BlockOnCommand(urai_fen.Move_To(gotcontrols))
	Sleep(2)
	Story_Event("CHATTER_46")
	Sleep(4)

	Register_Prox(bossktalk, Prox_ClearCineArea, 150, empire_player)
	-- finds all destroyer droid spawners and deletes them
	unit_list = Find_All_Objects_Of_Type("UM02_DESTROYER_SPAWNER")
	for k, unit in pairs(unit_list) do
		if TestValid(unit) then
			unit.Despawn()
		end
	end

	-- finds all conveyor belts and deactivates them
	conv_list = Find_All_Objects_Of_Type("UM02_CONVEYOR")
	for k, unit in pairs(conv_list) do
		if TestValid(unit) then
			unit.Play_Animation("Structure Hold", true, 0)
		end
	end
	
	Create_Thread("SwitchDroids")
	
	Sleep(1)
	urai_fen.Set_Selectable(true)
	--urai_fen.Play_SFX_Event("SFX_UMP_EmpireKesselAlarm")
	Story_Event("UM04_CONTROLS_USED")
	Sleep(2)
	if not DefeatStarted then
		current_cine_id = Create_Thread("CINE_Mid_Mission")
	end
	bossktalk.Cancel_Event_Object_In_Range(Prox_ClearCineArea)
end

function SwitchDroids()
	-- finds all destroyer droids and deactivates them
	droid_list = Find_All_Objects_Of_Type("DESTROYER_DROID")
	for k, unit in pairs(droid_list) do
		if TestValid(unit) then
			newunit = Create_Generic_Object("DESTROYER_DROID",unit.Get_Position(),neutral_player)
			newunit.Teleport_And_Face(unit)
			newunit.Attach_Particle_Effect("HAN_SOLO_TARGET_STUN_EFFECT")
			unit.Take_Damage(10000)
			Sleep(.25)
		end
	end
end

-- triggered when the player gets tyber close to controls
function Prox_UseControls_Wrong(self_obj, trigger_obj)
	if MissionPartOneStarted then 
		-- CHATTER -- Tyber Zann: "I don't know how to use this thing. Urai get over here."
		if not trigger_obj then
			DebugMessage("Warning: prox received a nil trigger_obj .")
			return
		end
		tyber_distance=self_obj.Get_Distance(tyber_zann)
		if tyber_distance < 60 then 
			Story_Event("CHATTER_44")
			self_obj.Cancel_Event_Object_In_Range(Prox_UseControls_Wrong)
		end
	end
end

-- mid-mission cinematic where jabba lands and gives his best
function CINE_Mid_Mission()
	Cancel_Fast_Forward() 
	CINE_Mid_Active = true
	Story_Event("UM04_MIDCINE_BEGIN")
	
	Suspend_AI(1)
	Lock_Controls(1)
	Fade_Screen_Out(1)
	Sleep(1)
	
	Letter_Box_In(0)
	Start_Cinematic_Camera()	
	
	cineguys1 = Create_Generic_Object("HUTT_POD_WALKER", troops1.Get_Position(), neutral_player)
	cineguys2 = Create_Generic_Object("HUTT_POD_WALKER", troops2.Get_Position(), neutral_player)
	cineguys3 = Create_Generic_Object("HUTT_POD_WALKER", troops3.Get_Position(), neutral_player)
	
	tyber_zann.Teleport_And_Face(midcine_tyber)
	urai_fen.Teleport_And_Face(uraispot)
	bossk = Create_Generic_Object("BOSSK", bossk_spawn.Get_Position(), underworld_player)
	
	bossk.Prevent_All_Fire(true)
	urai_fen.Prevent_All_Fire(true)
	tyber_zann.Prevent_All_Fire(true)
	
	--Set_Cinematic_Camera_Key(target_pos, xoffset_dist, yoffset_pitch, zoffset_yaw, angles?, attach_object, use_object_rotation, cinematic_animation)
	Set_Cinematic_Camera_Key(urai_fen, 0, -20, 18, 0, 0, 0, 0)
	Set_Cinematic_Target_Key(station, 0, 0, 17, 0, 0, 0, 0)
	
	Fade_Screen_In(1)
	Sleep(1)
	
	Transition_Cinematic_Camera_Key(urai_fen, 4, 10, -20, 20, 0, 0, 0, 0)
	Story_Event("CHATTER_06")
	urai_fen.Play_Animation("cinematic", true, 0)
	while not State_Mission_4_Chatter_Dialog_06_Done do Sleep(.5) end
	urai_fen.Play_Animation("idle", true, 0)

	-- changed per lec
	--bossk.Move_To(bossk_goto)
	bossk.Teleport_And_Face(bossk_goto)
	bossk.Face_Immediate(tyber_zann)
	Sleep(.5)
	bossk.Play_Animation("attack idle", true, 0)
	Sleep(.5)
	
	--Set_Cinematic_Camera_Key(target_pos, xoffset_dist, yoffset_pitch, zoffset_yaw, angles?, attach_object, use_object_rotation, cinematic_animation)
	Set_Cinematic_Camera_Key(tyber_zann, 20, 0, 18, 0, 0, 0, 0)
	Set_Cinematic_Target_Key(bossk_goto, 0, 0, 17, 0, 0, 0, 0)
	Sleep(.5)
	--bossk.Play_Animation("talk", true, 0)

	Sleep(.5)
	tyber_zann.Play_SFX_Event("Unit_Attack_Bossk")
	Sleep(1.5)
	
	Story_Event("CHATTER_07")
	tyber_zann.Play_Animation("cinematic", true, 2)
	while not State_Mission_4_Chatter_Dialog_07_Done do Sleep(.5) end
	tyber_zann.Play_Animation("idle", true, 0)
	
	tyber_zann.Turn_To_Face(bossk)
	Sleep(.25)
	
	urai_fen.Move_To(uraimove)
	
	Story_Event("CHATTER_11")
	tyber_zann.Play_Animation("cinematic", true, 2)
	Transition_Cinematic_Camera_Key(tyber_zann, 4, 20, -16, 18, 0, 0, 0, 0)
	while not State_Mission_4_Chatter_Dialog_11_Done do Sleep(.5) end
	tyber_zann.Play_Animation("idle", true, 0)
	
	--bossk.Play_Animation("talk", true, 0)
	Story_Event("CHATTER_12")
	while not State_Mission_4_Chatter_Dialog_12_Done do Sleep(.5) end
	
	--Set_Cinematic_Camera_Key(target_pos, xoffset_dist, yoffset_pitch, zoffset_yaw, angles?, attach_object, use_object_rotation, cinematic_animation)
	Set_Cinematic_Camera_Key(bossk, 20, 0, 18, 0, 0, 0, 0)
	Set_Cinematic_Target_Key(tyber_zann, 0, 0, 16, 0, 0, 0, 0)
	Transition_Cinematic_Target_Key(tyber_zann, 3, 0, 11, 16, 0, 0, 0, 0)
	--bossk.Play_Animation("idle", true, 0)
	Story_Event("CHATTER_13")
	tyber_zann.Play_Animation("cinematic", true, 2)
	while not State_Mission_4_Chatter_Dialog_13_Done do Sleep(.5) end
	tyber_zann.Play_Animation("idle", true, 0)
	
	--Set_Cinematic_Camera_Key(target_pos, xoffset_dist, yoffset_pitch, zoffset_yaw, angles?, attach_object, use_object_rotation, cinematic_animation)
	bossk.Play_Animation("talk", true, 0)
	Set_Cinematic_Camera_Key(bossk, 15, 0, 18, 0, 0, 0, 0)
	Set_Cinematic_Target_Key(bossk, 0, 0, 17, 0, 0, 0, 0)
	
	Story_Event("CHATTER_14")
	while not State_Mission_4_Chatter_Dialog_14_Done do Sleep(.5) end
	
	bossk.Play_Animation("idle", true, 0)
	Sleep(1)
	
	jabbadoor.Take_Damage(50000)
	
	jabba = Create_Generic_Object("HUTT_CIVILIAN", jabbaspawn.Get_Position(), neutral_player)
	jabba.Prevent_AI_Usage(true)
	jabba.Prevent_All_Fire(true)
	jabba.Make_Invulnerable(true)
	jguard1a = Create_Generic_Object("PIRATE_SOLDIER_NONSQUAD", jabbaguard1.Get_Position(), neutral_player)
	jguard1b = Create_Generic_Object("PIRATE_SOLDIER_NONSQUAD", jabbaguard1.Get_Position(), neutral_player)
	jguard2a = Create_Generic_Object("PIRATE_SOLDIER_NONSQUAD", jabbaguard2.Get_Position(), neutral_player)
	jguard2b = Create_Generic_Object("PIRATE_SOLDIER_NONSQUAD", jabbaguard2.Get_Position(), neutral_player)
	jguard1a.Prevent_AI_Usage(true)
	jguard2a.Prevent_AI_Usage(true)
	jguard1b.Prevent_AI_Usage(true)
	jguard2b.Prevent_AI_Usage(true)
	jguard1a.Prevent_All_Fire(true)
	jguard2a.Prevent_All_Fire(true)
	jguard1b.Prevent_All_Fire(true)
	jguard2b.Prevent_All_Fire(true)
	jguard1a.Make_Invulnerable(true)
	jguard2a.Make_Invulnerable(true)
	jguard1b.Make_Invulnerable(true)
	jguard2b.Make_Invulnerable(true)
	
	Set_Cinematic_Camera_Key(jabbacam, 0, 0, 15, 0, 0, 0, 0)
	Set_Cinematic_Target_Key(jabba, 0, 0, 50, 0, 0, 0, 0)
	jabbacam.Play_SFX_Event("SFX_Death_Bombard")
	
	jguard1a.Move_To(jg1spot)
	jguard2a.Move_To(jg2spot)
	Sleep(1)
	jguard1b.Move_To(jg1spot)
	jguard2b.Move_To(jg2spot)
	
	jabba.Move_To(jabbaspot)
	tyber_zann.Turn_To_Face(jabba)
	urai_fen.Turn_To_Face(jabba)
	bossk.Turn_To_Face(jabba)
	
	Transition_Cinematic_Camera_Key(tybertalk, 6, 50, 0, 50, 0, 0, 0, 0)
	Transition_Cinematic_Target_Key(jabbaspot, 5, 0, 0, 0, 0, 1, 0, 0)
	
	Sleep(4)
	
	tyber_zann.Teleport_And_Face(tybertalk)
	urai_fen.Teleport_And_Face(uraitalk)
	bossk.Teleport_And_Face(bossktalk)
	tyber_zann.Turn_To_Face(jabba)
	urai_fen.Turn_To_Face(jabba)
	bossk.Turn_To_Face(jabba)
	
	Sleep(1.5)
	jabba.Stop()
	jabba.Turn_To_Face(tyber_zann)
	Sleep(.5)
	jabba.Suspend_Locomotor(true)
	
	Story_Event("CHATTER_08")
	jabba.Play_Animation("cinematic", true, 0)	
	
	jguard1a.Suspend_Locomotor(true)
	jguard1a.Turn_To_Face(tyber_zann)
	jguard2a.Suspend_Locomotor(true)
	jguard2a.Turn_To_Face(tyber_zann)
	jguard1b.Suspend_Locomotor(true)
	jguard1b.Turn_To_Face(tyber_zann)
	jguard2b.Suspend_Locomotor(true)
	jguard2b.Turn_To_Face(tyber_zann)
	--Sleep(6)
	while not State_Mission_4_Chatter_Dialog_08_Done do Sleep(.5) end
	jabba.Play_Animation("idle", true, 0)

	Set_Cinematic_Camera_Key(jabba, 50, 0, 18, 0, 0, 0, 0)
	Set_Cinematic_Target_Key(tyber_zann, 0, 0, 16, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(jabba, 5, -10, 45, 18, 0, 0, 0, 0)
	
	Story_Event("CHATTER_09")
	tyber_zann.Play_Animation("cinematic", true, 2)
	while not State_Mission_4_Chatter_Dialog_09_Done do Sleep(.5) end
	tyber_zann.Play_Animation("idle", true, 0)
	
	Set_Cinematic_Camera_Key(tyber_zann, 50, 10, 50, 0, 0, 0, 0)
	Set_Cinematic_Target_Key(jabbaspot, 0, 0, 0, 0, 1, 0, 0)
	Transition_Cinematic_Camera_Key(tyber_zann, 8, 50, -10, 40, 0, 0, 0, 0)
	
	Story_Event("CHATTER_10")
	jabba.Play_Animation("cinematic", true, 0)
	while not State_Mission_4_Chatter_Dialog_10_Done do Sleep(.5) end
	jabba.Play_Animation("idle", true, 0)
	
	jabba.Suspend_Locomotor(false)
	jguard1a.Suspend_Locomotor(false)
	jguard2a.Suspend_Locomotor(false)
	jguard1b.Suspend_Locomotor(false)
	jguard2b.Suspend_Locomotor(false)
		
	jabba.Move_To(pad2)
	
	Sleep(2)
	jguard1a.Move_To(doorguard1)
	jguard2a.Move_To(doorguard2)
	jguard1b.Move_To(doorguard3)
	jguard2b.Move_To(doorguard4)
	
	Sleep(1)
	cineguys1.Move_To(jabbaspot)
	cineguys2.Move_To(jabbaspot)
	cineguys3.Move_To(jabbaspot)
	jguard1a.Turn_To_Face(tyber_zann)
	jguard2b.Turn_To_Face(tyber_zann)
	Sleep(1)
	jguard1b.Turn_To_Face(tyber_zann)
	jguard2a.Turn_To_Face(tyber_zann)
	Sleep(3.5)
	
	Fade_Screen_Out(1)
	Sleep(1)
	
	Create_Thread("MidCineCleanup")
end

function Mid_Mission_Setup()
	-- Destroys all magnetically sealed doors
	unit_list = Find_All_Objects_Of_Type("UM02_MAGNETICALLY_SEALED_DOORWAY")
	for k, unit in pairs(unit_list) do
		if TestValid(unit) then
			unit.Take_Damage(50000)
		end
	end
	unit_list = Find_All_Objects_Of_Type("UM02_KILLABLE_DOOR")
	for k, unit in pairs(unit_list) do
		if TestValid(unit) then
			unit.Take_Damage(50000)
		end
	end
	
	--pad1.Change_Owner(pirate_player)
	
	reinforce_list = {
		"Pirate_Soldier_Squad",
		"Pirate_Plex_Squad",
		"UNDERWORLD_POD_WALKER_COMPANY"
	}

	--ReinforceList(reinforce_list, pad1, pirate_player, false, true, true, Find_And_Attack)
	ReinforceList(reinforce_list, pad2, pirate_player, false, true, true, Find_And_Attack)
	ReinforceList(reinforce_list, pad3, pirate_player, false, true, true, Find_And_Attack)
	ReinforceList(reinforce_list, pad4, pirate_player, false, true, true, Find_And_Attack)
	
	Create_Thread("MidMissionObjective")
end

function Prox_ClearCineArea(self_obj, trigger_obj)
	if trigger_obj.Get_Owner() == empire_player then
		trigger_obj.Take_Damage(50000)
	end
end


function Check_LandingPads()
	reinforce_list = {
		"Pirate_Soldier_Squad",
		"Pirate_Plex_Squad",
		"UNDERWORLD_POD_WALKER_COMPANY"
	}
	Register_Timer(JabbaGuysLand, 1)
	while not VictoryCondition_LandingPads do
		if pad1.Get_Owner() == underworld_player and not PadOneCaptured then
			PadOneCaptured = true
			PadsCaptured = PadsCaptured + 1
			Create_Thread("Captured_A_Pad")
		end
		if pad2.Get_Owner() == underworld_player and not PadTwoCaptured then
			PadTwoCaptured = true
			PadsCaptured = PadsCaptured + 1
			Create_Thread("Captured_A_Pad")
		end
		if pad3.Get_Owner() == underworld_player and not PadThreeCaptured then
			PadThreeCaptured = true
			PadsCaptured = PadsCaptured + 1
			Create_Thread("Captured_A_Pad")
		end
		if pad4.Get_Owner() == underworld_player and not PadFourCaptured then
			PadFourCaptured = true
			PadsCaptured = PadsCaptured + 1
			Create_Thread("Captured_A_Pad")
		end
		if PadOneCaptured and PadTwoCaptured and PadThreeCaptured and PadFourCaptured then
			VictoryCondition_LandingPads = true
			Story_Event("UM04_PADSCAPTURED")
		end
		Sleep(1)
	end
end

function Captured_A_Pad()
	if PadsCaptured < 1 then
	elseif PadsCaptured < 2 then
		--Sleep(1)
		--Story_Event("CHATTER_39")
		--Sleep(2)
		--Story_Event("CHATTER_40")
	elseif PadsCaptured < 3 then
		Sleep(1)
		Story_Event("CHATTER_41")
	elseif PadsCaptured < 4 then
		Sleep(1)
		Story_Event("CHATTER_39")
		while not State_Mission_4_Chatter_Dialog_39_Done do Sleep(.5) end
		Story_Event("CHATTER_42")
	elseif PadsCaptured < 5 then
		--Sleep(1)
		--Story_Event("CHATTER_43")
		--Sleep(2)
	end
end

function JabbaGuysLand ()
	randompad = GameRandom(1,4)
	if not PadOneCaptured and randompad == 1 then
		ReinforceList(reinforce_list, pad1, pirate_player, false, true, true, Find_And_Attack)
	end
	if not PadTwoCaptured and randompad == 2 then
		ReinforceList(reinforce_list, pad2, pirate_player, false, true, true, Find_And_Attack)
	end
	if not PadThreeCaptured and randompad == 3 then
		ReinforceList(reinforce_list, pad3, pirate_player, false, true, true, Find_And_Attack)
	end
	if not PadFourCaptured and randompad == 4 then
		ReinforceList(reinforce_list, pad4, pirate_player, false, true, true, Find_And_Attack)
	end
	Register_Timer(JabbaGuysLand, 45)
end

function Find_And_Attack(attack_list)
	Create_Thread("DD_Hunt_Underworld",attack_list)
end

function DD_Hunt_Underworld(attack_list)
	local enemy_player = Find_Player("Underworld")
	while true do
	  if not VictoryStarted and not DefeatStarted then
		for k, unit in pairs(attack_list) do
			if TestValid(unit) then
				if not unit.Get_Owner().Is_Human() then
					local closest_enemy = Find_Nearest(unit, enemy_player, true)	
					if  unit.Is_Ability_Ready("ROCKET_ATTACK") then
						unit.Activate_Ability("ROCKET_ATTACK", false)
					end
					unit.Attack_Move(closest_enemy)
				end
			end
		end
	  end
      Sleep(4)
	end
end

-- delay a short time and then display the mission objective
function MidMissionObjective()
	Sleep(2)
	Set_Hint_At_Object(droidworksloc)
	
	-- this creates a small timer/re-timer system that checks for victory conditions on landing pads
	Create_Thread("Check_LandingPads")
	
	Story_Event("CHATTER_28")
	while not State_Mission_4_Chatter_Dialog_28_Done do Sleep(.5) end
	Story_Event("CHATTER_29")
	Story_Event("UM04_HINT_DROIDWORKS")
	while not State_Mission_4_Chatter_Dialog_29_Done do Sleep(.5) end
	Story_Event("CHATTER_30")
	while not State_Mission_4_Chatter_Dialog_30_Done do Sleep(.5) end
	Story_Event("CHATTER_32")
	Story_Event("UM04_HINT_LANDINGPADS")
	Sleep(2)
end

-- triggered when the player gets urai at the droid works
function Prox_CapturedDroidWorks(self_obj, trigger_obj)
	if MissionPartTwoStarted then 
		if not trigger_obj then
			DebugMessage("Warning: prox received a nil trigger_obj .")
			return
		end
		urai_distance=self_obj.Get_Distance(urai_fen)
		if urai_distance < 60 then 
			self_obj.Cancel_Event_Object_In_Range(Prox_CapturedDroidWorks)
			--urai_fen.Play_SFX_Event("SFX_UMP_EmpireKesselAlarm")
			Create_Thread("UraiUsesDroidWorks")	
			Remove_Hint_At_Object(droidworksloc)
			Story_Event("UM04_DROIDWORKS_CAPTURED")
		end
	end
end

function UraiUsesDroidWorks()

	urai_fen.Set_Selectable(false)
	BlockOnCommand(urai_fen.Move_To(droidworksloc))
	Sleep(5)
	
	-- changes control of droid works to underworld player
	droidworks=Find_Hint("U_GROUND_DROID_WORKS","droidworks")
	VictoryCondition_DroidWorks = true
	droidworks.Change_Owner(underworld_player)

			-- finds all conveyor belts and deactivates them
			conv_list = Find_All_Objects_Of_Type("UM02_CONVEYOR")
			for k, unit in pairs(conv_list) do
				if TestValid(unit) then
					unit.Play_Animation("idle", true, 0)
				end
			end
			
	Sleep(1)
	urai_fen.Set_Selectable(true)
	--urai_fen.Play_SFX_Event("SFX_UMP_EmpireKesselAlarm")
	Create_Thread("ActivateDroids")
	Create_Thread("StartDroidProduction")
	Story_Event("CHATTER_47")
end

function ActivateDroids()
	-- finds all destroyer droids and "activates" them
	droid_list = Find_All_Objects_Of_Type("DESTROYER_DROID")
	for k, unit in pairs(droid_list) do
		if TestValid(unit) then
			unit.Change_Owner(underworld_player)
			unit.Attach_Particle_Effect("HAN_SOLO_TARGET_STUN_EFFECT")
			Sleep(1)
		end
	end
end

-- triggered when the player reboots the factory and now gets droids from all over
function StartDroidProduction()
	if MissionPartOneStarted and MissionPartOneStarted then 
		-- Begin producing destroyer droids
	
		droid1 = Find_Hint("GENERIC_MARKER_LAND","ddroid1")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",droid1.Get_Position(),underworld_player)
		droid2 = Find_Hint("GENERIC_MARKER_LAND","ddroid2")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",droid2.Get_Position(),underworld_player)
		droid3 = Find_Hint("GENERIC_MARKER_LAND","ddroid3")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",droid3.Get_Position(),underworld_player)
		droid4 = Find_Hint("GENERIC_MARKER_LAND","ddroid4")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",droid4.Get_Position(),underworld_player)
		droid5 = Find_Hint("GENERIC_MARKER_LAND","ddroid5")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",droid5.Get_Position(),underworld_player)
		droid6 = Find_Hint("GENERIC_MARKER_LAND","ddroid6")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",droid6.Get_Position(),underworld_player)
		droid7 = Find_Hint("GENERIC_MARKER_LAND","ddroid7")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",droid7.Get_Position(),underworld_player)
		droid8 = Find_Hint("GENERIC_MARKER_LAND","ddroid8")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",droid8.Get_Position(),underworld_player)
	
		edroid1 = Find_Hint("GENERIC_MARKER_LAND","edroid1")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",edroid1.Get_Position(),underworld_player)
		edroid2 = Find_Hint("GENERIC_MARKER_LAND","edroid2")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",edroid2.Get_Position(),underworld_player)
		edroid3 = Find_Hint("GENERIC_MARKER_LAND","edroid3")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",edroid3.Get_Position(),underworld_player)
		edroid4 = Find_Hint("GENERIC_MARKER_LAND","edroid4")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",edroid4.Get_Position(),underworld_player)
		edroid5 = Find_Hint("GENERIC_MARKER_LAND","edroid5")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",edroid5.Get_Position(),underworld_player)
		
		tdroid1 = Find_Hint("GENERIC_MARKER_LAND","tube1")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",tdroid1.Get_Position(),underworld_player)
		tdroid2 = Find_Hint("GENERIC_MARKER_LAND","tube2")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",tdroid2.Get_Position(),underworld_player)
		tdroid3 = Find_Hint("GENERIC_MARKER_LAND","tube3")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",tdroid3.Get_Position(),underworld_player)
		tdroid4 = Find_Hint("GENERIC_MARKER_LAND","tube4")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",tdroid4.Get_Position(),underworld_player)
		tdroid5 = Find_Hint("GENERIC_MARKER_LAND","tube5")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",tdroid5.Get_Position(),underworld_player)
		tdroid6 = Find_Hint("GENERIC_MARKER_LAND","tube6")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",tdroid6.Get_Position(),underworld_player)
		tdroid7 = Find_Hint("GENERIC_MARKER_LAND","tube7")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",tdroid7.Get_Position(),underworld_player)
		tdroid8 = Find_Hint("GENERIC_MARKER_LAND","tube8")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",tdroid8.Get_Position(),underworld_player)
		tdroid9 = Find_Hint("GENERIC_MARKER_LAND","tube9")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",tdroid9.Get_Position(),underworld_player)
		tdroid10 = Find_Hint("GENERIC_MARKER_LAND","tube10")
		Create_Generic_Object("UM02_DROIDS_SPAWNER",tdroid10.Get_Position(),underworld_player)
		
		Sleep(2)
		
		Story_Event("UM04_HINT_USEDROIDS")
		droid1.Highlight(true)
		Add_Radar_Blip(droid1, "droid1")
		droid2.Highlight(true)
		Add_Radar_Blip(droid2, "droid2")
		droid3.Highlight(true)
		Add_Radar_Blip(droid3, "droid3")
		droid4.Highlight(true)
		Add_Radar_Blip(droid4, "droid4")
		droid5.Highlight(true)
		Add_Radar_Blip(droid5, "droid5")
		droid6.Highlight(true)
		Add_Radar_Blip(droid6, "droid6")
		droid7.Highlight(true)
		Add_Radar_Blip(droid7, "droid7")
		droid8.Highlight(true)
		Add_Radar_Blip(droid8, "droid8")
		
		edroid1.Highlight(true)
		Add_Radar_Blip(edroid1, "edroid1")
		edroid2.Highlight(true)
		Add_Radar_Blip(edroid2, "edroid2")
		edroid3.Highlight(true)
		Add_Radar_Blip(edroid3, "edroid3")
		edroid4.Highlight(true)
		Add_Radar_Blip(edroid4, "edroid4")
		edroid5.Highlight(true)
		Add_Radar_Blip(edroid5, "edroid5")
		
		tdroid1.Highlight(true)
		Add_Radar_Blip(tdroid1, "tdroid1")
		tdroid2.Highlight(true)
		Add_Radar_Blip(tdroid2, "tdroid2")
		tdroid3.Highlight(true)
		Add_Radar_Blip(tdroid3, "tdroid3")
		tdroid4.Highlight(true)
		Add_Radar_Blip(tdroid4, "tdroid4")
		tdroid5.Highlight(true)
		Add_Radar_Blip(tdroid5, "tdroid5")
		tdroid6.Highlight(true)
		Add_Radar_Blip(tdroid6, "tdroid6")
		tdroid7.Highlight(true)
		Add_Radar_Blip(tdroid7, "tdroid7")
		tdroid8.Highlight(true)
		Add_Radar_Blip(tdroid8, "tdroid8")
		tdroid9.Highlight(true)
		Add_Radar_Blip(tdroid9, "tdroid9")
		tdroid10.Highlight(true)
		Add_Radar_Blip(tdroid10, "tdroid10")
		
		Sleep(5)
		
		droid1.Highlight(false)
		Remove_Radar_Blip("droid1")
		droid2.Highlight(false)
		Remove_Radar_Blip("droid2")
		droid3.Highlight(false)
		Remove_Radar_Blip("droid3")
		droid4.Highlight(false)
		Remove_Radar_Blip("droid4")
		droid5.Highlight(false)
		Remove_Radar_Blip("droid5")
		droid6.Highlight(false)
		Remove_Radar_Blip("droid6")
		droid7.Highlight(false)
		Remove_Radar_Blip("droid7")
		droid8.Highlight(false)
		Remove_Radar_Blip("droid8")
		
		edroid1.Highlight(false)
		Remove_Radar_Blip("edroid1")
		edroid2.Highlight(false)
		Remove_Radar_Blip("edroid2")
		edroid3.Highlight(false)
		Remove_Radar_Blip("edroid3")
		edroid4.Highlight(false)
		Remove_Radar_Blip("edroid4")
		edroid5.Highlight(false)
		Remove_Radar_Blip("edroid5")
		
		tdroid1.Highlight(false)
		Remove_Radar_Blip("tdroid1")
		tdroid2.Highlight(false)
		Remove_Radar_Blip("tdroid2")
		tdroid3.Highlight(false)
		Remove_Radar_Blip("tdroid3")
		tdroid4.Highlight(false)
		Remove_Radar_Blip("tdroid4")
		tdroid5.Highlight(false)
		Remove_Radar_Blip("tdroid5")
		tdroid6.Highlight(false)
		Remove_Radar_Blip("tdroid6")
		tdroid7.Highlight(false)
		Remove_Radar_Blip("tdroid7")
		tdroid8.Highlight(false)
		Remove_Radar_Blip("tdroid8")
		tdroid9.Highlight(false)
		Remove_Radar_Blip("tdroid9")
		tdroid10.Highlight(false)
		Remove_Radar_Blip("tdroid10")
		
		
	end
end

-- delay a short time and then show game has been won VICTORY
function EndMissionVictory()
	Cancel_Fast_Forward() 
	CINE_End_Active = true
	Story_Event("UM04_ENDCINE_BEGIN")

	Suspend_AI(1)
	Lock_Controls(1)
	Fade_Screen_Out(1)
	Sleep(1)
	
	turrets = Find_All_Objects_Of_Type("PIRATE_ANTI_INFANTRY_TURRET")
	for k, unit in pairs(turrets) do
		if TestValid(unit) then
			unit.Take_Damage(9999)
		end
	end
	turrets = Find_All_Objects_Of_Type("PIRATE_ANTI_AIRCRAFT_TURRET")
	for k, unit in pairs(turrets) do
		if TestValid(unit) then
			unit.Take_Damage(9999)
		end
	end
	turrets = Find_All_Objects_Of_Type("PIRATE_ANTI_VEHICLE_TURRET")
	for k, unit in pairs(turrets) do
		if TestValid(unit) then
			unit.Take_Damage(9999)
		end
	end
	soldiers = Find_All_Objects_Of_Type(pirate_player)
	for k, unit in pairs(soldiers) do
		if TestValid(unit) then
			unit.Prevent_All_Fire(true)
		end
	end

	--entourage1 = Create_Generic_Object("HUTT_POD_WALKER", deadguys1.Get_Position(), neutral_player) 
	--entourage2 = Create_Generic_Object("HUTT_SOLDIER", deadguys2.Get_Position(), neutral_player) 
	--entourage3 = Create_Generic_Object("HUTT_SOLDIER", deadguys4.Get_Position(), neutral_player) 
	--entourage4 = Create_Generic_Object("HUTT_SOLDIER", deadguys5.Get_Position(), neutral_player) 
	
	Letter_Box_In(0)
	Start_Cinematic_Camera()	
	
	detritus1 = Create_Generic_Object("HUTT_SOLDIER", deadguys1.Get_Position(), neutral_player)
	detritus2 = Create_Generic_Object("HUTT_SOLDIER", deadguys2.Get_Position(), neutral_player)
	detritus3 = Create_Generic_Object("HUTT_SOLDIER", deadguys3.Get_Position(), neutral_player)
	detritus4 = Create_Generic_Object("HUTT_SOLDIER", deadguys4.Get_Position(), neutral_player)
	detritus5 = Create_Generic_Object("HUTT_SOLDIER", deadguys5.Get_Position(), neutral_player)
	detritus6 = Create_Generic_Object("HUTT_SOLDIER", deadguys6.Get_Position(), neutral_player)
	detritus1.Take_Damage(99999)
	detritus2.Take_Damage(99999)
	detritus3.Take_Damage(99999)
	detritus4.Take_Damage(99999)
	detritus5.Take_Damage(99999)
	detritus6.Take_Damage(99999)
	wreckage2 = Create_Generic_Object("HUTT_POD_WALKER", wreck2.Get_Position(), neutral_player)
	wreckage3 = Create_Generic_Object("HUTT_POD_WALKER", wreck3.Get_Position(), neutral_player)
	wreckage2.Take_Damage(99999)
	wreckage3.Take_Damage(99999)
	endjabbaholospawn = Find_Hint("STORY_TRIGGER_ZONE", "endjabbaholospawn")
	
	tyber_zann.Teleport_And_Face(endtyberspawn)
	urai_fen.Teleport_And_Face(enduraispawn)
	if not TestValid(bossk) then
		bossk = Create_Generic_Object("BOSSK", endbosskspawn.Get_Position(), underworld_player)
	end
	bossk.Teleport_And_Face(endbosskspawn)
	--jabba = Create_Generic_Object("HUTT_CIVILIAN", endjabbaspawn.Get_Position(), neutral_player)
	jabba = Create_Generic_Object("UMP_CINE_HOLOJABBA", endjabbaholospawn.Get_Position(), neutral_player)
	jabba.Teleport_And_Face(endjabbaholospawn)
	--lildroid = Create_Generic_Object("UMP_CINE_MOUSEDROID", endjabbaspawn.Get_Position(), neutral_player)
	--jabba.Teleport_And_Face(endjabbaspawn)
	--jabba.Suspend_Locomotor(true)
	tyber_zann.Play_Animation("Idle", false, 0)
	bossk.Prevent_All_Fire(true)
	urai_fen.Prevent_All_Fire(true)
	tyber_zann.Prevent_All_Fire(true)
	jabba.Prevent_All_Fire(true)
	
	--entourage1.Face_Immediate(endtyberspawn)
	--entourage2.Face_Immediate(endtyberspawn)
	--entourage3.Face_Immediate(endtyberspawn)
	--entourage4.Face_Immediate(endtyberspawn)

	Sleep(1)	
	Fade_Screen_In(1)
	--Set_Cinematic_Camera_Key(target_pos, xoffset_dist, yoffset_pitch, zoffset_yaw, angles?, attach_object, use_object_rotation, cinematic_animation)
	Set_Cinematic_Camera_Key(jabba, 40, 25, 35, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(tyber_zann, 0, 0, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(jabba, 5, 40, 25, 50, 1, 0, 0, 0)
	
	Sleep(1)
	
	jabba.Play_Animation("idle", true, 0)
	Story_Event("CHATTER_15")
	tyber_zann.Play_Animation("cinematic", true, 2)
	while not State_Mission_4_Chatter_Dialog_15_Done do Sleep(.5) end
	tyber_zann.Play_Animation("idle", true, 0)
	
	Set_Cinematic_Camera_Key(tyber_zann, 30, 55, -60, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(jabba, 0, 0, 0, 0, 0, 0, 0)
	--Transition_Cinematic_Camera_Key(tyber_zann, 8, 30, 55, -70, 1, 0, 0, 0)
	
	jabba.Play_Animation("idle", true, 0)
	Story_Event("CHATTER_16")
	Sleep(2)
	--jabba.Play_Animation("Idle", false, 3)
	while not State_Mission_4_Chatter_Dialog_16_Done do Sleep(.5) end
	
	Set_Cinematic_Camera_Key(jabba, 40, 25, 50, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(tyber_zann, 0, 0, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(jabba, 21, 40, 25, 95, 1, 0, 0, 0)
	
	jabba.Play_Animation("cinematic", true, 0)
	Story_Event("CHATTER_17")
	tyber_zann.Play_Animation("cinematic", true, 2)
	Sleep(12.5)

	detritus1.Despawn()
	detritus2.Despawn()
	detritus3.Despawn()
	detritus4.Despawn()
	detritus5.Despawn()
	detritus6.Despawn()
	detritus1 = Create_Generic_Object("HUTT_SOLDIER", deadguys1.Get_Position(), neutral_player)
	detritus2 = Create_Generic_Object("HUTT_SOLDIER", deadguys2.Get_Position(), neutral_player)
	detritus3 = Create_Generic_Object("HUTT_SOLDIER", deadguys3.Get_Position(), neutral_player)
	detritus4 = Create_Generic_Object("HUTT_SOLDIER", deadguys4.Get_Position(), neutral_player)
	detritus5 = Create_Generic_Object("HUTT_SOLDIER", deadguys5.Get_Position(), neutral_player)
	detritus6 = Create_Generic_Object("HUTT_SOLDIER", deadguys6.Get_Position(), neutral_player)
	detritus1.Take_Damage(99999)
	detritus2.Take_Damage(99999)
	detritus3.Take_Damage(99999)
	detritus4.Take_Damage(99999)
	detritus5.Take_Damage(99999)
	detritus6.Take_Damage(99999)
	
	--Set_Cinematic_Camera_Key(jabba, 20, -8, 16, 0, 0, 0, 0)
	--Set_Cinematic_Target_Key(tyber_zann, 0, 0, -5, 0, 0, 0, 0)
	while not State_Mission_4_Chatter_Dialog_17_Done do Sleep(.5) end
	tyber_zann.Play_Animation("Idle", false, 1)
	
	jabba.Play_Animation("idle", true, 0)
	Story_Event("CHATTER_18")
	Set_Cinematic_Camera_Key(tyber_zann, 80, 25, -120, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(jabba, 50, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Camera_Key(jabba, 12, 80, 25, 120, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(tyber_zann, 11, 5, -10, 0, 1, 0, 0, 0)
	
	while not State_Mission_4_Chatter_Dialog_18_Done do Sleep(.5) end
	--jabba.Play_Animation("Idle", false, 0)

	--Set_Cinematic_Camera_Key(jabba, 55, 10, 10, 0, 0, 0, 0)
	--Set_Cinematic_Target_Key(tyber_zann, 0, 0, -5, 0, 0, 0, 0)
	
	
	jabba.Play_Animation("cinematic", true, 0)
	Story_Event("CHATTER_19") 
	tyber_zann.Play_Animation("cinematic", true, 2)
	Sleep(5)
	
	jabba.Play_Animation("undeploy", true, 0)
	--jabba.Move_To(jabbacam)
	--jabba.Suspend_Locomotor(false)
	--jabba.Move_To(jabbacam)
	Sleep(2)
	--entourage1.Despawn()
	--entourage2.Despawn()
	--entourage3.Despawn()
	--entourage4.Despawn()
	
	urai_fen.Face_Immediate(tyber_zann)
	Set_Cinematic_Camera_Key(tyber_zann, 10, 15, 18, 0, 1, 0, 0)
	Set_Cinematic_Target_Key(urai_fen, 0, 0, 17, 0, 0, 0, 0)
	
	while not State_Mission_4_Chatter_Dialog_19_Done do Sleep(.5) end
	tyber_zann.Play_Animation("idle", true, 0)
	
	jabba.Play_Animation("undeploy", false, 0)
	Story_Event("CHATTER_20")
	urai_fen.Play_Animation("cinematic", true, 0)
	while not State_Mission_4_Chatter_Dialog_20_Done do Sleep(.5) end
	urai_fen.Play_Animation("idle", true, 0)
	--jabba.Hide(true)
	
	tyber_zann.Turn_To_Face(urai_fen)
	bossk.Turn_To_Face(tyber_zann)
	
	Story_Event("CHATTER_63")
	tyber_zann.Play_Animation("cinematic", true, 2)
	Set_Cinematic_Camera_Key(urai_fen, -35, 0, 18, 0, 0, 0, 0)
	Set_Cinematic_Target_Key(tyber_zann, 0, 0, 17, 0, 0, 0, 0)
	while not State_Mission_4_Chatter_Dialog_63_Done do Sleep(.5) end
	tyber_zann.Play_Animation("idle", true, 0)
	
	Story_Event("CHATTER_64")
	Set_Cinematic_Camera_Key(tyber_zann, 10, 15, 18, 0, 1, 0, 0)
	Set_Cinematic_Target_Key(urai_fen, 0, 0, 17, 0, 0, 0, 0)
	urai_fen.Play_Animation("cinematic", true, 0)
	while not State_Mission_4_Chatter_Dialog_64_Done do Sleep(.5) end
	urai_fen.Play_Animation("idle", true, 0)
	
	Story_Event("CHATTER_65")
	tyber_zann.Play_Animation("cinematic", true, 2)
	Set_Cinematic_Camera_Key(urai_fen, -35, 0, 18, 0, 0, 0, 0)
	Set_Cinematic_Target_Key(tyber_zann, 0, 0, 17, 0, 0, 0, 0)
	Sleep(2)
	Transition_Cinematic_Camera_Key(tyber_zann, 11, 10, 14, 16, 0, 1, 0, 0)
	while not State_Mission_4_Chatter_Dialog_65_Done do Sleep(.5) end
	tyber_zann.Play_Animation("idle", true, 0)
	Create_Thread("EndCineCleanup")
end

-- delay a short time and then show game has been lost DEFEAT
function EndMissionDefeat()
	Cancel_Fast_Forward() 
	Suspend_AI(1)
	Lock_Controls(1)
	Sleep(1)
	Story_Event("UM04_ENDMISSION_DEFEAT")
end




















function State_Mission_4_Chatter_Dialog_00_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_00_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_01_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_01_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_02_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_02_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_03_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_03_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_04_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_04_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_05_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_05_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_06_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_06_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_07_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_07_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_08_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_08_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_09_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_09_Done = true
	end
end


function State_Mission_4_Chatter_Dialog_10_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_10_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_11_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_11_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_12_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_12_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_13_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_13_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_14_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_14_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_15_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_15_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_16_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_16_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_17_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_17_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_18_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_18_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_19_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_19_Done = true
	end
end


function State_Mission_4_Chatter_Dialog_20_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_20_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_21_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_21_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_22_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_22_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_23_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_23_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_24_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_24_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_25_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_25_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_26_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_26_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_27_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_27_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_28_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_28_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_29_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_29_Done = true
	end
end


function State_Mission_4_Chatter_Dialog_30_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_30_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_31_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_31_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_32_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_32_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_33_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_33_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_34_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_34_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_35_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_35_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_36_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_36_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_37_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_37_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_38_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_38_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_39_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_39_Done = true
	end
end


function State_Mission_4_Chatter_Dialog_40_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_40_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_41_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_41_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_42_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_42_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_43_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_43_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_44_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_44_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_45_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_45_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_46_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_46_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_47_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_47_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_48_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_48_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_49_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_49_Done = true
	end
end


function State_Mission_4_Chatter_Dialog_50_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_50_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_51_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_51_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_52_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_52_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_53_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_53_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_54_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_54_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_55_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_55_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_56_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_56_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_57_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_57_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_58_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_58_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_59_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_59_Done = true
	end
end



function State_Mission_4_Chatter_Dialog_60_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_60_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_61_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_61_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_62_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_62_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_63_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_63_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_64_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_64_Done = true
	end
end
function State_Mission_4_Chatter_Dialog_65_Speech_Done(message)
	if message == OnEnter then
		State_Mission_4_Chatter_Dialog_65_Done = true
	end
end
