return {
	dwelling_type = "PARTISAN",
	can_be_influenced = true,

	group_name = "GAMORREAN",
	random_allegiance = false,
	Allegiances = {"CIS", "HUTT_CARTELS"},

	Spawn_Units = {
		["PARTISAN_GAMORREAN_SQUAD"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		}
	},
	Scripts = {"partisan-allegiance"},
}