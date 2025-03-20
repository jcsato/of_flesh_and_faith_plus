oath_of_tithing_completed_effect <- inherit("scripts/skills/skill", {
	m = { }

	function create() {
		m.ID					= "effects.oath_of_tithing_completed";
		m.Name					= "Oath of Tithing";
		m.Description			= "Wherever you find yourself in the world, whether in the foulest dungeon or the finest castle, the highest peak or the smallest village, know this: no Oathtaker is alone.";
		m.Icon					= "skills/status_effect_plus_32.png";
		m.IconMini				= "";
		m.Overlay				= "status_effect_plus_32";
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
			{ id = 10, type = "text", icon = "ui/icons/asset_daily_money.png", text = "All brothers with the Oathtaker background are paid 10% fewer wages" }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "All Oathtaker recruits cost 1000 fewer crowns to hire, to a minimum of " + ::OFFP.Oathtakers.Boons.TithingRecruitMinimum }
		];

		return ret;
	}
});
