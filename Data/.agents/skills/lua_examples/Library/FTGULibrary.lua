require("eawx-util/StoryUtil")

function Set_Tech()	
	p_newrep = Find_Player("Rebel")
	p_empire = Find_Player("Empire")
	p_hutts = Find_Player("Hutt_Cartels")
	
	if not p_newrep.Is_Human() then
		Story_Event("SET_CIS_TECH")
	end
	
	if not p_empire.Is_Human() then
		Story_Event("SET_REP_TECH")
	end

	if not p_hutts.Is_Human() then
		Story_Event("SET_HUTT_TECH")
	end
	
	return GlobalValue.Get("CURRENT_ERA")
end

function Get_SSDS()
	return {
		{"Mandator_I_Dreadnought", 6},
		{"Mandator_II_Dreadnought",6},
		{"Subjugator",6},
		{"Devastation",6},
		{"Lucrehulk_Battleship",5},
		{"Lucrehulk_Carrier_Control",5},
		{"Lucrehulk_Carrier",5},
		{"Lucrehulk_Auxiliary_Control",4},
		{"Lucrehulk_Auxiliary",4},
		{"Secutor_Star_Destroyer",1},
		{"Tector_Star_Destroyer",1},
		{"Imperator_Star_Destroyer",1},
		{"Maelstrom_Battlecruiser",2},
		{"Procurator_Battlecruiser",2}
	}
end