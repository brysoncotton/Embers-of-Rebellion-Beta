require("deepcore/std/callable")

local conditions = {}

function conditions.owned_by(faction_name)
    return callable {
        faction_name = faction_name,
        call = function(self, game_object)
            return Find_Player(self.faction_name) == game_object.Get_Owner()
        end
    }
end

function conditions.is_ai(faction_name)
	return callable {
		faction_name = faction_name,
		call = function(self)
			if Find_Player(self.faction_name) ~= nil then
				return not Find_Player(self.faction_name).Is_Human()
			else
				return false
			end
		end
	}
end

return conditions