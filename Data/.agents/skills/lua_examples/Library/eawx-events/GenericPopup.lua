require("deepcore/std/class")
require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")
require("deepcore/crossplot/crossplot")

---@class GenericPopup
GenericPopup = class()

function GenericPopup:new(active_planets, event_name, options_table, planet_list, player_list, spawn_list, show_holocron_list, movie_name_list, unlock_list, lock_list, crossplot_event, crossplot_param, header_override)
	--Logger:trace("entering GenericPopup:new")
	self.is_complete = false
	self.is_active = false
	self.plot = Get_Story_Plot("Conquests\\Player_Agnostic_Plot.XML")

	-- Not sure what the planet list is actually for at this point, but calling a specific planet that isn't in the GC will crash, so you need to check against this table for if the planet name is set to true or not.
	self.Active_Planets = active_planets
	self.is_valid = true

	self.HumanPlayer = Find_Player("local")
	self.PlanetsList = planet_list
	self.PlayerList = player_list
	self.SpawnList = spawn_list
	self.HolocronList = show_holocron_list
	self.MovieList = movie_name_list
	self.UnlockList = unlock_list
	self.LockList = lock_list
	self.CrossplotEvent = crossplot_event
	self.CrossplotParam = crossplot_param
	self.OptionsTable = options_table
	self.Story_Tag = event_name
	EventOptionChosenString = ""
	self.HeaderOverride = header_override

	--self.Chained_Event = event_enabled_list

	self:activate()
	-- crossplot:subscribe(self.Story_Tag, self.activate, self)
end

function GenericPopup:activate()
	--Logger:trace("entering GenericPopup:activate")
	if GlobalValue.Get("POPUP_ACTIVE") ~= nil then
		return
	end

	GlobalValue.Set("POPUP_ACTIVE", true)
	StoryUtil.UnlockAllControls()
	if (self.is_complete == false) and (self.is_active == false) then
		self.is_active = true

		self.Hostile_Player = Find_Player("Hostile")

		-- trigger_unit = "Event_Trigger"
		trigger_unit_table = {"Event_Trigger"}
		-- trigger_unit_table[1] = trigger_unit
		body_obj = self.Story_Tag.."_BODY"
		-- body_obj = Find_Object_Type(body_obj_name)
		header_obj = self.Story_Tag.."_HEADER"
		if self.HeaderOverride ~= nil then
			header_obj = self.HeaderOverride
		end
		-- header_obj = Find_Object_Type(header_obj_name)

		option_table = {}

		option_table[1] = header_obj
		option_table[2] = body_obj

		local i = 2

		for _, option in pairs(self.OptionsTable) do

			i = i + 1

			option_obj = self.Story_Tag.."_"..option
			-- option_obj = Find_Object_Type(option_obj_name)
			-- spawned_option_obj = Spawn_Unit(option_obj,self.Spawn_Planet,self.Hostile_Player)
			option_table[i] = option_obj
			--Logger:trace(tostring(option_table[i]))

		end

		local location = StoryUtil.FindFriendlyPlanet(self.HumanPlayer, true)
		if location == nil then
			local allPlanets = FindPlanet.Get_All_Planets()

			local random = 0

			while table.getn(allPlanets) > 0 do
				random = GameRandom.Free_Random(1, table.getn(allPlanets))
				location = allPlanets[random]
				table.remove(allPlanets, random)

				if location.Get_Owner() == Find_Player("Neutral") then
					--Don't pick a space only planet, as that would make hostile conquer it
					local base_level = EvaluatePerception("MaxGroundbaseLevel", self.HumanPlayer, location)
					if base_level > 0 then
						break
					end
				end
			end
		end

		spawned_options = SpawnList(trigger_unit_table, location, self.HumanPlayer)
		spawned_options = SpawnList(option_table, location, self.Hostile_Player)

		-- self.galactic_hero_neutralized_event = gc.Events.GalacticHeroNeutralized
		-- self.galactic_hero_neutralized_event:attach_listener(self.on_galactic_hero_neutralized, self)

		self.HumanPlayer.Give_Money(2) --Ensure you can always pay for the choice; for some reason this costs a minimum of $2

		trigger_unit_fleet = Assemble_Fleet({Find_First_Object("Event_Trigger")})
		trigger_unit_fleet.Activate_Ability()

		self.plot = Get_Story_Plot("Conquests\\Player_Agnostic_Plot.XML")
		local plot = self.plot
		Story_Event("LOCK_EVENT_PICTURE_1")
		Story_Event("LOCK_EVENT_PICTURE_2")
		Story_Event("PAUSE_DURING_EVENT")

		crossplot:subscribe("GALACTIC_HERO_NEUTRALIZED", self.on_galactic_hero_neutralized, self)
	end
end

function GenericPopup:on_galactic_hero_neutralized(hero_type_name)
	--Logger:trace("entering GenericPopup:on_galactic_hero_neutralized")
	if self.is_active ~= true then
		return
	end

	local i = 0

	Find_First_Object(self.Story_Tag.."_BODY").Despawn()
	local header_obj = self.Story_Tag.."_HEADER"
	if self.HeaderOverride ~= nil then
		header_obj = self.HeaderOverride
	end
	Find_First_Object(header_obj).Despawn()

	for _, option in pairs(self.OptionsTable) do

		i = i + 1
		option_obj_name = self.Story_Tag.."_"..option

		if hero_type_name == option_obj_name then
			--Logger:trace("EventOption "..tostring(i))
			string_option_chosen = hero_type_name
			--Logger:trace("EventOptionChosenString "..tostring(string_option_chosen))
			EventOptionChosen = i
		else
			RemovedOption = Find_First_Object(option_obj_name)
			--Logger:trace("Tried to despawn "..option_obj_name)
			if TestValid(RemovedOption) then
				RemovedOption.Despawn()
			end
		end
	end

	self:EventOption(EventOptionChosen)
	GlobalValue.Set("POPUP_ACTIVE", nil)
end

function GenericPopup:EventOption(selected_option)
	--Logger:trace("entering GenericPopup:EventOption "..tostring(selected_option))

	self.show_holocron = EmptyCheck(selected_option, self.HolocronList)
	--Logger:trace("entering GenericPopup:EventOption:Holocron List "..tostring(self.show_holocron))

	self.movie_name = EmptyCheck(selected_option, self.MovieList)
	--Logger:trace("entering GenericPopup:EventOption:Movie List "..tostring(self.movie_name))

	self.Planet_Name = EmptyCheck(selected_option, self.PlanetsList)
	--Logger:trace("entering GenericPopup:EventOption:Planet Name "..tostring(self.Planet_Name))

	self.Start_Text = "TEXT_SPEECH_" .. tostring(self.Story_Tag)

	-- self.HumanPlayer = Find_Player("local")

	self.Unlock_Types = EmptyCheck(selected_option, self.UnlockList)
	--Logger:trace("entering GenericPopup:EventOption:Unlock List "..tostring(self.Unlock_Types))

	self.Lock_Types = EmptyCheck(selected_option, self.LockList)
	--Logger:trace("entering GenericPopup:EventOption:Lock List "..tostring(self.Lock_Types))

	self.Spawn_Types = EmptyCheck(selected_option, self.SpawnList)
	--Logger:trace("entering GenericPopup:EventOption:Spawn List "..tostring(self.Spawn_Types))

	self.ForPlayer = EmptyCheck(selected_option, self.PlayerList)
	--Logger:trace("entering GenericPopup:EventOption:Player List "..tostring(self.ForPlayer))

	if self.Unlock_Types ~= nil then
		for _, unit in pairs(self.Unlock_Types) do
			self.ForPlayer.Unlock_Tech(Find_Object_Type(unit))
		end
	end

	if self.Lock_Types ~= nil then
		for _, unit in pairs(self.Lock_Types) do
			self.ForPlayer.Lock_Tech(Find_Object_Type(unit))
		end
	end

	if self.Planet_Name ~= nil then
		StoryUtil.SpawnAtSafePlanet(self.Planet_Name, self.ForPlayer, self.Active_Planets, self.Spawn_Types)
	end

	if self.CrossplotEvent ~= nil then
		crossplot:publish(self.CrossplotEvent, string_option_chosen, self.CrossplotParam)
	end

	Story_Event("RELOCK_EVENT_BUTTON")

	self.is_active = false

	-- Story_Event("UNPAUSE_AFTER_EVENT")
	--Story_Event("UNLOCK_UNPAUSE")
end

function EmptyCheck(selected_option, selected_list)
	-- Logger:trace("entering EmptyCheck "..tostring(selected_option).." with "..tostring(selected_list))
	if selected_list == nil then
		return nil
	else
		if selected_list[selected_option] ~= nil then
			return selected_list[selected_option]
		else
			return nil
		end
	end
end

-- Fighter_Supremacy = Find_Object_Type("NR_Fighter_Supremacy")
-- Create_Generic_Object (Fighter_Supremacy, Object.Get_Position(), Object.Get_Owner())

return GenericPopup
