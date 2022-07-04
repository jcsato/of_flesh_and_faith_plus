oath_of_proving_upheld_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
		KillScored		= false
		DefenseBoost	= 3
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.oath_of_proving_upheld";
		m.Name			= "Oath of Proving Upheld";
		m.Icon			= "ui/traits/trait_icon_plus_31.png";
		m.Description	= "This character has fulfilled an Oath of Proving, and left no doubt to his abilities as a warrior. Now tempered with accomplishments, he understands the importance of the first blows that are struck in combat - and is extra wary of being on the receiving end of them himself.";

		m.Order			= Const.SkillOrder.Trait + 1;

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.DefenseBoost + "[/color] Melee Defense each combat until this character kills an enemy" }
			{ id = 11, type = "text", icon = "ui/icons/ranged_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.DefenseBoost + "[/color] Ranged Defense each combat until this character kills an enemy" }
		];

		return ret;
	}

	function onCombatStarted()
	{
		m.KillScored = false;
	}

	function onCombatFinished()
	{
		m.KillScored = false;
	}

	function onTargetKilled(_targetEntity, _skill)
	{
		if(!_targetEntity.isAlliedWith(getContainer().getActor()))
			m.KillScored	= true;
	}

	function onUpdate(_properties)
	{
		if (!m.KillScored) {
			_properties.MeleeDefense	+= m.DefenseBoost;
			_properties.RangedDefense	+= m.DefenseBoost;
		}
	}
})
