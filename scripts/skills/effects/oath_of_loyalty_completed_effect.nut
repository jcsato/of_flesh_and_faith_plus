oath_of_loyalty_completed_effect <- inherit("scripts/skills/skill", {
	m = { }

	function create() {
		m.ID					= "effects.oath_of_loyalty_completed";
		m.Name					= "Oath of Loyalty";
		m.Description			= "While mercenaries rarely earn the trust society's upper castes, even the most cautious of employers can see the benefits to fostering good relations with a violent religious cult that slays bandits and protects the economy of their underlings.";
		m.Icon					= "skills/status_effect_plus_26.png";
		m.IconMini				= "";
		m.Overlay				= "status_effect_plus_26";
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
			{ id = 10, type = "text", icon = "ui/icons/special.png", text = "Gain additional Renown each time you successfully complete a contract" }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "Gain additional relations with your employer each time you successfully complete a contract" }
		];

		return ret;
	}
});
