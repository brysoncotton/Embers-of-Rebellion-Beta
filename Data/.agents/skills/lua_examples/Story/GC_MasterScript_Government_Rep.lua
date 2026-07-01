--****************************************************--
--***  Fall of the Republic: Government Republic   ***--
--****************************************************--

require("PGStoryMode")
require("PGBase")
require("PGSpawnUnits")
require("eawx-util/ChangeOwnerUtilities")
require("eawx-util/StoryUtil")
require("deepcore/crossplot/crossplot")
require("deepcore/std/class")
require("deepcore/std/Observable")
require("eawx-util/GalacticUtil")
require("SetFighterResearch")
require("eawx-util/UnitUtil")

ModContentLoader = require("eawx-std/ModContentLoader")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents = {
			Trigger_Choice_Enhanced_Security = State_Choice_Enhanced_Security,
			Trigger_Choice_Kuat_Power_Struggle = State_Choice_Kuat_Power_Struggle,
			Trigger_Choice_Military_Enhancement = State_Choice_Military_Enhancement,
			Trigger_Choice_Order_6X = State_Choice_Order_6X,
			Trigger_Choice_Sector_Governance = State_Choice_Sector_Governance,

			Trigger_Order_66_Despawn_Jedi = State_Order_66_Despawn_Jedi,
			Trigger_Order_66_Prompt_Knightfall = State_Order_66_Prompt_Knightfall,
			Trigger_Order_66_Post_Tactical_Knightfall = State_Order_66_Post_Tactical_Knightfall,

			Trigger_Republic_KDY_Contract_Proposal = State_Republic_KDY_Contract_Proposal
	}

	crossplot:galactic()
end

--Senate support event popups
function State_Choice_Enhanced_Security(message)
	if message == OnEnter then
		crossplot:publish("POPUPEVENT", "SENATE_CHOICE_ENH_SEC", {"MOTHMA","TARKIN"}, { },
				{ }, { },
				{ }, { },
				{ }, { },
				"SENATE_CHOICE_ENH_SEC_OPTION")
	else
		crossplot:update()
	end
end

function State_Choice_Kuat_Power_Struggle(message)
	if message == OnEnter then
		crossplot:publish("POPUPEVENT", "SENATE_CHOICE_KUAT", {"ONARA","GIDDEAN"}, { },
				{ }, { },
				{ }, { },
				{ }, { },
				"SENATE_CHOICE_KUAT_OPTION")
	else
		crossplot:update()
	end
end

function State_Choice_Military_Enhancement(message)
	if message == OnEnter then
		crossplot:publish("POPUPEVENT", "SENATE_CHOICE_MIL_ENH", {"MOTHMA","PESTAGE"}, { },
				{ }, { },
				{ }, { },
				{ }, { },
				"SENATE_CHOICE_MIL_ENH_OPTION")
	else
		crossplot:update()
	end
end

function State_Choice_Order_6X(message)
	if message == OnEnter then
		crossplot:publish("POPUPEVENT", "SENATE_CHOICE_ORDER_6X", {"ORDER_65","ORDER_66"}, { },
				{ }, { },
				{ }, { },
				{ }, { },
				"SENATE_CHOICE_ORDER_6X_OPTION")
	else
		crossplot:update()
	end
end

function State_Choice_Sector_Governance(message)
	if message == OnEnter then
		crossplot:publish("POPUPEVENT", "SENATE_CHOICE_SEC_GOV", {"MOTHMA","PESTAGE"}, { },
				{ }, { },
				{ }, { },
				{ }, { },
				"SENATE_CHOICE_SEC_GOV_OPTION")
	else
		crossplot:update()
	end
end

--Order 66 sub-events spaced out by story dialogs for human player
function State_Order_66_Despawn_Jedi(message)
	if message == OnEnter then
		crossplot:publish("EXECUTE_ORDER_66", "DespawnJedi")
	else
		crossplot:update()
	end
end

function State_Order_66_Prompt_Knightfall(message)
	if message == OnEnter then
		crossplot:publish("EXECUTE_ORDER_66", "PromptKnightfall")
	else
		crossplot:update()
	end
end

function State_Order_66_Post_Tactical_Knightfall(message)
	if message == OnEnter then
		crossplot:publish("EXECUTE_ORDER_66", "PostTacticalKnightfall")
	else
		crossplot:update()
	end
end

--KDY contract events
function State_Republic_KDY_Contract_Proposal(message)
	if message == OnEnter then
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Dummy_KDY_Contract"))
	end
end
