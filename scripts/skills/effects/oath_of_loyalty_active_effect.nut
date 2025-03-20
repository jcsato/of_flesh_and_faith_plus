oath_of_loyalty_active_effect <- inherit("scripts/skills/skill", {
	m = {
		XPMalus	= 50
	}

	function create() {
		m.ID					= "effects.oath_of_loyalty_active";
		m.Name					= "Oath of Loyalty";
		m.Description			= "\"Mind the noble and the elder, tend to their needs. Without leaders there can be no order, and it is only in order that a man truly proves his convictions.\"";
		m.Icon					= "ui/traits/trait_icon_85.png";
		m.IconMini				= "";
		m.Overlay				= "trait_icon_85";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 10;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip() {
		local numCompleted = !(getContainer() == null) ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.Loyalty) : 0;

		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/xp_received.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.XPMalus + "%[/color] Experience Gain if the company has no active contract" }
			{ id = 12, type = "text", icon = "ui/icons/special.png", text = "Uphold by completing " + ::OFFP.Oathtakers.Quests.LoyaltyContractsCompleted + " contracts successfully (" + numCompleted + " so far)" }
		];

		return ret;
	}

	function onUpdate(_properties) {
		if (!("Contracts" in World && World.Contracts.getActiveContract() != null))
			_properties.XPGainMult	*= (1.0 - m.XPMalus / 100.0);
	}
});
