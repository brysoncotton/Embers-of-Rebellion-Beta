require("PGTaskForce")

function Clean_Up()
	Target = nil
end

function Evaluate()

	planet = Target.Get_Game_Object()
	if TestValid(planet) then
		name = planet.Get_Type().Get_Name()
		level = GlobalValue.Get(name.."_SMUGGLING_LEVEL")
		DebugMessage("%s -- Smuggling level for planet %s is %s", tostring(Script), tostring(name), tostring(level))
		if level == nil then
			return 0.0
		end
		
		return level
	else
		return 0.0
	end

end





