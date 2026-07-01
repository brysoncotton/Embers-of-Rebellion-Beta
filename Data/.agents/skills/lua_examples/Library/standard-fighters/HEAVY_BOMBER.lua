require("StandardFighterFunctions")

return {
	Evaluate_Fighters = function(native,suffix,owner,alias,techLevel,regime,flags,is_main_empire)		
		local fighter = "SCURRG_H6_PROTOTYPE_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
		end
		
		local simpletypes = {
			CIS = "ADVANCED_ESTAP_BROWN_SQUADRON",
			HUTT_CARTELS = "SCURRG_H6_SQUADRON",
			MANDALORIANS = "FIRESPRAY_BOMBER_SQUADRON"
		}
		
		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		if (owner == "EMPIRE" or alias == "EMPIRE") and techLevel >= 2 then
			fighter = "NTB_630_SQUADRON"
		end 
		
		if suffix then
			fighter = fighter .. suffix
		end
		return fighter
	end
}