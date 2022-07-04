oath_of_camaraderie_upheld_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.oath_of_camaraderie_upheld";
		m.Name			= "Oath of Camaraderie Upheld";
		m.Icon			= "ui/traits/trait_icon_plus_18.png";
		m.Description	= "This character has fulfilled an Oath of Camaraderie, and has forged a trust in his allies with the fires of battle. So long as the line holds, so will he.";

		m.Order			= Const.SkillOrder.Trait + 1;

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/morale.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+2[/color] Resolve against negative morale checks for each adjacent ally" }
		];

		return ret;
	}
})