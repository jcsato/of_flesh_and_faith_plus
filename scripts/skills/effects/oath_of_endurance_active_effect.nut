oath_of_endurance_active_effect <- inherit("scripts/skills/skill", {
	m = {
		FatigueRecoveryMalus = 3
	}

	function create() {
		m.ID					= "effects.oath_of_endurance_active";
		m.Name					= "Oath of Endurance";
		m.Description			= "Young Anselm was well known for his brio, and many who seek to emulate the first Oathtaker run themselves ragged in attempts to meet the standards he set.";
		m.Icon					= "ui/traits/trait_icon_84.png";
		m.IconMini				= "";
		m.Overlay				= "trait_icon_84";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 10;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip() {
		local numWon = !(getContainer() == null) ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.Endurance) : 0;

		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/fatigue.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.FatigueRecoveryMalus + "[/color] Fatigue Recovery per turn" }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "Uphold by taking part in " + ::OFFP.Oathtakers.Quests.EnduranceConsecutiveBattles + " consecutive victorious battles (" + numWon + " so far)" }
		];

		return ret;
	}

	function onUpdate(_properties) {
		_properties.FatigueRecoveryRate -= m.FatigueRecoveryMalus;
	}
});
