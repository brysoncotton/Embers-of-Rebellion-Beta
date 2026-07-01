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
--*   @Filename:            Spawner_Anaxes.lua
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
		space_IV_list = {"Commander_Tier_IV_Invincible_Cruiser", "Commander_Tier_IV_Procurator_Battlecruiser", {"Commander_Tier_IV_Imperator_Star_Destroyer", "Imperator_Star_Destroyer"}}
		space_III_list = {"Commander_Tier_III_Acclamator_I_Assault", {"Commander_Tier_III_Venator_Star_Destroyer", "Venator_Star_Destroyer"}, {"Commander_Tier_III_Victory_I_Star_Destroyer", "Victory_I_Star_Destroyer"}, {"Commander_Tier_III_Victory_I_Fleet_Star_Destroyer", "Victory_I_Star_Destroyer"}}
		space_II_list = {{"Commander_Tier_II_Neutron_Star", "Neutron_Star"}, "Commander_Tier_II_Acclamator_I_Carrier", "Commander_Tier_II_Acclamator_I_Supercruiser"}
		space_I_list = {"Commander_Tier_I_Arquitens", "Commander_Tier_I_PDF_DHC", "Commander_Tier_I_Rep_DHC"}
		Register_Timer(CadetLoop, 0, {Object, true, space_I_list, space_II_list, space_III_list,space_IV_list, {}, {}})
    end
end