require("PGStateMachine")
require("PGSpawnUnits")
require("PGMoveUnits")



function Definitions()
  DebugMessage("%s -- In Definitions", tostring(Script))

  Define_State("State_Init", State_Init);
end


function State_Init(message)
 
	DamagedUnitTable = Find_All_Objects_Of_Type("Generic_Star_Destroyer")
	-- Put unit type in here.
		
	for all,Unit in pairs(DamagedUnitTable) do 
	UnitHealth = Unit.Get_Health() 
		if UnitHealth >= 0.5 then
			Hide_Sub_Object(Unit, 1, "objObject05")
		-- Put the objects to be hidden at full health in here.	
		elseif UnitHealth < 0.5 then
		Hide_Sub_Object(Unit, 0, "objObject05")
		-- Unhide them under half health in here.
		end
	end
   
end

