oathtakers_scenario <- inherit("scripts/scenarios/world/starting_scenario", {
	m = { }

	function create() {
		m.ID			= "scenario.oathtakers";
		m.Name			= "Oathtakers";
		m.Description	= "[p=c][img]gfx/ui/events/event_180.png[/img][/p][p]Oathtakers are a militant group of vagrants and questors pursuant to the ideals and teachings of their founder, Young Anselm. The order now finds itself in dire straits, and they've turned to you to reverse their fortunes. Can you teach these zealots to become successful mercenaries?\n\n[color=#bcad8c]Paladins:[/color] Start with two battle-hardened warriors and good equipment.\n[color=#bcad8c]Oathtakers:[/color] Sworn to Young Anselm's teachings, your men can take on burdens to uphold oaths that grant boons once fulfilled.[/p]";
		m.Difficulty	= 2;
		m.Order			= 40;
		m.IsFixedLook	= true;
	}

	function isValid() {
		return Const.DLC.Paladins;
	}

	function onSpawnAssets() {
		local roster = World.getPlayerRoster();
		local names = [];

		for (local i = 0; i < 2; ++i) {
			local bro;

			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = Time.getVirtualTimeF();
		}

		local bros = roster.getAll();

		bros[0].setStartValuesEx([ "old_paladin_background" ]);
		bros[0].getBackground().m.RawDescription = "{%name% is rather old, nigh on decrepit, a rarity amongst the militant and doubly so amongst the Oathtakers. Few throw themselves into danger with the reckless abandon of Young Anselm's paladins, and to grow old in their number requires great skill indeed. Though age has dulled some of his natural abilities, he still commands much respect from his fellow Oathtakers. Seeing him bellow as he cleaves through the order's foes, you can see why. | %name% is a man of many spirits, having wandered the world in the shell of soldier, farmer, sellsword, and more. He has never divulged what events saw him join the Oathtakers, but in the years since he has proven one of the most ardent followers of the Oaths. When schism tore the group asunder, none questioned %name%'s right to safeguard Young Anselm's skull.}";
		bros[0].setPlaceInFormation(4);
		bros[0].m.PerkPoints = 2;
		bros[0].m.LevelUps = 2;
		bros[0].m.Level = 3;

		bros[0].getSkills().add(new("scripts/skills/traits/old_trait"));

		bros[0].m.Talents = [];
		local talents = bros[0].getTalents();
		talents.resize(Const.Attributes.COUNT, 0);
		talents[Const.Attributes.Bravery] = 3;
		talents[Const.Attributes.MeleeSkill] = 1;
		talents[Const.Attributes.RangedDefense] = 2;

		local items = bros[0].getItems();
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Head));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Offhand));

		items.equip(new("scripts/items/helmets/heavy_mail_coif"));
		items.equip(new("scripts/items/armor/adorned_mail_shirt"));
		items.equip(new("scripts/items/accessory/oathtaker_skull_01_item"));
		items.equip(new("scripts/items/weapons/military_pick"));

		local shield = new("scripts/items/shields/kite_shield");
		shield.onPaintInCompanyColors();
		items.equip(shield);

		bros[1].setStartValuesEx([ "paladin_background" ]);
		bros[1].getBackground().m.RawDescription = "{Orphaned by a brigand raid, %name% was taken in and raised by a traveling group of Oathtakers. The eclectic warriors taught him how to survive on the road, how to fight, and most importantly how to follow Young Anselm's Oaths. Though now a grown man, he has yet to let the world's horrors and grind wear him down. In moments of honesty, he reminds you of yourself. In moments of reflection, you realize that he will likely one day resemble you as you are now. But until then, his earnest nature is a nice change of pace from the cynicism typical of sellswords.}"
		bros[1].setPlaceInFormation(5);
		bros[1].m.PerkPoints = 0;
		bros[1].m.LevelUps = 0;
		bros[1].m.Level = 1;

		bros[1].m.Talents = [];
		talents = bros[1].getTalents();
		talents.resize(Const.Attributes.COUNT, 0);
		talents[Const.Attributes.Initiative] = 3;
		talents[Const.Attributes.MeleeSkill] = 2;
		talents[Const.Attributes.MeleeDefense] = 1;

		items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Head));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Offhand));

		items.equip(new("scripts/items/helmets/adorned_closed_flat_top_with_mail"));
		items.equip(new("scripts/items/armor/adorned_warriors_armor"));
		items.equip(new("scripts/items/weapons/arming_sword"));

		World.Assets.getStash().add(new("scripts/items/misc/oathtakers/book_of_oaths"));
		World.Assets.getStash().add(new("scripts/items/supplies/ground_grains_item"));
		World.Assets.addMoralReputation(10.0);

		World.Assets.m.Money = World.Assets.m.Money - 800;
		World.Assets.m.ArmorParts = World.Assets.m.ArmorParts / 2;
		World.Assets.m.Medicine = World.Assets.m.Medicine / 2;
		World.Assets.m.Ammo = World.Assets.m.Ammo / 2;
	}

	function onSpawnPlayer() {
		local randomVillage;

		for (local i=0; i != World.EntityManager.getSettlements().len(); ++i) {
			randomVillage = World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 3 && !randomVillage.isSouthern()) // start near city
				break;
		}

		local randomVillageTile = randomVillage.getTile();

		local navSettings = World.getNavigator().createSettings();
		navSettings.ActionPointCosts = Const.World.TerrainTypeNavCost_Flat;

		do {
			local x = Math.rand(Math.max(2, randomVillageTile.SquareCoords.X - 4), Math.min(Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 4));
			local y = Math.rand(Math.max(2, randomVillageTile.SquareCoords.Y - 4), Math.min(Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 4));

			if (!World.isValidTileSquare(x, y))
				continue;

			local tile = World.getTileSquare(x, y);

			if (tile.Type == Const.World.TerrainType.Ocean || tile.Type == Const.World.TerrainType.Shore || tile.IsOccupied)
				continue;

			if (tile.getDistanceTo(randomVillageTile) <= 1)
				continue;

			local path = World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

			if (!path.isEmpty()) {
				randomVillageTile = tile;
				break;
			}
		}
		while(1);

		World.State.m.Player = World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		World.Assets.updateLook(19);
		World.getCamera().setPos(World.State.m.Player.getPos());

		Time.scheduleEvent(TimeUnit.Real, 1000, function(_tag) {
			Music.setTrackList(Const.Music.IntroTracks, Const.Music.CrossFadeTime);

			World.Events.fire("event.oathtakers_scenario_intro")
		}, null);
	}

	function onInit() {
		if (!(World.Statistics.getFlags().get("OathtakersEventsAdded"))) {
			local mundaneEvents = IO.enumerateFiles("scripts/events/offplus_oathtakers_events");
			foreach ( i, event in mundaneEvents ) {
				local instantiatedEvent = new(event);
				World.Events.m.Events.push(instantiatedEvent);
			};
		}
		World.Statistics.getFlags().set("OathtakersEventsAdded", true);

		World.Events.addSpecialEvent("event.oathtaker_brings_oaths");
		World.Events.addSpecialEvent("event.oathtakers_book_copied");
		World.Events.addSpecialEvent("event.oathtakers_book_missing");
		World.Events.addSpecialEvent("event.oathtakers_skull_copied");
		World.Events.addSpecialEvent("event.oathtakers_skull_missing");

		local brothers = World.getPlayerRoster().getAll();

		// Because brothers are deserialized one by one (reasonably), skills that scale based on number of brothers
		//  (such as the completed Oath of Tithing effect) won't work correctly on initial load. onInit is loaded
		//  after all bros are deserialized, so running onUpdate will calculate those skills correctly.
		foreach (bro in brothers) {
			bro.getSkills().update();
		}
	}

	function onGetBackgroundTooltip(_background, _tooltip) {
		_tooltip.push({ id = 16, type = "text", icon = "ui/icons/special.png", text = "Can undertake up to three Oaths that grant permanent boons when fulfilled" });
	}

	function onActorKilled(_actor, _killer, _combatID) {
		if (_killer == null || (_killer.getFaction() != Const.Faction.Player && _killer.getFaction() != Const.Faction.PlayerAnimals))
			return;

		local actorFaction = Const.EntityType.getDefaultFaction(_actor.getType());
		local skills = _killer.getSkills();
		local flags = _killer.getFlags();

		// Oath of Righteousness only checks personal kills
		if (skills.hasSkill("effects.oath_of_righteousness_active")) {
			if (actorFaction == Const.FactionType.Zombies || actorFaction == Const.FactionType.Undead) {
				flags.increment(::OFFP.Oathtakers.Flags.Righteousness);

				switch (_actor.getType()) {
					case Const.EntityType.Necromancer:
					case Const.EntityType.Ghost:
					case Const.EntityType.SkeletonPriest:
					case Const.EntityType.SkeletonBoss:
					case Const.EntityType.SkeletonLich:
					case Const.EntityType.Vampire:
						flags.increment(::OFFP.Oathtakers.Flags.RighteousnessLeaders);
						break;
				}
			}
		}

		// Oath of Vengeance checks personal kills for leaders and company kills for the rest
		if (actorFaction == Const.FactionType.Goblins || actorFaction == Const.FactionType.Orcs) {
			local brothers = World.getPlayerRoster().getAll();

			foreach (bro in brothers) {
				if (bro.getSkills().hasSkill("effects.oath_of_vengeance_active"))
					bro.getFlags().increment(::OFFP.Oathtakers.Flags.Vengeance);
			}

			switch (_actor.getType()) {
				case Const.EntityType.GoblinLeader:
				case Const.EntityType.GoblinShaman:
				case Const.EntityType.OrcWarlord:
					if (skills.hasSkill("effects.oath_of_vengeance_active"))
						flags.increment(::OFFP.Oathtakers.Flags.VengeanceLeaders);

					break;
			}
		}

		// Oath of Wrath only checks personal kills
		if (actorFaction == Const.FactionType.Bandits || actorFaction == Const.FactionType.Barbarians || actorFaction == Const.FactionType.OrientalBandits) {
			if (skills.hasSkill("effects.oath_of_wrath_active")) {
				switch (_actor.getType()) {
					case Const.EntityType.BanditLeader:
					case Const.EntityType.NomadLeader:
					case Const.EntityType.BarbarianChampion:
						flags.increment(::OFFP.Oathtakers.Flags.WrathLeaders);
						break;
				}
			}
		}

		// Oath of Dominion only checks personal kills
		if (skills.hasSkill("effects.oath_of_dominion_active")) {
			if (actorFaction == Const.FactionType.Beasts || _actor.getType() == Const.EntityType.BarbarianUnhold || _actor.getType() == Const.EntityType.BarbarianUnholdFrost) {
				if (Const.DLC.Unhold) {
					switch (_actor.getType()) {
						case Const.EntityType.Ghoul:
							if (!flags.get("OFFP_NachzehrerSlain")) {
								flags.set("OFFP_NachzehrerSlain", true);
								flags.increment(::OFFP.Oathtakers.Flags.Dominion);
							}
							break;

						case Const.EntityType.Direwolf:
							if (!flags.get("OFFP_DirewolfSlain")) {
								flags.set("OFFP_DirewolfSlain", true);
								flags.increment(::OFFP.Oathtakers.Flags.Dominion);
							}
							break;

						case Const.EntityType.Lindwurm:
							if (!flags.get("OFFP_LindwurmSlain")) {
								flags.set("OFFP_LindwurmSlain", true);
								flags.increment(::OFFP.Oathtakers.Flags.Dominion);
							}
							break;

						case Const.EntityType.Unhold:
						case Const.EntityType.UnholdFrost:
						case Const.EntityType.UnholdBog:
						case Const.EntityType.BarbarianUnhold:
						case Const.EntityType.BarbarianUnholdFrost:
							if (!flags.get("OFFP_UnholdSlain")) {
								flags.set("OFFP_UnholdSlain", true);
								flags.increment(::OFFP.Oathtakers.Flags.Dominion);
							}
							flags.increment(::OFFP.Oathtakers.Flags.DominionUnholds);
							break;

						case Const.EntityType.Spider:
						case Const.EntityType.SpiderEggs:
							if (!flags.get("OFFP_WebknechtSlain")) {
								flags.set("OFFP_WebknechtSlain", true);
								flags.increment(::OFFP.Oathtakers.Flags.Dominion);
							}
							break;

						case Const.EntityType.Alp:
						case Const.EntityType.AlpShadow:
							if (!flags.get("OFFP_AlpSlain")) {
								flags.set("OFFP_AlpSlain", true);
								flags.increment(::OFFP.Oathtakers.Flags.Dominion);
							}
							flags.increment(::OFFP.Oathtakers.Flags.DominionAlps);
							break;

						case Const.EntityType.Hexe:
							if (!flags.get("OFFP_HexeSlain")) {
								flags.set("OFFP_HexeSlain", true);
								flags.increment(::OFFP.Oathtakers.Flags.Dominion);
							}
							flags.increment(::OFFP.Oathtakers.Flags.DominionHexen);
							break;

						case Const.EntityType.Schrat:
						case Const.EntityType.SchratSmall:
							if (!flags.get("OFFP_SchratSlain")) {
								flags.set("OFFP_SchratSlain", true);
								flags.increment(::OFFP.Oathtakers.Flags.Dominion);
							}
							break;

						case Const.EntityType.Kraken:
						case Const.EntityType.KrakenTentacle:
							if (!flags.get("OFFP_KrakenSlain")) {
								flags.set("OFFP_KrakenSlain", true);
								flags.increment(::OFFP.Oathtakers.Flags.Dominion);
							}
							break;

						case Const.EntityType.TricksterGod:
							if (!flags.get("OFFP_IjirokSlain")) {
								flags.set("OFFP_IjirokSlain", true);
								flags.increment(::OFFP.Oathtakers.Flags.Dominion);
							}
							break;

						case Const.EntityType.Serpent:
							if (!flags.get("OFFP_SerpentSlain")) {
								flags.set("OFFP_SerpentSlain", true);
								flags.increment(::OFFP.Oathtakers.Flags.Dominion);
							}
							break;

						case Const.EntityType.SandGolem:
							if (!flags.get("OFFP_IfritSlain")) {
								flags.set("OFFP_IfritSlain", true);
								flags.increment(::OFFP.Oathtakers.Flags.Dominion);
							}
							break;

						case Const.EntityType.Hyena:
							if (!flags.get("OFFP_HyenaSlain")) {
								flags.set("OFFP_HyenaSlain", true);
								flags.increment(::OFFP.Oathtakers.Flags.Dominion);
							}
							break;
					}
				} else {
					flags.increment(::OFFP.Oathtakers.Flags.DominionLegacy);
				}
			}
		}

		if (skills.hasSkill("effects.oath_of_distinction_active")) {
			if (_actor.m.IsMiniboss || _actor.getSkills().hasSkill("perk.captain"))
				flags.increment(::OFFP.Oathtakers.Flags.Distinction);
		}
	}

	function onBattleWon(_combatLoot) {
		local crownsMult = 1.0
		local brothers = World.getPlayerRoster().getAll();

		foreach (bro in brothers) {
			if (World.Statistics.getFlags().getAsInt("LastCombatResult") == 1) {
				if (bro.getSkills().hasSkill("effects.oath_of_endurance_active")) {
					if (bro.isPlacedOnMap())
						bro.getFlags().increment(::OFFP.Oathtakers.Flags.Endurance);
					else if (bro.getFlags().getAsInt(::OFFP.Oathtakers.Flags.Endurance) < ::OFFP.Oathtakers.Quests.EnduranceConsecutiveBattles)
						bro.getFlags().set(::OFFP.Oathtakers.Flags.Endurance, 0);
				}
			}

			if (World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") > World.Statistics.getFlags().getAsInt("LastPlayersAtBattleStartCount")) {
				if (bro.getSkills().hasSkill("effects.oath_of_valor_active"))
					bro.getFlags().increment(::OFFP.Oathtakers.Flags.Valor);
			}

			if ("Entities" in Tactical && Tactical.Entities.getCombatResult() == Const.Tactical.CombatResult.EnemyRetreated) {
				if (bro.getSkills().hasSkill("effects.oath_of_honor_active"))
					bro.getFlags().increment(::OFFP.Oathtakers.Flags.Honor);
			}
		}
	}

	function onContractFinished(_contractType, _cancelled) {
		if (_contractType == "contract.arena" || _contractType == "contract.arena_tournament")
			return;

		// World.Assets.getOrigin().onContractFinished is called right before the contracts manager clears the active
		//  contract, so we can still use World.Contracts.getActiveContract() to get it
		local activeContract = World.Contracts.getActiveContract()
		local crownsMult = 1.0;

		if (!_cancelled) {
			local brothers = World.getPlayerRoster().getAll();

			foreach (bro in brothers) {
				if (bro.getSkills().hasSkill("effects.oath_of_loyalty_active"))
					bro.getFlags().increment(::OFFP.Oathtakers.Flags.Loyalty);

				if (bro.getSkills().hasSkill("effects.oath_of_loyalty_completed")) {
					World.FactionManager.getFaction(activeContract.getFaction()).addPlayerRelation(::OFFP.Oathtakers.Boons.LoyaltyRelations);
					World.Assets.addBusinessReputation(::OFFP.Oathtakers.Boons.LoyaltyRenown);
				}

				if (bro.getSkills().hasSkill("effects.oath_of_tithing_active") && bro.getFlags().getAsInt(::OFFP.Oathtakers.Flags.Tithing) < ::OFFP.Oathtakers.Quests.TithingCrownsLevied)
					crownsMult *= 0.9;
			}

			local pay = activeContract.m.Payment.getOnCompletion();
			local tithe = pay - Math.floor(pay * crownsMult);
			World.Assets.addMoney(-1 * tithe);

			foreach (bro in brothers) {
				if (bro.getSkills().hasSkill("effects.oath_of_tithing_active") && bro.getFlags().getAsInt(::OFFP.Oathtakers.Flags.Tithing) < ::OFFP.Oathtakers.Quests.TithingCrownsLevied)
					bro.getFlags().increment(::OFFP.Oathtakers.Flags.Tithing, tithe);
			}
		}
	}
});
