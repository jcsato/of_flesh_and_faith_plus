oath_of_distinction_active_effect <- inherit("scripts/skills/skill", {
	m = {
		DamageMalus	= 10
		SkillMalus	= 5
	}

	function create() {
		m.ID					= "effects.oath_of_distinction_active";
		m.Name					= "Oath of Distinction";
		m.Description			= "\"It is oft in solitude that one's true foes are revealed. Seek isolation, that you might then seek victory.\"";
		m.Icon					= "ui/traits/trait_icon_88.png";
		m.IconMini				= "";
		m.Overlay				= "trait_icon_88";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 10;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip(_withContainer = true) {
		local numSlain = _withContainer ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.Distinction) : 0;

		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/regular_damage.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.DamageMalus + "%[/color] damage if there are allies in adjacent tiles" }
			{ id = 12, type = "text", icon = "ui/icons/melee_skill.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.SkillMalus + "[/color] Melee Skill if there are allies in adjacent tiles" }
			{ id = 13, type = "text", icon = "ui/icons/ranged_skill.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.SkillMalus + "[/color] Ranged Skill if there are allies in adjacent tiles" }
			{ id = 14, type = "text", icon = "ui/icons/special.png", text = "Uphold by slaying " + ::OFFP.Oathtakers.Quests.DistinctionSlain + " enemy champions or leaders that inspire (" + numSlain + " so far)" }
		];

		return ret;
	}

	function getManagementScreenTooltip() {
		return getTooltip(false);
	}

	function onUpdate(_properties) {
		local actor = getContainer().getActor();
		if (!actor.isPlacedOnMap())
			return;

		local myTile = actor.getTile();
		local allies = Tactical.Entities.getInstancesOfFaction(actor.getFaction());
		local isAlone = true;

		foreach( ally in allies ) {
			if (ally.getID() == actor.getID() || !ally.isPlacedOnMap())
				continue;

			if (ally.getTile().getDistanceTo(myTile) <= 1) {
				isAlone = false;
				break;
			}
		}

		if (!isAlone) {
			_properties.DamageTotalMult	*= (1.0 - m.DamageMalus / 100.0);
			_properties.MeleeSkill		-= m.SkillMalus;
			_properties.RangedSkill		-= m.SkillMalus;
		}
	}
});
