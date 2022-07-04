rune_06_effect <- inherit("scripts/skills/skill",
{
	m =
	{
		BraveryBuff		= 15
		ThreatBuff		= 7
	}

	function create()
	{
		m.ID					= "effects.rune_06";
		m.Name					= "Nemesis Rune";
		m.Icon					= "skills/status_effect_plus_06.png";
		m.IconMini				= "status_effect_plus_06_mini";
		m.Overlay				= "status_effect_plus_06";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Trait - 5;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getDescription()
	{
		return "\"Be thee thankful for thine nemesis, for without him there is scant purpose in life, and with him there is reason for thee both to die.\"";
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/regular_damage.png", text = "Reduces the Resolve of any opponent engaged in melee by [color=" + Const.UI.Color.NegativeValue + "]-" + m.ThreatBuff + "[/color]" }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.BraveryBuff + "[/color] Resolve when in battle with enemy champions or leaders" }
		];

		return ret;
	}

	function onUpdate(_properties)
	{
		_properties.Threat += m.ThreatBuff;

		if(!getContainer().getActor().isPlacedOnMap())
			return;

		local nemesisPresent = false;
		local enemies = Tactical.Entities.getAllHostilesAsArray();

		foreach(enemy in enemies)
		{
			if (enemy.m.IsMiniboss || enemy.getSkills().hasSkill("perk.captain"))
			{
				nemesisPresent = true;
				break;
			}
		}

		if (nemesisPresent)
			_properties.Bravery += m.BraveryBuff;
	}
})