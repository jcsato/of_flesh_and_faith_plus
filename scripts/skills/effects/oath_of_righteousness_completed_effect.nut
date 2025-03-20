oath_of_righteousness_completed_effect <- inherit("scripts/skills/skill", {
	m = {
		ApplyEffect	= true
		DamageBonus	= 10
		SkillBonus	= 5
	}

	function create() {
		m.ID					= "effects.oath_of_righteousness_completed";
		m.Name					= "Oath of Righteousness";
		m.Description			= "\"Do not let the horror of the risen dead turn you from inquiries of who has come before and who shall come after. Seek out these anomalies and see them smote, and in so doing see the riddles of past and future alike secured once more.\"";
		m.Icon					= "skills/status_effect_plus_33.png";
		m.IconMini				= "";
		m.Overlay				= "status_effect_plus_33";
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
			{ id = 10, type = "text", icon = "ui/icons/regular_damage.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.DamageBonus + "%[/color] damage when fighting undead" }
			{ id = 11, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.SkillBonus + "[/color] Melee Defense when fighting undead" }
			{ id = 12, type = "text", icon = "ui/icons/special.png", text = "All kills are fatalities (if the weapon allows) when fighting undead" }
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

		local fightingUndead = false;
		local enemies = Tactical.Entities.getAllHostilesAsArray();

		foreach (enemy in enemies) {
			if (Const.EntityType.getDefaultFaction(enemy.getType()) == Const.FactionType.Zombies || Const.EntityType.getDefaultFaction(enemy.getType()) == Const.FactionType.Undead) {
				fightingUndead = true;
				break;
			}
		}

		if (fightingUndead) {
			_properties.DamageTotalMult	*= (1.0 + (m.DamageBonus / 100.0));
			_properties.MeleeDefense	 += m.SkillBonus;
			_properties.FatalityChanceMult	= 1000.0;
		}
	}
});
