require("StandardFighterFunctions")

return {
	Evaluate_Fighters = function(native,suffix,owner,alias,techLevel,regime,flags,is_main_empire)		
		local fighter = "2_WARPOD_SQUADRON"
		
		if techLevel >= 4 and not Get_Fighter_Research("RepublicWarpods") then
			fighter = "BTLS1_Y_WING_SQUADRON"
		end
		
		if Is_Amalgam(owner) then
			alias = native
		end
		
		local simpletypes = {
			CIS = "COYOTE_BOMBER_BROWN_SQUADRON",
		}
		
		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		if owner == "REBEL" then
			local paint = GlobalValue.Get("CIS_SKIN")
			if (paint == 1 and techLevel >= 2) or (paint == 3 and GameRandom.Free_Random(0,1) > 0) then
				fighter = "COYOTE_BOMBER_SQUADRON"
			end
		end
		
		if suffix then
			fighter = fighter .. suffix
		end
		return fighter
	end
}