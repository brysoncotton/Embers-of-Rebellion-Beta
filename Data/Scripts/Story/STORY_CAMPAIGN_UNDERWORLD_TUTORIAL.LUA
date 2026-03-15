-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Campaign_Underworld_Tutorial.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Campaign_Underworld_Tutorial.lua $
--
--    Original Author: Dan Etter
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
		Underworld_Tutorial_Demo_Begin = State_Underworld_Tutorial_Demo_Begin,
		Underworld_Tutorial_Open_NalHutta_To_Tyber = State_Underworld_Tutorial_Open_NalHutta_To_Tyber,
		Underworld_Tutorial_Highlight_Piracy_Option = State_Underworld_Tutorial_Highlight_Piracy_Option,
		Underworld_Tutorial_Corruption_Increased_On_Mandalore = State_Underworld_Tutorial_Corruption_Increased_On_Mandalore,
		Underworld_Tutorial_Trigger_After_Corruption_Increased_At_NalHutta = State_Underworld_Tutorial_Trigger_After_Corruption_Increased_At_NalHutta,
		Underworld_Tutorial_Highlight_Disruptor_Tech = State_Underworld_Tutorial_Highlight_Disruptor_Tech,
		Underworld_Tutorial_Complete_Objective_02 = State_Underworld_Tutorial_Complete_Objective_02,
		Underworld_Tutorial_Force_Urai_Respawn_After_Mandalore_Corruption = State_Underworld_Tutorial_Force_Urai_Respawn_After_Mandalore_Corruption,
		Underworld_Tutorial_Speech_Line_00_Remove_Text = State_Underworld_Tutorial_Speech_Line_00_Remove_Text,
		Underworld_Tutorial_Speech_Line_01_Remove_Text = State_Underworld_Tutorial_Speech_Line_01_Remove_Text,
		Underworld_Tutorial_Speech_Line_02_Remove_Text = State_Underworld_Tutorial_Speech_Line_02_Remove_Text,
		Underworld_Tutorial_Speech_Line_03_Remove_Text = State_Underworld_Tutorial_Speech_Line_03_Remove_Text,
		Underworld_Tutorial_Speech_Line_04_Remove_Text = State_Underworld_Tutorial_Speech_Line_04_Remove_Text,
		Underworld_Tutorial_Speech_Line_05_Remove_Text = State_Underworld_Tutorial_Speech_Line_05_Remove_Text,
		Underworld_Tutorial_Speech_Line_06_Remove_Text = State_Underworld_Tutorial_Speech_Line_06_Remove_Text,
		Underworld_Tutorial_Speech_Line_07_Remove_Text = State_Underworld_Tutorial_Speech_Line_07_Remove_Text,
		Underworld_Tutorial_Speech_Line_08_Remove_Text = State_Underworld_Tutorial_Speech_Line_08_Remove_Text,
		Underworld_Tutorial_Speech_Line_09_Remove_Text = State_Underworld_Tutorial_Speech_Line_09_Remove_Text,
		Underworld_Tutorial_Speech_Line_10_Remove_Text = State_Underworld_Tutorial_Speech_Line_10_Remove_Text,
		Underworld_Tutorial_Speech_Line_11_Remove_Text = State_Underworld_Tutorial_Speech_Line_11_Remove_Text,
		Underworld_Tutorial_Speech_Line_12_Remove_Text = State_Underworld_Tutorial_Speech_Line_12_Remove_Text,
		Underworld_Tutorial_Speech_Line_13_Remove_Text = State_Underworld_Tutorial_Speech_Line_13_Remove_Text,
		Underworld_Tutorial_Speech_Line_14_Remove_Text = State_Underworld_Tutorial_Speech_Line_14_Remove_Text,
		Underworld_Tutorial_Speech_Line_15_Remove_Text = State_Underworld_Tutorial_Speech_Line_15_Remove_Text,
		Underworld_Tutorial_Speech_Line_16_Remove_Text = State_Underworld_Tutorial_Speech_Line_16_Remove_Text,
		Underworld_Tutorial_Speech_Line_17_Remove_Text = State_Underworld_Tutorial_Speech_Line_17_Remove_Text,
		Underworld_Tutorial_Speech_Line_18_Remove_Text = State_Underworld_Tutorial_Speech_Line_18_Remove_Text,
		Underworld_Tutorial_Speech_Line_19_Remove_Text = State_Underworld_Tutorial_Speech_Line_19_Remove_Text,
		Underworld_Tutorial_Speech_Line_20_Remove_Text = State_Underworld_Tutorial_Speech_Line_20_Remove_Text,
		Underworld_Tutorial_Speech_Line_21_Remove_Text = State_Underworld_Tutorial_Speech_Line_21_Remove_Text,
		Underworld_Tutorial_Speech_Line_22_Remove_Text = State_Underworld_Tutorial_Speech_Line_22_Remove_Text,
		Underworld_Tutorial_Speech_Line_23_Remove_Text = State_Underworld_Tutorial_Speech_Line_23_Remove_Text,
		Underworld_Tutorial_Speech_Line_24_Remove_Text = State_Underworld_Tutorial_Speech_Line_24_Remove_Text,
		Underworld_Tutorial_Speech_Line_25_Remove_Text = State_Underworld_Tutorial_Speech_Line_25_Remove_Text,
		Underworld_Tutorial_Speech_Line_26_Remove_Text = State_Underworld_Tutorial_Speech_Line_26_Remove_Text,
		Underworld_Tutorial_Speech_Line_27_Remove_Text = State_Underworld_Tutorial_Speech_Line_27_Remove_Text,
		Underworld_Tutorial_Speech_Line_28_Remove_Text = State_Underworld_Tutorial_Speech_Line_28_Remove_Text,
		Underworld_Tutorial_Speech_Line_29_Remove_Text = State_Underworld_Tutorial_Speech_Line_29_Remove_Text,
		Underworld_Tutorial_Speech_Line_30_Remove_Text = State_Underworld_Tutorial_Speech_Line_30_Remove_Text,
		Underworld_Tutorial_Speech_Line_31_Remove_Text = State_Underworld_Tutorial_Speech_Line_31_Remove_Text,
		Underworld_Tutorial_Speech_Line_32_Remove_Text = State_Underworld_Tutorial_Speech_Line_32_Remove_Text,
		Underworld_Tutorial_Speech_Line_33_Remove_Text = State_Underworld_Tutorial_Speech_Line_33_Remove_Text,
		Underworld_Tutorial_Speech_Line_34_Remove_Text = State_Underworld_Tutorial_Speech_Line_34_Remove_Text,
		Underworld_Tutorial_Speech_Line_35_Remove_Text = State_Underworld_Tutorial_Speech_Line_35_Remove_Text,
		Underworld_Tutorial_Speech_Line_36_Remove_Text = State_Underworld_Tutorial_Speech_Line_36_Remove_Text,
		Underworld_Tutorial_Speech_Line_37_Remove_Text = State_Underworld_Tutorial_Speech_Line_37_Remove_Text,
		Underworld_Tutorial_Speech_Line_38_Remove_Text = State_Underworld_Tutorial_Speech_Line_38_Remove_Text,
		Underworld_Tutorial_Speech_Line_39_Remove_Text = State_Underworld_Tutorial_Speech_Line_39_Remove_Text,
		Underworld_Tutorial_Speech_Line_40_Remove_Text = State_Underworld_Tutorial_Speech_Line_40_Remove_Text,
		Underworld_Tutorial_Speech_Line_41_Remove_Text = State_Underworld_Tutorial_Speech_Line_41_Remove_Text,
		Underworld_Tutorial_Speech_Line_42_Remove_Text = State_Underworld_Tutorial_Speech_Line_42_Remove_Text,
		Underworld_Tutorial_Speech_Line_43_Remove_Text = State_Underworld_Tutorial_Speech_Line_43_Remove_Text,
		Underworld_Tutorial_Speech_Line_44_Remove_Text = State_Underworld_Tutorial_Speech_Line_44_Remove_Text,
		Underworld_Tutorial_Speech_Line_45_Remove_Text = State_Underworld_Tutorial_Speech_Line_45_Remove_Text,
		Underworld_Tutorial_Speech_Line_46_Remove_Text = State_Underworld_Tutorial_Speech_Line_46_Remove_Text,
		Underworld_Tutorial_Speech_Line_47_Remove_Text = State_Underworld_Tutorial_Speech_Line_47_Remove_Text,
		Underworld_Tutorial_Speech_Line_48_Remove_Text = State_Underworld_Tutorial_Speech_Line_48_Remove_Text,
		Underworld_Tutorial_Speech_Line_49_Remove_Text = State_Underworld_Tutorial_Speech_Line_49_Remove_Text,
		Underworld_Tutorial_Speech_Line_50_Remove_Text = State_Underworld_Tutorial_Speech_Line_50_Remove_Text,
		Underworld_Tutorial_Speech_Line_51_Remove_Text = State_Underworld_Tutorial_Speech_Line_51_Remove_Text,
		Underworld_Tutorial_Speech_Line_52_Remove_Text = State_Underworld_Tutorial_Speech_Line_52_Remove_Text,
		Underworld_Tutorial_Speech_Line_53_Remove_Text = State_Underworld_Tutorial_Speech_Line_53_Remove_Text,
		Underworld_Tutorial_Speech_Line_54_Remove_Text = State_Underworld_Tutorial_Speech_Line_54_Remove_Text,
		Underworld_Tutorial_Speech_Line_55_Remove_Text = State_Underworld_Tutorial_Speech_Line_55_Remove_Text,
		Underworld_Tutorial_Speech_Line_56_Remove_Text = State_Underworld_Tutorial_Speech_Line_56_Remove_Text,
		Underworld_Tutorial_Speech_Line_57_Remove_Text = State_Underworld_Tutorial_Speech_Line_57_Remove_Text,
		Underworld_Tutorial_Speech_Line_58_Remove_Text = State_Underworld_Tutorial_Speech_Line_58_Remove_Text,
		Underworld_Tutorial_Speech_Line_59_Remove_Text = State_Underworld_Tutorial_Speech_Line_59_Remove_Text,
		Underworld_Tutorial_Speech_Line_60_Remove_Text = State_Underworld_Tutorial_Speech_Line_60_Remove_Text,
		Underworld_Tutorial_Speech_Line_61_Remove_Text = State_Underworld_Tutorial_Speech_Line_61_Remove_Text,
		Underworld_Tutorial_Speech_Line_62_Remove_Text = State_Underworld_Tutorial_Speech_Line_62_Remove_Text,
		Underworld_Tutorial_Speech_Line_63_Remove_Text = State_Underworld_Tutorial_Speech_Line_63_Remove_Text,
		Underworld_Tutorial_Speech_Line_64_Remove_Text = State_Underworld_Tutorial_Speech_Line_64_Remove_Text,
		Underworld_Tutorial_Speech_Line_65_Remove_Text = State_Underworld_Tutorial_Speech_Line_65_Remove_Text,
		Underworld_Tutorial_Speech_Line_66_Remove_Text = State_Underworld_Tutorial_Speech_Line_66_Remove_Text,
		Underworld_Tutorial_Speech_Line_67_Remove_Text = State_Underworld_Tutorial_Speech_Line_67_Remove_Text,
		Underworld_Tutorial_Speech_Line_68_Remove_Text = State_Underworld_Tutorial_Speech_Line_68_Remove_Text,
		Underworld_Tutorial_Speech_Line_69_Remove_Text = State_Underworld_Tutorial_Speech_Line_69_Remove_Text,
		Underworld_Tutorial_Speech_Line_70_Remove_Text = State_Underworld_Tutorial_Speech_Line_70_Remove_Text,
		Underworld_Tutorial_Speech_Line_71_Remove_Text = State_Underworld_Tutorial_Speech_Line_71_Remove_Text,
		Underworld_Tutorial_Speech_Line_72_Remove_Text = State_Underworld_Tutorial_Speech_Line_72_Remove_Text,
		Underworld_Tutorial_Speech_Line_73_Remove_Text = State_Underworld_Tutorial_Speech_Line_73_Remove_Text,
		Underworld_Tutorial_Speech_Line_74_Remove_Text = State_Underworld_Tutorial_Speech_Line_74_Remove_Text,
		Underworld_Tutorial_Speech_Line_75_Remove_Text = State_Underworld_Tutorial_Speech_Line_75_Remove_Text,
		Underworld_Tutorial_Speech_Line_76_Remove_Text = State_Underworld_Tutorial_Speech_Line_76_Remove_Text,
		Underworld_Tutorial_Speech_Line_77_Remove_Text = State_Underworld_Tutorial_Speech_Line_77_Remove_Text,
		Underworld_Tutorial_Speech_Line_78_Remove_Text = State_Underworld_Tutorial_Speech_Line_78_Remove_Text,
		Underworld_Tutorial_Speech_Line_79_Remove_Text = State_Underworld_Tutorial_Speech_Line_79_Remove_Text,
		Underworld_Tutorial_Speech_Line_80_Remove_Text = State_Underworld_Tutorial_Speech_Line_80_Remove_Text,
		Underworld_Tutorial_Speech_Line_81_Remove_Text = State_Underworld_Tutorial_Speech_Line_81_Remove_Text,
		Underworld_Tutorial_Speech_Line_82_Remove_Text = State_Underworld_Tutorial_Speech_Line_82_Remove_Text,
		Underworld_Tutorial_Speech_Line_83_Remove_Text = State_Underworld_Tutorial_Speech_Line_83_Remove_Text,
		Underworld_Tutorial_Speech_Line_84_Remove_Text = State_Underworld_Tutorial_Speech_Line_84_Remove_Text,
		Underworld_Tutorial_Speech_Line_85_Remove_Text = State_Underworld_Tutorial_Speech_Line_85_Remove_Text,
		Underworld_Tutorial_Speech_Line_86_Remove_Text = State_Underworld_Tutorial_Speech_Line_86_Remove_Text,
		Underworld_Tutorial_Speech_Line_87_Remove_Text = State_Underworld_Tutorial_Speech_Line_87_Remove_Text,
		Underworld_Tutorial_Speech_Line_88_Remove_Text = State_Underworld_Tutorial_Speech_Line_88_Remove_Text,
		Underworld_Tutorial_Speech_Line_89_Remove_Text = State_Underworld_Tutorial_Speech_Line_89_Remove_Text,
		Underworld_Tutorial_Speech_Line_90_Remove_Text = State_Underworld_Tutorial_Speech_Line_90_Remove_Text,
		Underworld_Tutorial_Speech_Line_91_Remove_Text = State_Underworld_Tutorial_Speech_Line_91_Remove_Text,
		Underworld_Tutorial_Speech_Line_92_Remove_Text = State_Underworld_Tutorial_Speech_Line_92_Remove_Text,
		Underworld_Tutorial_Speech_Line_93_Remove_Text = State_Underworld_Tutorial_Speech_Line_93_Remove_Text,
		Underworld_Tutorial_Speech_Line_94_Remove_Text = State_Underworld_Tutorial_Speech_Line_94_Remove_Text,
		Underworld_Tutorial_Speech_Line_95_Remove_Text = State_Underworld_Tutorial_Speech_Line_95_Remove_Text,
		Underworld_Tutorial_Speech_Line_96_Remove_Text = State_Underworld_Tutorial_Speech_Line_96_Remove_Text,
		Underworld_Tutorial_Speech_Line_97_Remove_Text = State_Underworld_Tutorial_Speech_Line_97_Remove_Text,
		Underworld_Tutorial_Speech_Line_98_Remove_Text = State_Underworld_Tutorial_Speech_Line_98_Remove_Text,
		Underworld_Tutorial_Speech_Line_99_Remove_Text = State_Underworld_Tutorial_Speech_Line_99_Remove_Text,
		Underworld_Tutorial_Speech_Line_102_Remove_Text = State_Underworld_Tutorial_Speech_Line_102_Remove_Text,
		Underworld_Tutorial_Speech_Line_103_Remove_Text = State_Underworld_Tutorial_Speech_Line_103_Remove_Text,
		Underworld_Tutorial_Speech_Line_Felucia_18_Remove_Text = State_Underworld_Tutorial_Speech_Line_Felucia_18_Remove_Text
	}
	
	underworld_list_0 = {
		"Tyber_Zann_Team_No_Peacebringer"
	}
	
	underworld_list_1 = {
		"Urai_Fen_Team"
	}
	
	respawned_urai = {}
	
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	empire = Find_Player("Empire")
	
	felucia_ready = false
	mission_message_sent = false
	non_felucia_units = 5

end

function Story_Mode_Service()
	if felucia_ready and not mission_message_sent then	
		felucia = Find_First_Object("Felucia")
		nalhutta = Find_First_Object("NalHutta")
		ryloth = Find_First_Object("Ryloth")
		mandalore = Find_First_Object("Mandalore")
		galactic_fleet = Find_Object_Type("GALACTIC_FLEET")
			
		underworld_list = Find_All_Objects_Of_Type(underworld)
		non_felucia_units = 0
		
		for k, unit in pairs(underworld_list) do
			if TestValid(unit) and not unit.Is_Category("Structure") then
				parent = unit.Get_Parent_Object()
				if TestValid(parent) then
					if parent == felucia or
					   parent == nalhutta or
					   parent == ryloth or
					   parent == mandalore or
					   parent.Get_Type() == galactic_fleet then
							--MessageBox("Unit = %s, Parent = %s", unit.Get_Type().Get_Name(), parent.Get_Type().Get_Name())
							unit_loc = unit.Get_Planet_Location()
							if unit_loc ~= felucia then
								non_felucia_units = non_felucia_units + 1
							end
					end
				end
			end
		end
		--MessageBox("non Felucia units = %d", non_felucia_units)
		if non_felucia_units == 0 and not mission_message_sent then
			mission_message_sent = true
			Story_Event("LOCK_TUTORIAL_CONTROLS")
			Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_84")
			Story_Event("COMPLETE_GALACTIC_OBJECTIVE_03")
		end
	end
end

function State_Underworld_Tutorial_Force_Urai_Respawn_After_Mandalore_Corruption(message)
	if message == OnEnter then
		Sleep(0.5)
		urai = Find_First_Object("Urai_Fen")
		respawned_urai[1] = urai.Get_Parent_Object()
		urai_fleet = Assemble_Fleet(respawned_urai)
	end
end

function State_Underworld_Tutorial_Demo_Begin(message)
	if message == OnEnter then
		ryloth = Find_First_Object("Ryloth")
		felucia = Find_First_Object("Felucia")	
		urai_fleet_units = SpawnList(underworld_list_1,ryloth,underworld,false,false)		
		urai_fleet = Assemble_Fleet(urai_fleet_units)
		
		Story_Event("SPAWN_TYBER_AT_RYLOTH")
		
		
		underworld.Set_Black_Market_Tutorial(true)
		--underworld.Set_Sabotage_Tutorial(true)
		
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_01")
	end
end

function State_Underworld_Tutorial_Speech_Line_01_Remove_Text(message)
	if message == OnEnter then
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_00")
	end
end

function State_Underworld_Tutorial_Speech_Line_00_Remove_Text(message)
	if message == OnEnter then
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_103")
	end
end

function State_Underworld_Tutorial_Speech_Line_103_Remove_Text(message)
	if message == OnEnter then
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_71")
	end
end

function State_Underworld_Tutorial_Speech_Line_71_Remove_Text(message)
	if message == OnEnter then
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_72")
	end
end

function State_Underworld_Tutorial_Speech_Line_72_Remove_Text(message)
	if message == OnEnter then
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_73")
	end
end

function State_Underworld_Tutorial_Speech_Line_73_Remove_Text(message)
	if message == OnEnter then
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_102")
		Story_Event("ADD_GALACTIC_OBJECTIVE_00")
	end
end

function State_Underworld_Tutorial_Highlight_Piracy_Option(message)
	if message == OnEnter then
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_74")
	end
end

function State_Underworld_Tutorial_Speech_Line_74_Remove_Text(message)
	if message == OnEnter then
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_75")
		Story_Event("UNLOCK_CONTROLS_FOR_CORRUPTION")
	end
end

function State_Underworld_Tutorial_Corruption_Increased_On_Mandalore(message)
	if message == OnEnter then		
		--Sleep(12)
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_77")
		
	end
end

function State_Underworld_Tutorial_Speech_Line_77_Remove_Text(message)
	if message == OnEnter then				
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_99")
	end
end

function State_Underworld_Tutorial_Speech_Line_99_Remove_Text(message)
	if message == OnEnter then
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_98")
	end
end

function State_Underworld_Tutorial_Speech_Line_98_Remove_Text(message)
	if message == OnEnter then
		Story_Event("ZOOM_IN_TWICE")
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_38")
	end
end

function State_Underworld_Tutorial_Speech_Line_38_Remove_Text(message)
	if message == OnEnter then
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_91")
	end
end

function State_Underworld_Tutorial_Speech_Line_91_Remove_Text(message)
	if message == OnEnter then
		Story_Event("ZOOM_OUT_TWICE")
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_09")
	end
end

function State_Underworld_Tutorial_Speech_Line_09_Remove_Text(message)
	if message == OnEnter then
		Story_Event("SPAWN_DEFILER_FOR_BLACK_MARKET")
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_11")
	end
end

function State_Underworld_Tutorial_Speech_Line_11_Remove_Text(message)
	if message == OnEnter then
		Story_Event("ADD_GALACTIC_OBJECTIVE_01")
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_12")
	end
end

function State_Underworld_Tutorial_Speech_Line_12_Remove_Text(message)
	if message == OnEnter then
		Story_Event("UNLOCK_CONTROLS_FOR_BLACK_MARKET")
	end
end

function State_Underworld_Tutorial_Trigger_After_Corruption_Increased_At_NalHutta(message)
	if message == OnEnter then
		Sleep(5)
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_93")
	end
end

function State_Underworld_Tutorial_Speech_Line_93_Remove_Text(message)
	if message == OnEnter then
		Sleep(2)
		
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_80")
	end
end

function State_Underworld_Tutorial_Speech_Line_80_Remove_Text(message)
	if message == OnEnter then	
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_81")
	end
end

function State_Underworld_Tutorial_Speech_Line_81_Remove_Text(message)
	if message == OnEnter then
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_78")
		Story_Event("ADD_GALACTIC_OBJECTIVE_02")
	end
end

function State_Underworld_Tutorial_Highlight_Disruptor_Tech(message)
if message == OnEnter then	
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_51")
	end
end

function State_Underworld_Tutorial_Speech_Line_51_Remove_Text(message)
	if message == OnEnter then	
		Story_Event("UNLOCK_CONTROLS_AFTER_BM_EXPLANATION")
	end
end

function State_Underworld_Tutorial_Complete_Objective_02(message)
	if message == OnEnter then	
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_82")
		Story_Event("LOCK_TUTORIAL_CONTROLS")
	end
end

function State_Underworld_Tutorial_Speech_Line_82_Remove_Text(message)
	if message == OnEnter then	
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_83")
	end
end

function State_Underworld_Tutorial_Speech_Line_83_Remove_Text(message)
	if message == OnEnter then	
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_16")
		Story_Event("ADD_GALACTIC_OBJECTIVE_03")
	end
end

function State_Underworld_Tutorial_Speech_Line_16_Remove_Text(message)
	if message == OnEnter then	
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_10")
	end
end

function State_Underworld_Tutorial_Speech_Line_10_Remove_Text(message)
	if message == OnEnter then	
		Story_Event("UNLOCK_TUTORIAL_CONTROLS")
		Story_Event("OPEN_FELUCIA")
		felucia_ready = true
	end
end

function State_Underworld_Tutorial_Speech_Line_84_Remove_Text(message)
	if message == OnEnter then	
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_85")
	end
end

function State_Underworld_Tutorial_Speech_Line_85_Remove_Text(message)
	if message == OnEnter then	
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_86")
	end
end

function State_Underworld_Tutorial_Speech_Line_86_Remove_Text(message)
	if message == OnEnter then	
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_87")
	end
end

function State_Underworld_Tutorial_Speech_Line_87_Remove_Text(message)
	if message == OnEnter then	
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_88")
	end
end

function State_Underworld_Tutorial_Speech_Line_88_Remove_Text(message)
	if message == OnEnter then	
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_89")
	end
end

function State_Underworld_Tutorial_Speech_Line_89_Remove_Text(message)
	if message == OnEnter then	
		Story_Event("START_FELUCIA_LAND_MISSION")
		Story_Event("UNLOCK_TUTORIAL_CONTROLS")
	end
end
