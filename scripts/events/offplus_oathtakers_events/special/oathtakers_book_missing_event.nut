oathtakers_book_missing_event <- inherit("scripts/events/event", {
	m = { }

	function create() {
		m.ID		= "event.oathtakers_book_missing";
		m.Title		= "During camp...";
		m.IsSpecial = true;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_15.png[/img]{You step out of your tent to find the men in a furor. Apparently one of them found the Book of Oaths discarded along the side of the road, rather than safely ensconced in inventory. Naturally, the men are upset and the transgression already has them pointing fingers at one another for who bears ultimate responsibility.\n\nThinking fast, you interject that it must have been a thief who failed to realize the true value of the book and threw it away. The explanation seems to satisfy the men and direct their hostility away from each other - and more importantly, you - but the debacle has left them on edge nonetheless. It will be some time before morale recovers fully.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Guess I should have seen that coming."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				local brothers = World.getPlayerRoster().getAll();
				local item = new("scripts/items/misc/oathtakers/book_of_oaths");

				World.Assets.getStash().makeEmptySlots(1);
				World.Assets.getStash().add(item);
				List.push({ id = 10, icon = "ui/items/" + item.getIcon(), text = "You gain " + Const.Strings.getArticle(item.getName()) + item.getName() });

				foreach (bro in brothers) {
					if (bro.getBackground().getID() == "background.paladin")
						bro.worsenMood(1.5, "The company almost lost the Book of Oaths");
					else
						bro.worsenMood(0.75, "The company almost lost the Book of Oaths");

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

		local haveBook = false;

		local stash = World.Assets.getStash().getItems();
		foreach (item in stash) {
			if (item != null && item.getID() == "misc.book_of_oaths") {
				haveBook = true;
				break;
			}
		}

		if (!haveBook)
			return true;

		return false;
	}

	function onUpdateScore() {
		return;
	}

	function onPrepareVariables(_vars) { }

	function onClear() { }
});
