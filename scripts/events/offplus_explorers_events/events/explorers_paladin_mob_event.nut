explorers_paladin_mob_event <- inherit("scripts/events/event", {
	m = {
		Dude		= null
		Monk		= null
		Oathtaker	= null
		Raider		= null
	}

	function create() {
		m.ID		= "event.explorers_paladin_mob";
		m.Title		= "Along the way...";
		m.Cooldown	= 99999.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_43.png[/img]{You enter a small, rundown hamlet, so quiet you wonder if it hasn't been abandoned. As you enter the town square, however, you are stopped by a man in a monk's habit. Behind him is a rather sizeable group of angry looking peasants gripping an assortment of farm tools. The monk addresses you directly.%SPEECH_ON%I know what you are, sellsword. An apostate, that's what! A heretic! The proof is in the black Rot you carry in the filth of your bodies, in your very souls. Aye, I know what you are, vermin. Know this! The Old Gods shall not suffer your presence among their flock any longer! They have granted us a paladin, a holy knight, to cast you out! Leave us now, or be smote! Leave!%SPEECH_OFF%You're in no mood to put up with this madman's verbal abuse, but if he's not bluffing the company may have a fight on its hands.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "I won't see the company treated like this. Bring out this champion of yours."
					function getResult(_event) {
						if (_event.m.Oathtaker != null)
							return "Oathtaker";
						else if (Math.rand(1, 100) < 30 + (World.getTime().Days > 45 ? 20 : 0) + (World.getTime().Days > 70 ? 20 : 0))
							return "Oathbringer";
						else
							return "FakeOathbringer";
					}
				},
				{
					Text = "Fine, this isn't worth our time. We'll go."
					function getResult(_event) { return "Leave"; }
				}
			]

			function start(_event) {
				if (_event.m.Monk != null && World.getPlayerRoster().getSize() < World.Assets.getBrothersMax()) {
					Options.push({
						Text = "%monk%, you're a holy man. What do you make of this so-called 'paladin'?"
						function getResult(_event) { return "Monk"; }
					})
				}

				if (_event.m.Raider != null) {
					Options.push({
						Text = "It looks like %raider% the former raider has something to say."
						function getResult(_event) { return "Raider"; }
					})
				}
			}
		});

		m.Screens.push({
			ID			= "Oathbringer"
			Text		= "[img]gfx/ui/events/event_180.png[/img]{You put your hands on your hips, hock a gob of spit at the zealot's feet, and stand your ground.%SPEECH_ON%Well? Bring him out. I'm ready to be smote.%SPEECH_OFF%The man's crazed grin widens, and he wordlessly motions his champion forward from the crowd. A huge man clad head-to-toe in trophy-adorned armor steps forward, his weapons held at the ready.%SPEECH_ON%And Young Anselm said, 'Suffer not the plague in your midst, for he who bringeth disease bringeth other evils as well.' Hear me, churls! An Oathbringer stands before you, and an Oath of Justice I bring upon you!%SPEECH_OFF%He charges at you, and the rest of the mob follows suit. Defend yourselves!}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "To arms!"
					function getResult(_event) {
						local p = World.State.getLocalCombatProperties(World.State.getPlayer().getPos());
						p.LocationTemplate = clone Const.Tactical.LocationTemplate;

						p.CombatID = "CursedExplorersOathbringerFight";

						p.PlayerDeploymentType = Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = Const.Tactical.DeploymentType.Circle;

						p.Entities = [];

						for (local i = 0; i < 9; ++i)
							p.Entities.push(clone Const.World.Spawn.Troops.Peasant)

						for (local i = 0; i < 4; ++i)
							p.Entities.push(clone Const.World.Spawn.Troops.Militia)

						for (local i = 0; i < 2; ++i)
							p.Entities.push(clone Const.World.Spawn.Troops.MilitiaRanged)

						for (local i = 0; i < 2; ++i)
							p.Entities.push(clone Const.World.Spawn.Troops.MilitiaVeteran)

						local f = World.FactionManager.getFactionOfType(Const.FactionType.Bandits).getID();
						for(local i = 0; i < p.Entities.len(); ++i)
							p.Entities[i].Faction <- f;

						p.BeforeDeploymentCallback = function() {
							local oathbringer = 1;
							do {
								local x = Math.rand(14, 18);
								local y = Math.rand(14, 18);

								local tile = Tactical.getTileSquare(x, y);

								if(!tile.IsEmpty)
									continue;

								local e = Tactical.spawnEntity("scripts/entity/tactical/humans/oathbringer", tile.Coords);
								e.setFaction(f);
								e.assignRandomEquipment();

								--oathbringer;
							}
							while (oathbringer > 0);
						}

						World.State.startScriptedCombat(p, false, false, false);

						return 0;
					}
				}
			]

			function start(_event) {
				local brothers = World.getPlayerRoster().getAll();

				foreach (bro in brothers) {
					local skills = bro.getSkills();
					local rotTraits = [
						"trait.rot_01",
						"trait.rot_02",
						"trait.rot_03",
						"trait.rot_04",
						"trait.rot_05"
					];

					local numRots = 0;
					foreach (trait in rotTraits) {
						if (skills.hasSkill(trait))
							numRots++;
					};

					if (numRots > 1)
						bro.worsenMood(1.0, "Was reviled and driven out for carrying the Rot");
				}
			}
		});

		m.Screens.push({
			ID			= "FakeOathbringer"
			Text		= "[img]gfx/ui/events/event_43.png[/img]{You put your hands on your hips, hock a gob of spit at the zealot's feet, and stand your ground.%SPEECH_ON%Well? Bring him out. I'm ready to be smote.%SPEECH_OFF%The man's crazed expression freezes for a moment, but he simply grunts and his would-be paladin comes out. The man wobbles under the weight of the heavy armor he wears, and you think you can see his legs trembling slightly.\n\nAs he gets closer he begins to stammer out some proclamation about your sins or your plague or some shite and you decide you've had enough of this. You walk up to him and, before he can react, strike him with the hilt of your sword, the pommel making a satisfying 'gong' at it percusses his metal helm. He falls to the ground, and the mob instantly scatters, the monk that led them beating the hastiest retreat of all.\n\nYou rip the helmet off the 'holy knight' and see the face of a slightly dazed, very scared kid. He immediately starts sputtering out an apology.%SPEECH_ON%I'm sorry sirs I didn't mean it they made me do it the armor's not even mine it belonged to some knight we ran out of town, said he was some kind of oathmuncher or oathbungler or somet-%SPEECH_OFF%You draw your sword and he shuts up, eyes wide with fear. You tell him you don't care where he got the armor, but it's yours now and to take it off. After several minutes of desperate fumbling he manages to extract himself and dashes off, leaving you and the company alone in the empty town square. You tell %randombrother% to stow the gear and move on.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "At least we got something for our trouble."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				local potential_armor_loot = [ "armor/adorned_warriors_armor" ];
				local potential_helmet_loot = [ "helmets/adorned_closed_flat_top_with_mail", "helmets/adorned_full_helm" ];

				local item = new("scripts/items/" + potential_armor_loot[Math.rand(0, potential_armor_loot.len() - 1)]);
				List.push({ id = 10, icon = "ui/items/" + item.getIcon(), text = "You gain " + item.getName() });
				World.Assets.getStash().add(item);

				local item = new("scripts/items/" + potential_helmet_loot[Math.rand(0, potential_helmet_loot.len() - 1)]);
				item.setCondition(Math.max(1, item.getConditionMax() * 0.75));
				List.push({ id = 10, icon = "ui/items/" + item.getIcon(), text = "You gain " + item.getName() });
				World.Assets.getStash().add(item);
			}
		});

		m.Screens.push({
			ID			= "Oathtaker"
			Text		= "[img]gfx/ui/events/event_180.png[/img]{You put your hands on your hips, hock a gob of spit at the zealot's feet, and stand your ground.%SPEECH_ON%Well? Bring him out. I'm ready to be smote.%SPEECH_OFF%The man's crazed grin widens, and he wordlessly motions his champion forward from the crowd. A huge man clad head-to-toe in trophy-adorned armor steps forward, his weapons held at the ready.%SPEECH_ON%And Young Anselm said, 'Suffer not the plague in y-%SPEECH_OFF%The man is cut off mid-sentence by a high-pitched, inhuman scream as a blur you vaguely recognize to be %oathtaker% the Oathtaker dashes forward. He is upon the very-surprised Oathbringer in an instant, and in another instant he has caved the man's head in and is madly pulverizing it into a squelching red mist.\n\nThe mob, even more perturbed than you are, backs away slowly before scattering like the wind. You and %randombrother% manage to pull the screaming Oathtaker off the body before he can fully destroy it, and by the time he's calmed down it seems whatever fire stirred in the laity has died down. There are no signs of life in the village beyond nervous glances peeking out from boarded up windows. An almost normal reception for a mercenary company, if one ignores the ruined body on the street. You tell the men to try to salvage the Oathbringer's armor and continue on your way.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "I'll never understand these religious types."
					function getResult(_event) {
						return 0;
					}
				}
			]

			function start(_event) {
				_event.m.Oathtaker.getBaseProperties().Initiative += 4;
				_event.m.Oathtaker.getSkills().update();

				List.push( { id = 16, icon = "ui/icons/initiative.png", text = _event.m.Oathtaker.getName() + " gains [color=" + Const.UI.Color.PositiveEventValue + "]+4[/color] Initiative" } );

				local potential_loot = [ "armor/adorned_mail_shirt", "armor/adorned_warriors_armor" ];

				local item = new("scripts/items/" + potential_loot[Math.rand(0, potential_loot.len() - 1)]);
				item.setCondition(Math.max(1, item.getConditionMax() * 0.5));
				List.push({ id = 10, icon = "ui/items/" + item.getIcon(), text = "You gain " + item.getName() });
				World.Assets.getStash().add(item);

				Characters.push(_event.m.Oathtaker.getImagePath());
			}
		});

		m.Screens.push({
			ID			= "Monk"
			Text		= "[img]gfx/ui/events/event_180.png[/img]{%monk% the monk steps forward and asks the peasant's muscle to do the same. A large man clad in fantastic looking armor comes forth.%SPEECH_ON%I apologize, mercenaries, but I have taken an Oath to protect the troubled, as these villagers are, and on Young Anselm's honor I cannot renege my duty. Please, leave in peace.%SPEECH_OFF%%monk% nods thoughtfully and counters the Oathtaker.%SPEECH_ON%A noble duty, to be sure. Consider, however, that if the Old Gods truly wished us gone, they could see it done without mortal intervention. No, I believe that this disease which afflicts us is a challenge, a test of our faith, for all things happen under their intent. Our meeting must be no different. We seek a cure to our condition, and the elimination of the Rot would safeguard more than just these villagers. Why not join us? Surely a follower of Young Anselm would find this a worthy goal?%SPEECH_OFF%The man thinks about it for not very long at all and claps %monk% on the back.%SPEECH_ON%A fine point, friend! I believe I shall join you on this quest of yours! An auspicious turn of events indeed!%SPEECH_OFF%}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Er, happy to have you aboard."
					function getResult(_event) {
						return "MonkAcceptRecruit";
					}
				},
				{
					Text = "We have no place for you."
					function getResult(_event) {
						return "MonkRejectRecruit";
					}
				}
			]

			function start(_event) {
				local roster = World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([ "paladin_background" ]);
				_event.m.Dude.getBackground().m.RawDescription = "You met %name% in a small, backwards village where a local clergyman tried to use the Oathtaker to scare the %companyname% off. Hearing of your quest, he instead decided to join the company. The man gives endless sermons about Young Anselm's virtues and some sort of 'Oath of Illness', which wears a little thin, but you've no complaints about his skills as a fighter.";
				_event.m.Dude.getBackground().buildDescription(true);

				Characters.push(_event.m.Monk.getImagePath());
				Characters.push(_event.m.Dude.getImagePath());
			}
		});

		m.Screens.push({
			ID			= "MonkAcceptRecruit"
			Text		= "[img]gfx/ui/events/event_180.png[/img]{The Oathtaker strides into the company ranks and the mob stands there awkwardly, unsure what to do. The leader coughs nervously.%SPEECH_ON%Er, uh, this is clearly a sign from the gods that your condition has a purpose. We, er, of course welcome those touched by such divine provenance.%SPEECH_OFF%The man quickly walks away, glancing over his shoulder to check if you're following. Without their leader, the rest of the mob quickly disperses.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Fickle gods, these."
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
				Characters.push(_event.m.Monk.getImagePath());
				Characters.push(_event.m.Dude.getImagePath());
			}
		});

		m.Screens.push({
			ID			= "MonkRejectRecruit"
			Text		= "[img]gfx/ui/events/event_180.png[/img]{You inform the man of your decision and there's an awkward pause before %monk% interjects again.%SPEECH_ON%It wouldn't do for you to catch our affliction as well, you see. We can cover more ground if we split up.%SPEECH_OFF%This seems to satisfy the Oathtaker's honor and he nods eagerly in agreement before promptly leaving. The mob awkwardly stands there, unsure what to do. The leader coughs nervously.%SPEECH_ON%Er, uh, this is clearly a sign from the gods that your condition has a purpose. We, er, of course welcome those touched by such divine provenance.%SPEECH_OFF%The man quickly walks away, glancing over his shoulder to check if you're following. Without their leader, the rest of the mob quickly disperses.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Fickle gods, these."
					function getResult(_event) {
						return 0;
					}
				}
			]

			function start(_event) {
				Characters.push(_event.m.Monk.getImagePath());
			}
		});

		m.Screens.push({
			ID			= "Raider"
			Text		= "[img]gfx/ui/events/event_64.png[/img]{%raider% the raider steps forward and spits at the monk.%SPEECH_ON%What fools. Aye, we've the Rot, but it doesn't stop us from fighting. We'll be fine. But you, you lot are living closer to death than we are. When the men and beasts in the hills come for you,  and some farker puts an axehead in your back or a wolf tears out your lungs, remember how you drove away the sellswords that could have killed them. You can be sure word'll spread fast of a village too good to hire protection.%SPEECH_OFF%The man stalks out of the village, and you and the rest of the company follow suit. The mob hurls jeers and insults at your backs, but you can tell the raider's words struck a nerve. At the edge of town one of the local guildmasters sidles up to you furtively, a pouch of crowns jangling in his hands.%SPEECH_ON%Your man has the right of it, as you and I both know. Give me some time to dispell that zealot's notions from their heads. We have no feud with sellswords, regardless of their...condition, so long as they're reliable and get the job done. You're a business man, I'm sure you understand. Here, a show of good faith. Give me time!%SPEECH_OFF%The man practically shoves the pouch into your hands before dashing off. %randombrother% looks at you and shrugs.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Well, alright."
					function getResult(_event) {
						return 0;
					}
				}
			]

			function start(_event) {
				World.Assets.addMoney(75);
				List.push({ id = 10, icon = "ui/icons/asset_money.png", text = "You gain [color=" + Const.UI.Color.PositiveEventValue + "]75[/color] Crowns" });

				local brothers = World.getPlayerRoster().getAll();
				foreach (bro in brothers) {
					local skills = bro.getSkills();
					local rotTraits = [
						"trait.rot_01",
						"trait.rot_02",
						"trait.rot_03",
						"trait.rot_04",
						"trait.rot_05"
					];

					local numRots = 0;
					foreach (trait in rotTraits) {
						if (skills.hasSkill(trait))
							numRots++;
					};

					if (numRots > 1 && bro.getID() != _event.m.Raider.getID()) {
						bro.improveMood(0.75, "" + _event.m.Raider.getNameOnly() + " put some superstitious peasants in their place");

						if (bro.getMoodState() > Const.MoodState.Neutral)
							List.push({ id = 11, icon = Const.MoodStateIcon[bro.getMoodState()], text = bro.getName() + Const.MoodStateEvent[bro.getMoodState()] });
					}
				}

				Characters.push(_event.m.Raider.getImagePath());
			}
		});

		m.Screens.push({
			ID			= "Leave"
			Text		= "[img]gfx/ui/events/event_43.png[/img]{You sigh. You don't feel particularly threatened by this 'holy knight', but you're not particularly eager to slaughter a village either, even if in self-defense. Over the protests of the men and the jeers of the mob, you turn the men around and filter out of the hamlet.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "It's not worth a fight."
					function getResult(_event) {
						return 0;
					}
				}
			]

			function start(_event) {
				local brothers = World.getPlayerRoster().getAll();

				foreach (bro in brothers) {
					local skills = bro.getSkills();
					local rotTraits = [
						"trait.rot_01",
						"trait.rot_02",
						"trait.rot_03",
						"trait.rot_04",
						"trait.rot_05"
					];

					local numRots = 0;
					foreach (trait in rotTraits) {
						if (skills.hasSkill(trait))
							numRots++;
					};

					if (numRots > 1) {
						bro.worsenMood(1.0, "Was reviled and driven out for carrying the Rot");
						bro.worsenMood(0.5, "Felt you didn't stand up for the company");

						if (bro.getMoodState() < Const.MoodState.Neutral)
							List.push({ id = 11, icon = Const.MoodStateIcon[bro.getMoodState()], text = bro.getName() + Const.MoodStateEvent[bro.getMoodState()] });
					}
				}
			}
		});
	}

	function onUpdateScore() {
		if (!Const.DLC.Unhold || !Const.DLC.Paladins)
			return;

		if (World.Assets.getOrigin().getID() != "scenario.explorers")
			return;

		if (World.Assets.getBusinessReputation() < 550)
			return;

		local brothers = World.getPlayerRoster().getAll();
		local monk_candidates = [];
		local oathtaker_candidates = [];
		local raider_candidates = [];
		foreach (bro in brothers) {
			if (bro.getBackground().getID() == "background.monk" || bro.getBackground().getID() == "background.pacified_flagellant")
				monk_candidates.push(bro);
			else if (bro.getBackground().getID() == "background.paladin")
				oathtaker_candidates.push(bro);
			else if (bro.getBackground().getID() == "background.raider")
				raider_candidates.push(bro);
		}

		if (monk_candidates.len() > 0)
			m.Monk = monk_candidates[Math.rand(0, monk_candidates.len() - 1)];

		if (oathtaker_candidates.len() > 0)
			m.Oathtaker = oathtaker_candidates[Math.rand(0, oathtaker_candidates.len() - 1)];

		if (raider_candidates.len() > 0)
			m.Raider = raider_candidates[Math.rand(0, raider_candidates.len() - 1)];

		m.Score = 5;
	}

	function onPrepare() { }

	function onPrepareVariables(_vars) {
		_vars.push([ "monk", m.Monk ? m.Monk.getNameOnly() : "" ]);
		_vars.push([ "oathtaker", m.Oathtaker ? m.Oathtaker.getNameOnly() : "" ]);
		_vars.push([ "raider", m.Raider ? m.Raider.getNameOnly() : "" ]);
	}

	function onClear() {
		m.Dude = null;
		m.Monk = null;
		m.Oathtaker = null;
		m.Raider = null;
	}
});
