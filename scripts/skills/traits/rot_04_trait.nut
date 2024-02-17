rot_04_trait <- inherit("scripts/skills/traits/character_trait", {
	m = { }

	function create() {
		character_trait.create();

		m.ID			= "trait.rot_04";
		m.Name			= "Mindrot";
		m.Icon			= "ui/traits/trait_icon_plus_04.png";
		m.Description	= "The Rot has spread to this character's brain, causing forgetfulness and muddled thoughts.";

		m.Order			= Const.SkillOrder.Trait - 1;

		m.Excluded = [];
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/xp_received.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-5%[/color] Experience Gain per Rot" }
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

		_properties.XPGainMult -= numRots * 0.05;
	}
});
