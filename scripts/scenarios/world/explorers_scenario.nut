explorers_scenario <- inherit("scripts/scenarios/world/starting_scenario", {
	m = { }

	function create() {
		m.ID			= "scenario.explorers";
		m.Name			= "Cursed Explorers";
		m.Description	= "[p=c][img]gfx/ui/events/event_133.png[/img][/p][p]You and your men suffer from the Pillager Rot, a deadly degenerative disease. Your search for a mundane cure fruitless, you now turn to myth and legend. But can you survive the search?\n\n[color=#bcad8c]Cursed Explorers:[/color] Start with three men.\n[color=#bcad8c]Volition of the Cursed:[/color] Your men gain experience from discovering locations. Exploring legendary locations gives a permanent stat boost.\n[color=#bcad8c]The Pillager Rot:[/color] New recruits are 20% more expensive to hire. Your men suffer from a disease that worsens over time.[/p]";
		m.Difficulty	= 3;
		m.Order			= 95;
	}

	function isValid() {
		return Const.DLC.Paladins && Const.DLC.Unhold;
	}

	function onSpawnAssets() {
		local roster = World.getPlayerRoster();

		for (local i = 0; i < 3; i = ++i) {
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = Time.getVirtualTimeF();
		}

		local bros = roster.getAll();
		bros[0].setStartValuesEx([ "wildman_background" ]);
		bros[0].getBackground().m.RawDescription = "%name% spent his life in the wilds, isolated from civilization. He might be there still, were it not for the veins in his arms turning black one day, and a fateful encounter with two escaped prisoners who shared a similar condition.";
		bros[0].getBackground().buildDescription(true);
		bros[0].setPlaceInFormation(3);

		bros[0].getSkills().add(new("scripts/skills/traits/volition_of_the_cursed_trait"));
		bros[0].getFlags().set("CursedExplorersLegendaryLocations", 0);
		bros[0].getSkills().add(new("scripts/skills/traits/rot_02_trait"));

		bros[0].m.PerkPoints = 1;
		bros[0].m.LevelUps = 1;
		bros[0].m.Level = 2;

		bros[0].m.Talents = [];
		local talents = bros[0].getTalents();
		talents.resize(Const.Attributes.COUNT, 0);
		talents[Const.Attributes.Hitpoints] = 2;
		talents[Const.Attributes.Bravery] = 3;
		talents[Const.Attributes.RangedDefense] = 3;

		local items = bros[0].getItems();
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Head));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Offhand));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Ammo));

		items.equip(new("scripts/items/weapons/boar_spear"));
		local armor = new("scripts/items/armor/ragged_surcoat");
		armor.setUpgrade(new("scripts/items/armor_upgrades/direwolf_pelt_upgrade"));
		items.equip(armor);

		bros[1].setStartValuesEx([ "disowned_noble_background" ]);
		bros[1].getBackground().m.RawDescription = "%name% was once an ambitious nobleman with a bright future in the courts ahead of him. Then one morning he awoke coughing up blackened blood, and the court physician informed him - at a distance - of the Pillager Rot. Most of his allies abandoned him outright. The rest were turned away by rumors that he contracted the malady during a highly illegal tryst with a stable of whores, or from pagan rituals undertaken with heretical cultists. Cast out and left with only his sword and what he could carry with him, he now seeks to find a cure at any cost and reclaim the life that was stolen from him.";
		bros[1].getBackground().buildDescription(true);
		bros[1].setPlaceInFormation(4);

		bros[1].getSkills().add(new("scripts/skills/traits/volition_of_the_cursed_trait"));
		bros[1].getFlags().set("CursedExplorersLegendaryLocations", 0);
		bros[1].getSkills().add(new("scripts/skills/traits/rot_03_trait"));

		bros[1].m.PerkPoints = 1;
		bros[1].m.LevelUps = 1;
		bros[1].m.Level = 2;

		bros[1].m.Talents = [];
		talents = bros[1].getTalents();
		talents.resize(Const.Attributes.COUNT, 0);
		talents[Const.Attributes.Hitpoints] = 2;
		talents[Const.Attributes.Initiative] = 3;
		talents[Const.Attributes.MeleeSkill] = 2;

		bros[1].worsenMood(0.5, "Misses the power and comfort of his life in court");
		bros[1].improveMood(1.5, "Excited to have a lead to follow");

		items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Head));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Offhand));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Ammo));

		items.equip(new("scripts/items/weapons/fencing_sword"));
		items.equip(new("scripts/items/helmets/greatsword_hat"));
		items.equip(new("scripts/items/armor/padded_surcoat"));

		bros[2].setStartValuesEx([ "messenger_background" ]);
		bros[2].getBackground().m.RawDescription = "Once an innkeeper, %name% found himself forced into the courier's vocation when he contracted the Rot. A stoic man, he took the change in stride, deciding it provided a good opportunity to explore the world and perhaps find a cure in far-flung places. You met him when you were both imprisoned by the fleshmen in the Wellspring of Blood, and together the two of you managed to escape. He's been traveling with you ever since.";
		bros[2].getBackground().buildDescription(true);
		bros[2].setPlaceInFormation(5);

		bros[2].getSkills().add(new("scripts/skills/traits/volition_of_the_cursed_trait"));
		bros[2].getFlags().set("CursedExplorersLegendaryLocations", 1);
		bros[2].getSkills().add(new("scripts/skills/traits/rot_05_trait"));

		bros[2].m.PerkPoints = 2;
		bros[2].m.LevelUps = 2;
		bros[2].m.Level = 3;

		bros[2].m.Talents = [];
		talents = bros[2].getTalents();
		talents.resize(Const.Attributes.COUNT, 0);
		talents[Const.Attributes.Hitpoints] = 1;
		talents[Const.Attributes.Fatigue] = 2;
		talents[Const.Attributes.MeleeDefense] = 2;

		bros[2].worsenMood(0.5, "Still scarred by his experiences at the Wellspring of Blood");
		bros[2].improveMood(1.5, "Happy to be exploring the wilderness again");

		items = bros[2].getItems();
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Head));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Offhand));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Ammo));

		items.equip(new("scripts/items/weapons/hatchet"));
		items.equip(new("scripts/items/shields/buckler_shield"));
		items.equip(new("scripts/items/helmets/hood"));
		items.equip(new("scripts/items/armor/thick_tunic"));

		World.Assets.getStash().add(new("scripts/items/supplies/cured_rations_item"));
		World.Assets.getStash().add(new("scripts/items/supplies/cured_rations_item"));
	}

	function onSpawnPlayer() {
		local randomVillage;
		for (local i=0; i != World.EntityManager.getSettlements().len(); ++i) {
			randomVillage = World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 1 && !randomVillage.isSouthern())
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
		World.getCamera().setPos(World.State.m.Player.getPos());

		Time.scheduleEvent(TimeUnit.Real, 1000, function(_tag) {
			Music.setTrackList(Const.Music.CivilianTracks, Const.Music.CrossFadeTime);
			World.Events.fire("event.explorers_scenario_intro")

		}, null);
	}

	function onInit() {
		if (!(World.Statistics.getFlags().get("CursedExplorersEventsAdded"))) {
			local mundaneEvents = IO.enumerateFiles("scripts/events/offplus_explorers_events");

			foreach (i, event in mundaneEvents) {
				local instantiatedEvent = new(event);
				World.Events.m.Events.push(instantiatedEvent);
			};
		}
		World.Statistics.getFlags().set("CursedExplorersEventsAdded", true);

		World.Events.addSpecialEvent("event.bros_contract_rot");

		World.Assets.m.HiringCostMult *= 1.2;
	}

	function onHired(_bro) {
		_bro.getSkills().add(new("scripts/skills/traits/volition_of_the_cursed_trait"));
		_bro.getFlags().set("CursedExplorersLegendaryLocations", 0);
	}

	function onGetBackgroundTooltip(_background, _tooltip) {
		_tooltip.push({ id = 10, type = "text", icon = "ui/icons/special.png", text = "Gain [color=" + Const.UI.Color.PositiveValue + "]+1[/color] Resolve, Melee Skill, Ranged Skill, Melee Defense, and Ranged Defense for each legendary location cleared" });
		_tooltip.push({ id = 11, type = "text", icon = "ui/icons/special.png", text = "Gains XP each time you discover a location" });
	}
});
