southern_assassins_scenario <- inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		m.ID = "scenario.southern_assassins";
		m.Name = "Southern Assassins";
		m.Description = "[p=c][img]gfx/ui/events/event_165.png[/img][/p][p]You are an assassin of the Southern guilds, a master of shadows and blades. But when you are tasked with a target not even the guilds can touch, can you adapt to the life of a mercenary?\n\n[color=#bcad8c]Assassins:[/color] Start with two trained assassins.\n[color=#bcad8c]Secret Arts:[/color] At levels 3, 6, and 9, your men learn a random assassin specialty instead of gaining a perk point.\n[color=#bcad8c]Training Retinue:[/color] You have two fewer retinue slots.[/p]";
		m.Difficulty = 2;
		m.Order = 86;
		m.IsFixedLook = true;
	}

	function isValid()
	{
		return Const.DLC.Paladins && Const.DLC.Desert;
	}

	function onSpawnAssets()
	{
		local roster = World.getPlayerRoster();

		for( local i = 0; i < 2; i = ++i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = Time.getVirtualTimeF();
		}

		local bros = roster.getAll();
		bros[0].setStartValuesEx([ "assassin_southern_background" ]);
		bros[0].getBackground().m.RawDescription = "%name% is your most talented pupil, a truly rare combination of skilled, efficient, and professional. You've never quite been able to get a read on the man, but you know his skills will be invaluable to the %companyname%, and when you asked him to join you in exile he agreed without a moment's hesitation. If only more were like him.";
		bros[0].getBackground().buildDescription(true);
		bros[0].setPlaceInFormation(3);

		bros[0].m.PerkPoints = 1;
		bros[0].m.LevelUps = 1;
		bros[0].m.Level = 2;

		bros[0].m.Talents = [];
		local talents = bros[0].getTalents();
		talents.resize(Const.Attributes.COUNT, 0);
		talents[Const.Attributes.Bravery] = 2;
		talents[Const.Attributes.MeleeSkill] = 1;
		talents[Const.Attributes.MeleeDefense] = 3;

		local items = bros[0].getItems();
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Head));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Offhand));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Ammo));

		items.equip(new("scripts/items/weapons/scimitar"));
		items.equip(new("scripts/items/helmets/oriental/assassin_head_wrap"));
		items.equip(new("scripts/items/armor/oriental/assassin_robe"));

		bros[1].setStartValuesEx([ "assassin_southern_background" ]);
		bros[1].getBackground().m.RawDescription = "%name% is a peculiar sort, even by the abnormal standards of the guilds. Assassins prefer the certainty afforded by melee weapons almost as a rule, yet the man seems downright uncomfortable unless he has a bow in his hands. Similarly, most of the guild opt for a spartan life with few comforts so as to not stand out, yet %name% would live in hedonism to rival the viziers, could he afford it. These eccentricities might concern you more were he not also one of the most deadly killers in the south, with dozens of arrow-riddled corpses to his name. You decide you're willing to overlook a few quirks, and not just because he agreed to join you in exile.";
		bros[1].getBackground().buildDescription(true);
		bros[1].setPlaceInFormation(4);

		bros[1].m.PerkPoints = 1;
		bros[1].m.LevelUps = 1;
		bros[1].m.Level = 2;

		bros[1].m.Talents = [];
		local talents = bros[1].getTalents();
		talents.resize(Const.Attributes.COUNT, 0);
		talents[Const.Attributes.Fatigue] = 2;
		talents[Const.Attributes.Initiative] = 2;
		talents[Const.Attributes.RangedSkill] = 3;

		local items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Head));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Offhand));
		items.unequip(items.getItemAtSlot(Const.ItemSlot.Ammo));

		items.equip(new("scripts/items/weapons/oriental/composite_bow"));
		items.equip(new("scripts/items/ammo/quiver_of_arrows"));
		items.equip(new("scripts/items/helmets/oriental/assassin_head_wrap"));
		items.equip(new("scripts/items/armor/oriental/thick_nomad_robe"));
		items.addToBag(new("scripts/items/weapons/oriental/qatal_dagger"));

		World.Assets.m.BusinessReputation = 55;
		World.Assets.addMoralReputation(-10.0);
		World.Assets.getStash().add(new("scripts/items/supplies/dates_item"));
		World.Assets.getStash().add(new("scripts/items/supplies/rice_item"));
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = World.EntityManager.getSettlements()[i];

			if (!randomVillage.isIsolatedFromRoads() && randomVillage.isSouthern())
				break;
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = World.getNavigator().createSettings();
		navSettings.ActionPointCosts = Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = Math.rand(Math.max(2, randomVillageTile.SquareCoords.X - 4), Math.min(Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 4));
			local y = Math.rand(Math.max(2, randomVillageTile.SquareCoords.Y - 4), Math.min(Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 4));

			if (!World.isValidTileSquare(x, y))
				continue;

			local tile = World.getTileSquare(x, y);

			if (tile.Type == Const.World.TerrainType.Ocean || tile.Type == Const.World.TerrainType.Shore || tile.IsOccupied)
				continue;
			else if (tile.getDistanceTo(randomVillageTile) <= 1)
				continue;

			local path = World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

			if (!path.isEmpty())
			{
				randomVillageTile = tile;
				break;
			}
		}
		while (1);

		World.Retinue.setFollower(0, World.Retinue.getFollower("follower.poison_master"));
		World.Retinue.setFollower(1, World.Retinue.getFollower("follower.assassin_master"));

		World.Statistics.getFlags().set("SouthernAssassinNemesisName", Const.Strings.SouthernNames[Math.rand(0, Const.Strings.SouthernNames.len() - 1)]);

		World.State.m.Player = World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		World.Assets.updateLook(104);
		World.getCamera().setPos(World.State.m.Player.getPos());
		Time.scheduleEvent(TimeUnit.Real, 1000, function ( _tag )
		{
			Music.setTrackList([ "music/worldmap_11.ogg" ], Const.Music.CrossFadeTime);
			World.Events.fire("event.southern_assassins_scenario_intro");
		}, null);
	}

	function onInit()
	{
		if (!(World.Statistics.getFlags().get("SouthernAssassinsEventsAdded")))
		{
			local mundaneEvents = IO.enumerateFiles("scripts/events/offplus_assassins_events");
			foreach ( i, event in mundaneEvents ) {
				local instantiatedEvent = new(event);
				World.Events.m.Events.push(instantiatedEvent);
			};
		}
		World.Statistics.getFlags().set("SouthernAssassinsEventsAdded", true);
	}

	function onActorKilled(_actor, _killer, _combatID) {
		if (_combatID == "SouthernAssassinsProphetFight" && _actor.getSkills().hasSkill("effect.assassins_prophet"))
			World.Statistics.getFlags().set("SouthernAssassinsProphetSlain", true);
	}

	function onHired(_bro) {
		if (_bro.getLevel() >= 3)
			addPoisonSpeciality(_bro);
		if (_bro.getLevel() >= 6)
			addCombatSpeciality(_bro);
		if (_bro.getLevel() >= 9)
			addPhilosophy(_bro);
	}

	function onUpdateLevel(_bro) {
		if (_bro.getLevel() == 3)
			addPoisonSpeciality(_bro);
		else if (_bro.getLevel() == 6)
			addCombatSpeciality(_bro);
		else if (_bro.getLevel() == 9)
			addPhilosophy(_bro);
	}

	function addPoisonSpeciality(_bro) {
		local poison_effects = [ "assassin_poison_01_effect", "assassin_poison_02_effect", "assassin_poison_03_effect", "assassin_poison_04_effect", "assassin_poison_05_effect" ];
		_bro.getSkills().add(new("scripts/skills/effects/" + poison_effects[Math.rand(0, poison_effects.len() - 1)]));

		_bro.m.PerkPoints -= 1;
		_bro.m.PerkPointsSpent += 1;
	}

	function addCombatSpeciality(_bro) {
		local speciality_effects = [ "assassin_speciality_01_effect", "assassin_speciality_02_effect", "assassin_speciality_03_effect", "assassin_speciality_04_effect", "assassin_speciality_05_effect" ];
		_bro.getSkills().add(new("scripts/skills/effects/" + speciality_effects[Math.rand(0, speciality_effects.len() - 1)]));

		_bro.m.PerkPoints -= 1;
		_bro.m.PerkPointsSpent += 1;
	}

	function addPhilosophy(_bro) {
		local philosophies = [ "way_of_the_gilder_trait", "way_of_the_scorpion_trait", "way_of_the_shadow_trait", "way_of_the_spider_trait", "way_of_the_wolf_trait" ];
		_bro.getSkills().add(new("scripts/skills/traits/" + philosophies[Math.rand(0, philosophies.len() - 1)]));

		_bro.m.PerkPoints -= 1;
		_bro.m.PerkPointsSpent += 1;
	}
});

