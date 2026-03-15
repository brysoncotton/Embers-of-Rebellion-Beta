require("PGDebug")

YieldCount = 0;
DebugMode = false

function Debug_Text(text)
    if DebugMode then
        Game_Message(text)
    end
end

function Debug_Blip(object, blip_object_name)
    if DebugMode then
        Add_Radar_Blip(object, blip_object_name)
    end
end

function Remove_Debug_Blip(blip_object_name)
    if DebugMode then
        Remove_Radar_Blip(blip_object_name)
    end
end

function ScriptExit()
    _ScriptExit() -- set a flag in 'C' to terminate the whole script on next yield

    if GetThreadID() >= 0 then
        coroutine.yield(false) -- return false to exit this thread
    end
end

-- OG sleep
function Sleep(timeToSleep)
    -- DebugMessage("Sleeping...  SleepTime: %.3f, CurTime: %.3f\n", time, GetCurrentTime())

    ThreadValue.Set("StartTime", GetCurrentTime())

    while ThreadValue("StartTime") and (GetCurrentTime() - ThreadValue("StartTime") < timeToSleep) do
        PumpEvents()
    end
    -- DebugMessage("Done with Sleep.  Continuing, CurTime: %.3f\n", GetCurrentTime())
end

-- DEPRECATED Bobs sleep
--[[function Sleep(sleeptime)
    if type(sleeptime) ~= "number" then
        sleeptime = tonumber(0)
    end
    ThreadValue.Set("StartTime", GetCurrentTime())
    while GetCurrentTime() - ThreadValue("StartTime") < sleeptime do
        PumpEvents()
    end
end]]

-- PetroBHayes Sleep with force_to_number
--[[function force_to_number(val)
    local nval = tonumber(val)
    if nil == nval then return 0 end
    return nval
end]] --

--[[
function Sleep(time)
    -- can't have locals and upvalues in scope when yielding.  Custom lua persistence code doesn't like them
    time = force_to_number(time)
    ThreadValue.Set("StartTime", force_to_number(GetCurrentTime()))
    while force_to_number(GetCurrentTime()) - force_to_number(ThreadValue("StartTime")) < time do
        PumpEvents()
    end
end
]] --

-- Service the block until optional max duration has expired or alternate break function returns true
-- Pass -1 max_duration to use optional alternate break function with no time limit
function BlockOnCommand(block, max_duration, alternate_break_func)

    PumpEvents()

    if not block then
        return nil
    end

    break_block = false

    ThreadValue.Set("BlockStart", GetCurrentTime())

    repeat
        if break_block == true then
            break_block = false
            return nil
        end

        PumpEvents()

        if ((max_duration ~= nil) and (max_duration ~= -1) and
            (GetCurrentTime() - ThreadValue("BlockStart") > max_duration)) then
            -- MessageBox("%s -- Had a time limit and it expired", tostring(Script))
            return nil
        end

        if ((alternate_break_func ~= nil) and alternate_break_func()) then
            -- MessageBox("%s-- had a break func and it returned true", tostring(Script))
            return nil
        end

    until (block.IsFinished() == true)

    PumpEvents()

    return block.Result()
end

function BreakBlock()
    break_block = true
end

function TestCommand(block)
    if not block then
        return nil
    end

    PumpEvents()

    return block.IsFinished()
end

function PumpEvents()

    if Object and type(Object) == "userdata" then
        Object.Service_Wrapper()
    end

    if Pump_Service and type(Pump_Service) == "function" then
        Pump_Service()
    end

    if ThreadValue("InPumpEvents") then
        ScriptError("%s -- Already in pump event!!", tostring(Script))
    end

    ThreadValue.Set("InPumpEvents", true)

    -- DebugMessage("%s -- Entering yield.  Count: %d, Time: %.3f\n", tostring(Script), YieldCount, GetCurrentTime())
    YieldCount = YieldCount + 1
    coroutine.yield(true) -- yield here and return to 'C'
    -- DebugMessage("%s -- Return from yield.  Count: %d, Time: %.3f\n", tostring(Script), YieldCount, GetCurrentTime())

    CurrentEvent = GetEvent()
    while CurrentEvent do
        ScriptMessage("%s -- Pumping Event: %s.", tostring(Script), tostring(CurrentEvent))
        EventParams = GetEvent.Params()
        if EventParams then
            CurrentEvent(unpack(EventParams))
        else
            CurrentEvent()
        end

        if Script.Debug_Should_Issue_Event_Alert() and DebugEventAlert then
            DebugEventAlert(CurrentEvent, EventParams)
        end

        CurrentEvent = GetEvent()
    end
    ThreadValue.Set("InPumpEvents", false)
end

function TestValid(wrapper)
    if wrapper == nil then
        return false
    end

    if wrapper.Is_Valid == nil then
        return false
    end

    return wrapper.Is_Valid()
end

function Clamp(value, min, max)
    if value < min then
        return min
    elseif value > max then
        return max
    else
        return value
    end
end

-- Normalizes a given value with provided min and max values to something between 0 and 1
function Normalize(value, minValue, maxValue)
    if value > maxValue then
        return 1.0
    end

    if value < minValue then
        return 0.0
    end

    return (value - minValue) / (maxValue - minValue)
end

function NormalizeInverse(value, minValue, maxValue)
    if value > maxValue then
        return 0.0
    end

    if value < minValue then
        return 1.0
    end

    return (maxValue - value) / (maxValue - minValue)
end

function IsWithinRange(value, minValue, maxValue)
    if value < minValue then
        return 0.0
    end

    if value > maxValue then
        return 0.0
    end

    return 1.0
end

-- Nasty hack of a floor function to be replaced if a math library floor funciton is exposed
function Dirty_Floor(val)
    return string.format("%d", val) -- works on implicit string to int conversion
end

-- Machine independent modulus function 
function Simple_Mod(a, b)
    -- return a-b*math.floor(a/b)
    return a - b * Dirty_Floor(a / b)
end

-- Returns if something happened, given a % chance
function Chance(seed, percent)
    roll = Simple_Mod((seed + 1), 100)
    is_allowed = roll < percent
    DebugMessage("%s -- seed:%d percent:%d roll:%d is_allowed:%s", tostring(Script), seed, percent, roll,
        tostring(is_allowed))
    return is_allowed
end

function GetCurrentMinute()
    -- return math.floor(GetCurrentTime()/60)
    return Dirty_Floor(GetCurrentTime() / 60)
end

function GetRandomSeed()
    return GetCurrentTime()
end

-- Every X seconds, the AI will have a new opportunity to see if it's allowed to use an ability
function GetAbilityChanceSeed()
    return GetCurrentTime()
end

function GetChanceAllowed(difficulty)
    -- Possibly change these back, but randomness makes things hard to test
    chance = 100
    if difficulty == "Easy" then
        chance = 100
    elseif difficulty == "Hard" then
        chance = 100
    end
    return chance
end

function PlayerSpecificName(player_object, var_name)
    --	ret_value = tostring(player_object.Get_ID()) .. "_" .. var_name
    --	DebugMessage("%s -- creating player specific string %s.", tostring(Script), ret_value)
    --	return ret_value
    return (tostring("PLAYER" .. player_object.Get_ID()) .. "_" .. var_name)
end

function Flush_G()

    entries_for_deletion = {}

    -- Define the set of tables that we had better keep around
    very_important_tables = {
        _LOADED,
        coroutine,
        string,
        LuaWrapperMetaTable,
        _G,
        security,
        table,
        entries_for_deletion
    }

    -- Silly thing is nil (we think) if we try to add it earlier
    table.insert(very_important_tables, very_important_tables)

    -- Iterate all globals
    for i, g_entry in pairs(_G) do

        if type(g_entry) == "table" then
            -- Tables are inherently unsafe: who knows what might be in there?
            -- If they're not in the list of things we must keep then they go.

            for j, important_entry in pairs(very_important_tables) do
                if important_entry == g_entry then
                    keep_table = true
                end
            end
            if not keep_table then
                table.insert(entries_for_deletion, i)
            end

            keep_table = nil

        elseif type(g_entry) == "userdata" then
            -- Some User Data (e.g. our code functions) should be kept, but some is very, very dangerous.
            -- Query the object to see whether it's safe to persist.

            if not g_entry.Is_Pool_Safe() then
                table.insert(entries_for_deletion, i)
            end

        end

    end

    for i, bad_entry in pairs(entries_for_deletion) do
        _G[bad_entry] = nil
    end

    entries_for_deletion = nil
    very_important_tables = nil

end

function Max(t)
    tableLength = table.getn(t)
    if tableLength == 0 then
        return nil, nil
    end

    local key, value = 1, t[1]
    for i = 2, tableLength do
        if value < t[i] then
            key, value = i, t[i]
        end
    end
    return key, value
end

function GetIndexOfHighestValue(t)
    index, value = Max(t)
    return index
end

function GetIndexOfHighestValueWithSlightRandomness(t, chance)
    tableLength = table.getn(t)
    if tableLength < 2 then
        return 1
    end

    index = GetIndexOfHighestValue(t)
    if Chance(GetRandomSeed(), chance) then
        return index
    end

    table.remove(t, index)
    return GetIndexOfHighestValueWithSlightRandomness(t, (chance + 1))
end

function GetIndexOfRandomElementContainingTrueValue(t)
    if (table.getn(t) == 0) then
        return BIG_FLOAT
    end

    -- iterate over whole table to get all keys
    local indexTable = {}
    for index, value in pairs(t) do
        if value == true then
            table.insert(indexTable, index)
        end
    end

    randomIndex = GameRandom(1, table.getn(indexTable))
    return indexTable[randomIndex]
end

function FindAllObjectsForTypes(t)
    result = {}
    for i, currentType in pairs(t) do
        objects = Find_All_Objects_Of_Type(t[i])
        for i, object in pairs(objects) do
            table.insert(result, object)
        end
    end
    return result
end

function FindAllObjectsForTypesAndPlayer(playerObject, t)
    result = {}
    for i, currentType in pairs(t) do
        objects = Find_All_Objects_Of_Type(t[i], playerObject)
        for i, object in pairs(objects) do
            table.insert(result, object)
        end
    end
    return result
end

function FilterArray(arr, func)
    result = {}
    for i, object in ipairs(arr) do
        if func(object, i) then
            table.insert(result, object)
        end
    end
    return result
end

function GetObjectCount(objectTypes)
    result = FindAllObjectsForTypes(objectTypes)
    if result then
        return table.getn(result)
    end
    return 0
end

function GetObjectCountForPlayer(playerObject, objectTypes)
    result = FindAllObjectsForTypesAndPlayer(playerObject, objectTypes)
    if result then
        return table.getn(result)
    end
    return 0
end

function Merge(tableOne, tableTwo)
    result = {}
    for k, v in pairs(tableOne) do
        table.insert(result, v)
    end
    for k, v in pairs(tableTwo) do
        table.insert(result, v)
    end
    return result
end

function MergeArrays(t)
    result = {}
    for k, v in pairs(t) do
        result = Merge(result, v)
    end
    return result
end
