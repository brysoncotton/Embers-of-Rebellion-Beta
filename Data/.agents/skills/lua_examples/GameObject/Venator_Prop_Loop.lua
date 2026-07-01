
require("PGStateMachine")


function Definitions()

	--MessageBox("script attached!")
	Define_State("State_Init", State_Init)

end

function State_Init(message)

	-- prevent this from doing anything in galactic mode
	--MessageBox("%s, mode %s", tostring(Script), Get_Game_Mode())
	if Get_Game_Mode() ~= "Land" then
		ScriptExit()
	end
	Object.Play_Animation("Idle", true, 0)
end
