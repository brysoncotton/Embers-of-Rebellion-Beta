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
--*   @Date:                2017-11-24T12:43:51+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            GCPlayerAgnostic.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2018-03-19T22:04:47+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

require("PGDebug")
require("PGStateMachine")
require("PGStoryMode")
require("PGBase")

require("eawx-util/StoryUtil")
require("deepcore/std/deepcore")
require("deepcore-extensions/initialize")

require("eawx-statemachine/dsl/TransitionPolicyFactory")
require("eawx-statemachine/dsl/TransitionEffectBuilderFactory")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    ServiceRate = 0.1

    StoryModeEvents = {Zoom_Zoom = Begin_GC}
end

function Begin_GC(message)
    if message == OnEnter then
        CONSTANTS = ModContentLoader.get("GameConstants")
        GameObjectLibrary = ModContentLoader.get("GameObjectLibrary")
        local plot = StoryUtil.GetPlayerAgnosticPlot()
        StoryUtil.ShowScreenText("TEXT_GUI_INITIALIZING", 10)

        local era = Find_Player("local").Get_Tech_Level()
        if Find_Player("local") == Find_Player("Rebel") then
            era = era + 1 
        end

        if era == 1 then
            era = 2
        end

        local credits = Find_Player("local").Get_Credits()
        Find_Player("local").Give_Money(10000-credits)

        --Adding instead of replacing so if it's the old method it won't interfere, yet
        local era_dummies ={
            "Era_One_Dummy",
            "Era_Two_Dummy",
            "Era_Three_Dummy",
            "Era_Four_Dummy",
            "Era_Five_Dummy",
            "Era_Six_Dummy",
            "Era_Seven_Dummy",
            "Era_Eight_Dummy",
            "Era_Nine_Dummy",
            "Era_Ten_Dummy",
            "Era_Eleven_Dummy",
            "Era_Twelve_Dummy",
            "Era_Thirteen_Dummy",
            "Era_Fourteen_Dummy",
        }

        for i, dummy in pairs(era_dummies) do
            local era_indicator = Find_First_Object(dummy)
            if era_indicator then
                era = i
                era_indicator.Despawn()
            end
        end

        GlobalValue.Set("CURRENT_ERA", era)
        local year_start = 22
        if era == 3 then
            year_start = 21   
        elseif era == 4 then
            year_start = 20
         elseif era == 5 then
            year_start = 19
        end

        --local holocron_event = plot.Get_Event("Show_Debug_Display")
        
        --local holocron_sink = require("deepcore/log/sinks/holocron-window")
        --                        :with_event(holocron_event)

        --Logger = require("deepcore/log/logger")
        --        :with_sink(holocron_sink)
        --        :with_log_level(3)

        local plugin_list = ModContentLoader.get("InstalledPlugins")
        local context = {
            plot = plot,
            maxroutes = 6,
            id = "PROGRESSIVE",
            year_start = year_start,
            unlocktech = true,
            is_generated = true,
            statemachine_dsl_config = {
                transition_policy_factory = EawXTransitionPolicyFactory,
                transition_effect_builder_factory = EawXTransitionEffectBuilderFactory
            },
            gc_name = "PROGRESSIVE",
        }

        ActiveMod = deepcore:galactic {
            context = context,
            plugins = plugin_list,
            plugin_folder = "eawx-plugins",
            planet_factory = function(planet_name)
                local Planet = require("deepcore-extensions/galaxy/Planet")
                return Planet(planet_name)
            end
        }

    elseif message == OnUpdate then
        ActiveMod:update()
    end
end
