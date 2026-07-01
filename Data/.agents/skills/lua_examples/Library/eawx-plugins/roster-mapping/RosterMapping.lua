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
--*       File:              RosterMapping.lua                                                     *
--*       File Created:      Monday, 24th February 2020 02:19                                      *
--*       Author:            [TR] Jorritkarwehr                                                             *
--*       Last Modified:     Friday, 22th April 2024 21:16                                      *
--*       Modified By:       [TR] Jorritkarwehr                                                             *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("deepcore/std/class")

RosterMapping = class()

function RosterMapping:new(gc)
    --galactic_conquest class
    self.gc = gc
    --attach listener to production finished event
    self.gc.Events.GalacticProductionFinished:attach_listener(self.on_production_finished, self)
	self.Mapping = {}
	self.human = Find_Player("local")
	self.needinit = true
end

function RosterMapping:on_production_finished(planet, object_type_name)
    --Logger:trace("entering RosterMapping:on_production_finished")
	if self.needinit then
		self:init_mapping()
		if self.needinit then
			return
		end
	end
	local unitname = self.Mapping[object_type_name]
	if type(unitname) == "table" then
		rando = GameRandom.Free_Random(1, table.getn(unitname))
		unitname = unitname[rando]
	end
    if unitname then
		local owner = planet:get_game_object().Get_Owner()
		if owner == self.human then
			UnitUtil.DespawnCompany(object_type_name)
			local tospawn = Find_Object_Type(unitname)
			if tospawn ~= nil then
				Spawn_Unit(tospawn, planet:get_game_object(), owner)
			end
		end
    end
end

function RosterMapping:init_mapping()
	local sourcelist = GlobalValue.Get("ROSTER_MAPPING_SRC")
	local destlist = GlobalValue.Get("ROSTER_MAPPING_DEST")
	if sourcelist == nil then
		self.gc.Events.GalacticProductionFinished:detach_listener(self.on_production_finished, self)
	else
		self.needinit = false
		for index, source in pairs(sourcelist) do
			self.Mapping[source] = destlist[index]
		end
		GlobalValue.Set("ROSTER_MAPPING_SRC", nil)
		GlobalValue.Set("ROSTER_MAPPING_DEST", nil)
	end
end