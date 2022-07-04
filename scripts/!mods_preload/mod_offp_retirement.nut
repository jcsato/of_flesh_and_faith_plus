::mods_hookExactClass("skills/backgrounds/assassin_background", function(ab) {
	local getGoodEnding = ::mods_getMember(ab, "getGoodEnding");
	local getBadEnding = ::mods_getMember(ab, "getBadEnding");

	::mods_override(ab, "getGoodEnding", function() {
		if (!Tactical.State.isScenarioMode() && World.Assets.getOrigin().getID() == "scenario.southern_assassins")
			return "%name% joined the company already skilled in the assassin arts, and for all the time you've spent around shadowy killers he still managed to unnerve you. Despite it all, he fought for the %companyname% through thick and thin, and fought well. Last you heard, the assassin departed the company and has not been seen or heard from since. To this day you're still not sure what his reasons were for joining up.";
		else
			return getGoodEnding();
	})

	::mods_override(ab, "getBadEnding", function() {
		if (!Tactical.State.isScenarioMode() && World.Assets.getOrigin().getID() == "scenario.southern_assassins")
			return "%name% joined the company already skilled in the assassin arts, and for all the time you've spent around shadowy killers he still managed to unnerve you. Despite it all, he fought for the %companyname% through thick and thin, and fought well. Last you heard, the assassin departed the company and has not been seen or heard from since. You have heard some disturbing reports, however, of some southern assassin guilds disappearing entirely, no corpses to be found, with only rumors of a hooded northerner in the area to tie the disappearances together.";
		else
			return getBadEnding();
	})
});
