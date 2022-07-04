oath_of_endurance_upheld_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.oath_of_endurance_upheld";
		m.Name			= "Oath of Endurance Upheld";
		m.Icon			= "ui/traits/trait_icon_plus_21.png";
		m.Description	= "This character has fulfilled an Oath of Endurance, and fights with a drive few men possess. Whether his time spent under the Oath drove him beyond his limits or his physical abilities are simply augmented by zeal, he'll be the last to slow down in battle.";

		m.Order			= Const.SkillOrder.Trait + 1;

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/fatigue.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+5[/color] Fatigue" }
			{ id = 11, type = "text", icon = "ui/icons/fatigue.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+1[/color] Fatigue Recovery per turn" }
		];

		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.Stamina				+= 5;
		_properties.FatigueRecoveryRate	+= 1;
	}
})