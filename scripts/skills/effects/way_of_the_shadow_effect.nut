way_of_the_shadow_effect <- inherit("scripts/skills/skill", {
	m = { }

	function create() {
		m.ID			= "effects.way_of_the_shadow";
		m.Name			= "Way of the Shadow";
		m.Description	= "The Gilder's gleam blesses all equally, yet not all are equally worthy - why fight whilst they benefit so undeservedly? The Way of the Shadow followers have embraced their arts outside His auspice, and they dominate the night like no other.";

		m.Icon			= "skills/status_effect_plus_47.png";
		m.Type			= Const.SkillType.StatusEffect | Const.SkillType.Perk;
		m.Order			= Const.SkillOrder.VeryLast - 1;

		m.IsActive		= false;
		m.IsStacking	= false;
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+15[/color] Resolve at night or while covered by smoke" }
			{ id = 12, type = "text", icon = "ui/icons/initiative.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+20[/color] Initiative at night or while covered by smoke" }
			{ id = 13, type = "text", icon = "ui/icons/vision.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+1[/color] Vision at night" }
			{ id = 14, type = "text", icon = "ui/icons/special.png", text = "Not affected by nighttime penalties" }
			{ id = 14, type = "text", icon = "ui/icons/special.png", text = "Not affected by the Ranged Skill penalty of smoke" }
		];

		return ret;
	}

	function onUpdate(_properties) {
		_properties.IsAffectedByNight	= false;

		if (!getContainer().getActor().isPlacedOnMap())
			return;

		if (getContainer().hasSkill("special.night"))
			getContainer().getSkillByID("special.night").m.IsHidden = true;

		local nighttime = (("State" in World) && World.State != null && !World.getTime().IsDaytime) ? true : false;

		if (nighttime || getContainer().hasSkill("effects.smoke")) {
			_properties.Bravery		+= 10;
			_properties.Initiative	+= 15;
		}

		if (nighttime)
			_properties.Vision		+= 1;
	}
});
