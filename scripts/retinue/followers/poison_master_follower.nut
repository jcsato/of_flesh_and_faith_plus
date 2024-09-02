poison_master_follower <- inherit("scripts/retinue/follower", {
	m = { }

	function create() {
		follower.create();

		m.ID			= "follower.poison_master";
		m.Name			= "The Poison Master";
		m.Description	= "A former alchemist, the poison master can train others to concoct and apply a variety of dangerous substances - sometimes even without injury!";
		m.Image			= "ui/campfire/poison_master_02";
		m.Cost			= 0;
		m.Effects		= [
			"Your men learn a poison specialty at level 2 instead of gaining a perk point"
		];
		m.Requirements	= [ { IsSatisfied = false, Text = "You are a trusted assassin of the Southern guilds" } ];
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() },
			{ id = 4, type = "description", text = getDescription() }
		];

		foreach (i, e in m.Effects) {
			ret.push({ id = i, type = "text", icon = "ui/icons/special.png", text = e });
		}

		ret.push({ id = 1, type = "warning", icon = "ui/icons/warning.png", text = "Cannot be replaced" });
		return ret;
	}

	function isVisible() {
		return World.Assets.getOrigin().getID() == "scenario.southern_assassins";
	}

	function onUpdate() { }

	function onEvaluate() {
		m.Requirements[0].IsSatisfied = true;
	}
});
