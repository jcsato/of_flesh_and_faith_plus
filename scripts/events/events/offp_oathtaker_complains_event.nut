offp_oathtaker_complains_event <- inherit("scripts/events/event", {
	m = {
		Oathtaker	= null
	}

	function create() {
		m.ID		= "event.offp_oathtaker_complains";
		m.Title		= "Along the way...";
		m.Cooldown	= 60.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_183.png[/img]{%oathtaker% enters your tent abruptly. The oathtaker is high strung at the best of times, but he looks especially put out. You ask what it is he wants.%SPEECH_ON%Captain, I'm afraid I must protest the conditions in camp! I know that a life on the road comes with concessions, but there are some matters on which I simply cannot bear to compromise!%SPEECH_OFF%You arch an eyebrow and ask the man to elaborate.%SPEECH_ON%Well, for starters, the Oath of Meditation requires me to reflect on Young Anselm's glory in silence at least thrice daily, but the camp is too small and I cannot get far enough away from the other men to concentrate. Then there's the Oath of Purification, which calls for the imbibing of a clergy-blessed libation with at least every fourth meal, and we simply do not find ourselves in adequately holy towns frequently enough for me to keep my stock. And that's to say nothing of the Oath of Celi-%SPEECH_OFF%You cut the man off and remind him that his religious duties are his own responsibility, and make it quite clear you won't be altering camp practices or company destinations. His entire face flushes at the scandal of your refusal and he stomps out of your tent without another word.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Suck it up."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				Characters.push(_event.m.Oathtaker.getImagePath());

				_event.m.Oathtaker.worsenMood(1.5, "Finds it difficult to follow his religious oaths as a mercenary");

				if (_event.m.Oathtaker.getMoodState() < Const.MoodState.Neutral)
					List.push( { id = 10, icon = Const.MoodStateIcon[_event.m.Oathtaker.getMoodState()], text = _event.m.Oathtaker.getName() + Const.MoodStateEvent[_event.m.Oathtaker.getMoodState()] } );
			}
		});
	}

	function onUpdateScore() {
		if (!Const.DLC.Paladins)
			return;

		if (World.Assets.getOrigin().getID() == "scenario.oathtakers")
			return;

		local brothers = World.getPlayerRoster().getAll();
		local oathtakerCandidates = [];

		foreach (bro in brothers) {
			if (bro.getBackground().getID() == "background.paladin")
				oathtakerCandidates.push(bro);
		}

		if (oathtakerCandidates.len() == 0)
			return;

		m.Oathtaker = oathtakerCandidates[Math.rand(0, oathtakerCandidates.len() - 1)];
		m.Score = 3 * oathtakerCandidates.len();
	}

	function onPrepare() { }

	function onPrepareVariables(_vars) {
		_vars.push([ "oathtaker", m.Oathtaker.getName() ]);
	}

	function onClear() {
		m.Oathtaker	= null;
	}
});
