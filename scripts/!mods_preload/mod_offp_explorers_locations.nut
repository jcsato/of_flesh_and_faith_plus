::mods_hookChildren("entity/world/location", function(l) {
	// Doing this tree traversal, rather than using ::mods_getMember, is required as not all children define these functions
	while(!("onEnter" in l)) l = l[l.SuperName];
	while(!("onCombatLost" in l)) l = l[l.SuperName];
	while(!("onDiscovered" in l)) l = l[l.SuperName];
	while(!("setVisited" in l)) l = l[l.SuperName];
	local onEnter = l.onEnter;
	local onCombatLost = l.onCombatLost;
	local onDiscovered = l.onDiscovered;
	local setVisited = l.setVisited;

	l.onDiscovered = function() {
		if (World.Assets.getOrigin() != null && World.Assets.getOrigin().getID() == "scenario.explorers" && !isHiddenToPlayer()) {
			if (getTypeID() != "location.battlefield" && !isKindOf(this, "settlement")) {
				local brothers = World.getPlayerRoster().getAll();
				foreach( bro in brothers ) {
					bro.m.XP += 50;
					bro.updateLevel();
				}
			}
		}

		onDiscovered();
	}

	l.onEnter = function() {
		if (World.Assets.getOrigin() != null && World.Assets.getOrigin().getID() == "scenario.explorers" && isLocationType(Const.World.LocationType.Unique)) {
			if (getTypeID() == "location.ancient_statue" || getTypeID() == "location.ancient_temple" || getTypeID() == "location.ancient_watchtower" || getTypeID() == "location.land_ship" || getTypeID() == "location.holy_site.meteorite" || getTypeID() == "location.holy_site.oracle" || getTypeID() == "location.unhold_graveyard" || getTypeID() == "location.holy_site.vulcano")
			{
				local brothers = World.getPlayerRoster().getAll();
				foreach( bro in brothers ) {
					bro.getFlags().increment("CursedExplorersLegendaryLocations");
				}
			}
		}

		return onEnter();
	}

	l.onCombatLost = function() {
		if (World.Assets.getOrigin() != null && World.Assets.getOrigin().getID() == "scenario.explorers" && isLocationType(Const.World.LocationType.Unique)) {
			// Might have issues with icy cave and sunken library, as those don't have an onDestroyed they explicitly want called. . .we'll see
			if (getTypeID() == "location.black_monolith" || getTypeID() == "location.icy_cave_location" || getTypeID() == "location.sunken_library" || getTypeID() == "location.goblin_city" || getTypeID() == "location.waterwheel" || getTypeID() == "location.witch_hut")
			{
				local brothers = World.getPlayerRoster().getAll();
				foreach( bro in brothers ) {
					bro.getFlags().increment("CursedExplorersLegendaryLocations");
				}
			}
		}

		return onCombatLost();
	}

	l.setVisited = function(_f) {
		setVisited(_f);

		if (World.Assets.getOrigin() != null && World.Assets.getOrigin().getID() != "scenario.explorers")
			return;

		if (!isLocationType(Const.World.LocationType.Unique))
			return;

		if (_f)
			return;

		if (getTypeID() == "location.ancient_statue" || getTypeID() == "location.ancient_temple" || getTypeID() == "location.ancient_watchtower" || getTypeID() == "location.land_ship" || getTypeID() == "location.holy_site.meteorite" || getTypeID() == "location.holy_site.oracle" || getTypeID() == "location.unhold_graveyard" || getTypeID() == "location.holy_site.vulcano")
		{
			local brothers = World.getPlayerRoster().getAll();
			foreach( bro in brothers ) {
				bro.getFlags().increment("CursedExplorersLegendaryLocations", -1);
			}
		}
	}
});
