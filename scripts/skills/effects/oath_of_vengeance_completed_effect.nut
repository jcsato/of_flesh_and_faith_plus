oath_of_vengeance_completed_effect <- inherit("scripts/skills/skill", {
	m = {
		ApplyEffect				= true
		FatigueRecoveryBonus	= 2
		DefenseBonus			= 10
	}

	function create() {
		m.ID					= "effects.oath_of_vengeance_completed";
		m.Name					= "Oath of Vengeance";
		m.Description			= "\"The greenskin deserves naught but our purest hatred, but do not allow retribution to merely propel your strikes. Let it fuel your every motion, that it might lend quickness to your step and fullness to your being. No hail of arrows nor brutish blow can stop a warrior so empowered.\"";
		m.Icon					= "skills/status_effect_plus_36.png";
		m.IconMini				= "";
		m.Overlay				= "status_effect_plus_36";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 9;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip(_normalDescription = true) {
		local ret = [{ id = 1, type = "title", text = getName() }];

		if (_normalDescription)
			ret.push({ id = 2, type = "description", text = getDescription() });
		else
			ret.push({ id = 2, type = "description", text = "Upholding this Oath will grant the following effects:" });

		ret.extend([
			{ id = 10, type = "text", icon = "ui/icons/fatigue.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.FatigueRecoveryBonus + "[/color] Fatigue Recovery per turn when fighting greenskins" }
			{ id = 11, type = "text", icon = "ui/icons/ranged_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.DefenseBonus + "[/color] Ranged Defense when fighting greenskins" }
		]);

		return ret;
	}

	function getManagementScreenTooltip() {
		return getTooltip(false);
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

		local fightingGreenskins = false;
		local enemies = Tactical.Entities.getAllHostilesAsArray();

		foreach (enemy in enemies) {
			if (Const.EntityType.getDefaultFaction(enemy.getType()) == Const.FactionType.Orcs || Const.EntityType.getDefaultFaction(enemy.getType()) == Const.FactionType.Goblins) {
				fightingGreenskins = true;
				break;
			}
		}

		if (fightingGreenskins) {
			_properties.FatigueRecoveryRate	+= m.FatigueRecoveryBonus;
			_properties.RangedDefense		+= m.DefenseBonus;
		}
	}
});
