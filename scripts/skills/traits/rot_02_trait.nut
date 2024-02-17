rot_02_trait <- inherit("scripts/skills/traits/character_trait", {
	m = { }

	function create() {
		character_trait.create();

		m.ID			= "trait.rot_02";
		m.Name			= "Heartrot";
		m.Icon			= "ui/traits/trait_icon_plus_02.png";
		m.Description	= "The Rot has reached this character's heart, weakening their constitution.";

		m.Order			= Const.SkillOrder.Trait - 1;

		m.Excluded = [];
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "The threshold to sustain injuries on getting hit is decreased by [color=" + Const.UI.Color.NegativeValue + "]5%[/color] per Rot" }
		];

		return ret;
	}

	function onUpdate(_properties) {
		local skills = getContainer().getActor().getSkills();
		local numRots = 0;

		foreach (trait in ::OFFP.Explorers.RotTraits) {
			if (skills.hasSkill(trait))
				numRots++;
		};

		_properties.ThresholdToReceiveInjuryMult	*= (1.0 - (numRots * 0.05));
	}
});
