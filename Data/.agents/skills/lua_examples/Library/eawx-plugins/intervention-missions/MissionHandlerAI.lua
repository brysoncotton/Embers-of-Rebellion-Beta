require("deepcore/std/class")
require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")
CONSTANTS = ModContentLoader.get("GameConstants")

---@class MissionHandlerAI
MissionHandlerAI = class()

function MissionHandlerAI:new(gc,player)
	self.player = player

	self.potential_targets = {}

	self.TimeSinceAssigned = 0

	self.era = GlobalValue.Get("CURRENT_ERA")

	FactionTable = require("eawx-plugins/intervention-missions/factions/FactionTables_"..player.Get_Faction_Name())
	self.BaseRewardGroups = FactionTable.RewardGroups
	self.EligibleRewardGroups = {}
	self.RewardGroupDetails = FactionTable.RewardGroupDetails

	self.enemy_player = Find_Player("Empire")
	if Find_Player("Empire").Is_Human() then
		self.enemy_player = Find_Player("Rebel")
	end
end

function MissionHandlerAI:update()
	--Logger:trace("entering MissionHandlerAI:Update")
	if EvaluatePerception("Planet_Ownership", self.player) == 0 then
		return
	end

	self.TimeSinceAssigned = self.TimeSinceAssigned + 1

	local frequency = 5
	local difficulty = self.enemy_player.Get_Difficulty()

	if difficulty == "Easy" then
		frequency = 6
	elseif difficulty == "Hard" then
		frequency = 4
	end

	if GlobalValue.Get("CRUEL_ON") == 1 then
		frequency = frequency - 1
	end

	if self.TimeSinceAssigned >= frequency then
		self:SpawnAIReward()
	end
end

function MissionHandlerAI:GetEligibleRewardGroups()
	self.EligibleRewardGroups = {}

	for RewardGroupName,DetailTable in pairs(self.RewardGroupDetails) do
		if DetailTable.SupportArg ~= nil then
			for _,v in pairs(CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL) do
				if RewardGroupName == v then
					if EvaluatePerception("Planet_Ownership", Find_Player(RewardGroupName)) > 0 then
						table.insert(self.EligibleRewardGroups,RewardGroupName)
					end
					break
				end
			end
		end
	end

	if table.getn(self.EligibleRewardGroups) == 0 then
		self.EligibleRewardGroups = self.BaseRewardGroups
	end
end

function MissionHandlerAI:SpawnAIReward()
	--Logger:trace("entering MissionHandlerAI:SpawnAIReward")

	self:GetEligibleRewardGroups()

	self.TimeSinceAssigned = 0

	local RewardGroupIndex = GameRandom.Free_Random(1, table.getn(self.EligibleRewardGroups))
	local RewardGroup = self.EligibleRewardGroups[RewardGroupIndex]
	local RewardGroupSupportedName = self.RewardGroupDetails[RewardGroup].GroupSupport

	local RewardGroupSupportArg = self.RewardGroupDetails[RewardGroup].SupportArg
	local Reward = nil
	local RewardCount = 0
	local RewardLocation = nil

	Reward, RewardCount = MissionUtil.SelectReward(self.player, ""..self.RewardGroupDetails[RewardGroup].RewardName, GameRandom.Free_Random(1, 3))

	RewardLocation = StoryUtil.FindFriendlyPlanet(self.player)

	if RewardLocation == nil then
		return
	end

	for i=1,RewardCount do
		SpawnList({Reward}, RewardLocation, self.player, true, false)
	end

	if RewardGroupSupportedName == "LEGITIMACY" then
		crossplot:publish("INCREASE_LEGITIMACY", self.RewardGroupDetails[RewardGroup].DialogName, RewardGroupSupportArg)
	elseif RewardGroupSupportArg ~= nil then
		crossplot:publish("INCREASE_FAVOUR", RewardGroupSupportedName, RewardGroupSupportArg)
	end
end

return MissionHandlerAI
