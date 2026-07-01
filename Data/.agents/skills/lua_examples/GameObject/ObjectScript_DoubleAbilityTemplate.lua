require("PGStateMachine")

function Definitions()

	-- Standard service rate of once per second
	ServiceRate = 1
	
	-- State definitions
	Define_State("State_Init", State_Init);
	Define_State("State_AI_Autofire", State_AI_Autofire)
	Define_State("State_Human_No_Autofire", State_Human_No_Autofire)
	Define_State("State_Human_Autofire", State_Human_Autofire)

	-- Add globals here set to nil or other appropriate values
	ability_one_name = "ABILITY_ONE_NAME"
	ability_two_name = "ABILITY_TWO_NAME"
end

function State_Init(message)
	if message == OnEnter then

		-- prevent this from doing anything in X mode
		if Get_Game_Mode() == "MODE_TO_DISABLE" then
			ScriptExit()
		end
		
		-- Set globals here with initial values if needed
		
		-- Handle object ownership
		if Object.Get_Owner().Is_Human() then
			Set_Next_State("State_Human_No_Autofire")
		else
			Set_Next_State("State_AI_Autofire")
		end
	end
end

-- Standard AI functionality
function State_AI_Autofire(message)
	if message == OnUpdate then
		if Object.Is_Ability_Ready(ability_one_name) then
			-- Ability tests here
			Object.Activate_Ability(ability_one_name, true)
			return
		end
		
		if Object.Is_Ability_Ready(ability_two_name) then
			-- Ability tests here
			Object.Activate_Ability(ability_two_name, true)
			return
		end
		
		-- Optional- Land units can change hands
		if Object.Get_Owner().Is_Human() then
			Set_Next_State("State_Human_No_Autofire")
		end				
	end		
end

-- Standard for players. Sets to human autofire as needed
function State_Human_No_Autofire(message)
	if message == OnUpdate then
		if Object.Is_Ability_Autofire(ability_one_name) or Object.Is_Ability_Autofire(ability_two_name) then
			Set_Next_State("State_Human_Autofire")
		end		
	end
end

function State_Human_Autofire(message)
	if message == OnUpdate then
		-- Check if autofire is on
		if Object.Is_Ability_Autofire(ability_one_name) then
			if Object.Is_Ability_Ready(ability_one_name) then
				-- Ability tests here, usually identical to AI
				Object.Activate_Ability(ability_one_name, true)
				return
			end
		end
		
		if Object.Is_Ability_Autofire(ability_two_name) then
			if Object.Is_Ability_Ready(ability_two_name) then
				-- Ability tests here, usually identical to AI
				Object.Activate_Ability(ability_two_name, true)
				return
			end
		end		
		
		-- Move to no autofire mode if both abilities have autofire turned off
		if not Object.Is_Ability_Autofire(ability_one_name) and not Object.Is_Ability_Autofire(ability_two_name) then
			Set_Next_State("State_Human_No_Autofire")
		end
	end				
end