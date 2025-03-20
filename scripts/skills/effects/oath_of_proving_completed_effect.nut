oath_of_proving_completed_effect <- inherit("scripts/skills/skill", {
	m = {
		DefenseBonus	= 5
		KillScored		= false
	}

	function create() {
		m.ID					= "effects.oath_of_proving_completed";
		m.Name					= "Oath of Proving";
		m.Description			= "\"It is oft that the first sundering blow of a battle swings its tides. Be ever mindful that it is you who strikes it, and not your foe.\"";
		m.Icon					= "skills/status_effect_plus_39.png";
		m.IconMini				= "";
		m.Overlay				= "status_effect_plus_39";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 9;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.DefenseBonus + "[/color] Melee Defense each combat until this character kills an enemy" }
			{ id = 11, type = "text", icon = "ui/icons/ranged_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.DefenseBonus + "[/color] Ranged Defense each combat until this character kills an enemy" }
		];

		return ret;
	}

	function onCombatStarted() {
		m.KillScored = false;
	}

	function onCombatFinished() {
		m.KillScored = false;
	}

	function onTargetKilled(_targetEntity, _skill) {
		if(!_targetEntity.isAlliedWith(getContainer().getActor()))
			m.KillScored	= true;
	}

	function onUpdate(_properties) {
		if (!getContainer().getActor().isPlacedOnMap())
			return;

		if (!m.KillScored) {
			_properties.MeleeDefense	+= m.DefenseBonus;
			_properties.RangedDefense	+= m.DefenseBonus;
		}
	}
});
