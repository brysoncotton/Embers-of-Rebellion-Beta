require("deepcore/std/class")
require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")

---@class CreditIncomeMission
CreditIncomeMission = class()

function CreditIncomeMission:new(gc, player)

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
	self.CurrentCreditIncome = nil
	self.TargetCreditIncome = nil	
end

function CreditIncomeMission:update()
	--Logger:trace("entering CreditIncomeMission:update")
	if self.Active == true then
		self.CurrentCreditIncome = GlobalValue.Get("HUMAN_CURRENT_NET_INCOME")
		if self.CurrentCreditIncome >= self.TargetCreditIncome then
			self:Fulfil()
		end
		if self.TimeActive ~= nil then
			self.TimeActive = self.TimeActive - 1
			if self.TimeActive == 0 then
				self:Failed()
			end
		end
	end
end

function CreditIncomeMission:Begin(reward_group, week_start)
	--Logger:trace("entering CreditIncomeMission:Begin")
	if self.Active == true then
		return
	end

	local current_credit_income = GlobalValue.Get("HUMAN_CURRENT_NET_INCOME")

	if current_credit_income > 10000 then
		return
	end

	self.TimeSinceAssigned = 0

	self.RewardGroupTable = reward_group
	self.Dialog = "DIALOG_INTERVENTION_MASTERFILE_"..self.RewardGroupTable.DialogName

	self.TargetCreditIncome = GameRandom.Free_Random(15, 30) * 10 + current_credit_income

	self.Active = true
	
	self.TimerStart = week_start
	self.TimeActive = GameRandom.Free_Random(6, 10)
	self.EndTime = self.TimerStart + self.TimeActive
	self.TimeActive = self.TimeActive + 1

	self.Reward, self.RewardCount, self.RewardError = MissionUtil.SelectReward(self.player, self.RewardGroupTable.RewardName, 1)

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	local event = plot.Get_Event("CreditIncome_Credits_01")
	event.Set_Dialog(self.Dialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_CREDITINCOME_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_CREDITINCOME_TARGET", self.TargetCreditIncome)
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

	local tag = "CREDITINCOME"
	crossplot:publish("MISSION_STARTED", tag)

	Story_Event("CREDITINCOME_ASSIGN")
end

function CreditIncomeMission:Fulfil()
	--Logger:trace("entering CreditIncomeMission:Fulfil")
	local RewardLocation = StoryUtil.FindFriendlyPlanet(self.player)

	if RewardLocation ~= nil then
		for i=1,self.RewardCount do
			SpawnList({self.Reward}, RewardLocation, self.player, true, false)
		end
	else 
		RewardLocation = "(No safe location available; reward not granted)"
	end

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	local event = plot.Get_Event("CreditIncome_Credits_02")
	event.Set_Dialog(self.Dialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_CREDITINCOME_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_CREDITINCOME_TARGET_COMPLETE", self.TargetCreditIncome)
	event.Add_Dialog_Text("TEXT_NONE")

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

	Story_Event("CREDITINCOME_COMPLETE")
end

function CreditIncomeMission:Failed()
	--Logger:trace("entering CreditIncomeMission:Failed")

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	local event = plot.Get_Event("CreditIncome_Credits_04")
	event.Set_Dialog(self.Dialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_CREDITINCOME_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_CREDITINCOME_TARGET_FAILED", self.TargetCreditIncome)
	event.Add_Dialog_Text("TEXT_INTERVENTION_CREDITINCOME_TARGET_CURRENT", self.CurrentCreditIncome)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.TimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.EndTime)

	if self.RewardGroupTable.GroupSupport == "LEGITIMACY" then
		crossplot:publish("INCREASE_LEGITIMACY", self.RewardGroupTable.DialogName, (0 - self.RewardGroupTable.SupportArg))
	elseif self.RewardGroupTable.GroupSupport then
		crossplot:publish("INCREASE_FAVOUR" , self.RewardGroupTable.GroupSupport, (0 - self.RewardGroupTable.SupportArg))
	end

	self:Reset()

	Story_Event("CREDITINCOME_FAILED")
end

function CreditIncomeMission:Reset()
	--Logger:trace("entering CreditIncomeMission:Reset")
	self.Active = false
	self.Dialog = nil
	self.TimerStart = nil
	self.TimeActive = nil
	self.EndTime = nil
	self.Reward = nil
	self.RewardCount = 0
	self.CurrentCreditIncome = nil
	self.TargetCreditIncome = nil

	local tag = "CREDITINCOME"
	crossplot:publish("MISSION_COMPLETE", tag)
end

return CreditIncomeMission