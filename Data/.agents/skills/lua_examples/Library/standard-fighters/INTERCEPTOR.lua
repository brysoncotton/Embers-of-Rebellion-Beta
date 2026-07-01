require("StandardFighterFunctions")

return {
	Evaluate_Fighters = function(native,suffix,owner,alias,techLevel,regime,flags,is_main_empire)		
		local fighter = "CLOAKSHAPE_STOCK_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
		end
		
		local simpletypes = {
			CIS = "VULTURE_BROWN_SQUADRON"
		}
		
		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		if owner == "HUTT_CARTELS" or alias == "HUTT_CARTELS" then
			if Get_Fighter_Research("Scyk") then
				fighter = "SCYK_FIGHTER_SQUADRON"
			elseif Check_Flags(flags,"INTERCEPTOR_AB_INVERT") then
				fighter = "MORNINGSTAR_B_SQUADRON"
			else
				fighter = "MORNINGSTAR_A_SQUADRON"
			end
		end
		
		if (owner == "SECTOR_FORCES" or alias == "SECTOR_FORCES") then
			if Check_Flags(flags,"SECTOR_TORRENT") then
				alias = "EMPIRE"
			end
		end
		
		if owner == "EMPIRE" or alias == "EMPIRE" then
			if techLevel > 2 and Check_Flags(flags,"CLONE_Z95") then
				fighter = "CLONE_Z95_HEADHUNTER_SQUADRON"
			elseif techLevel > 4 and Check_Flags(flags,"TIE_POD") then
				fighter = "TIE_POD_SQUADRON"
			elseif techLevel >= 4 and not Check_Flags(flags,"TORRENTKEEP") then
				if TestValid(Find_First_Object("EMPEROR_PALPATINE")) or TestValid(Find_First_Object("SATE_PESTAGE")) or TestValid(Find_First_Object("MON_MOTHMA")) then
					fighter = "NIMBUS_V_WING_ELITE_GUARD_SQUADRON"
				else
					if Check_Flags(flags,"V_WING_MISSILE") then
						fighter = "NIMBUS_V_WING_MISSILE_SQUADRON"
					else
						fighter = "CLONE_NIMBUS_V_WING_SQUADRON"
					end
				end
			elseif techLevel >= 2 and not Check_Flags(flags,"KDYFIGHTERS") then
				fighter = "TORRENT_SQUADRON" 
			end
			--Else stock cloakshape
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