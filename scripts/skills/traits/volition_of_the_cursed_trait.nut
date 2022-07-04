volition_of_the_cursed_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.volition_of_the_cursed";
		m.Name			= "Volition of the Cursed";
		m.Icon			= "ui/traits/trait_icon_plus_17.png";
		m.Description	= "The victims of the Pillager Rot are driven to be free of it. For each legend proven true, the existence of the Fountain of Youth becomes itself more likely, and the desperate take heart from each piece of the wilderness' veil to be drawn back.";

		m.Order			= Const.SkillOrder.Trait - 2;
		m.IsHidden		= true;

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
		];

		local ll_cleared = getContainer().getActor().getFlags().getAsInt("CursedExplorersLegendaryLocations");
		if (ll_cleared > 0) {
			ret.push({ id = 10, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + ll_cleared + "[/color] Resolve" });
			ret.push({ id = 10, type = "text", icon = "ui/icons/melee_skill.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + ll_cleared + "[/color] Melee Skill" });
			ret.push({ id = 10, type = "text", icon = "ui/icons/ranged_skill.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + ll_cleared + "[/color] Ranged Skill" });
			ret.push({ id = 10, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + ll_cleared + "[/color] Melee Defense" });
			ret.push({ id = 10, type = "text", icon = "ui/icons/ranged_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + ll_cleared + "[/color] Ranged Defense" });
		} else {
			ret.push({ id = 10, type = "text", icon = "ui/icons/special.png", text = "No legendary locations discovered so far" });
		}

		if (getContainer().getActor().getFlags().getAsInt("CursedExplorersRotsActive") > 0)
			ret.push({ id = 10, type = "text", icon = "ui/icons/asset_daily_money.png", text = "Demands [color=" + Const.UI.Color.PositiveValue + "]15%[/color] fewer wages per day" });

		return ret;
	}

	function onUpdate(_properties)
	{
		local ll_cleared			= getContainer().getActor().getFlags().getAsInt("CursedExplorersLegendaryLocations");

		_properties.Bravery			+= ll_cleared;
		_properties.MeleeSkill		+= ll_cleared;
		_properties.RangedSkill		+= ll_cleared;
		_properties.MeleeDefense	+= ll_cleared;
		_properties.RangedDefense	+= ll_cleared;

		local activeRot				= getContainer().getActor().getFlags().getAsInt("CursedExplorersRotsActive");

		if (activeRot > 0)
			_properties.DailyWageMult *= 0.85;

		if (activeRot > 0 || ll_cleared > 0)
			m.IsHidden = false;
	}
})
