return {
	Ship_Crew_Requirement = 30,
	Fighters = {
		["CIVILIAN_FIGHTER_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["CIVILIAN_BOMBER_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat"},
	Flags = {HANGAR = true}
}