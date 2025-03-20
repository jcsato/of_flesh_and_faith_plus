oath_of_distinction_completed_effect <- inherit("scripts/skills/skill", {
	m = {
		InitiativeBonus	= 10
		ResolveBonus	= 10
		XPBonus			= 10
	}

	function create() {
		m.ID					= "effects.oath_of_distinction_completed";
		m.Name					= "Oath of Distinction";
		m.Description			= "This character has felled many enemy champions and now sees the battlefield differently. Being parted from one's battle line is not a cause for fear, but for celebration, for what better way to prove the worth of a deed than to do it without aid?";
		m.Icon					= "skills/status_effect_plus_27.png";
		m.IconMini				= "";
		m.Overlay				= "status_effect_plus_27";
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
			{ id = 11, type = "text", icon = "ui/icons/initiative.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.InitiativeBonus + "[/color] Initiative if there are no allies in adjacent tiles" }
			{ id = 11, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.ResolveBonus + "[/color] Resolve if there are no allies in adjacent tiles" }
			{ id = 12, type = "text", icon = "ui/icons/xp_received.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + m.XPBonus + "%[/color] Experience Gain if there are no allies in adjacent tiles" }
		];

		return ret;
	}

	function onUpdate(_properties) {
		local actor = getContainer().getActor();
		if (!actor.isPlacedOnMap())
			return;

		local myTile = actor.getTile();
		local allies = Tactical.Entities.getInstancesOfFaction(actor.getFaction());
		local isAlone = true;

		foreach (ally in allies) {
			if (ally.getID() == actor.getID() || !ally.isPlacedOnMap())
				continue;

			if (ally.getTile().getDistanceTo(myTile) <= 1) {
				isAlone = false;
				break;
			}
		}

		if (isAlone) {
			_properties.Initiative	+= m.InitiativeBonus;
			_properties.Bravery		+= m.ResolveBonus;
			_properties.XPGainMult	*= (1.0 + m.XPBonus / 100.0);
		}
	}
});
