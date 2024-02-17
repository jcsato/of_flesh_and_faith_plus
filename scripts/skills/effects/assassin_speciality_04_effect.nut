assassin_speciality_04_effect <- inherit("scripts/skills/skill", {
	m = {
		DamagePercent	= 5
	}

	function create() {
		m.ID			= "effects.assassin_speciality_04";
		m.Name			= "Predator";
		m.Description	= "Hunt them down! This character knows how to take advantage of a distracted opponent and hit them where it hurts most.";
		m.Icon			= "skills/status_effect_plus_16.png";
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
			{ id = 15, type = "text", icon = "ui/icons/regular_damage.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.DamagePercent + "%[/color] damage for each other combatant engaged with the target" }
			{ id = 16, type = "text", icon = "ui/icons/hitchance.png", text = "Has an additional [color=" + Const.UI.Color.PositiveValue + "]+5%" + "[/color] chance to hit while covered by smoke" }
			{ id = 17, type = "hint", icon = "ui/icons/special.png", text = "Unlocks the next row of perks" }
		];
	}

	function onAnySkillUsed(_skill, _targetEntity, _properties) {
		if (_targetEntity == null || !_targetEntity.isAlive() || _targetEntity.isDying())
			return;

		local targetTile = _targetEntity.getTile();
		local numAdjacent = 0;

		for (local i = 0; i < 6; i = ++i) {
			if (!targetTile.hasNextTile(i))
				continue;

			local tile = targetTile.getNextTile(i);

			if (tile.IsOccupiedByActor && tile.getEntity().getMoraleState() != Const.MoraleState.Fleeing) {
				if (!tile.getEntity().isAlliedWith(_targetEntity) && tile.getEntity().getID() != getContainer().getActor().getID())
					numAdjacent = ++numAdjacent;
			}
		}

		_properties.DamageTotalMult	*= (1.0 + ((numAdjacent * m.DamagePercent) / 100.0));

		if (_skill.isAttack() && getContainer().hasSkill("effects.smoke")) {
			_properties.MeleeSkill		+= 5;
			_properties.RangedSkill		+= 5;
		}
	}
});
