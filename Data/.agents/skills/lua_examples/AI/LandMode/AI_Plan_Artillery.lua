require("pgevents")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	
	AllowEngagedUnits = false
	IgnoreTarget = true
	Category = "Land_Artillery"
	TaskForce = {
	{
		"MainForce"						
		,"AV7 | HAG | Defoliator | CIS_Defoliator | CA_Artillery | MAL_Rocket_Vehicle | Plasma_Mortar | Parallax_Mobile_Artillery | SPMAG_Walker"..
		"| Imperial_Light_Mobile_Artillery | Imperial_Heavy_Mobile_Artillery | Imperial_Missile_Artillery | MPTL | Tracyaat_Artillery_Platform | VX_Artillery_Droid | Sith_Krath_Artillery = 1,2"
	}
	}

	artillery_flee_range = 400 -- This must be less than the artillery_attack_range for the plan to work
	slack_range = 200
	
	-- for memory pool cleanup
	
	DebugMessage("%s -- Done Definitions", tostring(Script))
end


function MainForce_Thread()
	
	tf = MainForce

	-- Collect the task force and bring in any reinforcements to the current location	
	BlockOnCommand(tf.Produce_Force())
	QuickReinforce(PlayerObject, AITarget, tf)

	-- Set up proximities on each member of the main task force
	for i, unit in (tf.Get_Unit_Table()) do
	
		-- discover the range of the unit if we need to
		if not artillery_attack_range then
			artillery_attack_range = unit.Get_Type().Get_Max_Range()
			DebugMessage("%s-- got artillery range %d", tostring(Script), artillery_attack_range)
			enemy_player = unit.Get_Owner().Get_Enemy()
		end
		
		--Register_Prox(unit, Prox_Enemy_In_Range, artillery_attack_range - slack_range, enemy_player)
		Register_Prox(unit, Prox_Enemy_In_Range, artillery_attack_range, enemy_player)
		Register_Prox(unit, Prox_Enemy_Too_Close, artillery_flee_range, enemy_player)
		
	end
	
	-- Move to the plan's original attack location.
	tf.Set_As_Goal_System_Removable(false)
	good_loc = AITarget
	SafeApproach(good_loc)

	-- Repeat as long as a good attack position exists.
	while good_loc do

		EvadeUntilSafe(tf)

		-- Attack the nearest good target, but stop advancing if any enemies come in range
		best_target = FindTarget(tf, "Should_Destroy_Land_Unit", "Enemy_Unit | Enemy_Structure", 1.0, artillery_attack_range + slack_range)
		if TestValid(best_target) then
			enemies_in_range = false
			BlockOnCommand(tf.Attack_Target(best_target, 10), -1, Enemies_In_Range) 
			tf.Move_To(tf)
		else
			best_target = FindTarget(tf, "Should_Destroy_Land_Unit", "Enemy_Unit | Enemy_Structure", 1.0)
			if TestValid(best_target) then
				--MessageBox("%s--moving to target:%s", tostring(Script), tostring(best_target))
				enemies_in_range = false
				BlockOnCommand(tf.Attack_Target(best_target, 10), -1, Enemies_In_Range)
				tf.Move_To(tf)
			end
		end
		
		if EvaluatePerception("Good_Artillery_Area", PlayerObject, good_loc) ~= 0 then

			-- We're in a good place.  Just continue to attack our last target until threatened.
			if TestValid(best_target) then
				enemies_near = false
				BlockOnCommand(tf.Attack_Target(best_target, 10), -1, Threatened)
			end
		else

			-- Find a new attack position because the current one has become useless
			good_loc = FindTarget(tf, "Good_Artillery_Area", "Tactical_Location", 0.7)
			if good_loc then
				SafeApproach(good_loc)
			else
				
				-- Apparently this plan now sucks.  Hide the artillery and abort.
				hiding_loc = FindTarget(MainForce, "Current_Friendly_Location", "Tactical_Location", 1.0, 5000.0)
				BlockOnCommand(tf.Move_To(hiding_loc, 10))
				break
			end
		end
		
		-- Yield to other systems, in case nothing else in this loop does.
		Sleep(2)
	end
	
	ScriptExit()
end


--Reapproach if enemies are already within range, otherwise edge up to them.
function SafeApproach(loc)
	if Enemies_In_Range() then
		BlockOnCommand(tf.Attack_Move(good_loc, 10))
	else
		BlockOnCommand(tf.Attack_Move(good_loc, 10), -1, Enemies_In_Range)
	end
end

--function Artillery_Behavior(tf)
--end


-- Keeps the task force running away from enemies.  
-- Should land the task force in a good attack location. 
-- Updates good_loc var and resets enemies_near to false.
function EvadeUntilSafe(tf)

	-- Evade as long as we have an enemy whose threat we're tracking and a nearby enemy
	deadly_enemy = FindDeadlyEnemy(tf)
	while deadly_enemy or enemies_near do
	
		-- Run from any attacker.
		if TestValid(deadly_enemy) then
			BlockOnCommand(tf.Move_To(Project_By_Unit_Range(deadly_enemy, tf), 10))
		end

		-- Further measures if there's still an enemy close
		if enemies_near then
		
			--Move to friendlies
			good_loc = FindTarget(tf, "Current_Friendly_Location", "Tactical_Location", 0.7)
			if good_loc then
				BlockOnCommand(tf.Move_To(good_loc, 10))
			end
		end

		enemies_near = false
		deadly_enemy = FindDeadlyEnemy(tf)
	end
	
end


function Prox_Enemy_In_Range(self_obj, enemy_obj)
	enemies_in_range = true
end


function Enemies_In_Range()
	return enemies_in_range
end


function Prox_Enemy_Too_Close(self_obj, enemy_obj)
	enemies_near = true
end


function Enemies_Are_Near()
	return enemies_near
end


-- Something has come too close or attacked us
function Threatened()
	return enemies_near or TestValid(FindDeadlyEnemy(tf))
end

