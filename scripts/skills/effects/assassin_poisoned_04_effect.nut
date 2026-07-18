assassin_poisoned_04_effect <- inherit("scripts/skills/skill", {
	m = {
		DamageMultPenalty		= 0.20
		VisionPenalty			= 5
		LastRoundApplied		= 0
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
		return "This character is afflicted by a vicious poison that clouds his vision and senses, and deals [color=" + Const.UI.Color.NegativeValue + "]" + (m.DamageMultPenalty * 100) + "%[/color] less damage for the rest of the battle.";
	}

	function onUpdate(_properties) {
		_properties.DamageTotalMult	*= (1.0 - m.DamageMultPenalty);
	}
});
