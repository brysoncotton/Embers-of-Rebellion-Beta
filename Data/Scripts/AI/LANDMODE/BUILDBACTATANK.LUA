-- $Id: //depot/Projects/StarWars_Steam/EAW/Run/Data/Scripts/AI/LandMode/BuildBactaTank.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/EAW/Run/Data/Scripts/AI/LandMode/BuildBactaTank.lua $
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

require("pgevents")

-- Build a single structure.

function Definitions()
	
	Category = "Build_Bacta_Tank"
	TaskForce = {
	{
		"MainForce"					
		,"TaskForceRequired"
		,"UC_Empire_Buildable_Bacta_Tank | UC_Rebel_Buildable_Bacta_Tank | UC_Pirate_Buildable_Bacta_Tank = 1"
	}
	}

end

function MainForce_Thread()
	DebugMessage("%s -- Building a turret.", tostring(Script))

	-- Build the task force
	-- Blocking shouldn't be necessary, but we'll use it to ease watching the script
	BlockOnCommand(MainForce.Build_All())
	ScriptExit()
end




