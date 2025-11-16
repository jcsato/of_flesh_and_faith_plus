way_of_the_gilder_effect <- inherit("scripts/skills/skill", {
	m = { }

	function create() {
		m.ID			= "effects.way_of_the_gilder";
		m.Name			= "Way of the Gilder";
		m.Description	= "Underneath the mystique of shadows and poisons, assassins are naught but men, fleshen constructs on the Gilder's meridian. To follow the Way of the Gilder is to acknowledge this truth, and in so doing be guided by His gleam to find the truths beyond.";

		m.Icon			= "skills/status_effect_plus_45.png";
		m.Type			= Const.SkillType.StatusEffect | Const.SkillType.Perk;
		m.Order			= Const.SkillOrder.AnyAny - 1;

		m.IsActive		= false;
		m.IsStacking	= false;
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/hitchance.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+100%[/color] chance to hit each combat until successfully landing a blow" }
			{ id = 12, type = "text", icon = "ui/icons/morale.png", text = "No morale check triggered upon losing hitpoints" }
			{ id = 13, type = "text", icon = "ui/icons/morale.png", text = "No morale check triggered upon allies fleeing" }
			{ id = 14, type = "text", icon = "ui/icons/morale.png", text = "No morale check triggered upon allies dying" }
		];

		return ret;
	}

	function onCombatStarted() {
		getContainer().add(new("scripts/skills/effects/true_strike_effect"));
	}

	function onCombatFinished() {
		getContainer().removeByID("effects.true_strike");
	}

	function onUpdate(_properties) {
		_properties.IsAffectedByLosingHitpoints	= false;
		_properties.IsAffectedByFleeingAllies	= false;
		_properties.IsAffectedByDyingAllies		= false;
	}
});
