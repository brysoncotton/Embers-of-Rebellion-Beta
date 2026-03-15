-- $Id: //depot/Projects/StarWars_Steam/EAW/Run/Data/Scripts/Story/Story_Rebel_Prologue_M03_LAND.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/EAW/Run/Data/Scripts/Story/Story_Rebel_Prologue_M03_LAND.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Brian_Hayes $
--
--            $Change: 637768 $
--
--          $DateTime: 2017/03/21 19:50:17 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStoryMode")


--
-- Definitions -- This function is called once when the script is first created.
-- 
function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))
	
	StoryModeEvents = 
	{
		Rebel_M03_LAND_09 = State_Rebel_M03_LAND_09
	}
       
	reinforce_type_list = { 
		"Imperial_Mini_Stormtrooper_Squad"
		,"Imperial_Mini_Stormtrooper_Squad"
		,"Imperial_Mini_Stormtrooper_Squad"
		,"Imperial_Light_Scout_Squad"
	}

end

function State_Rebel_M03_LAND_09(message)

	if message == OnEnter then
		MessageBox("entering State_Rebel_M03_LAND_09")

		entry_marker = Find_Hint("LAND DEFENDER RETREAT MARKER")
		if not TestValid(entry_marker) then
			MessageBox("didn't find entry_marker")
			return
		end
		
		ReinforceList(reinforce_type_list, entry_marker, entry_marker.Get_Owner(), true, true)

	elseif message == OnUpdate then
		
	elseif message == OnExit then
	end

end

