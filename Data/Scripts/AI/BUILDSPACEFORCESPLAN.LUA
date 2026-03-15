-- $Id: //depot/Projects/StarWars_Steam/EAW/Run/Data/Scripts/AI/BuildSpaceForcesPlan.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/EAW/Run/Data/Scripts/AI/BuildSpaceForcesPlan.lua $
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

-- Tell the script pooling system to pre-cache this number of scripts.
ScriptPoolCount = 4

function Definitions()
	Category = "Build_Space_Forces"
	IgnoreTarget = true
	
	--Fighters are omitted deliberately.  Since they're cheap, build fast and are quickly killed it's typically better
	--to build them as we need them to attack.  For defensive purposes we'll rely on space station garrisons for our fighter
	--needs
	TaskForce = {
	{
		"ReserveForce"
		,"DenyHeroAttach"
		,"Corvette = 0,4"
		,"Frigate = 0,4"
		,"Capital = 0,4"
	}
	}
	RequiredCategories = { "Corvette | Frigate | Capital" }
	AllowFreeStoreUnits = false
end

function ReserveForce_Thread()
	DebugMessage("%s -- In ReserveForce_Thread.", tostring(Script))
	
	BlockOnCommand(ReserveForce.Produce_Force())
	ReserveForce.Set_Plan_Result(true)
	
	DebugMessage("%s -- ReserveForce done!", tostring(Script));
	ScriptExit()
end
