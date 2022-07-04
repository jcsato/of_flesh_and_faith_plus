oath_of_sacrifice_upheld_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.oath_of_sacrifice_upheld";
		m.Name			= "Oath of Sacrifice Upheld";
		m.Icon			= "ui/traits/trait_icon_plus_26.png";
		m.Description	= "This character has fulfilled an Oath of Sacrifice, and has the scars to prove it. The flesh is not strengthened by ruination, and a dead man can sacrifice nothing. In this truth lies the realization that to truly put the needs of others over himself, a man must first stay alive and healthy enough to give.";

		m.Order			= Const.SkillOrder.Trait + 1;

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "The threshold to sustain injuries on getting hit is increased by [color=" + Const.UI.Color.PositiveValue + "]33%[/color]" }
		];

		return ret;
	}

	function onUpdate(_properties)
	{
		_properties.ThresholdToReceiveInjuryMult	*= 1.33;
	}
})
