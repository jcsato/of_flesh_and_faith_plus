way_of_the_spider_trait <- inherit("scripts/skills/traits/character_trait", {
	m =
	{
		DamageBoost			= 5
		LastEnemyAppliedTo	= 0
		LastFrameApplied	= 0
		SkillCount			= 0
	}

	function create() {
		character_trait.create();

		m.ID			= "trait.way_of_the_spider";
		m.Name			= "Way of the Spider";
		m.Icon			= "ui/traits/trait_icon_plus_10.png";
		m.SoundOnUse	= [ "sounds/combat/poison_applied_01.wav", "sounds/combat/poison_applied_02.wav" ];
		m.Description	= "Let the wound fester, let the poison run its course. The Way of the Spider appears cruel at first, but at its heart is pragmatism. Assassination is inherently asymmetrical - it would be foolish to not leverage one's unique strengths in such a contest.";

		m.Excluded = [];
	}

	function getDescription() {
		return "";
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 14, type = "text", icon = "ui/icons/regular_damage.png", text = "[color=" + Const.UI.Color.DamageValue + "]+" + m.DamageBoost + "[/color] additional damage for each active poison effect on the target" }
		];

		return ret;
	}

	function onBeforeTargetHit(_skill, _targetEntity, _hitInfo) {
		if (!_skill.isAttack() || _targetEntity == null || !_targetEntity.isAlive())
			return;

		if (!(_targetEntity.getSkills().hasSkill("effects.assassin_poisoned_01")
				|| _targetEntity.getSkills().hasSkill("effects.assassin_poisoned_02")
				|| _targetEntity.getSkills().hasSkill("effects.assassin_poisoned_03")
				|| _targetEntity.getSkills().hasSkill("effects.assassin_poisoned_04")
				|| _targetEntity.getSkills().hasSkill("effects.assassin_poisoned_05")
				|| _targetEntity.getSkills().hasSkill("effects.lindwurm_acid")
				|| _targetEntity.getSkills().hasSkill("effects.acid")
				|| _targetEntity.getSkills().hasSkill("effects.spider_poison")
				|| _targetEntity.getSkills().hasSkill("effects.goblin_poison")
			))
			return;

		spawnIcon("trait_icon_plus_10", _targetEntity.getTile());
	}

	function onAnySkillUsed(_skill, _targetEntity, _properties) {
		if (_targetEntity == null)
			return;

		local numPoisons = 0;
		numPoisons += _targetEntity.getSkills().getNumOfSkill("effects.assassin_poisoned_01");
		numPoisons += _targetEntity.getSkills().getNumOfSkill("effects.assassin_poisoned_02");
		numPoisons += _targetEntity.getSkills().getNumOfSkill("effects.assassin_poisoned_03");
		numPoisons += _targetEntity.getSkills().getNumOfSkill("effects.assassin_poisoned_04");
		numPoisons += _targetEntity.getSkills().getNumOfSkill("effects.assassin_poisoned_05");
		numPoisons += _targetEntity.getSkills().getNumOfSkill("effects.lindwurm_acid");
		numPoisons += _targetEntity.getSkills().getNumOfSkill("effects.acid");
		numPoisons += _targetEntity.getSkills().getNumOfSkill("effects.spider_poison");
		numPoisons += _targetEntity.getSkills().getNumOfSkill("effects.goblin_poison");

		if (_skill.isAttack() && numPoisons > 0) {
			_properties.DamageRegularMin += numPoisons * m.DamageBoost;
			_properties.DamageRegularMax += numPoisons * m.DamageBoost;
		}
	}

	function onCombatStarted() {
		m.SkillCount = 0;
		m.LastEnemyAppliedTo = 0;
		m.LastFrameApplied = 0;
	}

	function onCombatFinished() {
		skill.onCombatFinished();
		m.SkillCount = 0;
		m.LastEnemyAppliedTo = 0;
		m.LastFrameApplied = 0;
	}
})