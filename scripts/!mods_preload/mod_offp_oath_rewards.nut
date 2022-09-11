::mods_queue("of_flesh_and_faith_plus", "", function() {
	::mods_hookNewObject("events/events/special/ambition_fulfilled_event", function(afe) {
		foreach(screen in afe.m.Screens) {
			if (screen.ID == "A") {
				local start = screen.start;

				screen.start = function( _event ) {
					local active = World.Ambitions.getActiveAmbition();
					local isOath = !active.isCancelable() && active.isRepeatable();
					local bonusAchieved = isOath && active.getRenownOnSuccess() > Const.World.Assets.ReputationOnOathAmbition;

					if (isOath && bonusAchieved) {
						local brothers = World.getPlayerRoster().getAll();

						local trait_name = "";
						switch(active.getID()) {
							case "ambition.oath_of_camaraderie":
								trait_name = "oath_of_camaraderie_upheld_trait";
								break;
							case "ambition.oath_of_distinction":
								trait_name = "oath_of_distinction_upheld_trait";
								break;
							case "ambition.oath_of_dominion":
								trait_name = "oath_of_dominion_upheld_trait";
								break;
							case "ambition.oath_of_endurance":
								trait_name = "oath_of_endurance_upheld_trait";
								break;
							case "ambition.oath_of_fortification":
								trait_name = "oath_of_fortification_upheld_trait";
								break;
							case "ambition.oath_of_honor":
								trait_name = "oath_of_honor_upheld_trait";
								break;
							case "ambition.oath_of_humility":
								trait_name = "oath_of_humility_upheld_trait";
								break;
							case "ambition.oath_of_proving":
								trait_name = "oath_of_proving_upheld_trait";
								break;
							case "ambition.oath_of_righteousness":
								trait_name = "oath_of_righteousness_upheld_trait";
								break;
							case "ambition.oath_of_sacrifice":
								trait_name = "oath_of_sacrifice_upheld_trait";
								break;
							case "ambition.oath_of_valor":
								trait_name = "oath_of_valor_upheld_trait";
								break;
							case "ambition.oath_of_vengeance":
								trait_name = "oath_of_vengeance_upheld_trait";
								break;
							case "ambition.oath_of_wrath":
								trait_name = "oath_of_wrath_upheld_trait";
								break;
						}

						foreach(bro in brothers) {
							bro.getSkills().add(new("scripts/skills/traits/" + trait_name));
						}
					}

					start(_event);
				}
				break;
			}
		}
	});

	::mods_hookExactClass("scenarios/world/paladins_scenario", function(ps) {
		local onActorKilled = ::mods_getMember(ps, "onActorKilled");
		local onInit = ::mods_getMember(ps, "onInit");

		::mods_override(ps, "onActorKilled", function( _actor, _killer, _combatID ) {
			onActorKilled(_actor, _killer, _combatID);

			if (!World.Ambitions.hasActiveAmbition())
				return;

			if (_killer == null || _killer.getFaction() != Const.Faction.Player) {
				if (_actor.isPlayerControlled && World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_camaraderie")
					World.Statistics.getFlags().increment("OathOfCamaraderieNewObjective");

				return;
			}

			if (_killer.getFaction() == Const.Faction.Player)
				_killer.getFlags().increment("OathOfProvingKills");
		});

		::mods_override(ps, "onInit", function() {
			if (!(World.Statistics.getFlags().get("OFFPlusOathOfProvingAdded")))
			{
				local oaths = IO.enumerateFiles("scripts/ambitions/additional_oaths");
				foreach ( i, oath in oaths ) {
					local instantiatedOath = new(oath);
					World.Ambitions.m.OathAmbitions.push(instantiatedOath);
				};
			}
			World.Statistics.getFlags().set("OFFPlusOathOfProvingAdded", true);
		});
	});

	// Oath of Camaraderie
	//
	// Burden changed to: -10 Resolve per tile of distance from the nearest ally
	// Bonus objective changed to: Have no more than 2/1/0 men die
	//
	::mods_hookExactClass("ambitions/oaths/oath_of_camaraderie_ambition", function(ooca) {
		::mods_addField(ooca, "oath_of_camaraderie_ambition", "OathBurdenText", "Your men suffer [color=" + Const.UI.Color.NegativeValue + "]-10[/color] Resolve for each tile of distance from the nearest ally.")
		::mods_addField(ooca, "oath_of_camaraderie_ambition", "SuccessText", "[img]gfx/ui/events/event_180.png[/img]{Power in numbers, camaraderie in brotherhood. Initially the men struggled with the larger formations, sure that their comrades would split off and get each other killed. Over the course of every battle, however, the %companyname% quickly realized that the chaos of combat could be overcome by standing shoulder to shoulder with the man beside you, trusting him to do his job and him trusting that you do yours. It matters not if you fight with one man or one hundred, so long as there's an Oathtaker among them.\n\nNow that the company knows it can confront its enemies by trusting its own members, it is ready to take on another Oath!}")

		::mods_override(ooca, "getRenownOnSuccess", function() {
			local additionalRenown = getBonusObjectiveProgress() <= getBonusObjectiveGoal() ? Const.World.Assets.ReputationOnOathBonusObjective : 0;
			return Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
		});

		::mods_override(ooca, "getRewardTooltip", function() {
			local objectiveString = " none of your men die ";
			if (World.Assets.getCombatDifficulty() == Const.Difficulty.Normal)
				objectiveString = " no more than 1 of your men dies ";
			else if (World.Assets.getCombatDifficulty() < Const.Difficulty.Normal)
				objectiveString = " no more than 2 of your men die ";

			return "You gain extra Renown if" + objectiveString + "during the Oath (" + getBonusObjectiveProgress() + " dead so far).";
		});

		::mods_override(ooca, "getBonusObjectiveProgress", function() {
			return World.Statistics.getFlags().getAsInt("OathOfCamaraderieNewObjective");
		});

		::mods_override(ooca, "getBonusObjectiveGoal", function() {
			if (World.Assets.getCombatDifficulty() >= Const.Difficulty.Hard)
				return 0;
			else if (World.Assets.getCombatDifficulty() >= Const.Difficulty.Normal)
				return 1;
			else
				return 2;
		});

		::mods_override(ooca, "onStart", function() {
			onStart();
			World.Statistics.getFlags().set("OathOfCamaraderieNewObjective", 0);
		});
	});

	::mods_hookExactClass("skills/traits/oath_of_camaraderie_trait", function(ooct) {
		::mods_addField(ooct, "oath_of_camaradere_trait", "Description", "This character has taken an Oath of Camaraderie, and is sworn to stand together with his allies against all odds. Unconvinced of their ability to survive away from his protection, and equally suspicious of their helpfulness if he gets cut off, he's more nervous than usual about getting separated from the rest of the men.")

		local getTooltip = ::mods_getMember(ooct, "getTooltip");
		local onUpdate = ::mods_getMember(ooct, "onUpdate");

		::mods_override(ooct, "getTooltip", function() {
			local ret = getTooltip();
			ret.pop();
			ret.push({ id = 10, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-10[/color] Resolve for each tile of distance from the closest ally." });
			return ret;
		});

		::mods_override(ooct, "onUpdate", function( _properties ) {
			// Don't run the original onUpdate at all
			local actor = getContainer().getActor();

			if (!actor.isPlacedOnMap())
				return;

			local myTile = actor.getTile();
			local allies = Tactical.Entities.getInstancesOfFaction(actor.getFaction());
			local smallestDistance = 9999;

			foreach( ally in allies )
			{
				if (ally.getID() == actor.getID() || !ally.isPlacedOnMap())
					continue;

				if (ally.getTile().getDistanceTo(myTile) < smallestDistance)
				{
					smallestDistance = ally.getTile().getDistanceTo(myTile);
					if (smallestDistance <= 1)
						break;
				}

				_properties.Bravery -= (smallestDistance - 1) * 10;
			}
		});
	});

	// Oath of Distinction
	//
	// XP mechanics changed so bro gets all XP from kills, but has 50% reduced XP gain
	//
	::mods_hookExactClass("ambitions/oaths/oath_of_distinction_ambition", function(ooda) {
		::mods_addField(ooda, "oath_of_distinction_ambition", "OathBurdenText", "Your men gain [color=" + Const.UI.Color.NegativeValue + "]50%[/color] less experience and do not share experience with allies.")
	});

	::mods_hookExactClass("skills/traits/oath_of_distinction_trait", function(oodt) {
		local getTooltip = ::mods_getMember(oodt, "getTooltip");
		local onUpdate = ::mods_getMember(oodt, "onUpdate");

		::mods_override(oodt, "getTooltip", function() {
			local ret = getTooltip();

			ret.push({ id = 12, type = "text", icon = "ui/icons/xp_received.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-50%[/color] XP Gain" });

			return ret;
		});

		::mods_override(oodt, "onUpdate", function( _properties ) {
			onUpdate(_properties);

			_properties.XPGainMult /= 1.5;
			_properties.XPGainMult *= 0.5;
		});
	});

	::mods_hookExactClass("entity/tactical/player", function(p) {
		local onActorKilled = ::mods_getMember(p, "onActorKilled");
		local checkMorale = ::mods_getMember(p, "checkMorale");

		::mods_override(p, "onActorKilled", function( _actor, _tile, _skill ) {
			if (!getSkills().hasSkill("trait.oath_of_distinction")) {
				onActorKilled(_actor, _tile, _skill);
				return;
			}

			actor.onActorKilled(_actor, _tile, _skill);
			addXP(_actor.getXPValue());
		});

		::mods_override(p, "checkMorale", function(_change, _difficulty, _type = Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false) {
			if(_change < 0 && m.Skills.hasSkill("trait.oath_of_camaraderie_upheld")) {
				local numAlliesAdjacent = 0;
				local myTile = getTile();

				for(local i=0; i != 6; ++i) {
					if(!myTile.hasNextTile(i))
						continue;

					local tile = myTile.getNextTile(i);

					if(tile.IsOccupiedByActor && tile.getEntity().getMoraleState() != Const.MoraleState.Fleeing && tile.getEntity().isAlliedWith(this))
						++numAlliesAdjacent;
				}

				_difficulty += numAlliesAdjacent * 2;
			}

			return checkMorale(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);
		})
	});

	// Oath of Fortification
	//
	// Bonus objective: defeat 6/7/8 enemy camps, either as part of contracts of your own initiative
	//
	::mods_hookExactClass("ambitions/oaths/oath_of_fortification_ambition", function(oofa) {
		local onStart = ::mods_getMember(oofa, "onStart");

		::mods_addField(oofa, "oath_of_fortification_ambition", "SuccessText", "[img]gfx/ui/events/event_180.png[/img]{A wise warrior once said 'The walls of the earth will never rival the walls within man himself.' The %companyname% put that to the test in fulfilling the Oath of Fortification. Again and again you assailed the walls of villains and monsters with a wall of your own, and each time yours was proven stronger. It always took a few moments to piece the elements together, but once your shieldwall formed it crushed those before it as readily as a boulder would an ant. Now with the walls of your enemies lain low, it's time to move on to the next Oath!}")

		::mods_override(oofa, "getRenownOnSuccess", function() {
			local additionalRenown = getBonusObjectiveProgress() >= getBonusObjectiveGoal() ? Const.World.Assets.ReputationOnOathBonusObjective : 0;
			return Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
		});

		::mods_override(oofa, "getRewardTooltip", function() {
			return "You gain extra Renown for destroying hostile ruins and camps (" + getBonusObjectiveProgress() + "/" + getBonusObjectiveGoal() + ").";
		});

		::mods_override(oofa, "getBonusObjectiveProgress", function() {
			return World.Statistics.getFlags().getAsInt("OathOfFortificationNewObjective");
		});

		::mods_override(oofa, "getBonusObjectiveGoal", function() {
			if (World.Assets.getCombatDifficulty() >= Const.Difficulty.Hard)
				return 8;
			else if (World.Assets.getCombatDifficulty() >= Const.Difficulty.Normal)
				return 7;
			else
				return 6;
		});

		::mods_override(oofa, "onStart", function() {
			onStart();
			World.Statistics.getFlags().set("OathOfFortificationNewObjective", 0);
		});
	});

	::mods_hookClass("states/tactical_state", function(ts) {
		local onBattleEnded = ts.onBattleEnded;

		ts.onBattleEnded = function() {
			local isVictory = Tactical.Entities.getCombatResult() == Const.Tactical.CombatResult.EnemyDestroyed || Tactical.Entities.getCombatResult() == Const.Tactical.CombatResult.EnemyRetreated;
			if (isVictory && !isScenarioMode() && m.StrategicProperties != null && m.StrategicProperties.IsAttackingLocation)
				World.Statistics.getFlags().increment("OathOfFortificationNewObjective");

			onBattleEnded();
		}
	});
});
