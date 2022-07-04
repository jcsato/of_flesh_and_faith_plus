oath_of_honor_upheld_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.oath_of_honor_upheld";
		m.Name			= "Oath of Honor Upheld";
		m.Icon			= "ui/traits/trait_icon_plus_23.png";
		m.Description	= "This character has fulfilled an Oath of Honor, and proven himself a more than capable melee combatant. Indeed, he carries himself differently from other men, and strides into battle with an imposing calm that even his enemies cannot ignore.";

		m.Order			= Const.SkillOrder.Trait + 1;

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 12, type = "text", icon = "ui/icons/special.png", text = "Reduces the Resolve of any opponent engaged in melee by [color=" + Const.UI.Color.NegativeValue + "]-3[/color]" }
		];

		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.Threat += 3;
	}
})
