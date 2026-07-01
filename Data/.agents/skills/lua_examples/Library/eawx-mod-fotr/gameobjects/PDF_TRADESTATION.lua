return {
	Fighters = {
		["CLOAKSHAPE_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 2},
			HOSTILE = {Initial = 1, Reserve = 2},
			SECTOR_FORCES = {Initial = 1, Reserve = 2},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 2}
		},
		["NANTEX_SQUADRON"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 2},
			COMMERCE_GUILD = {Initial = 1, Reserve = 2},
			REBEL = {Initial = 1, Reserve = 2}
		},
		["SCARAB_SQUADRON"] = {
			TECHNO_UNION = {Initial = 1, Reserve = 2},
			TRADE_FEDERATION = {Initial = 1, Reserve = 2}
		}
	},
	Scripts = {"fighter-spawn", "DefenderAligned"},
}