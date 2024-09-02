oath_of_valor_completed_effect <- inherit("scripts/skills/skill", {
	m = { }

	function create() {
		m.ID					= "effects.oath_of_valor_completed";
		m.Name					= "Oath of Valor";
		m.Description			= "\"Remember in times of peril that courage triumphs over skill. Even the most expert blade loses its edge when wielded in fear. Hold fast, and death itself shall falter in witness.\"";
		m.Icon					= "skills/status_effect_plus_35.png";
		m.IconMini				= "";
		m.Overlay				= "status_effect_plus_35";
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
			ret.push({ id = 2, type = "description", text = "Upholding this Oath will grant the following effect:" });

		ret.extend([
			{ id = 10, type = "text", icon = "ui/icons/morale.png", text = "Will not flee in battle" }
			{ id = 11, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+5[/color] Resolve for adjacent allies who have not also completed the Oath of Valor" }
		]);

		return ret;
	}

	function getManagementScreenTooltip() {
		return getTooltip(false);
	}

	function onCombatStarted() {
		local actor = getContainer().getActor();
		local allies = Tactical.Entities.getInstancesOfFaction(actor.getFaction());

		foreach (ally in allies) {
			ally.getSkills().add(new("scripts/skills/effects/inspired_by_hero_effect"));
		}
	}

	function onCombatFinished() {
		local actor = getContainer().getActor();
		local allies = Tactical.Entities.getInstancesOfFaction(actor.getFaction());

		foreach (ally in allies) {
			ally.getSkills().removeByID("effects.inspired_by_hero");
		}
	}

	function onMovementFinished() {
		local actor = getContainer().getActor();
		local allies = Tactical.Entities.getInstancesOfFaction(actor.getFaction());

		foreach (ally in allies) {
			if (ally.getID() != actor.getID())
				ally.getSkills().update();
		}
	}
});
