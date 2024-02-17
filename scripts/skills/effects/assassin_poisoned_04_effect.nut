assassin_poisoned_04_effect <- inherit("scripts/skills/skill", {
	m = {
		SkillMultPenalty		= 0.10
		VisionPenalty			= 5
		LastRoundApplied		= 0
		TurnsLeft				= 2
	}

	function create() {
		m.ID					= "effects.assassin_poisoned_04";
		m.Name					= "Gilder's Gaze Poison";
		m.Icon					= "skills/status_effect_plus_21.png";
		m.IconMini				= "status_effect_plus_21_mini";
		m.SoundOnUse			= [ "sounds/combat/poison_applied_01.wav", "sounds/combat/poison_applied_02.wav" ];
		m.Type					= Const.SkillType.StatusEffect;
		m.IsActive				= false;
		m.IsStacking			= false;
		m.IsRemovedAfterBattle	= true;
	}

	function getDescription() {
		return "This character is afflicted by a vicious poison that clouds his vision and senses. [color=" + Const.UI.Color.NegativeValue + "]-" + m.VisionPenalty + "[/color] Vision and [color=" + Const.UI.Color.NegativeValue + "]-" + (m.SkillMultPenalty * 100) + "%[/color] Melee and Ranged Skill for [color=" + Const.UI.Color.NegativeValue + "]" + m.TurnsLeft + "[/color] more turn(s).";
	}

	function resetTime() {
		m.TurnsLeft = 2;

		if (getContainer().hasSkill("trait.ailing"))
			++m.TurnsLeft;
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
		_properties.Vision			-= m.VisionPenalty;
		_properties.MeleeSkillMult	*= (1.0 - m.SkillMultPenalty);
		_properties.RangedSkillMult	*= (1.0 - m.SkillMultPenalty);
	}
});
