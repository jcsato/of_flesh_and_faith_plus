way_of_the_owl_effect <- inherit("scripts/skills/skill", {
	m = {
		ArmorPenetrationBonusPercent	= 15
		AttackThresholdPercent			= 85
		DamageReductionPercent			= 25
		DefenseThresholdPercent			= 75
	}

	function create() {
		m.ID			= "effects.way_of_the_owl";
		m.Name			= "Way of the Owl";
		m.Description	= "To follow the Way of the Owl is to act with certainty. It is not a question of if a blow shall be struck, but how. The outcomes are clear to those with eyes to see.";

		m.Icon			= "skills/status_effect_plus_52.png";
		m.Type			= Const.SkillType.StatusEffect | Const.SkillType.Perk;
		m.Order			= Const.SkillOrder.Any - 1;

		m.IsActive		= false;
		m.IsStacking	= false;
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/direct_damage.png", text = "An additional [color=" + Const.UI.Color.PositiveValue + "]+" + m.ArmorPenetrationBonusPercent + "%[/color] of damage ignores armor when making attacks with [color=" + Const.UI.Color.PositiveValue + "]" + m.AttackThresholdPercent + "%[/color] or greater chance to hit" }
			{ id = 11, type = "text", icon = "ui/icons/direct_damage.png", text = "Receives only [color=" + Const.UI.Color.NegativeValue + "]" + (100 - m.DamageReductionPercent) + "%[/color] of damage from attacks made with [color=" + Const.UI.Color.NegativeValue + "]" + m.DefenseThresholdPercent + "%[/color] or greater chance to hit" }
			{ id = 12, type = "text", icon = "ui/icons/vision.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+1[/color] Vision" }
		];

		if (!getContainer().getActor().getFlags().get(::OFFP.Assassins.Flags.HasUsedRespec))
			ret.push({ id = 15, type = "text", icon = "ui/icons/special.png", text = "Can retrain to a different assassin specialty once" });

		return ret;
	}

	function onBeforeTargetHit(_skill, _targetEntity, _hitInfo) {
		local actor = getContainer().getActor();

		if (!actor.isPlacedOnMap())
			return;

		if (_targetEntity == null || !_targetEntity.isAlive() || _targetEntity.isDying() || _targetEntity.isAlliedWith(actor))
			return;

		local toHit = getToHitChance(actor, _targetEntity, _skill);

		if (toHit >= m.AttackThresholdPercent)
			_hitInfo.DamageDirect += (m.ArmorPenetrationBonusPercent / 100.0);
	}

	function onBeforeDamageReceived(_attacker, _skill, _hitInfo, _properties) {
		local toHit = getToHitChance(_attacker, getContainer().getActor(), _skill);

		if (toHit >= m.DefenseThresholdPercent)
			_properties.DamageReceivedTotalMult *= (1.0 - (m.DamageReductionPercent / 100.0));
	}

	function onUpdate(_properties) {
		_properties.Vision += 1;
	}

	// sadness
	function getToHitChance(_attacker, _defender, _skill) {
		local properties = _attacker.getSkills().buildPropertiesForUse(_skill, _defender);
		local defenderProperties = _defender.getSkills().buildPropertiesForDefense(_attacker, _skill);
		local levelDifference = _defender.getTile().Level - _attacker.getTile().Level;
		local defense = _defender.getDefense(_attacker, _skill, defenderProperties);
		local toHit = 0;

		local attackSkill = _skill.isRanged() ? properties.RangedSkill * properties.RangedSkillMult : properties.MeleeSkill * properties.MeleeSkillMult;
		toHit += attackSkill;
		toHit -= defense;

		if (levelDifference < 0)
			toHit += Const.Combat.LevelDifferenceToHitBonus;
		else
			toHit += Const.Combat.LevelDifferenceToHitMalus * levelDifference;

		local shieldBonus = 0;
		local shield = _defender.getItems().getItemAtSlot(Const.ItemSlot.Offhand);
		if (shield != null && shield.isItemType(Const.Items.ItemType.Shield)) {
			shieldBonus = (_skill.isRanged() ? shield.getRangedDefense() : shield.getMeleeDefense()) * (_defender.getCurrentProperties().IsSpecializedInShields ? 1.25 : 1.0);

			// shieldwall relevant?
			if(_defender.getSkills().hasSkill("effects.shieldwall"))
				shieldBonus *= 2;
		}

		toHit *= properties.TotalAttackToHitMult;
		toHit += Math.max(0, 100 - toHit) * (1.0 - defenderProperties.TotalDefenseToHitMult);

		// don't bother checking for e.g. shots going astray, this is good enough
		return toHit;
	}
});
