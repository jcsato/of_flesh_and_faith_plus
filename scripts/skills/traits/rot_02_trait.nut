rot_02_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.rot_02";
		m.Name			= "Heartrot";
		m.Icon			= "ui/traits/trait_icon_plus_02.png";
		m.Description	= "The Rot has reached this character's heart, weakening their constitution.";

		m.Order			= Const.SkillOrder.Trait - 1;

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/health.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-10%[/color] Hitpoints" }
		];

		return ret;
	}

	function onAdded()
	{
		getContainer().getActor().getFlags().increment("CursedExplorersRotsActive");
	}

	function onRemoved()
	{
		getContainer().getActor().getFlags().increment("CursedExplorersRotsActive", -1);
	}

	function onUpdate(_properties)
	{
		_properties.HitpointsMult	*= 0.9;
	}
})
