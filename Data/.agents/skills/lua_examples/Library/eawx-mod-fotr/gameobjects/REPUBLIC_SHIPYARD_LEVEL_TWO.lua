return {
	Fighters = {
		["PDF_Z95_HEADHUNTER_SQUADRON"] = {
			DEFAULT = {Initial = 2, Reserve = 99, TechLevel = LessThan(3)}
		},
		["TORRENT_SQUADRON"] = {
			DEFAULT = {Initial = 2, Reserve = 99, TechLevel = IsOneOf{(3)}}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON"] = {
			DEFAULT = {Initial = 2, Reserve = 99, TechLevel = GreaterOrEqualTo(4)}
		},
		["CLOAKSHAPE_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = LessThan(3)}
		},
		["CLONE_ARC_170_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(3)}
		},
		["2_WARPOD_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 2, ResearchType = "RepublicWarpods"},
			SECTOR_FORCES = {Initial = 1, Reserve = 2, TechLevel = LessThan(2)},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 2, TechLevel = LessThan(2)}
		},
		["BTLS1_Y_WING_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 2, ResearchType = "~RepublicWarpods"},
			SECTOR_FORCES = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(2)},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(2)}
		},
		["SKIRMISH_LAC"] = {
			DEFAULT = {Initial = 2, Reserve = 4}
		},
		["SKIRMISH_PDF_DHC"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = LessThan(2)}
		},
		["SKIRMISH_REP_DHC"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = GreaterOrEqualTo(2)}
		},
		["SKIRMISH_CONSULAR_REFIT"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = LessThan(2)}
		},
		["SKIRMISH_CARRACK_CRUISER_LASERS"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = GreaterOrEqualTo(2)}
		},
		["SKIRMISH_STARBOLT"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = LessThan(2)}
		}
	},
	Scripts = {"fighter-spawn"},
	Flags = {SHIPYARD = true, HANGAR = true}
}