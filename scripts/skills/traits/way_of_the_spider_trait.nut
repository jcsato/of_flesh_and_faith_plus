way_of_the_spider_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
		DamageBoost			= 5
		LastEnemyAppliedTo	= 0
		LastFrameApplied	= 0
		SkillCount			= 0
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.way_of_the_spider";
		m.Name			= "Way of the Spider";
		m.Icon			= "ui/traits/trait_icon_plus_10.png";
		m.SoundOnUse	= [ "sounds/combat/poison_applied_01.wav", "sounds/combat/poison_applied_02.wav" ];
		m.Description	= "Let the wound fester, let the poison run its course. The Way of the Spider appears cruel at first, but at its heart is pragmatism. Assassination is inherently asymmetrical - it would be foolish to not leverage one's unique strengths in such a contest.";

		m.Excluded = [];
	}

	function getDescription()
	{
		return "";
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 14, type = "text", icon = "ui/icons/special.png", text = "Any attacks that inflict a poison status inflict an additional stacking [color=" + Const.UI.Color.DamageValue + "]" + m.DamageBoost + "[/color] damage at the end of the target's turn" }
		];

		return ret;
	}

	function onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor)
	{
		if (_targetEntity.getCurrentProperties().IsImmuneToPoison || _damageInflictedHitpoints < Const.Combat.PoisonEffectMinDamage || _targetEntity.getHitpoints() <= 0)
			return;

		if (!_targetEntity.isAlive())
			return;

		if (_targetEntity.getFlags().has("undead"))
			return;

		if (!(_targetEntity.getSkills().hasSkill("effects.assassin_poisoned_01_effect")
				|| _targetEntity.getSkills().hasSkill("effects.assassin_poisoned_02_effect")
				|| _targetEntity.getSkills().hasSkill("effects.assassin_poisoned_03_effect")
				|| _targetEntity.getSkills().hasSkill("effects.assassin_poisoned_04_effect")
				|| _targetEntity.getSkills().hasSkill("effects.assassin_poisoned_05_effect")
				|| _targetEntity.getSkills().hasSkill("effects.spider_poison")
				|| _targetEntity.getSkills().hasSkill("effects.goblin_poison")
			))
			return;

		if ((Time.getFrame() == m.LastFrameApplied || m.SkillCount == Const.SkillCounter) && _targetEntity.getID() == m.LastEnemyAppliedTo)
			return;

		if (!_targetEntity.isHiddenToPlayer() && m.SoundOnUse.len() != 0)
			Sound.play(m.SoundOnUse[Math.rand(0, m.SoundOnUse.len() - 1)], Const.Sound.Volume.RacialEffect * 1.5, _targetEntity.getPos());

		spawnIcon("status_effect_plus_23", _targetEntity.getTile());

		m.LastFrameApplied = Time.getFrame();
		m.LastEnemyAppliedTo = _targetEntity.getID();
		m.SkillCount = Const.SkillCounter;

		_targetEntity.getSkills().add(new("scripts/skills/effects/assassin_spider_poison_effect"));
	}

	function onCombatStarted()
	{
		m.SkillCount = 0;
		m.LastEnemyAppliedTo = 0;
		m.LastFrameApplied = 0;
	}

	function onCombatFinished()
	{
		skill.onCombatFinished();
		m.SkillCount = 0;
		m.LastEnemyAppliedTo = 0;
		m.LastFrameApplied = 0;
	}
})