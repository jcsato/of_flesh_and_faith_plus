oath_of_wrath_upheld_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.oath_of_wrath_upheld";
		m.Name			= "Oath of Wrath Upheld";
		m.Icon			= "ui/traits/trait_icon_plus_29.png";
		m.Description	= "This character has fulfilled an Oath of Wrath, and refuses to let the attacks of others halt their own strikes. Though no amount focus can shorten the depth of a stab or the length of a cut, while under the Oath he learned to ignore the pain and move with the blows, putting all his mind and soul into hitting back.";

		m.Order			= Const.SkillOrder.Trait + 1;

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "This character accumulates [color=" + Const.UI.Color.PositiveValue + "]50%[/color] less Fatigue from enemy attacks, whether they hit or miss, when wielding a two-handed or double-gripped melee weapon" }
		];

		return ret;
	}

	function onUpdate(_properties)
	{
		local items = getContainer().getActor().getItems();
		local main = items.getItemAtSlot(Const.ItemSlot.Mainhand);

		if (main != null && main.isItemType(Const.Items.ItemType.MeleeWeapon) && (main.isItemType(Const.Items.ItemType.TwoHanded) || (items.getItemAtSlot(Const.ItemSlot.Offhand) == null && !items.hasBlockedSlot(Const.ItemSlot.Offhand))))
			_properties.FatigueLossOnAnyAttackMult = 0.5;
	}
})
