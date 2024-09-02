assassin_speciality_05_effect <- inherit("scripts/skills/skill", {
	m = { }

	function create() {
		m.ID			= "effects.assassin_speciality_05";
		m.Name			= "Ambidextrous";
		m.Description	= "This character has learned to use tools in their offhand and pack more efficiently than others. They're pretty good at juggling, too.";
		m.Icon			= "skills/status_effect_plus_17.png";
		m.IconMini		= "";
		m.Type			= Const.SkillType.StatusEffect | Const.SkillType.Perk;
		m.Order			= Const.SkillOrder.VeryLast - 2;
		m.IsActive		= false;
		m.IsStacking	= false;
	}

	function getTooltip() {
		return [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/action_points.png", text = "Consumables such as nets cost [color=" + Const.UI.Color.NegativeValue + "]3[/color] Action Points to use" }
			{ id = 11, type = "text", icon = "ui/icons/fatigue.png", text = "Consumables such as nets build up [color=" + Const.UI.Color.NegativeValue + "]50%[/color] less Fatigue" }
			{ id = 17, type = "hint", icon = "ui/icons/special.png", text = "Unlocks the next row of perks" }
		];
	}
});
