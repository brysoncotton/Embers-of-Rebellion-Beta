--******************************************************************************
--     _______ __
--    |_     _|  |--.----.---.-.--.--.--.-----.-----.
--      |   | |     |   _|  _  |  |  |  |     |__ --|
--      |___| |__|__|__| |___._|________|__|__|_____|
--     ______
--    |   __ \.-----.--.--.-----.-----.-----.-----.
--    |      <|  -__|  |  |  -__|     |  _  |  -__|
--    |___|__||_____|\___/|_____|__|__|___  |_____|
--                                    |_____|
--*   @Author:              [TR]Pox
--*   @Date:                2017-08-20T21:31:11+02:00
--*   @Project:             Imperial Civil War
--*   @Filename:            Survival_GC_Script_Remnant.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2017-12-21T13:18:38+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************



require("PGStateMachine")
require("PGStoryMode")




function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))
	StoryModeEvents = {
		Universal_Story_Start = Begin_GC,
		STORY_FLAG_Battle_Over = Get_WaveCount
	}
end

function Begin_GC(message)
	if message == OnEnter then
		GlobalValue.Set("Survival_Mode", 1)
	end
end

function Get_WaveCount(message)
	if message == OnEnter then
		wave_count = GlobalValue.Get("WaveCount") -1

		--wave_count = 5
		plot = Get_Story_Plot("Story_Sandbox_Battle_Remnant.xml")
		event = plot.Get_Event("Show_Wave_Dialog")
		dialog = "Dialog_Survival"

		event.Set_Dialog(dialog)
		event.Clear_Dialog_Text()
		--event.Add_Dialog_Text("TEXT_UNIT_VENGEANCE_FRIGATE")
		event.Add_Dialog_Text("TEXT_WAVES_SURVIVED", wave_count)
		Story_Event("DIALOG")
	end
end
