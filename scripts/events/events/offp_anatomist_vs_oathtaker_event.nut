offp_anatomist_vs_oathtaker_event <- inherit("scripts/events/event", {
	m = {
		Anatomist	= null
		Oathtaker	= null
	}

	function create() {
		m.ID		= "event.offp_anatomist_vs_oathtaker";
		m.Title		= "During camp...";
		m.Cooldown	= 55.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_05.png[/img]{You and the men are sitting around the fire when you catch %oathtaker% the oathtaker and %anatomist% the anatomist in heated debate.%SPEECH_ON%Don't you see? In such a harsh world as this, that which is without grows from within, yet also shields it from understanding. We men must pursue the secrets inside that we may improve our fragile shells.%SPEECH_OFF%The oathtaker shakes his head.%SPEECH_ON%These experiments of yours only serve to rob the dead of their repose. 'Tis the pathway to necromancy and villainy, my friend, not self-betterment. Only the Oaths can offer that.%SPEECH_OFF%}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Oh, this should be good."
					function getResult(_event) { return Math.rand(1, 100) <= 50 ? "B" : "C"; }
				},
				{
					Text = "Alright, that's enough. We've got work to do."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				Characters.push(_event.m.Oathtaker.getImagePath());
				Characters.push(_event.m.Anatomist.getImagePath());
			}
		});

		m.Screens.push({
			ID			= "B"
			Text		= "[img]gfx/ui/events/event_05.png[/img]{%anatomist% sighs exasperatedly.%SPEECH_ON%Your oaths are no different from my research. You follow them to strive against the failures of your mind and body. And surely those failures exist in all of us, for was not even your own founder Anselm imperfect, and so-%SPEECH_OFF%The rest of the anatomist's rebuttal is cut short as a screeching %oathtaker% begins pummeling him for besmirching the name of his cult's founder. You and the rest of the company hurry and split them up, but not before the more academic of the two men has been badly beaten. You confront the oathtaker about his outburst, but he just shakes his head sullenly.%SPEECH_ON%I'm sorry, captain, but there are simply some evils I cannot abide. I can look the other way when the man scribbles in his notebooks or dissects corpses, but not- not that!%SPEECH_OFF%He stomps off.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "What the hell, man."
					function getResult(_event) { return 0;}
				}
			]

			function start(_event) {
				Characters.push(_event.m.Oathtaker.getImagePath());
				Characters.push(_event.m.Anatomist.getImagePath());

				_event.m.Anatomist.addHeavyInjury();
				List.push( { id = 10, icon = "ui/icons/days_wounded.png", text = _event.m.Anatomist.getName() + " suffers light wounds" } );

				_event.m.Anatomist.worsenMood(1.5, "Was assaulted by a mad cultist");
				_event.m.Oathtaker.worsenMood(1.0, "Heard someone besmirch Young Anselm's perfection");

				if (_event.m.Anatomist.getMoodState() < Const.MoodState.Neutral)
					List.push({ id = 11, icon = Const.MoodStateIcon[_event.m.Anatomist.getMoodState()], text = _event.m.Anatomist.getName() + Const.MoodStateEvent[_event.m.Anatomist.getMoodState()] });

				if (_event.m.Oathtaker.getMoodState() < Const.MoodState.Neutral)
					List.push({ id = 12, icon = Const.MoodStateIcon[_event.m.Oathtaker.getMoodState()], text = _event.m.Oathtaker.getName() + Const.MoodStateEvent[_event.m.Oathtaker.getMoodState()] });
			}
		});

		m.Screens.push({
			ID			= "C"
			Text		= "[img]gfx/ui/events/event_05.png[/img]{%anatomist% wracks his brain, trying to think of a way to get through to his stubborn counterpart.%SPEECH_ON%Your Young Anselm established the oaths as a means for men to better themselves, correct?%SPEECH_OFF%The oathtaker nods warily, his fists tightening at the mention of his order's founder. The anatomist continues.%SPEECH_ON%What better proof could there be of man's frailty than for it to be rallied against by such a prime specimen? Consider further, then, the invalid and the infirm. They cannot practically follow your more martial oaths; but what if they could? Consider the elderly man, whom circumstance deprived knowledge of your order until late in his life; does he not deserve the chance, nay the time, to pursue the oaths as fully as any other? It is them whom my research benefits, not I.%SPEECH_OFF% The oathtaker opens his mouth to retort, then pauses, then opens his mouth again, then pauses again and frowns. Then he cracks a wide grin and gives the anatomist a friendly punch in the shoulder.%SPEECH_ON%I see you now to be of a firmer character than I thought, friend! Ha! Bringing the Oaths to even the elderly and crippled is truly a noble pursuit, worthy of a new title. What would befit a parchment man? Oathpreacher, perhaps? Hmm.%SPEECH_OFF%The paladin wonders off in good spirits, lost in thought. The anatomist, for his part, winces as he nurses a freshly bruised shoulder.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Glad you could work that out."
					function getResult(_event) { return 0;}
				}
			]

			function start(_event) {
				Characters.push(_event.m.Oathtaker.getImagePath());
				Characters.push(_event.m.Anatomist.getImagePath());

				_event.m.Anatomist.improveMood(1.0, "Got " + _event.m.Oathtaker.getNameOnly() + " to approve of his research");
				_event.m.Oathtaker.improveMood(1.0, "Convinced the other men in the company are pursuing the oaths in their own way");

				if (_event.m.Anatomist.getMoodState() > Const.MoodState.Neutral)
					List.push({ id = 11, icon = Const.MoodStateIcon[_event.m.Anatomist.getMoodState()], text = _event.m.Anatomist.getName() + Const.MoodStateEvent[_event.m.Anatomist.getMoodState()] });

				if (_event.m.Oathtaker.getMoodState() > Const.MoodState.Neutral)
					List.push({ id = 12, icon = Const.MoodStateIcon[_event.m.Oathtaker.getMoodState()], text = _event.m.Oathtaker.getName() + Const.MoodStateEvent[_event.m.Oathtaker.getMoodState()] });
			}
		});
	}

	function onUpdateScore() {
		if (!Const.DLC.Paladins)
			return;

		local brothers = World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
			return;

		local anatomist_candidates = [];
		local oathtaker_candidates = [];

		foreach (bro in brothers) {
			if (bro.getBackground().getID() == "background.anatomist")
				anatomist_candidates.push(bro);
			else if (bro.getBackground().getID() == "background.paladin")
				oathtaker_candidates.push(bro);
		}

		if (anatomist_candidates.len() == 0 || oathtaker_candidates.len() == 0)
			return;

		m.Anatomist = anatomist_candidates[Math.rand(0, anatomist_candidates.len() - 1)];
		m.Oathtaker = oathtaker_candidates[Math.rand(0, oathtaker_candidates.len() - 1)];
		m.Score = 5;
	}

	function onPrepareVariables(_vars) {
		_vars.push([ "anatomist", m.Anatomist.getNameOnly() ]);
		_vars.push([ "oathtaker", m.Oathtaker.getNameOnly() ]);
	}

	function onClear() { }
});
