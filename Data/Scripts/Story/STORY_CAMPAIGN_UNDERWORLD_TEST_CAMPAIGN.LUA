-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Campaign_Underworld_Test_Campaign.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Campaign_Underworld_Test_Campaign.lua $
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
		Underworld_ActII_M07_Tyber_Gets_To_Bespin = State_Underworld_ActII_M07_Tyber_Gets_To_Bespin,
		Underworld_ActII_M07_Urai_Gets_To_Bespin = State_Underworld_ActII_M07_Urai_Gets_To_Bespin,
		Underworld_Mission_07_Completed = State_Underworld_Mission_07_Completed
	}
	
	
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	empire = Find_Player("Empire")
	
	tyber_to_bespin = false
	urai_to_bespin = false
	mission_7_ready = false
	mission_7_complete = false
	mission_message_sent = false
end

function Story_Mode_Service()
	if mission_7_ready and not mission_7_complete and not mission_message_sent then
		mission_message_sent = true
		Story_Event("START_MISSION_7")
	end
end

function State_Underworld_ActII_M07_Tyber_Gets_To_Bespin(message)
	if message == OnEnter then
		Start_Mission_7()
	end
end

function State_Underworld_ActII_M07_Urai_Gets_To_Bespin(message)
	if message == OnEnter then
		Start_Mission_7()
	end
end

function State_Underworld_Mission_07_Completed(message)
	if message == OnEnter then
		mission_7_complete = true
	end
end

function Start_Mission_7()
	tyber = Find_First_Object("TYBER_ZANN_PASSENGER")
	urai = Find_First_Object("Urai_Fen")
	bespin = Find_First_Object("Bespin")
	
	if TestValid(tyber) then
		--MessageBox("Tyber0 found!")
		tyber_loc = tyber.Get_Planet_Location()
	end
		
	if TestValid(urai) then
		--MessageBox("Urai found!")
		urai_loc = urai.Get_Planet_Location()
	end
	
	if tyber_loc == bespin and urai_loc == bespin then
		mission_7_ready = true
	end
end
