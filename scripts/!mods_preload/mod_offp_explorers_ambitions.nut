::mods_hookNewObject("ambitions/ambitions/discover_locations_ambition", function(dla) {
	local onUpdateScore = dla.onUpdateScore;

    dla.onUpdateScore = function() {
		if (World.Assets.getOrigin().getID() != "scenario.explorers") {
			onUpdateScore();
			return;
		}

		local locations = World.EntityManager.getLocations();
		local numDiscovered = 0;

		foreach( v in locations )
		{
			if (v.isDiscovered())
				numDiscovered = ++numDiscovered;
		}

		if (numDiscovered + 12 >= locations.len())
			return;

		m.Score = 1 + Math.rand(0, 5);
    }
}, false);

::mods_hookNewObject("ambitions/ambitions/find_and_destroy_location_ambition", function(fadla) {
	local onUpdateScore = fadla.onUpdateScore;

    fadla.onUpdateScore = function() {
		if (World.Assets.getOrigin().getID() != "scenario.explorers") {
			onUpdateScore();
			return;
		}

		if (World.Statistics.getFlags().getAsInt("LastLocationDestroyedFaction") != 0 && World.Statistics.getFlags().get("LastLocationDestroyedForContract") == false)
			return;

		if (World.Ambitions.getDone() < 1)
			return;

		m.Score = 1 + Math.rand(0, 5);
    }
}, false);
