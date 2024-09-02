way_of_the_gilder_effect <- inherit("scripts/skills/skill", {
	m = {
		Hitchance	= 100
	}

	function create() {
		m.ID					= "effects.way_of_the_gilder";
		m.Name					= "True Strike";
		m.Description			= "Shaped by training and meditation beyond the imaginations of most men, this character is intensely focused on their next strike and will see it carried out with unerring accuracy.";
		m.Icon					= "skills/status_effect_plus_43.png";
		m.IconMini				= "status_effect_plus_43_mini";
		m.Overlay				= "status_effect_plus_39";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 9;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= true;
		m.IsStacking			= false;
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/hitchance.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.Hitchance + "[/color] chance to hit until successfully landing a blow" }
		];

		return ret;
	}

	function onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor) {
		if (_targetEntity != null && isKindOf(_targetEntity, "actor")) {
			getContainer().getActor().setDirty(true);
			removeSelf();
		}
	}

	function onAnySkillUsed(_skill, _targetEntity, _properties) {
		if (_skill.isAttack()) {
			_properties.MeleeSkill		+= m.Hitchance;
			_properties.RangedSkill		+= m.Hitchance;			
		}
	}
});
