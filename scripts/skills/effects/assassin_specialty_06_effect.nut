
assassin_specialty_06_effect <- inherit("scripts/skills/skill", {
	m = {
		DamageDistanceLow	= 1
		DamageDistanceHigh	= 4
		DamagePercentLow	= 10
		DamagePercentHigh	= 30
	}

	function create() {
		m.ID			= "effects.assassin_specialty_06";
		m.Name			= "Sniper";
		m.Description	= "This character has trained intensely to hold unshakeable focus on single targets and knows where to aim attacks for maximal effect.";
		m.Icon			= "skills/status_effect_plus_51.png";
		m.IconMini		= "";
		m.Type			= Const.SkillType.StatusEffect | Const.SkillType.Perk;
		m.Order			= Const.SkillOrder.Any - 2;
		m.IsActive		= false;
		m.IsStacking	= false;
	}

	function getTooltip() {
		return [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 15, type = "text", icon = "ui/icons/regular_damage.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.DamagePercentHigh + "%[/color] damage if the target is more than [color=" + Const.UI.Color.NegativeValue + "]" + m.DamageDistanceHigh + "[/color] tile away" }
			{ id = 15, type = "text", icon = "ui/icons/regular_damage.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.DamagePercentLow + "%[/color] damage if the target is more than [color=" + Const.UI.Color.NegativeValue + "]" + m.DamageDistanceLow + "[/color] tile away" }
			{ id = 10, type = "text", icon = "ui/icons/special.png", text = "Has a [color=" + Const.UI.Color.PositiveValue + "]100%[/color] lower chance to inflict friendly fire" }
			{ id = 17, type = "hint", icon = "ui/icons/special.png", text = "Unlocks the next row of perks" }
		];
	}

	function onAnySkillUsed(_skill, _targetEntity, _properties) {
		local actor = getContainer().getActor();

		if (_skill.isAttack() && _targetEntity != null && _targetEntity.getID() != getContainer().getActor().getID() && _targetEntity.getFaction() == getContainer().getActor().getFaction()) {
			_properties.MeleeSkillMult *= 0.0;
			_properties.RangedSkillMult *= 0.0;

			local dist = actor.getTile().getDistanceTo(_targetEntity.getTile());

			if (dist > m.DamageDistanceHigh)
				_properties.DamageTotalMult *= (1.0 + (m.DamagePercentHigh / 100.0));
			else if (dist > m.DamageDistanceLow)
				_properties.DamageTotalMult *= (1.0 + (m.DamagePercentLow / 100.0));
		}
	}
});
