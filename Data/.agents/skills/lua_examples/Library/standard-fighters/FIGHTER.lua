require("StandardFighterFunctions")

return {
	Evaluate_Fighters = function(native,suffix,owner,alias,techLevel,regime,flags,is_main_empire)		
		local fighter = "PDF_Z95_HEADHUNTER_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
		end
		
		if (owner == "SECTOR_FORCES" or alias == "SECTOR_FORCES") and not Check_Flags(flags,"NO_TIEFIGHTERS") then
			alias = "EMPIRE"
		end
		
		if owner == "EMPIRE" or alias == "EMPIRE" then
			if techLevel > 3 then
				fighter = "TWIN_ION_ENGINE_STARFIGHTER_SQUADRON"
				local test = Find_First_Object("TRACHTA_VENATOR")
				if TestValid(test) then
					fighter = "TIE_POD_SQUADRON"
				end
			end
		end
		
		if owner == "HUTT_CARTELS" or alias == "HUTT_CARTELS" then
			if Get_Fighter_Research("Dunelizard") then
				fighter = "DUNELIZARD_FIGHTER_SQUADRON"
			else
				fighter = "MORNINGSTAR_B_SQUADRON"
			end
		end
		
		if alias == "CIS" then
			if techLevel > 3 then
				fighter = "MANKVIM_SQUADRON"
			else
				fighter = "NANTEX_SQUADRON"
			end
		end 
		
		if suffix then
			fighter = fighter .. suffix
		end
		return fighter
	end
}