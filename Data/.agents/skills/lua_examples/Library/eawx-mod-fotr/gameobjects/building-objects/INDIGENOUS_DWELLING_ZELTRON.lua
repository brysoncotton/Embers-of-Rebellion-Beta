return {
	dwelling_type = "PARTISAN",
	can_be_influenced = true,

	group_name = "ZELTRON",
	random_allegiance = true,
	Allegiances = {"ATTACKER", "DEFENDER", "INDEPENDENT_FORCES"},

	Spawn_Units = {
		["PARTISAN_ZELTRON_SQUAD"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		}
	},
	Scripts = {"partisan-allegiance"},
}