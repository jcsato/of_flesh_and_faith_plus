oath_of_vengeance_active_effect <- inherit("scripts/skills/skill", {
	m = {
		ApplyEffect		= true
		ResolveMalus	= 10
	}

	function create() {
		m.ID					= "effects.oath_of_vengeance_active";
		m.Name					= "Oath of Vengeance";
		m.Description			= "Young Anselm's family was killed by orcs. It is said that the first Oathtaker would sometimes lose himself to single-minded fury and spend days or even weeks venturing the lands to lay low the greenskin menace.";
		m.Icon					= "ui/traits/trait_icon_77.png";
		m.IconMini				= "";
		m.Overlay				= "trait_icon_77";
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Perk + 10;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getTooltip(_withContainer = true) {
		local numSlain = _withContainer ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.Vengeance) : 0;
		local numLeadersSlain = _withContainer ? getContainer().getActor().getFlags().getAsInt(::OFFP.Oathtakers.Flags.VengeanceLeaders) : 0;

		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.ResolveMalus + "[/color] Resolve if not fighting greenskins" }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "Uphold by helping the company fell " + ::OFFP.Oathtakers.Quests.VengeanceCompanyGreenskinsSlain + " goblins or orcs (" + numSlain + " so far), and personally slaying an Orc Warlord, Goblin Overseer, or Goblin Shaman (" + numLeadersSlain + " so far)" }
		];

		return ret;
	}

	function getManagementScreenTooltip() {
		return getTooltip(false);
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

		local fightingGreenskins = false;
		local enemies = Tactical.Entities.getAllHostilesAsArray();

		foreach (enemy in enemies) {
			if (Const.EntityType.getDefaultFaction(enemy.getType()) == Const.FactionType.Orcs || Const.EntityType.getDefaultFaction(enemy.getType()) == Const.FactionType.Goblins) {
				fightingGreenskins = true;
				break;
			}
		}

		if (!fightingGreenskins)
			_properties.Bravery -= m.ResolveMalus;
	}
});
