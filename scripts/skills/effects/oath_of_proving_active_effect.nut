oath_of_proving_active_effect <- inherit("scripts/skills/skill", {
	m = {
		KillScored	= false
		XPMalus		= 100
	}

	function create() {
		m.ID					= "effects.oath_of_proving_active";
		m.Name					= "Oath of Proving";
		m.Description			= "\"Let every man fight knowing how many depend on his victory. And just as a shepherd must be able to protect his flock, so too must a warrior be able to lay low his foes.\"";
		m.Icon					= "skills/status_effect_plus_38.png";
		m.IconMini				= "";
		m.Overlay				= "status_effect_plus_38";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 10;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip(_withContainer = true) {
		local numGained = _withContainer ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.Proving) : 0;

		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/xp_received.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.XPMalus + "%[/color] Experience Gain each combat until this character kills an enemy" }
			{ id = 12, type = "text", icon = "ui/icons/special.png", text = "Uphold by gaining 2000 experience (" + numGained + " so far)" }
		];

		return ret;
	}

	function getManagementScreenTooltip() {
		return getTooltip(false);
	}

	function onCombatStarted() {
		m.KillScored = false;
	}

	function onCombatFinished() {
		getContainer().getActor().getFlags().set("OFFP_OathOfProvingApplyXPMult", true);
	}

	function onTargetKilled(_targetEntity, _skill) {
		if (!_targetEntity.isAlliedWith(getContainer().getActor())) {
			m.KillScored = true;
			getContainer().getActor().getFlags().set("OFFP_OathOfProvingApplyXPMult", false);
		}
	}

	function onUpdate(_properties) {
		if (!getContainer().getActor().isPlacedOnMap())
			return;

		if (getContainer().getActor().getFlags().get("OFFP_OathOfProvingApplyXPMult"))
			_properties.XPGainMult *= (1.0 - m.XPMalus / 100.0);
	}
});
