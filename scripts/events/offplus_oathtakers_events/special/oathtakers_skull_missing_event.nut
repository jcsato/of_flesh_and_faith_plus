oathtakers_skull_missing_event <- inherit("scripts/events/event", {
	m = { }

	function create() {
		m.ID		= "event.oathtakers_skull_missing";
		m.Title		= "During camp...";
		m.IsSpecial = true;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_plus_01.png[/img]{You exit your tent to take stock of the men and find them ringing a stool in stony silence. Upon the stool sits the skull of Young Anselm, its gaping eye sockets seeming to point at you regardless of where you stand. %randombrother% comes up to you and explains that one of the men found the skull on the ground some ways away from camp, rather than safely in inventory. The implications are obvious.\n\nFortunately, the Oathtakers of the company are too cooperative to begin accusing others of heresy, choosing to believe that it was instead some accident that saw their founder's remains tossed aside. Unfortunately, even the least superstitious among them sees this as an ill-omen of immense proportions. Their morale will not recover for some time.}"
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
				local item = new("scripts/items/accessory/oathtaker_skull_01_item");

				World.Assets.getStash().makeEmptySlots(1);
				World.Assets.getStash().add(item);
				List.push({ id = 10, icon = "ui/items/" + item.getIcon(), text = "You gain " + Const.Strings.getArticle(item.getName()) + item.getName() });

				foreach (bro in brothers) {
					if (bro.getBackground().getID() == "background.paladin")
						bro.worsenMood(3.0, "The company almost lost Young Anselm's skull");
					else
						bro.worsenMood(1.5, "The company almost lost Young Anselm's skull");

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

		if (!::OFFP.Helpers.hasSkull(World.getPlayerRoster().getAll(), World.Assets.getStash().getItems()))
			return true;

		return false;
	}

	function onUpdateScore() {
		return;
	}

	function onPrepareVariables(_vars) { }

	function onClear() { }
});
