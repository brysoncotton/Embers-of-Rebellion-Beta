
--*****************************************************--
--******* Operation Durge's Lance: Crazy Clone ********--
--*****************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")

function Definitions()
	ServiceRate = 1
	Define_State("State_Init", State_Init);
end

function State_Init(message)
	if message == OnEnter then
		if Get_Game_Mode() ~= "Space"  then
            ScriptExit()
        end

		raid_feet_marker = Find_First_Object("MAP_CORNER")

		clone_saver_list = {
			"Venator_Star_Destroyer",
			"Venator_Star_Destroyer",
			"Venator_Star_Destroyer",
			"Venator_Star_Destroyer",
			"Pelta_Support",
			"Pelta_Support",
			"Pelta_Support",
			"Arquitens",
			"Arquitens",
			"Arquitens",
			"Arquitens",
		}

        if Get_Game_Mode() == "Space" then
			Object.Highlight(true)
			Add_Radar_Blip(Object, "Mad_Clone_Blip")
			Add_Objective("TEXT_MISSION_CRAZY_CLONE_OBJECTIVE_CIS_04", false)

			Clone_Saver_Fleet = SpawnList(clone_saver_list, raid_feet_marker, p_republic, false, true)
			Clone_Saver = Clone_Saver_Fleet[1]
			Clone_Saver.Teleport_And_Face(raid_feet_marker)
			Clone_Saver.Cinematic_Hyperspace_In(100)
		end
	end
end


