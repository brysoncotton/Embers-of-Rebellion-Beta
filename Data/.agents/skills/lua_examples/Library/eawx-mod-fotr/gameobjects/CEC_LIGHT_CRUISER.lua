return {
	Ship_Crew_Requirement = 60,
	Fighters = {
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 1, ResearchType = "TIERacks", HeroOverride = {{"TRACHTA_VENATOR"}, {"TIE_POD_SQUADRON_HALF"}}}
		}
	},
	Scripts = {"multilayer", "single-unit-retreat", "fighter-spawn"},
	Flags = {HANGAR = true}
}