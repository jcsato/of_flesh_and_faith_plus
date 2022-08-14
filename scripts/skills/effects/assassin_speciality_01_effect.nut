assassin_speciality_01_effect <- inherit("scripts/skills/skill", {
	m =
	{
		DamageBoost			= 20
		MeleeDefenseBoost	= 5
		RangedDefenseBoost	= 10
	}

	function create() {
		m.ID			= "effects.assassin_speciality_01";
		m.Name			= "Mubarizun";
		m.Description	= "While the practice of sending skirmishers against each other before battle has fallen out of style in current military doctrine, generations of the practice has provided valuable lessons for the lone assassin to learn.";
		m.Icon			= "skills/status_effect_plus_13.png";
		m.IconMini		= "";
		m.Type			= Const.SkillType.StatusEffect;
		m.Order			= Const.SkillOrder.VeryLast - 2;
		m.IsActive		= false;
		m.IsStacking	= false;
	}

	function getTooltip() {
		return [
					{ id = 1, type = "title", text = getName() }
					{ id = 2, type = "description", text = getDescription() }
					{ id = 11, type = "text", icon = "ui/icons/regular_damage.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+20%[/color] Damage if engaged with a single enemy and there are no allies in adjacent tiles" }
					{ id = 12, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+5[/color] Melee Defense if there are no allies in adjacent tiles" }
					{ id = 13, type = "text", icon = "ui/icons/ranged_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+10[/color] Ranged Defense if there are no allies in adjacent tiles" }
					{ id = 17, type = "hint", icon = "ui/icons/special.png", text = "Unlocks the next row of perks" }
				];
	}

	function onUpdate(_properties) {
		if (!getContainer().getActor().isPlacedOnMap())
			return;

		local actor = getContainer().getActor();
		local myTile = actor.getTile();
		local numAlliesAdjacent = 0, numOpponentsAdjacent = 0;

		for( local i = 0; i < 6; i = ++i ) {
			if (!myTile.hasNextTile(i))
				continue;

			local tile = myTile.getNextTile(i);

			if (tile.IsOccupiedByActor && tile.getEntity().getMoraleState() != Const.MoraleState.Fleeing) {
				if (tile.getEntity().isAlliedWith(actor))
					numAlliesAdjacent = ++numAlliesAdjacent;
				else
					numOpponentsAdjacent = ++numOpponentsAdjacent;
			}
		}

		if (numAlliesAdjacent == 0) {
			_properties.MeleeDefense += m.MeleeDefenseBoost;
			_properties.RangedDefense += m.RangedDefenseBoost;
		}

		if (numOpponentsAdjacent == 1)
			_properties.DamageTotalMult	*= (1.0 + m.DamageBoost / 100.0);
	}
})
