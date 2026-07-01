require("deepcore/std/class")
require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")

---@class BuildStructuresSpaceMission
BuildStructuresSpaceMission = class()

function BuildStructuresSpaceMission:new(gc, player)

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
	self.BuildType = nil
	self.BuildAmount = 0
	self.CountInitial = 0
	self.CountCurrent = 0
	self.CountTarget = 0
	self.BuildList = nil

	self.production_finished_event = gc.Events.GalacticProductionFinished
	self.production_finished_event:attach_listener(self.on_construction_finished, self)
end

function BuildStructuresSpaceMission:update()
	--Logger:trace("entering BuildStructuresSpaceMission:update")
	if self.Active == true then
		if self.TimeActive ~= nil then
			self.TimeActive = self.TimeActive - 1
			if self.TimeActive == 0 then
				self:Failed()
			end
		end
	end
end

function BuildStructuresSpaceMission:Begin(reward_group, week_start)
	--Logger:trace("entering BuildStructuresSpaceMission:Begin")
	if self.Active == true then
		return
	end
	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	self.TimeSinceAssigned = 0

	self.RewardGroupTable = reward_group
	self.Dialog = "DIALOG_INTERVENTION_MASTERFILE_"..self.RewardGroupTable.DialogName
	
	self.TimerStart = week_start
	self.TimeActive = GameRandom.Free_Random(7, 13)
	self.EndTime = self.TimerStart + self.TimeActive
	self.TimeActive = self.TimeActive + 1

	self.Reward, self.RewardCount, self.RewardError = MissionUtil.SelectReward(self.player, self.RewardGroupTable.RewardName, 2)

	self.BuildList = "SPACE"

	MasterBuildingTable = require("eawx-plugins/intervention-missions/build-options/BuildOptionTables_"..self.player.Get_Faction_Name())
	if self.RewardGroupTable.GroupSupport then
		local build_list_group = self.BuildList.."_"..self.RewardGroupTable.GroupSupport
		if MasterBuildingTable[build_list_group] ~= nil then
			self.BuildList = build_list_group
		end
	end

	self.BuildType, self.BuildAmount = MissionUtil.SelectBuilding(self.player, self.BuildList)

	local all_instances = Find_All_Objects_Of_Type(self.BuildType, self.player)
	self.CountInitial = table.getn(all_instances)
	if self.CountInitial == nil then
		self.CountInitial = 0
	end
	self.CountCurrent = self.CountInitial
	self.CountTarget = self.CountCurrent + self.BuildAmount

	self:UpdateDisplay()

	self.Active = true

	local tag = "BUILDSTRUCTURESSPACE"
	crossplot:publish("MISSION_STARTED", tag)

	Story_Event("BUILDSTRUCTURESSPACE_ASSIGN")
end

function BuildStructuresSpaceMission:UpdateDisplay()
	--Logger:trace("entering BuildStructuresSpaceMission:UpdateDisplay")
	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	local event = plot.Get_Event("BuildStructuresSpace_01")
	event.Set_Dialog(self.Dialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_BUILDSTRUCTURESSPACE_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_STRUCTURE", Find_Object_Type(self.BuildType))
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_CURRENT", self.CountCurrent)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_NEEDED", self.CountTarget - self.CountCurrent)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_TARGET", self.CountTarget)
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

end

function BuildStructuresSpaceMission:Fulfil()
	--Logger:trace("entering BuildStructuresSpaceMission:Fulfil")
	local RewardLocation = StoryUtil.FindFriendlyPlanet(self.player)

	if RewardLocation ~= nil then
		for i=1,self.RewardCount do
			SpawnList({self.Reward}, RewardLocation, self.player, true, false)
		end
	else 
		RewardLocation = "(No safe location available; reward not granted)"
	end

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	local event = plot.Get_Event("BuildStructuresSpace_02")
	event.Set_Dialog(self.Dialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_BUILDSTRUCTURESSPACE_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_STRUCTURE_COMPLETE", Find_Object_Type(self.BuildType))
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_CURRENT", self.CountCurrent)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_NEEDED", self.CountTarget - self.CountCurrent)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_TARGET", self.CountTarget)
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

	Story_Event("BUILDSTRUCTURESSPACE_COMPLETE")
end

function BuildStructuresSpaceMission:Failed()
	--Logger:trace("entering BuildStructuresSpaceMission:Failed")

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	local event = plot.Get_Event("BuildStructuresSpace_04")
	event.Set_Dialog(self.Dialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_BUILDSTRUCTURESSPACE_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_STRUCTURE_FAILED", Find_Object_Type(self.BuildType))
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_CURRENT", self.CountCurrent)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_NEEDED", self.CountTarget - self.CountCurrent)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY_TARGET", self.CountTarget)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.TimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.EndTime)

	if self.RewardGroupTable.GroupSupport == "LEGITIMACY" then
		crossplot:publish("INCREASE_LEGITIMACY", self.RewardGroupTable.DialogName, (0 - self.RewardGroupTable.SupportArg))
	elseif self.RewardGroupTable.GroupSupport then
		crossplot:publish("INCREASE_FAVOUR" , self.RewardGroupTable.GroupSupport, (0 - self.RewardGroupTable.SupportArg))
	end

	self:Reset()

	Story_Event("BUILDSTRUCTURESSPACE_FAILED")
end

function BuildStructuresSpaceMission:Reset()
	--Logger:trace("entering BuildStructuresSpaceMission:Reset")
	self.Active = false
	self.Dialog = nil
	self.TimerStart = nil
	self.TimeActive = nil
	self.EndTime = nil
	self.Reward = nil
	self.RewardCount = 0
	self.BuildType = nil
	self.BuildAmount = 0
	self.CountInitial = 0
	self.CountCurrent = 0
	self.CountTarget = 0

	local tag = "BUILDSTRUCTURESSPACE"
	crossplot:publish("MISSION_COMPLETE", tag)
end

function BuildStructuresSpaceMission:on_construction_finished(planet, game_object_type_name)
	--Logger:trace("entering BuildStructuresSpaceMission:on_construction_finished")
	if self.Active ~= true or self.BuildType == nil or planet:get_owner() ~= self.player then
		return
	end

	if game_object_type_name ~= Find_Object_Type(self.BuildType).Get_Name() then
		return
	end

	local all_instances = Find_All_Objects_Of_Type(self.BuildType, self.player)
	self.CountCurrent = table.getn(all_instances)
	if self.CountCurrent >= self.CountTarget then 
		self:Fulfil()
	else
		self:UpdateDisplay()
	end
end

return BuildStructuresSpaceMission
