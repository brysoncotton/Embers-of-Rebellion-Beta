return {
	Fighters = {
		["NANTEX_SQUADRON"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 1},
			COMMERCE_GUILD = {Initial = 1, Reserve = 1}
		},
		["SCARAB_SQUADRON"] = {
			REBEL = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(3)},
			TECHNO_UNION = {Initial = 1, Reserve = 1},
			TRADE_FEDERATION = {Initial = 1, Reserve = 1}
		},
		["MANKVIM_SQUADRON"] = {
			REBEL = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(3)}
		},
		["SKIRMISH_DIAMOND_FRIGATE"] = {
			DEFAULT = {Initial = 1, Reserve = 0}
		}
	},
	Scripts = {"turn-station", "fighter-spawn"},
	Flags = {HANGAR = true}
}