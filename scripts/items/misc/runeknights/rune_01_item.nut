rune_01_item <- inherit("scripts/items/item", {
	m = { }

	function create() {
		item.create();

		m.ID					= "misc.rune_01";
		m.Name					= "Rune of the Threshold";
		m.Description			= "If a warrior meets his end without truly leaving his mark on this plane, his soul's strength may be ceded to another who may claim glory for the both of them.\n\nMost are unworthy of having their soul inscribed in a rune. To stand on the threshold of greatness in Ironhand's eyes is an honor indeed.";
		m.SlotType				= Const.ItemSlot.None;
		m.ItemType				= Const.Items.ItemType.Usable;
		
		m.IsDroppedAsLoot		= true;
		m.IsAllowedInBag		= false;
		m.IsUsable				= true;

		m.IconLarge				= "";
		m.Icon					= "consumables/rune_01.png";

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

		result.push({ id = 11, type = "text", icon = "ui/icons/special.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+5%[/color] Experience Gain" });
		result.push({ id = 65, type = "text", text = "Right-click or drag onto the currently selected character in order to etch the rune into their soul. This item will be consumed in the process." });

		return result;
	}

	function playInventorySound(_eventType) {
		Sound.play("sounds/combat/armor_leather_impact_03.wav", Const.Sound.Volume.Inventory);
	}

	function onUse(_actor, _item = null) {
		if (_actor.getSkills().hasSkill("effects.rune_01"))
			return false;

		Sound.play("sounds/combat/shatter_hit_0" + Math.rand(1, 3) + ".wav", Const.Sound.Volume.Inventory);

		_actor.getSkills().add(new("scripts/skills/effects/rune_01_effect"));
		_actor.getFlags().increment("numActiveRunes");

		return true;
	}
});
