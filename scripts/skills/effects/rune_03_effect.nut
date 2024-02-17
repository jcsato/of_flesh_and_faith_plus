rune_03_effect <- inherit("scripts/skills/skill", {
	m = {
		SkillBuff	= 4
		DefenseBuff	= 2
	}

	function create() {
		m.ID					= "effects.rune_03";
		m.Name					= "Rune of the Warrior King";
		m.Icon					= "skills/status_effect_plus_03.png";
		m.IconMini				= "status_effect_plus_03_mini";
		m.Overlay				= "status_effect_plus_03";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Trait - 8;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getDescription() {
		return "\"Only under the weight of thine own crown can thee know the true freedom of thine servitude. Stand as a king among men, that thee might prove worthy as mine vassal.\"";
	}

	function getTooltip() {
		local numWeaponMasteries = getNumMasteries(getContainer().getActor().getCurrentProperties());

		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 15, type = "text", icon = "ui/icons/special.png", text = "Gain [color=" + Const.UI.Color.PositiveValue + "]+4[/color] Skill and [color=" + Const.UI.Color.PositiveValue + "]+2[/color] Defense for each weapon mastery" }
		];

		if (numWeaponMasteries > 0) {
			ret.extend([
				{ id = 16, type = "text", icon = "ui/icons/melee_skill.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + numWeaponMasteries * m.SkillBuff + "[/color] Melee Skill" }
				{ id = 17, type = "text", icon = "ui/icons/ranged_skill.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + numWeaponMasteries * m.SkillBuff + "[/color] Ranged Skill" }
				{ id = 18, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + numWeaponMasteries * m.DefenseBuff + "[/color] Melee Defense" }
				{ id = 19, type = "text", icon = "ui/icons/ranged_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + numWeaponMasteries * m.DefenseBuff + "[/color] Ranged Defense" }
			]);
		}

		return ret;
	}

	function onAfterUpdate(_properties) {
		local numWeaponMasteries = getNumMasteries(_properties);

		_properties.MeleeSkill		+= numWeaponMasteries * m.SkillBuff;
		_properties.RangedSkill		+= numWeaponMasteries * m.SkillBuff;
		_properties.MeleeDefense	+= numWeaponMasteries * m.DefenseBuff;
		_properties.RangedDefense	+= numWeaponMasteries * m.DefenseBuff;
	}

	function getNumMasteries(_properties) {
		local numWeaponMasteries = 0;

		if (_properties.IsSpecializedInBows)
			numWeaponMasteries++;
		if (_properties.IsSpecializedInCrossbows)
			numWeaponMasteries++;
		if (_properties.IsSpecializedInThrowing)
			numWeaponMasteries++;
		if (_properties.IsSpecializedInSwords)
			numWeaponMasteries++;
		if (_properties.IsSpecializedInCleavers)
			numWeaponMasteries++;
		if (_properties.IsSpecializedInMaces)
			numWeaponMasteries++;
		if (_properties.IsSpecializedInHammers)
			numWeaponMasteries++;
		if (_properties.IsSpecializedInAxes)
			numWeaponMasteries++;
		if (_properties.IsSpecializedInFlails)
			numWeaponMasteries++;
		if (_properties.IsSpecializedInSpears)
			numWeaponMasteries++;
		if (_properties.IsSpecializedInPolearms)
			numWeaponMasteries++;
		if (_properties.IsSpecializedInDaggers)
			numWeaponMasteries++;
		if (_properties.IsSpecializedInShields)
			numWeaponMasteries++;

		return numWeaponMasteries;
	}
});
