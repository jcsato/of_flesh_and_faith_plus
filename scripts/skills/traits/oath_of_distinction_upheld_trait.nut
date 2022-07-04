oath_of_distinction_upheld_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.oath_of_distinction_upheld";
		m.Name			= "Oath of Distinction Upheld";
		m.Icon			= "ui/traits/trait_icon_plus_19.png";
		m.Description	= "This character has fulfilled an Oath of Distinction, and has developed a keen awareness of the battlefield. They're much more confident in their own abilities when separated from the main formation, and by necessity they've become adept at figuring out what works and how to better apply it in the future.";

		m.Order			= Const.SkillOrder.Trait + 1;

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+10[/color] Resolve if there are no allies in adjacent tiles" }
			{ id = 12, type = "text", icon = "ui/icons/xp_received.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+10%[/color] Experience Gain" }
		];

		return ret;
	}

	function onUpdate( _properties ) {
		_properties.XPGainMult += 0.1;

		local actor = getContainer().getActor();
		if (!actor.isPlacedOnMap())
			return;

		local myTile = actor.getTile();
		local allies = Tactical.Entities.getInstancesOfFaction(actor.getFaction());
		local isAlone = true;

		foreach( ally in allies )
		{
			if (ally.getID() == actor.getID() || !ally.isPlacedOnMap())
				continue;

			if (ally.getTile().getDistanceTo(myTile) <= 1)
			{
				isAlone = false;
				break;
			}
		}

		if (isAlone)
			_properties.Bravery += 10;
	}
})