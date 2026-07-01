require("PGStoryMode")
require("PGBase")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")

function Definitions()
	Define_State("State_Init", State_Init)
end

function State_Init(message)
	if message == OnEnter then
		if Get_Game_Mode() ~= "Space" then
			ScriptExit()
		end

		Object.Change_Owner(Find_Player("Neutral"))

		if TestValid(Find_First_Object("YULAREN_RESOLUTE"))
		or TestValid(Find_First_Object("YULAREN_INTEGRITY"))
		or TestValid(Find_First_Object("COBURN_VENATOR"))
		or TestValid(Find_First_Object("TENANT_VENATOR"))
		or TestValid(Find_First_Object("AUTEM_VENATOR"))
		or TestValid(Find_First_Object("KILIAN_ENDURANCE"))
		or TestValid(Find_First_Object("WIELER_RESILIENT")) then
			Hide_Sub_Object(Object, 0, "Venator_00_OCA")
			Hide_Sub_Object(Object, 1, "Venator_00")
			death_clone_gamble = GameRandom.Free_Random(0, 4)
			BlockOnCommand(Object.Play_Animation("DIE", false, death_clone_gamble))
			Object.Despawn()
			ScriptExit()
		elseif TestValid(Find_First_Object("WESSEX_REDOUBT"))
		or TestValid(Find_First_Object("ONARA_KUAT_PRIDE_OF_THE_CORE")) then
			Hide_Sub_Object(Object, 0, "Venator_00_KDY")
			Hide_Sub_Object(Object, 1, "Venator_00")
			death_clone_gamble = GameRandom.Free_Random(0, 4)
			BlockOnCommand(Object.Play_Animation("DIE", false, death_clone_gamble))
			Object.Despawn()
			ScriptExit()
		elseif TestValid(Find_First_Object("TARKIN_VENATOR"))
		or TestValid(Find_First_Object("MAARISA_RETALIATION")) then
			Hide_Sub_Object(Object, 0, "Venator_00_ORSF")
			Hide_Sub_Object(Object, 1, "Venator_00")
			death_clone_gamble = GameRandom.Free_Random(0, 4)
			BlockOnCommand(Object.Play_Animation("DIE", false, death_clone_gamble))
			Object.Despawn()
			ScriptExit()
		elseif TestValid(Find_First_Object("GRANT_VENATOR")) then
			Hide_Sub_Object(Object, 0, "Venator_00_Tapani")
			Hide_Sub_Object(Object, 1, "Venator_00")
			death_clone_gamble = GameRandom.Free_Random(0, 4)
			BlockOnCommand(Object.Play_Animation("DIE", false, death_clone_gamble))
			Object.Despawn()
			ScriptExit()
		else
			death_clone_gamble = GameRandom.Free_Random(0, 4)
			BlockOnCommand(Object.Play_Animation("DIE", false, death_clone_gamble))
			Object.Despawn()
			ScriptExit()
		end
	end
end
