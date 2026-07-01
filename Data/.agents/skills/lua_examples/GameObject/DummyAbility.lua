DummyAbility = {}

DummyAbility.isActive = true
DummyAbility.Id = nil

function DummyAbility:Init(globals)
  if not Object.Get_Owner().Is_Human() or Get_Game_Mode() ~= "Space" then
    self.isActive = false
    return
  end
  local value = GlobalValue.Get("Chaf_Count")
  if not value then
    value = 0
  end
  value = value + 1
  GlobalValue.Set("Chaf_Count", value)
  globals.Id = value
end

function DummyAbility:Update(globals)
--  if globals.Id == 3 then
--    Game_Message("TEXT_CONQUEST_KATANA_BATTLE_BOARDING_START")
--  end
end

return DummyAbility