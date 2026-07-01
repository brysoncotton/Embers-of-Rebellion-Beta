-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/TacticalMultiplayerBuildSpaceUnitsGeneric.lua#5 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/TacticalMultiplayerBuildSpaceUnitsGeneric.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 54441 $
--
--          $DateTime: 2006/09/13 15:08:39 $
--
--          $Revision: #5 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()
	
	Category = "Tactical_Multiplayer_Build_Space_Units_Generic"
	IgnoreTarget = true
	TaskForce = {
		{
		"ReserveForce"
		-- ,"RC_Level_Two_Tech_Upgrade | RC_Level_Three_Tech_Upgrade = 0,1"
		-- ,"EC_Level_Two_Tech_Upgrade | EC_Level_Three_Tech_Upgrade = 0,1"
		-- ,"UC_Level_Two_Tech_Upgrade | UC_Level_Three_Tech_Upgrade = 0,1"
		,"SpaceHero = 0, 1"
		,"SuperCapital = 0, 1"
		,"Capital = 0, 3"
		,"Frigate = 0, 3"
		,"Corvette = 0, 3"
		,"Gunship = 0, 2"
		,"AntiBomber = 0, 1"
		,"Fighter | Bomber = 0, 5"
		,"Defense_Station_Level_One | Defense_Station_Level_Two | Defense_Station_Level_Three = 0, 3"
		
		
		}
	}
	RequiredCategories = {"Corvette | Frigate | Capital"}
	AllowFreeStoreUnits = false

end

function ReserveForce_Thread()
			
	BlockOnCommand(ReserveForce.Produce_Force())
	ReserveForce.Set_Plan_Result(true)
	ReserveForce.Set_As_Goal_System_Removable(false)
		
	-- Give some time to build up money.
	tech_level = PlayerObject.Get_Tech_Level()
	max_sleep_seconds = 60
	max_cash_on_hand = 6000
	if tech_level == 2 then
		max_sleep_seconds = 60
		max_cash_on_hand = 8000
	elseif tech_level == 3 then
		max_sleep_seconds = 60
		max_cash_on_hand = 10000
	elseif tech_level == 4 then
		max_sleep_seconds = 60
		max_cash_on_hand = 15000
	elseif tech_level == 5 then
		max_sleep_seconds = 60
		max_cash_on_hand = 20000
	end
	
	current_sleep_seconds = 0
	while (current_sleep_seconds < max_sleep_seconds) and PlayerObject.Get_Credits() < max_cash_on_hand do
		current_sleep_seconds = current_sleep_seconds + 1
		Sleep(1)
	end

	ScriptExit()
end