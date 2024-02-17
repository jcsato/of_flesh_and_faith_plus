ironhand_dream_04_event <- inherit("scripts/events/event", {
	m = {
		Chosen = null
	}

	function create() {
		m.ID		= "event.ironhand_dream_04";
		m.Title		= "During camp...";
		m.Cooldown	= 99999.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_39.png[/img]{As the company settles around the campfire, a sudden weariness falls upon you. You make your way to your tent, but on the way you bump into %chosen%. He's got something in his hands you can't see.%SPEECH_ON%Oh, captain, there you are. I wanted to show you this. It's the darndest thing.%SPEECH_OFF%He hands you what looks like some kind of black rock, and the instant you touch it the whole world falls away. You find yourself in a scorched wasteland, bits of charred grass and dead trees breaking up the otherwise featureless hills. In front you wanders a herd not of sheep but of gray, dying wolves, led by a cloaked shepherd tossing out seeds on the ground.\n\nYou fill with rage at the sight of the farce. You think to confront the shepherd, to berate him for sowing a barren land and herding not livestock but predators. You think to rip away the notion of a peaceful land sustained by farming, to compel the shepherd to take up arms and slay the wolves and feast on their meat, to give meaning to his struggle and give it purpose and thus death.\n\nBut the words do not come, and instead see the shepherd's bearded face begin to squirm and morph, and he turns to you and you see a face you recognize for a moment but then his mouth opens and laughs and keeps opening and the maw consumes him whole, and underneath the hood you can now see nothing but teeth, teeth affixed in an evil smile that is reflected by the teeth in the starless, empty void of the sky, and the shepherd's staff twists and warps and turns and an axehead appears at its tip and the cackling fills your ears and the wolves have the faces of men and you stare at one and it is your face.%SPEECH_ON%Death and purpose indeed, 'mine chosen'. I await thee.%SPEECH_OFF%The cackling grows louder still, piercing you, and you double over in pain, and you are back in camp with %chosen% and the black rock is gone.%SPEECH_ON%Captain, are you alright? You've gone pale.%SPEECH_OFF%You remember nothing. You were feeling tired and headed to your tent, but the fatigue is gone, replaced only with an empty, gnawing doubt. The rest of the men feel it too, but none can put a finger on why. Something just feels...wrong.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "And mine death I shall visit upon..."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				local brothers = World.getPlayerRoster().getAll();
				local rune_candidates = [];

				foreach (bro in brothers) {
					if (bro.getSkills().hasSkill("effects.rune_01") || bro.getSkills().hasSkill("effects.rune_02") || bro.getSkills().hasSkill("effects.rune_03") || bro.getSkills().hasSkill("effects.rune_04") || bro.getSkills().hasSkill("effects.rune_05") || bro.getSkills().hasSkill("effects.rune_06") || bro.getSkills().hasSkill("effects.rune_07")) {
						bro.getBaseProperties().Bravery -= 4;
						bro.getSkills().update();

						List.push({ id = 16, icon = "ui/icons/bravery.png", text = bro.getName() + " loses [color=" + Const.UI.Color.NegativeEventValue + "]-4[/color] Resolve" });
						bro.worsenMood(0.5, "Had his faith in Old Ironhand shaken by a confusing vision");
					}
				}

				World.Statistics.getFlags().set("RuneKnightsDreamStage", 4);
			}
		});
	}

	function onUpdateScore() {
		if (!Const.DLC.Wildmen || !Const.DLC.Paladins)
			return;

		if (World.Assets.getOrigin().getID() != "scenario.runeknights")
			return;

		if (World.Statistics.getFlags().getAsInt("RuneKnightsDreamStage") != 3)
			return;

		local brothers = World.getPlayerRoster().getAll();
		local rune_candidates = [ ], veteran_rune_candidates = [ ], elite_rune_candidates = [ ];

		foreach (bro in brothers) {
			if (bro.getFlags().getAsInt("numActiveRunes") >= 5)
				elite_rune_candidates.push(bro);
			else if (bro.getFlags().getAsInt("numActiveRunes") >= 3)
				veteran_rune_candidates.push(bro);
			else if (bro.getFlags().getAsInt("numActiveRunes") >= 1)
				rune_candidates.push(bro);
		}

		local candidates_sum = elite_rune_candidates.len() + veteran_rune_candidates.len() + rune_candidates.len();
		if (elite_rune_candidates.len() < 2 && candidates_sum < 9)
			return;

		m.Chosen = elite_rune_candidates[Math.rand(0, elite_rune_candidates.len() - 1)];
		m.Score = 3 * candidates_sum;
	}

	function onPrepare() { }

	function onPrepareVariables(_vars) {
		_vars.push([ "chosen", m.Chosen.getName() ]);
	}

	function onClear() {
		m.Chosen = null;
	}
});
