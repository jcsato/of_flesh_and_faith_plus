oath_of_fortification_upheld_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.oath_of_fortification_upheld";
		m.Name			= "Oath of Fortification Upheld";
		m.Icon			= "ui/traits/trait_icon_plus_22.png";
		m.Description	= "This character has fulfilled an Oath of Fortification, and possesses a fortitude to rival that of his shield. In his time spent under the Oath he picked up new skills, and when given a proper bulwark he'll yield to none.";

		m.Order			= Const.SkillOrder.Trait + 1;

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 6, type = "text", icon = "ui/icons/special.png", text = "Immune to being knocked back or grabbed when wielding a shield" }
		];

		return ret;
	}

	
	function onUpdate(_properties)
	{
		local items = getContainer().getActor().getItems();
		local offhand = items.getItemAtSlot(Const.ItemSlot.Offhand);

		if (offhand != null && offhand.isItemType(Const.Items.ItemType.Shield))
			_properties.IsImmuneToKnockBackAndGrab = true;
	}
})