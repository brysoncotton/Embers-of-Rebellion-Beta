-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/UnrestrictedGrabSpace.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/UnrestrictedGrabSpace.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Andre_Arsenault $
--
--            $Change: 37816 $
--
--          $DateTime: 2006/02/15 15:33:33 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

--A plan to rapidly grab space control that bypasses timing restrictions on AI attacks.

require("pgtaskforce")

-- Tell the script pooling system to pre-cache this number of scripts.
ScriptPoolCount = 4

function Definitions()	
	MinContrastScale = 1.1
	MaxContrastScale = 1.2
		
	Category = "Unrestricted_Grab_Space | Skynet_Unrestricted_Grab_Space"
	TaskForce = {
	{
		"MainForce"
		,"DenyHeroAttach"		
		,"Gunship | Corvette | Frigate | Capital  = 100%"
	}
	}
	RequiredCategories = {"AntiBomber", "Frigate | Capital"}	--we want at least one heavier ship
	
	LandSecured = false
	end_blockade = 0
	
end

function MainForce_Thread()
	
	-- Since we're using plan failure to adjust contrast, we're 
	-- only concerned with failures in battle. Default the 
	-- plan to successful and then 
	-- only on the event of our task force being killed is the
	-- plan set to a failed state.
	MainForce.Set_Plan_Result(true)	
	
	--For fast execution, build and attack in one plan rather than having the first few iterations
	--feed the freestore
	AssembleForce(MainForce)
	
	if EvaluatePerception("Space_Force_Limit_For_Unrestricted_Grab", PlayerObject, Target) <= EvaluatePerception("Space_Contrast", PlayerObject, Target) then
		DebugMessage("%s -- planet too well defended now, exiting", tostring(Script))
		MainForce.Set_Plan_Result(false)	
		ScriptExit()
	end
	
	GlobalValue.Set("CONQUER_OPPONENT", Target.Get_Type().Get_Name())
	BlockOnCommand(MainForce.Move_To(Target))
	
	if MainForce.Get_Force_Count() == 0 then
		DebugMessage("%s -- taskforce destroyed, exiting", tostring(Script))
		MainForce.Set_Plan_Result(false)	
		ScriptExit()
	end
	
	-- Fleet sticks around between 0 and 80 seconds
	end_blockade = GameRandom.Free_Random(0, 80)
	while end_blockade > 0 do
		DebugMessage("%s -- blockading, rolled %s", tostring(Script), tostring(end_blockade))
		Sleep(1)
		end_blockade = end_blockade - 1
	end
	
	ScriptExit()
end

function MainForce_Production_Failed(failed_object_type)
	ScriptExit()
end

function MainForce_Original_Target_Owner_Changed(tf, old_owner, new_owner)	
	--If we take control of this planet than we'll release our blockading units
	if new_owner == PlayerObject then
		ScriptExit()
	end
end