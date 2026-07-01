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
--*   @Filename:            SpaceBattleHandler.lua
--*   @Last modified by:    svenmarcus
--*   @Last modified time:  2018-03-30T03:07:16+02:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("eawx-tactical/RaidFleet")
require("eawx-tactical/RandomEventQueue")
require("deepcore/crossplot/crossplot")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))
    --Define_State("State_Init", State_Init);
    --invaders = Find_Player("Hostile")
    --attack_chance = 0
    StoryModeEvents = {
        Battle_Start = State_Init,
        SWITCH_CONTROL_None1 = Remove_Huttlist,
        SWITCH_CONTROL_None2 = Remove_Huttlist,
        SWITCH_CONTROL_None3 = Remove_Huttlist,
        SWITCH_CONTROL_None4 = Remove_Huttlist,
        SWITCH_CONTROL_None5 = Remove_Huttlist,
        SWITCH_CONTROL_None6 = Remove_Huttlist,
        SWITCH_CONTROL_None7 = Remove_Huttlist,
        SWITCH_CONTROL_None8 = Remove_Huttlist,
        SWITCH_CONTROL_None9 = Remove_Huttlist,
        SWITCH_CONTROL_None10 = Remove_Huttlist,
        Retreat_Complete = Remove_Huttlist
    }

    queue = MakeRandomEventQueue()
end

function State_Init(message)
    if message == OnEnter then
        -- DebugMessage("State_Init  SpaceBattleHandler Started")
        -- TM = TransactionManager()
        -- TM:ResetBoardingTransactions()
        local fleet = MakeRaidFleet(0)
        --fleet:initialize()
        queue:addEvent(fleet)
        queue:beginEvents()
        crossplot:tactical()
        -- DebugMessage("State_Init  SpaceBattleHandler Finished")
    elseif message == OnUpdate then
        -- DebugMessage("State_Init  SpaceBattleHandler Update Started")
        crossplot:update()
        -- DebugMessage("State_Init  SpaceBattleHandler Update Finished")
    end
end

function Remove_Huttlist(message)
    -- DebugMessage("Remove_Huttlist SpaceBattleHandler Started")
    if message == OnEnter then
        queue:postBattleCleanUp()
    --RegisterBoardingTransactions()
    end
    -- DebugMessage("Remove_Huttlist SpaceBattleHandler Finished")
end
