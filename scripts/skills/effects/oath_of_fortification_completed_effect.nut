oath_of_fortification_completed_effect <- inherit("scripts/skills/skill", {
	m = {
		DamageBonus			= 15
		DamageResistance	= 50
		StunChance			= ::OFFP.Oathtakers.Boons.FortificationStunChance
		IsUsed				= false
	}

	function create() {
		m.ID					= "effects.oath_of_fortification_completed";
		m.Name					= "Oath of Fortification";
		m.Description			= "\"The shield is not simply a barrier to be put before a knave's blade. Is is an extension of the being, inward and out. Let none think an Oathtaker unprotected for the absence of some meager planks, nor defanged for their presence.\"";
		m.Icon					= "skills/status_effect_plus_30.png";
		m.IconMini				= "";
		m.Overlay				= "status_effect_plus_30";
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
			{ id = 11, type = "text", icon = "ui/icons/regular_damage.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.DamageBonus + "%[/color] damage when equipped with a shield" }
			{ id = 12, type = "text", icon = "ui/icons/special.png", text = "The Knock Back skill has a [color=" + Const.UI.Color.PositiveValue + "]" + m.StunChance + "%[/color] chance to stun targets" }
			{ id = 13, type = "text", icon = "ui/icons/special.png", text = "Only receive [color=" + Const.UI.Color.PositiveValue + "]" + m.DamageResistance + "%[/color] damage from the first hit of every combat encounter which doesn't ignore armor" }
		]);

		return ret;
	}

	function getManagementScreenTooltip() {
		return getTooltip(false);
	}

	function onBeforeDamageReceived(_attacker, _skill, _hitInfo, _properties) {
		if (m.IsUsed)
			return;

		if (_hitInfo.DamageDirect < 1.0) {
			m.IsUsed = true;
			_properties.DamageReceivedTotalMult *= m.DamageResistance / 100.0;
		}
	}

	function onCombatFinished() {
		m.IsUsed = false;
	}

	function onUpdate(_properties) {
		local offhandItem = getContainer().getActor().getItems().getItemAtSlot(Const.ItemSlot.Offhand);

		if (offhandItem != null && offhandItem.isItemType(Const.Items.ItemType.Shield))
			_properties.DamageTotalMult *= (1.0 + m.DamageBonus / 100.0);
	}
});
