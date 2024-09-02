rune_05_effect <- inherit("scripts/skills/skill", {
	m = {
		BraveryBuff		= 4
		InitiativeBuff	= 6
		Stacks			= 0
	}

	function create() {
		m.ID					= "effects.rune_05";
		m.Name					= "Death's Door Rune";
		m.Icon					= "skills/status_effect_plus_05.png";
		m.IconMini				= "status_effect_plus_05_mini";
		m.Overlay				= "status_effect_plus_05";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Trait - 6;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getDescription() {
		return "\"Only in thine twilight will thee see and know the true path.\"";
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/regular_damage.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+15%[/color] damage if hitpoints are below [color=" + Const.UI.Color.NegativeValue + "]75%[/color]" }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "This character gains [color=" + Const.UI.Color.PositiveValue + "]+" + m.BraveryBuff + "[/color] Resolve and [color=" + Const.UI.Color.PositiveValue + "]+" + m.InitiativeBuff + "[/color] Initiative each time they take hitpoint damage, resetting at the end of combat" }
		];

		if (m.Stacks > 0) {
			local resolveBuff		= m.Stacks * m.BraveryBuff;
			local initiativeBuff	= m.Stacks * m.InitiativeBuff;
			ret.push({ id = 12, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + resolveBuff + "[/color] Resolve" });
			ret.push({ id = 13, type = "text", icon = "ui/icons/initiative.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + initiativeBuff + "[/color] Initiative" });
		}

		return ret;
	}

	function onCombatStarted() {
		m.Stacks = 0;
	}

	function onCombatFinished() {
		m.Stacks = 0;
	}

	function onDamageReceived(_attacker, _damageHitpoints, _damageArmor) {
		if (_damageHitpoints > 0) {
			spawnIcon("status_effect_plus_05", getContainer().getActor().getTile());
			m.Stacks++;
		}
	}

	function onUpdate(_properties) {
		local actor = getContainer().getActor();

		if (actor.getHitpoints() < (actor.getHitpointsMax() / 4) * 3)
			_properties.DamageTotalMult *= 1.15;

		_properties.Bravery				+= m.Stacks * m.BraveryBuff;
		_properties.Initiative			+= m.Stacks * m.InitiativeBuff;
	}
});
