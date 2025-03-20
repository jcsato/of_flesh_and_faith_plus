oath_of_righteousness_active_effect <- inherit("scripts/skills/skill", {
	m = {
		ApplyEffect	= false
		XPMalus		= 20
	}

	function create() {
		m.ID					= "effects.oath_of_righteousness_active";
		m.Name					= "Oath of Righteousness";
		m.Description			= "\"When confronted by the evil that has stolen into this realm, set aside your wordly matters. Dedicate yourself to the final rest of our dead, for no man deserves to walk twice across this darkened land.\"";
		m.Icon					= "ui/traits/trait_icon_78.png";
		m.IconMini				= "";
		m.Overlay				= "trait_icon_78";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 10;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip() {
		local numSlain = !(getContainer() == null) ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.Righteousness) : 0;
		local numLeadersSlain = !(getContainer() == null) ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.RighteousnessLeaders) : 0;

		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/xp_received.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.XPMalus + "%[/color] Experience Gain if not fighting undead" }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "Uphold by personally slaying " + ::OFFP.Oathtakers.Quests.RighteousnessUndeadSlain + " undead (" + numSlain + " so far) and a Necromancer, Geist, Necrosavant, or Ancient Priest (" + numLeadersSlain + " so far)" }
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

		if (!fightingUndead)
			_properties.XPGainMult	*= (1.0 - m.XPMalus / 100.0);
	}
});
