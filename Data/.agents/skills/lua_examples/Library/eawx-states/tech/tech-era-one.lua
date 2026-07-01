require("eawx-util/UnitUtil")
require("PGStoryMode")
require("PGSpawnUnits")
require("SetFighterResearch")

return {
    on_enter = function(self, state_context)
        self.entry_time = GetCurrentTime()
        Set_Fighter_Research("RepublicWarpods")

        if self.entry_time <= 5 then
            UnitUtil.SetLockList("EMPIRE", {
                "Charger_C70",
                "Pelta_Assault",
                "Pelta_Support",
                "Arquitens",
                "Acclamator_I_Carrier",
                "Acclamator_II",
                "Acclamator_I_Assault",
                "Republic_74Z_Bike_Company",
                "Republic_AT_RT_Company",
                "AT_XT_Company",
                "Republic_TX130S_Company",
                "AV7_Company",
                "Republic_LAAT_Company",
                "UT_AT_Speeder_Company",
                "Republic_AT_TE_Walker_Company",
                "Republic_A5_Juggernaut_Company",
                "Clone_Commando_Company",
                "Clonetrooper_Phase_One_Company",
                "ARC_Phase_One_Company",
                "Republic_74Z_Bike_Company",
                "Republic_BARC_Company",
                "Republic_ISP_Company",
                "Republic_Flashblind_Company",
                "Clonetrooper_Phase_Two_Company",
                "ARC_Phase_Two_Company",
                "HAET_Company",
                "Republic_AT_AP_Walker_Company",
                "AT_OT_Walker_Company"
            }, false)

            UnitUtil.SetLockList("EMPIRE", {
                "Republic_Overracer_Speeder_Bike_Company",
                "Republic_VAAT_Company",
                "Class_C_Frigate",
                "Class_C_Support",
                "CEC_Light_Cruiser",
                "Starbolt",
                "Consular_Refit"
            })

            UnitUtil.SetLockList("REBEL", {
                "Recusant_Light_Destroyer",
                "Providence_Carrier_Destroyer",
                "Lucrehulk_Carrier",
                "Lucrehulk_Battleship",
                "Subjugator",
                "Devastation",
                "CIS_GAT_Company",
                "MAF_Company",
                "Magna_Octuptarra_Company",
                "B2_Droid_Company",
                "BX_Commando_Company",
                "Crab_Droid_Company",
                "HMP_Company",
                "Destroyer_Droid_II_Company",
                "Destroyer_Droid_I_W_Company"
            }, false)

             UnitUtil.SetLockList("REBEL", {
                "Destroyer_Droid_I_P_Company"
            })

            UnitUtil.SetLockList("HUTT_CARTELS", {

            }, false)

             UnitUtil.SetLockList("HUTT_CARTELS", {
                "Consular_Refit"
            })
        end
    end,
    on_update = function(self, state_context)
    end,
    on_exit = function(self, state_context)
    end
}
