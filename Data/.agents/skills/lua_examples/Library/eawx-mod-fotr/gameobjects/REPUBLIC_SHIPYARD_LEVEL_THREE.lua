return {
	Fighters = {
		["PDF_Z95_HEADHUNTER_SQUADRON"] = {
			DEFAULT = {Initial = 3, Reserve = 99, TechLevel = LessThan(2)}
		},
		["TORRENT_SQUADRON"] = {
			DEFAULT = {Initial = 3, Reserve = 99, TechLevel = IsOneOf({2, 3})}
		},
		["CLONE_NIMBUS_V_WING_SQUADRON"] = {
			DEFAULT = {Initial = 3, Reserve = 99, TechLevel = GreaterOrEqualTo(4)}
		},
		["CLOAKSHAPE_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = LessThan(2)}
		},
		["CLONE_ARC_170_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(2)}
		},
		["2_WARPOD_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 3, Reserve = 6, ResearchType = "RepublicWarpods"},
			SECTOR_FORCES = {Initial = 3, Reserve = 6, TechLevel = LessThan(2)},
			INDEPENDENT_FORCES = {Initial = 3, Reserve = 6, TechLevel = LessThan(2)}
		},
		["BTLS1_Y_WING_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 3, Reserve = 6, ResearchType = "~RepublicWarpods"},
			SECTOR_FORCES = {Initial = 3, Reserve = 6, TechLevel = GreaterOrEqualTo(2)},
			INDEPENDENT_FORCES = {Initial = 3, Reserve = 6, TechLevel = GreaterOrEqualTo(2)}
		},
		["SKIRMISH_LAC"] = {
			DEFAULT = {Initial = 2, Reserve = 4}
		},
		["SKIRMISH_CLASS_C_FRIGATE"] = {
			DEFAULT = {Initial = 3, Reserve = 0, TechLevel = LessThan(2)}
		},
		["SKIRMISH_ARQUITENS"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = GreaterOrEqualTo(2)}
		},
		["SKIRMISH_REP_DHC"] = {
			DEFAULT = {Initial = 2, Reserve = 0}
		},
		["SKIRMISH_STARBOLT"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = LessThan(2)}
		},
		["SKIRMISH_ACCLAMATOR_I_CARRIER"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = GreaterOrEqualTo(2)}
		},
		["SKIRMISH_CEC_LIGHT_CRUISER"] = {
			DEFAULT = {Initial = 4, Reserve = 0, TechLevel = LessThan(2)}
		}

	},
	Scripts = {"fighter-spawn"},
	Flags = {SHIPYARD = true, HANGAR = true}
}