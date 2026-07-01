return {
	Fighters = {
		["VULTURE_SQUADRON"] = {
			DEFAULT = {Initial = 3, Reserve = 99}
		},
		["SCARAB_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = LessThan(3)}
		},
		["TRIFIGHTER_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(3)}
		},
		["HYENA_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 2, Reserve = 4}
		},
		["SKIRMISH_DIAMOND_FRIGATE"] = {
			DEFAULT = {Initial = 2, Reserve = 3}
		},
		["SKIRMISH_MUNIFEX"] = {
			DEFAULT = {Initial = 2, Reserve = 0}
		},
		["SKIRMISH_MUNIFICENT"] = {
			DEFAULT = {Initial = 2, Reserve = 0}
		},
		["SKIRMISH_HARDCELL"] = {
			DEFAULT = {Initial = 3, Reserve = 0, TechLevel = LessThan(2)}
		},
		["SKIRMISH_CAPTOR"] = {
			DEFAULT = {Initial = 2, Reserve = 0, TechLevel = GreaterOrEqualTo(2)}
		},
		["SKIRMISH_LUCREHULK_AUXILIARY"] = {
			DEFAULT = {Initial = 1, Reserve = 0, TechLevel = LessThan(2)}
		},
		["SKIRMISH_PROVIDENCE_DESTROYER"] = {
			DEFAULT = {Initial = 1, Reserve = 0, TechLevel = EqualTo(2), ResearchType = "ProvidenceResearch"}
		},
		["SKIRMISH_PROVIDENCE"] = {
			DEFAULT = {Initial = 1, Reserve = 0, TechLevel = GreaterOrEqualTo(3), ResearchType = "~ProvidenceResearch"}
		}
	},
	Scripts = {"fighter-spawn"},
	Flags = {SHIPYARD = true, HANGAR = true}
}