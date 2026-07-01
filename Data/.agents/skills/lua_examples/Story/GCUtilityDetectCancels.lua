require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
-- require("deepcore/crossplot/crossplot")
CONSTANTS = ModContentLoader.get("GameConstants")

function Definitions()
	-- DebugMessage("%s -- In Definitions", tostring(Script))

	ServiceRate = 0.005

	StoryModeEvents = {
		Trigger_Initialize_GCUtilityDetectCancels = State_Initialize_GCUtilityDetectCancels,
		Click_Create_00 = State_Reset_Buttons,
		Click_Create_01 = State_Reset_Buttons,
		Click_Create_02 = State_Reset_Buttons,
		Click_Create_03 = State_Reset_Buttons,
		Click_Create_04 = State_Reset_Buttons,
		Click_Create_05 = State_Reset_Buttons,
		Click_Create_06 = State_Reset_Buttons,
		Click_Create_07 = State_Reset_Buttons,
		Click_Create_08 = State_Reset_Buttons,
		Click_Create_09 = State_Reset_Buttons,
		Click_Create_10 = State_Reset_Buttons,
		Click_Create_11 = State_Reset_Buttons,
		Click_Create_12 = State_Reset_Buttons,
		Click_Create_13 = State_Reset_Buttons,
		Click_Create_14 = State_Reset_Buttons,
		Click_Create_15 = State_Reset_Buttons,
		Click_Create_16 = State_Reset_Buttons,
		Click_Create_17 = State_Reset_Buttons,
		Click_Create_18 = State_Reset_Buttons,
		Click_Create_19 = State_Reset_Buttons,
		Click_Create_20 = State_Reset_Buttons,
		Click_Create_21 = State_Reset_Buttons,
		Click_Create_22 = State_Reset_Buttons,
		Click_Create_23 = State_Reset_Buttons,
		Click_Create_24 = State_Reset_Buttons,
		Click_Create_25 = State_Reset_Buttons,
		Click_Create_26 = State_Reset_Buttons,
		Click_Create_27 = State_Reset_Buttons,
		Click_Create_28 = State_Reset_Buttons,
		Click_Create_29 = State_Reset_Buttons,
		Click_Create_30 = State_Reset_Buttons
	}

	player = nil

	-- crossplot:subscribe("UPDATED_AVAILABILITY", Enable_Buttons)
end

function State_Initialize_GCUtilityDetectCancels(message)
	if message == OnEnter then
		for _,faction_name in pairs(CONSTANTS.PLAYABLE_FACTIONS) do
			player = Find_Player(faction_name)
			if player.Is_Human() then
				break
			end
		end
	end

	Detect_Cancellation(message)
end

function State_Reset_Buttons(message)
	Story_Event("CANCELED_OBJECT")
	Story_Event("RESTORE_BUTTONS")
	Detect_Cancellation(message)
end

function Detect_Cancellation(message)
	if message == OnEnter then
		if TestValid(player) then
			credits = player.Get_Credits()
		else
			credits = 0
		end

	elseif message == OnUpdate then
		-- crossplot:update()

		oldCredits = credits
		if TestValid(player) then
			credits = player.Get_Credits()
			if oldCredits ~= credits then
				Story_Event("CANCELED_OBJECT")
				-- crossplot:publish("UPDATE_AVAILABILITY", "empty")
			end
		end
	end
end

-- function Enable_Buttons()
	-- Story_Event("RESTORE_BUTTONS")
-- end
