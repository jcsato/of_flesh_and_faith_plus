oath_of_dominion_completed_effect <- inherit("scripts/skills/skill", {
	m = {
		ResolveBonus	= 10
		ThreatBonus		= 3
	}

	function create() {
		m.ID					= "effects.oath_of_dominion_completed";
		m.Name					= "Oath of Dominion";
		m.Description			= "\"Patrol not the peripheries between dukes and barons, for it is the border between man and beast that requires the greatest vigilance.\"";
		m.Icon					= "skills/status_effect_plus_28.png";
		m.IconMini				= "";
		m.Overlay				= "status_effect_plus_28";
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
			{ id = 10, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.ResolveBonus + "[/color] Resolve" }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "Reduces the Resolve of any opponent engaged in melee by [color=" + Const.UI.Color.NegativeValue + "]-" + m.ThreatBonus + "[/color]" }
		];

		return ret;
	}

	function onUpdate(_properties) {
		_properties.Bravery	 += m.ResolveBonus;
		_properties.Threat	 += m.ThreatBonus;
	}
});
