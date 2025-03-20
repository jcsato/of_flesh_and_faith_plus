oath_of_dominion_active_effect <- inherit("scripts/skills/skill", {
	m = {
		ApplyEffect	= true
		SkillMalus	= 5
	}

	function create() {
		m.ID					= "effects.oath_of_dominion_active";
		m.Name					= "Oath of Dominion";
		m.Description			= "\"If man is to be more than beast, then beast he must slay. Distance yourself from nature's claws, within and without. Grip your humanity with your own two hands, judge if with your own eyes, challenge it with your own tongue, and yours it shall be proven.\"";
		m.Icon					= "ui/traits/trait_icon_79.png";
		m.IconMini				= "";
		m.Overlay				= "trait_icon_79";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 10;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip() {
		local numSlain = !(getContainer() == null) ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.DominionLegacy) : 0;
		local numUnholdsSlain = !(getContainer() == null) ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.DominionUnholds) : 0;
		local numHexenSlain = !(getContainer() == null) ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.DominionHexen) : 0;
		local numLindwurmsSlain = !(getContainer() == null) ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.DominionLindwurms) : 0;

		local objective = null;
		if (Const.DLC.Unhold)
			objective = "" + ::OFFP.Oathtakers.Quests.DominionUnholdsSlain + " Unholds (" + numUnholdsSlain + " so far), a Hexe (" + numHexenSlain + " so far), or a Lindwurm (" + numLindwurmsSlain + " so far)";
		else
			objective = "15 beasts (" + numSlain + " so far)";

		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/melee_skill.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.SkillMalus + "[/color] Melee Skill when fighting human opponents" }
			{ id = 11, type = "text", icon = "ui/icons/ranged_skill.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.SkillMalus + "[/color] Ranged Skill when fighting human opponents" }
			{ id = 12, type = "text", icon = "ui/icons/special.png", text = "Uphold by personally slaying " + objective }
		];

		return ret;
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

		local fightingHumans = false;
		local enemies = Tactical.Entities.getAllHostilesAsArray();

		foreach (enemy in enemies) {
			if (isBrigand(enemy.getType()) || isNomad(enemy.getType()) || isHumanBarbarian(enemy.getType()) || isHumanNoble(enemy.getType()) || isHumanGilded(enemy.getType()) || isVillager(enemy.getType()) || isUnaffiliatedHuman(enemy.getType())) {
				fightingHumans = true;
				break;
			}
		}

		if (fightingHumans) {
			_properties.MeleeSkill	 -= m.SkillMalus;
			_properties.RangedSkill	 -= m.SkillMalus;
		}
	}

	function isBrigand(enemyType) {
		return Const.EntityType.getDefaultFaction(enemyType) == Const.FactionType.Bandits;
	}

	function isNomad(enemyType) {
		return Const.EntityType.getDefaultFaction(enemyType) == Const.FactionType.OrientalBandits;
	}

	function isHumanBarbarian(enemyType) {
		return Const.EntityType.getDefaultFaction(enemyType) == Const.FactionType.Barbarians && !(enemyType == Const.EntityType.BarbarianUnhold || enemyType == Const.EntityType.BarbarianUnholdFrost);
	}

	function isHumanNoble(enemyType) {
		return Const.EntityType.getDefaultFaction(enemyType) == Const.FactionType.NobleHouse && !(enemyType == Const.EntityType.MilitaryDonkey)
	}

	function isHumanGilded(enemyType) {
		return Const.EntityType.getDefaultFaction(enemyType) == Const.FactionType.OrientalCityState && !(enemyType == Const.EntityType.Mortar)
	}

	function isVillager(enemyType) {
		Const.EntityType.getDefaultFaction(enemyType) == Const.FactionType.Settlement && !(enemyType == Const.EntityType.CaravanDonkey)
	}

	function isUnaffiliatedHuman(enemyType) {
		return enemyType == Const.EntityType.BountyHunter ||
				enemyType == Const.EntityType.Mercenary ||
				enemyType == Const.EntityType.MercenaryRanged ||
				enemyType == Const.EntityType.Swordmaster ||
				enemyType == Const.EntityType.HedgeKnight ||
				enemyType == Const.EntityType.MasterArcher ||
				enemyType == Const.EntityType.Cultist ||
				enemyType == Const.EntityType.Oathbringer;
	}
});
