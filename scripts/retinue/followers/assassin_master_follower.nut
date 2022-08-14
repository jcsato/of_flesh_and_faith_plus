assassin_master_follower <- inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		follower.create();
		m.ID = "follower.assassin_master";
		m.Name = "The Grandmaster";
		m.Description = "The Grandmaster is an expert in the combat arts of the Southern guilds. While it would take most a lifetime to match his skill, there is still much to learn from him.";
		m.Image = "ui/campfire/assassin_master_01";
		m.Cost = 0;
		m.Effects = [
			"Your men learn an assassin specialty at level 5 instead of gaining a perk point",
			"Your men adopt an assassination philosophy at level 8 instead of gaining a perk point"
		];
		m.Requirements = [ { IsSatisfied = false, Text = "You are a trusted assassin of the Southern guilds" } ];
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = getName() },
			{ id = 4, type = "description", text = getDescription() }
		];

		foreach( i, e in m.Effects )
		{
			ret.push({ id = i, type = "text", icon = "ui/icons/special.png", text = e });
		}

		ret.push({ id = 1, type = "warning", icon = "ui/icons/warning.png", text = "Cannot be replaced" });
		return ret;
	}

	function isVisible()
	{
		return World.Assets.getOrigin().getID() == "scenario.southern_assassins";
	}

	function onUpdate()
	{
	}

	function onEvaluate()
	{
		m.Requirements[0].IsSatisfied = true;
	}

});

