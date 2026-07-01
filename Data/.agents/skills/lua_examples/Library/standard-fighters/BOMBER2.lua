require("StandardFighterFunctions")

return {
	Evaluate_Fighters = function(native,suffix,owner,alias,techLevel,regime,flags,is_main_empire)		
		local fighter = "H60_TEMPEST_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
		end
		
		-- Commented out because of redundancy, remove comments if new Bomber2 is made to keep H60s for Republic
		-- local simpletypes = {
			-- EMPIRE = "H60_TEMPEST_SQUADRON"
		-- }
		
		-- if simpletypes[owner] then
			-- fighter = simpletypes[owner]
		-- elseif simpletypes[alias] then
			-- fighter = simpletypes[alias]
		-- end
		
		if owner == "HUTT_CARTELS" then
			if Get_Fighter_Research("KimoKrayt") then
				fighter = "KIMOGILA_SQUADRON"
			else
				fighter = "KUSAK_SQUADRON"
			end
		end
		
		if alias == "CIS" then
			if techLevel >= 2 then
				fighter = "BELBULLAB24_SQUADRON"
			else
				fighter = "ADVANCED_ESTAP_BROWN_SQUADRON"
			end
		end 
		
		if suffix then
			fighter = fighter .. suffix
		end
		return fighter
	end
}