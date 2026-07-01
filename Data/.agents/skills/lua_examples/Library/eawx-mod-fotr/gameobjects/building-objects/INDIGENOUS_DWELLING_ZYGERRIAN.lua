return {
	dwelling_type = "PARTISAN",
	can_be_influenced = true,

	group_name = "ZYGERRIAN",
	random_allegiance = false,
	Allegiances = {"CIS"},

	Spawn_Units = {
		["PARTISAN_ZYGERRIAN_SQUAD"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		}
	},
	Scripts = {"partisan-allegiance"},
}