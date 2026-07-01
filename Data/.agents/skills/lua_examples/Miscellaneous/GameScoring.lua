require("pgcommands")
require("deepcore/std/deepcore")
require("GalacticConquestEndings")

-- Don't pool...
ScriptPoolCount = 0

--
-- Base_Definitions -- sets up the base variable for this script.
--
-- @since 3/15/2005 3:55:03 PM -- BMH
--
function Base_Definitions()
    DebugMessage("%s -- In Base_Definitions", tostring(Script))

    Common_Base_Definitions()

    ServiceRate = 0.1
	timer = 0

    frag_index = 1
    death_index = 2
    GameStartTime = 0

    CampaignGame = false

    Reset_Stats()

    if Definitions then
        Definitions()
    end

    ModContentLoader = require("eawx-std/ModContentLoader")
    GlobalValue.Set("MOD_ID", ModContentLoader.get_mod_id())

    GameScoringPluginRunner = nil
end

--
-- The player list has been reset underneath us, reset the stats.
--
-- @since 5/5/2005 7:43:17 PM -- BMH
--
function Player_List_Reset()
    GameScoringMessage("GameScoring -- PlayerList Reset.")
    Reset_Stats()
end

--
-- main script function.  Does event pumps and servicing.
--
-- @since 3/15/2005 3:55:03 PM -- BMH
--
function main()
    DebugMessage("GameScoring -- In main.")

    if GameService then
        while true do
            GameService()
            PumpEvents()
            if GameScoringPluginRunner then
                GameScoringPluginRunner:update()
            end
        end
    end

    ScriptExit()
end

--
-- Reset the Tactical mode game stats.
--
-- @since 3/15/2005 3:56:43 PM -- BMH
--
function Reset_Tactical_Stats()
    GameScoringMessage("GameScoring -- Resetting tactical stats.")
    -- [frag|death][playerid][object_type][build_count, credits_spent, combat_power]
    TacticalKillStatsTable = {[frag_index] = {}, [death_index] = {}}
    TacticalTeamKillStatsTable = {[frag_index] = {}, [death_index] = {}}

    -- [playerid][planetname][object_type][build_count, credits_spent, combat_power]
    TacticalBuildStatsTable = {}

    -- a dirty hack to reset tactical script registry values
    ResetTacticalRegistry()
end

function GameScoringMessage(...)
    _ScriptMessage(string.format(unpack(arg)))
    _OuputDebug(string.format(unpack(arg)) .. "\n")
end

--
-- Reset all the stats and player lists.
--
-- @since 3/15/2005 3:56:43 PM -- BMH
--
function Reset_Stats()
    GameScoringMessage("GameScoring -- Resetting stats.")

    Reset_Tactical_Stats()
    -- [frag|death][playerid][object_type][build_count, credits_spent, combat_power]
    GalacticKillStatsTable = {[frag_index] = {}, [death_index] = {}}

    -- [playerid][planetname][object_type][build_count, credits_spent, combat_power]
    GalacticBuildStatsTable = {}

    -- [playerid][object_type][neutralized_count]
    GalacticNeutralizedTable = {}

    -- [playerid][planet_type][sacked_count, lost_count]
    GalacticConquestTable = {}
    PlayerTable = {}
    PlayerQuitTable = {}
end

function ResetTacticalRegistry()
    DebugMessage("Resetting Allow_AI_Controlled_Fog_Reveal to 1 (allowed)")
    GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)
end

--
-- Update our GameStats table with build stats
--
-- @param stat_table    stat table to update
-- @param planet        planet where the object was produced
-- @param object_type   the object type that was just produced
-- @since 3/18/2005 3:48:32 PM -- BMH
--
function Update_Build_Stats_Table(stat_table, planet, object_type, owner, build_cost)
    Update_Player_Table(owner)

    if planet then
        planet_type = planet.Get_Type()
        planet_name = planet_type.Get_Name()
    else
        planet_type = 1
        planet_name = "Unknown"
    end

    combat_power = object_type.Get_Combat_Rating()
    score_value = object_type.Get_Score_Cost_Credits()
    owner_id = owner.Get_ID()

    GameScoringMessage(
        "GameScoring -- %s produced %s at %s.",
        PlayerTable[owner_id].Get_Name(),
        object_type.Get_Name(),
        planet_name
    )

    player_entry = stat_table[owner_id]
    if player_entry == nil then
        player_entry = {}
    end

    planet_entry = player_entry[planet_type]
    if planet_entry == nil then
        planet_entry = {}
    end

    type_entry = planet_entry[object_type]
    if type_entry == nil then
        type_entry = {build_count = 1, combat_power = combat_power, build_cost = build_cost, score_value = score_value}
    else
        type_entry.build_count = type_entry.build_count + 1
        type_entry.combat_power = type_entry.combat_power + combat_power
        type_entry.build_cost = type_entry.build_cost + build_cost
        type_entry.score_value = type_entry.score_value + score_value
    end

    planet_entry[object_type] = type_entry
    player_entry[planet_type] = planet_entry
    stat_table[owner_id] = player_entry
end

--
-- Print out the current build statistics for all the players.
--
-- @param stat_table    stats table to display.
-- @since 3/21/2005 10:34:07 AM -- BMH
--
function Print_Build_Stats_Table(stat_table)
    GameScoringMessage("GameScoring -- Build Stats dump.")

    totals_table = {}

    for owner_id, player_entry in pairs(stat_table) do
        build_count = 0
        cost_count = 0
        power_count = 0
        score_count = 0

        GameScoringMessage("\tPlayer %s:", PlayerTable[owner_id].Get_Name())
        for planet_type, planet_entry in pairs(player_entry) do
            if planet_type == 1 then
                GameScoringMessage("\t\t%20s:", "Tactical")
            else
                GameScoringMessage("\t\t%20s:", planet_type.Get_Name())
            end
            for object_type, type_entry in pairs(planet_entry) do
                GameScoringMessage(
                    "\t\t%40s: %d : %d : $%d : %d",
                    object_type.Get_Name(),
                    type_entry.build_count,
                    type_entry.combat_power,
                    type_entry.build_cost,
                    type_entry.score_value
                )
                build_count = build_count + type_entry.build_count
                cost_count = cost_count + type_entry.build_cost
                power_count = power_count + type_entry.combat_power
                score_count = score_count + type_entry.score_value
            end
        end

        GameScoringMessage("\tTotal Builds: %d : %d : $%d : %d", build_count, power_count, cost_count, score_count)
        totals_table[owner_id] = {
            build_count = build_count,
            cost_count = cost_count,
            power_count = power_count,
            score_count = score_count
        }
    end
end

--
-- Print out the current statistics for all the players.
--
-- @param stat_table    stats table to display.
-- @since 3/15/2005 5:55:55 PM -- BMH
--
function Print_Stat_Table(stat_table)
    frag_table = {}

    GameScoringMessage("Frags:")
    for k, v in pairs(stat_table[frag_index]) do
        tkills = 0
        tpower = 0
        tscore = 0

        GameScoringMessage("\tPlayer %s:", PlayerTable[k].Get_Name())
        for kk, vv in pairs(v) do
            GameScoringMessage("\t%40s: %d : %d : %d", kk.Get_Name(), vv.kills, vv.combat_power, vv.score_value)
            tkills = tkills + vv.kills
            tpower = tpower + vv.combat_power
            tscore = tscore + vv.score_value
        end

        GameScoringMessage("\tTotal Frags: %d : %d : %d", tkills, tpower, tscore)
        frag_table[k] = {kills = tkills, combat_power = tpower, score_value = tscore}
    end

    death_table = {}

    GameScoringMessage("Deaths:")
    for k, v in pairs(stat_table[death_index]) do
        tkills = 0
        tpower = 0
        tscore = 0

        GameScoringMessage("\tPlayer %s:", PlayerTable[k].Get_Name())
        for kk, vv in pairs(v) do
            GameScoringMessage("\t%40s: %d : %d : %d", kk.Get_Name(), vv.kills, vv.combat_power, vv.score_value)
            tkills = tkills + vv.kills
            tpower = tpower + vv.combat_power
            tscore = tscore + vv.score_value
        end

        GameScoringMessage("\tTotal Deaths: %d : %d : %d", tkills, tpower, tscore)
        death_table[k] = {kills = tkills, combat_power = tpower, score_value = tscore}
    end

    for k, player in pairs(PlayerTable) do
        ft = frag_table[k]
        dt = death_table[k]
        if ft == nil or ft.kills == 0 then
            GameScoringMessage("\tPlayer %s, Weighted Kill Ratio: 0.0", player.Get_Name())
        elseif dt == nil or dt.kills == 0 then
            GameScoringMessage("\tPlayer %s, Weighted Kill Ratio: %d", player.Get_Name(), ft.kills)
        else
            GameScoringMessage("\tPlayer %s, Weighted Kill Ratio: %f", player.Get_Name(), ft.kills / dt.kills)
        end
    end
end

--
-- Script service function.  Just prints out the current stats.
--
-- @since 3/15/2005 3:56:43 PM -- BMH
--
function GameService()
	timer = timer + 0.1
	
	if timer >= 40 and CampaignGame then
		--GameScoringMessage("GameScoring -- Tactical Stats dump.")
		--Print_Stat_Table(TacticalKillStatsTable)
		GameScoringMessage("GameScoring -- Galactic Stats dump.")
		Print_Stat_Table(GalacticKillStatsTable)
		Print_Build_Stats_Table(GalacticBuildStatsTable)
		--Print_Build_Stats_Table(TacticalBuildStatsTable)
		Debug_Print_Score_Vals()
		timer = 0
	end
end

--
-- Updates the table of players for the current game.
--
-- @param player    player object to add to our table of players
-- @since 3/15/2005 3:56:43 PM -- BMH
--
function Update_Player_Table(player)
    if player == nil then
        return
    end

    ent = PlayerTable[player.Get_ID()]
    if ent == nil then
        PlayerTable[player.Get_ID()] = player
    end
    ent = nil
end

--
-- Update our GameStats table with victim, killer info.
--
-- @param stat_table    stat table to update
-- @param object        the object that was destroyed
-- @param killer        the player that killed this object
-- @since 3/15/2005 4:10:19 PM -- BMH
--
function Update_Kill_Stats_Table(stat_table, object, killer)
    if TestValid(object) == false or TestValid(killer) == false then
        return
    end

    Update_Player_Table(killer)
    Update_Player_Table(object.Get_Owner())

    object_type = object.Get_Game_Scoring_Type()
    score_value = object.Get_Game_Scoring_Type().Get_Score_Cost_Credits()
    combat_power = object.Get_Game_Scoring_Type().Get_Combat_Rating()
    build_cost = object.Get_Game_Scoring_Type().Get_Build_Cost()
    killer_id = killer.Get_ID()
    owner_id = object.Get_Owner().Get_ID()

    GameScoringMessage("GameScoring -- Object: %s, was killed by %s.", object_type.Get_Name(), killer.Get_Name())

    -- Update frags
    frag_entry = stat_table[frag_index]
    if frag_entry == nil then
        frag_entry = {}
    end

    entry = frag_entry[killer_id]
    if entry == nil then
        entry = {}
    end

    pe = entry[object_type]
    if pe == nil then
        pe = {kills = 1, combat_power = combat_power, build_cost = build_cost, score_value = score_value}
    else
        pe.kills = pe.kills + 1
        pe.combat_power = pe.combat_power + combat_power
        pe.build_cost = pe.build_cost + build_cost
        pe.score_value = pe.score_value + score_value
    end

    entry[object_type] = pe
    frag_entry[killer_id] = entry
    stat_table[frag_index] = frag_entry

    -- Update deaths
    death_entry = stat_table[death_index]
    if death_entry == nil then
        death_entry = {}
    end

    entry = death_entry[owner_id]
    if entry == nil then
        entry = {}
    end

    pe = entry[object_type]
    if pe == nil then
        pe = {kills = 1, combat_power = combat_power, build_cost = build_cost, score_value = score_value}
    else
        pe.kills = pe.kills + 1
        pe.combat_power = pe.combat_power + combat_power
        pe.build_cost = pe.build_cost + build_cost
        pe.score_value = pe.score_value + score_value
    end

    entry[object_type] = pe
    death_entry[owner_id] = entry
    stat_table[death_index] = death_entry
end

----------------------------------------
--
--      E V E N T   H A N D L E R S
--
----------------------------------------

--
-- This event is triggered on a game mode start.
--
-- @param mode_name    name of the new mode (ie: Galactic, Land, Space)
-- @since 3/15/2005 3:58:59 PM -- BMH
--
function Game_Mode_Starting_Event(mode_name, map_name)
    GameScoringMessage("GameScoring -- Mode %s (%s) now starting.", mode_name, map_name)
    LastModeName = mode_name
    LastMapName = map_name

    if StringCompare(mode_name, "Galactic") then
        -- Galactic Campaign
        if not GameScoringPluginRunner then
            local config = require("DeepCoreGameScoringConfig")
            GameScoringPluginRunner = deepcore:gamescoring(config)
        end

        CampaignGame = true
        Reset_Stats()
        GameStartTime = GetCurrentTime.Frame()
    elseif CampaignGame == false then
        -- Skirmish tactical
        Reset_Stats()
        GameStartTime = GetCurrentTime.Frame()
    elseif CampaignGame == true then
        -- Galactic transition to Tactical.
        -- cleaning out full galactic tables for performance reasons
        Reset_Tactical_Stats()
    end
    crossplot:publish("GAME_MODE_STARTING", mode_name)
    LastWasCampaignGame = CampaignGame
end

--
-- This event is triggered on a game mode end.
--
-- @param mode_name    name of the old mode (ie: Galactic, Land, Space)
-- @since 3/15/2005 3:58:59 PM -- BMH
--
function Game_Mode_Ending_Event(mode_name)
    GameScoringMessage("GameScoring -- Mode %s now ending.", mode_name)

    LastWasCampaignGame = CampaignGame
    if StringCompare(mode_name, "Galactic") then
        CampaignGame = false
    end
    
    crossplot:publish("GAME_MODE_ENDING", mode_name)
end

--
-- This event is triggered when a player quits the game.
--
-- @param player		the player that just quit
-- @since 8/25/2005 10:00:54 AM -- BMH
--
function Player_Quit_Event(player)
    Update_Player_Table(player)

    if player == nil then
        return
    end

    PlayerQuitTable[player.Get_ID()] = true
end

--
-- This event is triggered when a unit is destroyed in a tactical game mode.
--
-- @param object        the object that was destroyed
-- @param killer        the player that killed this object
-- @since 3/15/2005 4:10:19 PM -- BMH
--
function Tactical_Unit_Destroyed_Event(object, killer)
    Update_Kill_Stats_Table(TacticalKillStatsTable, object, killer)

    if object.Is_Category("Fighter") or object.Is_Category("Bomber") or object.Is_Category("Gunship") then
        return
    end

    local object_type = object.Get_Type()

    if not object_type then
        return
    end

    local object_name = object_type.Get_Name()
    local object_power = object_type.Get_Combat_Rating()
    local object_is_hero = object_type.Is_Hero()

    if object_name and object_power then
        crossplot:publish("TACTICAL_UNIT_DESTROYED", object_name, object_power, object_is_hero, object)
    end
end

--
-- This event is triggered when a unit is destroyed in the galactic game mode.
--
-- @param object        the object that was destroyed
-- @param killer        the player that killed this object
-- @since 3/15/2005 4:10:19 PM -- BMH
--
-- NB: For units that have companies, the "object" submitted to this function is always the company.
--     There is an engine bug related to this: when a hero company's space transport is killed in
--     tactical, the hero company's death is reported using this function and the company is removed
--     from the game, but the unit objects that are members of that company are NOT removed from the
--     game. They stick around with an invalid location for the remainder of the game. ~Mord
function Galactic_Unit_Destroyed_Event(object, killer)
    Update_Kill_Stats_Table(GalacticKillStatsTable, object, killer)
    Update_Kill_Stats_Table(TacticalTeamKillStatsTable, object, killer)

    local object_type = object.Get_Type()
    local object_name = object_type.Get_Name()

    local killer_name = ""
    if TestValid(killer) and killer.Get_Faction_Name then
        killer_name = killer.Get_Faction_Name()
    end

    local owner = object.Get_Owner()
    local owner_name = ""
    if TestValid(owner) and owner.Get_Faction_Name then
        owner_name = owner.Get_Faction_Name()
    end

    if object_name == "GROUND_HYPERVELOCITY_GUN" or object_name == "GROUND_ION_CANNON" then
        return
    end

    if object_name == "DARK_EMPIRE_CLONING_FACILITY" then
        crossplot:publish("GALACTIC_HERO_KILLED", object_name, owner_name, killer_name)
        return
    end

    if object_type.Is_Hero() == true then
        crossplot:publish("GALACTIC_HERO_KILLED", object_name, owner_name, killer_name)
        return
    end

    local short_name = Is_SSD(object_name)
    if short_name ~= nil then
        crossplot:publish("GALACTIC_SSD_KILLED", short_name, owner_name, killer_name)
        return
    end

    local limited_build = require("BuildLimitLibrary")
    if string.find(object_name, "PATRON_") or limited_build[object_name] then
        crossplot:publish("LIMITED_UNIT_KILLED", object_name, owner_name)
    end
end

function Is_SSD(entered_name)
    local display_name_library = require("DisplayNameLibrary")

    return display_name_library[entered_name]
end

--
-- This event is triggered when production has begun on an item at a given planet
--
-- @param planet        the planet that will produce this object
-- @param object_type   the object type scheduled for production
-- @since 3/15/2005 4:10:19 PM -- BMH
--
function Galactic_Production_Begin_Event(planet, object_type)
    --Track credits spent
    crossplot:publish("PRODUCTION_STARTED", planet.Get_Type().Get_Name(), object_type.Get_Name())
end

--
-- This event is triggered when production has been prematurely canceled
-- on an item at a given planet
--
-- @param planet        the planet that was producing this object
-- @param object_type   the object type that got canceled
-- @since 3/15/2005 4:10:19 PM -- BMH
--
function Galactic_Production_Canceled_Event(planet, object_type)
    --Track credits spent
    crossplot:publish("PRODUCTION_CANCELED", planet.Get_Type().Get_Name(), object_type.Get_Name())
end

--
-- This event is triggered when production has finished in a tactical mode
--
-- @param object_type   the object type that was just built
-- @param player			the player that built the object.
-- @param location		the location that built the object(could be nil)
-- @since 8/22/2005 6:11:07 PM -- BMH
--
function Tactical_Production_End_Event(object_type, player, location)
    Update_Build_Stats_Table(
        TacticalBuildStatsTable,
        location,
        object_type,
        player,
        object_type.Get_Tactical_Build_Cost()
    )

    crossplot:publish("TACTICAL_PRODUCTION_FINISHED", object_type.Get_Name())
end

--
-- This event is triggered when production has finished on an item at a given planet
--
-- @param planet        the planet that produced this object
-- @param object        the object that was just created
-- @since 3/15/2005 4:10:19 PM -- BMH
--
function Galactic_Production_End_Event(planet, object)
    if object.Get_Type == nil then
        -- object must be a GameObjectTypeWrapper not a GameObjectWrapper if it doesn't
        -- have a Get_Type function.
        Update_Build_Stats_Table(GalacticBuildStatsTable, planet, object, planet.Get_Owner(), object.Get_Build_Cost())
    else
        --somehow bad objects (or planets?) get in here sometimes
		if planet == nil or object == nil then
			return
		elseif planet.Get_Type() == nil or object.Get_Type() == nil then
			return
		else
			crossplot:publish("PRODUCTION_FINISHED", planet.Get_Type().Get_Name(), object.Get_Type().Get_Name())
		end

        -- object points to the GameObjectWrapper that was just created.
        Update_Build_Stats_Table(
            GalacticBuildStatsTable,
            planet,
            object.Get_Game_Scoring_Type(),
            planet.Get_Owner(),
            object.Get_Game_Scoring_Type().Get_Build_Cost()
        )
    end
end

function fake_get_owner()
    return fake_object_player
end

function fake_get_type()
    return fake_object_type
end

function fake_is_valid()
    return true
end

--
-- This event is triggered when the level of a starbase changes
--
-- @param planet        the planet where the starbase is located
-- @param old_type      the old starbase type
-- @param new_type      the new starbase type
-- @since 3/15/2005 4:10:19 PM -- BMH
--
function Galactic_Starbase_Level_Change(planet, old_type, new_type)
    GameScoringMessage(
        "GameScoring -- %s Starbase changed from %s to %s.",
        planet.Get_Type().Get_Name(),
        tostring(old_type),
        tostring(new_type)
    )

    if old_type == nil then
        return
    end
    if new_type ~= nil then
        return
    end

    fake_object_type = old_type
    fake_object_player = planet.Get_Owner()
    fake_object = {}
    fake_object.Get_Owner = fake_get_owner
    fake_object.Get_Type = fake_get_type
    fake_object.Get_Game_Scoring_Type = fake_get_type
    fake_object.Is_Valid = fake_is_valid
    crossplot:publish(
        "STARBASE_LEVEL_CHANGED", 
        fake_object_player,
        planet, 
        old_type, 
        new_type, 
        planet.Get_Final_Blow_Player())
    Galactic_Unit_Destroyed_Event(fake_object, planet.Get_Final_Blow_Player())
end

--
-- This event is called when a planet changes faction in galactic mode
--
-- @param planet	      The planet object
-- @param newplayer		The new owner player of this planet.
-- @param oldplayer		The old owner player of this planet.
-- @since 6/20/2005 8:37:53 PM -- BMH
--
function Galactic_Planet_Faction_Change(planet, newplayer, oldplayer)
    local newplayer_faction_name = newplayer.Get_Faction_Name()
    local oldplayer_faction_name = oldplayer.Get_Faction_Name()

    crossplot:publish(
        "PLANET_OWNER_CHANGED",
        planet.Get_Type().Get_Name(),
        newplayer_faction_name,
        oldplayer_faction_name
    )

    CONSTANTS = ModContentLoader.get("GameConstants")

    human_player = Find_Player("local")
    if human_player == newplayer or human_player == oldplayer then
        for _, playable_faction_name in pairs(CONSTANTS.PLAYABLE_FACTIONS) do
            if oldplayer_faction_name == playable_faction_name then
                GlobalValue.Set("LAST_LOSE_PLAYER_NAME",oldplayer_faction_name)
            end
            if newplayer_faction_name == playable_faction_name then
                GlobalValue.Set("LAST_GAIN_PLAYER_NAME",newplayer_faction_name)
            end
        end
    end

    -- Update the player table.
    Update_Player_Table(newplayer)
    Update_Player_Table(oldplayer)

    newid = newplayer.Get_ID()
    oldid = oldplayer.Get_ID()
    planet_type = planet.Get_Type()

    GameScoringMessage(
        "GameScoring -- %s changed control from %s to %s.",
        planet_type.Get_Name(),
        oldplayer.Get_Name(),
        newplayer.Get_Name()
    )

    -- Update the sacked count for the new owner.
    entry = GalacticConquestTable[newid]
    if entry == nil then
        entry = {}
    end

    pe = entry[planet_type]
    if pe == nil then
        pe = {sacked_count = 1, lost_count = 0}
    else
        pe.sacked_count = pe.sacked_count + 1
    end

    entry[planet_type] = pe
    GalacticConquestTable[newid] = entry

    -- Update the lost count for the old owner.
    entry = GalacticConquestTable[oldid]
    if entry == nil then
        entry = {}
    end

    pe = entry[planet_type]
    if pe == nil then
        pe = {sacked_count = 0, lost_count = 1}
    else
        pe.lost_count = pe.lost_count + 1
    end

    entry[planet_type] = pe
    GalacticConquestTable[oldid] = entry

    planet_type = nil
end

--
-- This event is called when a hero is neutralized by another hero in galactic mode
--
-- @param hero_type	The hero that was just neutralized
-- @param killer		The hero that just neutralized the above hero.
-- @since 3/21/2005 1:43:44 PM -- BMH
--
function Galactic_Neutralized_Event(hero_type, killer)
    Update_Player_Table(killer.Get_Owner())

    killer_id = killer.Get_Owner().Get_ID()

    entry = GalacticNeutralizedTable[killer_id]
    if entry == nil then
        entry = {}
    end

    pe = entry[hero_type]
    if pe == nil then
        pe = {neutralized = 1}
    else
        pe.neutralized = pe.neutralized + 1
    end

    entry[hero_type] = pe
    GalacticNeutralizedTable[killer_id] = entry
	
	crossplot:publish("GALACTIC_HERO_NEUTRALIZED", hero_type.Get_Name(), killer_id)
end

--
-- This function returns the number of frags a given player has for a given object type.
--
-- @param object_type        the object type we want to know about.
-- @param player             the player who's frag count we want to query.
-- @since 3/21/2005 1:23:21 PM -- BMH
--
function Get_Frag_Count_For_Type(object_type, player)
    owner_id = player.Get_ID()

    frag_entry = GalacticKillStatsTable[frag_index]
    if frag_entry == nil then
        return 0
    end

    entry = frag_entry[owner_id]
    if entry == nil then
        return 0
    end

    pe = entry[object_type]
    if pe == nil then
        return 0
    end

    return pe.kills
end

--
-- This function returns the number of neutralizes a given player has for a given object type.
--
-- @param object_type        the object type we want to know about.
-- @param player             the player who's neutralize count we want to query.
-- @since 3/21/2005 1:23:21 PM -- BMH
--
function Get_Neutralized_Count_For_Type(object_type, player)
    owner_id = player.Get_ID()

    entry = GalacticNeutralizedTable[owner_id]
    if entry == nil then
        return 0
    end

    pe = entry[object_type]
    if pe == nil then
        return 0
    end

    return pe.neutralized
end

--
-- This function updates the table of GameSpy game stats.
--
-- @since 3/29/2005 5:14:42 PM -- BMH
--
function Update_GameSpy_Game_Stats()
end

--
-- This function updates the table of GameSpy player kill stats.
--
-- @param stat_table		the stat table we should pull stats from
-- @param player			the player who's stats we need to update.
-- @since 3/29/2005 5:14:42 PM -- BMH
--
function Update_GameSpy_Kill_Stats(stat_table, build_stats, player)
end

--
-- This function updates the table of GameSpy player stats.
--
-- @param player		the player who's stats we need to update.
-- @since 3/29/2005 5:14:42 PM -- BMH
--
function Update_GameSpy_Player_Stats(player)
end

function Get_Current_Winner_By_Score()
    return WinnerID
end
