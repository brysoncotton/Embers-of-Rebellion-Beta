-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/AI/AI_Plan_ExpansionGeneric_RemoveCorruption.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/AI/AI_Plan_ExpansionGeneric_RemoveCorruption.lua $
--
--    Original Author: James Yarrow
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

require("pgevents")

function Definitions()
	
	Category = "Remove_Corruption"
	IgnoreTarget = true
	TaskForce = {
		{
			"MainForce",
			"DenyHeroAttach",
			"Mon_Mothma_Team | Obi_Wan_Team | Katarn_Team | Yoda_Team | Luke_Skywalker_Jedi_Team | Han_Solo_Team | Emperor_Palpatine_Team | General_Veers_Team | Darth_Team | Mara_Jade_Team | Grand_Admiral_Thrawn_Team = 1"
		}
	}
end

function MainForce_Thread()
	AssembleForce(MainForce)
	LaunchUnits(MainForce)
	MainForce.Set_As_Goal_System_Removable(false)
	MainForce.Activate_Ability()
	MainForce.Set_Plan_Result(true)	
	Sleep(300)
end

function MainForce_No_Units_Remaining(tf)
	--No action
end

function MainForce_Production_Failed(tf, failed_object_type)
	ScriptExit()
end