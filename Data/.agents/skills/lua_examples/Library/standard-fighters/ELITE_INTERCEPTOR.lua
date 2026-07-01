require("StandardFighterFunctions")

return {
	Evaluate_Fighters = function(native,suffix,owner,alias,techLevel,regime,flags,is_main_empire)		
		local fighter = "DELTA6_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
		end
		
		-- Commented out for lack of anything to input
		-- local simpletypes = {
		
		-- }
		
		-- if simpletypes[owner] then
			-- fighter = simpletypes[owner]
		-- elseif simpletypes[alias] then
			-- fighter = simpletypes[alias]
		-- end
		
		if owner == "EMPIRE" or alias == "EMPIRE" then
			if techLevel > 2 then
				fighter = "ETA2_ACTIS_SQUADRON"
			end
		end
		
		if owner == "HUTT_CARTELS" then
			if Get_Fighter_Research("Dunelizard") then
				fighter = "DUNELIZARD_INTERCEPTOR_SQUADRON"
			else
				fighter = "MORNINGSTAR_B_SQUADRON"
			end
		end
		
		if alias == "CIS" then
			if owner == "COMMERCE_GUILD" or owner == "BANKING_CLAN" then
				fighter = "NANTEX_SQUADRON"
			else
				if techLevel > 2 then
					fighter = "TRIFIGHTER_SQUADRON"
				else
					fighter = "SCARAB_SQUADRON"
				end
			end
		end
		
		if suffix then
			fighter = fighter .. suffix
		end
		return fighter
	end
}