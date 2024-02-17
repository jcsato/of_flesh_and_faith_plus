oath_of_redemption_active_effect <- inherit("scripts/skills/skill", {
	m = { }

	function create() {
		m.ID					= "effects.oath_of_redemption_active";
		m.Name					= "Oath of Redemption";
		m.Description			= "Most who choose to flee the Oathtakers find themselves in an early grave, whether by the hand of their former order or, just as often, of mere brigands. Those few that seek redemption are given a second chance only if they prove themselves in combat. A coward's courage is rarely enough to see one's foes slain, but the crucible of battle can turn survivors into heroes. Or so the saying goes.";
		m.Icon					= "skills/status_effect_plus_40.png";
		m.IconMini				= "";
		m.Overlay				= "status_effect_plus_40";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 10;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip(_withContainer = true) {
		local numKills = _withContainer ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.Redemption) : 0;

		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/morale.png", text = "Cannot be of Confident or Steady morale" }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "Uphold by personally slaying " + ::OFFP.Oathtakers.Quests.RedemptionFoesSlain + " foes (" + numKills + " so far)" }
		];

		return ret;
	}

	function getManagementScreenTooltip() {
		return getTooltip(false);
	}

	function onCombatStarted() {
		local actor = getContainer().getActor();

		if (actor.getMoodState() >= Const.MoodState.Disgruntled && actor.getMoraleState() > Const.MoraleState.Wavering)
			actor.setMoraleState(Const.MoraleState.Wavering);
	}
});
