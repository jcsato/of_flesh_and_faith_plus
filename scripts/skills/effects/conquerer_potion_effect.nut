conquerer_potion_effect <- inherit("scripts/skills/skill", {
	m = {
		ArmorDamageTaken	= 0
	}

	function create() {
		m.ID					= "effects.conquerer_potion";
		m.Name					= "Vengeful Strikes";
		m.Icon					= "skills/status_effect_plus_25.png";
		m.IconMini				= "status_effect_plus_25_mini";
		m.Overlay				= "status_effect_plus_25";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getDescription() {
		return "This character's body has taken in material found in the Black Monolith, and they are filled with a constant, albeit undirected, vengeful rage. This makes them almost unbearable to be around in camp, but their attitude and newfound mutations make them all the more capable in the battlefield.";
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/damage_dealt.png", text = "Every time this character takes armor damage, [color=" + Const.UI.Color.PositiveValue + "]50%[/color] of that damage is added to their next attack that hits" }
			{ id = 12, type = "text", icon = "ui/icons/special.png", text = "Resets upon landing a hit" }
			{ id = 12, type = "hint", icon = "ui/tooltips/warning.png", text = "Further mutations will cause a longer period of sickness" }
		];

		if (Math.floor(m.ArmorDamageTaken * 0.5) > 0)
			ret.push({ id = 13, type = "text", icon = "ui/icons/damage_dealt.png", text = "+[color=" + Const.UI.Color.PositiveValue + "]" + Math.floor(m.ArmorDamageTaken * 0.5) + "[/color] damage on the next hit" });

		return ret;
	}

	function onCombatStarted() {
		m.ArmorDamageTaken = 0;
	}

	function onCombatFinished() {
		m.ArmorDamageTaken = 0;
	}

	function onDamageReceived(_attacker, _damageHitpoints, _damageArmor) {
		m.ArmorDamageTaken += _damageArmor;
	}

	function onAnySkillUsed(_skill, _targetEntity, _properties) {
		if (_targetEntity == null)
			return;

		if (_skill.isAttack() && m.ArmorDamageTaken > 0) {
			_properties.DamageRegularMin	+= Math.floor(m.ArmorDamageTaken * 0.5);
			_properties.DamageRegularMax	+= Math.floor(m.ArmorDamageTaken * 0.5);
		}
	}

	function onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor) {
		m.ArmorDamageTaken = 0;
	}

	function onDeath(_fatalityType) {
		if(_fatalityType != Const.FatalityType.Unconscious)
			World.Statistics.getFlags().set("isConquererPotionAcquired", false);
	}

	function onDismiss() {
		World.Statistics.getFlags().set("isConquererPotionAcquired", false);
	}
});
