offp_anatomists_experimental_integrity_event <- inherit("scripts/events/event", {
	m = {
		Anatomist	= null
	}

	function create() {
		m.ID		= "event.offp_anatomists_experimental_integrity";
		m.Title		= "Along the way...";
		m.Cooldown	= 9999.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_184.png[/img]{You see %anatomist% the anatomist sitting by the campfire and decide to ask him a question you've had on your mind for some time.%SPEECH_ON%How come you never make more than one of the same potion?%SPEECH_OFF%The anatomist answers you in the same insufferable tone you might use to explain something to a young child.%SPEECH_ON%You may not understand experimental integrity, scapegrace, but be assured that I do. It would be irresponsible to begin mass production of our speculative inoculations until we've had thorough opportunity to study their effects on the test specim- er, that is to say, on the men.%SPEECH_OFF%Sure, his concern for his fellow man is overwhelming.%SPEECH_ON%Doesn't it impact the experiment if the same man gets more than one mutation?%SPEECH_OFF%He sets aside his quill, rubbing his temples in annoyance.%SPEECH_ON%I'll note that you're the one who decides which man receives which treatment, captain. Regardless, the ultimate goal is for men to receive all the benefits of our research, so observing how they interplay is valuable.%SPEECH_OFF%You ask the obvious followup question.%SPEECH_ON%Wouldn't it make sense to produce more than one of each potion, to study more of their interactions at once, then?%SPEECH_OFF%The man opens his mouth to speak, pauses, rubs his chin thoughtfully, then turns back to you.%SPEECH_ON%I don't tell you how to do your job, sellsword. Don't presume to tell me how to do mine.%SPEECH_OFF%With that, he resumes scribbling in his journals, crossing out several sections. Hmph.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Damn eggheads."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				Characters.push(_event.m.Anatomist.getImagePath());
			}
		});
	}

	function onUpdateScore() {
		if (!Const.DLC.Paladins)
			return;

		if (World.Assets.getOrigin().getID() != "scenario.anatomists")
			return;

		local brothers = World.getPlayerRoster().getAll();
		local anatomistCandidates = [];
		local numMutations = 0;

		foreach (bro in brothers) {
			if (bro.getBackground().getID() == "background.anatomist")
				anatomistCandidates.push(bro);

			numMutations += bro.getFlags().getAsInt("ActiveMutations");
		}

		if (anatomistCandidates.len() == 0 || numMutations < 6)
			return;

		m.Anatomist = anatomistCandidates[Math.rand(0, anatomistCandidates.len() - 1)];
		m.Score = 3 * anatomistCandidates.len();
	}

	function onPrepare() { }

	function onPrepareVariables(_vars) {
		_vars.push([ "anatomist", m.Anatomist.getNameOnly() ]);
	}

	function onClear() {
		m.Anatomist	= null;
	}
});
