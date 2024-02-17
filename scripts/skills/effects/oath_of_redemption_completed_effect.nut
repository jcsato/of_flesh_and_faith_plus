oath_of_redemption_completed_effect <- inherit("scripts/skills/skill", {
	m = {
		DamageReduction		= 10
		ResolveBonusFirst	= 20
		ResolveBonusSecond	= 30
		ResolveBonusThird	= 40
	}

	function create() {
		m.ID					= "effects.oath_of_redemption_completed";
		m.Name					= "Oath of Redemption";
		m.Description			= "\"Heed not the words of the fearful, but do not disregard their actions. It is sometimes only in the deepest throes of dread that a man's true character shines forth, and in even the meekest heart lies the potential for great courage.\"";
		m.Icon					= "skills/status_effect_plus_41.png";
		m.IconMini				= "";
		m.Overlay				= "status_effect_plus_41";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 9;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip(_withContainer = true) {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.ResolveBonusFirst + "[/color] Resolve when at Wavering morale" }
			{ id = 11, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.ResolveBonusSecond + "[/color] Resolve when at Breaking morale" }
			{ id = 12, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.ResolveBonusThird + "[/color] Resolve when at Fleeing morale" }
			{ id = 13, type = "text", icon = "ui/icons/morale.png", text = "No morale check triggered upon losing hitpoints" }
			{ id = 14, type = "text", icon = "ui/icons/special.png", text = "Receives only [color=" + Const.UI.Color.PositiveValue + "]" + (100 - m.DamageReduction) + "%[/color] of any damage" }
		];

		return ret;
	}

	function getManagementScreenTooltip() {
		return getTooltip(false);
	}

	function onUpdate(_properties) {
		_properties.DamageReceivedTotalMult	*= (1.0 - (m.DamageReduction / 100.0));

		local actor = getContainer().getActor();

		if (actor.getMoraleState() <= Const.MoraleState.Fleeing)
			_properties.Bravery	 += m.ResolveBonusThird;
		else if (actor.getMoraleState() <= Const.MoraleState.Breaking)
			_properties.Bravery	 += m.ResolveBonusSecond;
		else if (actor.getMoraleState() <= Const.MoraleState.Wavering)
			_properties.Bravery	 += m.ResolveBonusFirst;
	}
});
