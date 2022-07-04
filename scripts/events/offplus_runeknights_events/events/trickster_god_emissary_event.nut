trickster_god_emissary_event <- inherit("scripts/events/event",
{
	m =
	{
		Dude				= null
		Barbarian			= null
	}

	function create()
	{
		m.ID		= "event.trickster_god_emissary";
		m.Title		= "Along the way...";
		m.Cooldown	= 99999.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
							ID			= "A"
							Text		= "{%terrainImage%You come across a strange man muttering to himself. As you approach, he breaks into a fit of crazed laughter, then suddenly swerves his gaze to you, noticing your presence.%SPEECH_ON%You! YOU! Hee hee hee, you, you, you...I have a gift! A boon! A lowly tribute for a sellsword brute, hee hee hee! Take it with my respects, king with no subjects!%SPEECH_OFF%The man, to your surprise, holds out a rune towards you. The symbol is wholly unfamiliar to you, but you can immediately recognize it as a part of Old Ironhand's alphabet nonetheless. You take the rune from the man, almost without thinking, and he immediately begins wandering off as if you weren't there at all.}"
							Image		= ""
							List		= [ ]
							Characters	= [ ]
							Options		= [
											{
												Text = "What a strange fellow."
												function getResult(_event) {
													if (_event.m.Barbarian != null)
														return "B";
													else
														return 0;
												}
											}
										]
							function start(_event) {
								local item = new("scripts/items/misc/runeknights/rune_07_item");
								World.Assets.getStash().add(item);
								List.push({ id = 10, icon = "ui/items/" + item.getIcon(), text = "You gain " + item.getName() });
							}
						});

		m.Screens.push({
							ID			= "B"
							Text		= "{%terrainImage%%barbarian% the barbarian steps forward.%SPEECH_ON%I recognize that man. He was kin. We thought him lost to a blizzard years ago.%SPEECH_OFF%The man's face takes on a plaintive aspect as he observes the madman murmuring to himself, walking about in a strange, looping pattern.%SPEECH_ON%Captain, let's take him with us. He was chosen when I knew him, and even in this state he'll be a valuable addition to the %companyname%.%SPEECH_OFF%The strange man freezes in his tracks and stares at you both, a rope of drool hanging from his mouth, eyes full of fear and wonder and malice and yet vacant at the same time.}"
							Image		= ""
							List		= [ ]
							Characters	= [ ]
							Options		= [
											{
												Text = "Very well."
												function getResult(_event) { return "C"; }
											},
											{
												Text = "We have no need of him."
												function getResult(_event) { return "D"; }
											}
										]
							function start(_event)
							{
								local roster = World.getTemporaryRoster();
								_event.m.Dude = roster.create("scripts/entity/tactical/player");
								_event.m.Dude.setStartValuesEx([ "barbarian_background" ]);
								_event.m.Dude.getBackground().m.RawDescription = "\"A mercenary, me? What a comedy it be. A ruler of nothing, a captaincy he seeks, following ghostly visions and ignoring the dark clouds over the peaks. They think to be free, to leave this plane with no regrets, but not a one lacks shackles, least of all the soul my flesh begets. Ha!\"\n\nHow quaint.";
								_event.m.Dude.getBackground().buildDescription(true);
								_event.m.Dude.m.PerkPoints = 3;
								_event.m.Dude.m.LevelUps = 3;
								_event.m.Dude.m.Level = 4;

								_event.m.Dude.getSkills().add(new("scripts/skills/traits/mad_trait"));

								Characters.push(_event.m.Barbarian.getImagePath());
								Characters.push(_event.m.Dude.getImagePath());
							}
						});

		m.Screens.push({
							ID			= "C"
							Text		= "{%terrainImage%You let out a sigh.%SPEECH_ON%Very well. But I'm holding you responsible for him.%SPEECH_OFF%%barbarian% eagerly nods and gently guides the crazed man into the ranks. He passively follows, his face fluctuating between a mad grin and an expression of abject terror. Then he stops, his face set in stony neutrality.%SPEECH_ON%An honor to be here, sir. I won't let you down.%SPEECH_OFF%}"
							Image		= ""
							List		= [ ]
							Characters	= [ ]
							Options		= [
											{
												Text = "That's good. Now please do something about that drool."
												function getResult(_event) {
													World.getPlayerRoster().add(_event.m.Dude);
													World.getTemporaryRoster().clear();
													_event.m.Dude.onHired();
													_event.m.Dude = null;
												}
											}
										]
							function start(_event)
							{
								Characters.push(_event.m.Barbarian.getImagePath());
								Characters.push(_event.m.Dude.getImagePath());

								_event.m.Barbarian.improveMood(1.0, "Found his long-lost kin " + _event.m.Dude.getName());
								_event.m.Barbarian.worsenMood(0.5, "Troubled by " + _event.m.Dude.getName() + "'s disturbed state");
								if (_event.m.Barbarian.getMoodState() > Const.MoodState.Neutral)
									List.push({ id = 10, icon = Const.MoodStateIcon[_event.m.Barbarian.getMoodState()], text = _event.m.Barbarian.getName() + Const.MoodStateEvent[_event.m.Barbarian.getMoodState()] });
							}
						});

		m.Screens.push({
							ID			= "D"
							Text		= "{%terrainImage%You tell the man no. There are enough madmen in the company already, and you're not looking to add what seems to be a deranged lunatic to the mix - even a deranged lunatic with a strange rune. The barbarian is clearly disappointed, but accepts your decision in stony silence.\n\nYou tell the company to move on, glancing back at the crazed man. He's still standing there, frozen in place, eyes full and vacant. Then his face breaks into another wide grin and he runs off, whooping and hollering and cackling with a joy that only those free of sanity's shackles possess.}"
							Image		= ""
							List		= [ ]
							Characters	= [ ]
							Options		= [
											{
												Text = "Well, alright."
												function getResult(_event)
												{
													return 0;
												}
											}
										]
							function start(_event)
							{
								Characters.push(_event.m.Barbarian.getImagePath());

								_event.m.Barbarian.worsenMood(0.75, "You refused to take in his long-lost kin");
								if (_event.m.Barbarian.getMoodState() < Const.MoodState.Neutral)
									List.push({ id = 10, icon = Const.MoodStateIcon[_event.m.Barbarian.getMoodState()], text = _event.m.Barbarian.getName() + Const.MoodStateEvent[_event.m.Barbarian.getMoodState()] });
							}
						});
	}

	function onUpdateScore()
	{
		if (!Const.DLC.Wildmen || !Const.DLC.Paladins)
			return;

		if (World.Assets.getOrigin().getID() != "scenario.runeknights")
			return;

		if (World.getPlayerRoster().getSize() >= World.Assets.getBrothersMax())
			return;

		if (World.Assets.getStash().getNumberOfEmptySlots() < 1)
			return;

		local currentTile = World.State.getPlayer().getTile();
		if (currentTile.SquareCoords.Y < World.getMapSize().Y * 0.4)
			return;

		if (!World.Flags.has("IjirokStage") || World.Flags.get("IjirokStage") < 5)
			return;

		local brothers = World.getPlayerRoster().getAll();
		local barbarian_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.barbarian")
				barbarian_candidates.push(bro);
		}

		if (barbarian_candidates.len() > 0)
			m.Barbarian = barbarian_candidates[Math.rand(0, barbarian_candidates.len() - 1)];

		m.Score = 7;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables(_vars)
	{
		_vars.push([ "barbarian", m.Barbarian != null ? m.Barbarian.getNameOnly() : "" ]);
	}

	function onClear()
	{
		m.Barbarian		= null;
		m.Dude			= null;
	}
})