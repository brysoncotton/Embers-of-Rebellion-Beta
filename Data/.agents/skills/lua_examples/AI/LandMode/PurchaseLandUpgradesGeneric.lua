-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/PurchaseLandUpgradesGeneric.lua#6 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/PurchaseLandUpgradesGeneric.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 56734 $
--
--          $DateTime: 2006/10/24 14:15:48 $
--
--          $Revision: #6 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()
	
	Category = "Purchase_Land_Upgrades_Generic"
	IgnoreTarget = true
	TaskForce = {
	{
		"ReserveForce"
		,"DenySpecialWeaponAttach"
		,"DenyHeroAttach"
		
		
		,"Upgrade =0, 1"
		-- Even though only one can be purchased, the 0,10 should increase the liklihood of items from these lists being chosen.
		,"Ground_Skirmish_Planetary_Bombard_Use_Upgrade | Ground_Skirmish_Bombing_Run_Use_Upgrade = 0,10"
		
		,"Ground_Level_Two_Tech_Upgrade | Ground_Level_Three_Tech_Upgrade | Ground_Level_Four_Tech_Upgrade | Ground_Level_Five_Tech_Upgrade = 0,1"
		
		,"Command_Center_Increased_Supplies_L1_Upgrade | Command_Center_Increased_Supplies_L2_Upgrade | Command_Center_Increased_Supplies_L3_Upgrade | Command_Center_Increased_Supplies_L4_Upgrade | Command_Center_Increased_Supplies_L5_Upgrade".. 
		"| Mining_Increased_Supplies_L1_Upgrade | Mining_Increased_Supplies_L2_Upgrade | Mining_Increased_Supplies_L3_Upgrade | Mining_Increased_Supplies_L4_Upgrade | Mining_Increased_Supplies_L5_Upgrade = 0,5"
	}
	}
	 
	RequiredCategories = {"Upgrade"}
	AllowFreeStoreUnits = false

end

function ReserveForce_Thread()
			
	ReserveForce.Set_Plan_Result(true)
	ReserveForce.Set_As_Goal_System_Removable(false)
	BlockOnCommand(ReserveForce.Produce_Force())

	-- Give some time to build up money.
	tech_level = PlayerObject.Get_Tech_Level()
	min_credits = 1000
	if tech_level == 2 then
		min_credits = 1000
	elseif tech_level >= 3 then
		min_credits = 1000
	end
	
	max_sleep_seconds = 30
	current_sleep_seconds = 0
	while (PlayerObject.Get_Credits() < min_credits) and (current_sleep_seconds < max_sleep_seconds) do
		current_sleep_seconds = current_sleep_seconds + 1
		Sleep(1)
	end
		
	ScriptExit()
end


