rune_06_item <- inherit("scripts/items/item", {
	m = {
		BraveryBuff		= 15
		ThreatBuff		= 5
	}

	function create() {
		m.ID					= "misc.rune_06";
		m.Name					= "Nemesis Rune";
		m.Description			= "If a warrior meets his end without truly leaving his mark on this plane, his soul's strength may be ceded to another who may claim glory for the both of them.\n\nTo know the true worth of an enemy is a difficult task indeed, but the rune rite does not discriminate against any who prove themselves, regardless of allegiance.";
		m.SlotType				= Const.ItemSlot.None;
		m.ItemType				= Const.Items.ItemType.Usable;

		m.IsDroppedAsLoot		= true;
		m.IsAllowedInBag		= false;
		m.IsUsable				= true;

		m.IconLarge				= "";
		m.Icon					= "consumables/rune_06.png";

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

		result.push({ id = 10, type = "text", icon = "ui/icons/regular_damage.png", text = "Reduces the Resolve of any opponent engaged in melee by [color=" + Const.UI.Color.NegativeValue + "]-" + m.ThreatBuff + "[/color]" });
		result.push({ id = 11, type = "text", icon = "ui/icons/special.png", text = "Gain [color=" + Const.UI.Color.PositiveValue + "]+" + m.BraveryBuff + "[/color] Resolve when in battle with enemy champions or leaders" });
		result.push({ id = 65, type = "text", text = "Right-click or drag onto the currently selected character in order to etch the rune into their soul. This item will be consumed in the process." });

		return result;
	}

	function playInventorySound(_eventType) {
		Sound.play("sounds/combat/armor_leather_impact_03.wav", Const.Sound.Volume.Inventory);
	}

	function onUse(_actor, _item = null) {
		if (_actor.getSkills().hasSkill("effects.rune_06"))
			return false;

		Sound.play("sounds/combat/shatter_hit_0" + Math.rand(1, 3) + ".wav", Const.Sound.Volume.Inventory);

		_actor.getSkills().add(new("scripts/skills/effects/rune_06_effect"));
		_actor.getFlags().increment("numActiveRunes");

		return true;
	}
});
