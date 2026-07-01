require("PGStateMachine")

function Definitions()
	Define_State("State_Init", State_Init)
	retreating_allowed = false
end

function State_Init(message)
	if Get_Game_Mode() ~= "Space" then
		ScriptExit()
	end
	if message == OnEnter then
		if not Object.Get_Owner().Is_Human() then
			Sleep(8.0)
			if Object.Are_Engines_Online() then 
				if Object.Get_Owner().Get_Faction_Name() == "WARLORDS" or Object.Get_Owner().Get_Faction_Name() == "HOSTILE" or
					EvaluatePerception("Enemy_Retreating", Object.Get_Owner()) == 1 or EvaluatePerception("Self_Retreating", Object.Get_Owner()) == 1 then
					ScriptExit()
				end
				local interdictorTable = Find_All_Objects_Of_Type("Interdictor")
				for _, interdictor in pairs(interdictorTable) do
					if TestValid(interdictor) then
						if interdictor.Is_Ability_Active("INTERDICT") then 
							ScriptExit()
						end
					end
				end
				Object.Hyperspace_Away(false)
			end
			ScriptExit()
		end
	elseif message == OnUpdate then
		if Object.Get_Owner().Is_Human() then
			if Object.Is_Ability_Active("TURBO") then
				Sleep(8.0)
				if Object.Are_Engines_Online() then 
					if EvaluatePerception("Enemy_Retreating", Object.Get_Owner()) == 1 or EvaluatePerception("Self_Retreating", Object.Get_Owner()) == 1 then
						retreating_allowed = false
					else
						retreating_allowed = true
					end
					local interdictorTable = Find_All_Objects_Of_Type("Interdictor")
					for _, interdictor in pairs(interdictorTable) do
						if TestValid(interdictor) then
							if interdictor.Is_Ability_Active("INTERDICT") then 
								retreating_allowed = false
							else
								retreating_allowed = true
							end
						end
					end
					if retreating_allowed and Object.Is_Ability_Active("TURBO") then
						Object.Hyperspace_Away(false)
					end
				end
				ScriptExit()
			end
		end
	end
end
