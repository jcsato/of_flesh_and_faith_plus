death_knight_confrontation_event <- inherit("scripts/events/event",
{
	m =
	{
		Champion			= null
		ChampionCandidates	= []
		Dude				= null
	}

	function create()
	{
		m.ID		= "event.death_knight_confrontation";
		m.Title		= "Along the way...";
		m.Cooldown	= 99999.0 * World.getTime().SecondsPerDay;


		m.Screens.push({
							ID			= "A"
							Text		= "{%terrainImage%As you make your way through the wilderness, you are stopped by a peculiar sight indeed. A barbarian warrior clad in thick plated armor stands in the middle of your path - and you see that resting beneath his tented, calloused hands is Ironhand's rune blade! You'd thought the weapon lost forever, but here it is before your eyes, the familiar pocks and scratches of its runed surface immediately marking it as the real thing. The man addresses you.%SPEECH_ON%I know who you are. Old Ironhand is displeased by your carelessness with his gift. But he sees potential in you. I was tasked with retrieving his blade and returning it you, if you prove yourselves worthy. Put forth your greatest warrior. We shall duel, and we shall die. Once the price is paid, the blade shall be yours again.%SPEECH_OFF%You consider the man and his offer. Whoever he is, it's clear he's extremely dangerous, but if he acts under Old Ironhand's auspice you can at least take him at his word.}"
							Image		= ""
							List		= [ ]
							Characters	= [ ]
							Options		= [ ]
							function start(_event) {
								local candidates = _event.m.ChampionCandidates;
								candidates.sort(function(_bro1, _bro2) {
									if(_bro1.getXP() > _bro2.getXP())
										return -1;
									else if(_bro1.getXP() < _bro2.getXP())
										return 1;
									return 0;
								})

								local numChampions = Math.min(3, candidates.len())
								for(local i = 0; i < numChampions; ++i) {
									local bro = candidates[i];

									Options.push(
									{
										Text = "{Very well, | So be it. | Our champion} " + bro.getName() + " shall fight you for the blade."
										function getResult(_event) {
											_event.m.Champion = bro;
											if (Math.rand(1, 100) <= 50)
												return "B";
											else
												return "C";
										}
									});
								}

								Options.push({
									Text = "There'll be no duels today."
									function getResult(_event) { return "D"; }
								});

								local roster = World.getTemporaryRoster();
								_event.m.Dude = roster.create("scripts/entity/tactical/player");
								_event.m.Dude.setStartValuesEx([ "barbarian_background" ]);
								_event.m.Dude.getBackground().m.RawDescription = "%name% is a true chosen, acting on visions granted by Old Ironhand to go mete out the god's judgement upon the world. He holds no doubts as to his purpose, and seeks the true end in all he does. This has done no favors to the man's personality, but one can't deny his skill as a warrior.";
								_event.m.Dude.getBackground().buildDescription(true);
								_event.m.Dude.m.PerkPoints = 9;
								_event.m.Dude.m.LevelUps = 9;
								_event.m.Dude.m.Level = 10;

								local dudeItems = _event.m.Dude.getItems();
								dudeItems.unequip(dudeItems.getItemAtSlot(Const.ItemSlot.Head));
								dudeItems.equip(new("scripts/items/helmets/barbarians/crude_faceguard_helmet"));
								dudeItems.unequip(dudeItems.getItemAtSlot(Const.ItemSlot.Body));
								dudeItems.equip(new("scripts/items/armor/barbarians/thick_plated_barbarian_armor"));

								dudeItems.unequip(dudeItems.getItemAtSlot(Const.ItemSlot.Mainhand));
								dudeItems.equip(new("scripts/items/weapons/legendary/barbarian_runeblade"));

								Characters.push(_event.m.Dude.getImagePath());
							}
						});

		m.Screens.push({
							ID			= "B"
							Text		= "{%terrainImage%%champion% steps up, ready to fight. He locks eyes with the barbarian for a moment, then lunges forward. There's a flash of metal and a spurt of blood and, to your shock, you see the mercenary's decapitated head soar through the air before landing with a clunk. The stranger relaxes his stance and bows his head.%SPEECH_ON%A fine strike and a true warrior. Were I not guided by the cloaked will, it would be mine death this day and not his. Let a rune be carved.%SPEECH_OFF%The men, though clearly disturbed by the the death of a comrade, are somewhat mollified by this display of respect. Some of the more devout men in the company even seem to be inspired by the rune knight's adherence to the old ways. You order a rune carved for %champion%, and the stranger takes up a place in the ranks.%SPEECH_ON%I would visit mine death upon Ironhand's foes under your command, captain. I can see that the warriors you travel with serve his will admirably, and I assure you that you won't find my skills wanting for a place in your renewed band.%SPEECH_OFF%Seeing as how the %companyname% just lost one of its most veteran fighters, you agree to his request, provided he understands that you're in charge. He nods.%SPEECH_ON%Of course. Ironhand saw fit that you should receive his talon not once, but twice. It's a privilege to follow such a favored chosen.%SPEECH_OFF%}"
							Image		= ""
							List		= [ ]
							Characters	= [ ]
							Options		= [
											{
												Text = "Very well. Then together our deaths we shall visit upon Ironhand's foes."
												function getResult(_event)
												{
													World.getPlayerRoster().add(_event.m.Dude);
													World.getTemporaryRoster().clear();
													_event.m.Dude.onHired();
													_event.m.Dude.getFlags().increment("numActiveRunes");
													_event.m.Dude.getSkills().add(new("scripts/skills/effects/rune_04_effect"));
													_event.m.Dude = null;
													return 0;
												}
											}
										]

							function start(_event) {
								Characters.push(_event.m.Dude.getImagePath());

								List.push({	id = 13, icon = "ui/icons/kills.png", text = _event.m.Champion.getName() + " has died" });
								_event.m.Champion.getItems().transferToStash(World.Assets.getStash());
								World.getPlayerRoster().remove(_event.m.Champion);

								local item = new("scripts/items/misc/runeknights/rune_05_item");
								World.Assets.getStash().add(item);
								List.push({ id = 10, icon = "ui/items/" + item.getIcon(), text = "You gain " + item.getName() });

								if (_event.m.Champion.getSkills().hasSkill("effects.rune_07")) {
									item = new("scripts/items/misc/runeknights/rune_07_item");
									World.Assets.getStash().add(item);
									List.push({ id = 10, icon = "ui/items/" + item.getIcon(), text = "You gain " + item.getName() });
								}

								local brothers = World.getPlayerRoster().getAll();

								foreach( bro in brothers ) {
									if (bro.getBackground().getID() == "background.barbarian" || bro.getFlags().getAsInt("numActiveRunes") >= 3) {
										bro.improveMood(0.5, "Feels that Old Ironhand has set the company on the right path");

										if (bro.getMoodState() >= Const.MoodState.Neutral)
											List.push({ id = 10, icon = Const.MoodStateIcon[bro.getMoodState()], text = bro.getName() + Const.MoodStateEvent[bro.getMoodState()] });
									} else if (bro.getBackground().getID() == "background.killer_on_the_run") {
										bro.improveMood(0.5, "Saw " + _event.m.Champion.getName() + " killed");

										if (bro.getMoodState() >= Const.MoodState.Neutral)
											List.push({ id = 10, icon = Const.MoodStateIcon[bro.getMoodState()], text = bro.getName() + Const.MoodStateEvent[bro.getMoodState()] });
									} else {
										bro.worsenMood(0.5, "Saw " + _event.m.Champion.getName() + " killed");

										if (bro.getMoodState() < Const.MoodState.Neutral)
											List.push({ id = 10, icon = Const.MoodStateIcon[bro.getMoodState()], text = bro.getName() + Const.MoodStateEvent[bro.getMoodState()] });
									}
								}
							}
						});

		m.Screens.push({
							ID			= "C"
							Text		= "{%terrainImage%%champion% steps up and locks eyes with the barbarian for a moment, then the two begin circling each other. They go round and round for what feels like an eternity, then the mercenary leaps forward with a yell and brings down his weapon and the barbarian moves to parry, but too slowly, and then it's over. The warrior lies dead, the rune blade clutched loosely in his fingers. %champion% shrugs.%SPEECH_ON%That was it? I was expecting more after all that talk.%SPEECH_OFF%You tell him to collect the weapon and get the company back on the road.}"
							Image		= ""
							List		= [ ]
							Characters	= [ ]
							Options		= [
											{
												Text = "We have the rune blade once more!"
												function getResult(_event) { return 0; }
											}
										]

							function start(_event) {
								Characters.push(_event.m.Champion.getImagePath());

								local item = new("scripts/items/weapons/legendary/barbarian_runeblade");
								World.Assets.getStash().add(item);
								List.push({ id = 10, icon = "ui/items/" + item.getIcon(), text = "You gain " + item.getName() });

								_event.m.Champion.improveMood(1.0, "Bested a barbarian warrior in single combat");
								if (_event.m.Champion.getMoodState() >= Const.MoodState.Neutral)
									List.push({ id = 10, icon = Const.MoodStateIcon[_event.m.Champion.getMoodState()], text = _event.m.Champion.getName() + Const.MoodStateEvent[_event.m.Champion.getMoodState()] });
							}
						});

		m.Screens.push({
							ID			= "D"
							Text		= "{%terrainImage%The warrior scoffs derisively at you.%SPEECH_ON%No chosen of Ironhand's ever achieved greatness by clinging desperately to life. Very well, then. He has no time for your cowardice, nor do I. When I find the true end, you shall be not even a memory, mercenary.%SPEECH_OFF%He spits out the last word and stalks off, taking the rune blade with him. The more devout adherents in the company are troubled by this turn of events, but they'll live to get over it, and that's what matters right now.}"
							Image		= ""
							List		= [ ]
							Characters	= [ ]
							Options		= [
											{
												Text = "We'll see Ironhand's will done with the weapons we have now."
												function getResult(_event) { return 0; }
											}
										]

							function start(_event) {
								Characters.push(_event.m.Dude.getImagePath());

								local brothers = World.getPlayerRoster().getAll();

								foreach( bro in brothers ) {
									if (bro.getBackground().getID() == "background.barbarian" || bro.getFlags().getAsInt("numActiveRunes") >= 3) {
										bro.worsenMood(0.75, "Is worried the company has strayed from the followings of Old Ironhand");

										if (bro.getMoodState() < Const.MoodState.Neutral)
											List.push({ id = 10, icon = Const.MoodStateIcon[bro.getMoodState()], text = bro.getName() + Const.MoodStateEvent[bro.getMoodState()] });
									}
								}
							}
						});
	}

	function onUpdateScore() {
		if (!Const.DLC.Wildmen || !Const.DLC.Paladins)
			return;

		if (World.Assets.getOrigin().getID() != "scenario.runeknights")
			return;

		if (World.getPlayerRoster().getSize() >= World.Assets.getBrothersMax() || World.getPlayerRoster().getSize() < 3)
			return;

		if (World.Assets.getStash().getNumberOfEmptySlots() < 2)
			return;

		if (World.Assets.getBusinessReputation() < 1800)
			return;

		local towns = World.EntityManager.getSettlements();
		local nearTown = false;
		local playerTile = World.State.getPlayer().getTile();

		foreach( t in towns ) {
			if (t.getTile().getDistanceTo(playerTile) <= 3) {
				nearTown = true;
				break;
			}
		}

		if (nearTown)
			return;

		local brothers = World.getPlayerRoster().getAll();
		local haveRuneblade = false;
		local champion_candidates = []

		foreach( bro in brothers ) {
			local item = bro.getItems().getItemAtSlot(Const.ItemSlot.Mainhand);

			if (item != null && item.getID() == "weapon.barbarian_runeblade")
				haveRuneblade = true;

			if (bro.getLevel() >= 10 && bro.getFlags().getAsInt("numActiveRunes") > 0)
				champion_candidates.push(bro);
		}

		if (!haveRuneblade) {
			local stash = World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && item.getID() == "weapon.barbarian_runeblade")
				{
					haveRuneblade = true;
					break;
				}
			}
		}

		if (haveRuneblade)
			return;

		if (champion_candidates.len() < 1)
			return;

		m.ChampionCandidates = champion_candidates;

		m.Score = 10;
	}

	function onPrepare() { }

	function onPrepareVariables(_vars) {
		_vars.push([ "champion", m.Champion != null ? m.Champion.getName() : "" ]);
	}

	function onClear() {
		m.Champion				= null;
		m.ChampionCandidates	= [];
		m.Dude					= null;
	}
})
