require("PGStoryMode")
require("PGSpawnUnits")
require("deepcore/std/class")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")
require("eawx-util/UnitUtil")
require("deepcore/crossplot/crossplot")
require("TRCommands")
require("HeroFighterLibrary")
require("SetFighterResearch")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	Define_State("State_Init", State_Init);

end

function State_Init(message)
	if message == OnEnter then
		if Get_Game_Mode() ~= "Land" then
			ScriptExit()
		end

		if TestValid(Find_First_Object("Scripted_Battle_Marker")) then
			ScriptExit()
		end

		if not ModContentLoader then
            ModContentLoader = require("eawx-std/ModContentLoader")
		end

		CONSTANTS = ModContentLoader.get("GameConstants")
		
		players = {}
		
		p_attacker = false
		
		p_neutral = Find_Player("Neutral")
		
		for _, player_name in pairs(CONSTANTS.PLAYABLE_FACTIONS) do
			player_object = Find_Player(player_name)
			if player_object.Is_Human() then
				p_human = player
				p_human_object = player_object
			end
			
			if table.getn(Find_All_Objects_Of_Type(player_object)) > 0 then
				table.insert(players, player_object)
			end
		end

		p_attacker = MissionUtil.Find_Attacking_Player()
		p_defender = MissionUtil.Find_Defending_Player()

		victory_point_present = false
		
		victoryPoint = Find_First_Object("Victory_Point")
		
		if TestValid(victoryPoint) then
			victory_point_present = true
		end

		Sleep(2)

		local FighterHeroes = Get_Hero_Entries()
		for index, entry in pairs(FighterHeroes) do
			if entry.GroundCompany ~= nil then
				local perception
				local reinforce = false
				if entry.GroundReinforcementPerception ~= nil then
					perception = entry.GroundReinforcementPerception
					reinforce = true
					if entry.NoSpawnFlag ~= nil then
						local nope = GlobalValue.Get(entry.NoSpawnFlag)
						if nope then
							reinforce = false
						end
					end
				else
					local host = Get_Fighter_Hero(entry.Hero_Squadron)
					if host ~= nil then
						local oktospawn = true
						if entry.NoSpawnFlag then
							if GlobalValue.Get(entry.NoSpawnFlag) ~= nil then
								oktospawn = false
							end
						end
						if oktospawn then
							for index2, option in pairs(entry.Options) do
								for index3, Location in pairs(option.Locations) do
									if Location == host then
										perception = option.GroundPerception
										reinforce = true
									end
								end
							end
						end
					end
				end
				if reinforce then
					for _, faction in pairs(entry.Factions) do
						local Rogue_host = Evaluate_In_Galactic_Context(perception, Find_Player(faction))
						if Rogue_host > 0 then
							local comp = entry.GroundCompany
							if type(comp) == "table" then
								comp = comp[Get_Hero_Index(index, true)]
							end
							Add_Reinforcement(comp, Find_Player(faction))
							break
						end
					end
				end
			end
		end

		if p_attacker.Is_Human() then
			if victory_point_present and not TestValid(Find_First_Object("Scripted_Battle_Marker")) then
				Story_Event("CAPTURE_POINT_PRESENT")
			end
		end
		if p_defender.Is_Human() then
			if victory_point_present and not TestValid(Find_First_Object("Scripted_Battle_Marker")) then
				Story_Event("CAPTURE_POINT_PRESENT_DEFENDER")
			end
		end
	end
end