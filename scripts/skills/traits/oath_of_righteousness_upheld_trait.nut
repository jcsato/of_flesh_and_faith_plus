oath_of_righteousness_upheld_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
		ApplyEffect = true
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.oath_of_righteousness_upheld";
		m.Name			= "Oath of Righteousness Upheld";
		m.Icon			= "ui/traits/trait_icon_plus_25.png";
		m.Description	= "This character has fulfilled an Oath of Righteousness, and proven himself a reliable champion against the horrors of undeath. Indeed, in place of fear his heart holds a renewed hatred for their profanity, and he strikes true against them as though guided by some divine fury.";

		m.Order			= Const.SkillOrder.Trait + 1;

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/melee_skill.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+5[/color] Melee Skill when fighting undead" }
			{ id = 10, type = "text", icon = "ui/icons/ranged_skill.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+5[/color] Ranged Skill when fighting undead" }
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

		local fightingUndead = false;
		local enemies = Tactical.Entities.getAllHostilesAsArray();

		foreach(enemy in enemies)
		{
			if (Const.EntityType.getDefaultFaction(enemy.getType()) == Const.FactionType.Zombies ||Const.EntityType.getDefaultFaction(enemy.getType()) == Const.FactionType.Undead) {
				fightingUndead = true;
				break;
			}
		}

		if (fightingUndead) {
			_properties.MeleeSkill	+= 5;
			_properties.RangedSkill	+= 5;
		}
	}
})