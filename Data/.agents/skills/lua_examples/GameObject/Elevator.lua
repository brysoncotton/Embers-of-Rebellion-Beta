--***************************************************--
--***************** Elevator Script *****************--
--***************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	Define_State("State_Init", State_Init)

	elevator_range = 50

end

function State_Init(message)
	if message == OnEnter then

		if Get_Game_Mode() ~= "Land" then
			return
		end

		elevator_exit = Find_First_Object("ELEVATOR_EXIT_MARKER")

		Register_Prox(Object, Unit_Prox, elevator_range)

	end
end

function Unit_Prox(self_obj, trigger_obj)

	if trigger_obj.Is_Category("InfantryHero") then
		trigger_obj.Teleport_And_Face(elevator_exit)
		Sleep(5)
	end

	if trigger_obj.Is_Category("Infantry") then
		trigger_obj = trigger_obj.Get_Parent_Object()
		trigger_obj.Teleport_And_Face(elevator_exit)
		Sleep(5)
	end

	if not elevator_exit then
		return
	end

end

