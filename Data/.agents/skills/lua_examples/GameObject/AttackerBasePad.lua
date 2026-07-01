require("PGStateMachine")
require("PGStoryMode")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	Define_State("State_Init", State_Init);
	Define_State("State_Waiting_For_Control", State_Waiting_For_Control);
	Define_State("State_Controlled", State_Controlled);

end

function State_Init(message)
	if message == OnEnter then
			Sleep(1)
			elseif message == OnUpdate then
			faction = Object.Get_Owner().Get_Faction_Name()
			if faction == "EMPIRE" then	
			Object.Disable_Capture(true)	
			structure = Find_First_Object("Field_Base_Pad")
			pad_list = Find_All_Objects_Of_Type("Attacker Entry Position")
				for i,pad in pairs(pad_list) do
				Create_Generic_Object("Field_Base_Pad", pad, structure.Get_Owner())
				Object.Take_Damage(10001)
				Sleep(900)
			end	
		end
	end
end