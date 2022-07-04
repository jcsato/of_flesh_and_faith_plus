rot_05_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.rot_05";
		m.Name			= "Nerverot";
		m.Icon			= "ui/traits/trait_icon_plus_05.png";
		m.Description	= "The Rot has spread to this character's nerves. Jolts of pain shoot through their limbs seemingly at random, making it difficult to react with speed and surety.";

		m.Order			= Const.SkillOrder.Trait - 1;

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-10%[/color] Melee Defense" }
			{ id = 12, type = "text", icon = "ui/icons/ranged_defense.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-10%[/color] Ranged Defense" }
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
		_properties.MeleeDefenseMult	*= 0.9;
		_properties.RangedDefenseMult	*= 0.9;
	}
})
