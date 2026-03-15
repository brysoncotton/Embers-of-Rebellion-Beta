-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Campaign_Underworld_Focus_Demo.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Campaign_Underworld_Focus_Demo.lua $
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
		Underworld_Focus_Demo_Begin = State_Underworld_Focus_Demo_Begin,
		Underworld_Focus_Demo_Remove_Text_03 = State_Underworld_Focus_Demo_Remove_Text_03,
		Underworld_Focus_Demo_Sabotage_Task_Completed = State_Underworld_Focus_Demo_Sabotage_Task_Completed,
		Underworld_Focus_Demo_Spawn_Silri_After_Purchase = State_Underworld_Focus_Demo_Spawn_Silri_After_Purchase,
		Underworld_Focus_Demo_Sabotage_Base_Shield = State_Underworld_Focus_Demo_Sabotage_Base_Shield
	}
	
	underworld_list_0 = {
		"Crusader_Gunship"
		,"Crusader_Gunship"
		,"Crusader_Gunship"
		,"Vengeance_Frigate"
		,"Vengeance_Frigate"
		,"Vengeance_Frigate"
		,"Kedalbe_Battleship"
		,"Tyber_Zann_Team"
	}
	
	underworld_list_1 = {
		"Silri_Team"
	}
	
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	empire = Find_Player("Empire")

end


function State_Underworld_Focus_Demo_Begin(message)
	if message == OnEnter then
		nalhutta = Find_First_Object("NalHutta")
		felucia = Find_First_Object("Felucia")	
		tyber_fleet_units = SpawnList(underworld_list_0,nalhutta,underworld,false,false)		
		tyber_fleet = Assemble_Fleet(tyber_fleet_units)
		
		--MessageBox("Spawning Silri at Nal Hutta!")	
		silri_fleet_units = SpawnList(underworld_list_1,nalhutta,underworld,false,false)		
		silri_fleet = Assemble_Fleet(silri_fleet_units)
		
		underworld.Set_Black_Market_Tutorial(true)
		underworld.Set_Sabotage_Tutorial(true)
	end
end

function State_Underworld_Focus_Demo_Remove_Text_03(message)
	if message == OnEnter then
		underworld.Set_Black_Market_Tutorial(false)
	end
end

function State_Underworld_Focus_Demo_Sabotage_Task_Completed(message)
	if message == OnEnter then
		underworld.Set_Sabotage_Tutorial(false)
	end
end

function State_Underworld_Focus_Demo_Spawn_Silri_After_Purchase(message)
	if message == OnEnter then
		--MessageBox("Spawning Silri at Nal Hutta!")	
		silri_fleet_units = SpawnList(underworld_list_1,nalhutta,underworld,false,false)		
		silri_fleet = Assemble_Fleet(silri_fleet_units)
	end
end

function State_Underworld_Focus_Demo_Sabotage_Base_Shield(message)
	if message == OnEnter then
		--MessageBox("Spawning Base Shield!")	
		base_shield = Spawn_Unit(Find_Object_Type("R_GROUND_BASE_SHIELD"), felucia, rebel)
	end
end