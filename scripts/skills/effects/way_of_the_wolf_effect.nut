way_of_the_wolf_effect <- inherit("scripts/skills/skill", {
	m = {
		LastTargetID		= 0
		SkillCount			= 0
	}

	function create() {
		m.ID			= "effects.way_of_the_wolf";
		m.Name			= "Way of the Wolf";
		m.Description	= "Strike first, strike hard, and thusly strike last. The Way of the Wolf has no room for hesitancy, nor for ponderousness. Assassination is a hunt, and while only a foolish predator leaps headlong into danger, one who waits for their quarry to give up of its own accord is not a predator at all, but prey. And a Wolf is never prey.";

		m.Icon			= "skills/status_effect_plus_49.png";
		m.Type			= Const.SkillType.StatusEffect | Const.SkillType.Perk;
		m.Order			= Const.SkillOrder.Any - 1;

		m.IsActive		= false;
		m.IsStacking	= false;
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/regular_damage.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+20%[/color] damage against targets that have not yet acted" }
			{ id = 11, type = "text", icon = "ui/icons/fatigue.png", text = "The Adrenaline skill costs [color=" + Const.UI.Color.NegativeValue + "]60%[/color] less Fatigue" }
		];

		return ret;
	}

	function onAnySkillUsed(_skill, _targetEntity, _properties) {
		if (!getContainer().getActor().isPlacedOnMap())
			return;

		if (Tactical.TurnSequenceBar.getActiveEntity() == null || Tactical.TurnSequenceBar.getActiveEntity().getID() != getContainer().getActor().getID())
			return;

		if (_targetEntity == null || !_targetEntity.isAlive() || _targetEntity.isDying() || _targetEntity.isAlliedWith(getContainer().getActor()))
			return;

		if (!_targetEntity.isTurnStarted() && !_targetEntity.isTurnDone()) {
			if(m.SkillCount == Const.SkillCounter && m.LastTargetID == _targetEntity.getID())
				return;

			m.SkillCount = Const.SkillCounter;
			m.LastTargetID = _targetEntity.getID();

			_properties.DamageTotalMult	*= 1.2;
		}
	}

	function onBeforeTargetHit(_skill, _targetEntity, _hitInfo) {
		if (Tactical.TurnSequenceBar.getActiveEntity() == null || Tactical.TurnSequenceBar.getActiveEntity().getID() != getContainer().getActor().getID())
			return;

		if (_targetEntity == null || !_targetEntity.isAlive() || _targetEntity.isDying() || _targetEntity.isAlliedWith(getContainer().getActor()))
			return;

		if (!_targetEntity.isTurnStarted() && !_targetEntity.isTurnDone()) {
			if(m.SkillCount == Const.SkillCounter && m.LastTargetID == _targetEntity.getID())
				return;

			spawnIcon("status_effect_plus_49", _targetEntity.getTile())
		}
	}

	function onCombatStarted() {
		m.SkillCount	= 0;
		m.LastTargetID	= 0;
	}

	function onCombatFinished() {
		m.SkillCount	= 0;
		m.LastTargetID	= 0;
	}

	function onUpdate(_properties) {
		_properties.SkillCostAdjustments.push({ ID = "actives.adrenaline", APAdjust = 0, FatigueAdjust = 0, FatigueMultAdjust = 0.6 });
	}
});
