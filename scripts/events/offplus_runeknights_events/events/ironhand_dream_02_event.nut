ironhand_dream_02_event <- inherit("scripts/events/event", {
	m = {
		Chosen = null
	}

	function create() {
		m.ID		= "event.ironhand_dream_02";
		m.Title		= "During camp...";
		m.Cooldown	= 99999.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_39.png[/img]{You once again find yourself in front of the fire, its flickering light casting the shadows of men into the world. You look at it with pity, knowing how it struggles, knowing what true flames look like, knowing how it wishes it could char your flesh instead of merely warm it.\n\nFew understand that this is the true nature of fire, despite your attempts to teach them. You remember the Scorched Tribe and their mewling adherence to rituals and castes, to pointless sacrifice and to wanton banditry. All a smokescreen to hide the fear behind all they did. Fear of cold, fear of hunger, fear of man, fear of death. Old Ironhand bid you remind them the origin of their savage little games, show them the reason they turn to savagery in the first place. He bid you show them the fire that produced the smoke.\n\nBut they had spent too long in the cold, and none of them could stand the heat of Ironhand's hearth. Nothing of them now remains, the place their village once stood a blackened scar on the land and even their name lost to the fire. Yet even then other northmen villages learned nothing, instead speaking of them in hushed tones, dubbing them the Scorched and giving them a legend their end did not deserve.\n\nThe southerners are even worse, so desperately clutching at life that they have neglected death. They live not even in smoke, but in an endless winter that belies their warm lands, given purpose and life only by the sputtering of conflicts that might as well be candles. And then there are the dream men, standing in gilded halls you have never seen, who were so cold they sought to never die at all, to spend the rest of eternity in an endless vacuum without heat or purpose, and you sneer at their memory, and the old bearded man who you know but don't know stares at you with that same disappointment as ever, and your fingers begin to tingle with pain, and then %chosen% pulls your hand out of the fire and the trance is broken.%SPEECH_ON%I see it too, but do not despair, captain. These false fires will give way to Old Ironhand's hearth in time. We'll see to it.%SPEECH_OFF%You give the man a nod in thanks, and the two of you return to your ruminations. Sleep does not come, and the fire eventually dies, but the one inside burns bright yet.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "And mine death I shall visit upon Ironhand's foes."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				local brothers = World.getPlayerRoster().getAll();

				foreach (bro in brothers) {
					if (bro.getSkills().hasSkill("effects.rune_01") || bro.getSkills().hasSkill("effects.rune_02") || bro.getSkills().hasSkill("effects.rune_03") || bro.getSkills().hasSkill("effects.rune_04") || bro.getSkills().hasSkill("effects.rune_05") || bro.getSkills().hasSkill("effects.rune_06") || bro.getSkills().hasSkill("effects.rune_07")) {
						bro.getBaseProperties().Bravery += 2;
						bro.getSkills().update();

						List.push({ id = 16, icon = "ui/icons/bravery.png", text = bro.getName() + " gains [color=" + Const.UI.Color.PositiveEventValue + "]+2[/color] Resolve" });
						bro.improveMood(1.0, "Is compelled to seek a worthy end in a world of weak men");
					}
				}

				World.Statistics.getFlags().set("RuneKnightsDreamStage", 2);
			}
		});
	}

	function onUpdateScore() {
		if (!Const.DLC.Wildmen || !Const.DLC.Paladins)
			return;

		if (World.Assets.getOrigin().getID() != "scenario.runeknights")
			return;

		if (World.Statistics.getFlags().getAsInt("RuneKnightsDreamStage") != 1)
			return;

		local brothers = World.getPlayerRoster().getAll();
		local rune_candidates = [], veteran_rune_candidates = [];

		foreach (bro in brothers) {
			if (bro.getFlags().getAsInt("numActiveRunes") >= 3)
				veteran_rune_candidates.push(bro);
			else if (bro.getFlags().getAsInt("numActiveRunes") >= 1)
				rune_candidates.push(bro);
		}

		local candidates_sum = veteran_rune_candidates.len() + rune_candidates.len();
		if (veteran_rune_candidates.len() < 1 && candidates_sum < 5)
			return;

		m.Chosen = veteran_rune_candidates[Math.rand(0, veteran_rune_candidates.len() - 1)];
		m.Score = 5 * candidates_sum;
	}

	function onPrepare() { }

	function onPrepareVariables(_vars) {
		_vars.push([ "chosen", m.Chosen.getName() ]);
	}

	function onClear() {
		m.Chosen = null;
	}
});
