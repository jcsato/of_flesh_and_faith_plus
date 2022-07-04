oath_of_valor_upheld_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.oath_of_valor_upheld";
		m.Name			= "Oath of Valor Upheld";
		m.Icon			= "ui/traits/trait_icon_plus_27.png";
		m.Description	= "This character has fulfilled an Oath of Valor, and has stared into the horrors of man and monster and death alike. He never broke while under the Oath, and he doesn't intend to start now.";

		m.Order			= Const.SkillOrder.Trait + 1;

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+5[/color] Resolve" }
		];

		return ret;
	}

	function onUpdate(_properties)
	{
		_properties.Bravery		+= 5;
	}
})
