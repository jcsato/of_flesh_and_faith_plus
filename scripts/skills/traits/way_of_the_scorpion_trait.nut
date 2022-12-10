way_of_the_scorpion_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.way_of_the_scorpion";
		m.Name			= "Way of the Scorpion";
		m.Icon			= "ui/traits/trait_icon_plus_08.png";
		m.Description	= "No man is without flaw, no creature incapable of error. To best a target, then, is a matter of enduring until they make such an error - and then striking decisively. Such is the Way of the Scorpion.";

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/fatigue.png", text = "[color=" + this.Const.UI.Color.PositiveValue + "]+2[/color] Fatigue Recovery per turn" }
			{ id = 12, type = "text", icon = "ui/icons/special.png", text = "Builds up [color=" + this.Const.UI.Color.PositiveValue + "]1[/color] less Fatigue for each tile travelled" }
		];

		return ret;
	}

	function onUpdate(_properties)
	{
		_properties.MovementFatigueCostAdditional	-= 1;
		_properties.FatigueRecoveryRate				+= 2;
	}

})