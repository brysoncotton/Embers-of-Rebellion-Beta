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
--*   @Date:                2017-11-24T12:45:14+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            RandomEventQueue.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2017-12-21T12:31:56+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************



function MakeRandomEventQueue()
  local RandomEventQueue = {
    events = {},
    currentIndex = 1
  }
  function RandomEventQueue:addEvent(event)
    table.insert(self.events, event)
    event:setCompletedListener(self)
  end

  function RandomEventQueue:beginEvents()
    if table.getn(self.events) > 0 then
      self.events[self.currentIndex]:initialize()
    end
  end

  function RandomEventQueue:onComplete()
    print("Completed")
    if self.currentIndex < table.getn(self.events) then
      self.currentIndex = self.currentIndex + 1
      self.events[self.currentIndex]:initialize()
    end
  end

  function RandomEventQueue:postBattleCleanUp()
    for i, evt in pairs(self.events) do
      evt:cleanUp()
    end
  end

  return RandomEventQueue
end
