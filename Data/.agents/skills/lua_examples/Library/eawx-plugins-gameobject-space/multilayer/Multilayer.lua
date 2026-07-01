require("deepcore/std/class")
require("eawx-util/StoryUtil")

MultiLayer = class()

function MultiLayer:new()
    local heights = {"ZLayer_Medium"}

    if Object.Is_Category("Capital") then
        table.insert(heights, "ZLayer_Low1")
        table.insert(heights, "ZLayer_Low2")
        table.insert(heights, "ZLayer_Low3")
    else
        table.insert(heights, "ZLayer_High1")
        table.insert(heights, "ZLayer_High2")
        table.insert(heights, "ZLayer_High3")
    end

    Object.Prevent_All_Fire(true)

    Object.Cancel_Hyperspace()

    Object.Hide(true)
    Object.Hide(true)

    local heightType = Find_Object_Type(heights[GameRandom(1, table.getn(heights))])
    local zLayerDummyList = Spawn_Unit(heightType, Object.Get_Position(), Object.Get_Owner())
    local zLayerDummy = zLayerDummyList[1]
    Object.Teleport(zLayerDummy)

    Object.Cinematic_Hyperspace_In(1)
    zLayerDummy.Despawn()
    Object.Prevent_All_Fire(false)
    Object.Make_Invulnerable(false)
    Object.Prevent_AI_Usage(false)

    if GlobalValue.Get("PATRON_PLAYTHROUGH") then
        local patroninfo = require("PatronList")
        if Object.Get_Owner() == Find_Player("local") then
            if string.find(string.upper(Object.Get_Type().Get_Name()), "PATRON") then
                StoryUtil.ShowScreenText(patroninfo[Object.Get_Type().Get_Name()].custom_name.." has entered the battle", 10, Object.Get_Type())
            end
        end
    end
end

return MultiLayer