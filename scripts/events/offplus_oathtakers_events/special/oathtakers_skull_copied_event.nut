oathtakers_skull_copied_event <- inherit("scripts/events/event", {
	m = { }

	function create() {
		m.ID		= "event.oathtakers_skull_copied";
		m.Title		= "During camp...";
		m.IsSpecial = true;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_plus_01.png[/img]{You exit your tent to the sound of the men making a great commotion. You hurry over to the source of the sound and quickly find its cause: in the middle of camp lies not just Young Anselm's skull, but its duplicate. The two are identical, down to the shape and size of the mark on the first Oathtaker's forehead. The only conclusion to draw is that one - or both - are forgeries, and the companies' more faithful men are frothing at the mouth.\n\nBefore you can even begin to placate them, the Oathtakers of the company grab one of the skulls and promptly march out of the camp. You think to stop them, but the look in their eyes tells you they'd kill anyone who got in their way.\n\nThe rest of the men are understandably sullen and a dour mood takes over the camp. You glance at the skull that remains, unsure if it's the true artifact or a mere copy, or if either of them were ever real. You gaze into its empty sockets and realize you'll never know for certain.}"
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
					if (bro.getBackground().getID() == "background.paladin") {
						List.push( { id = 13, icon = "ui/icons/kills.png", text = bro.getName() + " leaves the " + World.Assets.getName() } );
						bro.getItems().transferToStash(World.Assets.getStash());
						bro.getSkills().onDeath(Const.FatalityType.None);
						World.getPlayerRoster().remove(bro);
					} else {
						bro.worsenMood(1.0, "The company found a forgery of Young Anselm's skull");

						if (bro.getMoodState() < Const.MoodState.Neutral)
							List.push({ id = 11, icon = Const.MoodStateIcon[bro.getMoodState()], text = bro.getName() + Const.MoodStateEvent[bro.getMoodState()] });
					}
				}

				World.Assets.getStash().makeEmptySlots(1);
				World.Assets.getStash().add(new("scripts/items/accessory/oathtaker_skull_01_item"));
			}
		});
	}

	function isValid() {
		if (!Const.DLC.Paladins)
			return false;

		if (World.Assets.getOrigin().getID() != "scenario.oathtakers")
			return false;

		local numSkulls = 0;
		local brothers = World.getPlayerRoster().getAll();
		local stash = World.Assets.getStash().getItems();

		foreach (bro in brothers) {
			local item = bro.getItems().getItemAtSlot(Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
				numSkulls++;
		}

		foreach (item in stash) {
			if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
				numSkulls++;
		}

		if (numSkulls > 1)
			return true;

		return false;
	}

	function onUpdateScore() {
		return;
	}

	function onPrepare() {
		local brothers = World.getPlayerRoster().getAll();
		local items = World.Assets.getStash().getItems();
		local candidates = [];

		foreach (bro in brothers) {
			local item = bro.getItems().getItemAtSlot(Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
				bro.getItems().unequip(item);
		}

		foreach (item in items) {
			if (item == null)
				continue;

			if (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02")
				candidates.push(item);
		}

		for (local i = 0; i < candidates.len(); i++) {
			World.Assets.getStash().remove(candidates[i]);
		}
	}

	function onPrepareVariables(_vars) { }

	function onClear() { }
});
