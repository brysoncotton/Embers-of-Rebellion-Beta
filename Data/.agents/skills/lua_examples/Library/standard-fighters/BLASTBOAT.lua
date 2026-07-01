require("StandardFighterFunctions")

return {
	Evaluate_Fighters = function(native,suffix,owner,alias,techLevel,regime,flags,is_main_empire)		
		local fighter = "EARLY_SKIPRAY_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
		end
		
		local simpletypes = {
			CIS = "FIRESPRAY_GUNSHIP_SQUADRON",
			MANDALORIANS = "FIRESPRAY_GUNSHIP_SQUADRON"
		}
		
		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		if owner == "HUTT_CARTELS" then
			if Get_Fighter_Research("KimoKrayt") then
				fighter = "KRAYT_GUNSHIP_SQUADRON"
			else
				fighter = "KELL_GUNSHIP_SQUADRON"
			end
		end
		
		if suffix then
			fighter = fighter .. suffix
		end
		return fighter
	end
}