assassin_poison_03_effect <- inherit("scripts/skills/skill", {
	m = {
		FatigueDamageOnHit		= 10
	}

	function create() {
		m.ID			= "effects.assassin_poison_03";
		m.Name			= "Mudblood Venom";
		m.Description	= "This character has coated their weapons with a venom that saps energy from victims and leaves them struggling to breathe.";
		m.Icon			= "skills/status_effect_plus_10.png";
		m.IconMini		= "";
		m.Type			= Const.SkillType.StatusEffect | Const.SkillType.Perk;
		m.Order			= Const.SkillOrder.Any - 3;
		m.SoundOnUse	= [ "sounds/combat/poison_applied_01.wav", "sounds/combat/poison_applied_02.wav" ];
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/fatigue.png", text = "Every weapon attack that does at least [color=" + Const.UI.Color.NegativeValue + "]" + Const.Combat.PoisonEffectMinDamage + "[/color] damage to hitpoints applies a poison that inflicts [color=" + Const.UI.Color.NegativeValue + "]" + m.FatigueDamageOnHit + "[/color] extra Fatigue" }
			{ id = 12, type = "text", icon = "ui/icons/fatigue.png", text = "Every weapon attack that does at least [color=" + Const.UI.Color.NegativeValue + "]" + Const.Combat.PoisonEffectMinDamage + "[/color] damage to hitpoints applies a poison that reduces the target's Fatigue Recovery per turn by [color=" + Const.UI.Color.NegativeValue + "]-15[/color] for 2 turns" }
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

		spawnIcon("status_effect_plus_10", _targetEntity.getTile());
		local poison = _targetEntity.getSkills().getSkillByID("effects.assassin_poisoned_03");

		_targetEntity.setFatigue(_targetEntity.getFatigue() + m.FatigueDamageOnHit)

		if (poison == null)
			_targetEntity.getSkills().add(new("scripts/skills/effects/assassin_poisoned_03_effect"));
		else
			poison.resetTime();
	}
});
