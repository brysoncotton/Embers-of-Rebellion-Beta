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
--*   @Date:                2017-10-04T10:32:23+02:00
--*   @Project:             Imperial Civil War
--*   @Filename:            TurnStation.lua
--*   @Last modified by:    Pox
--*   @Last modified time:  2017-12-27T04:40:54+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************



require("PGBase")

TurnStation = {}

TurnStation.isActive = true

function TurnStation:Init(globals)
  if Get_Game_Mode() ~= "Space" then
    self.isActive = false
  end
  Object.Override_Max_Speed(0.0)
end

function TurnStation:Update(globals)
  if Object.Is_Ability_Ready("WEAKEN_ENEMY") then
    self.onCooldown = false
  end

  if not self.onCooldown then
    if not Object.Is_Ability_Ready("WEAKEN_ENEMY") then
      local turnMarker = Find_Nearest(Object, "Microjump_Marker")
      if TestValid(turnMarker) then
        self.onCooldown = true
        local neutral = Find_Player("Neutral")
        local privateTurnMarker = Spawn_Unit(Find_Object_Type("Private_Microjump_Marker"), turnMarker.Get_Position(), neutral)[1]
        turnMarker.Despawn()

        if not TestValid(privateTurnMarker) then
          return
        end

        privateTurnMarker.Set_Selectable(false)
        Object.Override_Max_Speed(0.00001)
        Object.Set_Selectable(false)
        BlockOnCommand(Object.Turn_To_Face(privateTurnMarker), -1)

        if TestValid(privateTurnMarker) then
          privateTurnMarker.Despawn()
        end

        Object.Set_Selectable(true)
        Object.Override_Max_Speed(0.0)
        Object.Reset_Ability_Counter()
      end
    end
  end
end


return TurnStation
