require("pgevents")

-- Build a field base.

function Definitions()
	
	Category = "Build_Field_Support_Emplacement"
	TaskForce = {
	{
		"MainForce"					
		,"TaskForceRequired"
		,"UC_Generic_Field_Support_Emplacement = 1"
	}
	}
	pad = nil
	good_pad = nil
end

function MainForce_Thread()	
	-- Make sure we've ended up with a build location that's reasonably close to our original target
	pad_table = MainForce.Get_Reserved_Build_Pads()
	for i,pad in pad_table do
		if pad.Get_Distance(AITarget) > 120 then
			ScriptExit()
		end
	end
	
	-- Build the task force
	-- Blocking shouldn't be necessary, but we'll use it to ease watching the script	
	MainForce.Set_Plan_Result(true)
	BlockOnCommand(MainForce.Build_All())
	ScriptExit()
end