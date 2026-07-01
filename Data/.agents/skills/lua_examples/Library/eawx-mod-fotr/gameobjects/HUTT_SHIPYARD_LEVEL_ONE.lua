return {
	Fighters = {
		["Z95_HEADHUNTER_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 99}
		},
		["CLOAKSHAPE_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["BTLS1_Y_WING_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(2)}
		},
		["2_WARPOD_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = EqualTo(1)}
		},
		["SKIRMISH_LIGHT_MINSTREL_YACHT"] = {
			DEFAULT = {Initial = 2, Reserve = 2}
		},
		["SKIRMISH_HEAVY_MINSTREL_YACHT"] = {
			DEFAULT = {Initial = 2, Reserve = 0}
		},
		["SKIRMISH_JUVARD_FRIGATE"] = {
			DEFAULT = {Initial = 2, Reserve = 0,}
		}
	},
	Scripts = {"fighter-spawn"},
	Flags = {SHIPYARD = true, HANGAR = true}
}