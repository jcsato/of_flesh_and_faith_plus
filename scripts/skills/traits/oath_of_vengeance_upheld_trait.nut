oath_of_vengeance_upheld_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
		ApplyEffect = true
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.oath_of_vengeance_upheld";
		m.Name			= "Oath of Vengeance Upheld";
		m.Icon			= "ui/traits/trait_icon_plus_28.png";
		m.Description	= "This character has fulfilled an Oath of Vengeance, and proven once again that man is more than a match for any greenskin. No hail of goblin arrows is unweatherable, no contest of strength with an orc unbeatable, so long as one holds their affronts in their heart and tends the fires of revenge.";

		m.Order			= Const.SkillOrder.Trait + 1;

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/ranged_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+5[/color] Ranged Defense when fighting greenskins" }
			{ id = 11, type = "text", icon = "ui/icons/fatigue.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+1[/color] Fatigue Recovery per turn when fighting greenskins" }
		];

		return ret;
	}
	function onCombatStarted()
	{
		m.ApplyEffect = true;
	}

	function onCombatFinished()
	{
		m.ApplyEffect = false;
	}

	function onUpdate(_properties)
	{
		if (!m.ApplyEffect)
			return;

		if (!getContainer().getActor().isPlacedOnMap())
			return;

		local fightingGreenskins = false;
		local enemies = Tactical.Entities.getAllHostilesAsArray();

		foreach(enemy in enemies)
		{
			if (Const.EntityType.getDefaultFaction(enemy.getType()) == Const.FactionType.Orcs ||Const.EntityType.getDefaultFaction(enemy.getType()) == Const.FactionType.Goblins) {
				fightingGreenskins = true;
				break;
			}
		}

		if (fightingGreenskins) {
			_properties.RangedDefense		 += 5;
			_properties.FatigueRecoveryRate	 += 1;
		}
	}
})