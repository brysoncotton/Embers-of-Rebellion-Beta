--INSTRUCTIONS FOR ADDING CUSTOM GC END STRINGS:
--Table EndScreenMessages is nested in order Storyline > Human Player > Ending.

--//Storyline// is a GlobalValue. If nil, DEFAULT_STORY is used. It can be set or reset freely anywhere a GlobalValue can be modifed, but generally if 
--you want a GC not to use DEFAULT_STORY, you should set it to the desired value in the GC Player Agnostic script in the "Begin_GC" function. For instance, 
--all historicals use GlobalValue.Set("STORYLINE","LIMITED_SCOPE") unless they use their own bespoke storyline.

--//Human Player// accepts aliases such as "IMPERIAL" and can also be modified by the function Mod_Specific_Faction_Name_Overrides to cause certain in-game
--actions to override the human player's faction to something different, such as turning FOTR Hutt Cartels into Shadow Collective or TR Zsinj Empire into 
--Zann Empire. If there are multiple ending groups within a storyline that the human faction qualifies for, priority goes:
--    Override > Faction True Name > Faction Alias
--For example, if a TR storyline had endings for ZSINJ_EMPIRE, ZANN_EMPIRE, and IMPERIAL, a player who wins the GC as the brown warlord faction with Zsinj 
--dead, Zann alive, and no Legitimacy regime leader alive will get a ZANN_EMPIRE ending.

--//Ending// is also a GlobalValue. If nil, there are 2 options: DEFAULT_WIN when the human player is the last player to take a planet, DEFAULT_LOSE when
--an AI player is the last player to take a planet and there is not an Ending defined for that AI player for that Human Player in that Storyline. 
--Buildable victory objects such as Shipyard_Victory_Object and Treaty_Victory_Object have Ending values set by the victory handler plugin, but you can set
--or reset Ending whenever a GlobalValue can be modified. Endings named for factions that are not the Human Player are used when the human loses and the
--named faction is the last player to take a planet. The Ending parameter supports aliases (such as "IMPERIAL") in the same manner as the Human Player
--parameter. For instance, in storyline "CAAMAS_CRISIS," Human Player "REBEL" has unique endings for defeat at the hands of the Empire and the EOTH.

--Mod-specific events that can change ending strings are defined in functions Mod_Specific_Faction_Name_Overrides and Mod_Specific_End_Modifiers.
--Placeholdeer strings can be used to dynamically fill in certain variables - all mods support the following placeholder strings:
--    Human Player Name
--    Last Lose Player Name
--    Last Gain Player Name
--The specific length of the placeholder string used for these variables depends on the mod. The length of the placeholder string is equal to the longest
--string that can be substituted in its place. This is necessary because the endings are strictly limited to 217 characters (excluding any control or
--escape characters; special characters like line breaks denoted by "\n" are counted as a single character).

--Determining what default will be selected for each of the three parameters can be difficult. The code is in function Galactic_Conquest_End_Message.
--An example of complex inheritance leveraging default values can be seen in TR Storyline "OPERATION_SHADOW_HAND." There is no ending defined for a human
--player Rebel who is defeated by Palpatine or one of the warlord factions. If none of the endings defined for this storyline for this player are
--triggered, the endings will be drawn from the DEFAULT_STORY storyline for a Rebel human player, which has a specific ending for defeat at the hands of 
--Palpatine and an alias ending for defeat at the hands of an Imperial faction not otherwise specified.

require("eawx-util/StringUtil")

function Get_End_Screen_Messages()
--text char limit 217            = "X                                                                                                                                                                                                                       X",
	EndScreenMessages = {
		["DEFAULT_STORY"] = {
			["DEFAULT_PLAYER"] = {
				["DEFAULT_WIN"]  = "You have led HUMAN_PLAYER_ to defeat LAST_LOSE_PLA. The future of the Galaxy belongs to you.",
				["SHIPYARD"]     = "Control of the major shipyards of the galaxy has given HUMAN_PLAYER_ the power to cut off any rival from interstellar trade and communications on a whim. Galactic hegemony is yours.",
				["DEFAULT_LOSE"] = "This war has left HUMAN_PLAYER_ in ruins. It seems it was the Galaxy's destiny to be ruled by LAST_GAIN_PLA.",
			},
			["REBEL"] = {
				["DEFAULT_WIN"]  = "The Confederacy has triumphed over LAST_LOSE_PLA, securing for all systems the right to make their own contracts with our loyal corporate allies. Corrupt bureaucrats will no longer interfere with the freedom of trade.",
				["SHIPYARD"]     = "By seizing the major shipyards of the galaxy, the Confederacy and its allies have forced LAST_LOSE_PLA to negotiate. Either they will sign a treaty that respects the freedom of enterprise or suffer endless blockade.",
				["EMPIRE"]       = "The Republic and their Jedi dogs may have overthrown the Confederacy, but as long as there are sapients who believe in the freedom of entrepreneurs to turn an honest profit in a free market, our cause will rise again.",
				["HUTT_CARTELS"] = "The galaxy belongs to the Hutts. This is not the outcome anyone expected when this war began, but all is not lost. They say everyone has a price - the Hutts are proud to advertise theirs, and it's quite affordable...",
				["SHADOW_COLL"]  = "The galaxy seems to belong to the Hutts, but they could not have taken these actions on their own. Something moves in the shadows behind them; a phantom menace even more powerful than Lord Sidious. The future is dark.",
			},
			["EMPIRE"] = {
				["DEFAULT_WIN"]  = "LAST_LOSE_PLA and all other enemies of democracy have been defeated. The Grand Army occupies huge swathes of the Galaxy. Now the Senate can ask the Chancellor to hold new elections and return the Republic to normalcy.",
				["SHIPYARD"]     = "The Grand Army has occupied the industrial heart of the Galaxy. From this position of strength, we will offer LAST_LOSE_PLA the choice of unconditional surrender or bombardment into rubble. Long live the Republic!",
				["REBEL"]        = "The CIS has forced the Senate to sign a treaty that outlaws the Jedi, forbids nearly all regulation of commerce and industry, and permits any system to secede at will. The Republic will not survive this humiliation.",
				["HUTT_CARTELS"] = "Democracy has fallen. The former citizens of the Republic are now little more than slaves of the Hutts. Though the Confederate corporations may have been more rapacious, the Hutts are more cruel. Our future is bleak.",
				["SHADOW_COLL"]  = "Democracy has fallen. The former citizens of the Republic are now little more than slaves of the Hutts. Yet, the Hutts are fearful - as though they, too, are slaves. Who or what could be the true ruler of the Galaxy?",
			},
			["HUTT_CARTELS"] = {
				["DEFAULT_WIN"]  = "We Hutts are not conquerors by nature, but we have nonetheless gained mastery of the Galaxy by the incompetence of lesser beings. Perhaps we shall invite some of the more useful species to sign a new Treaty of Vontor.",
				["SHIPYARD"]     = "The Hutt Cartels have an iron grip on the major shipyards of the galaxy. Though other states remain, none dare oppose us or our business ventures. We were rich - now our wealth will grow beyond measure.",
				["DEFAULT_LOSE"] = "This is an expensive setback to be sure, but we will return to the shadows, rebuild, and await our next opportunity. The Hutt Cartels will survive. You, however, will not. Your failure has angered the Grand Council...",
			},
			["SHADOW_COLL"] = {
				["DEFAULT_WIN"]  = "Maul's rage and burning desire for revenge gave him the strength to overcome every obstacle in his path. He has had his vengeance on Kenobi, the Jedi, and Sidious - now, he rules the Galaxy from his shadowed throne.",
				["SHIPYARD"]     = "Maul's actions have thwarted the Sith Grand Plan. Darth Sidious faces his former apprentice warily, knowing the Jedi still hunt them both. For now, Maul has the upper hand, but neither can foresee the final outcome.",
				["DEFAULT_LOSE"] = "In his arrogance, Maul fancied himself a rival to Darth Sidious, but his schemes burned to ash in the flame of Sidious' power. Now, Maul calls Sidious \"Master\" once more and begs for the mercy of a quick death.",
			},
		},
		["LIMITED_SCOPE"] = {
			["DEFAULT_PLAYER"] = {
				["DEFAULT_WIN"]  = "HUMAN_PLAYER_ has triumphed in this campaign and shifted the war in its favor. LAST_LOSE_PLA is not beaten and will surely seek to avenge this loss, but the road to final victory is paved with battles such as these.",
				["SHIPYARD"]     = "With control of the shipyards, HUMAN_PLAYER_ has seized a decisive strategic advantage in this theater and forced LAST_LOSE_PLA to cease their offensive. The war rages on, but these sectors have earned a reprieve.",
				["HUTT_CARTELS"] = "Our intelligence never indicated that the Hutts had substantial forces in the area, much less that they were on the warpath. We have no choice but to withdraw from this region. This is a strange turn of events indeed.",
				["DEFAULT_LOSE"] = "LAST_GAIN_PLA may have defeated HUMAN_PLAYER_ today, but this only serves to bring the unseen puppetmaster's plot a step closer to fruition. When the game ends, pawns on the winning side will not share in the victory.",
			},
			["HUTT_CARTELS"] = {
				["DEFAULT_WIN"]  = "The Republic and CIS have exhausted their forces and we've driven them out - now these sectors know peace under Hutt law. From here, the kajidics stand ready to spread our rule across the Galaxy, one system at a time.",
				["SHIPYARD"]     = "While our rivals were busy, we took the key shipyards of this region. It would be unprofitable to have more war here, so we have denied shipyard services to the enemy fleets, forcing them to halt their offensives.",
				["DEFAULT_LOSE"] = "LAST_GAIN_PLA may have thwarted our attempts to expand Hutt influence in this region, but it is of little concern. There will be other opportunities to profit from this war, and we Hutts are nothing if not patient.",
			},
			["SHADOW_COLL"] = {
				["DEFAULT_WIN"]  = "The Republic and CIS have exhausted their forces and we've driven them out. This victory brings Maul one step closer to his vengeance on his former master, but Darth Sidious is still beyond his reach... For now...",
				["SHIPYARD"]     = "While Darth Sidious was busy playing the Republic and CIS against each other, Lord Maul seized the key shipyards of this region. Now Sidious' puppets flop uselessly, their strings cut. Maul's final revenge draws near.",
				["DEFAULT_LOSE"] = "LAST_GAIN_PLA has thwarted Maul's attempts to expand his influence in this region - for now. This was not the only opportunity to undermine Darth Sidious' plans, and Maul has learned to temper his rage with patience.",
			},
		},
		["ORDER_66_STORY"] = {
			["REBEL"] = {
				["DEFAULT_WIN"]  = "Whether it was a Republic or an Empire in its death throes is irrelevant; Palpatine is dead. The Confederacy and its benefactors now oversee a galaxy in which all beings are free to participate in the free market.",
				["SHIPYARD"]     = "The Republic has made itself an \"Empire\" and slaughtered its Jedi, but the CIS holds all major shipyards. For all its bluster, the so-called \"New Order\" is powerless to oppose us. Lord Sidious will surely be pleased.",
				["EMPIRE"]       = "Everything has gone wrong. Count Dooku, General Grievous, and the Separatist Council are dead. How can this be? Lord Sidious assured us that peace would come soon after the Republic was reorganized into an Empire...",
			},
			["EMPIRE"] = {
				["DEFAULT_WIN"]  = "The war was long and costly, but the Empire has delivered us from droids, traitors, criminals, and the limitless incompetence of the Senate. Only the New Order could have achieved this. Long live Emperor Palpatine!",
				["SHIPYARD"]     = "The Empire has torn out the economic heart of the CIS and forced their surrender. Reconstruction of the ex-Confederate systems may take decades, but the Galaxy will be healed under the benevolent rule of the Emperor.",
				["REBEL"]        = "Though the Emperor foiled their plot, the Jedi betrayal crippled the Imperial Army. The Confederacy has ordered the dissolution of the Imperial Senate and the Emperor has vanished into CIS custody. We fear the worst.",
				["HUTT_CARTELS"] = "No one could have foreseen that without the Jedi, the Empire would be crushed by the Hutts. The Emperor is missing, and his New Order that was supposed to protect us more effectively than the old Republic has failed.",
				["SHADOW_COLL"]  = "The ancient way of the Sith is for the apprentice to rise above and slay the master, but never has this cycle played out on such a grand scale. Now, Maul is the undisputed master - of the Sith Order and of the Galaxy.",
			},
			["SHADOW_COLL"] = {
				["DEFAULT_WIN"]  = "Darth Sidious believed himself to be the Sith'ari, but now he and the false Sith Tyranus and Vader lie dead. Fueled by rage, Maul has clawed his way out of the junkyard to become the master of the Sith and the Galaxy.",
				["SHIPYARD"]     = "Sidious was wrong to underestimate Maul. Now Maul controls the major shipyards of the galaxy and has has forced his former master into a standoff. The two Sith circle each other warily, looking for any opportunity.",
			},
		},
		["ORDER_65_STORY"] = {
			["REBEL"] = {
				["DEFAULT_WIN"]  = "The Jedi coup against Chancellor Palpatine only hastened the disintegration of the Republic. The Confederacy and its benefactors now oversee a galaxy in which all beings are free to participate in the free market.",
				["SHIPYARD"]     = "After the Jedi overthrew Palpatine, the cowards of the Republic Senate begged us for peace. Of course, with our control of the Galaxy's shipyards, they had no choice. We will offer them generous terms of surrender.",
				["EMPIRE"]       = "The Republic found new resolve after the Jedi dethroned Chancellor Palpatine. Where once our droids were an even match for their clones, our forces crumbled. Now all is lost. Lord Sidious has abandoned us to our fate.",
			},
			["EMPIRE"] = {
				["DEFAULT_WIN"]  = "Palpatine and his puppet Dooku are no more. The Clone Wars brought the Republic closer to destruction than ever before, but thanks to the Jedi Master Anakin Skywalker, disaster was averted. The future is bright.",
				["SHIPYARD"]     = "With Darth Sidious unmasked and the Republic in control of the Galaxy's major shipyards, Chancellor Mothma has sent envoys to the Confederate Senate with proof of the Sith scheme. Peace negotiations will soon begin.",
				["REBEL"]        = "Though Darth Sidious was exposed, the Confederacy proved too strong for the Republic to overcome. The droids gunned down the last of the Jedi. Now the Separatist Council and its hidden benefactors rule the Galaxy.",
				["HUTT_CARTELS"] = "Though the Sith plot to end the Republic was foiled, still the Republic fell. No one could have foreseen that a less mystical, more venal evil would achieve what the Sith could not. The Galaxy belongs to the Hutts.",
				["SHADOW_COLL"]  = "It wasn't enough to defeat one Sith Lord, for there are always two. The Jedi overcame Darth Sidious, but Maul proved to be even more dangerous. The Grand Plan was foiled, yet a Sith Lord rules the Galaxy nonetheless.",
			},
			["SHADOW_COLL"] = {
				["DEFAULT_WIN"]  = "First defeated by Skywalker and then humiliated by Maul, Darth Sidious' failure is complete. The Galaxy does not belong to the Republic, Empire, Confederacy, Hutts, Jedi, or Sith - the Galaxy belongs to Lord Maul!",
				["SHIPYARD"]     = "With Palpatine overthrown and the shipyards of the galaxy in Hutt hands, the Republic and CIS have called a truce. The Hutts have offered to mediate a treaty - one that will serve the interests of their hidden master.",
				["DEFAULT_LOSE"] = "The Jedi thwarted Darth Sidious' scheme to eradicate them and transform the Republic into an Empire, but that didn't save Maul from LAST_GAIN_PLA onslaught that broke his power base and drove him back into hiding.",
			},
		},
	}

	return EndScreenMessages
end

function Mod_Specific_Faction_Name_Overrides(faction_name,storyline)
	if faction_name == "EMPIRE" then
		local storyline = GlobalValue.Get("STORYLINE")
		if storyline == "ORDER_65_STORY" then
			faction_name = "ORDER_65_P"
		elseif storyline == "ORDER_66_STORY" then
			faction_name = "ORDER_66_P"
		end
	elseif faction_name == "HUTT_CARTELS" and GlobalValue.Get("SHADOW_COLLECTIVE") == true then
		faction_name = "SHADOW_COLL"
	end

	return faction_name, nil
end

function Mod_Specific_End_Modifiers(end_screen_message,storyline)
	local FactionEndStrings = {
		EMPIRE           = "the Republic",
		ORDER_65_P       = "the Republic",
		ORDER_66_P       = "the Empire",
		SECTOR_FORCES    = "the Republic",
		REBEL            = "the CIS",
		BANKING_CLAN     = "the CIS",
		COMMERCE_GUILD   = "the CIS",
		TRADE_FEDERATION = "the CIS",
		TECHNO_UNION     = "the CIS",
		HUTT_CARTELS     = "the Hutts",
		SHADOW_COLL      = "Maul's allies",
	}

	local human_faction_name = Mod_Specific_Faction_Name_Overrides(Find_Player("local").Get_Faction_Name(),storyline)
	local faction_name
	local faction_string

	if string.find(end_screen_message,"HUMAN_PLAYER_") then
		faction_name = human_faction_name
		if faction_name == nil or FactionEndStrings[faction_name] == nil then
			faction_string = "our faction"
		else
			faction_string = FactionEndStrings[faction_name]
		end
		end_screen_message = string.gsub(end_screen_message,"HUMAN_PLAYER_",faction_string)
	end

	if string.find(end_screen_message,"LAST_LOSE_PLA") then
		local last_lose_player_name = GlobalValue.Get("LAST_LOSE_PLAYER_NAME")
		if last_lose_player_name == nil then
			last_lose_player_name = Find_Player("local").Get_Faction_Name()
		end
		
		faction_name = Mod_Specific_Faction_Name_Overrides(last_lose_player_name,storyline)
		if faction_name == nil or FactionEndStrings[faction_name] == nil or faction_name == human_faction_name then
			faction_string = "the enemy"
		else
			faction_string = FactionEndStrings[faction_name]
		end

		--if a human CIS wins by taking a sub's planet last or a human GAR wins by taking a SF planet last
		if faction_string == FactionEndStrings[human_faction_name] then
			faction_string = "the enemy"
		end

		end_screen_message = string.gsub(end_screen_message,"LAST_LOSE_PLA",faction_string)
	end

	if string.find(end_screen_message,"LAST_GAIN_PLA") then
		local last_gain_player_name = GlobalValue.Get("LAST_GAIN_PLAYER_NAME")
		if last_gain_player_name == nil then
			last_gain_player_name = Find_Player("local").Get_Faction_Name()
		end

		faction_name = Mod_Specific_Faction_Name_Overrides(last_gain_player_name,storyline)
		if faction_name == nil or FactionEndStrings[faction_name] == nil then
			faction_string = "the enemy"
		else
			faction_string = FactionEndStrings[faction_name]
		end
		end_screen_message = string.gsub(end_screen_message,"LAST_GAIN_PLA",faction_string)
	end

	return CapitalizeFirstCharacterOfEachSentence(end_screen_message)
end
