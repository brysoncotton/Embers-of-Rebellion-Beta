require("PGStateMachine")
require("PGSpawnUnits")
require("PGMoveUnits")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")

function Definitions()
	Define_State("State_Init", State_Init)
end

function State_Init(message)
	if Get_Game_Mode() ~= "Space" then
		ScriptExit()
	end
	if Find_Hint("ATTACKER ENTRY POSITION", "main-menu-battle-disable-me") then
		ScriptExit()
	end
	if message == OnEnter then
		local p_attacker = MissionUtil.Find_Attacking_Player()
		local p_defender = MissionUtil.Find_Defending_Player()

		local active_shield_attacker = Evaluate_In_Galactic_Context("Planetary_Shield_Present", p_defender)
		local active_shield_defender = Evaluate_In_Galactic_Context("Planetary_Shield_Present", p_defender)
		if active_shield_attacker == 1 or active_shield_defender == nil then
			Hide_Sub_Object(Object, 0, "Shield")
		end
		ScriptExit()
	end
end