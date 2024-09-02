::mods_hookNewObject("events/events/dlc2/location/fountain_of_youth_event", function(foye) {
	local onDetermineStartScreen = ::mods_getMember(foye, "onDetermineStartScreen");

	foye.m.Screens.push({
		ID			= "ExplorersRejected"
		Text		= "[img]gfx/ui/events/event_114.png[/img]{You find yourself at the edge of a forest clearing thick with fog. You step in, and within a few paces find your eyes cannot penetrate the shroud in any direction. You realize you have no idea what direction is back. You're trapped.\n\nAs you flounder, suddenly the fog in front of you begins moving. Slowly, what appears to be a human face forms, its misty eyes affixed on you. All is still for a moment, then a lilting voice crawls up your spine, around your neck, and into your ears.%SPEECH_ON%Not. Enough. Harvest. More.%SPEECH_OFF%You blink, and find yourself back outside the clearing, its contents still invisible. The men don't seem have noticed your disappearance, or indeed the strangely shrouded glade nearby.}"
		Image		= ""
		List		= [ ]
		Characters	= [ ]
		Options		= [
			{
				Text = "Let's get out of here."
				function getResult(_event) {
					if (World.State.getLastLocation() != null)
						World.State.getLastLocation().setVisited(false);

					return 0;
				}
			}
		]

		function start(_event) { }
	});

	foye.m.Screens.push({
		ID			= "ExplorersWonA"
		Text		= "[img]gfx/ui/events/event_114.png[/img]{You find yourself at the edge of a forest clearing and the sight therein sends chills down your spine.\n\nA trunk of a human body runs up out of the eart like a slender tree, naked and bristling, goosebumps for bark, continuing upward until it is twice as tall as yourself. There are no branches. There are no hands. There are, instead, a series of human heads bound in a bunch where a tree crown should be. From left to right they are babyish and beautifully present, ambiguously sexless, malformed creations of time it seems, where the shadows they themselves author turn their faces from ones oddly familiar to strangely naive, as they stare about as though they knew not how they got there and seem ever ready to ask it of you. It reminds you of a drowning you happened upon, the face contorting beneath the running river water, the flesh suffering nothing short of constant conjecture as to what put it there.\n\nThe sight fills you with a joy and dread you've never felt before. This is the tree, the Fountain of Youth for which you have searched! Before you can think to call the men over, whispers sift in. They riffle over the ground as if spoken by the bugs, and they clamber up your arms until they scratch at your very ears. They tell you to stay. They tell you to approach.}"
		Image		= ""
		List		= [ ]
		Characters	= [ ]
		Options		= [
			{
				Text = "What does it want?"
				function getResult(_event) { return "ExplorersWonB"; }
			},
			{
				Text = "This isn't right. We need to leave."
				function getResult(_event) {
					if (World.State.getLastLocation() != null)
						World.State.getLastLocation().setVisited(false);

					return 0;
				}
			}
		]

		function start(_event) { }
	});

	foye.m.Screens.push({
		ID			= "ExplorersWonB"
		Text		= "[img]gfx/ui/events/event_114.png[/img]{Upon entering the clearing, the bizarre creature straightens up, swaying its heads from side to side like a peacock readying a display. They speak to you.%SPEECH_ON%The. Elder. Yes. Here. Yes. Him. We. Know. Him. We. Knew.%SPEECH_OFF%The faces warp and discolor as though blemished in the wake of the words leaving their very mouths. Slowly they reform to speak again, a grotesque panoply punctuating itself one head at a time.%SPEECH_ON%Drink. Nothing. Life. Empty. Death. Full. Give. Death. Create. Life.%SPEECH_OFF%You look down to see an earthen overhang curving across a shallow bowl in the ground. You somehow know it's supposed to be full of something, but it is assuredly empty, and the realization brings you a grief you cannot understand. You look up to see the faces looking down, their appearances molding from anguish to happiness to surprise to fear to confusion, before eventually settling in a grim stare.\n\nYou look at your hands and find them empty. You look back and see nothing. You exist in a total emptiness, no color, no light, no shadow. Just you and the tree.}"
		Image		= ""
		List		= [ ]
		Characters	= [ ]
		Options		= [
			{
				Text = "What is going on?!"
				function getResult(_event) { return "ExplorersWonC"; }
			}
		]

		function start(_event) { }
	});

	foye.m.Screens.push({
		ID			= "ExplorersWonC"
		Text		= "[img]gfx/ui/events/event_114.png[/img]{You open your mouth but no words come out. Instead, an inky shadow begins to dribble from your lips, then stream from them, then you are on your knees vomiting an impossible torrent of the blackness from some unknown source. Your mouth, nostrils, even your eyes and ears exist as nothing but portals for the Rot to escape - and deep down in some primitive part of your mind you know that this is, indeed, the Rot.\n\nJust as you think your body can take no more, the flow stops and your arms give out. You fall into the pool of Rot beneath you and find another world beneath its surface, one of dim, featureless light. An elderly man stares at you, brow furrowed, eyes haggard. He gives you a small, sad smile, then blinks out of existence. The voice from before fills your ears again, coming from all directions.%SPEECH_ON%The. Price. Paid. The. Fountain. Flows.%SPEECH_OFF%You press your palms firmly against the ground and pull yourself out of the Rot with all your strength. The tree is nowhere to be seen. The pool of Rot is gone, a small, muddy pool of condensation in its place. As you rise to your feet and try to get your bearings, %randombrother% runs up to you in a panic.%SPEECH_ON%Sir! Sir! The Rot! It-It's gone! We're cured!%SPEECH_OFF%You become aware of its absence as well, the pain and exhaustion you'd become so accustomed to nowhere to be felt. The men are ecstatic, of course, if a little confused.%SPEECH_ON%I say we keep looking for the Fountain of Youth, nay, I say we redouble are efforts! The Rot took more than its fair share of my life, and I intend to take just as much back from the fountain!%SPEECH_OFF%The rest of the men cheer, but you know that you, at least, will never find the tree or the fountain again, and that something has been taken from you that will never come back. With the Rot cured, perhaps it's time to retire, and leave this life behind you?\n\n%OOC%You\'ve won! Battle Brothers is designed for replayability and for campaigns to be played until you\'ve beaten one or two late game crises. Starting a new campaign will allow you to try out different things in a different world.\n\nYou can also choose to continue your campaign for as long as you want. Just be aware that campaigns are not intended to last forever and you\'re likely to run out of challenges eventually.%OOC_OFF%}"
		Image		= ""
		List		= [ ]
		Characters	= [ ]
		Options		= [
			{
				Text = "The %companyname% needs their commander!",
				function getResult( _event ) {
					if (World.State.getLastLocation() != null)
						World.State.getLastLocation().die();

					return 0;
				}
			},
			{
				Text = "It\'s time to retire from mercenary life. (End Campaign)",
				function getResult( _event ) {
					World.State.getMenuStack().pop(true);
					World.State.showGameFinishScreen(true);
					return 0;
				}
			}
		]

		function start(_event) {
			World.Statistics.getFlags().set("CursedExplorersRotCured", true);

			local brothers = World.getPlayerRoster().getAll();
			foreach (bro in brothers) {
				bro.getFlags().increment("CursedExplorersLegendaryLocations");
				bro.getSkills().removeByID("trait.rot_01");
				bro.getSkills().removeByID("trait.rot_02");
				bro.getSkills().removeByID("trait.rot_03");
				bro.getSkills().removeByID("trait.rot_04");
				bro.getSkills().removeByID("trait.rot_05");
			}
		}
	});

	foye.onDetermineStartScreen = function() {
		if (World.Assets.getOrigin().getID() != "scenario.explorers") {
			return onDetermineStartScreen();
		} else {
			local brothers = World.getPlayerRoster().getAll();
			local totalRot = 0;

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

				totalRot += numRots;
			}

			if (totalRot < 20)
				return "ExplorersRejected";
			else
				return "ExplorersWonA";
		}
	}
});

::mods_hookNewObject("events/events/dlc6/location/oracle_enter_event", function(oee) {
	local onDetermineStartScreen = ::mods_getMember(oee, "onDetermineStartScreen");

	oee.m.Screens.push({
		ID			= "SouthernAssassinsProphetStart"
		Text		= "[img]gfx/ui/events/event_152.png[/img]{You approach the Oracle, taking in the structure and the tent city that surrounds it. It's a good place to hide, with more than enough pilgrims to blend into while sending agents to and fro, but not enough official presence for the powerful to run afoul of the authorities. In hindsight, an almost obvious place for the Prophet to use as his base of operations.\n\nHe's in there, somewhere, with his cadre of mercenaries and adherents and whatever else. It's been some time since you set off and formed the %companyname% to slay him - but is the company ready?}"
		Image		= ""
		List		= [ ]
		Characters	= [ ]
		Options		= [
			{
				Text = "It's time to finish this."
				function getResult(_event) { return "SouthernAssassinsProphetPreFight"; }
			},
			{
				Text = "There's something else we have to take care of first."
				function getResult(_event) {
					local oracle_event = World.Events.getEvent("event.location.oracle_enter");
					oracle_event.m.CooldownUntil = Time.getVirtualTimeF();

					local locations = World.EntityManager.getLocations();
					foreach (l in locations) {
						if (l.getTypeID() == "location.holy_site.oracle")
							l.setVisited(false);
					}
					return 0;
				}
			}
		]

		function start(_event) { }
	});

	oee.m.Screens.push({
		ID			= "SouthernAssassinsProphetPreFight"
		Text		= "[img]gfx/ui/events/event_152.png[/img]{As you enter the tent city, you are approached by Firi Al-Kashim, the short, robed emissary who first extended the Prophet's invitation to you. He wastes no time on formalities.%SPEECH_ON%It is good you have come. He awaits. Follow me.%SPEECH_OFF%Firi leads you and the men through a maze of pilgrims, stopping in front of two guards posted to a large tent. He flashes a hand gesture you cannot see and they let you inside. Firi moves a few boxes and pulls aside a large rug, revealing a trapdoor underneath.%SPEECH_ON%Tell your men not to stray. The pathways underneath the Oracle are complex, and it is a simple matter for the uninitiated to become lost and...expire within.%SPEECH_OFF%You idly wonder how one goes about being initiated into this sect and follow the man. It turns out he wasn't exaggerating. The tunnels sprawl out like an anthill, full of dead ends, traps, and false walls. There is no light save for the dim flicker of Firi's lantern as glides ahead of you.\n\nYou continue that way for some time, long enough that you wonder if your guide himself is lost. Then you see a shaft of light ahead and Firi leads you above ground into a desert encampment. As your eyes adjust, you see the Oracle in the distance, further away than you'd expected. This must be one of the myriad ruins that dot the area around the holy site - no doubt the Prophet has camps such as this set up in many of them.}"
		Image		= ""
		List		= [ ]
		Characters	= [ ]
		Options		= [
			{
				Text = "Clever. Now where is the Prophet?"
				function getResult(_event) { return "SouthernAssassinsProphetFight"; }
			}
		]

		function start(_event) { }
	});

	oee.m.Screens.push({
		ID			= "SouthernAssassinsProphetFight"
		Text		= "[img]gfx/ui/events/event_167.png[/img]{An eclectic group of armed men stands before you, obviously mercenaries. Many are northerners, but you see a few southerners in the ranks as well - and there, in the shadows, robed men invisible to the untrained eye. It seems some of the guilds' previously failed attempts were just thwarted, but subverted.\n\nOn a small dais in the center of them all sits an imposing man, clad head to toe in black and gold armor, whom you take to be the Prophet. He motions for you to sit on a nearby seat and speaks in a deep voice.%SPEECH_ON%Welcome, Crownlings. Firi has told me much of your exploits. It is good that you have come, for I have need of men like you. The Gilder himself has given me visions of a great evil brewing in the mountains, an evil of flesh and...of stone.%SPEECH_OFF%He pauses and motions with his arm toward a cluster of statues. Each has been defaced, left with raw, chipped stone where artisans' features used to rest. Seeing your quizzical look, the Prophet continues.%SPEECH_ON%I'm sure you have many questions, but before we discuss further how you can help me, let us discuss how I can help you. You are something of a curiosity to me, I admit. I understand the mind of a Crownling - it is motivated by the Gilder's coin, and rightly so, for what is a life that lacks that most important of his many gleams? I understand also the mind of an Assassin - it is motivated by faith and the promises of paradise, though they be empty ones coming from that wretched fossil of a man. But you...you are both. What drives you, oh castaway of the guilds? Is it loyalty to a man that exiled you and sent you here to die? Is it the crowns you make selling your skills for the amusement of others?%SPEECH_OFF%You and the rest of the men calmly rise to your feet, unfazed that the man knows who - what - you are, nor by his guards as they draw their weapons. For a moment, you see not the Prophet, but an elderly, bearded man you recognize from...somewhere, now smiling, now grimacing, now stern and sightless in the face of the fiery death. Then it's gone, and before you once more is the pretender in his golden armor, surrounded by his little guards. %randombrother% steps forward and scoffs.%SPEECH_ON%Is the Gilder so sightless that his own prophet cannot see into the shadows of his gleam? Or is this just the extent of one who sees himself a ruler in the reflection of his coins? There's only one thing you can offer us, and that's your head. No need to give it here, we'll come take it ourselves.%SPEECH_OFF%}"
		Image		= ""
		List		= [ ]
		Characters	= [ ]
		Options		= [
			{
				Text = "Well said. To arms!"
				function getResult(_event) {
					if (World.State.getLastLocation() != null)
						World.State.getLastLocation().setVisited(false);

					World.Statistics.getFlags().set("SouthernAssassinsProphetFightTriggered", true);

					local p = World.State.getLocalCombatProperties(World.State.getPlayer().getPos());
					p.LocationTemplate = clone Const.Tactical.LocationTemplate;

					p.CombatID = "SouthernAssassinsProphetFight";
					p.LocationTemplate.Template[0] = "tactical.southern_ruins";
					p.LocationTemplate.Fortification = Const.Tactical.FortificationType.Walls;

					p.Music = Const.Music.OrientalCityStateTracks;
					p.PlayerDeploymentType = Const.Tactical.DeploymentType.LineBack;
					p.EnemyDeploymentType = Const.Tactical.DeploymentType.Line;

					p.Entities = [];

					local additional_troops = 1;
					if (World.Assets.getCombatDifficulty() == Const.Difficulty.Hard)
						++additional_troops;
					if (World.Assets.getCombatDifficulty() == Const.Difficulty.Easy)
						--additional_troops;

					for (local i = 0; i < 9 + additional_troops; ++i)
						p.Entities.push(clone Const.World.Spawn.Troops.Mercenary)

					for (local i = 0; i < 3 + additional_troops; ++i)
						p.Entities.push(clone Const.World.Spawn.Troops.MercenaryRanged)

					local f = World.FactionManager.getFactionOfType(Const.FactionType.OrientalBandits).getID();
					for (local i = 0; i < p.Entities.len(); ++i)
						p.Entities[i].Faction <- f;

					p.BeforeDeploymentCallback = function() {
						// prophet
						local prophet = 1;
						do {
							local x = Math.rand(21, 23);
							local y = Math.rand(15, 17);

							local tile = Tactical.getTileSquare(x, y);

							if(!tile.IsEmpty)
								continue;

							local e = Tactical.spawnEntity("scripts/entity/tactical/humans/officer", tile.Coords);
							e.setFaction(f);
							e.getSkills().add(new("scripts/skills/effects/assassins_prophet_effect"));
							e.assignRandomEquipment();

							if (Const.DLC.Wildmen) {
								e.getSprite("miniboss").setBrush("bust_miniboss");
								e.getSkills().removeByID("racial.champion");
							}

							if (e.getItems().getItemAtSlot(Const.ItemSlot.Mainhand) != null)
								e.getItems().getItemAtSlot(Const.ItemSlot.Mainhand).removeSelf();

							if (e.getItems().getItemAtSlot(Const.ItemSlot.Offhand) != null)
								e.getItems().getItemAtSlot(Const.ItemSlot.Offhand).removeSelf();

							if (e.getItems().getItemAtSlot(Const.ItemSlot.Head) != null)
								e.getItems().getItemAtSlot(Const.ItemSlot.Head).removeSelf();

							if (e.getItems().getItemAtSlot(Const.ItemSlot.Body) != null)
								e.getItems().getItemAtSlot(Const.ItemSlot.Body).removeSelf();

							local helmet = new("scripts/items/helmets/named/gold_and_black_turban");
							helmet.setName("The False Prophet's Crown");
							local armor = new("scripts/items/armor/named/black_and_gold_armor");
							armor.setName("The False Prophet's Aegis");
							local weapon = new("scripts/items/weapons/named/named_polemace");
							weapon.setName("The False Prophet's Staff");

							e.getItems().equip(helmet);
							e.getItems().equip(armor);
							e.getItems().equip(weapon);

							e.setName("The False Prophet");

							--prophet;
						}
						while (prophet > 0);

						local assassins = 2;
						if (World.Assets.getCombatDifficulty() == Const.Difficulty.Hard)
							++assassins;
						if (World.Assets.getCombatDifficulty() == Const.Difficulty.Easy)
							--assassins;

						do {
							local x = Math.rand(22, 24);
							local y = Math.rand(14, 18);

							local tile = Tactical.getTileSquare(x, y);

							if(!tile.IsEmpty)
								continue;

							local e = Tactical.spawnEntity("scripts/entity/tactical/humans/assassin", tile.Coords);
							e.setFaction(f);
							e.assignRandomEquipment();

							--assassins;
						}
						while (assassins > 0);

						local hedgehegs = 1;

						do {
							local x = Math.rand(20, 21);
							local y = Math.rand(13, 19);

							local tile = Tactical.getTileSquare(x, y);

							if(!tile.IsEmpty)
								continue;

							local e = Tactical.spawnEntity("scripts/entity/tactical/humans/hedge_knight", tile.Coords);
							e.setFaction(f);
							e.assignRandomEquipment();

							if (e.getItems().getItemAtSlot(Const.ItemSlot.Mainhand) != null)
								e.getItems().getItemAtSlot(Const.ItemSlot.Mainhand).removeSelf();

							if (e.getItems().getItemAtSlot(Const.ItemSlot.Offhand) != null)
								e.getItems().getItemAtSlot(Const.ItemSlot.Offhand).removeSelf();

							if (e.getItems().getItemAtSlot(Const.ItemSlot.Head) != null)
								e.getItems().getItemAtSlot(Const.ItemSlot.Head).removeSelf();

							if (e.getItems().getItemAtSlot(Const.ItemSlot.Body) != null)
								e.getItems().getItemAtSlot(Const.ItemSlot.Body).removeSelf();

							if (Const.DLC.Wildmen)
								e.getSkills().removeByID("racial.champion");

							e.getItems().equip(new("scripts/items/helmets/full_helm"));
							e.getItems().equip(new("scripts/items/armor/oriental/padded_mail_and_lamellar_hauberk"));
							e.getItems().equip(new("scripts/items/weapons/greatsword"));

							if (hedgehegs == 1)
								e.setName("Edmund the Gilded");

							--hedgehegs;
						}
						while (hedgehegs > 0);

						local blade_dancers = 1;

						do {
							local x = Math.rand(20, 21);
							local y = Math.rand(13, 19);

							local tile = Tactical.getTileSquare(x, y);

							if (!tile.IsEmpty)
								continue;

							local e = Tactical.spawnEntity("scripts/entity/tactical/humans/desert_devil", tile.Coords);
							e.setFaction(f);
							e.assignRandomEquipment();

							if (Const.DLC.Wildmen)
								e.getSkills().removeByID("racial.champion");

							if (blade_dancers == 1)
								e.setName("Firi Al-Kashim");

							--blade_dancers;
						}
						while (blade_dancers > 0);

						local gunners = 3;

						if (World.Assets.getCombatDifficulty() == Const.Difficulty.Hard)
							++gunners;
						if (World.Assets.getCombatDifficulty() == Const.Difficulty.Easy)
							--gunners;

						do {
							local x = Math.rand(23, 24);
							local y = Math.rand(13, 19);
							local tile = Tactical.getTileSquare(x, y);

							if (!tile.IsEmpty)
								continue;

							local e = Tactical.spawnEntity("scripts/entity/tactical/humans/gunner", tile.Coords);
							e.setFaction(f);
							e.assignRandomEquipment();

							--gunners;
						}
						while (gunners > 0);
					};

					_event.registerToShowAfterCombat("Victory", "Defeat");
					World.State.startScriptedCombat(p, false, false, false);

					return 0;
				}
			}
		]

		function start(_event) { }
	});

	oee.m.Screens.push({
		ID			= "Victory"
		Text		= ""
		Image		= ""
		List		= [ ]
		Characters	= [ ]
		Options		= [
				{
					Text = "The %companyname% needs their commander!",
					function getResult( _event ) { return 0; }
				},
				{
					Text = "It\'s time to retire from mercenary life. (End Campaign)",
					function getResult( _event ) {
						World.State.getMenuStack().pop(true);
						World.State.showGameFinishScreen(true);
						return 0;
					}
				}
		]

		function start(_event) {
			_event.m.Title = "After the battle...";

			if (World.Statistics.getFlags().get("SouthernAssassinsProphetSlain") == true)
				Text = "[img]gfx/ui/events/event_152.png[/img]{The False Prophet is dead. The men finish off any survivors with an efficiency that would make any in the guild proud, then scavenge the battlefield for trinkets as any Crownling should. %randombrother% comes up to you.%SPEECH_ON%What should we do with the body? You should see it, this whole time that farker was-%SPEECH_OFF%You hold up a hand, interrupting him.%SPEECH_ON%Burn it, but strip the armor first. I don't care beyond that.%SPEECH_OFF%The man nods, a bit puzzled, and as the stench of burning flesh fills the air you look to the horizon and wonder. You've done it, but what now? The Old Man on the Mountain said this was your last mission, and he never suggested that your exile was temporary. Do you just put it all behind you, retire and see if his promised paradise comes? Or stay a Crownling, and see where this new life of yours takes you?\n\n%OOC%You\'ve won! Battle Brothers is designed for replayability and for campaigns to be played until you\'ve beaten one or two late game crises. Starting a new campaign will allow you to try out different things in a different world.\n\nYou can also choose to continue your campaign for as long as you want. Just be aware that campaigns are not intended to last forever and you\'re likely to run out of challenges eventually.%OOC_OFF%}";
			else {
				World.Statistics.getFlags().set("SouthernAssassinsProphetFled", true);
				Text = "[img]gfx/ui/events/event_152.png[/img]{You scour the field for sign of the False Prophet's body, but none can be found. Perhaps he fled down another bolt hole, perhaps he simply ran and let the wind scatter his tracks. Whatever the case, he's gone.\n\nYou're not particularly concerned. With his agents dead and you now in possession of his rather sizeable war chest, he's little more than a madman with delusions of grandeur. %randombrother% comes up to you.%SPEECH_ON%What do you think he was talking about, anyway? An evil in the mountains?%SPEECH_OFF%The man motions to the defaced statues.%SPEECH_ON%Just the ravings of some lunatic. Get the men ready to head out.%SPEECH_OFF%As he throws a salute and begins rounding up the rest of the company, your thoughts turn to the future. You mission might as well be complete, but the Old Man on the Mountain never suggested your exile was temporary. Maybe it's time to put this all behind you and settle down somewhere, never needing to kill again. Then again, is there something more to the life of a Crownling, something you've yet to discover?\n\n%OOC%You\'ve won! Battle Brothers is designed for replayability and for campaigns to be played until you\'ve beaten one or two late game crises. Starting a new campaign will allow you to try out different things in a different world.\n\nYou can also choose to continue your campaign for as long as you want. Just be aware that campaigns are not intended to last forever and you\'re likely to run out of challenges eventually.%OOC_OFF%}";
			}

			World.Assets.addMoney(10000);
		}
	});

	oee.m.Screens.push({
		ID			= "Defeat"
		Text		= "[img]gfx/ui/events/event_152.png[/img]{As you beat a hasty retreat away from the camp, you recall the first time you saw the Old Man on the Mountain punish a guild assassin for failure. You force the gruesome scene from your mind and continue running. You're not a member of the guilds anymore, so surely you would be spared that fate at least.\n\nRegardless, the fact of the matter is that the %companyname% failed to slay the Prophet given their chance, and you're sure there won't be another. He'll move to a different ruin, perhaps a different holy site entirely, and the guilds will stay locked in a deathgrip with him until one of them dies.\n\nYou could care less. Right now all that's on your mind is keeping the company alive. With luck, you were never more than a pawn in their game, too insignificant for either to chase down. You run by a rock and see a robed man in its shadow, holding a knife and staring at you. You blink and he's gone.}"
		Image		= ""
		List		= [ ]
		Characters	= [ ]
		Options		= [
			{
				Text = "Damn it!"
				function getResult(_event) { return 0; }
			}
		]

		function start(_event) {
			_event.m.Title = "After the battle...";

			World.Statistics.getFlags().set("SouthernAssassinsProphetFightLost", true);

			local cityStates = World.FactionManager.getFactionsOfType(Const.FactionType.OrientalCityState);

			foreach( c in cityStates ) {
				c.addPlayerRelation(-10.0, "Ran afoul of the assassin guilds and the Prophet both");
			}
		}
	});

	oee.onDetermineStartScreen = function() {
		local flags = World.Statistics.getFlags();
		local noSummons = flags.get("SouthernAssassinsProphetSummonsReceived") != true;
		local alreadyFought = (flags.get("SouthernAssassinsProphetFightTriggered") && (flags.get("SouthernAssassinsProphetFightLost") || flags.get("SouthernAssassinsProphetSlain") || flags.get("SouthernAssassinsProphetFled")));

		if (World.Assets.getOrigin().getID() != "scenario.southern_assassins" || noSummons || alreadyFought)
			return onDetermineStartScreen();
		else {
			return "SouthernAssassinsProphetStart";
		}
	}
});
