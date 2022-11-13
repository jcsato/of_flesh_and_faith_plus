oath_of_proving_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
		ApplyXPMult	= false
		KillScored	= false
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.oath_of_proving";
		m.Name			= "Oath of Proving";
		m.Icon			= "ui/traits/trait_icon_plus_30.png";
		m.Description	= "This character has taken an Oath of Proving, and has sworn his exploits in battle will demonstrate his worth.";

		m.Order			= Const.SkillOrder.Trait - 1;

		m.Excluded = [];
	}

	function getTooltip() {
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
		];

		if (!getContainer().getActor().isPlacedOnMap() || !m.KillScored) {
			ret.extend([
				{ id = 10, type = "text", icon = "ui/icons/initiative.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+15[/color] Initiative each combat until this character kills an enemy" }
				{ id = 11, type = "text", icon = "ui/icons/damage_dealt.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+10%[/color] damage each combat until this character kills an enemy" }
			])
		} else if (getContainer().getActor().isPlacedOnMap() && m.KillScored) {
			ret.push({ id = 10, type = "text", icon = "ui/icons/special.png", text = "This character has killed an enemy this combat and proven his worth" })
		}

		if (getContainer().getActor().getFlags().get("OathOfProvingApplyXPMult"))
			ret.push({ id = 12, type = "text", icon = "ui/icons/xp_received.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-100%[/color] Experience Gain until this character kills an enemy" });

		return ret;
	}

	function onCombatStarted() {
		m.ApplyXPMult = getContainer().getActor().getFlags().get("OathOfProvingApplyXPMult");
		m.KillScored = false;
	}

	function onCombatFinished() {
		getContainer().getActor().getFlags().set("OathOfProvingApplyXPMult", !m.KillScored);
	}

	function onTargetKilled(_targetEntity, _skill) {
		if(!_targetEntity.isAlliedWith(getContainer().getActor())) {
			m.KillScored	= true;
			getContainer().getActor().getFlags().set("OathOfProvingApplyXPMult", false);
		}
	}

	function onUpdate(_properties) {
		if (!getContainer().getActor().isPlacedOnMap())
			return;

		if (!m.KillScored) {
			_properties.Initiative		+= 15;
			_properties.DamageTotalMult	*= 1.1;
		}

		if (getContainer().getActor().getFlags().get("OathOfProvingApplyXPMult"))
			_properties.XPGainMult *= 0.0;
	}
})
