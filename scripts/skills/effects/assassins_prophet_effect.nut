assassins_prophet_effect <- inherit("scripts/skills/skill", {
	m = { }

	function create() {
		m.ID					= "effects.assassins_prophet";
		m.Name					= "The Prophet";
		m.Icon					= "skills/status_effect_plus_24.png";
		m.IconMini				= "status_effect_plus_24_mini";
		m.Overlay				= "status_effect_plus_24";
		m.Type					= Const.SkillType.StatusEffect;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function onUpdate(_properties) {
		_properties.IsAffectedByDyingAllies		= false;
		_properties.IsAffectedByLosingHitpoints = false;
		_properties.IsAffectedByFreshInjuries	= false;

		_properties.DamageTotalMult		*= 1.15;
		_properties.BraveryMult			*= 1.5;
		_properties.StaminaMult			*= 1.5;
		_properties.MeleeSkillMult		*= 1.25;
		_properties.MeleeDefenseMult	*= 1.25;
		_properties.RangedDefenseMult	*= 1.25;
		_properties.InitiativeMult		*= 1.25;
		_properties.HitpointsMult		*= 1.5;
	}
});
