return {
	Fighters = {
		["NANTEX_SQUADRON_HALF"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 1},
			COMMERCE_GUILD = {Initial = 1, Reserve = 1},
			REBEL = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(3)}
		},
		["MANKVIM_SQUADRON_HALF"] = {
			REBEL = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(3)}
		},
		["SCARAB_SQUADRON_HALF"] = {
			TECHNO_UNION = {Initial = 1, Reserve = 1},
			TRADE_FEDERATION = {Initial = 1, Reserve = 1}
		},
		["ADVANCED_ESTAP_BROWN_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(1)}
		},
		["BELBULLAB24_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 1, TechLevel = GreaterOrEqualTo(2)}
		},
		["SKIRMISH_DIAMOND_FRIGATE"] = {
			DEFAULT = {Initial = 1, Reserve = 1}
		}
	},
	Scripts = {"fighter-spawn"}
}