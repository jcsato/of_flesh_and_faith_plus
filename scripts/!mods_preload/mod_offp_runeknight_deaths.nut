::mods_hookNewObject("entity/tactical/player", function(p) {
	local isReallyKilled = p.isReallyKilled;
	p.isReallyKilled = function( _fatalityType ) {
		if (!Tactical.State.isScenarioMode() && World.Assets.getOrigin().getID() == "scenario.runeknights")
			return true;

		return isReallyKilled( _fatalityType );
	}
});
