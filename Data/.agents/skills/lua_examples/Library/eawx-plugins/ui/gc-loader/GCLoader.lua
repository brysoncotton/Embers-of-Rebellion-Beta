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
--*   @Author:              [TR]Pox <Pox>
--*   @Date:                2018-01-13T11:47:17+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            GCLoader.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2018-03-27T03:41:19+02:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

require("PGSpawnUnits")
require("deepcore/std/class")

---@class GCLoader
GCLoader = class()
function GCLoader:new()

    local all_planets = FindPlanet.Get_All_Planets()

    self.planet_name = nil
    for _, planet in ipairs(all_planets) do
        self.planet_name = planet.Get_Type().Get_Name()
    end
    --Match the order of the index in factions.xml
    liveFactionTable = {
      ["REBEL"] = 0,
      ["EMPIRE"] = 1,
      --["UNDERWORLD"] = 2,
      --["NEUTRAL"] = 3,
      --["HOSTILE"] = 4,
      --["INDEPENDENT_FORCES"] = 5,
      ["HUTT_CARTELS"] = 6,
      ["BANKING_CLAN"] = 7,
      ["COMMERCE_GUILD"] = 8,
      ["TECHNO_UNION"] = 9,
      ["TRADE_FEDERATION"] = 10,
      ["SECTOR_FORCES"] = 11,
      --["MANDALORIANS"] = 12,
  }

    self.faction_index = 0
    self.faction_name = "REBEL"
    for faction, id in pairs(liveFactionTable) do
      if Find_Player(faction).Is_Human() then
        self.faction_index = id
        self.faction_name = faction
        break
      end
    end

    self.chosen_era = nil
    self.era_list = {"2", "3", "4", "5"}
    self.initial_popup = false

    -- if tostring(era).."_"..self.faction_name ~= "2_EMPIRE" then
    --   Handle_Input()
    -- end

    crossplot:subscribe("PROGRESSIVE_START_OPTION", self.Handle_Input, self)

end

function GCLoader:update()
    if self.initial_popup == false and GetCurrentTime() > 3 then
        self.initial_popup = true
        self:Initialize()
    end
end

function GCLoader:Initialize()
    GenericPopup("POPUPEVENT", "PROGRESSIVE_START", self.era_list, { },
      { }, { },
      { }, { },
      { }, { },
      "PROGRESSIVE_START_OPTION")
  end
  
  
  function GCLoader:Handle_Input(choice)
    
    if choice then
        StoryUtil.ShowScreenText(self.planet_name, 5)
        self.chosen_era = string.gsub(choice, "PROGRESSIVE_START_", "")

            self:Load_GC()
      end
   end
  
  function GCLoader:Load_GC()

        self.name = self.planet_name.."_Era_"..self.chosen_era.."_"..self.faction_name    

        --Uncomment this to use old map setup
        --local self.name = self.planet_name.."_"..self.faction_name.."_Era_"..tostring(era)
    
        local difficulty = Find_Player("Empire").Get_Difficulty()
        if self.faction_name == "EMPIRE" then
            difficulty = Find_Player("Rebel").Get_Difficulty()
        end
        local difficulty_index = 1
        if difficulty == "Easy" then
            difficulty_index = 0
        elseif difficulty == "Hard" then
            difficulty_index = 2
        end
        StoryUtil.LoadCampaign(self.name, self.faction_index, difficulty_index)
  
  end

return GCLoader
