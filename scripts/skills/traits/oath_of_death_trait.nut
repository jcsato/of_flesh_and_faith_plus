oath_of_death_trait <- inherit("scripts/skills/traits/character_trait", {
	m = {
		ResolveMalus	= 5
	}

	function create() {
		character_trait.create();

		m.ID			= "trait.oath_of_death";
		m.Name			= "Oath of Death";
		m.Icon			= "ui/traits/trait_icon_plus_19.png";
		m.Description	= "This character is taken by a religious obsession with death. He draws little bravery from the sources on which most men rely, but neither is he fazed by the ebb of life, be it his own or that of an ally.";

		m.Excluded		= [ ];
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.ResolveMalus + "[/color] Resolve" }
			{ id = 11, type = "text", icon = "ui/icons/morale.png", text = "No morale check triggered upon losing hitpoints" }
			{ id = 12, type = "text", icon = "ui/icons/morale.png", text = "No morale check triggered upon allies fleeing" }
			{ id = 13, type = "text", icon = "ui/icons/morale.png", text = "No morale check triggered upon allies dying" }
		];

		return ret;
	}

	function onUpdate(_properties) {
		_properties.Bravery						-= m.ResolveMalus;
		_properties.IsAffectedByLosingHitpoints = false;
		_properties.IsAffectedByFleeingAllies	= false;
		_properties.IsAffectedByDyingAllies		= false;
	}
});
