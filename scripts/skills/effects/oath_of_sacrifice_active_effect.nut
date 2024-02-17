oath_of_sacrifice_active_effect <- inherit("scripts/skills/skill", {
	m = {
		InjuryThresholdMalus	= 33
		LastInjuryNum			= 0
	}

	function create() {
		m.ID					= "effects.oath_of_sacrifice_active";
		m.Name					= "Oath of Sacrifice";
		m.Description			= "\"If all is within the realm of the old gods' gifts, then pain itself shall be their bitterest fruit. But an offering it is, nonetheless, and so our battle against pain is one of great selfishness.\"";
		m.Icon					= "ui/traits/trait_icon_87.png";
		m.IconMini				= "";
		m.Overlay				= "trait_icon_87";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 10;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip(_withContainer = true) {
		local numSustained = _withContainer ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.Sacrifice) : 0;
	
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "The threshold to sustain injuries on getting hit is decreased by [color=" + Const.UI.Color.NegativeValue + "]-" + m.InjuryThresholdMalus + "%[/color]" }
			{ id = 12, type = "text", icon = "ui/icons/special.png", text = "Uphold by sustaining " + ::OFFP.Oathtakers.Quests.SacrificeInjuriesSustained + " injuries (" + numSustained + " so far)" }
		];

		return ret;
	}

	function getManagementScreenTooltip() {
		return getTooltip(false);
	}

	// Called before update()
	function onCombatStarted() {
		m.LastInjuryNum = 0;
		m.LastInjuryNum += getContainer().getAllSkillsOfType(Const.SkillType.TemporaryInjury).len();
		m.LastInjuryNum += getContainer().getAllSkillsOfType(Const.SkillType.PermanentInjury).len();
	}

	// Probably unnecessary, but here for consistency
	function onCombatFinished() {
		m.LastInjuryNum = 0;
		m.LastInjuryNum += getContainer().getAllSkillsOfType(Const.SkillType.TemporaryInjury).len();
		m.LastInjuryNum += getContainer().getAllSkillsOfType(Const.SkillType.PermanentInjury).len();
	}

	// Called before skill_container.onAfterDamageReceived, which calls update()
	function onBeforeDamageReceived(_attacker, _skill, _hitInfo, _properties) {
		m.LastInjuryNum = 0;
		m.LastInjuryNum += getContainer().getAllSkillsOfType(Const.SkillType.TemporaryInjury).len();
		m.LastInjuryNum += getContainer().getAllSkillsOfType(Const.SkillType.PermanentInjury).len();
	}

	function onUpdate( _properties ) {
		_properties.ThresholdToReceiveInjuryMult	*= (1.0 - m.InjuryThresholdMalus / 100.0);

		// Just to capture weirdness stemming from event injuries
		if (getContainer().getActor().isPlacedOnMap()) {
			local numInjuries = 0;

			numInjuries += getContainer().getAllSkillsOfType(Const.SkillType.TemporaryInjury).len();
			numInjuries += getContainer().getAllSkillsOfType(Const.SkillType.PermanentInjury).len();

			if (numInjuries > m.LastInjuryNum) {
				getContainer().getActor().getFlags().increment(::OFFP.Oathtakers.Flags.Sacrifice, (numInjuries - m.LastInjuryNum));
				m.LastInjuryNum = numInjuries;
			}
		}
	}
});
