way_of_the_gilder_trait <- inherit("scripts/skills/traits/character_trait", {
	m = { }

	function create() {
		character_trait.create();

		m.ID			= "trait.way_of_the_gilder";
		m.Name			= "Way of the Gilder";
		m.Icon			= "ui/traits/trait_icon_plus_07.png";
		m.Type			= Const.SkillType.Trait | Const.SkillType.Perk;
		m.Order			= Const.SkillOrder.VeryLast - 1;
		m.Description	= "Underneath the mystique of shadows and poisons, assassins are naught but men, fleshen constructs on the Gilder's meridian. To follow the Way of the Gilder is to acknowledge this truth, and in so doing be guided by His gleam to find the truths beyond.";

		m.Excluded		= [ ];
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
		getContainer().add(new("scripts/skills/effects/way_of_the_gilder_effect"));
	}

	function onCombatFinished() {
		getContainer().removeByID("effects.way_of_the_gilder");
	}

	function onUpdate(_properties) {
		_properties.IsAffectedByLosingHitpoints	= false;
		_properties.IsAffectedByFleeingAllies	= false;
		_properties.IsAffectedByDyingAllies		= false;
	}
});
