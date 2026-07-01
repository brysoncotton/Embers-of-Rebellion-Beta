require("PGStateMachine")

function Definitions()
	Define_State("State_Init", State_Init)
	retreating_allowed = false
	
	fire_cycle_one = false
	fire_cycle_two = false
	fire_cycle_three = false
	fire_cycle_end = false
	
end

function State_Init(message)
	if Get_Game_Mode() ~= "Land" then
		ScriptExit()
	end

	if message == OnEnter then
		cycle_choice = GameRandom.Free_Random(1, 3)
		if cycle_choice == 1 then
			Create_Thread("Cycle_One_Begins")
		elseif cycle_choice == 2 then
			Create_Thread("Cycle_Two_Begins")
		elseif cycle_choice == 3 then
			Create_Thread("Cycle_Three_Begins")
		end
	elseif message == OnUpdate then
		if Object.Get_Hull() <= 0.90 then
			Create_Thread("Fire_Cycle_End_Begins")
		end
	end
end

function Cycle_One_Begins()
	if message == OnEnter then
		fire_cycle_one = true
		Sleep(15)

		Object.Play_Animation("Idle", false)
		Sleep(10)

		cycle_choice = GameRandom.Free_Random(1, 2)
		if cycle_choice == 1 then
			Create_Thread("Cycle_Two_Begins")
		elseif cycle_choice == 2 then
			Create_Thread("Cycle_Three_Begins")
		end
	end
end

function Cycle_Two_Begins()
	if message == OnEnter then
		fire_cycle_two = true
		Sleep (30)

		Object.Play_Animation("Idle", false)
		Sleep (10)

		cycle_choice = GameRandom.Free_Random(1, 2)
		if cycle_choice == 1 then
			Create_Thread("Cycle_One_Begins")
		elseif cycle_choice == 2 then
			Create_Thread("Cycle_Three_Begins")
		end
	end
end

function Cycle_Three_Begins()
	if message == OnEnter then
		fire_cycle_Three = true
		Sleep (45)
	
		Object.Play_Animation("Idle", false)
		Sleep (10)
		
		cycle_choice = GameRandom.Free_Random(1, 2)
		if cycle_choice == 1 then
			Create_Thread("Cycle_One_Begins")
		elseif cycle_choice == 2 then
			Create_Thread("Cycle_Two_Begins")
		end
	end
end

function Fire_Cycle_End_Begins()
	fire_cycle_end = true
	ScriptExit()
end