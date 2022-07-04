way_of_the_wolf_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
		LastEnemyAppliedTo	= 0
		LastFrameApplied	= 0
		SkillCount			= 0
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.way_of_the_wolf";
		m.Name			= "Way of the Wolf";
		m.Icon			= "ui/traits/trait_icon_plus_11.png";
		m.Description	= "Strike first, strike hard, and thusly strike last. The Way of the Wolf has no room for hesitancy, nor for ponderousness. Assassination is a hunt, and while only a foolish predator leaps headlong into danger, one who waits for their quarry to give up of its own accord is not a predator at all, but prey. And a Wolf is never prey.";

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/regular_damage.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+15%[/color] damage against targets that have not yet acted" }
		];

		return ret;
	}

	function onAnySkillUsed(_skill, _targetEntity, _properties)
	{
		if(Tactical.TurnSequenceBar.getActiveEntity() == null || Tactical.TurnSequenceBar.getActiveEntity().getID() != getContainer().getActor().getID())
			return;

		if(!_targetEntity.isAlive() || _targetEntity.isDying() || _targetEntity.isAlliedWith(getContainer().getActor()))
			return;

		if(!_targetEntity.isTurnStarted() && !_targetEntity.isTurnDone())
		{
			if(m.SkillCount == Const.SkillCounter && m.LastTargetID == _targetEntity.getID())
				return;

			m.SkillCount = Const.SkillCounter;
			m.LastTargetID = _targetEntity.getID();

			_properties.DamageTotalMult *= 1.15;
		}
	}

	function onBeforeTargetHit(_skill, _targetEntity, _hitInfo)
	{
		if(Tactical.TurnSequenceBar.getActiveEntity() == null || Tactical.TurnSequenceBar.getActiveEntity().getID() != getContainer().getActor().getID())
			return;

		if(!_targetEntity.isAlive() || _targetEntity.isDying() || _targetEntity.isAlliedWith(getContainer().getActor()))
			return;

		if(!_targetEntity.isTurnStarted() && !_targetEntity.isTurnDone())
		{
			if(m.SkillCount == Const.SkillCounter && m.LastTargetID == _targetEntity.getID())
				return;

			spawnIcon("trait_icon_plus_11", getContainer().getActor().getTile())
		}
	}

	function onCombatStarted()
	{
		m.SkillCount	= 0;
		m.LastTargetID	= 0;
	}

	function onCombatFinished()
	{
		skill.onCombatFinished();
		m.SkillCount	= 0;
		m.LastTargetID	= 0;
	}
})