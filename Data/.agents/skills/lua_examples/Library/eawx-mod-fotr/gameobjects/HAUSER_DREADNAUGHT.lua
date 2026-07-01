return {
	Fighters = {
		["CLOAKSHAPE_STOCK_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 0, TechLevel = EqualTo(1)}
		},
		["TORRENT_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 0, TechLevel = EqualTo(2)}
		},
		["CLONE_Z95_HEADHUNTER_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 0, TechLevel = GreaterOrEqualTo(3)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}