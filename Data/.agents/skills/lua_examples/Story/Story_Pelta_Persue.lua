
--*****************************************************--
--****** Hunt for the Malevolence: Pelta Persue *******--
--*****************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents =
	{
		Battle_Start = Begin_Battle,
		Trigger_Showdown_Yularen = State_Showdown_Yularen,
		Trigger_Yularen_Escaped = State_Yularen_Escaped,
		Trigger_Pelta_Assault_Kill_Counter = State_Pelta_Assault_Kill_Counter,
		Trigger_Pelta_Support_Kill_Counter = State_Pelta_Support_Kill_Counter,
		Trigger_Pelta_Assault_Skirmish_Kill_Counter = State_Pelta_Assault_Skirmish_Kill_Counter,
		Trigger_Pelta_Support_Skirmish_Kill_Counter = State_Pelta_Support_Skirmish_Kill_Counter,
		Trigger_Haven_Kill_Counter = State_Haven_Kill_Counter,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")

	act_1_active = false

	generic_battle = false

	yularen_dead = false
	yularen_present = false

	camera_offset = 125
end

function Begin_Battle(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			Story_Event("PLAYER_CIS")
			player_yularen = Find_First_Object("YULAREN_RESOLUTE")
			if TestValid(player_yularen) then
				act_1_active = true
				yularen_present = true
				Story_Event("VALID_YULAREN")
			elseif not TestValid(player_yularen) then
				yularen_present = false
				generic_battle = true -- If the Malevolence isn't there, this ain't the battle you are looking for
			end
			player_haven_station = Find_First_Object("EMPIRE_STAR_BASE_1")
			if TestValid(player_haven_station) then
				Add_Objective("TEXT_MISSION_PELTA_PERSUE_OBJECTIVE_CIS_02", false)
			end
		end
	end
end


function State_Showdown_Yularen(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			if TestValid(Find_First_Object("YULAREN_RESOLUTE")) then
				Find_First_Object("YULAREN_RESOLUTE").Set_Cannot_Be_Killed(true)
				Add_Objective("TEXT_MISSION_PELTA_PERSUE_OBJECTIVE_CIS_01", false)
			end
		end
	end
end

function State_Yularen_Escaped(message)
	if message == OnEnter then
		if TestValid(Find_First_Object("YULAREN_RESOLUTE")) then
			Find_First_Object("YULAREN_RESOLUTE").Hyperspace_Away(true)
			Sleep(8.0)

			Find_First_Object("YULAREN_RESOLUTE").Despawn()
		end
	end
end

function State_Pelta_Assault_Kill_Counter(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			pelta_kills = GlobalValue.Get("CIS_Pelta_Kill_Count")
			GlobalValue.Set("CIS_Pelta_Kill_Count", pelta_kills + 1)
		end
	end
end

function State_Pelta_Support_Kill_Counter(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			pelta_kills = GlobalValue.Get("CIS_Pelta_Kill_Count")
			GlobalValue.Set("CIS_Pelta_Kill_Count", pelta_kills + 1)
		end
	end
end

function State_Pelta_Assault_Skirmish_Kill_Counter(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			pelta_kills = GlobalValue.Get("CIS_Pelta_Kill_Count")
			GlobalValue.Set("CIS_Pelta_Kill_Count", pelta_kills + 1)
		end
	end
end

function State_Pelta_Support_Skirmish_Kill_Counter(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			pelta_kills = GlobalValue.Get("CIS_Pelta_Kill_Count")
			GlobalValue.Set("CIS_Pelta_Kill_Count", pelta_kills + 1)
		end
	end
end

function State_Haven_Kill_Counter(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			haven_kills = GlobalValue.Get("CIS_Haven_Kill_Count")
			GlobalValue.Set("CIS_Haven_Kill_Count", haven_kills + 1)
		end
	end
end


function Story_Handle_Esc()
end

function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			if not yularen_dead then
				if Find_First_Object("Yularen_Resolute").Get_Hull() <= 0.01 then
					Story_Event("YULAREN_ESCAPED")
					yularen_dead = true
				end
			end
		end
		if generic_battle then
			if TestValid(Find_First_Object("Yularen_Resolute")) and not yularen_present then
				act_1_active = true
				Story_Event("PLAYER_CIS")
				Story_Event("VALID_YULAREN")
				generic_battle = false
				yularen_present = true
			end
		end
	end
end
