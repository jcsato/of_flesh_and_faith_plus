rune_02_item <- inherit("scripts/items/item", {
	m = { }

	function create() {
		m.ID					= "misc.rune_02";
		m.Name					= "Unpassage Rune";
		m.Description			= "If a warrior meets his end without truly leaving his mark on this plane, his soul's strength may be ceded to another who may claim glory for the both of them.\n\nMany kinds of warriors quest for Ironhand's favor, but common to all the most successful is an unrelenting vigor that compels them to seek the next conquest.";
		m.SlotType				= Const.ItemSlot.None;
		m.ItemType				= Const.Items.ItemType.Usable;
		
		m.IsDroppedAsLoot		= true;
		m.IsAllowedInBag		= false;
		m.IsUsable				= true;

		m.IconLarge				= "";
		m.Icon					= "consumables/rune_02.png";

		m.Value					= 0;
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

		result.push({ id = 11, type = "text", icon = "ui/icons/days_wounded.png", text = "Injuries heal [color=" + Const.UI.Color.PositiveValue + "]1[/color] day faster" });
		result.push({ id = 11, type = "text", icon = "ui/icons/special.png", text = "Recovers [color=" + Const.UI.Color.PositiveValue + "]10[/color] Hitpoints after each battle" });
		result.push({ id = 65, type = "text", text = "Right-click or drag onto the currently selected character in order to etch the rune into their soul. This item will be consumed in the process." });

		return result;
	}

	function playInventorySound(_eventType) {
		Sound.play("sounds/combat/armor_leather_impact_03.wav", Const.Sound.Volume.Inventory);
	}

	function onUse(_actor, _item = null) {
		if (_actor.getSkills().hasSkill("effects.rune_02"))
			return false;

		Sound.play("sounds/combat/shatter_hit_0" + Math.rand(1, 3) + ".wav", Const.Sound.Volume.Inventory);

		_actor.getSkills().add(new("scripts/skills/effects/rune_02_effect"));
		_actor.getFlags().increment("numActiveRunes");

		return true;
	}
});
