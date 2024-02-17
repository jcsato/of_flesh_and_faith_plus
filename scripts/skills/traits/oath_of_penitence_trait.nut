oath_of_penitence_trait <- inherit("scripts/skills/traits/character_trait", {
	m = {
		DamageBonus		= 10
		HitpointMalus	= 10
	}

	function create() {
		character_trait.create();

		m.ID			= "trait.oath_of_penitence";
		m.Name			= "Oath of Penitence";
		m.Icon			= "ui/traits/trait_icon_plus_18.png";
		m.Description	= "This character has convinced himself that he is guilty of committing some transgression and he now seeks repentence in self-flagellation. At least his aptitude for war has compelled him to ply his newfound skills towards the ruination of your enemies and not just himself.";

		m.Excluded		= [ ];
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/regular_damage.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.DamageBonus + "%[/color] Melee Damage when wielding flails or whips" }
			{ id = 11, type = "text", icon = "ui/icons/health.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.HitpointMalus + "[/color] Hitpoints" }
		];

		return ret;
	}

	function onUpdate(_properties) {
		_properties.Hitpoints -= m.HitpointMalus;

		local items = getContainer().getActor().getItems();
		local main = items.getItemAtSlot(Const.ItemSlot.Mainhand);

		if (main != null && (main.getCategories().slice(0, 5) == "Flail" || main.getID() == "weapon.battle_whip" || main.getID() == "weapon.named_battle_whip" || main.getID() == "weapon.thorned_whip")) {
			logDebug("active!")
			_properties.MeleeDamageMult *= (1.0 + m.DamageBonus / 100.0);
		}
	}
});
