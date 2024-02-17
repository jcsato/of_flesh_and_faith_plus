oath_of_honor_active_effect <- inherit("scripts/skills/skill", {
	m = { }

	function create() {
		m.ID					= "effects.oath_of_honor_active";
		m.Name					= "Oath of Honor";
		m.Description			= "\"Go unto the melee and content yourself with the battles that lie within arm's reach. A truly skilled warrior knows he need not concern himself with the craven far afield.\"";
		m.Icon					= "ui/traits/trait_icon_82.png";
		m.IconMini				= "";
		m.Overlay				= "trait_icon_82";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 10;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip(_withContainer = true) {
		local numRetreats = _withContainer ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.Honor) : 0;

		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/special.png", text = "Uphold by allowing enemies to flee without running them down " + ::OFFP.Oathtakers.Quests.HonorRetreatsAllowed + " times (" + numRetreats + " so far)" }
			{ id = 11, type = "hint", icon = "ui/icons/warning.png", text = "Cannot use ranged attacks or tools" }
		];

		return ret;
	}

	function getManagementScreenTooltip() {
		return getTooltip(false);
	}
});
