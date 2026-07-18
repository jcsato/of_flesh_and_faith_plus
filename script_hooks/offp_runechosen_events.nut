::mods_hookExactClass("events/events/oldguard_becomes_drunkard_event", function(obde) {
	local onUpdateScore = ::mods_getMember(obde, "onUpdateScore");

	::mods_override(obde, "onUpdateScore", function() {
		if (World.Assets.getOrigin().getID() == "scenario.runeknights")
			return;

		onUpdateScore();
	});
});
