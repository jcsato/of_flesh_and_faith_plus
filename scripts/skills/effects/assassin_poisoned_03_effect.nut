assassin_poisoned_03_effect <- inherit("scripts/skills/skill",
{
	m =
	{
		FatigueRecoveryPenalty	= 15
		LastRoundApplied		= 0
		TurnsLeft				= 2
	}

	function create()
	{
		m.ID					= "effects.assassin_poisoned_03";
		m.Name					= "Mudblood Venom";
		m.Icon					= "skills/status_effect_plus_20.png";
		m.IconMini				= "status_effect_plus_20_mini";
		m.SoundOnUse			= [ "sounds/combat/poison_applied_01.wav", "sounds/combat/poison_applied_02.wav" ];
		m.Type					= Const.SkillType.StatusEffect;
		m.IsActive				= false;
		m.IsStacking			= false;
		m.IsRemovedAfterBattle	= true;
	}

	function getDescription()
	{
		return "This character has a vicious poison running through his veins that tightens the lungs and quells the fires of battle. [color=" + Const.UI.Color.NegativeValue + "]" + "-" + m.FatigueRecoveryPenalty + "[/color] Fatigue recovered per turn for [color=" + Const.UI.Color.NegativeValue + "]" + m.TurnsLeft + "[/color] more turn(s).";
	}

	function resetTime()
	{
		m.TurnsLeft = 2;

		if(getContainer().hasSkill("trait.ailing"))
			++m.TurnsLeft;
	}

	function onAdded()
	{
		m.TurnsLeft = 2;

		if(getContainer().hasSkill("trait.ailing"))
			++m.TurnsLeft;
	}

	function onTurnEnd()
	{
		if(--m.TurnsLeft <= 0)
			removeSelf();
	}

	function onUpdate(_properties)
	{
		_properties.FatigueRecoveryRate -= m.FatigueRecoveryPenalty;
	}
})