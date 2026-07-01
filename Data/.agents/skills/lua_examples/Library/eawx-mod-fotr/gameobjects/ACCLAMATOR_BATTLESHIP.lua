return {
	Ship_Crew_Requirement = 600,
	Fighters = {
		["ELITE_FIGHTER_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		},
		["INTERCEPTOR"] = {
			DEFAULT = {Initial = 1, Reserve = 3, HeroOverride = {{"SATE_PESTAGE","MON_MOTHMA"}, {"NIMBUS_V_WING_ELITE_GUARD_GUARD_SQUADRON","NIMBUS_V_WING_ELITE_GUARD_SQUADRON"}}, TechLevel = GreaterThan(3)}
		},
		["HEAVY_BOMBER"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
	},
	Native = "EMPIRE",
	Scripts = {"multilayer", "fighter-spawn"}
}