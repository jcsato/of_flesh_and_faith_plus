way_of_the_gilder_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.way_of_the_gilder";
		m.Name			= "Way of the Gilder";
		m.Icon			= "ui/traits/trait_icon_plus_07.png";
		m.Description	= "Underneath the mystique of shadows and poisons, assassins are naught but men, fleshen constructs on the Gilder's meridian. To follow the Way of the Gilder is to acknowledge this truth and seek balance in all things, and in so doing be guided by His gleam.";

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/health.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+1[/color] Hitpoints" }
			{ id = 12, type = "text", icon = "ui/icons/fatigue.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+1[/color] Max Fatigue" }
			{ id = 13, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+1[/color] Resolve" }
			{ id = 14, type = "text", icon = "ui/icons/initiative.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+1[/color] Initiative" }
			{ id = 14, type = "text", icon = "ui/icons/melee_skill.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+1[/color] Melee Skill" }
			{ id = 15, type = "text", icon = "ui/icons/ranged_skill.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+1[/color] Ranged Skill" }
			{ id = 16, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+1[/color] Melee Defense" }
			{ id = 17, type = "text", icon = "ui/icons/ranged_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+1[/color] Ranged Defense" }
		];

		return ret;
	}

	function onUpdate(_properties)
	{
		_properties.Hitpoints		+= 1;
		_properties.Stamina			+= 1;
		_properties.Bravery			+= 1;
		_properties.Initiative		+= 1;
		_properties.MeleeSkill		+= 1;
		_properties.RangedSkill		+= 1;
		_properties.MeleeDefense	+= 1;
		_properties.RangedDefense	+= 1;
	}

})