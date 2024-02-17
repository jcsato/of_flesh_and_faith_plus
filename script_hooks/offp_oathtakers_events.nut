::mods_hookNewObject("events/events/dlc8/oathbreaker_event", function(oe) {
	local onUpdateScore = ::mods_getMember(oe, "onUpdateScore");
	local onDetermineStartScreen = ::mods_getMember(oe, "onDetermineStartScreen");

	oe.m.Screens.push({
		ID			= "Oathtakers"
		Text		= "[img]gfx/ui/events/event_180.png[/img]{You come across a man laid out on the ground, legs scissoring back and forth in a drunken stupor, his arms slung out as if they were around the shoulders of friends but instead only find the comfort of mud. Far more notable than his squalor, however, is the armor he wears. Adorned in trophies and totems, you've only seen its like on thieves and your oath-bound brethren. From the ease with which he windmills around in it, you take him to be one of the latter. He notices you and calls out.%SPEECH_ON%I beseech ye, traveler, buy m'armors and m'weapons, and leave me the crowns suitably worthy of both, such that I may seek redemption another way, for them martial matters are no longer kin to my path in this world. May the old gods -hic- smite me for admittin' it aloud but I'll admit it aloud!%SPEECH_OFF%The Oathbreaker stumbles and hobbles and props himself up on his knees and groggily takes in the sight of you and the %companyname%. A moment of blankness, then a moment of cognition in which he realizes you're Oathtakers, and then,%SPEECH_ON%Oh, shite.%SPEECH_OFF%}"
		Image		= ""
		List		= [ ]
		Characters	= [ ]
		Options		= [
			{
				Text = "You may have abandoned Young Anselm, but he has not abandoned you. Join us."
				function getResult(_event) { return "OathtakersJoin"; }
			},
			{
				Text = "That gear belongs to the order, not to you, Oathbreaker."
				function getResult(_event) { return "OathtakersExpel"; }
			}
		]

		function start(_event) { }
	});

	oe.m.Screens.push({
		ID			= "OathtakersJoin"
		Text		= "[img]gfx/ui/events/event_180.png[/img]{As you once left the order yourself, you're sympathetic to the man's plight. It's one thing to kill for survival or for coin, but entirely another to drain blood simply out of principle. There is of course a power in strong belief that the %companyname% is now intimately familiar with, a thaumaturgy all to its own wherein the blade is guided and the belly filled and the journey pleasant simply because it is decreed to be. To the apostate, however, violence borne only from principles unveils a deep, black truth of the world: that life is so cheap it can be bought with nothing more than dead men's thoughts, given steel form by the ardent's hands. It doesn't take long for an unfaithful mind to wonder when the life on barter will be theirs, and by then fear has already taken root.\n\nStill, sympathetic though he may be, there is a price to pay for leaving the order. One look at the muddied Oathbreaker tells you it's a price he can ill afford. Instead of exacting it, you hold out your hand.%SPEECH_ON%Young Anselm taught us to swear our oaths precisely because he knew we would falter, for to falter is to live. Do you think being here in the mud is error? Do you think your failures are something mended by coin?%SPEECH_OFF%The man looks up at you through bleary eyes. He asks how a man like him is supposed to regain Young Anselm's favor. He still hasn't taken your hand, so you take his and pull him to his feet.%SPEECH_ON%Together. Wherever an Oathtaker is in the world, he is not alone. Was that not Young Anselm's first message?%SPEECH_OFF%The man slowly cracks a wide grin and gives you a teary-eyed but firm hug, embracing you and the company together.}"
		Image		= ""
		List		= [ ]
		Characters	= [ ]
		Options		= [
			{
				Text = "Faith is the only way forward for some..."
				function getResult(_event) {
					World.getPlayerRoster().add(_event.m.Dude);
					World.getTemporaryRoster().clear();
					_event.m.Dude.onHired();
					_event.m.Dude = null;
					return 0;
				}
			}
		]

		function start(_event) {
			local roster = World.getTemporaryRoster();
			_event.m.Dude = roster.create("scripts/entity/tactical/player");
			_event.m.Dude.setStartValuesEx([ "oathbreaker_background" ]);
			_event.m.Dude.getFlags().set("IsOathbreaker", true);
			_event.m.Dude.getFlags().set("IsSpecial", true);

			_event.m.Dude.setTitle("the Oathbreaker");
			_event.m.Dude.getBackground().m.RawDescription = "Like many, %name% was found in squalor. Ale on his lips, grime in his ears, piss and shit at least somewhere on his person. The meek-hearted man turned his back on Young Anselm and once sought to abandon the Oaths, but when you offered him the chance to redeem himself among like-minded fellows, he leapt at it. It remains to be seen if his newfound resolve comes from within, or is simply the confidence that comes with numbers - and beer - but his desire to find the order's good graces seems earnest, at least.";
			_event.m.Dude.getBackground().buildDescription(true);

			_event.m.Dude.m.PerkPoints = 0;
			_event.m.Dude.m.LevelUps = 0;
			_event.m.Dude.m.Level = 1;
			_event.m.Dude.m.XP = Const.LevelXP[_event.m.Dude.m.Level - 1];

			local trait = new("scripts/skills/traits/drunkard_trait");
			_event.m.Dude.getSkills().add(trait);

			::OFFP.Helpers.resetOathFlags(::OFFP.Helpers.oathNameToActiveID("oath_of_redemption"), _event.m.Dude.getFlags());
			local oath = new("scripts/skills/effects/oath_of_redemption_active_effect");
			_event.m.Dude.getSkills().add(oath);

			local dudeItems = _event.m.Dude.getItems();
			if(dudeItems.getItemAtSlot(Const.ItemSlot.Mainhand) != null)
				dudeItems.getItemAtSlot(Const.ItemSlot.Mainhand).removeSelf();

			if(dudeItems.getItemAtSlot(Const.ItemSlot.Offhand) != null)
				dudeItems.getItemAtSlot(Const.ItemSlot.Offhand).removeSelf();

			if(dudeItems.getItemAtSlot(Const.ItemSlot.Head) != null)
				dudeItems.getItemAtSlot(Const.ItemSlot.Head).removeSelf();

			if(dudeItems.getItemAtSlot(Const.ItemSlot.Body) != null)
				dudeItems.getItemAtSlot(Const.ItemSlot.Body).removeSelf();

			local weapons = [
				"weapons/arming_sword"
				"weapons/noble_sword"
				"weapons/longsword"
				"weapons/greatsword"
			]

			local item = new("scripts/items/" + weapons[Math.rand(0, weapons.len() - 1)]);
			item.setCondition((item.getConditionMax() / 3) - 1);
			dudeItems.equip(item);

			item = new("scripts/items/helmets/adorned_full_helm");
			item.setCondition((item.getConditionMax() / 3) - 1);
			dudeItems.equip(item);

			item = new("scripts/items/armor/adorned_heavy_mail_hauberk");
			item.setCondition((item.getConditionMax() / 3) - 1);
			dudeItems.equip(item);

			Characters.push(_event.m.Dude.getImagePath());
		}
	});

	oe.m.Screens.push({
		ID			= "OathtakersExpel"
		Text		= "[img]gfx/ui/events/event_180.png[/img]{You're no stranger to the order's shortcomings, but there are rules about these things. When you left, you grit your teeth and did it right, even if they didn't deserve it. You certainly aren't about to let some drunk coward escape like this.%SPEECH_ON%You know the rules. When you leave the order, you owe it dues. Pay up.%SPEECH_OFF%The Oathbreaker holds stock still for a moment, weighing his options. Realizing he has no way out of this, he starts to remove his armor in stony silence. He bundles them up and passes them off to %randombrother%, then turns to leave. No, he won't get off that easy.%SPEECH_ON%And the tithe of penance.%SPEECH_OFF%The man opens his mouth to protest, but no words come out. Instead he bites his lip and tosses you a filthy burlap pouch that jingles with the sound of the few crowns within. You count out a tenth of their sum and pocket it, put the rest back in the pouch and throw it back at him. He catches it and flinches as if it stung him.%SPEECH_ON%Go.%SPEECH_OFF%You order and he obeys, tears welling in his red eyes as he stumbles down the road. He still can't walk in a straight line, but you're sure the experience was sobering for the Oathbreaker nonetheless.}"
		Image		= ""
		List		= [ ]
		Characters	= [ ]
		Options		= [
			{
				Text = "Good riddance."
				function getResult(_event) { return 0; }
			}
		]

		function start(_event) {
			local item;
			local stash = World.Assets.getStash();

			item = new("scripts/items/armor/adorned_heavy_mail_hauberk");
			item.setCondition((item.getConditionMax() / 3) - 1);
			stash.add(item);
			List.push({ id = 10, icon = "ui/items/" + item.getIcon(), text = "You gain " + Const.Strings.getArticle(item.getName()) + item.getName() });

			item = new("scripts/items/helmets/adorned_full_helm");
			item.setCondition((item.getConditionMax() / 3) - 1);
			stash.add(item);
			List.push({ id = 10, icon = "ui/items/" + item.getIcon(), text = "You gain " + Const.Strings.getArticle(item.getName()) + item.getName() });

			World.Assets.addMoney(3);
			List.push({ id = 10, icon = "ui/icons/asset_money.png", text = "You gain [color=" + Const.UI.Color.PositiveEventValue + "]3[/color] Crowns" });

			World.Assets.addMoralReputation(-5);

			local brothers = World.getPlayerRoster().getAll();

			foreach(bro in brothers) {
				if (Math.rand(1, 100) <= 33)
					bro.worsenMood(0.5, "Encountered an Oathbreaker and saw him punished");

				if (bro.getBackground().getID() == "background.paladin") {
					if (Math.rand(1, 100) <= 20) {
						bro.getBaseProperties().Bravery += 1;
						List.push({ id = 16, icon = "ui/icons/bravery.png", text = _event.m.Oathtaker.getName() + " gains [color=" + Const.UI.Color.PositiveEventValue + "]+1[/color] Resolve" });
						bro.positiveMood(0.0, "Was compelled to redouble his efforts to follow the oaths");
					}
				}

				if(bro.getMoodState() < Const.MoodState.Neutral)
					List.push( { id = 10, icon = Const.MoodStateIcon[bro.getMoodState()], text = bro.getName() + Const.MoodStateEvent[bro.getMoodState()] } );
			}
		}
	});

	oe.onUpdateScore = function() {
		if (World.Assets.getOrigin().getID() != "scenario.oathtakers") {
			onUpdateScore();
			return;
		}

		if (!Const.DLC.Paladins)
			return;

		if (World.Assets.getStash().getNumberOfEmptySlots() < 3)
			return;

		if (World.getPlayerRoster().getSize() >= World.Assets.getBrothersMax())
			return;

		if (::OFFP.Helpers.getNumOathsUnlocked() < 3)
			return;

		m.Score = 7;
	}

	oe.onDetermineStartScreen = function() {
		if (World.Assets.getOrigin().getID() != "scenario.oathtakers")
			return onDetermineStartScreen();
		else
			return "Oathtakers";
	}
});

::mods_hookNewObject("events/events/dlc8/tree_fort_event", function(tfe) {
	local screenToEdit = null;

	foreach (screen in tfe.m.Screens) {
		if (screen.ID = "A") {
			screenToEdit = screen;
			break;
		}
	}

	if (screenToEdit != null) {
		local originalStart = screenToEdit.start;

		screenToEdit.start = function(_event) {
			originalStart(_event);

			if (World.Assets.getOrigin().getID() == "scenario.oathtakers") {
				Options.push({
					Text = "Perhaps tales of Young Anselm's deeds would coax them out."
					function getResult(_event) { return "D"; }
				});
			}
		}
	}
});

::mods_hookNewObject("events/events/dlc8/oathtakers_lore_event", function(ole) {
	local onUpdateScore = ole.onUpdateScore;

	ole.onUpdateScore = function() {
		onUpdateScore();

		// If some other mod would normally cause the event to fire, don't re-evaluate the score
		if (m.Score > 0)
			return;

		if (!Const.DLC.Paladins)
			return;

		if (World.Assets.getOrigin().getID() != "scenario.oathtakers")
			return;

		local towns = World.EntityManager.getSettlements();
		local nearTown = false;
		local town = null;
		local playerTile = World.State.getPlayer().getTile();

		foreach (t in towns) {
			if (t.isSouthern() || t.isMilitary())
				continue;

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer()) {
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
			return;

		if (!::OFFP.Helpers.hasSkull(World.getPlayerRoster().getAll(), World.Assets.getStash().getItems()))
			return;

		local brothers = World.getPlayerRoster().getAll();
		local candidates = [];

		foreach (bro in brothers) {
			if (bro.getBackground().getID() == "background.paladin")
				candidates.push(bro);
		}

		if (candidates.len() == 0)
			return;

		m.Oathtaker = candidates[Math.rand(0, candidates.len() - 1)];
		m.Town = town;
		m.Score = 25;
	}
});

::mods_hookNewObject("events/events/dlc8/captured_oathbringer_event", function(coe) {
	local onUpdateScore = coe.onUpdateScore;

	coe.onUpdateScore = function() {
		onUpdateScore();

		// If some other mod would normally cause the event to fire, don't re-evaluate the score
		if (m.Score > 0)
			return;

		if (!Const.DLC.Paladins)
			return;

		if (World.Assets.getOrigin().getID() != "scenario.oathtakers")
			return;

		if (World.getTime().Days < 35)
			return;

		local brothers = World.getPlayerRoster().getAll();
		local torturer_candidates = [];
		local haveUpgradedSkull = false;

		foreach(bro in brothers) {
			local item = bro.getItems().getItemAtSlot(Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.oathtaker_skull_02"))
				haveUpgradedSkull = true;

			if (bro.getBackground().getID() == "background.paladin")
				torturer_candidates.push(bro);
		}

		if (!haveUpgradedSkull) {
			local stash = World.Assets.getStash().getItems();

			foreach(item in stash) {
				if (item != null && (item.getID() == "accessory.oathtaker_skull_02")) {
					haveUpgradedSkull = true;
					break;
				}
			}
		}

		if (haveUpgradedSkull)
			return;

		if (torturer_candidates.len() == 0)
			torturer_candidates.push(brothers[Math.rand(0, brothers.len() - 1)]);

		m.Torturer = torturer_candidates[Math.rand(0, torturer_candidates.len() - 1)];
		m.Score = 7;
	}
});

::mods_hookNewObject("events/events/dlc8/bad_reputation_event", function(bre) {
	local onUpdateScore = bre.onUpdateScore;

	bre.onUpdateScore = function() {
		onUpdateScore();

		// If some other mod would normally cause the event to fire, don't re-evaluate the score
		if (m.Score > 0)
			return;

		if (!Const.DLC.Paladins)
			return;

		if (World.Assets.getOrigin().getID() != "scenario.oathtakers")
			return;

		if (World.Assets.getMoralReputation() >= 40.0)
			return;

		m.Score = 15;
	}
});

::mods_hookNewObject("events/events/dlc8/oathtakers_skull_event", function(ose) {
	local onUpdateScore = ose.onUpdateScore;

	ose.onUpdateScore = function() {
		onUpdateScore();

		// If some other mod would normally cause the event to fire, don't re-evaluate the score
		if (m.Score > 0)
			return;

		if (!Const.DLC.Paladins)
			return;

		if (World.Assets.getOrigin().getID() != "scenario.oathtakers")
			return;

		local brothers = World.getPlayerRoster().getAll();
		local oathtaker_candidates = [];

		foreach (bro in brothers) {
			if (bro.getBackground().getID() == "background.paladin" && bro.getMoodState() < Const.MoodState.Neutral)
				oathtaker_candidates.push(bro);
		}

		if (!::OFFP.Helpers.hasSkull(World.getPlayerRoster().getAll(), World.Assets.getStash().getItems()))
			return;

		if (oathtaker_candidates.len() == 0)
			return;

		m.Oathtaker = oathtaker_candidates[Math.rand(0, oathtaker_candidates.len() - 1)];
		m.Score = 5 * oathtaker_candidates.len();
	}
});
