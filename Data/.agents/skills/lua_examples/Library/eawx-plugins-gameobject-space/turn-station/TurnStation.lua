require("PGBase")
require("deepcore/std/class")

---@class TurnStation
TurnStation = class()

function TurnStation:new()
    self.isActive = true
    self.onCooldown = false
    Object.Suspend_Locomotor(true)
end

function TurnStation:update()
    if Object.Is_Ability_Ready("WEAKEN_ENEMY") then
        self.onCooldown = false
    end

    if not self.onCooldown then
        if not Object.Is_Ability_Ready("WEAKEN_ENEMY") then
            local turnMarker = Find_Nearest(Object, "Microjump_Marker")
            if TestValid(turnMarker) then
                self.onCooldown = true
                local neutral = Find_Player("Neutral")
                local privateTurnMarker =
                    Spawn_Unit(Find_Object_Type("Private_Microjump_Marker"), turnMarker.Get_Position(), neutral)[1]
                turnMarker.Despawn()

                if not TestValid(privateTurnMarker) then
                    return
                end

                privateTurnMarker.Set_Selectable(false)
                Object.Suspend_Locomotor(false)
                Object.Set_Selectable(false)
                BlockOnCommand(Object.Turn_To_Face(privateTurnMarker), -1)

                if TestValid(privateTurnMarker) then
                    privateTurnMarker.Despawn()
                end

                Object.Set_Selectable(true)
                Object.Suspend_Locomotor(true)
                Object.Reset_Ability_Counter()
            end
        end
    end
end

return TurnStation
