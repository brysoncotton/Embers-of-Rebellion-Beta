return {
	Fighters = {
		["DELTA6_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(2)},
			HOSTILE = {Initial = 1, Reserve = 4},
			SECTOR_FORCES = {Initial = 1, Reserve = 4},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 4}
		},
		["CLONE_Z95_HEADHUNTER_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(2)}
		},
		["CLOAKSHAPE_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 9, TechLevel = LessOrEqualTo(2)},
			HOSTILE = {Initial = 1, Reserve = 9, TechLevel = LessOrEqualTo(2)},
			SECTOR_FORCES = {Initial = 1, Reserve = 9, TechLevel = LessOrEqualTo(2)},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 9, TechLevel = LessOrEqualTo(2)}
		},
		["CLONE_ARC_170_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 9, TechLevel = GreaterThan(2)},
			HOSTILE = {Initial = 1, Reserve = 9, TechLevel = GreaterThan(2)},
			SECTOR_FORCES = {Initial = 1, Reserve = 9, TechLevel = GreaterThan(2)},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 9, TechLevel = GreaterThan(2)}
		},
		["2_WARPOD_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 9, ResearchType = "RepublicWarpods"},
			SECTOR_FORCES = {Initial = 1, Reserve = 9, TechLevel = EqualTo(1)},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 9, TechLevel = EqualTo(1)},
			HOSTILE = {Initial = 1, Reserve = 9, TechLevel = EqualTo(1)}
		},
		["CLONE_BTLB_Y_WING_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 9, ResearchType = "~RepublicWarpods"},
			SECTOR_FORCES = {Initial = 1, Reserve = 9, TechLevel = GreaterOrEqualTo(2)},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 9, TechLevel = GreaterOrEqualTo(2)},
			HOSTILE = {Initial = 1, Reserve = 9, TechLevel = GreaterOrEqualTo(2)}
		},
		["NTB_630_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = GreaterOrEqualTo(2)},
			HOSTILE = {Initial = 1, Reserve = 4, TechLevel = GreaterOrEqualTo(2)},
			SECTOR_FORCES = {Initial = 1, Reserve = 4, TechLevel = GreaterOrEqualTo(2)},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 4, TechLevel = GreaterOrEqualTo(2)},
		},
		["SCURRG_H6_PROTOTYPE_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = EqualTo(1)},
			HOSTILE = {Initial = 1, Reserve = 4, TechLevel = EqualTo(1)},
			SECTOR_FORCES = {Initial = 1, Reserve = 4, TechLevel = EqualTo(1)},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 4, TechLevel = EqualTo(1)}
		},
		["SKIRMISH_LAC"] = {
			DEFAULT = {Initial = 3, Reserve = 3}
		}
	},
	Scripts = {"fighter-spawn"},
}