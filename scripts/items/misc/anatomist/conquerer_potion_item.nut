conquerer_potion_item <- inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = { }

	function create() {
		anatomist_potion_item.create();

		m.ID			= "misc.conquerer_potion";
		m.Name			= "Soul of the Fallen";
		m.Description	= "This smoky mixture, created through intense study of the undead known as 'the Conquerer', grants the vengeful fury that seems to drive the ancient dead themselves - but directed at more productive targets!";

		m.IconLarge		= "";
		m.Icon			= "consumables/potion_plus_01.png";

		m.Value			= 0;
	}

	function getTooltip() {
		local result = [
			{ id = 1, type = "title", text = getName() },
			{ id = 2, type = "description", text = getDescription() }
		];

		result.push({ id = 66, type = "text", text = getValueString() });

		if (getIconLarge() != null)
			result.push({ id = 3, type = "image", image = getIconLarge(), isLarge = true });
		else
			result.push({ id = 3, type = "image", image = getIcon() });

		result.push({ id = 11, type = "text", icon = "ui/icons/special.png", text = "Add [color=" + Const.UI.Color.PositiveValue + "]50%[/color] of all accrued armor damage to the next attack" });
		result.push({ id = 11, type = "text", icon = "ui/icons/special.png", text = "Resets upon landing a hit" });

		result.push({ id = 65, type = "text", text = "Right-click or drag onto the currently selected character in order to drink. This item will be consumed in the process." });

		result.push({ id = 65, type = "hint", icon = "ui/tooltips/warning.png", text = "Mutates the body, causing sickness" });

		return result;
	}

	function playInventorySound(_eventType) {
		Sound.play("sounds/bottle_01.wav", Const.Sound.Volume.Inventory);
	}

	function onUse(_actor, _item = null) {
		_actor.getSkills().add(new("scripts/skills/effects/conquerer_potion_effect"));

		return anatomist_potion_item.onUse(_actor, _item);
	}
});
