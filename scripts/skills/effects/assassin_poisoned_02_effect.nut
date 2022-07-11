assassin_poisoned_02_effect <- inherit("scripts/skills/skill",
{
	m =
	{
		ResolvePenalty		= 5
		LastRoundApplied	= 0
		TurnsLeft			= 2
	}

	function create()
	{
		m.ID					= "effects.assassin_poisoned_02";
		m.Name					= "Lion Leech Poison";
		m.Icon					= "skills/status_effect_plus_19.png";
		m.IconMini				= "status_effect_plus_19_mini";
		m.SoundOnUse			= [ "sounds/combat/poison_applied_01.wav", "sounds/combat/poison_applied_02.wav" ];
		m.Type					= Const.SkillType.StatusEffect;
		m.IsActive				= false;
		m.IsStacking			= true;
		m.IsRemovedAfterBattle	= true;
	}

	function getDescription() {
		return "This character has a vicious poison running through his veins that drains the will to fight. [color=" + Const.UI.Color.NegativeValue + "]" + "-" + m.ResolvePenalty + "[/color] Resolve for [color=" + Const.UI.Color.NegativeValue + "]" + m.TurnsLeft + "[/color] more turn(s).";
	}

	function onAdded() {
		m.TurnsLeft = 2;

		if (getContainer().hasSkill("trait.ailing"))
			++m.TurnsLeft;
	}

	function onTurnEnd() {
		if (--m.TurnsLeft <= 0)
			removeSelf();
	}

	function onUpdate(_properties) {
		_properties.Bravery -= m.ResolvePenalty;
	}
})
