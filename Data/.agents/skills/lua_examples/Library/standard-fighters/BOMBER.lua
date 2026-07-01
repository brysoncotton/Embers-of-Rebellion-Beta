require("StandardFighterFunctions")

return {
	Evaluate_Fighters = function(native,suffix,owner,alias,techLevel,regime,flags,is_main_empire)		
		local fighter = "2_WARPOD_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
		end
		
		local simpletypes = {
			CIS = "ADVANCED_ESTAP_BROWN_SQUADRON"
		}
		
		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		if owner == "EMPIRE" or alias == "EMPIRE" then
			if techLevel >= 2 and not Get_Fighter_Research("RepublicWarpods") and not Check_Flags(flags,"PDF_BOMBER") then
				fighter = "CLONE_BTLB_Y_WING_SQUADRON"
			end
		end
		
		if owner == "REBEL" then
			local paint = GlobalValue.Get("CIS_SKIN")
			if (paint == 1 and techLevel >= 2) or (paint == 3 and GameRandom.Free_Random(0,1) > 0) then
				fighter = "ADVANCED_ESTAP_SQUADRON"
			end
		end
		
		if owner == "HUTT_CARTELS" then
			if Get_Fighter_Research("KimoKrayt") then
				fighter = "KIMOGILA_SQUADRON"
			else
				fighter = "MORNINGSTAR_C_SQUADRON"
			end
		end
		
		if suffix then
			fighter = fighter .. suffix
		end
		return fighter
	end
}