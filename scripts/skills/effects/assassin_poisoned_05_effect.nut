assassin_poisoned_05_effect <- inherit("scripts/skills/skill",
{
	m =
	{
		ActionPointPenalty		= 2
		Count					= 1
		LastRoundApplied		= 0
		TurnsLeft				= 1
	}

	function create()
	{
		m.ID					= "effects.assassin_poisoned_05";
		m.Name					= "Violet Paralytic";
		m.Icon					= "skills/status_effect_plus_22.png";
		m.IconMini				= "status_effect_plus_22_mini";
		m.SoundOnUse			= [ "sounds/combat/poison_applied_01.wav", "sounds/combat/poison_applied_02.wav" ];
		m.Type					= Const.SkillType.StatusEffect;
		m.IsActive				= true;
		m.IsStacking			= false;
		m.IsRemovedAfterBattle	= true;
	}

	function getName()
	{
		if (m.Count <= 1)
			return m.Name;
		else
			return m.Name + " (x" + m.Count + ")";
	}

	function getDescription() {
		return "This character has a vicious poison running through his veins that paralyzes and numbs his nerves. [color=" + Const.UI.Color.NegativeValue + "]-" + (m.ActionPointPenalty * m.Count) + "[/color] Action Points for [color=" + Const.UI.Color.NegativeValue + "]" + m.TurnsLeft + "[/color] more turn(s).";
	}

	function addStack() {
		m.Count++;
	}

	function onAdded() {
		m.TurnsLeft = 1;

		if(getContainer().hasSkill("trait.ailing"))
			++m.TurnsLeft;
	}

	function onTurnEnd() {
		if(--m.TurnsLeft <= 0)
			removeSelf();
	}

	function onUpdate(_properties) {
		_properties.ActionPoints	-= (m.ActionPointPenalty * m.Count);
	}
})