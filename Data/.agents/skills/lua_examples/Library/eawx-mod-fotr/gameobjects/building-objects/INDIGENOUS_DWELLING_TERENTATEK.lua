return {
	dwelling_type = "ANIMAL",
	can_be_influenced = true,

	group_name = "TERENTATEK",
	random_allegiance = false,
	Allegiances = {"HOSTILE"},

	Spawn_Units = {
		["TERENTATEK"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		}
	},
	Scripts = {"partisan-allegiance"},
}