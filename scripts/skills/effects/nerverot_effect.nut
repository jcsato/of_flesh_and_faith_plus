nerverot_effect <- inherit("scripts/skills/skill", {
	m = {
		AttacksLeft	= 2
		Magnitude	= 1
		ToHitMalus	= 8
	}

	function create() {
		m.ID					= "effects.nerverot";
		m.Name					= "Nerverot";
		m.Description			= "The Rot has spread to this character's nerves. Jolts of pain shoot through their limbs at random, making it difficult to react with speed and surety.";
		m.Icon					= "skills/status_effect_plus_42.png";
		m.IconMini				= "status_effect_plus_42_mini";
		m.Type					= Const.SkillType.StatusEffect;
		m.IsActive				= false;
		m.IsStacking			= false;
		m.IsRemovedAfterBattle	= true;
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/hitchance.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.ToHitMalus * m.Magnitude + "%[/color] Chance to Hit for the next " + m.AttacksLeft + " attack(s)" }
		];

		return ret;
	}

	function setMagnitude(_magnitude) {
		m.Magnitude = _magnitude
	}

	function onAnySkillUsed(_skill, _targetEntity, _properties) {
		if (_skill.isAttack()) {
			_properties.MeleeSkill		-= m.ToHitMalus * m.Magnitude;
			_properties.RangedSkill		-= m.ToHitMalus * m.Magnitude;
		}
	}

	function onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor) {
		m.AttacksLeft--;

		if (m.AttacksLeft <= 0)
			removeSelf();
	}

	function onTargetMissed(_skill, _targetEntity) {
		m.AttacksLeft--;

		if (m.AttacksLeft <= 0)
			removeSelf();
	}

	function onRefresh() {
		m.AttacksLeft = 2;
		spawnIcon("status_effect_plus_42", getContainer().getActor().getTile());
	}
});
