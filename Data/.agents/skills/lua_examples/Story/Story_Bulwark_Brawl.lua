
--*****************************************************--
--********** Foerost Campaign: Bulwark Brawl **********--
--*****************************************************--

require("PGBase")
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
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")

	act_1_active = false

	generic_battle = false

	screed_dead = false
	screed_present = false

	dodonna_dead = false
	dodonna_present = false
end
function Begin_Battle(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			scripted_battle_marker = Find_First_Object("SCRIPTED_BATTLE_MARKER")
			if TestValid(scripted_battle_marker) then
				ScriptExit()
			end

			attacker_marker = Find_First_Object("Attacker Entry Position")
			defender_marker = Find_First_Object("Defending Forces Position")
			map_middle_marker = Create_Position(0, 0, 0)

			if TestValid(Find_First_Object("Screed_Arlionne")) then
				act_1_active = true
				screed_present = true

				Create_Thread("State_Showdown_Screed")
			elseif not TestValid(Find_First_Object("Screed_Arlionne")) then
				screed_present = false
			end

			if TestValid(Find_First_Object("Dodonna_Ardent")) then
				act_1_active = true
				dodonna_present = true

				Create_Thread("State_Showdown_Dodonna")
			elseif not TestValid(Find_First_Object("Dodonna_Ardent")) then
				dodonna_present = false
			end

			if not screed_present and not dodonna_present then
				generic_battle = true -- If no one is here, this ain't the battle you are looking for
			end
		elseif p_republic.Is_Human() then
			scripted_battle_marker = Find_First_Object("SCRIPTED_BATTLE_MARKER")
			if TestValid(scripted_battle_marker) then
				ScriptExit()
			end

			attacker_marker = Find_First_Object("Attacker Entry Position")
			defender_marker = Find_First_Object("Defending Forces Position")
			map_middle_marker = Create_Position(0, 0, 0)

			if TestValid(Find_First_Object("Dua_Ningo_Unrepentant")) then
				act_1_active = true
				ningo_present = true

				Create_Thread("State_Showdown_Ningo")
			elseif not TestValid(Find_First_Object("Dua_Ningo_Unrepentant")) then
				ningo_present = false
			end

			if not ningo_present then
				generic_battle = true -- If no one is here, this ain't the battle you are looking for
			end

		end
	end
end

function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			if TestValid(Find_First_Object("Screed_Arlionne")) then
				if not screed_dead then
					Find_First_Object("Screed_Arlionne").Set_Cannot_Be_Killed(true)
					if Find_First_Object("Screed_Arlionne").Get_Hull() <= 0.01 then
						screed_dead = true

						Create_Thread("State_Screed_Escaped")
						MissionUtil.MissionTextSpeech("BULWARK_BRAWL", 2, 9.5, nil, {r = 255, g = 255, b = 255})
					end
				end
			end
			if TestValid(Find_First_Object("Dodonna_Ardent")) then
				if not dodonna_dead then
					Find_First_Object("Dodonna_Ardent").Set_Cannot_Be_Killed(true)
					if Find_First_Object("Dodonna_Ardent").Get_Hull() <= 0.01 then
						dodonna_dead = true

						Create_Thread("State_Dodonna_Escaped")
						MissionUtil.MissionTextSpeech("BULWARK_BRAWL", 3, 9.5, nil, {r = 255, g = 255, b = 255})
					end
				end
			end
		end
		if generic_battle then
			if TestValid(Find_First_Object("Screed_Arlionne")) and not screed_present then
				act_1_active = true
				generic_battle = false
				screed_present = true

				Story_Event("PLAYER_CIS")
				Create_Thread("State_Showdown_Screed")
			end
			if TestValid(Find_First_Object("Dodonna_Ardent")) and not dodonna_present then
				act_1_active = true
				generic_battle = false
				dodonna_present = true

				Story_Event("PLAYER_CIS")
				Create_Thread("State_Showdown_Dodonna")
			end
		end
	elseif p_republic.Is_Human() then
		if act_1_active then
			if TestValid(Find_First_Object("Dua_Ningo_Unrepentant")) then
				if not ningo_dead then
					if Find_First_Object("Dua_Ningo_Unrepentant").Get_Hull() <= 0.01 then
						ningo_dead = true

						Create_Thread("State_Ningo_Escaped")
						MissionUtil.MissionTextSpeech("BULWARK_BRAWL", 1, 9.5, "Sian_Tevv_Loop", {r = 255, g = 255, b = 255})
					end
				end
			end
		end
		if generic_battle then
			if TestValid(Find_First_Object("Dua_Ningo_Unrepentant")) and not ningo_present then
				act_1_active = true
				generic_battle = false
				ningo_present = true

				Story_Event("PLAYER_REP")
				Create_Thread("State_Showdown_Ningo")
			end
		end
	end
end

function State_Showdown_Screed()
	if p_cis.Is_Human() then
		if TestValid(Find_First_Object("Screed_Arlionne")) then
			Find_First_Object("Screed_Arlionne").Set_Cannot_Be_Killed(true)
		end
	end
end
function State_Screed_Escaped()
	if p_cis.Is_Human() then
		Find_First_Object("Screed_Arlionne").Hyperspace_Away(true)
		Sleep(5.0)
		if TestValid(Find_First_Object("Screed_Arlionne")) then
			Find_First_Object("Screed_Arlionne").Despawn()
		end
	end
end

function State_Showdown_Dodonna()
	if p_cis.Is_Human() then
		if TestValid(Find_First_Object("Dodonna_Ardent")) then
			Find_First_Object("Dodonna_Ardent").Set_Cannot_Be_Killed(true)
		end
	end
end
function State_Dodonna_Escaped()
	if p_cis.Is_Human() then
		Find_First_Object("Dodonna_Ardent").Hyperspace_Away(true)
		Sleep(5.0)
		if TestValid(Find_First_Object("Dodonna_Ardent")) then
			Find_First_Object("Dodonna_Ardent").Despawn()
		end
	end
end

function State_Showdown_Ningo()
	if p_republic.Is_Human() then
		if TestValid(Find_First_Object("Dua_Ningo_Unrepentant")) then
			Find_First_Object("Dua_Ningo_Unrepentant").Set_Cannot_Be_Killed(true)
		end
	end
end
function State_Ningo_Escaped()
	if p_republic.Is_Human() then
		Find_First_Object("Dua_Ningo_Unrepentant").Hyperspace_Away(true)
		Sleep(5.0)
		if TestValid(Find_First_Object("Dua_Ningo_Unrepentant")) then
			Find_First_Object("Dua_Ningo_Unrepentant").Despawn()
		end
	end
end


