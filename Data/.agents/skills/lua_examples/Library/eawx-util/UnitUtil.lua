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
--*   @Date:                2018-03-10T15:09:24+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            story_util.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2018-03-17T02:24:26+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************
require("eawx-util/StoryUtil")

UnitUtil = {
    __important = true,
    PlayerAgnosticPlots = {
        Galactic = "Conquests\\Player_Agnostic_Plot.xml",
        Space = "Conquests\\SpaceTactical\\Tactical_SpaceBattles.XML",
        Land = "Conquests\\GroundTactical\\Tactical_GroundBattles.XML"
    }
}

function UnitUtil.GetPlayerAgnosticPlot()
    local plotName = UnitUtil.PlayerAgnosticPlots[Get_Game_Mode()]
    return Get_Story_Plot(plotName)
end


function UnitUtil.SetLockList(faction, lock_list, state)

    local player = Find_Player(faction)

    for _, unit in pairs(lock_list) do
        if TestValid(Find_Object_Type(unit)) then
            DebugMessage("Locking %s for %s", tostring(unit), tostring(player))
            if state == false then
                player.Lock_Tech(Find_Object_Type(unit))
            else
                player.Unlock_Tech(Find_Object_Type(unit))
            end
        end
    end

    return
end

--These require a second prereq object to exist, then spawn that
function UnitUtil.TacticalUnlock(object, player)

    local position = Find_First_Object("Defending Forces Position").Get_Position()
    local prereq_name = object .. "_Prereq"
    Create_Generic_Object(prereq_name, position, Find_Player(player))

end

function UnitUtil.TacticalLock(object)

    local prereq_name = object .. "_Prereq"
    local object = Find_First_Object(prereq_name)
    if TestValid(object) then
        object.Despawn()
    end

    return
end

function UnitUtil.ReplaceAtLocation(original, upgrade)
    local checkObject = original
    if type(checkObject) == "string" then 
        checkObject = Find_First_Object(original)
    end
    if TestValid(checkObject) then
        local objectOwner = checkObject.Get_Owner()
        local planet = checkObject.Get_Planet_Location()
        
        if not planet then
            planet = StoryUtil.FindFriendlyPlanet(objectOwner, true)
        end

        if not planet then
            return
        end

        local planetOwner = planet.Get_Owner()

        if planetOwner ~= objectOwner then
            if EvaluatePerception("Enemy_Present_In_Space", objectOwner, planet) > 0 then
                planet = StoryUtil.FindFriendlyPlanet(objectOwner, true)
            end
			--Fill up the ground slots the the unit will always spawn in orbit
			SpawnList({"Placement_Dummy","Placement_Dummy","Placement_Dummy","Placement_Dummy","Placement_Dummy","Placement_Dummy","Placement_Dummy","Placement_Dummy","Placement_Dummy","Placement_Dummy"}, planet, Find_Player("Neutral"),false,false)
        end

        checkObject.Despawn()
        SpawnList({upgrade}, planet, objectOwner, true, false)
		local forceorbit = Find_All_Objects_Of_Type("Placement_Dummy")
		for _, randomDummy in pairs(forceorbit) do
			randomDummy.Despawn()
		end
    end
end

function UnitUtil.SpawnAtObjectLocation(target, object)
    local checkObject = Find_First_Object(target)
    if TestValid(checkObject) then
        local objectOwner = checkObject.Get_Owner()
        local planet = checkObject.Get_Planet_Location()
        if not planet then
            planet = StoryUtil.FindFriendlyPlanet(objectOwner, true)
        end
        if not planet then
            return
        end
        SpawnList({object}, planet, objectOwner, true, false)
    end
end

function UnitUtil.DespawnList(despawn_list)
    for _, object in pairs(despawn_list) do
		local checkObject = Find_All_Objects_Of_Type(object)
		for i, unit in pairs(checkObject) do
			unit.Despawn()
		end
    end
end

function UnitUtil.DespawnCompany(company)
    local plot = Get_Story_Plot("Conquests\\Player_Agnostic_Plot.xml")
    local event = plot.Get_Event("Template_Company_Remove")
	event.Set_Reward_Parameter(0, company)
	Story_Event("REMOVE_UNIT")
end

function UnitUtil.SetBuildable(player, unitType, state)
    local player_name = string.upper(player.Get_Faction_Name())
    local plot = Get_Story_Plot("Conquests\\Factional_Buildable_"..player_name..".xml")
    if not plot then
        return
    end

    local tag = "ENABLE_BUILDABLE_"..player_name
    if state == false then
        tag = "DISABLE_BUILDABLE_"..player_name
    end

    local event = plot.Get_Event(tag)
    if not event then
        return
    end

    event.Set_Reward_Parameter(0, unitType)
    Story_Event(tag)
end

return UnitUtil
