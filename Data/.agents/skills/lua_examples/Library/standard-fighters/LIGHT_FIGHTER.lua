require("StandardFighterFunctions")

return {
	Evaluate_Fighters = function(native,suffix,owner,alias,techLevel,regime,flags,is_main_empire)		
		local fighter = "Z95_HEADHUNTER_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
		end
		
		local simpletypes = {
			CIS = "VULTURE_BROWN_SQUADRON",
			EMPIRE = "PDF_Z95_HEADHUNTER_SQUADRON",
			SECTOR_FORCES = "PDF_Z95_HEADHUNTER_SQUADRON"
		}
		
		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		if owner == "REBEL" then
			local paint = GlobalValue.Get("CIS_SKIN")
			if (paint == 1 and techLevel >= 2) or (paint == 3 and GameRandom.Free_Random(0,1) > 0) then
				fighter = "VULTURE_SQUADRON"
			end
		end
		
		if suffix then
			fighter = fighter .. suffix
		end
		return fighter
	end
}