rune_01_effect <- inherit("scripts/skills/skill",
{
	m =
	{
	}

	function create()
	{
		m.ID					= "effects.rune_01";
		m.Name					= "Rune of the Threshold";
		m.Icon					= "skills/status_effect_plus_01.png";
		m.IconMini				= "status_effect_plus_01_mini";
		m.Overlay				= "status_effect_plus_01";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Trait - 10;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getDescription()
	{
		return "\"Stand in the threshold, mine chosen. Brace thineself against its void, and in the liminal plane between death and glory, see thine fate and the fate of thine predecessors and know that under mine auspice your death shall be worthy.\"";
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/xp_received.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+5%[/color] Experience Gain" }
		];

		return ret;
	}

	function onUpdate(_properties)
	{
		_properties.XPGainMult		*= 1.05;
	}

})