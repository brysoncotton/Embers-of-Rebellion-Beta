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
--*       File:              ProductionListener.lua                                                *
--*       File Created:      Tuesday, 17th March 2020 06:51                                        *
--*       Author:            [TR] Pox                                                              *
--*       Last Modified:     Wednesday, 18th March 2020 01:31                                      *
--*       Modified By:       [TR] Pox                                                              *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("PGStateMachine")
require("PGSpawnUnits")
require("deepcore/std/class")
require("deepcore/crossplot/crossplot")

---@class ProductionListener
ProductionListener = class()

---@param production_finished_event ProductionFinishedEvent
function ProductionListener:new(production_finished_event)
    self.on_production_finished_actions = {}
    self.number_of_listeners = 0

    -- add listeners for object types (upper case!) you want to run when they're being constructed here
    --self:put_listener("YOUR_OBJECT_TYPE", self.object_type_listener_function)
	self:put_listener("EXECUTOR_STAR_DREADNOUGHT", self.generic_executor_constructed)

    production_finished_event:attach_listener(self.on_production_finished, self)
end

function ProductionListener:put_listener(object_type_name, listener_func)
    --Logger:trace("entering ProductionListener:put_listener")
    self.on_production_finished_actions[object_type_name] = listener_func

    if not self.on_production_finished_actions[object_type_name] then
        return
    end

    self.number_of_listeners = self.number_of_listeners + 1
end

function ProductionListener:remove_listener(object_type_name)
    --Logger:trace("entering ProductionListener:remove_listener")
    if not self.on_production_finished_actions[object_type_name] then
        return
    end

    self.on_production_finished_actions[object_type_name] = nil
    self.number_of_listeners = self.number_of_listeners - 1
end

---@param planet Planet
---@param object_type_name string
function ProductionListener:on_production_finished(planet, object_type_name)
    --Logger:trace("entering ProductionListener:on_production_finished")
    local listener_func = self.on_production_finished_actions[object_type_name]
    if not listener_func then
        return
    end

    listener_func(self, planet, object_type_name)

    if self.number_of_listeners == 0 then
        self.on_production_finished:detach_listener(self.on_production_finished)
    end
end

---@param planet Planet
---@param object_type_name string
function ProductionListener:object_type_listener_function(planet, object_type_name)
    --Logger:trace("entering ProductionListener:object_type_listener_function")
    -- do the things you want for that type here

    -- call this if you want to stop listening to construction events of that type
    self:remove_listener(object_type_name)
end

function ProductionListener:generic_executor_constructed(planet, object_type_name)
    --Logger:trace("entering ProductionListener:generic_executor_constructed")
	local NH_OK = GlobalValue.Get("NIGHT_HAMMER_BUILD_ENABLED")
	if NH_OK == nil then
		self:remove_listener(object_type_name)
	else
		local dummy_table = Find_All_Objects_Of_Type(object_type_name)
		for i, unit in pairs(dummy_table) do
			if unit.Get_Owner() == Find_Player("Eriadu_Authority") then
				spawn_list_NH = {"Cronus_Night_Hammer"}
				SpawnList(spawn_list_NH, unit.Get_Planet_Location(), Find_Player("Eriadu_Authority"), true, false)
				unit.Despawn()
				self:remove_listener(object_type_name)
				
				local plot = Get_Story_Plot("Conquests\\Night_Hammer_Build.XML")
				if Find_Player("Eriadu_Authority").Is_Human() then
					Story_Event("BUILD_NIGHT_HAMMER")
				end
				break
			end
		end
	end
	--crossplot:publish("generic-executor-constructed", planet:get_name())
end
