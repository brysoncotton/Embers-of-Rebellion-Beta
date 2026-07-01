require("PGBaseDefinitions")

function Clean_Up()
	-- any temporary object pointers need to be set to nil in this function.
	-- ie: Target = nil
	ret_value = nil
end

function Evaluate(randmin, randmax)

	if not randmin then
		randmin = 0
	end
	
	if not randmax then
		randmax = 10
	end

	--DebugMessage("%s -- Generating random number", tostring(Script))
	ret_value = GameRandom.Free_Random(randmin, randmax)/10
	
	return ret_value
end 