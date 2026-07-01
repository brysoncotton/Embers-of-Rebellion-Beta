require("deepcore/std/class")
require("eawx-events/GenericResearch")
require("eawx-events/GenericSwap")
require("eawx-events/GenericConquer")
require("eawx-events/GenericPopup")
require("eawx-util/StoryUtil")

---@class EventManager
EventManager = class()

function EventManager:new(galactic_conquest, human_player, planets)
	self.galactic_conquest = galactic_conquest
	self.human_player = human_player
	self.planets = planets
	self.starting_era = nil

	self.LocationPick = false

	self.LocationType = ""
	self.Shortcut = false
	self.RosterType = ""
	self.EnemyType = ""
	self.StartType = ""

	crossplot:subscribe("START_LOCATION_PICK", self.RosterPick, self)
	crossplot:subscribe("ROSTER_PICK", self.HeroPick, self)
	crossplot:subscribe("HERO_PICK", self.SFPick, self)
	crossplot:subscribe("STARTING_SIZE_PICK", self.PlanetModifierPick, self)
end

function EventManager:update()

	self.current_time = GetCurrentTime()
	if (self.current_time >= 12) and (self.LocationPick == false) then
		self.LocationPick = true
		GenericPopup(StoryUtil.GetSafePlanetTable(),
			"CUSTOM_GC", {"LEARNER_MODE", "PICK_LOCATION", "PICK_ENEMY_LOCATION", "PICK_EVERYWHERE", "ROGUELIKE_FACTIONAL", "ROGUELIKE_ALL"}, { },
			{ }, { },
			{ }, { },
			{ }, { },
			"START_LOCATION_PICK")
	end

end

function EventManager:RosterPick(choice)
	self.LocationType = choice
	if choice == "CUSTOM_GC_LEARNER_MODE" then
		crossplot:publish("ROSTER_PICK", "CUSTOM_GC_STANDARD_ROSTER")
		crossplot:publish("HERO_PICK", "CUSTOM_GC_HERO_DEFAULT")
		crossplot:publish("STARTING_SIZE_PICK", "CUSTOM_GC_SMALL_START")
		crossplot:publish("PLANET_MODIFIER_PICK", "CUSTOM_GC_PLAYER_HALF")
		self.Shortcut = true
	elseif choice == "CUSTOM_GC_ROGUELIKE_FACTIONAL" then
		crossplot:publish("ROSTER_PICK", "CUSTOM_GC_RANDOM_ROSTER")
		crossplot:publish("HERO_PICK", "CUSTOM_GC_HERO_FACTIONAL_RANDOM")
		crossplot:publish("STARTING_SIZE_PICK", "CUSTOM_GC_SMALL_START")
		crossplot:publish("PLANET_MODIFIER_PICK", "CUSTOM_GC_EQUAL")
		self.Shortcut = true
	elseif choice == "CUSTOM_GC_ROGUELIKE_ALL" then
		crossplot:publish("ROSTER_PICK", "CUSTOM_GC_RANDOM_MAPS")
		crossplot:publish("HERO_PICK", "CUSTOM_GC_HERO_ALL_RANDOM")
		crossplot:publish("STARTING_SIZE_PICK", "CUSTOM_GC_SMALL_START")
		crossplot:publish("PLANET_MODIFIER_PICK", "CUSTOM_GC_EQUAL")
		self.Shortcut = true
	else
		GenericPopup(StoryUtil.GetSafePlanetTable(),
			"CUSTOM_GC", {"STANDARD_ROSTER", "CUSTOM_ROSTER_ENABLE", "CUSTOM_ROSTER", "MAPPED_ROSTER", "RANDOM_ROSTER", "RANDOM_MAPS", "LOOTBOX_ROSTER"}, { },
			{ }, { },
			{ }, { },
			{ }, { },
			"ROSTER_PICK")
	end
end

function EventManager:HeroPick(choice)
	if not self.Shortcut then
		self.RosterType = choice
		GenericPopup(StoryUtil.GetSafePlanetTable(),
			"CUSTOM_GC", {"HERO_DEFAULT", "HERO_FACTIONAL", "HERO_ALL", "HERO_FACTIONAL_RANDOM", "HERO_ALL_RANDOM"}, { },
			{ }, { },
			{ }, { },
			{ }, { },
			"HERO_PICK")
	end
end

function EventManager:SFPick(choice)
	if not self.Shortcut then
		self.RosterType = choice
		GenericPopup(StoryUtil.GetSafePlanetTable(),
			"CUSTOM_GC", {"FTGU", "SMALL_START", "FULL_START"}, { },
			{ }, { },
			{ }, { },
			{ }, { },
			"STARTING_SIZE_PICK")
	end
end

function EventManager:PlanetModifierPick(choice)
	if not self.Shortcut and choice ~= "CUSTOM_GC_FTGU" and self.LocationType ~= "CUSTOM_GC_PICK_EVERYWHERE" then
		GenericPopup(StoryUtil.GetSafePlanetTable(),
			"CUSTOM_GC", {"EQUAL", "PLAYER_EXTRA", "PLAYER_HALF", "PLAYER_FTGU_EXTREME", "PLAYER_OBSERVER"}, { },
			{ }, { },
			{ }, { },
			{ }, { },
			"PLANET_MODIFIER_PICK")
	end
end

return EventManager
