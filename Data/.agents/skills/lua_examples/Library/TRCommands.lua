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
--*   @Filename:            TRCommands.lua
--*   @Last modified by:    svenmarcus
--*   @Last modified time:  2018-03-01T15:22:09+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

require("PGBase")
require("PGCommands")

GameObjectLibrary = ModContentLoader.get("GameObjectLibrary")

function TR_Register_Prox(obj, func, range, player_filter, param)
    if not ProximityCallbacks then
        ProximityCallbacks = {}
    end

    if not ProximityCallbacks[obj] then
        ProximityCallbacks[obj] = {}
    end

    table.insert(ProximityCallbacks[obj], {callback = func, param = param})
    Register_Prox(obj, DefaultCallback, range, player_filter)
end

function DefaultCallback(prox_obj, trigger_obj)
    if not ProximityCallbacks[prox_obj] then
        return
    end
    for _, callbackWrapper in pairs(ProximityCallbacks[prox_obj]) do
        callbackWrapper.callback(prox_obj, trigger_obj, callbackWrapper.param)
    end
end

function TR_Cancel_Prox(obj, func)
    if not ProximityCallbacks[obj] then
        return
    end

    for i, callbackWrapper in pairs(ProximityCallbacks[obj]) do
        if callbackWrapper.callback == func then
            table.remove(ProximityCallbacks[obj], i)
        end
    end

    if table.getn(ProximityCallbacks[obj]) == 0 then
        ProximityCallbacks[obj] = nil
        obj.Cancel_Event_Object_In_Range(func)
    end
end

function HasScriptedAbility(object, abilityName)
    if not TestValid(object) then
        return false
    end

    local objectTypeName = object.Get_Type().Get_Name()

    local libraryEntry = ModContentLoader.get_object_script(objectTypeName)

    if not libraryEntry or not libraryEntry.Scripts then
        return false
    end

    for i, script in pairs(libraryEntry.Scripts) do
        if script == abilityName then
            return true
        end
    end

    return false
end

function IsAllowedToUseTurbo(object)
    return not HasScriptedAbility(object, "SingleUnitRetreat")
end

function UseTurboIfAllowed(units)
    local unitList = units
    if Is_A_Taskforce(units) then
        unitList = MainForce.Get_Unit_Table()
    elseif type(units) == "userdata" then
        unitList = {units}
    end

    if not unitList then
        return
    end

    for i, unit in pairs(unitList) do
        local isValidUnit = TestValid(unit) and unit.Has_Ability("Turbo") and unit.Is_Ability_Ready("Turbo")
        if isValidUnit and IsAllowedToUseTurbo(unit) then
            unit.Activate_Ability("Turbo", true)
        end
    end
end

function Randomize_List(object_list)

    randomized_object_list = {}
    for _, value in ipairs(object_list) do
        table.insert(randomized_object_list, value)
    end

    randomized_object_size = table.getn(randomized_object_list)

    for i = 1, randomized_object_size, 1 do
        local a = GameRandom(1, randomized_object_size)
        local b = GameRandom(1, randomized_object_size)
        randomized_object_list[a], randomized_object_list[b] = randomized_object_list[b], randomized_object_list[a]
    end

    return randomized_object_list
end

-- Creates a table of faction player objects where each entry is
-- a faction that owns at least one planet in the GC.
-- In: string list of faction names e.g. CONSTANTS.ALL_FACTIONS, galactic_context bool true if need to evaluate from tactical
-- Out: FactionTable
function CreateFactionTable(factions, galactic_context)
    faction_table = {}
    for _, faction in pairs(factions) do
        CreateFactionEntry(faction, faction_table, galactic_context)
    end

    return faction_table
end

---@private
-- Creates an entry in  the FactionTable for factions that are present
-- In: String name of a faction, galactic_context bool true if need to evaluate from tactical
-- Out: Inserts faction into FactionTable
function CreateFactionEntry(faction_string, faction_table, galactic_context)
    if faction_string == "NEUTRAL" or faction_string == "HOSTILE" then
        return
    end
	DebugMessage("%s -- adding faction %s to list.", tostring(Script), tostring(faction_string))
    faction_object = Find_Player(faction_string)
	if faction_object then
		if FactionOwnsPlanets(faction_object, galactic_context) then
			table.insert(faction_table, faction_object)
		end
	end
end

---@private
-- Returns true if a faction has some kind of AI control and
-- owns at least one planet
-- In: faction playerObject, galactic_context bool true if need to evaluate from tactical
-- Out: boolean
function FactionOwnsPlanets(faction_object, galactic_context)
	local planets_owned = 0
	if galactic_context then
		planets_owned = Evaluate_In_Galactic_Context("Planet_Ownership", faction_object)
	else
		planets_owned = EvaluatePerception("Planet_Ownership", faction_object)
	end
		
	if planets_owned ~= nil then
		if planets_owned > 0 then
			return true
		end
	end

    return false
end

