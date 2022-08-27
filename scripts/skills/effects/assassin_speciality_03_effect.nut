assassin_speciality_03_effect <- inherit("scripts/skills/skill", {
	m =
	{
		AttackBoost	= 10
	}

	function create() {
		m.ID			= "effects.assassin_speciality_03";
		m.Name			= "Torturer";
		m.Description	= "Hit them while they're down! This character can recognize and exploit blind spots and vulnerabilities, and knows how to strike for maximum effect.";
		m.Icon			= "skills/status_effect_plus_15.png";
		m.IconMini		= "";
		m.Type			= Const.SkillType.StatusEffect;
		m.Order			= Const.SkillOrder.VeryLast - 2;
		m.IsActive		= false;
		m.IsStacking	= false;
	}

	function getTooltip() {
		return [
					{ id = 1, type = "title", text = getName() }
					{ id = 2, type = "description", text = getDescription() }
					{ id = 15, type = "text", icon = "ui/icons/special.png", text = "The threshold to inflict injuries is lowered by [color=" + Const.UI.Color.NegativeValue + "]25%[/color] against targets who are injured or under the effects of poison" }
					{ id = 16, type = "text", icon = "ui/icons/hitchance.png", text = "Has an additional [color=" + Const.UI.Color.PositiveValue + "]+" + m.AttackBoost + "%[/color] chance to hit targets who are injured or under the effects of poison" }
					{ id = 17, type = "hint", icon = "ui/icons/special.png", text = "Unlocks the next row of perks" }
				];
	}

	function onAnySkillUsed(_skill, _targetEntity, _properties) {
		if(!_skill.isAttack() || _targetEntity == null || !_targetEntity.isAlive() || _targetEntity.isDying())
			return;

		local skills = _targetEntity.getSkills();
		if (skills.hasSkillOfType(Const.SkillType.TemporaryInjury) ||
			skills.hasSkill("effects.goblin_poison") ||
			skills.hasSkill("effects.spider_poison") ||
			skills.hasSkill("effects.lindwurm_acid") ||
			skills.hasSkill("effects.acid") ||
			skills.hasSkill("effects.assassin_poison_01") ||
			skills.hasSkill("effects.assassin_poison_02") ||
			skills.hasSkill("effects.assassin_poison_03") ||
			skills.hasSkill("effects.assassin_poison_04") ||
			skills.hasSkill("effects.assassin_poison_05") ||
			skills.hasSkill("effects.assassin_spider_poison"))
		{
			_properties.ThresholdToInflictInjuryMult	*= 0.75;
			_properties.MeleeSkill						+= m.AttackBoost;
			_properties.RangedSkill						+= m.AttackBoost;
		}
	}
})
