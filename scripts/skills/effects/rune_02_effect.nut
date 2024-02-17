rune_02_effect <- inherit("scripts/skills/skill", {
	m = {
		HealingApplied = false
	}

	function create() {
		m.ID					= "effects.rune_02";
		m.Name					= "Unpassage Rune";
		m.Icon					= "skills/status_effect_plus_02.png";
		m.IconMini				= "status_effect_plus_02_mini";
		m.Overlay				= "status_effect_plus_02";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Trait - 9;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getDescription() {
		return "\"Mine duty lies not with the Deathmonger. It is not the end of mine chosen that please me, but the manner in which that end is met. Tend thine wounds, that thee might earn deeper ones.\"";
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/days_wounded.png", text = "Injuries heal [color=" + Const.UI.Color.PositiveValue + "]1[/color] day faster" }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "Recovers [color=" + Const.UI.Color.PositiveValue + "]10[/color] Hitpoints after each battle" }
		];

		return ret;
	}

	function onCombatStarted() {
		m.HealingApplied = false;
	}

	function onCombatFinished() {
		local actor = getContainer().getActor();

		if (actor != null && !actor.isNull() && actor.isAlive() && !m.HealingApplied) {
			actor.setHitpoints(Math.min(actor.getHitpoints() + 10, actor.getHitpointsMax()));
			actor.setDirty(true);
			m.HealingApplied = true;
		}
	}
});
