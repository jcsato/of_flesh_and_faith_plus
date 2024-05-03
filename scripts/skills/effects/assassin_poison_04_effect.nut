assassin_poison_04_effect <- inherit("scripts/skills/skill", {
	m = { }

	function create() {
		m.ID			= "effects.assassin_poison_04";
		m.Name			= "Gilder's Gaze";
		m.Description	= "This character's weapons are coated in a poison that clouds vision and numbs the limbs. Sometimes used by unscrupulous priests to induce the fear of the Gilder into the uninitiatied.";
		m.Icon			= "skills/status_effect_plus_11.png";
		m.IconMini		= "";
		m.Type			= Const.SkillType.StatusEffect;
		m.Order			= Const.SkillOrder.VeryLast - 3;
		m.SoundOnUse	= [ "sounds/combat/poison_applied_01.wav", "sounds/combat/poison_applied_02.wav" ];
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "Every weapon attack that does at least [color=" + Const.UI.Color.NegativeValue + "]" + Const.Combat.PoisonEffectMinDamage + "[/color] damage to hitpoints applies a poison that reduces the target's Vision by [color=" + Const.UI.Color.NegativeValue + "]5[/color] and Melee and Ranged Skill by [color=" + Const.UI.Color.NegativeValue + "]10%[/color] for 2 turns" }
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

		spawnIcon("status_effect_plus_11", _targetEntity.getTile());
		local poison = _targetEntity.getSkills().getSkillByID("effects.assassin_poisoned_04");

		if (poison == null)
			_targetEntity.getSkills().add(new("scripts/skills/effects/assassin_poisoned_04_effect"));
		else
			poison.resetTime();
	}
});
