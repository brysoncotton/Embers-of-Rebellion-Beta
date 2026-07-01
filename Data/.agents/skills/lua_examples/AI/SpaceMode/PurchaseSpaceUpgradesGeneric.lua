-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/PurchaseSpaceUpgradesGeneric.lua#5 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/PurchaseSpaceUpgradesGeneric.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 55010 $
--
--          $DateTime: 2006/09/19 19:14:06 $
--
--          $Revision: #5 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()
	
	Category = "Purchase_Space_Upgrades_Generic"
	IgnoreTarget = true
	TaskForce = {
	{
		"ReserveForce"
		,"DenySpecialWeaponAttach"
		,"DenyHeroAttach"
		,"Space_Starbase_Increased_Supplies_L1_Upgrade | Space_Starbase_Increased_Supplies_L2_Upgrade | Space_Starbase_Increased_Supplies_L3_Upgrade | Space_Starbase_Increased_Supplies_L4_Upgrade | Space_Starbase_Increased_Supplies_L5_Upgrade".. 
		"| Space_Asteroid_Mine_Increased_Supplies_L1_Upgrade | Space_Asteroid_Mine_Increased_Supplies_L2_Upgrade | Space_Asteroid_Mine_Increased_Supplies_L3_Upgrade | Space_Asteroid_Mine_Increased_Supplies_L4_Upgrade | Space_Asteroid_Mine_Increased_Supplies_L5_Upgrade = 0,10"
		
		,"Space_Starbase_Increased_Defence_L1_Upgrade | Space_Starbase_Increased_Defence_L2_Upgrade | Space_Starbase_Increased_Shield_L1_Upgrade | Space_Starbase_Increased_Shield_L2_Upgrade | Space_Secondary_Increased_Health_L1_Upgrade".. 
		"| Space_Secondary_Increased_Health_L2_Upgrade | Space_Asteroid_Mine_Increased_Health_L1_Upgrade | Space_Asteroid_Mine_Increased_Health_L2_Upgrade = 0,1"
		
		
		,"NR_Mon_Cal_Shielding | NR_Fighter_Supremacy | IR_Superweapon_Desires | IR_Pondering_Giant | EOTH_Skirmish_Tactics | EOTH_Enhanced_Mobility | CSA_Corporate_Focus | CSA_Cutting_Corners | Republic_Secret_Fleets | Republic_Ace_Cloning_Program".. 
		"| PA_Corporate_Allies | PA_Isolationism | Zsinj_Friends_In_Low_Places | Zsinj_Warlordism | Malrood_The_Crimson_Fleet | Malrood_Constant_Raids | Eriadu_Experimental_focus | Eriadu_Reckless | CIS_Secret_Hyperspace_Route | CIS_Design_Trade_Offs | Hutt_Cartels_Profit_motive | Hutt_Cartels_Bootana_Hutta_Reinforcement = 0,5"
		
	}
	}
	 
	RequiredCategories = {"Upgrade"}
	AllowFreeStoreUnits = false

end

function ReserveForce_Thread()
			
	BlockOnCommand(ReserveForce.Produce_Force())
	ReserveForce.Set_Plan_Result(true)
	ReserveForce.Set_As_Goal_System_Removable(false)

	-- Give some time to build up money.
	tech_level = PlayerObject.Get_Tech_Level()
	min_credits = 0
	if tech_level == 2 then
		min_credits = 0
	elseif tech_level >= 3 then
		min_credits = 0
	end
	
	max_sleep_seconds = 100
	current_sleep_seconds = 0
	while (PlayerObject.Get_Credits() < min_credits) and (current_sleep_seconds < max_sleep_seconds) do
		current_sleep_seconds = current_sleep_seconds + 1
		Sleep(1)
	end

	ScriptExit()
end

