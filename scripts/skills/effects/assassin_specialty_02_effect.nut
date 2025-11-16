assassin_specialty_02_effect <- inherit("scripts/skills/skill", {
	m = {
		PrimaryStatBoost	= 4
		SecondaryStatBoost	= 8
		ApplyEffect			= true
	}

	function create() {
		m.ID			= "effects.assassin_specialty_02";
		m.Name			= "Challenger";
		m.Description	= "Bring them on! Assassins often find themselves outnumbered, but rather than being daunted this character relishes the challenge, focusing even harder than normal.";
		m.Icon			= "skills/status_effect_plus_14.png";
		m.IconMini		= "";
		m.Type			= Const.SkillType.StatusEffect | Const.SkillType.Perk;
		m.Order			= Const.SkillOrder.Any - 2;
		m.IsActive		= false;
		m.IsStacking	= false;
	}

	function getTooltip() {
		return [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.SecondaryStatBoost + "[/color] Resolve" }
			{ id = 11, type = "text", icon = "ui/icons/initiative.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.SecondaryStatBoost + "[/color] Initiative" }
			{ id = 12, type = "text", icon = "ui/icons/melee_skill.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.PrimaryStatBoost + "[/color] Melee Skill" }
			{ id = 13, type = "text", icon = "ui/icons/ranged_skill.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.PrimaryStatBoost + "[/color] Ranged Skill" }
			{ id = 14, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.PrimaryStatBoost + "[/color] Melee Defense" }
			{ id = 15, type = "text", icon = "ui/icons/ranged_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.PrimaryStatBoost + "[/color] Ranged Defense" }
			{ id = 16, type = "text", icon = "ui/icons/special.png", text = "Only active when outnumbered by the enemy" }
			{ id = 17, type = "hint", icon = "ui/icons/special.png", text = "Unlocks the next row of perks" }
		];
	}

	function onCombatStarted() {
		m.ApplyEffect = true;
	}

	function onCombatFinished() {
		m.ApplyEffect = false;
	}

	function onUpdate(_properties) {
		if (!m.ApplyEffect)
			return;

		if (!getContainer().getActor().isPlacedOnMap())
			return;

		local all = Tactical.Entities.getAllInstances();
		local numAllies = 0, numEnemies = 0;
		foreach (faction in all) {
			foreach (entity in faction) {
				if (!entity.isAlive() || !entity.isPlacedOnMap() || entity.isDying())
					continue;

				if (entity.isAlliedWith(getContainer().getActor().getFaction()))
					numAllies++;
				else
					numEnemies++;
			}
		}

		if (numAllies < numEnemies) {
			_properties.Bravery				+= m.SecondaryStatBoost;
			_properties.Initiative			+= m.SecondaryStatBoost;
			_properties.MeleeSkill			+= m.PrimaryStatBoost;
			_properties.RangedSkill			+= m.PrimaryStatBoost;
			_properties.MeleeDefense		+= m.PrimaryStatBoost;
			_properties.RangedDefense		+= m.PrimaryStatBoost;
		}
	}
});
