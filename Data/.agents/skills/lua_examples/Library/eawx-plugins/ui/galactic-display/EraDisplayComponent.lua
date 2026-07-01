require("deepcore/std/class")
require("eawx-util/StoryUtil")

EraDisplayComponent = class()

function EraDisplayComponent:new(selectedPlanetChangedEvent, year_handler, options_handler)
    self.current_text_id = ""
    self.__needs_update = true
    self.era_header = "Era"
    self.year_handler = year_handler
    self.options_handler = options_handler

    self.enemy = Find_Player("Empire")
    if self.enemy.Is_Human() then
        self.enemy = Find_Player("Rebel")
    end

    selectedPlanetChangedEvent:attach_listener(self.generic_update, self)
end

function EraDisplayComponent:needs_update()
    return self.__needs_update
end

function EraDisplayComponent:render()
    self.__needs_update = false
    StoryUtil.RemoveScreenText(self.era_header)
    StoryUtil.RemoveScreenText(self.current_text_id)

    local difficulty = ""
    local diff_index = EvaluatePerception("DisplayDifficulty", self.enemy)
    if diff_index == 1 then
        difficulty = "Recruit"
    elseif diff_index == 2 then
        difficulty = "Captain"
    else
        difficulty = "Admiral"
    end

    local cruel = ""
    if GlobalValue.Get("CRUEL_ON") == 1 then
        cruel = "Cruel "
    end

    local cheater = ""
    if self.options_handler.cheater_flag == true then
        cheater = " Nerf Herder"
    end

    self.current_text_id = self.year_handler.current_year_text .. " (Era " .. tostring(GlobalValue.Get("CURRENT_ERA")) .. ") - Difficulty: " .. cruel .. difficulty .. cheater

    StoryUtil.ShowScreenText(self.era_header)
    StoryUtil.ShowScreenText(self.current_text_id, -1, nil, nil, false)
end

function EraDisplayComponent:generic_update()
    self.__needs_update = true
end
