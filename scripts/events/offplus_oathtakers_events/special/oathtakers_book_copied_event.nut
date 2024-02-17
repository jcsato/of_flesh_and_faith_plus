oathtakers_book_copied_event <- inherit("scripts/events/event", {
	m = { }

	function create() {
		m.ID		= "event.oathtakers_book_copied";
		m.Title		= "During camp...";
		m.IsSpecial = true;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_15.png[/img]{You're writing in your journal when you hear a commotion in camp. Exiting your tent to investigate, you find the men formed into two opposing groups around the fire. You grab %randombrother% by the collar and demand an explanation.%SPEECH_ON%It's a disaster, sir! There are two Oath books! Two of 'em! There's only supposed to be one! Got the men accusing each other of being Oathbringers and trying to pervert the Oaths!%SPEECH_OFF%You step between the factions and demand to see both books. The men hand them over and you flip through them. Able to find no meaningful difference between them, you pick one at random and toss it into the fire.You hold up the remaining book and shout above the ensuing hubbub.%SPEECH_ON%There has only ever been one Book of Oaths, and so shall it remain! Brothers, don't be deceived by treachery! This is surely some Oathbringer plot meant to divide us. Do not give them the satisfaction!%SPEECH_OFF%The men grumble and grouse, but both groups have already decided theirs was the book not cast into flame and forgotten exactly who was in which camp. Morale will be low for some time as the company recovers from this scandal, but better fragile than broken.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "If only there was some way I could have avoided this..."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				local brothers = World.getPlayerRoster().getAll();

				foreach (bro in brothers) {
					if (bro.getBackground().getID() == "background.paladin")
						bro.worsenMood(2.0, "Discovered a forgery of the sacred Oath texts");
					else
						bro.worsenMood(1.0, "Discovered a forgery of the sacred Oath texts");

					if (bro.getMoodState() < Const.MoodState.Neutral)
						List.push({ id = 11, icon = Const.MoodStateIcon[bro.getMoodState()], text = bro.getName() + Const.MoodStateEvent[bro.getMoodState()] });
				}
			}
		});
	}

	function isValid() {
		if (!Const.DLC.Paladins)
			return false;

		if (World.Assets.getOrigin().getID() != "scenario.oathtakers")
			return false;

		local numBooks = 0;
		local stash = World.Assets.getStash().getItems();

		foreach (item in stash) {
			if (item != null && item.getID() == "misc.book_of_oaths")
				numBooks++;
		}

		if (numBooks > 1)
			return true;

		return false;
	}

	function onUpdateScore() {
		return;
	}

	function onPrepare() {
		local items = World.Assets.getStash().getItems();
		local candidates = [];

		foreach (item in items) {
			if (item == null)
				continue;

			if (item.getID() == "misc.book_of_oaths")
				candidates.push(item);
		}

		for (local i = 1; i < candidates.len(); i++) {
			World.Assets.getStash().remove(candidates[i]);
		}
	}

	function onPrepareVariables(_vars) { }

	function onClear() { }
});
