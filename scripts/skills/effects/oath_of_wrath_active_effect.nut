oath_of_wrath_active_effect <- inherit("scripts/skills/skill", {
	m = {
		DefenseMalus	= 5
	}

	function create() {
		m.ID					= "effects.oath_of_wrath_active";
		m.Name					= "Oath of Wrath";
		m.Description			= "\"But the greatest wrath of all is to be reserved for evil in the guise of men, for what could be more vile than one who spurns his fellows amidst such hardship? Let neither tact nor caution slow your judgement.\"";
		m.Icon					= "ui/traits/trait_icon_80.png";
		m.IconMini				= "";
		m.Overlay				= "trait_icon_80";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 10;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip(_withContainer = true) {
		local numLeadersSlain = _withContainer ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.WrathLeaders) : 0;
		local numDestroyed = _withContainer ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.WrathLocations) : 0;

		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.DefenseMalus + "[/color] Melee Defense" }
			{ id = 11, type = "text", icon = "ui/icons/ranged_defense.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.DefenseMalus + "[/color] Ranged Defense" }
			{ id = 12, type = "text", icon = "ui/icons/special.png", text = "Uphold by destroying " + ::OFFP.Oathtakers.Quests.WrathLocationsDestroyed + " human outlaw locations, such as brigand or barbarian camps (" + numDestroyed + " so far), and personally slaying a Brigand Leader, Barbarian Chosen, or Nomad Leader (" + numLeadersSlain + " so far)" }
		];

		return ret;
	}

	function getManagementScreenTooltip() {
		return getTooltip(false);
	}

	function onUpdate( _properties ) {
		_properties.MeleeDefense	-= m.DefenseMalus;
		_properties.RangedDefense	-= m.DefenseMalus;
	}
});
