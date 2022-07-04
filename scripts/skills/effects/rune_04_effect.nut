rune_04_effect <- inherit("scripts/skills/skill",
{
	m =
	{
	}

	function create()
	{
		m.ID					= "effects.rune_04";
		m.Name					= "Rune of the Old God";
		m.Icon					= "skills/status_effect_plus_04.png";
		m.IconMini				= "status_effect_plus_04_mini";
		m.Overlay				= "status_effect_plus_04";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Trait - 7;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getDescription()
	{
		return "\"Ne\'er shall mine chosen betray my service to bend knee to fear. Meet thine death with thine weapon in hand and thine heart free of indolence.\"";
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 15, type = "text", icon = "ui/icons/fatigue.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+3[/color] Fatigue Recovery per turn" }
			{ id = 16, type = "text", icon = "ui/icons/morale.png", text = "No morale check triggered upon losing hitpoints" }
			{ id = 17, type = "text", icon = "ui/icons/morale.png", text = "No morale check triggered upon allies fleeing" }
			{ id = 18, type = "text", icon = "ui/icons/morale.png", text = "No morale check triggered upon allies dying" }
		];

		return ret;
	}

	function onUpdate(_properties)
	{
		_properties.FatigueRecoveryRate			+= 3;
		_properties.IsAffectedByLosingHitpoints	= false;
		_properties.IsAffectedByFleeingAllies	= false;
		_properties.IsAffectedByDyingAllies		= false;
	}
})