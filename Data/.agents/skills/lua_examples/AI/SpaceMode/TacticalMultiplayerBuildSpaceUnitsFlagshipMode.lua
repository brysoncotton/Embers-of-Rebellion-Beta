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

	Category = "Tactical_Multiplayer_Build_Space_Units_Flagship"
	IgnoreTarget = true
	TaskForce = {
		{
		"ReserveForce"
		
		,"Flagship_CIS_AAA | Flagship_CIS_AAB | Flagship_CIS_AAC | Flagship_CIS_AAG | Flagship_CIS_AAH | Flagship_CIS_AAP | Flagship_CIS_AAQ = 0, 5"
		,"Flagship_CIS_AAD | Flagship_CIS_AAE | Flagship_CIS_AAF | Flagship_CIS_AAJ | Flagship_CIS_AAK | Flagship_CIS_AAN = 0, 3"
		,"Flagship_CIS_AAI | Flagship_CIS_AAL | Flagship_CIS_AAM | Flagship_CIS_AAR	= 0, 2"
		,"Flagship_CIS_AAS | Flagship_CIS_AAT | Flagship_CIS_AAU | Flagship_CIS_AAV | Flagship_CIS_AAW	= 0, 2"
		,"Flagship_CIS_AAX | Flagship_CIS_AAY | Flagship_CIS_AAZ = 0, 1"
	
		,"Flagship_Republic_AAA | Flagship_Republic_AAB | Flagship_Republic_AAC | Flagship_Republic_AAD | Flagship_Republic_AAE | Flagship_Republic_AAI | Flagship_Republic_AAJ | Flagship_Republic_AAK | Flagship_Republic_AAQ | Flagship_Republic_AAR | Flagship_Republic_AAU	= 0, 5"
		,"Flagship_Republic_AAF | Flagship_Republic_AAG | Flagship_Republic_AAH | Flagship_Republic_AAL | Flagship_Republic_AAS | Flagship_Republic_AAT = 0, 3"			
		,"Flagship_Republic_AAM | Flagship_Republic_AAN | Flagship_Republic_AAO | Flagship_Republic_AAP | Flagship_Republic_AAV | Flagship_Republic_AAW = 0, 2"	
		,"Flagship_Republic_AAX | Flagship_Republic_AAY | Flagship_Republic_AAZ | Flagship_Republic_ABA | Flagship_Republic_ABB = 0, 2"	
		,"Flagship_Republic_ABC | Flagship_Republic_ABD | Flagship_Republic_ABE = 0, 1"				
		
		,"Flagship_Hutt_Cartels_AAA | Flagship_Hutt_Cartels_AAB | Flagship_Hutt_Cartels_AAF | Flagship_Hutt_Cartels_AAG | Flagship_Hutt_Cartels_AAH | Flagship_Hutt_Cartels_AAI | Flagship_Hutt_Cartels_AAO | Flagship_Hutt_Cartels_AAP | Flagship_Hutt_Cartels_AAQ | Flagship_Hutt_Cartels_AAR | Flagship_Hutt_Cartels_AAY | Flagship_Hutt_Cartels_AAT	= 0, 5"
		,"Flagship_Hutt_Cartels_AAC | Flagship_Hutt_Cartels_AAD | Flagship_Hutt_Cartels_AAE | Flagship_Hutt_Cartels_AAJ | Flagship_Hutt_Cartels_AAN | Flagship_Hutt_Cartels_AAW = 0, 3"			
		,"Flagship_Hutt_Cartels_AAK | Flagship_Hutt_Cartels_AAL  = 0, 2"	
		,"Flagship_Hutt_Cartels_AAM | Flagship_Hutt_Cartels_AAS | Flagship_Hutt_Cartels_AAX | Flagship_Hutt_Cartels_AAU = 0, 2"	
		,"Flagship_Hutt_Cartels_AAV = 0, 1"				
		}
	
	}
	
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
	while (current_sleep_seconds < max_sleep_seconds) do
		current_sleep_seconds = current_sleep_seconds + 1
		Sleep(1)
	end

	ScriptExit()
end