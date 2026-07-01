--**************************************************************************************************
--*    _______ __                                                                                  *
--*   |_     _|  |--.----.---.-.--.--.--.-----.-----.                                              *
--*     |   | |     |   _|  _  |  |  |  |     |__ --|                                              *
--*     |___| |__|__|__| |___._|________|__|__|_____|                                              *
--*    ______                                                                                      *
--*   |   __ \.-----.--.--.-----.-----.-----.-----.                                                *
--*   |      <|  -__|  |  |  -__|     |  _  |  -__|                                                *
--*   |___|__||_____|\___/|_____|__|__|___  |_____|                                                *
--*                                   |_____|                                                      *
--*                                                                                                *
--*                                                                                                *
--*       File:              FighterHeroes.lua                                                     *
--*       File Created:      Monday, 24th February 2020 02:19                                      *
--*       Author:            [TR] Jorritkarwehr                                                    *
--*       Last Modified:     Friday, 9th April 2023 21:16                                          *
--*       Modified By:       [TR] Jorritkarwehr                                                    *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("deepcore/std/class")
require("SetFighterResearch")
require("eawx-util/StoryUtil")
require("eawx-util/UnitUtil")
require("eawx-events/GenericPopup")

FighterHeroes = class()

function FighterHeroes:new(gc)
    --galactic_conquest class
    gc.Events.GalacticProductionFinished:attach_listener(self.on_production_finished, self)
	self.galactic_hero_killed_event = gc.Events.GalacticHeroKilled
    self.galactic_hero_killed_event:attach_listener(self.on_galactic_hero_killed, self)
	heroes = Get_Hero_Entries()
	local human = Find_Player("local")
	inverse_table = {} --create a reverse lookup to go from squadrons to setters for hero deaths
	inverse_ground_table = {} --for hero deaths to setters/indices
	reformers = {}
	for index, entry in pairs(heroes) do
		local inverseid = entry.Hero_Squadron
		if inverseid ~= nil then --Don't fail on ground unit only entries
			if type(inverseid) == "table" then
				for _, squad in pairs(inverseid) do
					inverse_table[squad] = index
				end
			else
				inverse_table[inverseid] = index
			end
		end
		inverseid = entry.GroundCompany
		if inverseid ~= nil then
			if type(inverseid) == "table" then
				for _, squad in pairs(inverseid) do
					inverse_ground_table[squad] = index
				end
			else
				inverse_ground_table[inverseid] = index
			end
			if entry.Enabler then --Generate entries with indexes of the reform objects
				if reformers[entry.Enabler] then
					table.insert(reformers[entry.Enabler],index)
				else
					reformers[entry.Enabler] = {index}
				end
			end
		end
		
		local Ok_to_init = true
		local faction = nil
		if entry.Faction ~= nil then
			faction = Find_Player(entry.Faction)
		else
			if entry.Factions ~= nil then
				faction = Find_Player(entry.Factions[1])
			end
		end
		if entry.NoPlayerInit ~= nil and faction ~= nil then
			if faction == human then
				Ok_to_init = false
			end
		end
		if entry.NoInit == nil and Ok_to_init then
			if not Set_To_First_Extant_Host(index, faction) then
				local squadron = entry.Hero_Squadron
				if type(squadron) == "table" then
					squadron = squadron[1]
				end
				Set_Fighter_Hero(squadron, entry.Options[1].Locations[1]) --Fallback if not host is found, probably because the heroes are spawned in rather than XML placed
			end
		end
	end
	
	crossplot:subscribe("FIGHTER_SELECTED_OPTION", self.FighterPick, self)
	crossplot:subscribe("FIGHTER_SPACE_INDEX_SET", self.SpaceIndex, self)
end

function FighterHeroes:on_production_finished(planet, object_type_name)
    --Logger:trace("entering FighterHeroes:on_production_finished")
	
    local hero_entry = heroes[object_type_name]
	
	if hero_entry ~= nil then
		local Object = Find_First_Object(object_type_name)
		
		if hero_entry.GroundReinforcementPerception then
			if hero_entry.NoSpawnFlag then
				GlobalValue.Set(hero_entry.NoSpawnFlag, nil)
			end
			local rebuilder = Find_Object_Type(object_type_name)
			Object.Get_Owner().Lock_Tech(rebuilder)
		else
			local options = {}
			local no_options = true
			local taken = false
			
			local Squadron = Get_Squadron_Name(hero_entry, object_type_name)
			
			for option, alternates in pairs(hero_entry.Options) do
				for index, obj in pairs(alternates.Locations) do
					checkObject = Find_First_Object(obj)
					if TestValid(checkObject) then
						if checkObject.Get_Owner() == Object.Get_Owner() then
							local currents = Get_Host_Fighters(obj)
							local ok = true
							for _, current in pairs(currents) do
								if not (current == Squadron or inverse_table[current] == nil) then
									ok = false
									taken = true
									break
								end
							end
							if ok then
								table.insert(options,alternates[1])
								no_options = false
							end
						end
					end
				end
			end
			
			if no_options then
				local host = Get_Fighter_Hero(Squadron)
				local mensaje = ""
				if taken then
					mensaje = "Host(s) already have a fighter assigned."
				else
					mensaje = "No assignment options available."
				end
				if host == nil then
					StoryUtil.ShowScreenText(mensaje, 5, nil, {r = 244, g = 0, b = 0})
				else
					StoryUtil.ShowScreenText(mensaje .. " Currently assigned to %s.", 5, host, {r = 244, g = 0, b = 0})
				end
			else
				table.insert(options,"CANCEL")
			
				GenericPopup(StoryUtil.GetSafePlanetTable(),
						"FIGHTER_SELECTOR", options, { },
						{ }, { },
						{ }, { },
						{ }, { },
						"FIGHTER_SELECTED_OPTION", object_type_name, hero_entry.PopupHeader
						)
			end
		end
		Object.Despawn()
	end
	
	local reformer = reformers[object_type_name]
	
	if reformer ~= nil then
		local Object = Find_First_Object(object_type_name)
		
		local rebuilder = Find_Object_Type(object_type_name)
		Object.Get_Owner().Lock_Tech(rebuilder)
		--Add global variable to reformers list and clear here instead of enable the setter if there needs to be a rebuildable ground form that does not disrupt space
		for _, setter in pairs(reformer) do
			UnitUtil.SetBuildable(Object.Get_Owner(), setter, true)
		end
		Object.Despawn()
	end
	
	local upgrade = Get_Hero_Upgrade(object_type_name)
	if upgrade ~= nil then
		Set_Fighter_Hero_Index(upgrade.Setter,upgrade.NewSquadron)
		Find_First_Object(object_type_name).Despawn()
	end
end

function FighterHeroes:FighterPick(choice, library)
	local hero_entry = heroes[library]
	
	local tag = string.gsub(choice, "FIGHTER_SELECTOR_", "")
	
	if hero_entry ~= nil then
		local Squadron = Get_Squadron_Name(hero_entry, library)
		if tag == "CANCEL" then
			local host = Get_Fighter_Hero(Squadron)
			if host == nil then
				StoryUtil.ShowScreenText("Not currently assigned.", 5)
			else
				Clear_Fighter_Hero(Squadron)
				StoryUtil.ShowScreenText("Cleared from assignment to %s.", 5, host)
			end
		else
			for option, alternates in pairs(hero_entry.Options) do
				if alternates[1] == tag then
					for index, obj in pairs(alternates.Locations) do
						checkObject = Find_First_Object(obj)
						if TestValid(checkObject) then
							Set_Fighter_Hero(Squadron,obj)
							StoryUtil.ShowScreenText("Assigned to %s", 5, obj)
						end
					end
				end
			end
		end
	end

end

function FighterHeroes:on_galactic_hero_killed(hero_name, owner)
	ownerfaction = Find_Player(owner)
	human = ownerfaction.Is_Human()
	if not human then
		local assigned = Get_Host_Fighters(hero_name)
		if assigned ~= nil then
			for _, squad in pairs(assigned) do
				local setter = inverse_table[squad]
				if setter ~= nil then
					Set_To_First_Extant_Host(setter,ownerfaction)
				end
			end
		end
	end
	local libraryid = inverse_ground_table[hero_name]
	if libraryid ~= nil then
		local entry = heroes[libraryid]
		if entry ~= nil then
			if entry.Hero_Squadron then --Rogue style
				if entry.NoSpawnFlag then 
					GlobalValue.Set(entry.NoSpawnFlag, true)
				end
				if entry.Enabler then 
					local reformer = reformers[entry.Enabler]
					if reformer ~= nil then
						local rebuilder = Find_Object_Type(entry.Enabler)
						if rebuilder ~= nil then
							if human then
								ownerfaction.Unlock_Tech(rebuilder)
								if not entry.NoSpawnFlag then 
									for _, setter in pairs(reformer) do
										UnitUtil.SetBuildable(ownerfaction, setter, false)
									end
									if type(entry.Hero_Squadron) == "table" then
										for _, squad in pairs(entry.Hero_Squadron) do
											Clear_Fighter_Hero(squad)
										end
									else
										Clear_Fighter_Hero(entry.Hero_Squadron)
									end
								end
							else
								local cost = rebuilder.Get_Build_Cost()
								ownerfaction.Give_Money(-cost)
							end
						end
					end
				end
			elseif entry.GroundReinforcementPerception then --Brashin style
				if entry.EnablementFlag then
					if GlobalValue.Get(entry.EnablementFlag) ~= true then
						return
					end
				end
				local rebuilder = Find_Object_Type(libraryid)
				if rebuilder ~= nil then
					if human then
						ownerfaction.Unlock_Tech(rebuilder)
					else
						local cost = rebuilder.Get_Build_Cost()
						ownerfaction.Give_Money(-cost)
					end
				end
				if entry.NoSpawnFlag then
					GlobalValue.Set(entry.NoSpawnFlag, true)
				end
			end
			if human and entry.DeathMessage then
				StoryUtil.ShowScreenText(entry.DeathMessage, 5, nil, {r = 244, g = 244, b = 0})
			end
		end
	end
end