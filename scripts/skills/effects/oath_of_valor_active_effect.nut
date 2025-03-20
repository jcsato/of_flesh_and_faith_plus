oath_of_valor_active_effect <- inherit("scripts/skills/skill", {
	m = { }

	function create() {
		m.ID					= "effects.oath_of_valor_active";
		m.Name					= "Oath of Valor";
		m.Description			= "\"The first war is to be waged not on the fields of battle, but in the corridors of the heart. Forge your weapons of the steel found in that crucible, and never shall you taste true defeat.\"";
		m.Icon					= "ui/traits/trait_icon_83.png";
		m.IconMini				= "";
		m.Overlay				= "trait_icon_83";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 10;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip() {
		local numWon = !(getContainer() == null) ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.Valor) : 0;

		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/morale.png", text = "Cannot be of confident morale" }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "Uphold by taking part in " + ::OFFP.Oathtakers.Quests.ValorOutnumberedVictories + " victorious battles against foes that outnumber you (" + numWon + " so far)" }
		];

		return ret;
	}
});
