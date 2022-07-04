rune_05_item <- inherit("scripts/items/item",
{

	m =
	{
	}

	function create()
	{
		m.ID					= "misc.rune_05";
		m.Name					= "Death's Door Rune";
		m.Description			= "If a warrior meets his end without truly leaving his mark on this plane, his soul's strength may be ceded to another who may claim glory for the both of them.\n\nFew reach the first threshold, but truly rare is the warrior who lives in the final portal, in the door of death.";
		m.SlotType				= Const.ItemSlot.None;
		m.ItemType				= Const.Items.ItemType.Usable;
		
		m.IsDroppedAsLoot		= true;
		m.IsAllowedInBag		= false;
		m.IsUsable				= true;

		m.IconLarge				= "";
		m.Icon					= "consumables/rune_05.png";

		m.Value					= 0;
	}

	function getTooltip()
	{
		local result =
		[ 
			{ id = 1, type = "title", text = getName() },
			{ id = 2, type = "description", text = getDescription() }
		];

		result.push({ id = 66, type = "text", text = getValueString() });

		if (getIconLarge() != null)
			result.push({ id = 3, type = "image", image = getIconLarge(), isLarge = true });
		else
			result.push({ id = 3, type = "image", image = getIcon() });

		result.push({ id = 14, type = "text", icon = "ui/icons/special.png", text = "Deal [color=" + Const.UI.Color.PositiveValue + "]+15%[/color] Damage if hitpoints are below [color=" + Const.UI.Color.NegativeValue + "]75%[/color]" });
		result.push({ id = 15, type = "text", icon = "ui/icons/bravery.png", text = "Grants [color=" + Const.UI.Color.PositiveValue + "]+4[/color] Resolve upon taking hitpoint damage, resetting at the end of combat" });
		result.push({ id = 16, type = "text", icon = "ui/icons/initiative.png", text = "Grants [color=" + Const.UI.Color.PositiveValue + "]+6[/color] Initiative upon taking hitpoint damage, resetting at the end of combat" });
		result.push({ id = 65, type = "text", text = "Right-click or drag onto the currently selected character in order to etch the rune into their soul. This item will be consumed in the process." });

		return result;
	}

	function playInventorySound(_eventType)
	{
		Sound.play("sounds/combat/armor_leather_impact_03.wav", Const.Sound.Volume.Inventory);
	}

	function onUse(_actor, _item = null)
	{
		if (_actor.getSkills().hasSkill("effects.rune_05"))
			return false;

		Sound.play("sounds/combat/shatter_hit_0" + Math.rand(1, 3) + ".wav", Const.Sound.Volume.Inventory);

		_actor.getSkills().add(new("scripts/skills/effects/rune_05_effect"));
		_actor.getFlags().increment("numActiveRunes");

		return true;
	}
})