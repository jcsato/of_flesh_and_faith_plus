oath_of_humility_upheld_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.oath_of_humility_upheld";
		m.Name			= "Oath of Humility Upheld";
		m.Icon			= "ui/traits/trait_icon_plus_24.png";
		m.Description	= "This character has fulfilled an Oath of Humility, and sees the world differently. The allure of earthly vices remains, of course, but the glitter of gold has lost some of its appeal, knowing better the value of things that cannot be bought.";

		m.Order			= Const.SkillOrder.Trait + 1;

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/asset_daily_money.png", text = "Demands [color=" + Const.UI.Color.PositiveValue + "]10%[/color] fewer wages per day" }
		];

		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.DailyWageMult *= 0.9;
	}
})