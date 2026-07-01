return {
	dwelling_type = "ANIMAL",
	can_be_influenced = true,

	group_name = "WAMPA",
	random_allegiance = false,
	Allegiances = {"HOSTILE"},

	Spawn_Units = {
		["WAMPA"] = {
			DEFAULT = {Initial = 5, Reserve = 10},
		}
	},
	Scripts = {"partisan-allegiance"},
}