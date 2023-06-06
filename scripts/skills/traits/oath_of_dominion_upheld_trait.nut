oath_of_dominion_upheld_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
		ApplyEffect	= true
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.oath_of_dominion_upheld";
		m.Name			= "Oath of Dominion Upheld";
		m.Icon			= "ui/traits/trait_icon_plus_20.png";
		m.Description	= "This character has fulfilled an Oath of Dominion, and has proven to himself - and the world - that it is proper for men to beat back the hordes of nature. He meets all the horrors of the natural and supernatural with a renewed, steely will, no longer afraid of the isolated hollow or the dark of night, for they are his domain.";

		m.Order			= Const.SkillOrder.Trait + 1;

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+15[/color] Resolve when fighting beasts" }
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

		local fightingBeasts = false;
		local enemies = Tactical.Entities.getAllHostilesAsArray();

		foreach(enemy in enemies)
		{
			if (Const.EntityType.getDefaultFaction(enemy.getType()) == Const.FactionType.Beasts || enemy.getType() == Const.EntityType.BarbarianUnhold || enemy.getType() == Const.EntityType.BarbarianUnholdFrost) {
				fightingBeasts = true;
				break;
			}
		}

		if (fightingBeasts)
			_properties.Bravery += 15;
	}
})