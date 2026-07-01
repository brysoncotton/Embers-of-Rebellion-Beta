-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/LandHeroes.lua#3 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/LandHeroes.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 52591 $
--
--          $DateTime: 2006/08/25 14:25:09 $
--
--          $Revision: #3 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

-- This plan just tries to land any purchased heroes for skirmish (they don't count toward unit cap)

function Definitions()
	
	Category = "Reinforce_Flagship_Mode"
	TaskForce = {
	{
		"MainForce"					
		,"DenyHeroAttach"
		,"Wall = 1,5"
	}
	}
	
	IgnoreTarget = true
	AllowEngagedUnits = false
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	
	--Immediately release anybody that was already landed
	MainForce.Release_Forces(1.0)
	
	if EvaluatePerception("Have_Flagship_Fleet", PlayerObject) > 0 then
		-- find something to reinforce near
		friendly_loc = FindTarget(MainForce, "Space_Area_Is_Friendly", "Tactical_Location", 1.0)
	else
		-- reinforce near the flagship
		friendly_loc = Find_All_Objects_Of_Type(PlayerObject, "SpaceStructure")[1]
	end

	if not TestValid(friendly_loc) then
		ScriptExit()
	end
	
	QuickReinforce(PlayerObject, friendly_loc, MainForce)
	
	MainForce.Release_Forces(1)
    MainForce.Set_Plan_Result(true)
	Sleep(5)
end




