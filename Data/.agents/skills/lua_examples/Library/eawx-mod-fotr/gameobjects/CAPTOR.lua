return {
	Ship_Crew_Requirement = 115,
	Fighters = {
		["LIGHT_FIGHTER"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["ELITE_FIGHTER"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["BOMBER_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		}
	},
	Native = "CIS",
	FighterFlags = {"PDF_BOMBER","ELITE_CLOAKSHAPE"},
	Scripts = {"multilayer", "fighter-spawn"}
}