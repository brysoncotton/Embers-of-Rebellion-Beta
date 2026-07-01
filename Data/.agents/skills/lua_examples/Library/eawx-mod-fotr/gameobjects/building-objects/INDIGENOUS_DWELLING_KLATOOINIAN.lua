return {
	dwelling_type = "PARTISAN",
	can_be_influenced = true,

	group_name = "KLATOOINIAN",
	random_allegiance = false,
	Allegiances = {"HUTT_CARTELS"},

	Spawn_Units = {
		["PARTISAN_KLATOOINIAN_SQUAD"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		}
	},
	Scripts = {"partisan-allegiance"},
}