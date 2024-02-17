offp_oathtaker_vs_flagellant_event <- inherit("scripts/events/event", {
	m = {
		Flagellant	= null
		Oathtaker	= null
	}

	function create() {
		m.ID		= "event.offp_oathtaker_vs_flagellant";
		m.Title		= "During camp...";
		m.Cooldown	= 9999.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_05.png[/img]{Now here's something you didn't expect: %oathtaker% the oathtaker and %flagellant% the flagellant are engaged in a debate over the virtues of the others' chosen path in life.%SPEECH_ON%I know something of your 'oaths', and I've seen your brethren inflict self-torture far worse than my simple appeasements.%SPEECH_OFF%The oathtaker counters.%SPEECH_ON%Aye, but there is a goal to our ruination as laid out in the Oaths. We explore the weakness of the flesh to better know its strengths, not simply to endure the endless pain your flagellations bring.%SPEECH_OFF%And so the two continue back and forth. You're glad to see both men engage in earnest discussion without the violence that characterizes both their pursuits, yet you have to wonder if its healthy for two the company's most extreme men to pit their ideologies against one another.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Let's see where this goes."
					function getResult(_event) { return Math.rand(1, 100) <= (50 + _event.m.Flagellant.getLevel() - _event.m.Oathtaker.getLevel()) ? "B" : "C"; }
				},
				{
					Text = "Alright, break it up. We don't need you two encouraging each other."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				Characters.push(_event.m.Oathtaker.getImagePath());
				Characters.push(_event.m.Flagellant.getImagePath());
			}
		});

		m.Screens.push({
			ID			= "B"
			Text		= "[img]gfx/ui/events/event_05.png[/img]{You decide to check in on the men later and return to the sound of %oathtaker% screaming.%SPEECH_ON%I AM SORRY, YOUNG ANSELM! FORGIVE THIS MISERABLE WRETCH'S FAILURES!%SPEECH_OFF%Well then. The oathtaker is furiously whipping his naked back, which you take as indication that the flagellant won the debate. You turn to %flagellant%, however, and he simply shakes his head.%SPEECH_ON%This is no holy rite, captain. Just as I thought my words were getting through to him, he started going on about how it was all a sign of some new oath he needed to take on or some such. It's a shame to see such a devoted man eschew the old gods for such pursuits.%SPEECH_OFF%}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "I'll never understand you religious types."
					function getResult(_event) { return 0;}
				}
			]

			function start(_event) {
				Characters.push(_event.m.Oathtaker.getImagePath());
				Characters.push(_event.m.Flagellant.getImagePath());

				local trait = new("scripts/skills/traits/oath_of_penitence_trait");

				_event.m.Oathtaker.getSkills().add(trait);
				List.push( { id = 10, icon = trait.getIcon(), text = _event.m.Oathtaker.getName() + " has taken on an Oath of Penitence" } );

				_event.m.Oathtaker.worsenMood(1.0, "Failed to live up to Young Anselm's standards");
			}
		});

		m.Screens.push({
			ID			= "C"
			Text		= "[img]gfx/ui/events/event_05.png[/img]{You decide to check in on the men later and return to see %flagellant% softly weeping with a smile on his face. %oathtaker% sees you and walks over excitedly.%SPEECH_ON%I think I finally got through to him, captain! He sees now the error of his ways, and how following in Young Anselm's footsteps shall put him on the Final Path! I must go now to ponder which Oaths he should follow first. It would not do to let a new inductee meander through the holy teachings unguided.%SPEECH_OFF%He hurries off and you glance at the flagellant-turned-oathtaker. You think he looks more defeated than enlightened, but perhaps this is all for the best if it stops the man's self-torture.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Just don't start proselytizing to me."
					function getResult(_event) { return 0;}
				}
			]

			function start(_event) {
				Characters.push(_event.m.Oathtaker.getImagePath());
				Characters.push(_event.m.Flagellant.getImagePath());

				local background = new("scripts/skills/backgrounds/paladin_background");

				background.m.IsNew = false;
				_event.m.Flagellant.getSkills().removeByID("background.flagellant");
				_event.m.Flagellant.getSkills().add(background);
				_event.m.Flagellant.m.Background = background;

				_event.m.Flagellant.getBackground().m.RawDescription = "Once a flagellant, %name% has traded his whip for the Oaths of Young Anselm. The man is as insufferable as the next man in his order, but at least you can be confident you won't wake up to find he's killed himself in some religious pursuit. By whip. Probably.";
				_event.m.Flagellant.getBackground().buildDescription(true);

				local hitpointBoost = Math.rand(4, 6);
				_event.m.Flagellant.getBaseProperties().Hitpoints += hitpointBoost;
				_event.m.Flagellant.getSkills().update();

				List.push({ id = 13, icon = background.getIcon(), text = _event.m.Flagellant.getName() + " is now an Oathtaker" });
				List.push({ id = 16, icon = "ui/icons/health.png", text = _event.m.Flagellant.getName() + " gains [color=" + Const.UI.Color.PositiveEventValue + "]+" + hitpointBoost + "[/color] Hitpoints" });
			}
		});
	}

	function onUpdateScore() {
		if (!Const.DLC.Paladins)
			return;

		// Disable for OFF+ v2.x Oathtakers
		if (World.Assets.getOrigin().getID() == "scenario.oathtakers")
			return;

		local brothers = World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
			return;

		local flagellant_candidates = [];
		local oathtaker_candidates = [];

		foreach (bro in brothers) {
			if (bro.getBackground().getID() == "background.flagellant")
				flagellant_candidates.push(bro);
			else if (bro.getBackground().getID() == "background.paladin" && !hasWeaponMastery(bro))
				oathtaker_candidates.push(bro);
		}
		
		if (flagellant_candidates.len() == 0 || oathtaker_candidates.len() == 0)
			return;

		m.Flagellant = flagellant_candidates[Math.rand(0, flagellant_candidates.len() - 1)];
		m.Oathtaker = oathtaker_candidates[Math.rand(0, oathtaker_candidates.len() - 1)];
		m.Score = 5;
	}

	function onPrepareVariables(_vars) {
		_vars.push([ "flagellant", m.Flagellant.getNameOnly() ]);
		_vars.push([ "oathtaker", m.Oathtaker.getNameOnly() ]);
	}

	function onClear() { }

	function hasWeaponMastery(bro) {
		local properties = bro.getCurrentProperties();

		return properties.IsSpecializedInBows || properties.IsSpecializedInCrossbows || properties.IsSpecializedInThrowing
			|| properties.IsSpecializedInSwords || properties.IsSpecializedInCleavers || properties.IsSpecializedInMaces
			|| properties.IsSpecializedInHammers || properties.IsSpecializedInAxes || properties.IsSpecializedInFlails
			|| properties.IsSpecializedInSpears || properties.IsSpecializedInPolearms || properties.IsSpecializedInDaggers;
	}
});
