oath_of_tithing_active_effect <- inherit("scripts/skills/skill", {
	m = {
		TithePercent	= 10
	}

	function create() {
		m.ID					= "effects.oath_of_tithing_active";
		m.Name					= "Oath of Tithing";
		m.Description			= "\"...and three tenths to the smith, that metal may be mended. But hold in reserve the final tenth for the order itself, for we are nothing without the lend of our brothers.\"";
		m.Icon					= "ui/traits/trait_icon_81.png";
		m.IconMini				= "";
		m.Overlay				= "trait_icon_81";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 10;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip(_withContainer = true) {
		local numLevied = _withContainer ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.Tithing) : 0;

		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/asset_daily_money.png", text = "Takes [color=" + Const.UI.Color.NegativeValue + "]" + m.TithePercent + "%[/color] of all crowns looted or earned from contracts" }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "Uphold by tithing at least 500 crowns total (" + numLevied + " so far)" }
		];

		return ret;
	}

	function getManagementScreenTooltip() {
		return getTooltip(false);
	}
});
