oath_of_endurance_completed_effect <- inherit("scripts/skills/skill", {
	m = {
		FatigueBonus	= 12
	}

	function create() {
		m.ID					= "effects.oath_of_endurance_completed";
		m.Name					= "Oath of Endurance";
		m.Description			= "\"And at the summit of the Higgarian peak, they found conquered both the mountain and their own fleshen vessels. Afterwards no trial of athleticism held the same daunt, no exhaustion the same hhold.\"";
		m.Icon					= "skills/status_effect_plus_29.png";
		m.IconMini				= "";
		m.Overlay				= "status_effect_plus_29";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 9;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/fatigue.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.FatigueBonus + "[/color] Fatigue" }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "The Recover skill now reduces current Fatigue by [color=" + Const.UI.Color.PositiveValue + "]" + ::OFFP.Oathtakers.Boons.EnduranceRecovery + "%[/color]" }
		];

		return ret;
	}

	function onUpdate(_properties) {
		_properties.Stamina += m.FatigueBonus;
	}
});
