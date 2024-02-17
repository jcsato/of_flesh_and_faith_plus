rune_07_item <- inherit("scripts/items/item", {
	m = {
		HitpointRegen	= 1
		FatigueRegen	= 5
	}

	function create() {
		m.ID					= "misc.rune_07";
		m.Name					= "Rune of the Berserker";
		m.Description			= "If a warrior meets his end without truly leaving his mark on this plane, his soul's strength may be ceded to another who may claim glory for the both of them.\n\nThose who have stared into the gaze of the mad god can never know peace. They crave battle, for only in combat does his shroud lift and a clarity of purpose descends.";
		m.SlotType				= Const.ItemSlot.None;
		m.ItemType				= Const.Items.ItemType.Usable;

		m.IsDroppedAsLoot		= true;
		m.IsAllowedInBag		= false;
		m.IsUsable				= true;

		m.IconLarge				= "";
		m.Icon					= "consumables/rune_07.png";

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

		result.push({ id = 11, type = "text", icon = "ui/icons/health.png", text = "Recover [color=" + Const.UI.Color.PositiveValue + "]" + m.HitpointRegen + "[/color] Hitpoint per turn for each active rune" });
		result.push({ id = 12, type = "text", icon = "ui/icons/special.png", text = "Once per turn, killing an opponent reduces current fatigue by [color=" + Const.UI.Color.NegativeValue + "]-" + m.FatigueRegen + "[/color]" });
		result.push({ id = 13, type = "text", icon = "ui/icons/special.png", text = "The threshold to sustain injuries on getting hit is decreased by [color=" + Const.UI.Color.NegativeValue + "]-20%[/color]" });
		result.push({ id = 65, type = "text", text = "Right-click or drag onto the currently selected character in order to etch the rune into their soul. This item will be consumed in the process." });

		return result;
	}

	function playInventorySound(_eventType) {
		Sound.play("sounds/combat/armor_leather_impact_03.wav", Const.Sound.Volume.Inventory);
	}

	function onUse(_actor, _item = null) {
		if (_actor.getSkills().hasSkill("effects.rune_07"))
			return false;

		Sound.play("sounds/combat/shatter_hit_0" + Math.rand(1, 3) + ".wav", Const.Sound.Volume.Inventory);

		_actor.getSkills().add(new("scripts/skills/effects/rune_07_effect"));
		_actor.getFlags().increment("numActiveRunes");

		return true;
	}
});
