--******************************************************************************
--     _______ __
--    |_     _|  |--.----.---.-.--.--.--.-----.-----.
--      |   | |     |   _|  _  |  |  |  |     |__ --|
--      |___| |__|__|__| |___._|________|__|__|_____|
--     ______
--    |   __ \.-----.--.--.-----.-----.-----.-----.
--    |      <|  -__|  |  |  -__|     |  _  |  -__|
--    |___|__||_____|\___/|_____|__|__|___  |_____|
--                                    |_____|
--*   @Author:              [TR]Pox
--*   @Date:                2017-12-18T22:57:21+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            RaidFleet.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2017-12-21T12:32:03+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

function MakeRaidFleet(chance)
    local RaidFleet = {}
    RaidFleet.chance = chance
    RaidFleet.spawnList = {}
    RaidFleet.completedListener = nil
	Objective_Name = "TEXT_TACTICAL_SECONDARY_SPACE_RAID"

    RaidFleet.factions = {
        "Rebel",
        "Empire",
        "EmpireoftheHand",
        "Pirates",
        "Pentastar",
        "Warlords",
        "Teradoc",
        "Hutts",
        "Hapes_Consortium",
        "Corporate_Sector"
    }
    RaidFleet.unit_types = {}

    function RaidFleet:setCompletedListener(listener)
        self.completedListener = listener
    end

    function RaidFleet:initialize()
        self:determineBattler()
        self:determineBattler()
        local raider = GameRandom(1, table.getn(self.unit_types))
        local entry = Find_First_Object("Attacker Entry Position")
        local moveto = Find_First_Object("Space Station Position")
        self:randomSpawn(self.unit_types[raider], entry, moveto, self.chance, 10)
    end

    function RaidFleet:determineBattler()
        for j, faction in pairs(self.factions) do
            if table.getn(Find_All_Objects_Of_Type(Find_Player(faction))) > 0 then
                table.remove(self.factions, j)
                table.remove(self.unit_types, j)
                break
            end
        end
    end

    function RaidFleet:randomSpawn(unit_list, spawnpoint, target, chance, max_ship_number)
        if type(unit_list) == "table" then
            local attack_chance = GameRandom(1, 100)
            local anzahl = GameRandom(3, max_ship_number)
            local spawnliste = {}
            local count = 0
            local invaders = Find_Player("Hostile")

            if attack_chance <= chance then
                repeat
                    local einheit = GameRandom(1, table.getn(unit_list))
                    table.insert(spawnliste, unit_list[einheit])
                    count = count + 1
                until count == anzahl
                Story_Event("NO_RETREAT")

                Register_Timer(startSpeach, 10, nil)
                Register_Timer(spawnFleet, 90, {self, spawnliste, spawnpoint, invaders})
                Register_Timer(enableRetreat, 140, nil)
            else
                --ScriptExit()
            end
        end
    end

    function RaidFleet:cleanUp()
        Story_Event("RESET_AI")
        for j, unit in pairs(self.spawnList) do
            if TestValid(unit) then
                unit.Despawn()
            end
        end
    end

    return RaidFleet
end

function startSpeach()
    Story_Event("START_SPEECH")
	Add_Objective(Objective_Name,false)
end

function spawnFleet(param)
    local self = param[1]
    self.spawnList = SpawnList(param[2], param[3], param[4], true, true)
end

function enableRetreat()
    Story_Event("YES_RETREAT")
end
