runeknights_scenario <- inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create() {
		m.ID = "scenario.runeknights";
		m.Name = "Rune Chosen";
		m.Description = "[p=c][img]gfx/ui/events/event_145.png[/img][/p][p]You are an adherent of Old Ironhand, an esoteric god of war and glorious death. As you begin to receive visions that the time has come to seek his favor beyond the bounds of the snowy north, what better way than through mercenary work?\n\n[color=#bcad8c]Ironhand's Chosen:[/color] Start with two barbarians and Ironhand's legendary rune blade.\n[color=#bcad8c]Warrior's Repose:[/color] Fallen brothers can be immortalized in runes that grant powerful boons.\n[color=#bcad8c]Death Seekers:[/color] Your men will always die if struck down.[/p]";
		m.Difficulty = 2;
		m.Order = 87;
		m.IsFixedLook = true;
	}

	function isValid() {
		return Const.DLC.Paladins && Const.DLC.Wildmen;
	}

	function onSpawnAssets() {
		local roster = World.getPlayerRoster();

		for( local i = 0; i < 2; i = ++i ) {
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = Time.getVirtualTimeF();
		}

		local bros = roster.getAll();
		bros[0].setStartValuesEx([ "barbarian_background" ]);
		bros[0].getBackground().m.RawDescription = "You first encountered %name% in the snowy wastes of the north, as a champion of a rival village. In your duel you both realized the futility of death in service of a kin's squabbles, so together you slaughtered both villages and set off in search of more worthy battles. You've been traveling and seeking Old Ironhand's favor together ever since.";
		bros[0].getBackground().buildDescription(true);
		bros[0].setTitle("the Runecarver");
		bros[0].setPlaceInFormation(3);

		bros[0].m.PerkPoints = 1;
		bros[0].m.LevelUps = 1;
		bros[0].m.Level = 2;

		bros[0].m.Talents = [];
		local talents = bros[0].getTalents();
		talents.resize(Const.Attributes.COUNT, 0);
		talents[Const.Attributes.Bravery] = 2;
		talents[Const.Attributes.MeleeSkill] = 1;
		talents[Const.Attributes.MeleeDefense] = 2;

		local items = bros[0].getItems();
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Head));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Offhand));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Ammo));

		items.equip(new("scripts/items/weapons/legendary/barbarian_runeblade"));
		items.equip(new("scripts/items/helmets/barbarians/closed_scrap_metal_helmet"));
		items.equip(new("scripts/items/armor/barbarians/heavy_iron_armor"));

		bros[1].setStartValuesEx([ "barbarian_background" ]);
		bros[1].getBackground().m.RawDescription = "Before being taken as a thrall, %name% served as a squire to a southern lord. While years have passed since the man adopted the northern culture as his own, it seems old habits die hard. When " + bros[0].getName() + " slaughtered the rest of his clan, he asked to be spared that he might serve as the chosen's second in battle and see his deeds under Ironhand's guidance reach their full potential. An unusual pact for a northman to take on, but taken on it was, and he has served faithfully since.";
		bros[1].getBackground().buildDescription(true);
		bros[1].setPlaceInFormation(4);
		bros[1].getSkills().add(new("scripts/skills/traits/loyal_trait"));

		bros[1].m.PerkPoints = 0;
		bros[1].m.LevelUps = 0;
		bros[1].m.Level = 1;

		bros[1].m.Talents = [];
		talents = bros[1].getTalents();
		talents.resize(Const.Attributes.COUNT, 0);
		talents[Const.Attributes.Fatigue] = 2;
		talents[Const.Attributes.Initiative] = 1;
		talents[Const.Attributes.MeleeSkill] = 2;

		items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Head));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Offhand));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Ammo));

		items.equip(new("scripts/items/weapons/militia_spear"));
		items.equip(new("scripts/items/helmets/barbarians/bear_headpiece"));
		items.equip(new("scripts/items/armor/barbarians/scrap_metal_armor"));

		World.Assets.addMoralReputation(-40.0);
		World.Assets.getStash().add(new("scripts/items/supplies/strange_meat_item"));
		World.Assets.getStash().add(new("scripts/items/supplies/strange_meat_item"));
		World.Assets.getStash().add(new("scripts/items/misc/runeknights/rune_01_item"));

		World.Assets.m.Money = World.Assets.m.Money / 2 + 150;
		World.Assets.m.Ammo = World.Assets.m.Ammo / 2;
	}

	function onSpawnPlayer() {
		local randomVillage = null, northernmostY = 0;
		for(local i=0; i != World.EntityManager.getSettlements().len(); ++i) {
			local v = World.EntityManager.getSettlements()[i];

			if(v.getTile().SquareCoords.Y > northernmostY && !v.isMilitary() && !v.isIsolatedFromRoads() && v.getSize() <= 2) {
				northernmostY = v.getTile().SquareCoords.Y;
				randomVillage = v;
			}
		}

		randomVillage.setLastSpawnTimeToNow();
		local randomVillageTile = randomVillage.getTile();

		local navSettings = World.getNavigator().createSettings();
		navSettings.ActionPointCosts = Const.World.TerrainTypeNavCost_Flat;

		do {
			local x = Math.rand(Math.max(6, randomVillageTile.SquareCoords.X - 6), Math.min(Const.World.Settings.SizeX - 6, randomVillageTile.SquareCoords.X + 6));
			local y = Math.rand(Math.max(6, randomVillageTile.SquareCoords.Y - 6), Math.min(Const.World.Settings.SizeY - 6, randomVillageTile.SquareCoords.Y + 6));

			if (!World.isValidTileSquare(x, y))
				continue;

			local tile = World.getTileSquare(x, y);

			if (tile.Type == Const.World.TerrainType.Ocean || tile.Type == Const.World.TerrainType.Shore || tile.IsOccupied)
				continue;

			if (tile.getDistanceTo(randomVillageTile) <= 4)
				continue;

			if (tile.Type != Const.World.TerrainType.Tundra && tile.Type != Const.World.TerrainType.Snow)
				continue;

			local path = World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);
			
			if (!path.isEmpty()) {
				randomVillageTile = tile;
				break;
			}			
		}
		while(1);

		local nobles = World.FactionManager.getFactionsOfType(Const.FactionType.NobleHouse);
		local houses = [];

		foreach(n in nobles) {
			local closest = null, dist = 9999;
			foreach(s in n.getSettlements()) {
				local d = s.getTile().getDistanceTo(randomVillageTile);

				if(d < dist) {
					dist = d;
					closest = s;
				}
			}

			houses.push({ Faction = n, Dist = dist });
		}

		houses.sort(function(_a, _b) { 
			if (_a.Dist > _b.Dist) 
				return 1;
			else if (_a.Dist < _b.Dist) 
				return -1;
			return 0;
		});

		houses[0].Faction.addPlayerRelation(-25.0, "You are barbaric and threatening");
		World.Statistics.getFlags().set("RuneKnightsDreamStage", 0);

		World.State.m.Player = World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		World.Assets.updateLook(103);
		World.getCamera().setPos(World.State.m.Player.getPos());

		World.Statistics.getFlags().set("numFirstLevelRunesToDrop", 0);
		World.Statistics.getFlags().set("numSecondLevelRunesToDrop", 0);
		World.Statistics.getFlags().set("numThirdLevelRunesToDrop", 0);
		World.Statistics.getFlags().set("numFourthLevelRunesToDrop", 0);
		World.Statistics.getFlags().set("numFifthLevelRunesToDrop", 0);
		World.Statistics.getFlags().set("numChampionRunesToDrop", 0);
		World.Statistics.getFlags().set("DropBerserkerRune", false);

		Time.scheduleEvent(TimeUnit.Real, 1000, function(_tag) {
			Music.setTrackList([ "music/barbarians_02.ogg" ] , Const.Music.CrossFadeTime);
			World.Events.fire("event.runeknights_scenario_intro")
		}, null);
	}

	function onInit() {
		if (!(World.Statistics.getFlags().get("RuneKnightsEventsAdded"))) {
			local mundaneEvents = IO.enumerateFiles("scripts/events/offplus_runeknights_events");
			foreach ( i, event in mundaneEvents ) {
				local instantiatedEvent = new(event);
				World.Events.m.Events.push(instantiatedEvent);
			};
		}
		World.Statistics.getFlags().set("RuneKnightsEventsAdded", true);
	}

	function onHired(_bro) {
		_bro.getFlags().set("numActiveRunes", 0);
	}

	function onActorKilled(_actor, _killer, _combatID) {
		if (_actor.isPlayerControlled()) {
			if (_actor.getSkills().hasSkill("effect.rune_07"))
				World.Statistics.getFlags().set("DropBerserkerRune", true);
			else if (_actor.getLevel() + _actor.getFlags().getAsInt("numActiveRunes") >= 10)
				World.Statistics.getFlags().increment("numFifthLevelRunesToDrop", 1);
			else if (_actor.getLevel() + _actor.getFlags().getAsInt("numActiveRunes") >= 8)
				World.Statistics.getFlags().increment("numFourthLevelRunesToDrop", 1);
			else if (_actor.getLevel() + _actor.getFlags().getAsInt("numActiveRunes") >= 6)
				World.Statistics.getFlags().increment("numThirdLevelRunesToDrop", 1);
			else if (_actor.getLevel() + _actor.getFlags().getAsInt("numActiveRunes") >= 4)
				World.Statistics.getFlags().increment("numSecondLevelRunesToDrop", 1);
			else if (_actor.getLevel() + _actor.getFlags().getAsInt("numActiveRunes") >= 2)
				World.Statistics.getFlags().increment("numFirstLevelRunesToDrop", 1);
		} else if (_actor.m.IsMiniboss && _killer != null && (_killer.getFaction() == Const.Faction.Player || _killer.getFaction() == Const.Faction.PlayerAnimals)) {
			World.Statistics.getFlags().increment("numChampionRunesToDrop", 1);
		}

	}

	function onBattleWon(_combatLoot) {
		local i;
		for(i = 0; i < World.Statistics.getFlags().getAsInt("numFirstLevelRunesToDrop"); ++i)
			_combatLoot.add(new("scripts/items/misc/runeknights/rune_01_item"));

		for(i = 0; i < World.Statistics.getFlags().getAsInt("numSecondLevelRunesToDrop"); ++i)
			_combatLoot.add(new("scripts/items/misc/runeknights/rune_02_item"));

		for(i = 0; i < World.Statistics.getFlags().getAsInt("numThirdLevelRunesToDrop"); ++i)
			_combatLoot.add(new("scripts/items/misc/runeknights/rune_03_item"));

		for(i = 0; i < World.Statistics.getFlags().getAsInt("numFourthLevelRunesToDrop"); ++i)
			_combatLoot.add(new("scripts/items/misc/runeknights/rune_04_item"));

		for(i = 0; i < World.Statistics.getFlags().getAsInt("numFifthLevelRunesToDrop"); ++i)
			_combatLoot.add(new("scripts/items/misc/runeknights/rune_05_item"));

		for(i = 0; i < World.Statistics.getFlags().getAsInt("numChampionRunesToDrop"); ++i)
			_combatLoot.add(new("scripts/items/misc/runeknights/rune_06_item"));

		if (World.Statistics.getFlags().get("DropBerserkerRune"))
			_combatLoot.add(new("scripts/items/misc/runeknights/rune_07_item"));
	}

	function onCombatFinished() {
		World.Statistics.getFlags().set("numFirstLevelRunesToDrop", 0);
		World.Statistics.getFlags().set("numSecondLevelRunesToDrop", 0);
		World.Statistics.getFlags().set("numThirdLevelRunesToDrop", 0);
		World.Statistics.getFlags().set("numFourthLevelRunesToDrop", 0);
		World.Statistics.getFlags().set("numFifthLevelRunesToDrop", 0);
		World.Statistics.getFlags().set("numChampionRunesToDrop", 0);
		World.Statistics.getFlags().set("DropBerserkerRune", false);

		return true;
	}

	function onGetBackgroundTooltip(_background, _tooltip) {
		_tooltip.push({ id = 11, type = "text", icon = "ui/icons/days_wounded.png", text = "Is permanently dead if struck down and will not survive with a permanent injury" });
	}
});
