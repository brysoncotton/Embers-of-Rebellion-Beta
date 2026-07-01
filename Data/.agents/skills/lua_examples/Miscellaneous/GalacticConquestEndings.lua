require("EndScreenMessages")

function Get_Econ_And_Kill_Efficiency(player, kill_stats, build_stats)
    pid = player.Get_ID()

    econ_eff = 1
    kill_eff = 0
    
    -- frag stats
    kill_table = kill_stats[frag_index][pid]

    total_fragged_power = 0

    if kill_table then
        for kk, vv in pairs(kill_table) do
            total_fragged_power = total_fragged_power + vv.combat_power
        end
    end

    -- loss stats
    death_table = kill_stats[death_index][pid]

    total_lost_power = 0
    total_lost_cost = 0

    if death_table then
        for kk, vv in pairs(death_table) do
            total_lost_power = total_lost_power + vv.combat_power
            total_lost_cost = total_lost_cost + vv.build_cost
        end
    end

    -- build stats
    total_built_cost = 0

    if build_stats[pid] then
        for planet_type, planet_entry in pairs(build_stats[pid]) do
            for object_type, type_entry in pairs(planet_entry) do
                total_built_cost = total_built_cost + type_entry.build_cost
            end
        end
    end

    if total_lost_cost > 0 then
        econ_eff = 1 - total_lost_cost / (total_built_cost + total_lost_cost)
    end

    if total_fragged_power > 0 then
        kill_eff = total_fragged_power / (total_fragged_power + total_lost_power)
    end

    return econ_eff, kill_eff
end

function Get_Conquest_Efficiency(player)
    pid = player.Get_ID()

    conq_eff = 0

    -- [playerid][planet_type][sacked_count, lost_count]
    entry = GalacticConquestTable[pid]

    if entry == nil then
        return 0
    end

    total_sacked_planets = 0
    total_lost_planets = 0
    for planet_type, pe in pairs(entry) do
        total_sacked_planets = total_sacked_planets + pe.sacked_count
        total_lost_planets = total_lost_planets + pe.lost_count
    end

    if total_sacked_planets > 0 then
        conq_eff = total_sacked_planets / (total_sacked_planets + total_lost_planets)
    end

    return conq_eff
end

function Calc_Score_For_Efficiency(econ_eff,kill_eff,conq_eff)
    econ_score = 0
    kill_score = 0
    conq_score = 0

-- efficiency, score

-- econ: build:lost cost
    Econ_Score_Table = {
        {1.00,100},
        {0.80, 95}, -- 4:1
        {0.78, 89},
        {0.76, 83},
        {0.74, 78},
        {0.72, 73},
        {0.70, 68}, -- 7:3
        {0.68, 64},
        {0.66, 60}, -- ~2:1
        {0.64, 56},
        {0.62, 52},
        {0.60, 48}, -- 3:2
        {0.55, 40},
        {0.50, 33}, -- 1:1
        {0.45, 28},
        {0.40, 23}, -- 2:3
        {0.35, 19},
        {0.30, 15}, -- 3:7
        {0.20,  9}, -- 1:4
        {0.10,  4}, -- 1:9
        {0.00,  0}
    }

-- kill: killed:lost power
-- conq: sacked:lost planets
    Kill_And_Conq_Score_Table = {
        {1.00,100},
        {0.97, 95}, -- ~33:1
        {0.96, 91}, -- 24:1
        {0.95, 87}, -- 19:1
        {0.94, 83},
        {0.93, 79},
        {0.92, 75},
        {0.90, 69}, -- 9:1
        {0.85, 54},
        {0.80, 43},
        {0.75, 34}, -- 3:1
        {0.70, 27},
        {0.65, 21},
        {0.60, 17},
        {0.55, 13},
        {0.50, 10}, -- 1:1
        {0.40,  7},
        {0.30,  5},
        {0.20,  3},
        {0.10,  1},
        {0.00,  0}
    }

    for i, scorerow in ipairs(Econ_Score_Table) do
        econ_score = scorerow[2]
        if econ_eff >= scorerow[1] then
            break
        end
    end

    for i, scorerow in ipairs(Kill_And_Conq_Score_Table) do
        kill_score = scorerow[2]
        if kill_eff >= scorerow[1] then
            break
        end
    end

    for i, scorerow in ipairs(Kill_And_Conq_Score_Table) do
        conq_score = scorerow[2]
        if conq_eff >= scorerow[1] then
            break
        end
    end

    return econ_score + kill_score + conq_score
end

function Debug_Print_Score_Vals()
    for pid, player in pairs(PlayerTable) do
        econ_eff, kill_eff = Get_Econ_And_Kill_Efficiency(player, GalacticKillStatsTable, GalacticBuildStatsTable)
        conq_eff = Get_Conquest_Efficiency(player)

        score = Calc_Score_For_Efficiency(econ_eff,kill_eff,conq_eff)

        GameScoringMessage(
            "Galactic %s:%s, Econ_Eff:%f, Kill_Eff:%f, Conq_Eff:%f, Score:%f",
            player.Get_Name(),
            player.Get_Faction_Name(),
            econ_eff,
            kill_eff,
            conq_eff,
            score
        )
    end
end

--
-- This function returns the a game stat for the given control id.
--
-- @param control_id         the control id
-- @return the game stat
-- @since 6/18/2005 4:13:13 PM -- BMH
--
function Get_Game_Stat_For_Control_ID(player, control_id, for_tactical)
--NB: efficiency values are truncated to 2 decimal places for display, but not for score calculations
    econ_eff = 0
    kill_eff = 0
    conq_eff = 0

    if for_tactical then
        econ_eff, kill_eff = Get_Econ_And_Kill_Efficiency(player, TacticalKillStatsTable, TacticalBuildStatsTable)
    else
        econ_eff, kill_eff = Get_Econ_And_Kill_Efficiency(player, GalacticKillStatsTable, GalacticBuildStatsTable)
    end

    if control_id == "IDC_MILITARY_EFFICIENCY_STATIC" then --can't rename guidialogs control w/o breaking display
        return econ_eff
    elseif control_id == "IDC_CONQUEST_EFFICIENCY_STATIC" then
        return Get_Conquest_Efficiency(player)
    elseif control_id == "IDC_KILL_EFFICIENCY_STATIC" then
        return kill_eff
    elseif control_id == "IDC_TITLE_STATIC" then
        conq_eff = Get_Conquest_Efficiency(player)
        score = Calc_Score_For_Efficiency(econ_eff,kill_eff,conq_eff)
        rank = Galactic_Conquest_Rank(score)
        message = Galactic_Conquest_End_Message(player)
        return rank..message
    else
        --MessageBox("Unknown control id %s:%s for Get_Game_Stat_For_Control_ID", type(control_id), tostring(control_id))
        return 0
    end
end

function Galactic_Conquest_Rank(score)
    local rank_table = {
        {300, "Flawless Victory"},
        {270, "Supreme Commander"},
        {255, "Fleet Admiral"},
        {240, "Admiral"},
        {225, "Vice Admiral"},
        {210, "Rear Admiral"},
        {195, "Commodore"},
        {180, "Captain"},
        {165, "Commander"},
        {150, "Lieutenant Commander"},
        {135, "Lieutenant"},
        {120, "Sub Lieutenant"},
        {105, "Chief Warrant Officer"},
        { 90, "Warrant Officer"},
        { 75, "Chief Petty Officer"},
        { 60, "Petty Officer"},
        { 45, "Leading Crewman"},
        { 30, "Able Crewman"},
        { 15, "Crewman"},
        {  0, "Youngling"}
    }

    local rank_string = nil
    local rank_count = nil
    if GlobalValue.Get("CHEATER") == true then
        rank_count = "XX"
    else
        rank_count = table.getn(rank_table)
    end

    for i, rank_row in ipairs(rank_table) do
        if score >= rank_row[1] then
            rank_string = "Rank "..tostring(i).." / "..tostring(rank_count)..": "..rank_row[2]
            break
        end
    end

    return rank_string
end

function Galactic_Conquest_End_Message(player)
	EndScreenMessages = Get_End_Screen_Messages()

	--storyline
	local storyline = GlobalValue.Get("STORYLINE")
	if EndScreenMessages[storyline] == nil then
		storyline = "DEFAULT_STORY"
	end

	--player
	local p_name = player.Get_Faction_Name()
	local p_event_name, p_alias = Mod_Specific_Faction_Name_Overrides(p_name,storyline)
	local p_name_masked

	if EndScreenMessages[storyline][p_event_name] ~= nil then
		p_name_masked = p_event_name
	elseif EndScreenMessages[storyline][p_name] ~= nil then
		p_name_masked = p_name
	elseif EndScreenMessages[storyline][p_alias] ~= nil then
		p_name_masked = p_alias
	elseif EndScreenMessages[storyline]["DEFAULT_PLAYER"] ~= nil then
		p_name_masked = "DEFAULT_PLAYER"

	elseif EndScreenMessages["DEFAULT_STORY"][p_event_name] ~= nil then
		storyline = "DEFAULT_STORY"
		p_name_masked = p_event_name		
	elseif EndScreenMessages["DEFAULT_STORY"][p_name] ~= nil then
		storyline = "DEFAULT_STORY"
		p_name_masked = p_name
	elseif EndScreenMessages["DEFAULT_STORY"][p_alias] ~= nil then
		storyline = "DEFAULT_STORY"
		p_name_masked = p_alias
	else
		storyline = "DEFAULT_STORY"
		p_name_masked = "DEFAULT_PLAYER"
	end

	--ending
	local ending = GlobalValue.Get("ENDING")
	if EndScreenMessages[storyline][p_name_masked][ending] ~= nil then
		--this space intentionally left blank
	else
		local last_gain_p_name = GlobalValue.Get("LAST_GAIN_PLAYER_NAME")
		if last_gain_p_name == nil then
			last_gain_p_name = Find_Player("local").Get_Faction_Name()
		end

		if ending == "SHIPYARD" then
			if EndScreenMessages[storyline][p_name_masked]["SHIPYARD"] ~= nil then
				--this space intentionally left blank
			else
				ending = "DEFAULT_WIN"
			end
		elseif last_gain_p_name == p_name then
			ending = "DEFAULT_WIN"
		else	
			local last_gain_p_event_name, last_gain_p_alias = Mod_Specific_Faction_Name_Overrides(last_gain_p_name,storyline)

			if EndScreenMessages[storyline][p_name_masked][last_gain_p_event_name] ~= nil then
				ending = last_gain_p_event_name
			elseif EndScreenMessages[storyline][p_name_masked][last_gain_p_name] ~= nil then
				ending = last_gain_p_name
			elseif EndScreenMessages[storyline][p_name_masked][last_gain_p_alias] ~= nil then
				ending = last_gain_p_alias
			elseif EndScreenMessages[storyline][p_name_masked]["DEFAULT_LOSE"] ~= nil then
				ending = "DEFAULT_LOSE"
			elseif EndScreenMessages[storyline][p_name_masked][last_gain_p_event_name] ~= nil then
				storyline = "DEFAULT_STORY"
				ending = last_gain_p_event_name
			elseif EndScreenMessages[storyline][p_name_masked][last_gain_p_name] ~= nil then
				storyline = "DEFAULT_STORY"
				ending = last_gain_p_name
			elseif EndScreenMessages[storyline][p_name_masked][last_gain_p_alias] ~= nil then
				storyline = "DEFAULT_STORY"
				ending = last_gain_p_alias
			else
				storyline = "DEFAULT_STORY"
				ending = "DEFAULT_LOSE"
			end
		end
	end

	local end_screen_message = EndScreenMessages[storyline][p_name_masked][ending]
	if end_screen_message == nil then
		end_screen_message = "ERROR: "..tostring(storyline).." "..tostring(p_name_masked).." "..tostring(ending)
	else
		end_screen_message = Mod_Specific_End_Modifiers(end_screen_message,storyline)
	end

	if string.len(end_screen_message) > 217 then
		end_screen_message = string.sub(end_screen_message,1,217)
	end

	return "\n \n"..end_screen_message
end
