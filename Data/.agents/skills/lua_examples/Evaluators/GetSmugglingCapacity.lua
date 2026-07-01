require("PGTaskForce")

function Clean_Up()
end

function Evaluate()
	capacity = GlobalValue.Get("HUTT_SMUGGLING_CAPACITY")
	if capacity == nil then
		return 0.0
	end
	
	return capacity
end
