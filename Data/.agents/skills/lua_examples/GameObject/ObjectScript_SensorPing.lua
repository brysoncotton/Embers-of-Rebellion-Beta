require("PGStateMachine")
require("eawx-util/MissionUtil")

function Definitions()
	ServiceRate = 1

	Define_State("State_Init", State_Init);

	ability_name = "FOW_REVEAL_PING"
	
	p_neutral = Find_Player("Neutral")
	p_human = Find_Player("local")
	p_attacker = nil
	p_owner = nil
end

function State_Init(message)
	if Get_Game_Mode() ~= "Land" then
		ScriptExit()
	end
	
	if p_attacker == nil then
		p_attacker = MissionUtil.Find_Attacking_Player()
	end
	
	if p_owner == nil then
		p_owner = Object.Get_Owner()
	end

	-- Bail out if this is a human player
	if p_owner == p_human then
		ScriptExit()
	end

	if p_owner ~= p_attacker then
		ScriptExit()
	end

	if message == OnEnter then
		ai_awake = nil
		--DebugMessage("%s -- init complete", tostring(Script))

	elseif message == OnUpdate then
		if ai_awake == nil then
			repeat
				Sleep(0.1)
				ai_awake = EvaluatePerception("Have_Orbital_Support", p_owner)
				--DebugMessage("%s -- checking orbital ready: %s", tostring(Script), tostring(orbital_ready))
			until ai_awake ~= nil
		end
		
		if EvaluatePerception("Have_Orbital_Support", p_owner) > 0 and Object.Is_Ability_Ready(ability_name) then
			structure_target_list = Find_All_Objects_Of_Type("InBase | OutBase")
			for _, structure_target in pairs(structure_target_list) do
				--DebugMessage("%s -- orbital ready, picked target %s", tostring(Script), tostring(structure_target))
				if TestValid(structure_target) then
					if structure_target.Get_Owner() ~= p_owner and structure_target.Get_Owner() ~= p_neutral then
						Try_Ability(Object, ability_name, structure_target)
						break
					end
				end
			end
		end
	end
end
