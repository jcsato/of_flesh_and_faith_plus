runeblade_skill <- inherit("scripts/skills/skill", {
	m = { }

	function create() {
		m.ID = "items.runeblade_skill";
		m.Type = Const.SkillType.Item;
		m.Order = Const.SkillOrder.Item;
		m.IsActive = false;
		m.IsHidden = true;
		m.IsStacking = false;
		m.IsSerialized = false;
		m.IsRemovedAfterBattle = false;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties ) {
		if (_targetEntity == null)
			return;

		local isNemesis = _targetEntity.m.IsMiniboss || _targetEntity.getSkills().hasSkill("perk.captain");
		if (_skill.isAttack() && isNemesis)
			_properties.DamageTotalMult *= 1.2;
	}
});
