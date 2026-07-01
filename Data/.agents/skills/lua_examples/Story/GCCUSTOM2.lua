require("PGStoryMode")
require("deepcore/crossplot/crossplot")
require("eawx-util/StoryUtil")

function Definitions()

    DebugMessage("%s -- In Definitions", tostring(Script))
	crossplot:galactic()
	crossplot:subscribe("STARTING_SIZE_PICK", Size_Choice)
	crossplot:subscribe("INITIALIZE_AI", Final_Handling)
	
	size_choice = nil
	
    StoryModeEvents = {
		Delayed_Initialize = Initialize
	}
	
end		

function Initialize(message)
    if message == OnEnter then	
	else
		crossplot:update()
    end
end

function Size_Choice(choice)
	p_Republic = Find_Player("Empire")
	if p_Republic.Is_Human() then
		if choice == "CUSTOM_GC_SMALL_START" then
			crossplot:publish("COMMAND_STAFF_DECREMENT", {1,0,2,2,1,1}, 0)
		end
		if choice == "CUSTOM_GC_FTGU" then
			crossplot:publish("COMMAND_STAFF_DECREMENT", {1,1,1,1,1,1}, 0, false, true)
			crossplot:publish("COMMAND_STAFF_DECREMENT", {1,1,1,1,1,1}, 0, true)
			crossplot:publish("COMMAND_STAFF_EXIT", {"Grumby"}, 1)
			crossplot:publish("COMMAND_STAFF_EXIT", {"Seerdon"}, 2)
		end
	end
	if GlobalValue.Get("CURRENT_ERA") > 1 then
		crossplot:publish("VENATOR_HEROES", "empty")
	end
	if GlobalValue.Get("CURRENT_ERA") > 2 then
		crossplot:publish("VICTORY1_HEROES", "empty")
	end
	if GlobalValue.Get("CURRENT_ERA") > 4 then
		crossplot:publish("VICTORY2_HEROES", "empty")
	end
	
	size_choice = choice
end

function Final_Handling()
	local check = Find_First_Object("Ziton_Moj")
	if check ~= nil then
		local Hutts = Find_Player("Hutt_Cartels")
		local techtype = Find_Object_Type("Hutt_Capital")
		Hutts.Lock_Tech(techtype)
		techtype = Find_Object_Type("Hutt_Office")
		Hutts.Lock_Tech(techtype)
		techtype = Find_Object_Type("Shadow_Collective_Capital")
		Hutts.Unlock_Tech(techtype)
		techtype = Find_Object_Type("Shadow_Collective_Office")
		Hutts.Unlock_Tech(techtype)
		local offices = Find_All_Objects_Of_Type("Hutt_Office")
		for _, office in pairs(offices) do
			local locale = office.Get_Planet_Location()
			office.Despawn()
			SpawnList({"Shadow_Collective_Office"}, locale, Hutts, false,false)
		end
		offices = Find_All_Objects_Of_Type("Hutt_Capital")
		for _, office in pairs(offices) do
			local locale = office.Get_Planet_Location()
			office.Despawn()
			SpawnList({"Shadow_Collective_Capital"}, locale, Hutts, false,false)
		end
	end
	
	local Republic = Find_Player("Empire")
	local ranger = Find_Object_Type("Antarian_Ranger_Company")
	if (not (ranger.Is_Build_Locked(Republic) or ranger.Is_Obsolete(Republic))) then
		Republic.Unlock_Tech(Find_Object_Type("Jedi_Ground_Barracks"))
	end
end