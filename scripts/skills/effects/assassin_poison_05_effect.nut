assassin_poison_05_effect <- inherit("scripts/skills/skill", {
	m = { }

	function create() {
		m.ID			= "effects.assassin_poison_05";
		m.Name			= "Violet Paralytic";
		m.Description	= "An exotic substance glistens on this character's weapons. Anyone unlucky enough to be wounded by them will find their muscles freeze and their whole body begin to seize up.";
		m.Icon			= "skills/status_effect_plus_12.png";
		m.IconMini		= "";
		m.Type			= Const.SkillType.StatusEffect | Const.SkillType.Perk;
		m.Order			= Const.SkillOrder.VeryLast - 3;
		m.SoundOnUse	= [ "sounds/combat/poison_applied_01.wav", "sounds/combat/poison_applied_02.wav" ];
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/action_points.png", text = "Every weapon attack that does at least [color=" + Const.UI.Color.NegativeValue + "]" + Const.Combat.PoisonEffectMinDamage + "[/color] damage to hitpoints applies a poison that reduces the target's Action Points by [color=" + Const.UI.Color.NegativeValue + "]2[/color] for 1 turn" }
			{ id = 12, type = "text", icon = "ui/icons/special.png", text = "Can stack multiple times on a single target" }
			{ id = 13, type = "hint", icon = "ui/icons/special.png", text = "Unlocks the next row of perks" }
		];

		return ret;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor ) {
		if (!_targetEntity.isAlive())
			return;

		if (_targetEntity.getCurrentProperties().IsImmuneToPoison || _damageInflictedHitpoints < Const.Combat.PoisonEffectMinDamage || _targetEntity.getHitpoints() <= 0)
			return;

		if (_targetEntity.getFlags().has("undead"))
			return;

		if (!_targetEntity.isHiddenToPlayer()) {
			if (m.SoundOnUse.len() != 0)
				Sound.play(m.SoundOnUse[Math.rand(0, m.SoundOnUse.len() - 1)], Const.Sound.Volume.RacialEffect * 1.5, _targetEntity.getPos());

			Tactical.EventLog.log(Const.UI.getColorizedEntityName(_targetEntity) + " is poisoned");
		}

		spawnIcon("status_effect_plus_12", _targetEntity.getTile());
		local poison = _targetEntity.getSkills().getSkillByID("effects.assassin_poisoned_05");

		if (poison == null)
			_targetEntity.getSkills().add(new("scripts/skills/effects/assassin_poisoned_05_effect"));
		else
			poison.addStack();
	}
});
