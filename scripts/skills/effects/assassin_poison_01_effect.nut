assassin_poison_01_effect <- inherit("scripts/skills/skill", {
	m = { }

	function create() {
		m.ID			= "effects.assassin_poison_01";
		m.Name			= "Holy Water";
		m.Description	= "This character's weapons are laced with a viscous liquid that has been blessed by priests. While benign to the living, it burns the undead with divine wrath.";
		m.Icon			= "skills/status_effect_plus_08.png";
		m.IconMini		= "";
		m.Type			= Const.SkillType.StatusEffect;
		m.Order			= Const.SkillOrder.VeryLast - 3;
		m.SoundOnUse	= [ "sounds/combat/poison_applied_01.wav", "sounds/combat/poison_applied_02.wav" ];
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "Every weapon attack that does at least [color=" + Const.UI.Color.NegativeValue + "]" + Const.Combat.PoisonEffectMinDamage + "[/color] damage to hitpoints coats the target in holy water, inflicting [color=" + Const.UI.Color.NegativeValue + "]10-15[/color] damage for 2 turns against any undead" }
			{ id = 12, type = "text", icon = "ui/icons/special.png", text = "Can stack multiple times on a single target" }
			{ id = 13, type = "hint", icon = "ui/icons/special.png", text = "Unlocks the next row of perks" }
		];

		return ret;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor ) {
		if (!_targetEntity.isAlive())
			return;

		if (_damageInflictedHitpoints < Const.Combat.PoisonEffectMinDamage || _targetEntity.getHitpoints() <= 0)
			return;

		if (!_targetEntity.getFlags().has("undead"))
			return;

		if (!_targetEntity.isHiddenToPlayer()) {
			if (m.SoundOnUse.len() != 0)
				Sound.play(m.SoundOnUse[Math.rand(0, m.SoundOnUse.len() - 1)], Const.Sound.Volume.RacialEffect * 1.5, _targetEntity.getPos());

			Tactical.EventLog.log(Const.UI.getColorizedEntityName(_targetEntity) + " has been sprayed with holy water");
		}

		spawnIcon("status_effect_plus_08", _targetEntity.getTile());
		local poison = _targetEntity.getSkills().getSkillByID("effects.assassin_poisoned_01");

		_targetEntity.getSkills().add(new("scripts/skills/effects/assassin_poisoned_01_effect"));
	}
});
