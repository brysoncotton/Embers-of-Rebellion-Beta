-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/Evaluators/GetDistanceToNearestWithProperty.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/Evaluators/GetDistanceToNearestWithProperty.lua $
--
--    Original Author: Steve_Copeland
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

require("PGCommands")

function Clean_Up()
	-- any temporary object pointers need to be set to nil in this function.
	-- ie: Target = nil
	nearest_obj = nil
end

-- Receives:
-- property_flag_name as defined in GameObjectPropertiesType.xml
-- affiliation_type is optional qualifier of "enemy" or "friendly"
function Evaluate(property_flag_name, affiliation_type)
	
	if affiliation_type == "ENEMY" then
		nearest_obj = PruneFriendlyObjects(Find_All_Objects_Of_Type(property_flag_name))
	elseif affiliation_type == "FRIENDLY" then
		--only issue here is in skirmish, PlayerObject does not own the allied starbase in some cases
		--notably when an AI is on the same team as a human player
		nearest_obj = Find_All_Objects_Of_Type(property_flag_name, PlayerObject)
	else
		nearest_obj = Find_All_Objects_Of_Type(property_flag_name)
	end
	
	--DebugMessage("%s -- First %s object with property %s for player %s, to %s is %s", tostring(Script), tostring(affiliation_type), tostring(property_flag_name), tostring(PlayerObject.Get_Faction_Name()), tostring(Target), tostring(nearest_obj[1]))
	if TestValid(nearest_obj[1]) then
		--DebugMessage("%s -- Distance is %s", tostring(Script), tostring(Target.Get_Distance(nearest_obj[1])))
		return Target.Get_Distance(nearest_obj[1])
	else
		return BIG_FLOAT
	end
end




