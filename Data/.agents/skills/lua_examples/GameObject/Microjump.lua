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
--*   @Date:                2017-08-20T21:31:11+02:00
--*   @Project:             Imperial Civil War
--*   @Filename:            Microjump.lua
--*   @Last modified by:    Pox
--*   @Last modified time:  2017-12-27T04:40:36+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************



require("PGBase")

Microjump = {}

Microjump.isActive = true

function Microjump:Init(globals)
  if Get_Game_Mode() ~= "Space" then
    self.isActive = false
    return
  end
end

function Microjump:Update(globals)
  if Object.Is_Ability_Ready("WEAKEN_ENEMY") then
    self.onCooldown = false
  end

  if not self.onCooldown then
    if not Object.Is_Ability_Ready("WEAKEN_ENEMY") then
      local jumpMarker = Find_Nearest(Object, "Microjump_Marker")
      if TestValid(jumpMarker) then
        self.onCooldown = true
        local neutral = Find_Player("Neutral")
        local privateJumpMarker = Spawn_Unit(Find_Object_Type("Private_Microjump_Marker"), jumpMarker.Get_Position(), neutral)[1]
        jumpMarker.Despawn()

        if not TestValid(privateJumpMarker) then
          return
        end

        privateJumpMarker.Highlight(true)
        privateJumpMarker.Set_Selectable(false)
        Object.Set_Selectable(false)
        BlockOnCommand(Object.Turn_To_Face(privateJumpMarker), -1)
        Register_Timer(self.JumpTimer, 3, privateJumpMarker)
        Object.Suspend_Locomotor(true)
        Play_Lightning_Effect("Hyperspace_Lightning_Effect", Object.Get_Bone_Position("root"), privateJumpMarker)

      end
    end
  end
end

function Microjump.JumpTimer(privateMarker)
  Object.Play_SFX_Event("Unit_Ship_Hyperspace_Enter")
  if TestValid(privateMarker) then
    Object.Teleport(privateMarker)
    privateMarker.Highlight(false)
    privateMarker.Despawn()
  end
  Object.Suspend_Locomotor(false)
  Object.Set_Selectable(true)
end

return Microjump
