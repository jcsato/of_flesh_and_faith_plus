oath_of_proving_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
		ApplyXPMult = false
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

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/initiative.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+15[/color] Initiative each combat until this character kills an enemy" }
			{ id = 11, type = "text", icon = "ui/icons/damage_dealt.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+10%[/color] damage each combat until this character kills an enemy" }
		];

		if (m.ApplyXPMult)
			ret.push({ id = 12, type = "text", icon = "ui/icons/xp_received.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-100%[/color] Experience Gain until this character kills an enemy" });

		return ret;
	}

	function onCombatStarted()
	{
		m.KillScored = false;
	}

	function onCombatFinished()
	{
		m.KillScored = false;
		m.ApplyXPMult = !m.KillScored;
	}

	function onTargetKilled(_targetEntity, _skill)
	{
		if(!_targetEntity.isAlliedWith(getContainer().getActor())) {
			m.KillScored	= true;
			m.ApplyXPMult	= false;
		}
	}

	function onUpdate(_properties)
	{
		if (!m.KillScored) {
			_properties.Initiative		+= 15;
			_properties.DamageTotalMult	*= 1.1;
		}

		if (m.ApplyXPMult)
			_properties.XPGainMult *= 0.0;
	}
})
