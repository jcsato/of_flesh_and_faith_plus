assassin_specialty_02_effect <- inherit("scripts/skills/skill", {
	m = {
		PrimaryStatBoost	= 4
		SecondaryStatBoost	= 8
		ApplyEffect			= true
	}

	function create() {
		m.ID			= "effects.assassin_specialty_02";
		m.Name			= "Incubator";
		m.Description	= "Poisons are among the assassin's most powerful tools. This character has trained so thoroughly that even the most glancing blow is an opportunity to enfeeble their target.";
		m.Icon			= "skills/status_effect_plus_14.png";
		m.IconMini		= "";
		m.Type			= Const.SkillType.StatusEffect | Const.SkillType.Perk;
		m.Order			= Const.SkillOrder.Any - 2;
		m.IsActive		= false;
		m.IsStacking	= false;
	}

	function getTooltip() {
		return [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 16, type = "text", icon = "ui/icons/special.png", text = "Applies poisons on any direct hit, regardless of hitpoint damage inflicted" }
			{ id = 17, type = "hint", icon = "ui/icons/special.png", text = "Unlocks the next row of perks" }
		];
	}
});
