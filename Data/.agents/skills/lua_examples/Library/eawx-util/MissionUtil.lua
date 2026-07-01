require("PGStoryMode")
require("PGSpawnUnits")
require("PGBaseDefinitions")
require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
require("eawx-util/StoryUtil")

MissionUtil = {}

--GC intervention mission functions

function MissionUtil.InsertDistribution(UnitTable, distribution)
    for k, PotentialUnit in pairs(UnitTable) do
        if PotentialUnit[1] ~= nil then
            distribution.Insert(PotentialUnit[1], PotentialUnit[2])
        end
    end
    return
end

function MissionUtil.SelectUnitObject(CombatPower, distribution, NoGamble, HardLimit)
	local MaxAmount = 5
    if NoGamble then
        if HardLimit == nil then
            HardLimit = 5
        end
        MaxAmount = GameRandom.Free_Random(1, HardLimit)
    end
    local SpawnUnit = distribution.Sample()
    if not SpawnUnit then
        return nil
    end
    local SpawnAmount = CombatPower / SpawnUnit.Get_Build_Cost()
    if SpawnAmount < 1 then
        SpawnAmount = 1
    end
    if SpawnAmount > MaxAmount then
        SpawnAmount = MaxAmount
    end
    return SpawnUnit, SpawnAmount
end

function MissionUtil.SelectBuilding(player, tag)
	local BuildList = nil
	local BuildEntry = {}
	local RandomEntry = 0
	if type(player) == "string" then
		player = Find_Player(player)
	end
	MasterBuildingTable = require("eawx-plugins/intervention-missions/build-options/BuildOptionTables_"..player.Get_Faction_Name())

	BuildList = MasterBuildingTable[tag]

	if BuildList == nil then
		return "THIS IS A BUG PLEASE TELL US! Error D; faction = "..player.Get_Faction_Name().."; tag = "..tostring(tag), 0
	elseif table.getn(BuildList) == 0 then
		return "THIS IS A BUG PLEASE TELL US! Error E; faction = "..player.Get_Faction_Name().."; tag = "..tostring(tag), 0
	end

	RandomEntry = GameRandom.Free_Random(1, table.getn(BuildList))
	BuildEntry = BuildList[RandomEntry]

	if BuildEntry == nil then
		return "THIS IS A BUG PLEASE TELL US! Error F; faction = "..player.Get_Faction_Name().."; tag = "..tostring(tag).."; RandomEntry = "..tostring(RandomEntry), 0
	elseif TestValid(Find_Object_Type(BuildEntry[1])) == 0 then
		return "THIS IS A BUG PLEASE TELL US! Error G; faction = "..player.Get_Faction_Name().."; tag = "..tostring(tag).."; BuildEntry[1] = "..tostring(BuildEntry[1]), 0
	end

	return BuildEntry[1], BuildEntry[2]
end

function MissionUtil.SelectReward(player, tag, tier)
	local UnitList = nil
	local era_tag = "Era_" .. tostring(GlobalValue.Get("CURRENT_ERA"))
	local RewardTable = {}
	local RandomEntry = 0
	if type(player) == "string" then
		player = Find_Player(player)
	end
	MasterUnitTable = require("eawx-plugins/intervention-missions/rewards/RewardTables_"..player.Get_Faction_Name())

	if tag == "ERA" then
		UnitList = MasterUnitTable[era_tag][tier]
	else
		UnitList = MasterUnitTable[tag][tier]
	end

	if table.getn(UnitList) == 0 then
		return nil, 0, "THIS IS A BUG PLEASE TELL US! Error A; tag = "..tostring(tag).."; era = "..tostring(era_tag).."; tier = "..tostring(tier)
	end

	local choice = nil
	local year = GlobalValue.Get("GALACTIC_YEAR")
	if year == nil then
		year = 0
	end

	local ValidUnitList = {}
	for _,entry in pairs(UnitList) do
		local disqualified_flag = false

		local start = entry["StartYear"]
		local last = entry["LastYear"]
		if not ((start == nil or year >= start) and (last == nil or year <= last)) then
			disqualified_flag = true
		end

		local disablingevent = entry["DisablingEvent"]
		if disablingevent ~= nil then
			local disablingevent = GlobalValue.Get(disablingevent)
			if disablingevent == true then
				disqualified_flag = true
			end
		end

		local enablingevent = entry["EnablingEvent"]
		if enablingevent ~= nil then
			local enablingevent = GlobalValue.Get(enablingevent)
			if enablingevent ~= true then
				disqualified_flag = true
			end
		end

		local requiredhero = entry["RequiredHero"]
		if requiredhero ~= nil then
			if not TestValid(Find_First_Object(requiredhero)) then
				disqualified_flag = true
			end
		end

		if disqualified_flag == false then
			table.insert(ValidUnitList,entry)
		end
	end

	if table.getn(ValidUnitList) == 0 then
		return nil, 0, "THIS IS A BUG PLEASE TELL US! Error B; tag = "..tostring(tag).."; era = "..tostring(era_tag).."; tier = "..tostring(tier)
	end

	RandomEntry = GameRandom.Free_Random(1, table.getn(ValidUnitList))
	RewardTable = ValidUnitList[RandomEntry]

	if not TestValid(Find_Object_Type(RewardTable[1])) then
		return nil, 0, "THIS IS A BUG PLEASE TELL US! Error C; tag = "..tostring(tag).."; era = "..tostring(era_tag).."; tier = "..tostring(tier).."; unit type = "..tostring(RewardTable[1])
	end

	return RewardTable[1], RewardTable[2]
end

function MissionUtil.FindLowInfluencePlanet(player, amount)
    if amount == 0 then
        return nil
    end

	if type(player) == "string" then
		player = Find_Player(player)
	end

	local target_planet_list = {}
	local allPlanets = FindPlanet.Get_All_Planets()
	
	local owner = nil
	local influence_level = nil

	for _,planet in pairs(allPlanets) do
		owner = planet.Get_Owner()
		influence_level = EvaluatePerception("Planet_Influence_Value", owner, planet)
		if influence_level == nil then
			return nil
		end
		if owner == player and influence_level < 5 then
			table.insert(target_planet_list, planet)
		end
	end

    local planet_count = table.getn(target_planet_list)

    if planet_count == 0 then
        return nil
    end

    if amount > planet_count then
        amount = planet_count
    end

    if amount > 5 then
        amount = 5
    end

    local random = 0
    local new_target = nil
    local target01 = nil
    local target02 = nil
    local target03 = nil
    local target04 = nil
    local target05 = nil

    repeat
        random = GameRandom.Free_Random(1, planet_count)
        new_target = target_planet_list[random]
        table.remove(target_planet_list, random)
        
        if target01 == nil then
            target01 = new_target
        elseif target02 == nil then
            target02 = new_target
        elseif target03 == nil then
            target03 = new_target
        elseif target04 == nil then
            target04 = new_target
        else
            target05 = new_target
        end
        
        planet_count = planet_count - 1
        amount = amount - 1
    until amount == 0
    
    if target05 ~= nil then
        return target01,target02,target03,target04,target05
    elseif target04 ~= nil then 
        return target01,target02,target03,target04
    elseif target03 ~= nil then 
        return target01,target02,target03
    elseif target02 ~= nil then 
        return target01,target02
    else
        return target01
    end
end

--unused
function MissionUtil.TravelConvoy(player, human_player, current_planet)
	if type(player) == "string" then
		player = Find_Player(player)
	end

	if type(human_player) == "string" then
		human_player = Find_Player(human_player)
	end

    local allPlanets = FindPlanet.Get_All_Planets()

    local random = 0
    local target_planet = nil
    local planet = nil

	while table.getn(allPlanets) > 0 do
		random = GameRandom.Free_Random(1, table.getn(allPlanets))
		target_planet = allPlanets[random]
		table.remove(allPlanets, random)

		if target_planet.Get_Owner() == player 
			and EvaluatePerception("Is_Connected_To_Me", human_player, target_planet) == 1
			and EvaluatePerception("Is_Important_Planet", player, target_planet) == 0 then
			if current_planet then
				convoy_path = Find_Path(player, current_planet, target_planet)
				if convoy_path then
					for _,planet in pairs(convoy_path) do
						if TestValid(planet) then
							if EvaluatePerception("Is_Owned_By_Ally", player, planet) then
								return target_planet
							else
								if table.getn(convoy_path) > 1 then
									target_planet = convoy_path[2]
									if target_planet.Get_Owner() == player then
										return target_planet
									else
										return nil
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function MissionUtil.RestrictAutoresolve(planet, allow_autoresolve)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local restrictAutoresolveEvent = plot.Get_Event(StoryUtil.RestrictAutoresolveEventName)

    if not restrictAutoresolveEvent then
        return
    end

    local is_allowed = 1
    if allow_autoresolve == false then
        is_allowed = 0
    end

    restrictAutoresolveEvent.Set_Reward_Parameter(0, planet)
    restrictAutoresolveEvent.Set_Reward_Parameter(1, is_allowed)
    Story_Event(StoryUtil.RestrictAutoresolveNotificationName)
end

function MissionUtil.EnableInvasion(planet, allow_invasion)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local enableInvasionEvent = plot.Get_Event(StoryUtil.EnableInvasionEventName)

    if not enableInvasionEvent then
        return
    end

    local is_allowed = 1
    if allow_invasion == false then
        is_allowed = 0
    end

    enableInvasionEvent.Set_Reward_Parameter(0, planet)
    enableInvasionEvent.Set_Reward_Parameter(1, is_allowed)
    Story_Event(StoryUtil.EnableInvasionNotificationName)
end

function MissionUtil.FlashPlanet(planet, flashId)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local flashPlanetEvent = plot.Get_Event(StoryUtil.FlashPlanetEventName)

    if not flashPlanetEvent then
        return
    end

    flashPlanetEvent.Set_Reward_Parameter(0, planet)
    flashPlanetEvent.Set_Reward_Parameter(3, flashId)
    Story_Event(StoryUtil.FlashPlanetNotificationName)

    local flashPlanetRemoveEvent = plot.Get_Event("Template_Flash_Planet_Remove")
    flashPlanetRemoveEvent.Set_Reward_Parameter(0, flashId)

    Story_Event(StoryUtil.CinematicSpeechNotificationName)
end

function MissionUtil.GalacticGoalComplete(textId)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local galacticGoalCompleteEvent = plot.Get_Event(StoryUtil.GalacticGoalCompleteEventName)

    if not galacticGoalCompleteEvent then
        return
    end

    galacticGoalCompleteEvent.Set_Reward_Parameter(0, textId)
    Story_Event(StoryUtil.GalacticGoalCompleteNotificationName)
end

function MissionUtil.GalacticGoalRemove(textId)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local galacticGoalRemoveEvent = plot.Get_Event(StoryUtil.GalacticGoalRemoveEventName)

    if not galacticGoalRemoveEvent then
        return
    end

    galacticGoalRemoveEvent.Set_Reward_Parameter(0, textId)
    Story_Event(StoryUtil.GalacticGoalRemoveNotificationName)
end


--tactical mission functions

function MissionUtil.SetObjectiveMissionSet(missionId, playerId, amount)
	local objectiveIndex = 0
	for i=1,amount do
		objectiveIndex = objectiveIndex + 1
		if amount < 10 then
			MissionUtil.SetObjectiveNew("TEXT_MISSION_"..missionId.."_OBJECTIVE_"..playerId.."_0"..objectiveIndex.."")
		else
			MissionUtil.SetObjectiveNew("TEXT_MISSION_"..missionId.."_OBJECTIVE_"..playerId.."_"..objectiveIndex.."")
		end
	end
end

function MissionUtil.SetObjectiveCleanUp()
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    Story_Event(StoryUtil.ObjectiveCleanUpNotificationName)
end

function MissionUtil.SetObjectiveComplete(textId)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local tacticalObjectiveEvent = plot.Get_Event(StoryUtil.ObjectiveCompleteEventName)

    if not tacticalObjectiveEvent then
        return
    end

    tacticalObjectiveEvent.Set_Reward_Parameter(0, textId)
    Story_Event(StoryUtil.ObjectiveCompleteNotificationName)
end

function MissionUtil.SetMissionObjectiveComplete(missionId, playerId, objectiveIndex)
	if objectiveIndex < 10 then
		MissionUtil.SetObjectiveComplete("TEXT_MISSION_"..missionId.."_OBJECTIVE_"..playerId.."_0"..objectiveIndex.."")
	else
		MissionUtil.SetObjectiveComplete("TEXT_MISSION_"..missionId.."_OBJECTIVE_"..playerId.."_"..objectiveIndex.."")
	end
end

function MissionUtil.SetObjectiveNew(textId)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local tacticalObjectiveEvent = plot.Get_Event(StoryUtil.ObjectiveNewEventName)

    if not tacticalObjectiveEvent then
        return
    end

    tacticalObjectiveEvent.Set_Reward_Parameter(0, textId)
    Story_Event(StoryUtil.ObjectiveNewNotificationName)
end

function MissionUtil.SetMissionObjectiveNew(missionId, playerId, objectiveIndex)
	if objectiveIndex < 10 then
		MissionUtil.SetObjectiveNew("TEXT_MISSION_"..missionId.."_OBJECTIVE_"..playerId.."_0"..objectiveIndex.."")
	else
		MissionUtil.SetObjectiveNew("TEXT_MISSION_"..missionId.."_OBJECTIVE_"..playerId.."_"..objectiveIndex.."")
	end
end

function MissionUtil.SetObjectiveUpdate(old_textId, new_textID)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local tacticalObjectiveEvent = plot.Get_Event(StoryUtil.ObjectiveUpdateEventName)

    if not tacticalObjectiveEvent then
        return
    end

    tacticalObjectiveEvent.Set_Reward_Parameter(0, old_textId)
    tacticalObjectiveEvent.Set_Reward_Parameter(1, new_textID)
    Story_Event(StoryUtil.ObjectiveUpdateNotificationName)
end

function MissionUtil.SetMissionObjectiveUpdate(missionId, playerId, objectiveIndexOld, objectiveIndexNew)
	if objectiveIndexOld < 10 and objectiveIndexNew < 10 then
		MissionUtil.SetObjectiveUpdate("TEXT_MISSION_"..missionId.."_OBJECTIVE_"..playerId.."_0"..objectiveIndexOld.."", "TEXT_MISSION_"..missionId.."_OBJECTIVE_"..playerId.."_0"..objectiveIndexNew.."")
	elseif objectiveIndexOld < 10 and objectiveIndexNew > 9 then
		MissionUtil.SetObjectiveUpdate("TEXT_MISSION_"..missionId.."_OBJECTIVE_"..playerId.."_0"..objectiveIndexOld.."", "TEXT_MISSION_"..missionId.."_OBJECTIVE_"..playerId.."_"..objectiveIndexNew.."")
	elseif objectiveIndexOld > 9 and objectiveIndexNew < 10 then
		MissionUtil.SetObjectiveUpdate("TEXT_MISSION_"..missionId.."_OBJECTIVE_"..playerId.."_"..objectiveIndexOld.."", "TEXT_MISSION_"..missionId.."_OBJECTIVE_"..playerId.."_0"..objectiveIndexNew.."")
	elseif objectiveIndexOld > 9 and objectiveIndexNew > 9 then
		MissionUtil.SetObjectiveUpdate("TEXT_MISSION_"..missionId.."_OBJECTIVE_"..playerId.."_"..objectiveIndexOld.."", "TEXT_MISSION_"..missionId.."_OBJECTIVE_"..playerId.."_"..objectiveIndexNew.."")
	end
end

function MissionUtil.SetObjectiveFailed(textId)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local tacticalObjectiveEvent = plot.Get_Event(StoryUtil.ObjectiveFailedEventName)

    if not tacticalObjectiveEvent then
        return
    end

    tacticalObjectiveEvent.Set_Reward_Parameter(0, textId)
    Story_Event(StoryUtil.ObjectiveFailedNotificationName)
end

function MissionUtil.SetMissionObjectiveFailed(missionId, playerId, objectiveIndex)
	if objectiveIndex < 10 then
		MissionUtil.SetObjectiveFailed("TEXT_MISSION_"..missionId.."_OBJECTIVE_"..playerId.."_0"..objectiveIndex.."")
	else
		MissionUtil.SetObjectiveFailed("TEXT_MISSION_"..missionId.."_OBJECTIVE_"..playerId.."_"..objectiveIndex.."")
	end
end

function MissionUtil.SetObjectiveRemove(textId)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local tacticalObjectiveEvent = plot.Get_Event(StoryUtil.ObjectiveRemoveEventName)

    if not tacticalObjectiveEvent then
        return
    end

    tacticalObjectiveEvent.Set_Reward_Parameter(0, textId)
    Story_Event(StoryUtil.ObjectiveRemoveNotificationName)
end

function MissionUtil.SetMissionObjectiveRemove(missionId, playerId, objectiveIndex)
	if objectiveIndex < 10 then
		MissionUtil.SetObjectiveRemove("TEXT_MISSION_"..missionId.."_OBJECTIVE_"..playerId.."_0"..objectiveIndex.."")
	else
		MissionUtil.SetObjectiveRemove("TEXT_MISSION_"..missionId.."_OBJECTIVE_"..playerId.."_"..objectiveIndex.."")
	end
end

function MissionUtil.HighlightObject(should_highlight, object, blip_tag)
	if should_highlight then
		object.Highlight(true)
		if blip_tag ~= nil then
			Add_Radar_Blip(object, blip_tag)
		end
	else
		object.Highlight(false)
		if blip_tag ~= nil then
			Remove_Radar_Blip(blip_tag)
		end
	end
end


function MissionUtil.PlayGenericSpeech(speechId)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local speechEvent = plot.Get_Event(StoryUtil.GenericSpeechEventName)

    if not speechEvent then
        return
    end

	Stop_All_Speech()
    speechEvent.Set_Reward_Parameter(0, speechId)
    Story_Event(StoryUtil.GenericSpeechNotificationName)
end

function MissionUtil.PlayCinematicSpeech(textId, var, color, teletype, speechId, movie_name, faction)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    if faction ~= nil then
        if Find_Player("local") ~= Find_Player(faction) then
            return
        end
    end

    local cinematicSpeechEvent = plot.Get_Event(StoryUtil.CinematicSpeechEventName)

    if not cinematicSpeechEvent then
        return
    end

    local colorString = ""
    if color then
        colorString = color.r .. " " .. color.g .. " " .. color.b
    end

    if not var then
        var = ""
    end

    local use_teletype = 1
    if teletype == false then
        use_teletype = 0
    end

    if speechId == nil then
        speechId = ""
    end

    if movie_name == nil then
        movie_name = ""
    end
    
    cinematicSpeechEvent.Set_Reward_Parameter(0, textId)
    cinematicSpeechEvent.Set_Reward_Parameter(1, -1)
    cinematicSpeechEvent.Set_Reward_Parameter(2, var)
    cinematicSpeechEvent.Set_Reward_Parameter(3, "")
    cinematicSpeechEvent.Set_Reward_Parameter(4, use_teletype)
    cinematicSpeechEvent.Set_Reward_Parameter(5, colorString)
    cinematicSpeechEvent.Set_Reward_Parameter(7, speechId)
    cinematicSpeechEvent.Set_Reward_Parameter(8, movie_name)
    cinematicSpeechEvent.Set_Reward_Parameter(9, 1)

    local cinematicSpeechRemoveEvent = plot.Get_Event("Template_Cinematic_Speech_Remove_Text")
    cinematicSpeechRemoveEvent.Set_Event_Parameter(0, speechId)
    cinematicSpeechRemoveEvent.Set_Reward_Parameter(0, textId)

    Story_Event(StoryUtil.CinematicSpeechNotificationName)
end

function MissionUtil.MissionTextSpeech(missionId, speechIndex, time, movie_name, color)
	if speechIndex < 10 then
		StoryUtil.Multimedia("TEXT_MISSION_"..missionId.."_SPEECH_0"..speechIndex.."", time, nil, movie_name, 0, nil, color)
	else
		StoryUtil.Multimedia("TEXT_MISSION_"..missionId.."_SPEECH_"..speechIndex.."", time, nil, movie_name, 0, nil, color)
	end
end

function MissionUtil.PlayCinematicMovieCrawl(movie_name, musicID)
	Fade_Screen_In(1)
	Weather_Audio_Pause(true)
	BlockOnCommand(Play_Bink_Movie("A_Long_Time_Ago_Campaign_Intro"))
	Play_Music(musicID)
	BlockOnCommand(Play_Bink_Movie(movie_name))
	Weather_Audio_Pause(false)
end

function MissionUtil.PlayGenericMovie(movie_name)
	Cancel_Fast_Forward()
	Stop_All_Music()
	BlockOnCommand(Play_Bink_Movie(movie_name))
	Resume_Mode_Based_Music()
end

function MissionUtil.PlayGenericMusic(musicID)
	Stop_All_Music()
	Play_Music(musicID)
end

function MissionUtil.PositionCamera(planet)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local positionCameraEvent = plot.Get_Event(StoryUtil.PositionCameraEventName)

    if not positionCameraEvent then
        return
    end

    positionCameraEvent.Set_Reward_Parameter(0, planet)
    Story_Event(StoryUtil.PositionCameraNotificationName)
end

function MissionUtil.ToggleAbility(player,unit_name,ability_name,state)
    local player_name = string.upper(player.Get_Faction_Name())
    local plot = Get_Story_Plot("Conquests\\SpaceTactical\\SpaceAbilityToggle_" .. player_name .. ".XML")

    if not plot then
        return
    end

    local tag = "NEW_ABILITY_"
    if state == false then
        tag = "REMOVE_ABILITY_"
    end
    tag = tag .. player_name

    local event = plot.Get_Event(tag)
    if not event then
        return
    end

    event.Set_Reward_Parameter(0, unit_name)
    event.Set_Reward_Parameter(1, ability_name)
    Story_Event(tag)
end

function MissionUtil.Find_Attacking_Player()
    local attacking_player = nil
	local attacker_marker = Find_First_Object("Attacker Entry Position")

	if not TestValid(attacker_marker) then
		attacker_marker = Find_Player("Hostile")
		return attacker_marker
	end

	local attacking_player = attacker_marker.Get_Owner()
	if TestValid(attacking_player) then
		return attacking_player
	else
		return nil
	end
end

function MissionUtil.Find_Defending_Player()
    local defending_player = nil
	local defender_marker = Find_First_Object("Defending Forces Position")

	if not TestValid(defender_marker) then
		defending_player = Find_Player("Hostile")
		return defending_player
	end

	local defending_player = defender_marker.Get_Owner()
	if TestValid(defending_player) then
		return defending_player
	else
		return nil
	end
end

function MissionUtil.PopulateAllMarkersWithHint(unit_type, player, hint, amount, allow_AI)
	if amount == nil then
		local amount = 1
	end

	allow_AI_usage = true
	if not allow_AI then
		allow_AI_usage = false
	end

	local marker_with_hint_list = Find_All_Objects_With_Hint(hint)
	for i,marker_with_hint in pairs(marker_with_hint_list) do
		MissionUtil.SpawnListSpawner(unit_type, marker_with_hint, player, 1, allow_AI_usage)
	end
end

function MissionUtil.SpawnUnitGround(unit, spawn_position, player)
    local player_name = player

	local unit_to_spawn = Find_Object_Type(unit)
	local unit_to_spawn_list = Spawn_Unit(unit_to_spawn, spawn_position, player_name)
	local player_unit_to_spawn = unit_to_spawn_list[1]
	player_unit_to_spawn.Teleport_And_Face(spawn_position)

	if TestValid(player_unit_to_spawn) then
		return player_unit_to_spawn
	else
		return nil
	end
end

function MissionUtil.SpawnUnitSpace(unit, spawn_position, player, hyperspace_duration)
    local player_name = player

	local unit_to_spawn = Find_Object_Type(unit)
	local player_unit_to_spawn = Spawn_Unit(unit_to_spawn, spawn_position, player_name)
	local player_unit_to_spawn = Find_Nearest(spawn_position, player_name, true)
	player_unit_to_spawn.Teleport_And_Face(spawn_position)

	if hyperspace_duration ~= nil then
		player_unit_to_spawn.Cinematic_Hyperspace_In(hyperspace_duration)
	end

	if TestValid(player_unit_to_spawn) then
		return player_unit_to_spawn
	else
		return nil
	end
end

function MissionUtil.SpawnListSpawner(unit_type, position, player, amount, allow_AI)
    local player_name = player

	allow_AI_usage = true
	if not allow_AI then
		allow_AI_usage = false
	end

	if amount == nil then
		local amount = 1
	end

	for i=1,amount do
		SpawnList({unit_type}, position, player_name, allow_AI_usage, true)
	end
end

function MissionUtil.AddToReinforcementPool(unit_type, player, amount)
    local player_name = player

	if amount == nil then
		local amount = 1
	end

	for i=1,amount do
		Reinforce_Unit(Find_Object_Type(unit_type), false, player_name)
	end
end

function MissionUtil.PlayAnimation(unit_type, animation, loop, anim_index)
	if anim_index == nil then
		local anim_index = 0
	end
	if loop == nil then
		local loop = false
	end
	if TestValid(unit_type) then
		unit_type.Play_Animation(animation, loop, anim_index)
	else
		return
	end
end

function MissionUtil.CreateCinematicLander(lander_type, position, player, idle_time, persist, current_phase, angle)
    local player_name = player

	local stay_around = 1
    if persist == false then
        stay_around = 0
    end

	local phase_mode = 1
	if current_phase == "LANDING" then
        phase_mode = 1
    elseif current_phase == "LOADING" then
        phase_mode = 2
    elseif current_phase == "LEAVING" then
        phase_mode = 3
    end

	local unit_to_land = Create_Cinematic_Transport(lander_type, player_name.Get_ID(), position, angle, phase_mode, 0, idle_time, stay_around)
	-- Create_Cinematic_Transport(object_type_name, player_id, transport_pos, zangle, phase_mode, anim_delta, idle_time, persist,hint)  
	-- phase_mode: TRANSPORT_PHASE_LANDING = 1, TRANSPORT_PHASE_UNLOADING = 2, TRANSPORT_PHASE_LEAVING = 3

	if TestValid(unit_to_land) then
		return unit_to_land
	else
		return nil
	end
end


function MissionUtil.CinematicEnvironmentOn()
	Allow_Localized_SFX(false)
	SFXManager.Allow_HUD_VO(false)
	SFXManager.Allow_Ambient_VO(false)
	SFXManager.Allow_Unit_Reponse_VO(false)
	SFXManager.Allow_Enemy_Sighted_VO(false)
	SFXManager.Allow_Localized_SFXEvents(false)
	Set_Cinematic_Environment(true)
end

function MissionUtil.CinematicEnvironmentOff()
	Allow_Localized_SFX(true)
	SFXManager.Allow_HUD_VO(true)
	SFXManager.Allow_Ambient_VO(true)
	SFXManager.Allow_Unit_Reponse_VO(true)
	SFXManager.Allow_Enemy_Sighted_VO(true)
	SFXManager.Allow_Localized_SFXEvents(true)
	Set_Cinematic_Environment(false)
	Master_Volume_Restore()
	Resume_Mode_Based_Music()
	Enable_Fog(true)
end

function MissionUtil.StartCinematicCamera()
	Start_Cinematic_Camera()
	Stop_All_Music()
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Letter_Box_In(0)
	Remove_All_Text()
	Suspend_AI(1)
	Fade_On()
end

function MissionUtil.EndCinematicCamera(camera_target, duration)
	Point_Camera_At(camera_target)
	Transition_To_Tactical_Camera(duration)
	Letter_Box_Out(duration)
	Suspend_AI(0)
	Lock_Controls(0)
	End_Cinematic_Camera()
end

function MissionUtil.SetCinematicCamera(camera_position, camera_target, follow_target, camera_coordinates, target_coordinates)
    if camera_target == nil then
        camera_target = 0
    end

    local should_follow = 1
    if follow_target == false then
        should_follow = 0
    end

	if camera_coordinates == nil or not camera_coordinates then
		Set_Cinematic_Camera_Key(camera_position, 0, 0, 0, 1, 0, 0, 0)
	else
		local camera_position_x = camera_coordinates.x
		local camera_position_y = camera_coordinates.y
		local camera_position_z = camera_coordinates.z
		Set_Cinematic_Camera_Key(camera_position, camera_position_x, camera_position_y, camera_position_z, 1, 0, 0, 0)
	end

	if target_coordinates == nil or not target_coordinates then
		Set_Cinematic_Target_Key(camera_position, 0, 0, 0, 0, camera_target, should_follow, 0)
	else
		local camera_position_x = target_coordinates.x
		local camera_position_y = target_coordinates.y
		local camera_position_z = target_coordinates.z
		Set_Cinematic_Target_Key(camera_position, camera_position_x, camera_position_y, camera_position_z, 0, camera_target, should_follow, 0)
	end
end

function MissionUtil.TransitionCinematicCamera(new_camera_position, camera_target, follow_target, duration, camera_coordinates, target_coordinates)
    if camera_target == nil then
        camera_target = 0
    end

    local should_follow = 1
    if follow_target == false then
        should_follow = 0
    end

	if camera_coordinates == nil or not camera_coordinates then
		Transition_Cinematic_Camera_Key(new_camera_position, duration, 0, 0, 0, 1, 0, 0, 0)
	else
		local camera_position_x = camera_coordinates.x
		local camera_position_y = camera_coordinates.y
		local camera_position_z = camera_coordinates.z
		Transition_Cinematic_Camera_Key(new_camera_position, duration, camera_position_x, camera_position_y, camera_position_z, 1, 0, 0, 0)
	end

	if target_coordinates == nil or not target_coordinates then
		Transition_Cinematic_Target_Key(new_camera_position, duration, 0, 0, 0, 0, camera_target, should_follow, 0)
	else
		local camera_position_x = target_coordinates.x
		local camera_position_y = target_coordinates.y
		local camera_position_z = target_coordinates.z
		Transition_Cinematic_Target_Key(new_camera_position, duration, camera_position_x, camera_position_y, camera_position_z, 0, camera_target, should_follow, 0)
	end
end

function MissionUtil.CinematicSkippingCleanUp(camera_position)
	Fade_Screen_Out(0)
	Stop_All_Music()
	Stop_All_Speech()
	Remove_All_Text()
	Stop_Bink_Movie()

	MissionUtil.CinematicEnvironmentOff()
	Resume_Mode_Based_Music()

	if camera_position ~= nil then
		Point_Camera_At(camera_position)
	end
	Transition_To_Tactical_Camera(1)
	Letter_Box_Out(1)
	Suspend_AI(0)
	Lock_Controls(0)
	End_Cinematic_Camera()
	MissionUtil.AIActivation()
end

function MissionUtil.AIActivation()
	local player_object = Find_Player("local")
	local player_name = player_object.Get_Faction_Name()
	for _, faction in pairs(CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL) do
		local faction_object = Find_Player(faction)
		if faction_object ~= player_object then
			local faction_name = faction_object.Get_Faction_Name()
			if Find_Object_Type("fotr") then
				if player_name == "REBEL" then
					if (GlobalValue.Get("CRUEL_ON") == 1) then
						local ai_type = CONSTANTS.ALL_FACTIONS_CRUEL_AI_CIS[string.upper(faction)]
						StoryUtil.ChangeAIPlayer(faction_name, ai_type)
					else
						local ai_type = CONSTANTS.ALL_FACTIONS_AI_CIS[string.upper(faction)]
						StoryUtil.ChangeAIPlayer(faction_name, ai_type)
					end
				else
					if (GlobalValue.Get("CRUEL_ON") == 1) then
						local ai_type = CONSTANTS.ALL_FACTIONS_CRUEL_AI[string.upper(faction)]
						StoryUtil.ChangeAIPlayer(faction_name, ai_type)
					else
						local ai_type = CONSTANTS.ALL_FACTIONS_AI[string.upper(faction)]
						StoryUtil.ChangeAIPlayer(faction_name, ai_type)
					end

				end
			else
				if (GlobalValue.Get("CRUEL_ON") == 1) then
					local ai_type = CONSTANTS.ALL_FACTIONS_CRUEL_AI[string.upper(faction)]
				else
					local ai_type = CONSTANTS.ALL_FACTIONS_AI[string.upper(faction)]
				end
			end
		end
	end
    Story_Event(StoryUtil.AIActivationNotificationName)
end

function MissionUtil.CinematicIntroHeader(textId)
	Remove_All_Text()
	StoryUtil.ShowScreenText("TEXT_MISSION_"..textId.."_INTRO_01", 8.0, nil, nil, true)
	StoryUtil.ShowScreenText("TEXT_MISSION_"..textId.."_INTRO_02", 8.0, nil, nil, true)
end

function MissionUtil.CinematicMidtroHeader(textId)
	Remove_All_Text()
	StoryUtil.ShowScreenText("TEXT_MISSION_"..textId.."_MIDTRO_01", 8.0, nil, nil, true)
	StoryUtil.ShowScreenText("TEXT_MISSION_"..textId.."_MIDTRO_02", 8.0, nil, nil, true)
end

function MissionUtil.CinematicOutroHeader(textId)
	Remove_All_Text()
	StoryUtil.ShowScreenText("TEXT_MISSION_"..textId.."_OUTRO_01", 8.0, nil, nil, true)
	StoryUtil.ShowScreenText("TEXT_MISSION_"..textId.."_OUTRO_02", 8.0, nil, nil, true)
end


function MissionUtil.DisableRetreat(player, status)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local player_name = player

    local disableRetreatEvent = plot.Get_Event(StoryUtil.DisableRetreatEventName)

    if not disableRetreatEvent then
        return
    end

    local is_disable = 1
    if status == false then
        is_disable = 0
    end

    disableRetreatEvent.Set_Reward_Parameter(0, player_name)
    disableRetreatEvent.Set_Reward_Parameter(1, is_disable)
    Story_Event(StoryUtil.DisableRetreatNotificationName)
end

function MissionUtil.VictoryAllowance(status)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local victoryAllowanceEvent = plot.Get_Event(StoryUtil.VictoryAllowanceEventName)

    if not victoryAllowanceEvent then
        return
    end

    local is_allowed = 1
    if status == false then
        is_allowed = 0
    end

    victoryAllowanceEvent.Set_Reward_Parameter(0, is_allowed)
    Story_Event(StoryUtil.VictoryAllowanceNotificationName)
end

function MissionUtil.ReinforcementAllowance(player, allow)
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    local player_name = player

    if not player then
        player_name = ""
    end

    local reinforcementHandlerEvent = plot.Get_Event(StoryUtil.ReinforcementHandlerEventName)

    if not reinforcementHandlerEvent then
        return
    end

    local disabled = 0
    if allow == false then
        disabled = 1
    end

    reinforcementHandlerEvent.Set_Reward_Parameter(0, disabled)
    reinforcementHandlerEvent.Set_Reward_Parameter(1, player_name)
    Story_Event(StoryUtil.ReinforcementHandlerNotificationName)
end

function MissionUtil.HideAutoresolve()
    local plot = StoryUtil.GetPlayerAgnosticPlot()

    if not plot then
        return
    end

    Story_Event(StoryUtil.HideAutoresolveNotificationName)
end

function MissionUtil.AllowOrbitalSupport(player, status)
    local player_name = player
	if status == true then
		player.Disable_Bombing_Run(true)
		player.Disable_Orbital_Bombardment(false)
	end
	if status == false then
		player.Disable_Bombing_Run(false)
		player.Disable_Orbital_Bombardment(true)
	end
end

function MissionUtil.Set_To_Allies(faction_1, faction_2)
	faction_1.Make_Ally(faction_2)
	faction_2.Make_Ally(faction_1)
end

function MissionUtil.Set_To_Enemies(faction_1, faction_2)
	faction_1.Make_Enemy(faction_2)
	faction_2.Make_Enemy(faction_1)
end
