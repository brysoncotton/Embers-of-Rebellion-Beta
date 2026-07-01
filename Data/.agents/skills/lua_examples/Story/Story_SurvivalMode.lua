
require("PGBase")
require("PGStoryMode")
require("deepcore/crossplot/crossplot")
require("PGDebug")
require("PGSpawnUnits")
require("eawx-util/MissionUtil")

------------------------------------------------------------------------------------------------
-- SURVIVAL MODE RULES
-- General Rules:
	--Boss fight every 5 waves
-- Ship Number Calculation and ship type leves:
	-- Waves 1 - 4:
		-- ship_number = wave + 4
		-- Level 1 units only
	-- Waves 5 - 8:
		-- ship_number = wave * 2
		-- Level 1 and 2 units
		-- level 2 ships = ((wave-1)/8) * ship_number
	-- Waves 9 - 12:
		-- ship_number = wave * 2
		-- Level 2 and 3 units
		-- level 3 ships = ((wave-2)/12) * ship_number
	-- Waves 13 - 16:
		-- ship_number = wave * 2
		-- Level 3 and 4 units
		-- level 4 ships = ((wave-3)/16) * ship_number
	-- Waves > 16:
		-- ship_number = 32
		-- Level 4 and 5 units
		-- level 5 ships = ((wave-4)/32) * ship_number
	-- Waves > 20
		-- ship_number = 32
		-- every wave is a boss battle
		-- level 5 ships = 32
------------------------------------------------------------------------------------------------

function Definitions()
	ServiceRate = 0.1
	StoryModeEvents = { 
						Universal_Story_Start = State_Initialize,
						Battle_Start = Handler 
					  }
    GlobalValue.Set("CURRENT_ERA", 4)
	GlobalValue.Set("REGIME_INDEX", 4)
end

function State_Initialize(message)
	if message == OnEnter then
		--get players
		rebel_player = Find_Player("Rebel")
		empire_player = Find_Player("Empire")
		underworld_player = Find_Player("Underworld")
		hutts_player = Find_Player("Hutt_Cartels")
		penastar_player = Find_Player("Pentastar")
		eriadu_player = Find_Player("Eriadu_Authority")
		zsinj_player = Find_Player("Zsinj_Empire")
		maldrood_player = Find_Player("Greater_Maldrood")
		corporate_sector_player = Find_Player("Corporate_Sector")
		hapes_player = Find_Player("Hapes_Consortium")
		empireofthehand_player = Find_Player("EmpireoftheHand")
		
		plot = Get_Story_Plot("Story_Sandbox_Survival.xml")
		Survival_Lore_Popup = plot.Get_Event("Survival_Popup")
		Survival_Lore_Popup.Set_Dialog("Dialog_Survival_Lore")
	end
end

function Handler(message)
	if message == OnEnter then
		crossplot:tactical()
		GlobalValue.Set("IS_SURVIVAL", true)

		active_text_string = ""
		humanPlayer = Find_Player("local")
		FogOfWar.Reveal_All(humanPlayer)

		GlobalValue.Set("CURRENT_ERA",4)
		base_pos = Find_First_Object("Survival_Base_Position")
		alternate_research_pos = Find_First_Object("Survival_Alternate_Research_Position")
		survivallibrary = require("SurvivalLibrary")

		Create_Generic_Object(survivallibrary["STARBASE_TYPES"][Find_Player("local").Get_Faction_Name()], base_pos, humanPlayer)
		Create_Generic_Object(survivallibrary["ALTERNATE_RESEARCH_TYPES"][Find_Player("local").Get_Faction_Name()], alternate_research_pos, humanPlayer)

		Find_Player("local").Give_Money(3000)
		hostile = Find_Player("Hostile")

		crossplot:subscribe("TACTICAL_PRODUCTION_FINISHED", SpawnAlliedUnit)

		current_wave = {}

		spawnMarkers = {
            Find_First_Object("Survival_Defender_Position_00"),
            Find_First_Object("Survival_Defender_Position_01"),
            Find_First_Object("Survival_Defender_Position_02")
        }

		enemySpawnMarkers = {
			Find_First_Object("Survival_Entry_Position_00"),
			Find_First_Object("Survival_Entry_Position_01"),
			Find_First_Object("Survival_Entry_Position_02"),
			Find_First_Object("Survival_Entry_Position_03")
		}
		DebugMessage("Current Era %s", tostring(GlobalValue.Get("CURRENT_ERA")))

		spawnUnits = survivallibrary["UNIT_OPTIONS"]
		boss_types = survivallibrary["BOSS_UNITS"]
		wave=0
		current_wave_alive = false
		GlobalValue.Set("WaveCount", wave)

		for j, list in pairs(boss_types) do
			for i, unit in pairs(list) do
				if unit.Is_Affiliated_With(humanPlayer) then
					table.remove(boss_types[j],i)
				end
			end
		end
		Story_Event("30WARNING")
		Register_Timer(Create_Wave, 30)
		Register_Timer(Story_Event, 10, "20WARNING")
		Register_Timer(Story_Event, 20, "10WARNING")

	elseif message == OnUpdate then
		crossplot:update()
		local player_defeated = EvaluatePerception("Survival_Defeat", humanPlayer)
		
		if player_defeated > 0 then
			Story_Event("PLAYER_DEFEATED")
		end
		
		if current_wave_alive then
			if table.getn(current_wave) > 0 then
				for j,unit in current_wave do
					DebugMessage("%s unit in %s updating",tostring(unit), tostring(Script))
				end
				units_alive= 0
				for i, unit in pairs(current_wave) do
					DebugMessage("%s unit in %s updating",tostring(unit), tostring(Script))
					if TestValid(unit) then
						units_alive = units_alive + 1
					end
				end
				DebugMessage("in %s updating", tostring(Script))

				RemoveWave()
				ShowWave(wave,false)

				RemoveScreenText(active_text_string)
				active_text_string="Remaining Enemy Units: " .. units_alive
				ShowScreenText("Remaining Enemy Units: " .. units_alive, -1, nil, nil, false)

				if units_alive == 0 then
					current_wave_alive = false

					new_money = 1200+(wave*1000)
					Find_Player("local").Give_Money(new_money)
					--May remove later, extra cash bonus for beating boss wave
					if Simple_Mod(wave,5) then
						Find_Player("local").Give_Money(500*wave)
					end


					GlobalValue.Set("WaveCount", wave)
					DebugMessage("in %s updating", tostring(Script))
					remaining_units = Find_All_Objects_Of_Type(hostile)
					if table.getn(remaining_units) > 0 then
						for i, unit in pairs(remaining_units) do
							if TestValid(unit) and (unit.Is_Category("Fighter") or unit.Is_Category("Bomber")) then
								unit.Take_Damage(9999999)
							end
						end
					end

					Story_Event("30WARNING")

					RemoveScreenText(active_text_string)
					Register_Timer(Create_Wave, 30)
					Register_Timer(Story_Event, 10, "20WARNING")
					Register_Timer(Story_Event, 20, "10WARNING")
				end
			end
		end
	end
end

function SpawnAlliedUnit(unit_name)
	for built, upgrade in pairs(survivallibrary["UPGRADE_TYPES"]) do
		if unit_name == built then 
			Create_Generic_Object(upgrade, base_pos, humanPlayer)
			return
		end
	end
	--For some reason putting the spawn markers as location here is less crash prone, while still adding unit to reinforcement pool as opposed to nil
	Reinforce_Unit(Find_Object_Type(unit_name),spawnMarkers[GameRandom.Free_Random(1, table.getn(spawnMarkers))],Find_Player("local"),true,false)
end

--Enemy Wave Creation

function Create_Wave()
	RemoveWave()
	wave = wave + 1
	ShowWave(wave)
	GlobalValue.Set("WaveCount", wave)
	boss_fight = false
	ship_number = wave * 2
	spawn = nil
	if wave <= 4 then
		--Level 1 units only!
		pos_count = 2
		ship_number = wave + 4
		max_level = 1
		high_ship_number = ship_number
		mid_ship_number = 0
		lower_ship_number = 0

	elseif wave <= 8 then
		--Level 1,2
		pos_count = 3
		upper_limit = 8
		percent_higher_level = (wave-1)/upper_limit
		high_ship_number = tonumber(Dirty_Floor(ship_number*percent_higher_level))
		mid_ship_number = 0
		lower_ship_number = ship_number - high_ship_number
		max_level = 2

	elseif wave <= 12 then
		--Level 2,3
		pos_count = 3
		upper_limit = 12
		ship_number = wave * 3
		percent_higher_level = (wave*0.3)/upper_limit
		high_ship_number = tonumber(Dirty_Floor(ship_number*percent_higher_level))
		mid_ship_number = tonumber(Dirty_Floor(ship_number*0.4))
		lower_ship_number = ship_number - high_ship_number - mid_ship_number
		max_level = 3
		

	elseif wave <= 16 then
		--Level 3,4
		pos_count = 4
		upper_limit = 16
		ship_number = wave * 3
		percent_higher_level = (wave*0.3)/upper_limit
		high_ship_number = tonumber(Dirty_Floor(ship_number*percent_higher_level))
		mid_ship_number = tonumber(Dirty_Floor(ship_number*0.5))
		lower_ship_number = ship_number - high_ship_number - mid_ship_number
		max_level = 4

	elseif wave > 16 then
		--Level 4,5
		pos_count = 4
		upper_limit = 20
		max_level = 5
		ship_number = wave * 2
		if wave <= 20 then
			if (wave-4) < upper_limit then
				percent_higher_level = (wave*0.2)/upper_limit
				high_ship_number = tonumber(Dirty_Floor(ship_number*percent_higher_level))
				mid_ship_number = tonumber(Dirty_Floor(ship_number*0.5))
				lower_ship_number = ship_number - high_ship_number - mid_ship_number
			else
				high_ship_number = tonumber(Dirty_Floor(ship_number*0.2))
				mid_ship_number = tonumber(Dirty_Floor(ship_number*0.6))
				lower_ship_number = ship_number - high_ship_number - mid_ship_number

			end

		else
			high_ship_number = tonumber(Dirty_Floor(ship_number*0.2))
			mid_ship_number = tonumber(Dirty_Floor(ship_number*0.6))
			lower_ship_number = ship_number - high_ship_number - mid_ship_number
	        boss_fight = true --every wave is a boss fight now! HARDCORE MODE

		end


	end

	if Simple_Mod(wave, 5) == 0 then
		boss_fight = true
	end

	Spawn_Wave(lower_ship_number, mid_ship_number, high_ship_number, max_level, pos_count, boss_fight)

end

function Spawn_Wave(low_ships, mid_ships, high_ships, level, position, boss)
	spawn_table = {}
	my_type = 0
	tier = 0

	max_level_low = level
	max_level_high = level
	mid_level_low = 1
	mid_level_high = 1
	low_level_low = 1
	low_level_high = 1
	if level == 3 then
		mid_level_low = 2
		mid_level_high = 2
		low_level_low = 1
		low_level_high = 1
	end
	if level == 4 then
		mid_level_low = 3
		mid_level_high = 3
		low_level_low = 1
		low_level_high = 2
	end
	if level == 5 then
		max_level_low = 4
		mid_level_low = 3
		mid_level_high = 4
		low_level_low = 1
		low_level_high = 2
	end


	for j = 1,high_ships,1 do
		tier = GameRandom.Free_Random(max_level_low,max_level_high)
		my_type = GameRandom.Free_Random(1,table.getn(spawnUnits[tier]))
		table.insert(spawn_table, spawnUnits[tier][my_type])
	end

	if mid_ships > 0 then
		for j = 1,mid_ships,1 do
			tier = GameRandom.Free_Random(mid_level_low,mid_level_high)
			my_type = GameRandom.Free_Random(1,table.getn(spawnUnits[tier]))
			table.insert(spawn_table, spawnUnits[tier][my_type])
		end
	end

	if low_ships > 0 then
		for j = 1, low_ships,1 do
			tier = GameRandom.Free_Random(low_level_low,low_level_high)
			my_type = GameRandom.Free_Random(1,table.getn(spawnUnits[tier]))
			table.insert(spawn_table, spawnUnits[tier][my_type])
		end
	end
	if boss then
        my_type = GameRandom.Free_Random(1,table.getn(boss_types[level]))
		table.insert(spawn_table, boss_types[level][my_type])
	end
	current_wave = MultiPosSpawnList(spawn_table, enemySpawnMarkers, position, hostile, true, true)

	current_wave_alive = true
	if active_text_string ~= "" then
		RemoveScreenText(active_text_string)
	end
	active_text_string = "Remaining Enemy Units: " .. table.getn(current_wave)

	ShowScreenText("Remaining Enemy Units: " .. table.getn(current_wave), -1)

end

--UTILITIES

function MultiPosSpawnList(unit_list, pos_list, pos_number, faction, allow_ai_usage, remove_after_battle)
	complete_list = {}
	if pos_number > 1 then
		want_to_split = GameRandom.Free_Random(0,100)
	else
		want_to_split = 0
	end
	temp_pos_list = pos_list

	if want_to_split > 40 then
		ships_per_spawnpoint = Dirty_Floor(table.getn(unit_list)/pos_number)

		while table.getn(temp_pos_list) > pos_number do

			table.remove(temp_pos_list, GameRandom.Free_Random(1, table.getn(temp_pos_list)))
		end



		for i, pos in pairs(temp_pos_list) do
			ships_on_spawnpoint = 0
			temp_list = {}


			for k = 1, ships_per_spawnpoint do
					index = GameRandom.Free_Random(1,table.getn(unit_list))
					table.insert(temp_list, unit_list[index])
					table.remove(unit_list, index)

			end


			spawn_unit_list = Spawn_List(temp_list, pos, faction, allow_ai_usage, remove_after_battle)
			for j, unit in pairs(spawn_unit_list) do
				table.insert(complete_list, unit)

			end

		end

		if table.getn(unit_list) > 0 then
			for i, unit in pairs(unit_list) do
				new_unit = Create_Generic_Object(unit, temp_pos_list[GameRandom.Free_Random(1, table.getn(temp_pos_list))], faction)
	
				new_unit.Prevent_AI_Usage(false)
				table.insert(complete_list, new_unit)
			end

		end

	else
		complete_list = Spawn_List(unit_list, pos_list[GameRandom.Free_Random(1, table.getn(pos_list))], faction, true, true)

	end


	return complete_list
end

function ShowScreenText(textId, time, var, color, teletype)
    local plot = Get_Story_Plot("Conquests\\Survival\\Tactical_SurvivalMode.xml")

    if not plot then
        return
    end

    local screenTextEvent = plot.Get_Event("Show_Screen_Text")

    if not screenTextEvent then
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

    screenTextEvent.Set_Reward_Parameter(0, textId)
    screenTextEvent.Set_Reward_Parameter(1, tostring(time))
    screenTextEvent.Set_Reward_Parameter(2, var)
    screenTextEvent.Set_Reward_Parameter(3, "")
    screenTextEvent.Set_Reward_Parameter(4, use_teletype)
    screenTextEvent.Set_Reward_Parameter(5, colorString)
    Story_Event("SHOW_SCREEN_TEXT")
end

function RemoveScreenText(textId)
    local plot = Get_Story_Plot("Conquests\\Survival\\Tactical_SurvivalMode.xml")

    if not plot then
        return
    end

    local screenTextEvent = plot.Get_Event("Show_Screen_Text")

    if not screenTextEvent then
        return
    end

    screenTextEvent.Set_Reward_Parameter(0, textId)
    screenTextEvent.Set_Reward_Parameter(3, "remove")
    Story_Event("SHOW_SCREEN_TEXT")
end

-- Nasty hack of a floor function to be replaced if a math library floor funciton is exposed
function Dirty_Floor(val)
	return string.format("%d", val) -- works on implicit string to int conversion
end

-- Machine independent modulus function
function Simple_Mod(a,b)
	--return a-b*math.floor(a/b)
	return a-b*Dirty_Floor(a/b)
end

function contains(list, element)
	for _, value in pairs(list) do
	  if value == element then
		return true
	  end
	end
	return false
end
  
function Spawn_List(type_list, entry_marker, player, allow_ai_usage, delete_after_scenario)
	unit_list = {}
	
	for k, unit_type in pairs(type_list) do
		if type(unit_type) == "string" then
			ref_type = Find_Object_Type(unit_type)
		else
			ref_type = unit_type
		end
		DebugMessage("testing ref type: %s", tostring(ref_type.Get_Name()))
		if TestValid(ref_type) then
			unit = Create_Generic_Object(ref_type, entry_marker, player)

				table.insert(unit_list, unit)
				if allow_ai_usage then
					DebugMessage("allow_ai_usage: %s", tostring(unit))
					unit.Prevent_AI_Usage(false)
				else
					unit.Prevent_AI_Usage(true) -- This doesn't happen automatically, unlike for Reinforce_Unit
				end
				if delete_after_scenario then
					DebugMessage("deleting after scenario: %s", tostring(unit))
					unit.Mark_Parent_Mode_Object_For_Death()

			end
		else
			DebugMessage("%s -- ERROR! Unit %s not found in XML!", tostring(Script), tostring(unit_type))
		end
	end
	
	unit = nil
	
	return unit_list
end

function ShowWave(wave, teletype)
    local plot = Get_Story_Plot("Conquests\\Survival\\Tactical_SurvivalMode.xml")

    if not plot then
        return
    end

    local screenTextEvent = plot.Get_Event("WaveMessage")

    if not screenTextEvent then
        return
    end

    local use_teletype = 1
    if teletype == false then
        use_teletype = 0
    end
	screenTextEvent.Set_Reward_Parameter(0, "Current Wave: " .. wave)
    -- screenTextEvent.Set_Reward_Parameter(2, wave)
    screenTextEvent.Set_Reward_Parameter(4, use_teletype)
    Story_Event("SHOW_WAVES")
end

function RemoveWave()
    local plot = Get_Story_Plot("Conquests\\Survival\\Tactical_SurvivalMode.xml")

    if not plot then
        return
    end

    local screenTextEvent = plot.Get_Event("RemoveWaveMessage")

    if not screenTextEvent then
        return
    end

    screenTextEvent.Set_Reward_Parameter(0, "Current Wave: " .. wave)
    screenTextEvent.Set_Reward_Parameter(3, "remove")
    Story_Event("REMOVE_WAVES")
end