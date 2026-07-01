require("PGStateMachine")
require("PGStoryMode")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	Define_State("State_Init", State_Init);

end

function State_Init(message)
	if message == OnEnter then

		Object.Set_Selectable(false)
		Object.Make_Invulnerable(true)

		base_type = Object.Get_Type().Get_Name() .. "_Base"
		
		

	elseif message == OnUpdate then

		local nearby_base = false

        local activeBases = Find_All_Objects_Of_Type(base_type)

        for _,base in pairs(activeBases) do

            distance = Object.Get_Distance(base)
            
            if distance <= 200 then
                nearby_base = true
				break
            end
    	end

		if nearby_base == false then

			Object.Make_Invulnerable(false)
			Object.Despawn()
		
		end
	end
end