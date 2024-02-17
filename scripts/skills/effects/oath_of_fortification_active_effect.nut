oath_of_fortification_active_effect <- inherit("scripts/skills/skill", {
	m = {
		ApplyEffect		= true
		DefenseMalus	= 5
		ResolveMalus	= 10
	}

	function create() {
		m.ID					= "effects.oath_of_fortification_active";
		m.Name					= "Oath of Fortification";
		m.Description			= "\"If you can trust in nothing else, trust in your shield. The contribution of the trees and the earth shall not be wasted on the nervous hinge of a coward's arm.\"";
		m.Icon					= "ui/traits/trait_icon_86.png";
		m.IconMini				= "";
		m.Overlay				= "trait_icon_86";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 10;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip(_withContainer = true) {
		local numNegated = _withContainer ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.Fortification) : 0;

		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.ResolveMalus + "[/color] Resolve when not equipped with a shield" }
			{ id = 11, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.DefenseMalus + "[/color] Melee Defense when not equipped with a shield" }
			{ id = 12, type = "text", icon = "ui/icons/ranged_defense.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.DefenseMalus + "[/color] Ranged Defense when not equipped with a shield" }
			{ id = 13, type = "text", icon = "ui/icons/special.png", text = "Uphold by blocking or dodging " + ::OFFP.Oathtakers.Quests.FortificationAttacksNegated + " attacks (" + numNegated + " so far)" }
		];

		return ret;
	}

	function getManagementScreenTooltip() {
		return getTooltip(false);
	}

	function onMissed(_attacker, _skill) {
		getContainer().getActor().getFlags().increment(::OFFP.Oathtakers.Flags.Fortification);
	}

	function onUpdate(_properties) {
		local offhandItem = getContainer().getActor().getItems().getItemAtSlot(Const.ItemSlot.Offhand);
		if (offhandItem == null || !offhandItem.isItemType(Const.Items.ItemType.Shield)) {
			_properties.Bravery -= m.ResolveMalus;
			_properties.MeleeDefense -= m.DefenseMalus;
			_properties.RangedDefense -= m.DefenseMalus;
		}
	}
});
