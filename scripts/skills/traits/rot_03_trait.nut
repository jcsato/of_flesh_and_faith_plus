rot_03_trait <- inherit("scripts/skills/traits/character_trait", {
	m = { }

	function create()
	{
		character_trait.create();

		m.ID			= "trait.rot_03";
		m.Name			= "Spinerot";
		m.Icon			= "ui/traits/trait_icon_plus_03.png";
		m.Description	= "The Rot has begun to affect this character's limbic system. Coordinated motions are sluggish and difficult as a result.";

		m.Order			= Const.SkillOrder.Trait - 1;

		m.Excluded = [];
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-5%[/color] damage inflicted per Rot when the offhand is not free" }
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

		local items = getContainer().getActor().getItems();
		local main = items.getItemAtSlot(Const.ItemSlot.Mainhand);

		// offhand not free?
		if ((main != null && (main.isItemType(Const.Items.ItemType.TwoHanded) || items.hasBlockedSlot(Const.ItemSlot.Offhand))) || items.getItemAtSlot(Const.ItemSlot.Offhand) != null) {
			_properties.DamageTotalMult	*= (1.0 - (numRots * 0.05));
		}
	}
});
