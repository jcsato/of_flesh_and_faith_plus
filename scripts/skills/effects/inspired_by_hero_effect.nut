inspired_by_hero_effect <- inherit("scripts/skills/skill", {
	m = {
		ResolveBonus	= 5
	}

	function create() {
		m.ID			= "effects.inspired_by_hero";
		m.Name			= "Inspired";
		m.Description	= "Standing next to an indomitable Oathtaker who has fulfilled the Oath of Valor, this character feels their own courage bolstered.";
		m.Icon			= "skills/status_effect_plus_44.png";
		m.IconMini		= "status_effect_plus_44_mini";
		m.Type			= Const.SkillType.StatusEffect;
		m.Order			= Const.SkillOrder.VeryLast - 1;
		m.IsActive		= false;
		m.IsStacking	= false;
	}

	function getTooltip() {
		return [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.ResolveBonus + "[/color] Resolve" }
		];
	}

	function receivesBonus(_properties) {
		local actor = getContainer().getActor();

		if (!actor.isPlacedOnMap() || ("State" in Tactical && Tactical.State.isBattleEnded()))
			return 0;

		local myTile = actor.getTile();
		local allies = Tactical.Entities.getInstancesOfFaction(actor.getFaction());

		foreach (ally in allies) {
			if (ally.getID() == actor.getID() || !ally.isPlacedOnMap())
				continue;

			if (ally.getTile().getDistanceTo(myTile) > 1)
				continue;

			if (ally.getSkills().hasSkill("effects.oath_of_valor_completed") && !actor.getSkills().hasSkill("effects.oath_of_valor_completed"))
				return true;
		}

		return false;
	}

	function onUpdate(_properties) {
		m.IsHidden = true;
	}

	function onAfterUpdate(_properties) {
		local bonus = receivesBonus(_properties);

		if (bonus) {
			m.IsHidden = false;
			_properties.Bravery	+= m.ResolveBonus;
		} else {
			m.IsHidden = true;
		}
	}

	function onCombatFinished() {
		skill.onCombatFinished();

		m.IsHidden = true;
	}
});
