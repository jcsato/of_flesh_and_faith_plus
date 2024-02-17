::mods_hookExactClass("ambitions/ambitions/sergeant_ambition", function(sa) {
	local onUpdateScore = ::mods_getMember(sa, "onUpdateScore");

	::mods_override(sa, "onUpdateScore", function() {
		if (World.Assets.getOrigin().getID() == "scenario.oathtakers")
			return;

		onUpdateScore();
	});
});
