require("deepcore/std/class")
require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")

---@class TakePlanetAnyMission
TakePlanetAnyMission = class()

function TakePlanetAnyMission:new(gc, player)

	self.player = player
	self.Dialog = nil
	self.RewardGroupTable = nil

	self.TimeSinceAssigned = 0

	self.Active = false
	self.TimerStart = nil
	self.TimeActive = nil
	self.EndTime = nil
	self.Reward = nil
	self.RewardError = nil
	self.RewardCount = 0
	self.Target = nil

	self.planet_owner_changed_event = gc.Events.PlanetOwnerChanged
	self.planet_owner_changed_event:attach_listener(self.on_planet_owner_changed, self)

end

function TakePlanetAnyMission:update()
	--Logger:trace("entering TakePlanetAnyMission:update")
	if self.Active == true then
		if self.TimeActive ~= nil then
			self.TimeActive = self.TimeActive - 1
			if self.TimeActive == 0 then
				self:Failed()
				self.Active = false
			end
		end
		if self.Target ~= nil and self.Active == true then
			self.Target.Attach_Particle_Effect("Expanding_Fronts_Mission_Particle")
		end
	end
end

function TakePlanetAnyMission:Begin(reward_group, week_start)
	--Logger:trace("entering TakePlanetAnyMission:Begin")
	if self.Active == true then
		self:Reset()
		return
	end

	self.TimeSinceAssigned = 0

	self.RewardGroupTable = reward_group
	self.Dialog = "DIALOG_INTERVENTION_MASTERFILE_"..self.RewardGroupTable.DialogName

	self.TimerStart = week_start
	self.TimeActive = GameRandom.Free_Random(5, 10)
	self.EndTime = self.TimerStart + self.TimeActive
	self.TimeActive = self.TimeActive + 1

	self.Target = StoryUtil.FindTargetPlanet(self.player, true, false, 1, false)
	if self.Target == nil then
		self:Reset()
		return
	end

	self.Reward, self.RewardCount, self.RewardError = MissionUtil.SelectReward(self.player, self.RewardGroupTable.RewardName, 3)

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	local event = plot.Get_Event("TakePlanetAny_Planet_01")
	event.Set_Dialog(self.Dialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", self.Target)
	event.Add_Dialog_Text("TEXT_NONE")

	--Try to turn these into a mission library function after basic testing.
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
	if self.RewardError then
		event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", self.RewardError)
	else
		event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.Reward))
	end
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.RewardCount)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.TimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.EndTime)

	self.Active = true
	
	local tag = "TAKEPLANETANY"
	crossplot:publish("MISSION_STARTED", tag)

	Story_Event("TAKEPLANETANY_ASSIGN")
end

function TakePlanetAnyMission:Fulfil()
	--Logger:trace("entering TakePlanetAnyMission:Fulfil")
	local RewardLocation = StoryUtil.FindFriendlyPlanet(self.player)

	if RewardLocation ~= nil then
		for i=1,self.RewardCount do
			SpawnList({self.Reward}, RewardLocation, self.player, true, false)
		end
	else 
		RewardLocation = "(No safe location available; reward not granted)"
	end

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	local event = plot.Get_Event("TakePlanetAny_Planet_02")
	event.Set_Dialog(self.Dialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", self.Target)
	event.Add_Dialog_Text("TEXT_NONE")

	--Try to turn these into a mission library function after basic testing.
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
	if self.RewardError then
		event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", self.RewardError)
	else
		event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.Reward))
	end
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.RewardCount)
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", RewardLocation)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.TimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.EndTime)

	if self.RewardGroupTable.GroupSupport == "LEGITIMACY" then
		crossplot:publish("INCREASE_LEGITIMACY", self.RewardGroupTable.DialogName, self.RewardGroupTable.SupportArg)
	elseif self.RewardGroupTable.GroupSupport then
		crossplot:publish("INCREASE_FAVOUR", self.RewardGroupTable.GroupSupport, self.RewardGroupTable.SupportArg)
	end

	self:Reset()

	Story_Event("TAKEPLANETANY_COMPLETE")
end

function TakePlanetAnyMission:Failed()
	--Logger:trace("entering TakePlanetAnyMission:Failed")

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	local event = plot.Get_Event("TakePlanetAny_Planet_04")
	event.Set_Dialog(self.Dialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_FAILED", self.Target)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.TimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.EndTime)

	if self.RewardGroupTable.GroupSupport == "LEGITIMACY" then
		crossplot:publish("INCREASE_LEGITIMACY", self.RewardGroupTable.DialogName, (0 - self.RewardGroupTable.SupportArg))
	elseif self.RewardGroupTable.GroupSupport then
		crossplot:publish("INCREASE_FAVOUR" , self.RewardGroupTable.GroupSupport, (0 - self.RewardGroupTable.SupportArg))
	end

	self:Reset()

	Story_Event("TAKEPLANETANY_FAILED")
end

function TakePlanetAnyMission:Reset()
	--Logger:trace("entering TakePlanetAnyMission:Reset")
	self.Active = false
	self.Dialog = nil
	self.TimerStart = nil
	self.TimeActive = nil
	self.EndTime = nil
	self.Reward = nil
	self.RewardCount = 0
	self.Target = nil

	local tag = "TAKEPLANETANY"
	crossplot:publish("MISSION_COMPLETE", tag)
end

function TakePlanetAnyMission:on_planet_owner_changed(planet, new_owner_name, old_owner_name)
	if new_owner_name ~= self.player.Get_Faction_Name() then 
		return
	end
	--Logger:trace("entering TakePlanetAnyMission:on_planet_owner_changed")

	if self.Active == true then
		if planet:get_game_object() == self.Target then
			self:Fulfil()
		end
	end
end

return TakePlanetAnyMission