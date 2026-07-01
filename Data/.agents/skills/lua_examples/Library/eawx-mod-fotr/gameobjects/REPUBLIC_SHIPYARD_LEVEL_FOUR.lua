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
		["CLOAKSHAPE_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = LessThan(2)}
		},
		["CLONE_ARC_170_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(2)}
		},
		["2_WARPOD_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 2, Reserve = 4, ResearchType = "RepublicWarpods"},
			SECTOR_FORCES = {Initial = 2, Reserve = 4, TechLevel = LessThan(2)},
			INDEPENDENT_FORCES = {Initial = 2, Reserve = 4, TechLevel = LessThan(2)}
		},
		["BTLS1_Y_WING_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 2, Reserve = 4, ResearchType = "~RepublicWarpods"},
			SECTOR_FORCES = {Initial = 2, Reserve = 4, TechLevel = GreaterOrEqualTo(2)},
			INDEPENDENT_FORCES = {Initial = 2, Reserve = 4, TechLevel = GreaterOrEqualTo(2)}
		},
		["SKIRMISH_LAC"] = {
			DEFAULT = {Initial = 3, Reserve = 6}
		},
		["SKIRMISH_CARRACK_CRUISER_LASERS"] = {
			DEFAULT = {Initial = 2, Reserve = 0}
		},
		["SKIRMISH_REP_DHC"] = {
			DEFAULT = {Initial = 3, Reserve = 0, TechLevel = LessThan(2)}
		},
		["SKIRMISH_CEC_LIGHT_CRUISER"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = IsOneOf{(2)}}
		},
		["SKIRMISH_ARQUITENS"] = {
			DEFAULT = {Initial = 4, Reserve = 0, TechLevel = GreaterOrEqualTo(3)}
		},
		["SKIRMISH_DHC_CARRIER"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = LessThan(2)}
		},
		["SKIRMISH_ACCLAMATOR_I_CARRIER"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = GreaterOrEqualTo(2)}
		},
		["SKIRMISH_INVINCIBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 0, TechLevel = LessThan(3)}
		},
		["SKIRMISH_VENATOR_STAR_DESTROYER"] = {
			DEFAULT = {Initial = 1, Reserve = 0, TechLevel = GreaterOrEqualTo(3)}
		}
	},
	Scripts = {"fighter-spawn"},
	Flags = {SHIPYARD = true, HANGAR = true}
}