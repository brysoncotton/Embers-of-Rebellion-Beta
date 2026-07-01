require("deepcore/std/class")
require("eawx-plugins/intervention-missions/MissionHandlerHuman")
require("eawx-plugins/intervention-missions/MissionHandlerAI")

---@class MissionManager
MissionManager = class()

function MissionManager:new(gc, id)
	local is_ftgu = false
	
	if id == "FTGU" then
		is_ftgu = true
	end

	local p_cis = Find_Player("Rebel")
	local p_hutts = Find_Player("Hutt_Cartels")
	local p_republic = Find_Player("Empire")
	local p_human = Find_Player("local")

	if p_cis == p_human then
		self.CISMissions = MissionHandlerHuman(gc,p_cis,is_ftgu)
	else
		self.CISMissions = MissionHandlerAI(gc,p_cis)
	end
	
	if p_hutts == p_human then
		self.HuttMissions = MissionHandlerHuman(gc,p_hutts,is_ftgu)
	else
		self.HuttMissions = MissionHandlerAI(gc,p_hutts)
	end
	
	if p_republic == p_human then
		self.RepublicMissions = MissionHandlerHuman(gc,p_republic,is_ftgu)
	else
		self.RepublicMissions = MissionHandlerAI(gc,p_republic)
	end
end

function MissionManager:update()
	--Logger:trace("entering MissionManager:Update")
	self.CISMissions:update()
	self.HuttMissions:update()
	self.RepublicMissions:update()
end

return MissionManager
