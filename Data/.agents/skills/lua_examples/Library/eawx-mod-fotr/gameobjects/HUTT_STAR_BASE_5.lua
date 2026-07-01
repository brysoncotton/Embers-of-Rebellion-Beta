return {
	Fighters = {
		["SCURRG_H6_PROTOTYPE_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(1)},
		},
		["SCURRG_H6_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(1)}
		},
		["MORNINGSTAR_B_SQUADRON"] = {
			DEFAULT = {Initial = 2, Reserve = 8},
		},
		["AGGRESSOR_ASSAULT_FIGHTER_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 9},
		},
		["KIMOGILA_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 9},
		},
		["SKIRMISH_LIGHT_MINSTREL_YACHT"] = {
			DEFAULT = {Initial = 4, Reserve = 4}
		}
	},
	Scripts = {"fighter-spawn"}
}