oath_of_honor_completed_effect <- inherit("scripts/skills/skill", {
	m = {
		ResolveBonus	= 10
	}

	function create() {
		m.ID					= "effects.oath_of_honor_completed";
		m.Name					= "Oath of Honor";
		m.Description			= "\"Know that to enter battle cloaked in honor is to be a victor awaiting only declaration.\"";
		m.Icon					= "skills/status_effect_plus_31.png";
		m.IconMini				= "";
		m.Overlay				= "status_effect_plus_31";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 9;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip(_normalDescription = true) {
		local ret = [{ id = 1, type = "title", text = getName() }];

		if (_normalDescription)
			ret.push({ id = 2, type = "description", text = getDescription() });
		else
			ret.push({ id = 2, type = "description", text = "Upholding this Oath will grant the following effects:" });

		ret.extend([
			{ id = 10, type = "text", icon = "ui/icons/morale.png", text = "Will start combat at confident morale if permitted by mood" }
			{ id = 11, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.ResolveBonus + "%[/color] Resolve when at Confident morale" }
		]);

		return ret;
	}

	function getManagementScreenTooltip() {
		return getTooltip(false);
	}

	function onCombatStarted() {
		local actor = getContainer().getActor();

		if (actor.getMoodState() >= Const.MoodState.Neutral && actor.getMoraleState() < Const.MoraleState.Confident)
			actor.setMoraleState(Const.MoraleState.Confident);
	}

	function onUpdate(_properties) {
		local actor = getContainer().getActor();

		if (actor.getMoraleState() > Const.MoraleState.Steady)
			_properties.BraveryMult	*= (1.0 + m.ResolveBonus / 100.0);
	}
});
