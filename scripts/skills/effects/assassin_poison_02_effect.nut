assassin_poison_02_effect <- inherit("scripts/skills/skill",
{
	m =
	{
	}

	function create()
	{
		m.ID			= "effects.assassin_poison_02";
		m.Name			= "Lion Leech Poison";
		m.Description	= "This character's weapons are coated in a hallucinogenic poison that distorts the victim's perception and induces terrifying visions. One of the more cruel tools in the assassin's kit.";
		m.Icon			= "skills/status_effect_plus_09.png";
		m.IconMini		= "";
		m.Type			= Const.SkillType.StatusEffect;
		m.Order			= Const.SkillOrder.VeryLast - 3;
		m.SoundOnUse	= [ "sounds/combat/poison_applied_01.wav", "sounds/combat/poison_applied_02.wav" ];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/fatigue.png", text = "Every weapon attack that does at least [color=" + Const.UI.Color.NegativeValue + "]" + Const.Combat.PoisonEffectMinDamage + "[/color] damage to hitpoints applies a poison that reduces the target's Resolve by [color=" + Const.UI.Color.NegativeValue + "]5[/color] for 2 turns" }
			{ id = 12, type = "text", icon = "ui/icons/special.png", text = "Can stack multiple times on a single target" }
			{ id = 13, type = "hint", icon = "ui/icons/special.png", text = "Unlocks the next row of perks" }
		];

		return ret;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_targetEntity.getCurrentProperties().IsImmuneToPoison || _damageInflictedHitpoints < Const.Combat.PoisonEffectMinDamage || _targetEntity.getHitpoints() <= 0)
			return;

		if (!_targetEntity.isAlive())
			return;

		if (_targetEntity.getFlags().has("undead"))
			return;

		if (!_targetEntity.isHiddenToPlayer())
		{
			if (m.SoundOnUse.len() != 0)
				Sound.play(m.SoundOnUse[Math.rand(0, m.SoundOnUse.len() - 1)], Const.Sound.Volume.RacialEffect * 1.5, _targetEntity.getPos());

			Tactical.EventLog.log(Const.UI.getColorizedEntityName(_targetEntity) + " is poisoned");
		}

		spawnIcon("status_effect_plus_09", _targetEntity.getTile());

		_targetEntity.getSkills().add(new("scripts/skills/effects/assassin_poisoned_02_effect"));
	}
});

