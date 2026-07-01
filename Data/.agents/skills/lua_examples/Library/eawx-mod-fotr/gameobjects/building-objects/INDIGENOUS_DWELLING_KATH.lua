return {
	dwelling_type = "ANIMAL",
	can_be_influenced = true,

	group_name = "KATH",
	random_allegiance = false,
	Allegiances = {"HOSTILE"},

	Spawn_Units = {
		["KATH_HOUND"] = {
			DEFAULT = {Initial = 10, Reserve = 20},
		}
	},
	Scripts = {"partisan-allegiance"},
}