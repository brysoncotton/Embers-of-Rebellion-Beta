-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/ConquerPiratePlan.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/ConquerPiratePlan.lua $
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

require("pgevents")

-- Tell the script pooling system to pre-cache this number of scripts.
ScriptPoolCount = 16

function Definitions()	
	MinContrastScale = 1.05
	MaxContrastScale = 1.15
	
	PerFailureContrastAdjust = 0.05
		
	Category = "Conquer_Pirate | CIS_Federation_Conquer_Pirate"
	TaskForce = {
	{
		"MainForce"
		,"DenyHeroAttach"
		,"MinimumTotalSize = 5"
		,"Infantry | Vehicle | AirGunship | AirSpeeder | Corvette | Frigate | Capital = 100%"
		,"SuperCapital = 0, 1"
		,"SpaceHero = 0,1"
	}
	}
	RequiredCategories = { "Corvette | Frigate | Capital", "AirGunship | AirSpeeder | Infantry | Vehicle" }	
	
	LandSecured = false
end

function MainForce_Thread()
	
	-- Since we're using plan failure to adjust contrast, we're 
	-- only concerned with failures in battle. Default the 
	-- plan to successful and then 
	-- only on the event of our task force being killed is the
	-- plan set to a failed state.
	MainForce.Set_Plan_Result(true)	
	
	if MainForce.Are_All_Units_On_Free_Store() == true then
		AssembleForce(MainForce)
	else
		BlockOnCommand(MainForce.Produce_Force());
		return
	end
	
	BlockOnCommand(MainForce.Move_To(Target))
	if MainForce.Get_Force_Count() == 0 then
		MainForce.Set_Plan_Result(false)	
		ScriptExit()
	end
	
	if EvaluatePerception("Is_Space_Only", PlayerObject, Target) > 0 then
		
		unit_table = MainForce.Get_Unit_Table()
		-- Release land units and heroes
		if unit_table ~= nil then
			for i,unit in pairs(unit_table) do
				if unit.Is_Transport() or unit.Get_Type().Is_Hero() then
					MainForce.Release_Unit(unit)
				end
			end
		end

		BlockOnCommand(GiveDesireBonus(PlayerObject, "Upgrade_Starbase", Target, 15, 40)) 
		DebugMessage("%s -- waiting for starbase", tostring(Script))
		
		while EvaluatePerception("StarbaseLevel", PlayerObject, Target) < 2 and MainForce.Get_Force_Count() > 0 do
			Sleep(40)
		end
		
		ScriptExit()
	end

	if Invade(MainForce) == false then
		MainForce.Set_Plan_Result(false)			
		ScriptExit()
	end
	
	LandSecured = true
	Release_Excess_Spaceforce(MainForce, PlayerObject, Target)
	FundBases(PlayerObject, Target)
	ScriptExit()
end

function MainForce_Production_Failed(failed_object_type)
	ScriptExit()
end

function MainForce_Original_Target_Owner_Changed(tf, old_owner, new_owner)	
	--Ignore changes to neutral - it might just be temporary on the way to
	--passing into my control.
	if new_owner ~= PlayerObject and new_owner.Is_Neutral() == false then
		ScriptExit()
	end
end

function MainForce_No_Units_Remaining()
	if not LandSecured then
		MainForce.Set_Plan_Result(false)			
		ScriptExit()
	end
end