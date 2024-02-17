oath_of_sacrifice_completed_effect <- inherit("scripts/skills/skill", {
	m = {
		DamageReduction			= 20
		InjuryThresholdBonus	= 20
	}

	function create() {
		m.ID					= "effects.oath_of_sacrifice_completed";
		m.Name					= "Oath of Sacrifice";
		m.Description			= "\"To withstand suffering, one must first know it. Just as the priory monks eschew the vices of the world and find their holy wisdom in deprivation, so too in devastation shall you find the will to rise in renewed strength.\"";
		m.Icon					= "skills/status_effect_plus_34.png";
		m.IconMini				= "";
		m.Overlay				= "status_effect_plus_34";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 9;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip(_normalDescription = true) {
		local ret = [{ id = 1, type = "title", text = getName() }];

		if (_normalDescription)
			ret.push({ id = 2, type = "description", text = getDescription() });
		else
			ret.push({ id = 2, type = "description", text = "Upholding this Oath will grant the following effects:" });

		ret.extend([
			{ id = 10, type = "text", icon = "ui/icons/special.png", text = "The threshold to sustain injuries on getting hit is increased by [color=" + Const.UI.Color.PositiveValue + "]" + m.InjuryThresholdBonus + "%[/color]" }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "Receives only [color=" + Const.UI.Color.PositiveValue + "]" + (100 - m.DamageReduction) + "%[/color] of any damage while affected by injuries" }
		]);

		return ret;
	}

	function getManagementScreenTooltip() {
		return getTooltip(false);
	}

	function onUpdate( _properties ) {
		_properties.ThresholdToReceiveInjuryMult *= (1.0 + m.InjuryThresholdBonus / 100.0);

		if (getContainer().getActor().getSkills().hasSkillOfType(Const.SkillType.TemporaryInjury) || getContainer().getActor().getSkills().hasSkillOfType(Const.SkillType.PermanentInjury))
			_properties.DamageReceivedTotalMult	*= (1.0 - (m.DamageReduction / 100.0));
	}
});
