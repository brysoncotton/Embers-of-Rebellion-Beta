function Get_Roster_Mapping()
	local mapping = {
		{{"Custom_GC_Light_Infantry","Custom_GC_Light_Infantry2"},{"Republic_Navy_Trooper_Company","Republic_Trooper_Company","COMP_Supporter_Company","B1_Droid_Company","B1_Droid_Marine_Company","B1_Geo_Droid_Company","B1_RC_Droid_Company","Hutt_Guard_Company","Police_Responder_Company","Security_Trooper_Company","PDF_Soldier_Company","Scavenger_Company","Light_Mercenary_Company","CorSec_Trooper_Influence_Company","Backwater_Soldier_Company"}},
		{{"Custom_GC_Heavy_Infantry","Custom_GC_Heavy_Infantry2"},{"Clonetrooper_Phase_One_Company","Clonetrooper_Phase_Two_Company","Clone_Galactic_Marine_Company","Clone_Vehicular_Assault_Company","Clone_Scout_Trooper_Company","Clone_Airborne_Trooper_Company","Special_Tactics_Trooper_Company","Kotas_Militia_Trooper_Company","Republic_Heavy_Trooper_Company","B2_Droid_Company","Neimoidian_Guard_Company","Ailon_Nova_Guard_Influence_Company","Sun_Guard_Influence_Company","Nimbus_Commando_Company","SC_Mandalorian_Soldier_Company","Military_Soldier_Company","Heavy_Scavenger_Company","Mercenary_Company"}},
		{{"Custom_GC_Commando","Custom_GC_Commando2","Custom_GC_Commando3","Custom_GC_Commando4"},{"ARC_Phase_One_Company","ARC_Phase_Two_Company","Clone_Commando_Company","Clone_Jumptrooper_Phase_One_Company","Clone_Jumptrooper_Phase_Two_Company","Clone_Special_Ops_Company","Clone_Flame_Trooper_Company","Clone_Blaze_Trooper_Company","Republic_Heavy_Trooper_Company","Senate_Commando_Company","BX_Commando_Company","Destroyer_Droid_I_P_Company","Destroyer_Droid_I_W_Company","Destroyer_Droid_I_Q_Company","Crab_Droid_Company","Dwarf_Spider_Droid_Company","Destroyer_Droid_II_Company","Skakoan_Combat_Engineer_Company","B2_RP_Droid_Company","Magnaguard_Squad","Gamorrean_Guard_Company","Armored_Hutt_Company","Minor_Shell_Hutt_Company","Antarian_Ranger_Company","SC_Mandalorian_Commando_Company","LR_57_Droid_Company","PDF_Tactical_Unit_Company","Elite_Mercenary_Company","PDF_Force_Cultist_Company","JU9_Juggernaut_Droid_Company","Republic_Jedi_Knight_Company","Dark_Jedi_Company","Nightsister_Sith_Witch_Company","Jedi_Padawan_Company"}},
		{{"Custom_GC_Bike","Custom_GC_Bike2"},{"Republic_Overracer_Speeder_Bike_Company","Overracer_Speeder_Bike_Company","Republic_74Z_Bike_Company","74Z_Bike_Company","Republic_BARC_Company","Republic_SD_6_Droid_Company","SD_5_Hulk_Infantry_Droid_Company","CIS_STAP_Company","STAP_Company","Hutt_Starhawk_Company","Hutt_Airhook_Company","X34_Technical_Company"}},
		
		{{"Custom_GC_Light_Walker"},{"Republic_AT_RT_Company","Republic_Trooper_AT_RT_Company","AT_RT_Company","Espo_Walker_91_Company"}},
		{{"Custom_GC_Light_Vehicle","Custom_GC_Light_Vehicle2","Custom_GC_Light_Vehicle3"},{"Republic_ISP_Company","ISP_Company","Republic_Gian_Company","Gian_Company","Gian_PDF_Company","Gian_Rebel_Company","Republic_ULAV_Company","ULAV_Company","AT_XT_Company","OG9_Company","PAC_Company","CIS_GAT_Company","GAT_Company","Hutt_Bantha_II_Skiff_Company","Hutt_SuperHaul_II_Skiff_Company","Hutt_Personnel_Skiff_IV_Company","Vulture_Land_Company","Bantha_II_Skiff_Company","Espo_Walker_91_Company","Arrow_23_Company","Light_Rakatan_Annihilator_Company"}},
		{{"Custom_GC_Medium_Vehicle","Custom_GC_Medium_Vehicle2"},{"Republic_TX130S_Company","Republic_TX130T_Company","CIS_AAT_Company","AAT_Company","Persuader_Company","Persuader_Assault_Company","WLO5_Tank_Company","Hutt_Pongeeta_Swamp_Speeder_Company","Riot_Hailfire_Company","Riot_Persuader_Company","PDF_AAT_Company","MZ8_Tank_Company","TNT_Company","Heavy_Rakatan_Annihilator_Company"}},
		{{"Custom_GC_Airspeeder"},{"Republic_Gaba18_Company","Republic_Flashblind_Company","Hutt_Atmospheric_Flyer_Company","Storm_Cloud_Car_Influence_Company","Wookiee_Flutter_Company","Skyhopper_Company","Skyhopper_Antivehicle_Company","Skyhopper_Primitive_Company","Skyhopper_Security_Company"}},
		{{"Custom_GC_2PerCompany","Custom_GC_2PerCompany2","Custom_GC_2PerCompany3"},{"AT_OT_Walker_Company","Republic_A5RX_Company","J1_Cannon_Company","Magna_Octuptarra_Company","Hailfire_Company","Terentatek_Company","Sith_War_Behemoth_Company"}},
		{{"Custom_GC_Heavy_Vehicle","Custom_GC_Heavy_Vehicle2","Custom_GC_Heavy_Vehicle3"},{"Republic_AT_TE_Walker_Company","UT_AT_Speeder_Company","Republic_A5_Juggernaut_Company","A5_Juggernaut_Company","Republic_A4_Juggernaut_Company","Republic_A6_Juggernaut_Company","Republic_AT_AP_Walker_Company","RX200_Falchion_Company","CIS_MTT_Company","MTT_Company","CIS_Super_Tank_Company","Super_Tank_Company","Protodeka_Company","Luxury_Barge_Company"}},
		{{"Custom_GC_Gunship","Custom_GC_Gunship2"},{"Republic_LAAT_Company","Republic_VAAT_Company","HAET_Company","CIS_MAF_Company","MAF_Company","HMP_Company","Hutt_VAAT_Company","VAAT_Company","JX30_Company","Gallofree_HTT_Company"}},
		{{"Custom_GC_Artillery"},{"AV7_Company","HAG_Company","CA_Artillery_Company","CIS_Defoliator_Company","Defoliator_Company","MAL_Rocket_Vehicle_Company"}},
		{{"Custom_GC_AA"},{"Republic_UT_AA_Company","HAML_Company","Hutt_AA_Skiff_Company"}},
		
		--Space units here
		{{"Custom_GC_Light_Corvette"},{"Super_Transport_VI_Missile","Super_Transport_VII_Missile","Light_Minstrel_Yacht","LAC","CR90","IPV1","Customs_Corvette","Lupus_Missile_Frigate"}},
		{{"Custom_GC_Heavy_Corvette","Custom_GC_Heavy_Corvette2"},{"IPV1","Interceptor_IV_Frigate","Customs_Corvette","Charger_C70","Lupus_Missile_Frigate","IPV1_Gunboat","Interceptor_II_Frigate","Lancer_Frigate_Prototype","Hardcell","Interceptor_III_Frigate","Consular_Refit","Diamond_Frigate","Sabaoth_Frigate_Spy"}},
		{{"Custom_GC_Superheavy_Corvette","Custom_GC_Superheavy_Corvette2"},{"Consular_Refit","Diamond_Frigate","Sabaoth_Frigate_Spy","Raka_Freighter_Tender","Pelta_Support","DP20","Action_VI_Support","Heavy_Minstrel_Yacht","Sabaoth_Frigate","Hardcell_Tender","Super_Transport_VI"}},
		{{"Custom_GC_FrigateA"},{"Sabaoth_Frigate","Hardcell_Tender","Super_Transport_VI","Kaloth_Battlecruiser","Marauder_Cruiser","Class_C_Support","Pelta_Assault","Geonosian_Cruiser_Influence","Class_C_Frigate"}},
		{{"Custom_GC_FrigateB","Custom_GC_FrigateB2","Custom_GC_FrigateB3"},{"Kaloth_Battlecruiser","Marauder_Cruiser","Class_C_Support","Pelta_Assault","Geonosian_Cruiser_Influence","Class_C_Frigate","Juvard_Frigate","Komrk_Gunship_Group","Citadel_Cruiser_Group","Super_Transport_VII","Galleon","Arquitens","Interceptor_I_Frigate","C9979_Carrier","C9979_Carrier_Subfaction","Hutt_Galleon","CEC_Light_Cruiser","Gamma_ATR_6_Group","Munifex","Sabaoth_Hex_Deployer","Pursuer_Enforcement_Ship_Group","Gozanti_Cruiser_Group"}},
		{{"Custom_GC_FrigateC","Custom_GC_FrigateC2"},{"C9979_Carrier","C9979_Carrier_Subfaction","Hutt_Galleon","CEC_Light_Cruiser","Gamma_ATR_6_Group","Munifex","Sabaoth_Hex_Deployer","Pursuer_Enforcement_Ship_Group","Gozanti_Cruiser_Group","Carrack_Cruiser","Carrack_Cruiser_Lasers","Starbolt","Barabbula_Frigate","Ubrikkian_Cruiser_CW","Victory_I_Frigate","Munificent_Transport","Gozanti_Cruiser_Raider_Group","Super_Transport_XI_Missile","Kuari_Princess_Liner","CIS_PDF_DHC","Kossak_Frigate","PDF_DHC"}},
		{{"Custom_GC_FrigateD"},{"Sabaoth_Hex_Deployer","Pursuer_Enforcement_Ship_Group","Gozanti_Cruiser_Group","Carrack_Cruiser","Carrack_Cruiser_Lasers","Starbolt","Barabbula_Frigate","Ubrikkian_Cruiser_CW","Victory_I_Frigate","Munificent_Transport","Gozanti_Cruiser_Raider_Group","Super_Transport_XI_Missile","Kuari_Princess_Liner","CIS_PDF_DHC","Kossak_Frigate","PDF_DHC","Neutron_Star"}},
		{{"Custom_GC_FrigateE"},{"Barabbula_Frigate","Ubrikkian_Cruiser_CW","Victory_I_Frigate","Munificent_Transport","Gozanti_Cruiser_Raider_Group","Super_Transport_XI_Missile","Kuari_Princess_Liner","CIS_PDF_DHC","Kossak_Frigate","PDF_DHC","Neutron_Star","Rep_DHC","Imperial_DHC","Neutron_Star_Mercenary"}},
		{{"Custom_GC_FrigateF"},{"Neutron_Star","Rep_DHC","Imperial_DHC","Neutron_Star_Mercenary","DHC_Gunboat","DHC_Carrier","Munificent_Tender","Gladiator_I","Auxilia","Acclamator_II"}},
		{{"Custom_GC_FrigateG"},{"Munificent_Tender","Gladiator_I","Auxilia","Acclamator_II","Munificent","Munificent_Subfaction","Recusant_Light_Destroyer","Szajin_Cruiser","Liberty_Liner","Tempest_Cruiser","Munificent_C3","Storm_Fleet_Destroyer","Imperial_I_Frigate","Acclamator_I_Assault","Super_Transport_XI"}},
		{{"Custom_GC_FrigateH"},{"Auxilia","Acclamator_II","Munificent","Munificent_Subfaction","Recusant_Light_Destroyer","Szajin_Cruiser","Liberty_Liner","Tempest_Cruiser","Munificent_C3","Storm_Fleet_Destroyer","Imperial_I_Frigate","Acclamator_I_Assault","Super_Transport_XI","Lucrehulk_Core_Destroyer","Munificent_Heavy_Cruiser","Captor","Karagga_Destroyer","Sabaoth_Destroyer"}},
		{{"Custom_GC_Heavy_Frigate","Custom_GC_Heavy_Frigate2","Custom_GC_Heavy_Frigate3","Custom_GC_Heavy_Frigate4"},{"Szajin_Cruiser","Liberty_Liner","Tempest_Cruiser","Munificent_C3","Storm_Fleet_Destroyer","Imperial_I_Frigate","Acclamator_I_Assault","Super_Transport_XI","Lucrehulk_Core_Destroyer","Munificent_Heavy_Cruiser","Captor","Karagga_Destroyer","Sabaoth_Destroyer","Victory_I_Star_Destroyer","Providence_Destroyer","Acclamator_I_Carrier","Acclamator_I_Supercruiser","Space_ARC_Cruiser","Victory_I_Fleet_Star_Destroyer","Refit_Venator_Star_Destroyer","Victory_II_Star_Destroyer","DH_Omni","Providence_Carrier","Bulwark_I"}},
		{{"Custom_GC_Superheavy_Frigate"},{"Refit_Venator_Star_Destroyer","Providence_Carrier","Bulwark_I","Providence_Carrier_Destroyer","Venator_Star_Destroyer","Super_Transport_XI_Modified","Recusant_Dreadnought"}},
		{{"Custom_GC_CapitalShip"},{"Recusant_Dreadnought","Vontor_Destroyer","Home_One_Type_Liner","Acclamator_Destroyer","Invincible_Cruiser","Bulwark_II","Imperator_Star_Destroyer_Assault","Home_One_Type_Defender","Acclamator_Battleship","Imperator_Star_Destroyer","Tector_Star_Destroyer","Maelstrom_Battlecruiser"}},
		{{"Custom_GC_CapitalShipB"},{"Invincible_Cruiser","Bulwark_II","Imperator_Star_Destroyer_Assault","Home_One_Type_Defender","Acclamator_Battleship","Imperator_Star_Destroyer","Tector_Star_Destroyer","Maelstrom_Battlecruiser","Voracious_Carrier","Procurator_Battlecruiser","Providence_Dreadnought","Lucrehulk_Bulk_Cruiser"}},
		{{"Custom_GC_Light_Battlecruiser"},{"Providence_Dreadnought","Lucrehulk_Bulk_Cruiser","Secutor_Star_Destroyer","Lucrehulk_Auxiliary","Lucrehulk_Auxiliary_Control"}},
		{{"Custom_GC_Heavy_Battlecruiser","Custom_GC_Heavy_Battlecruiser2"},{"Tagge_Battlecruiser","Praetor_I_Battlecruiser","Lucrehulk_Carrier_Control","Lucrehulk_Carrier","DorBulla_Warship","Lucrehulk_Battleship"}},
	}
	
	return mapping
end

function Get_Excluded_Heroes()
	local exclusions = {
		["VENATOR_TRANQUILITY"] = true,
	}
	
	return exclusions
end

function Get_Planet_Restrictions()
	local restrictions = {
		["Storm_Fleet_Destroyer"] = {"Kuat"},
		["Destroyer_Droid_II_Company"] = {"Hypori"},
	}
	
	return restrictions
end

--The first location in an enemy entry defines the capital
--SmallHero is a list of heroes for each era. Missing entries will default to era 1. Instead of lists, a number denoting an era to copy may be supplied
function Get_FTGU_Dummies()
	local dummies = {
		["Rebel"] = {
			DummyUnit = "Custom_GC_CIS",
			PlayerStart = {"Serenno"},
			Capital = "CIS_Capital",
			Perception = "Is_Connected_To_CIS",
			SmallHero = {
				{"Nute_Gunray_Team", "Dooku_Team", "TF1726_Munificent","Cavik_Toth_Reaver"},
				{"Argente_Team", "SevRance_Team", "Vetlya_Core_Destroyer","Trench_Invincible"},
				{"Nute_Gunray_Team", "Dooku_Team", "TF1726_Munificent","Trench_Invincible"},
				{"Nute_Gunray_Team", "Sora_Bulq_Team", "TF1726_Munificent","Dua_Ningo_Unrepentant"},
				{"Argente_Team", "Dooku_Team", "Dellso_Providence","Trench_Invincible"},
			},
			RosterUnits = {
				"Lupus_Missile_Frigate","Hardcell","Diamond_Frigate","Sabaoth_Frigate","Hardcell_Tender","Marauder_Cruiser","Geonosian_Cruiser",
				"C9979_Carrier","Munifex","Sabaoth_Hex_Deployer","Pursuer_Enforcement_Ship_Group","Gozanti_Cruiser_Group","Auxilia","Munificent",
				"Recusant_Light_Destroyer","Storm_Fleet_Destroyer","Lucrehulk_Core_Destroyer","Captor","Sabaoth_Destroyer","Providence_Destroyer","DH_Omni",
				"Bulwark_I","Providence_Carrier_Destroyer","Recusant_Dreadnought","Bulwark_II","Providence_Dreadnought","Lucrehulk_Auxiliary","Lucrehulk_Carrier",
				"Lucrehulk_Battleship","Subjugator","Devastation",

				"B1_Droid_Company","B1_Geo_Droid_Company","B1_RC_Droid_Company","Neimoidian_Guard_Company","Skakoan_Combat_Engineer_Company","B2_Droid_Company","BX_Commando_Company",
				"Crab_Droid_Company","CIS_STAP_Company","Destroyer_Droid_I_P_Company","Destroyer_Droid_I_W_Company","Destroyer_Droid_I_Q_Company",
				"Dwarf_Spider_Droid_Company","Destroyer_Droid_II_Company","OG9_Company","CIS_GAT_Company","CA_Artillery_Company","PAC_Company",
				"HAML_Company","HAG_Company","Persuader_Company","CIS_Defoliator_Company","CIS_AAT_Company","CIS_MTT_Company","J1_Cannon_Company",
				"CIS_MAF_Company","HMP_Company","Magna_Octuptarra_Company","Super_Tank_Company","CIS_Super_Tank_Company","Hailfire_Company",
			},
			RosterMapBases = {
				["Custom_GC_Light_Infantry"] = "B1_Droid_Company",
				["Custom_GC_Light_Infantry2"] = "B1_RC_Droid_Company",
				["Custom_GC_Heavy_Infantry"] = "B2_Droid_Company",
				["Custom_GC_Heavy_Infantry2"] = "Neimoidian_Guard_Company",
				["Custom_GC_Commando"] = "BX_Commando_Company",
				["Custom_GC_Commando2"] = "Destroyer_Droid_I_W_Company",
				["Custom_GC_Commando3"] = "Crab_Droid_Company",
				["Custom_GC_Commando4"] = "Dwarf_Spider_Droid_Company",
				["Custom_GC_Bike"] = "CIS_STAP_Company",
				["Custom_GC_Light_Vehicle"] = "OG9_Company",
				["Custom_GC_Light_Vehicle2"] = "PAC_Company",
				["Custom_GC_Light_Vehicle3"] = "CIS_GAT_Company",
				["Custom_GC_Medium_Vehicle"] = "CIS_AAT_Company",
				["Custom_GC_Medium_Vehicle2"] = "Persuader_Company",
				["Custom_GC_2PerCompany"] = "J1_Cannon_Company",
				["Custom_GC_2PerCompany2"] = "Magna_Octuptarra_Company",
				["Custom_GC_2PerCompany3"] = "Hailfire_Company",
				["Custom_GC_Heavy_Vehicle"] = "CIS_MTT_Company",
				["Custom_GC_Heavy_Vehicle2"] = "CIS_Super_Tank_Company",
				["Custom_GC_Heavy_Vehicle3"] = "Super_Tank_Company",
				["Custom_GC_Gunship"] = "CIS_MAF_Company",
				["Custom_GC_Gunship2"] = "HMP_Company",
				["Custom_GC_Artillery"] = "HAG_Company",
				["Custom_GC_AA"] = "HAML_Company",
				
				["Custom_GC_Light_Corvette"] = "Lupus_Missile_Frigate",
				["Custom_GC_Heavy_Corvette"] = "Hardcell",
				["Custom_GC_Heavy_Corvette2"] = "Diamond_Frigate",
				["Custom_GC_Superheavy_Corvette"] = "Sabaoth_Frigate",
				["Custom_GC_Superheavy_Corvette2"] = "Hardcell_Tender",
				["Custom_GC_FrigateA"] = "Marauder_Cruiser",
				["Custom_GC_FrigateB"] = "C9979_Carrier",
				["Custom_GC_FrigateB2"] = "Munifex",
				["Custom_GC_FrigateC"] = "Sabaoth_Hex_Deployer",
				["Custom_GC_FrigateC2"] = "Pursuer_Enforcement_Ship_Group",
				["Custom_GC_FrigateD"] = "Gozanti_Cruiser_Group",
				["Custom_GC_FrigateF"] = "Auxilia",
				["Custom_GC_FrigateG"] = "Munificent",
				["Custom_GC_FrigateH"] = "Recusant_Light_Destroyer",
				["Custom_GC_Heavy_Frigate"] = "Captor",
				["Custom_GC_Heavy_Frigate2"] = "Sabaoth_Destroyer",
				["Custom_GC_Heavy_Frigate3"] = "Providence_Destroyer",
				["Custom_GC_Heavy_Frigate4"] = "DH_Omni",
				["Custom_GC_Superheavy_Frigate"] = "Providence_Carrier_Destroyer",
				["Custom_GC_CapitalShip"] = "Bulwark_II",
				["Custom_GC_CapitalShipB"] = "Providence_Dreadnought",
				["Custom_GC_Light_Battlecruiser"] = "Lucrehulk_Auxiliary",
				["Custom_GC_Heavy_Battlecruiser"] = "Lucrehulk_Carrier",
				["Custom_GC_Heavy_Battlecruiser2"] = "Lucrehulk_Battleship",
			},
			UnmappedRoster = {"Subjugator","Devastation"}
		},
		["Empire"] = {
			DummyUnit = "Custom_GC_Republic",
			PlayerStart = {"Chandrila"},
			Capital = "Republic_Capital",
			Perception = "Is_Connected_To_Republic",
			SmallHero = {
				{"Pestage_Team", "Rahm_Kota_Team", "Dallin_Kebir","Seerdon_Invincible"},
				{"Pestage_Team", "Mace_Windu_Delta_Team", "Tallon_Sundiver","Pellaeon_Leveler"},
				{"Pestage_Team", "Obi_Wan_Eta_Team", "Tallon_Sundiver","Coburn_Venator"},
				{"Pestage_Team", "Yoda_Eta_Team", "Yularen_Integrity","Pellaeon_Leveler"},
				{"Pestage_Team", "Plo_Koon_Delta_Team", "Parck_Strikefast","Dodonna_Ardent"},
			},
			RosterUnits = {
				"LAC","CR90","Customs_Corvette","Charger_C70","Lancer_Frigate_Prototype","Consular_Refit","Pelta_Support",
				"DP20","Class_C_Support","Pelta_Assault","Class_C_Frigate","Citadel_Cruiser_Group","Galleon","Arquitens",
				"CEC_Light_Cruiser","Gamma_ATR_6_Group","Carrack_Cruiser_Lasers","Starbolt","Victory_I_Frigate","PDF_DHC",
				"Neutron_Star","Rep_DHC","DHC_Carrier","Gladiator_I","Acclamator_II","Imperial_I_Frigate","Acclamator_I_Assault","Victory_I_Star_Destroyer",
				"Acclamator_I_Carrier","Victory_I_Fleet_Star_Destroyer","Victory_II_Star_Destroyer","Venator_Star_Destroyer","Acclamator_Destroyer","Invincible_Cruiser","Imperator_Star_Destroyer_Assault",
				"Acclamator_Battleship","Imperator_Star_Destroyer","Tector_Star_Destroyer","Maelstrom_Battlecruiser","Procurator_Battlecruiser","Secutor_Star_Destroyer","Praetor_I_Battlecruiser",
				"Mandator_I_Dreadnought",
				
				"Republic_Navy_Trooper_Company","Republic_Trooper_Company","Clonetrooper_Phase_One_Company","Republic_Overracer_Speeder_Bike_Company","Clonetrooper_Phase_Two_Company","Special_Tactics_Trooper_Company",
				"ARC_Phase_One_Company","Republic_74Z_Bike_Company","Antarian_Ranger_Company","ARC_Phase_Two_Company","Clone_Commando_Company",
				"Republic_SD_6_Droid_Company","Republic_AT_RT_Company","Republic_AT_PT_Company","Republic_BARC_Company","Republic_ISP_Company","Republic_ULAV_Company","AT_XT_Company",
				"Republic_Gian_Company","AV7_Company","Republic_Jedi_Knight_Company","Republic_Gaba18_Company","Republic_AT_AP_Walker_Company","Republic_UT_AA_Company","Republic_TX130S_Company",
				"Republic_TX130T_Company","Republic_A4_Juggernaut_Company","UT_AT_Speeder_Company","AT_OT_Walker_Company","Republic_Flashblind_Company","Republic_AT_TE_Walker_Company","Republic_A5_Juggernaut_Company",
				"Republic_LAAT_Company","HAET_Company","Republic_VAAT_Company",
			},
			RosterMapBases = {
				["Custom_GC_Light_Infantry"] = "Republic_Trooper_Company",
				["Custom_GC_Light_Infantry2"] = "Republic_Navy_Trooper_Company",
				["Custom_GC_Heavy_Infantry"] = "Clonetrooper_Phase_One_Company",
				["Custom_GC_Heavy_Infantry2"] = "Clonetrooper_Phase_Two_Company",
				["Custom_GC_Commando"] = "ARC_Phase_One_Company",
				["Custom_GC_Commando2"] = "ARC_Phase_Two_Company",
				["Custom_GC_Commando3"] = "Clone_Commando_Company",
				["Custom_GC_Commando4"] = "Republic_Jedi_Knight_Company",
				["Custom_GC_Bike"] = "Republic_74Z_Bike_Company",
				["Custom_GC_Bike2"] = "Republic_SD_6_Droid_Company",
				["Custom_GC_Light_Walker"] = "AT_RT_Company",
				["Custom_GC_Light_Vehicle"] = "Republic_ISP_Company",
				["Custom_GC_Light_Vehicle2"] = "Republic_Gian_Company",
				["Custom_GC_Light_Vehicle3"] = "AT_XT_Company",
				["Custom_GC_Medium_Vehicle"] = "Republic_TX130S_Company",
				["Custom_GC_Medium_Vehicle2"] = "Republic_TX130T_Company",
				["Custom_GC_2PerCompany"] = "AT_OT_Walker_Company",
				["Custom_GC_Heavy_Vehicle"] = "Republic_AT_TE_Walker_Company",
				["Custom_GC_Heavy_Vehicle2"] = "UT_AT_Speeder_Company",
				["Custom_GC_Heavy_Vehicle3"] = "Republic_A5_Juggernaut_Company",
				["Custom_GC_Airspeeder"] = "Republic_Gaba18_Company",
				["Custom_GC_Gunship"] = "Republic_LAAT_Company",
				["Custom_GC_Gunship2"] = "HAET_Company",
				["Custom_GC_Artillery"] = "AV7_Company",
				["Custom_GC_AA"] = "Republic_UT_AA_Company",
				
				["Custom_GC_Light_Corvette"] = "CR90",
				["Custom_GC_Heavy_Corvette"] = "Charger_C70",
				["Custom_GC_Heavy_Corvette2"] = "Consular_Refit",
				["Custom_GC_Superheavy_Corvette"] = "Pelta_Support",
				["Custom_GC_Superheavy_Corvette2"] = "DP20",
				["Custom_GC_FrigateA"] = "Pelta_Assault",
				["Custom_GC_FrigateB"] = "Citadel_Cruiser_Group",
				["Custom_GC_FrigateB2"] = "Galleon",
				["Custom_GC_FrigateB3"] = "Arquitens",
				["Custom_GC_FrigateC"] = "Carrack_Cruiser_Lasers",
				["Custom_GC_FrigateC2"] = "Starbolt",
				["Custom_GC_FrigateD"] = "PDF_DHC",
				["Custom_GC_FrigateE"] = "Rep_DHC",
				["Custom_GC_FrigateF"] = "DHC_Carrier",
				["Custom_GC_FrigateG"] = "Acclamator_II",
				["Custom_GC_FrigateH"] = "Acclamator_I_Assault",
				["Custom_GC_Heavy_Frigate"] = "Victory_I_Star_Destroyer",
				["Custom_GC_Heavy_Frigate2"] = "Acclamator_I_Carrier",
				["Custom_GC_Heavy_Frigate3"] = "Victory_I_Fleet_Star_Destroyer",
				["Custom_GC_Heavy_Frigate4"] = "Victory_II_Star_Destroyer",
				["Custom_GC_Superheavy_Frigate"] = "Venator_Star_Destroyer",
				["Custom_GC_CapitalShip"] = "Invincible_Cruiser",
				["Custom_GC_CapitalShipB"] = "Procurator_Battlecruiser",
				["Custom_GC_Light_Battlecruiser"] = "Secutor_Star_Destroyer",
				["Custom_GC_Heavy_Battlecruiser"] = "Praetor_I_Battlecruiser",
			},
			UnmappedRoster = {"Republic_AT_PT_Company","Mandator_I_Dreadnought"},
		},
		["Hutt_Cartels"] = {
			DummyUnit = "Custom_GC_Hutts",
			PlayerStart = {"Nar_Shaddaa"},
			Capital = "Hutt_Capital",
			Perception = "Is_Connected_To_Hutts",
			SmallHero = {
				{"Smebba_Dunk_Team", "Troonol_Agrelcu_Haalta", "Riboga_Rightful_Dominion", "Parella_Team"}
			},
			AltSmall = {
				["Shadow Collective"] = {"Pre_Vizsla_Team", "Lom_Pyke_Super_Transport_XI_Modified", "Ziton_Moj_Team", "Lorka_Gedyc_Team", "Bo_Katan_Team"}
			},
			RosterUnits = {
				"Light_Minstrel_Yacht","IPV1_Gunboat","Consular_Refit","Raka_Freighter_Tender","Heavy_Minstrel_Yacht","Kaloth_Battlecruiser","SC_Komrk_Gunship_Group",
				"Juvard_Frigate","Galleon","Hutt_Galleon","Barabbula_Frigate","Ubrikkian_Cruiser_CW","Gozanti_Cruiser_Raider_Group","Kossak_Frigate",
				"DHC_Gunboat","Szajin_Cruiser","Tempest_Cruiser","Karagga_Destroyer","Vontor_Destroyer","Voracious_Carrier","Hutt_Boarding_Shuttle",
				"DorBulla_Warship",


				"Hutt_Guard_Company","Hutt_Airhook_Company","Armored_Hutt_Company","Hutt_Starhawk_Company","SC_Mandalorian_Soldier_Company",
				"SC_Mandalorian_Commando_Company","Hutt_Pongeeta_Swamp_Speeder_Company","Hutt_Personnel_Skiff_IV_Company","Hutt_Bantha_II_Skiff_Company","Hutt_SuperHaul_II_Skiff_Company","Hutt_AA_Skiff_Company",
				"Luxury_Barge_Company","Hutt_Atmospheric_Flyer_Company","WLO5_Tank_Company","MAL_Rocket_Vehicle_Company","Hutt_VAAT_Company",
			},
			RosterMapBases = {
				["Custom_GC_Light_Infantry"] = "Hutt_Guard_Company",
				["Custom_GC_Heavy_Infantry"] = "SC_Mandalorian_Soldier_Company",
				["Custom_GC_Commando"] = "Armored_Hutt_Company",
				["Custom_GC_Commando2"] = "SC_Mandalorian_Commando_Company",
				["Custom_GC_Bike"] = "Hutt_Starhawk_Company",
				["Custom_GC_Bike2"] = "Hutt_Airhook_Company",
				["Custom_GC_Light_Vehicle"] = "Hutt_Personnel_Skiff_IV_Company",
				["Custom_GC_Light_Vehicle2"] = "Hutt_Bantha_II_Skiff_Company",
				["Custom_GC_Light_Vehicle3"] = "Hutt_SuperHaul_II_Skiff_Company",
				["Custom_GC_Medium_Vehicle"] = "WLO5_Tank_Company",
				["Custom_GC_Medium_Vehicle2"] = "Hutt_Pongeeta_Swamp_Speeder_Company",
				["Custom_GC_Heavy_Vehicle"] = "Luxury_Barge_Company",
				["Custom_GC_Airspeeder"] = "Hutt_Atmospheric_Flyer_Company",
				["Custom_GC_Gunship"] = "Hutt_VAAT_Company",
				["Custom_GC_Artillery"] = "MAL_Rocket_Vehicle_Company",
				["Custom_GC_AA"] = "Hutt_AA_Skiff_Company",
				
				["Custom_GC_Light_Corvette"] = "Light_Minstrel_Yacht",
				["Custom_GC_Heavy_Corvette"] = "IPV1_Gunboat",
				["Custom_GC_Heavy_Corvette2"] = "Consular_Refit",
				["Custom_GC_Superheavy_Corvette"] = "Raka_Freighter_Tender",
				["Custom_GC_Superheavy_Corvette2"] = "Hardcell_Tender",
				["Custom_GC_FrigateA"] = "Kaloth_Battlecruiser",
				["Custom_GC_FrigateB"] = "Juvard_Frigate",
				["Custom_GC_FrigateB2"] = "Galleon",
				["Custom_GC_FrigateB3"] = "Hutt_Galleon",
				["Custom_GC_FrigateC"] = "Barabbula_Frigate",
				["Custom_GC_FrigateC2"] = "Ubrikkian_Cruiser_CW",
				["Custom_GC_FrigateD"] = "Gozanti_Cruiser_Raider_Group",
				["Custom_GC_FrigateE"] = "Kossak_Frigate",
				["Custom_GC_FrigateF"] = "DHC_Gunboat",
				["Custom_GC_FrigateG"] = "Szajin_Cruiser",
				["Custom_GC_FrigateG"] = "Tempest_Cruiser",
				["Custom_GC_Heavy_Frigate"] = "Karagga_Destroyer",
				["Custom_GC_CapitalShip"] = "Vontor_Destroyer",
				["Custom_GC_CapitalShipB"] = "Voracious_Carrier",
				["Custom_GC_Heavy_Battlecruiser"] = "DorBulla_Warship",
			},
			UnmappedRoster = {"Hutt_Boarding_Shuttle"},
		},
		["Sector_Forces"] = {
			DummyUnit = "Custom_GC_Sector",
			Capital = "Republic_Capital",
			Perception = "Is_Connected_To_Sector_Forces",
			SmallHero = {
				{"Garm_Team", "Commander_Army_IV_Team", "Dallin_Kebir", "Grumby_Invincible"},
			}
		},
		["Trade_Federation"] = {
			DummyUnit = "Custom_GC_Trade_Federation",
			Capital = "CIS_Capital",
			Perception = "Is_Connected_To_Trade_Federation",
			SmallHero = {
				{"Nute_Gunray_Team", "Lok_Durd_Defoliator_Team", "TF1726_Munificent","Commander_Tier_IV_Lucrehulk_Bulk_Cruiser"},
			}
		},
		["Techno_Union"] = {
			DummyUnit = "Custom_GC_Techno_Union",
			Capital = "CIS_Capital",
			Perception = "Is_Connected_To_Techno_Union",
			SmallHero = {
				{"Tambor_Team", "Treetor_Captor", "Commander_Tier_II_Lucrehulk_Core_Destroyer", "Commander_Tier_II_T_Series_Tectical_Droid_Brown_Company"},
			}
		},
		["Banking_Clan"] = {
			DummyUnit = "Custom_GC_IGBC",
			Capital = "CIS_Capital",
			Perception = "Is_Connected_To_Banking_Clan",
			SmallHero = {
				{"Hoolidan_Keggle_Team", "Canteval_Munificent", "Commander_Tier_II_Munificent_C3", "Commander_Tier_III_AAT_Company"},
			}
		},
		["Commerce_Guild"] = {
			DummyUnit = "Custom_GC_Commerce_Guild",
			Capital = "CIS_Capital",
			Perception = "Is_Connected_To_Commerce_Guild",
			SmallHero = {
				{"Shu_Mai_Castell", "Stark_Recusant", "Commander_Tier_II_Recusant_Light_Destroyer", "Commander_Tier_III_Persuader_Command_Company"},
			}
		},
	}
	
	return dummies
end

function Get_Full_Hero_File(era)
	local corenne = "eawx-mod-fotr/spawn-sets/"
	local perera = {"EraOneStartSet", "EraTwoStartSet", "EraThreeStartSet", "EraFourStartSet", "EraFiveStartSet"}
	return corenne .. perera[era]
end