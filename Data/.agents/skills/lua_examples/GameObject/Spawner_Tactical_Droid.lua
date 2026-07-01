--******************************************************************************
--     _______ __
--    |_     _|  |--.----.---.-.--.--.--.-----.-----.
--      |   | |     |   _|  _  |  |  |  |     |__ --|
--      |___| |__|__|__| |___._|________|__|__|_____|
--     ______
--    |   __ \.-----.--.--.-----.-----.-----.-----.
--    |      <|  -__|  |  |  -__|     |  _  |  -__|
--    |___|__||_____|\___/|_____|__|__|___  |_____|
--                                    |_____|
--*   @Author:              [TR]Pox
--*   @Date:                2018-03-20T01:27:01+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            Spawner_Tactical_Droid.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2018-03-26T09:58:14+02:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

require("MinorHeroSpawner")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    Define_State("State_Init", State_Init);
end


function State_Init(message)
    if message == OnEnter then
		space_IV_list = {"Commander_Tier_IV_Recusant_Dreadnought", {"Commander_Tier_IV_Bulwark_II", "Bulwark_II"}, "Commander_Tier_IV_Lucrehulk_Bulk_Cruiser"}
		space_III_list = {"Commander_Tier_III_Providence_Destroyer", "Commander_Tier_III_Providence_Carrier", {"Commander_Tier_III_Bulwark_I_CIS", "Bulwark_I"}, {"Commander_Tier_III_Bulwark_I_TU", "Bulwark_I"}}
		space_II_list = {"Commander_Tier_II_Munificent_C3", "Commander_Tier_II_Recusant_Light_Destroyer", "Commander_Tier_II_Lucrehulk_Core_Destroyer"}
		space_I_list = {"Commander_Tier_I_C9979_Carrier", "Commander_Tier_I_CIS_PDF_DHC", "Commander_Tier_I_CIS_DHC"}
		land_IV_list = {"Commander_Tier_IV_Defoliator_Company", "Commander_Tier_IV_Super_Tank_Company", "Commander_Tier_IV_MTT_Company","Commander_Tier_IV_MTT_CIS_Company"}
		land_III_list = {"Commander_Tier_III_GAT_CIS_Company", "Commander_Tier_III_Persuader_Command_Company", "Commander_Tier_III_AAT_Company", "Commander_Tier_III_AAT_CIS_Company"}
		land_II_list  = {"Commander_Tier_II_T_Series_Tectical_Droid_Blue_Company", "Commander_Tier_II_T_Series_Tectical_Droid_Green_Company", "Commander_Tier_II_T_Series_Tectical_Droid_Brown_Company", "Commander_Tier_II_STAP_CIS_Company"}
		land_I_list  = {"Commander_Tier_I_OOM_Security_Company", "Commander_Tier_I_Elite_Guard_BX_Commando_Company"}
		Register_Timer(CadetLoop, 0, {Object, true, space_I_list, space_II_list, space_III_list, space_IV_list, land_I_list, land_II_list, land_III_list, land_IV_list, {}, {}})
    end
end