oath_of_wrath_completed_effect <- inherit("scripts/skills/skill", {
	m = {
		InjuryThresholdBonus	= 25
	}

	function create() {
		m.ID					= "effects.oath_of_wrath_completed";
		m.Name					= "Oath of Wrath";
		m.Description			= "\"The blade that slays evil will soon find itself sharpened by the pursuit. Devote yourself to a strike with such a weapon, and even the most hardy villain's flesh shall part at its touch.\"";
		m.Icon					= "skills/status_effect_plus_37.png";
		m.IconMini				= "";
		m.Overlay				= "status_effect_plus_37";
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
			{ id = 10, type = "text", icon = "ui/icons/special.png", text = "[color=" + Const.UI.Color.NegativeValue + "]" + m.InjuryThresholdBonus + "%[/color] lower threshold to inflict injuries while wielding a double gripped or two handed weapon" }
		]);

		return ret;
	}

	function getManagementScreenTooltip() {
		return getTooltip(false);
	}

	function onAnySkillUsed(_skill, _targetEntity, _properties) {
		if (_skill.isAttack() && isValidWeapon())
			_properties.ThresholdToInflictInjuryMult *= (1.0 - m.InjuryThresholdBonus / 100.0);
	}

	function isValidWeapon() {
		local items = getContainer().getActor().getItems();
		local main = items.getItemAtSlot(Const.ItemSlot.Mainhand);

		if (main != null) {
			local isTwoHanded = main.isItemType(Const.Items.ItemType.TwoHanded);
			local isTwoHandedRanged = main.isItemType(Const.Items.ItemType.RangedWeapon) && items.hasBlockedSlot(Const.ItemSlot.Offhand);
			local isDoubleGrippedMelee = main.isItemType(Const.Items.ItemType.MeleeWeapon) && main.isItemType(Const.Items.ItemType.OneHanded) && items.getItemAtSlot(Const.ItemSlot.Offhand) == null && !items.hasBlockedSlot(Const.ItemSlot.Offhand);

			return isTwoHanded || isTwoHandedRanged || isDoubleGrippedMelee;
		}

		return false;
	}
});
