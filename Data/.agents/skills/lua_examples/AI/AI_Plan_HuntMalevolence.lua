--A plan to hunt the Malevolence.

require("pgtaskforce")

-- Tell the script pooling system to pre-cache this number of scripts.
ScriptPoolCount = 1

function Definitions()	
	MaxContrastScale = 2.0
	MinContrastScale = 1.1
		
	Category = "Hunt_Malevolence"
	TaskForce = {
	{
		"MainForce"
		,"DenyHeroAttach"		
		,"Corvette | Frigate | Capital | SuperCapital  = 100%"
	}
	}
	RequiredCategories = {"Frigate | Capital"}	--we want at least one heavier ship
	
end

function MainForce_Thread()
	
	-- Since we're using plan failure to adjust contrast, we're 
	-- only concerned with failures in battle. Default the 
	-- plan to successful and then 
	-- only on the event of our task force being killed is the
	-- plan set to a failed state.
	MainForce.Set_Plan_Result(true)	
	
	--For fast execution, build and attack in one plan rather than having the first few iterations
	--feed the freestore
	AssembleForce(MainForce)
	
	GlobalValue.Set("CONQUER_OPPONENT", Target.Get_Type().Get_Name())
	BlockOnCommand(MainForce.Move_To(Target))
	
	if MainForce.Get_Force_Count() == 0 then
		DebugMessage("%s -- taskforce destroyed, exiting", tostring(Script))
		MainForce.Set_Plan_Result(false)	
		ScriptExit()
	end
	
	ScriptExit()
end

function MainForce_Production_Failed(failed_object_type)
	ScriptExit()
end

function MainForce_Original_Target_Owner_Changed(tf, old_owner, new_owner)	
	--If we take control of this planet than we'll release our blockading units
	if new_owner == PlayerObject then
		ScriptExit()
	end
end