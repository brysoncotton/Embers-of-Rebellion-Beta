return {
	dwelling_type = "PARTISAN",
	can_be_influenced = false,

	group_name = "TUSKEN",
	random_allegiance = false,
	Allegiances = {"INDEPENDENT_FORCES"},

	Spawn_Units = {
		["PARTISAN_TUSKEN_RAIDER_SQUAD"] = {
			DEFAULT = {Initial = 2, Reserve = 4},
		},
		["PARTISAN_TUSKEN_HUNTER_SQUAD"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		}
	},
	Scripts = {"partisan-allegiance"},
}