return {
	dwelling_type = "PARTISAN",
	can_be_influenced = true,

	group_name = "SUN_GUARD",
	random_allegiance = false,
	Allegiances = {"CIS"},

	Spawn_Units = {
		["SUN_GUARD_SQUAD"] = {
			DEFAULT = {Initial = 3, Reserve = 6},
		}
	},
	Scripts = {"partisan-allegiance"},
}